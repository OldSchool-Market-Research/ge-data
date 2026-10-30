# ge-data: Database Setup

How the timeseries DB is built and run. See [`GOAL.md`](./GOAL.md) for *what*
we're collecting; this file covers the schema and the container.

## Why TimescaleDB

TimescaleDB is a PostgreSQL *extension* — same server, same SQL, same drivers.
We use it for two things on append-only, time-ordered, grows-forever data:

1. **Hypertables** — automatic time-based partitioning into "chunks", so inserts
   stay fast and range queries skip irrelevant time.
2. **Columnar compression** — old chunks get compressed hard (OSRS price rows
   are tiny and repetitive, the ideal case). This is the reason to use Timescale.

We run pg16 with the `timescaledb` extension preloaded — locally via the nix dev
shell, in production via eldo's NixOS `services.postgresql` (see
[`INFRA.md`](./INFRA.md)).

## Schema (`init/01_schema.sql`)

A static `items` lookup plus two hypertables, one per poll. The hypertables are
keyed `(ts, item_id)` and compressed (segment by `item_id`, order by `ts`) after
7 days.

- **`items`** — from `/mapping`, one typed column per field: `item_id` (the
  mapping's `id`), `name`, `examine`, `members`, `value`, `lowalch`, `highalch`,
  `buy_limit` (the mapping's `limit`), `icon`. Plain table, not a hypertable. No
  foreign key from the price tables, so a price can reference an item before
  `/mapping` is loaded. The whole feed is ~4.5k items / ~830 KB — one cheap GET.

  **Refresh:** upsert on startup, then again every ~24h while running. Always
  `INSERT ... ON CONFLICT (item_id) DO UPDATE` — never truncate-and-reload (that
  leaves a window where `items` is empty, and a failed fetch would nuke the table
  for nothing). New items land with game updates (~weekly), so a long-running
  poller needs the daily refresh, not just the startup load — but if the new item
  isn't in `items` yet it's harmless: prices still record under its `item_id`,
  it just has no name until the next refresh.

- **`prices_5m`** — from `/5m`. `avg_high_price`, `avg_low_price` (nullable),
  `high_volume`, `low_volume`. 1-month chunks.
- **`prices_1m`** — from `/latest`. `high`, `high_time`, `low`, `low_time`. No
  volume. Nullable prices. 1-week chunks (1m data is ~5× denser).

Write semantics:

- **5m** → `INSERT ... ON CONFLICT (ts, item_id) DO UPDATE`. The current block
  keeps settling while you poll it, so the row converges to the final average.
- **1m** → dedup on change: only insert when `high_time`/`low_time` advanced.

Prices store `item_id` only; join `items` when you want names.

## item_relations (`init/02_item_relations.sql` + `03_item_relations_seed.sql`)

A small hand-curated table of mechanical conversions between tradeable items —
potion decants (4↔3 dose), GE-clerk armour sets, and combine recipes. It backs
the conversion-arbitrage tooling in ge-mcp (`list_relations` / `combo_quote`):
these are the only places where two GE prices are mechanically linked, so
sum-of-parts gaps are direction-neutral edges.

It is **not ingested at runtime**. Curation happens by hand: item IDs come from
the OSRS Wiki `/mapping` feed (the same source as `items`), and the seed is
re-runnable (`ON CONFLICT (name) DO UPDATE`). Skill/quest gates and NPC fees
live in `notes`; leg names and buy limits are joined from `items` at query time
so they cannot drift.

**Apply to prod** (manual, on eldo, **as the `ge-data` role** — the
default-privilege rules in the ge-mcp / ge-orchestrator grants files attach
SELECT automatically only when `ge-data` creates the table):

```bash
PGPASSWORD=... psql -h 127.0.0.1 -p 5432 -U ge-data -d ge-data \
  -f init/02_item_relations.sql -f init/03_item_relations_seed.sql
```

**Sanity check after (re)seeding** — every leg must resolve to a real item; any
row returned here is a curation bug (wrong ID silently prices the wrong item):

```sql
SELECT r.name, (l->>'item_id')::int AS missing_item_id
FROM item_relations r,
     LATERAL jsonb_array_elements(r.inputs || r.outputs) AS l
WHERE NOT EXISTS (
  SELECT 1 FROM items i WHERE i.item_id = (l->>'item_id')::int
);
```

### Recipe families (`init/07_item_relation_families.sql`)

`item_relations.family` is a recipe's sub-type, finer than `kind`: `kind` says how
a conversion works, `family` says what market it trades in. Reporting and
calibration read it; a recipe's mechanics still come from `kind`. Curated by exact
name, re-runnable, and a recipe added later stays NULL until it is listed there.
Apply it as the `ge-data` role before deploying a ge-mcp or orchestrator that reads
the column:

```bash
PGPASSWORD=... psql -h 127.0.0.1 -p 5432 -U ge-data -d ge-data -v ON_ERROR_STOP=1 \
  -f init/07_item_relation_families.sql
```

## process_recipes (`init/04_process_recipes.sql` + `05_process_recipes_seed.sql`)

Processing money-makers: conversions that cost player time (planks, keels,
fish crates, unfinished potions), ranked by gp/hr, not one-off margin.
Separate from `item_relations` because quantities can be fractional (expected
yields such as 0.7875 potions per action) and every `item_relations` consumer
casts qty to `bigint`. Each row adds a per-action `fee_gp`, `actions_per_hour`
and a `throughput` kind (`fixed` / `volume_capped` / `volume_bound` /
`unknown`). A recipe that already exists in `item_relations` links to it via
`relation_name` + `relation_direction` and does not repeat its legs.

The seed is **generated** from a friend's "Processing Flips" Google Sheet by
`tools/process-import/import.py` (see its README). Each row's parsed legs first
reproduce the sheet's own cached profit/action, then get corrected where the
sheet disagrees with the game (chained intermediates cancelled, Wiki-checked
spell costs and yields, NPC/buy-limit "rates" made volume-bound); each
correction is written into the row's `notes`. The seed is one transaction and
deletes importer rows (`source` 'Main!...') it no longer generates. Skill/quest
requirements are not curated for these rows yet.

**Apply to prod** after 02+03, as the `ge-data` role:

```bash
PGPASSWORD=... psql -h 127.0.0.1 -p 5432 -U ge-data -d ge-data \
  -f init/04_process_recipes.sql -f init/05_process_recipes_seed.sql
```

**Sanity check after (re)seeding.** Same rule as above: any row returned is a
curation bug.

```sql
SELECT p.name, (l->>'item_id')::int AS missing_item_id
FROM process_recipes p,
     LATERAL jsonb_array_elements(coalesce(p.inputs, '[]') || coalesce(p.outputs, '[]')) AS l
WHERE NOT EXISTS (
  SELECT 1 FROM items i WHERE i.item_id = (l->>'item_id')::int
);

-- a reverse link must point at a reversible relation
SELECT p.name FROM process_recipes p JOIN item_relations r ON r.name = p.relation_name
WHERE p.relation_direction = 'reverse' AND NOT r.reversible;
```

## process_quotes (`init/06_process_quotes.sql`)

The single home of the processing math, so ge-mcp, the orchestrator API and
the ingester can't drift apart:

- `process_legs_now` (view): every recipe leg with its latest `prices_1m` quote,
  trailing-24h `prices_5m` volume, and the item's `/mapping` icon file (display only). Linked recipes resolve their legs through
  `item_relations`.
- `process_quotes_now` (view): per recipe, slow margin (buy at low, sell at
  high minus tax) and insta margin (the reverse), the real GE tax (sale/50,
  5M cap), and gp/hr at an effective rate = LEAST(player actions/hr, buy-limit
  rate, market-volume rate), with the market rate taken from the side each
  order type fills against (separately for slow and insta). Every throughput
  kind is capped by the buy limit and the market; `throughput` only records
  where the player-speed figure came from. A margin is NULL when a leg has no
  price or a malformed qty; `unknown_limit_legs` counts buy legs whose limit is
  unknown (the limit cap skips them, so it's optimistic). `icon` is the main
  output's icon file, for display.
- `process_snapshots` (hypertable): the ingester's hourly (hh:05) copy of
  `process_quotes_now`, keyed `(ts = the hour, recipe_id)`, with the recipe
  name. No FK to `process_recipes`, so history outlives a recipe the seed
  deletes or renames. History for trend and top-performer queries.

**Apply to prod** after 04+05, as `ge-data` (re-runnable):

```bash
PGPASSWORD=... psql -h 127.0.0.1 -p 5432 -U ge-data -d ge-data -f init/06_process_quotes.sql
```

Until it's applied, the ingester's hourly snapshot logs an error and retries
the next hour; the price polls are unaffected.

## Running the DB locally (nix dev shell)

Local dev runs a real Postgres from the nix shell — no container. `default.nix`
provides a `pg16 + timescaledb` server plus two scripts: `db_reset` (one-shot
prepare) and `__pg` (serve). PGDATA is `.db/`, port **5433** (set by the shell
hook). **Production runs on eldo**, not here — see [`INFRA.md`](./INFRA.md).

```bash
# 1. create .env with a password (see .env.example)
# 2. enter the shell (exports PGDATA=.db, PGPORT=5433)
nix-shell   # or via direnv (.envrc)

# 3. wipe + bootstrap + load init/01_schema.sql (DESTROYS DATA in .db/)
db_reset

# 4. serve
__pg

# 5. connect from another shell
psql "postgresql://ge-data:${POSTGRES_PASSWORD}@localhost:5433/ge-data"
#   \dx            -> timescaledb listed
#   \d+ prices_5m  -> hypertable
```

`db_reset` loads the schema once against a temporary preloaded server; apply later
schema changes by hand:

```bash
psql "postgresql://...@localhost:5433/ge-data" -f init/02_something.sql
```

## References

- Wiki real-time prices: https://oldschool.runescape.wiki/w/RuneScape:Real-time_Prices
- Wiki API rules/FAQs: https://prices.runescape.wiki/osrs/faqs
- TimescaleDB docs: https://www.tigerdata.com/docs
- Timescale Docker image: https://hub.docker.com/r/timescale/timescaledb
- `INSERT ... ON CONFLICT`: https://www.postgresql.org/docs/16/sql-insert.html#SQL-ON-CONFLICT
