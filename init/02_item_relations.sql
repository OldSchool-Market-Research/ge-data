-- item_relations: hand-curated static conversions between GE-tradeable items.
--
-- Backs the C (conversion arbitrage) archetype: decanting potions, GE-clerk
-- armour sets, and combine recipes are the only places two GE prices are
-- mechanically linked, so sum-of-parts gaps are direction-neutral edges.
--
-- Not ingested from anywhere at runtime: curated by hand (IDs resolved from
-- the OSRS Wiki /mapping, the same source as `items`), seeded by
-- 03_item_relations_seed.sql, which is re-runnable (ON CONFLICT DO UPDATE).
--
-- Conventions:
--   * canonical direction = inputs bought, outputs sold (the typical trade);
--     reversible=true means the conversion also works outputs->inputs
--     (GE-clerk sets, godsword dismantling, Bob Barter decants either way).
--   * legs are jsonb [{"item_id": int, "qty": int}]; names/buy limits are
--     joined from `items` at query time so they can never drift.
--   * skill/quest gates and NPC fees live in `notes` — consumers must surface
--     them (a conversion a player can't perform is not an edge for them).
--   * decants conserve doses: 4x 3-dose = 12 doses = 3x 4-dose.
--
-- Prod apply (manual, on eldo, AS THE ge-data ROLE so the default-privilege
-- grants to ge-mcp / ge-orchestrator attach — see docs/database-setup.md):
--   psql -h 127.0.0.1 -p 5432 -U ge-data -d ge-data \
--     -f init/02_item_relations.sql -f init/03_item_relations_seed.sql

CREATE TABLE IF NOT EXISTS item_relations (
  relation_id serial PRIMARY KEY,
  kind        text    NOT NULL CHECK (kind IN ('decant', 'set', 'combine')),
  name        text    NOT NULL UNIQUE,
  reversible  boolean NOT NULL DEFAULT false,
  inputs      jsonb   NOT NULL,
  outputs     jsonb   NOT NULL,
  notes       text
);
