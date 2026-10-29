-- process_quotes: live gp/hr for every process_recipes row, plus an hourly
-- snapshot table for trend / top-performer history.
--
-- This file is the ONE place the processing math lives. ge-mcp's process
-- tools, the orchestrator API and the ingester's hourly snapshot all read
-- these views; none of them re-derives a margin.
--
-- Pricing conventions (same as combo_quote / prices_1m.margin):
--   slow  = buy inputs at the latest low, sell outputs at the latest high
--           (patient offers on both sides)
--   insta = buy inputs at the latest high, sell outputs at the latest low
--   GE tax = sale/50 per unit (2% floored), capped at 5M, sell side only.
-- A margin is NULL when any leg it needs has no price (or a malformed qty):
-- an unpriceable recipe, never a partial sum and never zero. Nulls are
-- signal (GOAL.md); nothing here coalesces a price.
--
-- Rates, in actions per hour (one action = one set of legs):
--   limit_actions_per_hour = min over buy legs of buy_limit / qty / 4 (GE buy
--     limits reset every 4 hours). Legs with an unknown buy limit are skipped,
--     which is optimistic; unknown_limit_legs counts them.
--   market_actions_per_hour[_insta] = min over legs of trailing-24h volume on
--     the side the order fills against, / qty / 24. Slow: buy legs fill against
--     insta-sells (low_volume), sell legs against insta-buys (high_volume).
--     Insta: the reverse. No trades in 24h = rate 0, so gp/hr is 0.
--   effective_actions_per_hour[_insta]:
--     fixed / volume_capped -> LEAST(actions_per_hour, limit, market)
--     volume_bound          -> LEAST(limit, market)
--     unknown               -> NULL (no rate: rank on margin instead)
--   Every kind is capped by the market and the buy limit; `throughput` records
--   where the player-speed figure came from, not whether caps apply.
--
-- Prod apply (after 04+05, as the ge-data role; re-runnable):
--   psql -h 127.0.0.1 -p 5432 -U ge-data -d ge-data -f init/06_process_quotes.sql

-- One transaction: readers (the hh:05 snapshot, the API, ge-mcp) never see
-- the gap between the DROP and the CREATE below.
BEGIN;

-- Dropped and recreated (not just CREATE OR REPLACE) so a column change stays
-- re-runnable; nothing depends on these views, and ge-data's default privileges
-- re-grant SELECT to ge-mcp / ge-orchestrator when it recreates them.
DROP VIEW IF EXISTS process_quotes_now, process_legs_now;

-- Every leg of every recipe with its latest quote and 24h volume. Linked
-- recipes take their legs from item_relations (reverse direction swaps them).
-- Both lookups are LATERAL ... LIMIT 1 / a 24h sum per LEG, never DISTINCT ON
-- over an item list: that plan walks whole chunks once a few hundred
-- item_ids are involved (the Aug 2026 combo_screen timeout). The legs CTE is
-- referenced once, so it's inlined and a recipe_id filter reaches it: one
-- recipe costs a handful of index probes, not the whole universe.
CREATE VIEW process_legs_now AS
WITH legs AS (
  SELECT p.recipe_id, 'buy'::text AS side, (l->>'item_id')::int AS item_id, (l->>'qty')::numeric AS qty
  FROM process_recipes p
  LEFT JOIN item_relations r ON r.name = p.relation_name
  CROSS JOIN LATERAL jsonb_array_elements(CASE
      WHEN p.relation_name IS NULL THEN p.inputs
      WHEN p.relation_direction = 'forward' THEN r.inputs
      ELSE r.outputs END) l
  UNION ALL
  SELECT p.recipe_id, 'sell', (l->>'item_id')::int, (l->>'qty')::numeric
  FROM process_recipes p
  LEFT JOIN item_relations r ON r.name = p.relation_name
  CROSS JOIN LATERAL jsonb_array_elements(CASE
      WHEN p.relation_name IS NULL THEN p.outputs
      WHEN p.relation_direction = 'forward' THEN r.outputs
      ELSE r.inputs END) l
)
-- Volumes (not prices) default to 0: /5m only lists items that traded in the
-- block, so no rows in 24h means nothing traded. (After an ingester outage the
-- 24h sum undercounts until the window refills.)
SELECT legs.recipe_id, legs.side, legs.item_id, i.name, legs.qty, i.buy_limit,
       l1.high, l1.high_time, l1.low, l1.low_time,
       i.icon,
       coalesce(v.high_vol_24h, 0) AS high_vol_24h,
       coalesce(v.low_vol_24h, 0)  AS low_vol_24h
FROM legs
LEFT JOIN items i USING (item_id)
LEFT JOIN LATERAL (
  SELECT high, high_time, low, low_time FROM prices_1m
  WHERE item_id = legs.item_id ORDER BY ts DESC LIMIT 1
) l1 ON true
LEFT JOIN LATERAL (
  SELECT sum(high_volume) AS high_vol_24h, sum(low_volume) AS low_vol_24h FROM prices_5m
  WHERE item_id = legs.item_id AND ts > now() - interval '24 hours'
) v ON true;

CREATE VIEW process_quotes_now AS
WITH agg AS (
  SELECT l.recipe_id,
         -- a missing or non-positive qty makes the recipe unpriceable rather
         -- than dropping the leg from the sum (or dividing by zero below)
         CASE WHEN bool_and(coalesce(l.qty > 0, false) AND CASE l.side WHEN 'buy' THEN l.low ELSE l.high END IS NOT NULL)
              THEN sum(CASE l.side WHEN 'sell' THEN l.qty * (l.high - LEAST(l.high / 50, 5000000))
                                   ELSE -l.qty * l.low END) END AS gross_slow,
         CASE WHEN bool_and(coalesce(l.qty > 0, false) AND CASE l.side WHEN 'buy' THEN l.high ELSE l.low END IS NOT NULL)
              THEN sum(CASE l.side WHEN 'sell' THEN l.qty * (l.low - LEAST(l.low / 50, 5000000))
                                   ELSE -l.qty * l.high END) END AS gross_insta,
         count(*) FILTER (WHERE CASE l.side WHEN 'buy' THEN l.low ELSE l.high END IS NULL) AS missing_legs,
         count(*) FILTER (WHERE CASE l.side WHEN 'buy' THEN l.high ELSE l.low END IS NULL) AS missing_legs_insta,
         count(*) FILTER (WHERE l.side = 'buy' AND l.buy_limit IS NULL) AS unknown_limit_legs,
         min(l.buy_limit / NULLIF(l.qty, 0)) FILTER (WHERE l.side = 'buy') / 4 AS limit_actions_per_hour,
         min(CASE l.side WHEN 'buy' THEN l.low_vol_24h ELSE l.high_vol_24h END / NULLIF(l.qty, 0)) / 24 AS market_actions_per_hour,
         min(CASE l.side WHEN 'buy' THEN l.high_vol_24h ELSE l.low_vol_24h END / NULLIF(l.qty, 0)) / 24 AS market_actions_per_hour_insta,
         max(extract(epoch FROM now() - CASE l.side WHEN 'buy' THEN l.low_time ELSE l.high_time END))::bigint AS max_leg_age_s,
         -- display only: the recipe's main output (largest sell qty), /mapping icon file
         (array_agg(l.icon ORDER BY l.qty DESC NULLS LAST, l.item_id) FILTER (WHERE l.side = 'sell' AND l.icon IS NOT NULL))[1] AS icon
  FROM process_legs_now l
  GROUP BY l.recipe_id
),
rated AS (
  SELECT p.recipe_id, p.name, p.category, p.throughput, p.actions_per_hour, p.fee_gp, a.icon,
         a.gross_slow - p.fee_gp  AS margin_slow,
         a.gross_insta - p.fee_gp AS margin_insta,
         a.missing_legs, a.missing_legs_insta, a.unknown_limit_legs,
         a.limit_actions_per_hour, a.market_actions_per_hour, a.market_actions_per_hour_insta, a.max_leg_age_s,
         CASE p.throughput
           WHEN 'volume_bound' THEN LEAST(a.limit_actions_per_hour, a.market_actions_per_hour)
           WHEN 'unknown'      THEN NULL
           ELSE LEAST(p.actions_per_hour, a.limit_actions_per_hour, a.market_actions_per_hour)
         END AS effective_actions_per_hour,
         CASE p.throughput
           WHEN 'volume_bound' THEN LEAST(a.limit_actions_per_hour, a.market_actions_per_hour_insta)
           WHEN 'unknown'      THEN NULL
           ELSE LEAST(p.actions_per_hour, a.limit_actions_per_hour, a.market_actions_per_hour_insta)
         END AS effective_actions_per_hour_insta
  FROM process_recipes p
  JOIN agg a USING (recipe_id)
)
SELECT recipe_id, name, category, throughput, fee_gp,
       round(margin_slow)  AS margin_slow,
       round(margin_insta) AS margin_insta,
       -- the sheet's "theoretical" figure: player speed only, market ignored
       round(margin_slow * actions_per_hour)                  AS gp_hr_theoretical,
       round(margin_slow * effective_actions_per_hour)        AS gp_hr,
       round(margin_insta * effective_actions_per_hour_insta) AS gp_hr_insta,
       actions_per_hour,
       round(effective_actions_per_hour, 2)       AS effective_actions_per_hour,
       round(effective_actions_per_hour_insta, 2) AS effective_actions_per_hour_insta,
       round(limit_actions_per_hour, 2)           AS limit_actions_per_hour,
       round(market_actions_per_hour, 2)          AS market_actions_per_hour,
       round(market_actions_per_hour_insta, 2)    AS market_actions_per_hour_insta,
       missing_legs, missing_legs_insta, unknown_limit_legs, max_leg_age_s,
       icon
FROM rated;

-- process_snapshots: the ingester copies process_quotes_now here once an hour
-- (ts = the hour, so a second run within the hour is a no-op via the PK). This
-- is the history behind trend and top-performer queries. NULL columns are kept
-- as-is: an hour where a recipe couldn't be priced stays visible as a gap.
-- No FK to process_recipes, like prices -> items: the seed deletes recipes it
-- no longer generates (renames included), and their history must survive
-- that; `name` keeps an orphaned recipe_id readable.
CREATE TABLE IF NOT EXISTS process_snapshots (
  ts                               timestamptz NOT NULL,
  recipe_id                        integer     NOT NULL,
  name                             text        NOT NULL,
  margin_slow                      numeric,
  margin_insta                     numeric,
  gp_hr_theoretical                numeric,
  gp_hr                            numeric,
  gp_hr_insta                      numeric,
  effective_actions_per_hour       numeric,
  effective_actions_per_hour_insta numeric,
  limit_actions_per_hour           numeric,
  market_actions_per_hour          numeric,
  market_actions_per_hour_insta    numeric,
  missing_legs                     integer     NOT NULL,
  missing_legs_insta               integer     NOT NULL,
  unknown_limit_legs               integer     NOT NULL,
  max_leg_age_s                    bigint,
  PRIMARY KEY (ts, recipe_id)
);
SELECT create_hypertable('process_snapshots', by_range('ts', INTERVAL '1 month'), if_not_exists => true);
CREATE INDEX IF NOT EXISTS process_snapshots_recipe_ts_idx ON process_snapshots (recipe_id, ts DESC);

COMMIT;
