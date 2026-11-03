-- process_recipes curated by hand, outside the "Processing Flips" sheet: source
-- 'curated'. 05's importer deletes only its own 'Main!...' rows, so these survive
-- a re-generation. If the sheet ever gains a row with one of these names, the
-- importer's upsert takes it over.
--
-- Cooking: every 1-raw, 1-cooked fish or hunter meat at 60+ Cooking the sheet doesn't
-- have, with a market on both sides, whatever its margin today: prices move, and a
-- row's quote shows when it pays. 1300 actions/hr matches the sheet's other cooking rows.
-- Outputs are expected yields: 99 Cooking on the Hosidius range with the elite
-- Kourend & Kebos diary, plus cooking gauntlets where they apply, from each Wiki
-- page's success chart ((high + 1) / 256 at level 99, capped at 1). A Cooking cape
-- never burns, so it raises the rows below 1 to 1.
-- Left out: pies (Summer, Wild, Admiral, Dragonfruit, Mushroom), a separate low-end
-- market; Tuna potato (its Tuna and corn input barely trades); Rainbow crab meat (no sales).
--
-- Fortify via armour: an Armadyl piece bought and chiselled replaces bought plates,
-- so the plates are never traded. Links to item_relations. Rates chain the sheet's
-- 60 chisels/hr and 40 fortifies/hr per action; the buy limits bind long before them.
--
-- Re-runnable and exact: one transaction upserts every row and deletes curated rows
-- no longer listed. Prod apply (manual, on eldo, AS THE ge-data ROLE; 03 + 05 applied,
-- and 03 must include the relations linked below):
--   psql -h 127.0.0.1 -p 5432 -U ge-data -d ge-data -v ON_ERROR_STOP=1 -f init/09_process_recipes_curated.sql

BEGIN;

INSERT INTO process_recipes (name, category, relation_name, relation_direction, inputs, outputs, fee_gp, actions_per_hour, throughput, source, notes) VALUES
-- ── Cooking ──
('Cooking Manta Ray', 'Cooking', NULL, NULL, '[{"item_id":389,"qty":1}]', '[{"item_id":391,"qty":0.96875}]', 0, 1300, 'fixed', 'curated', 'Requires 91 Cooking. Burns at every level without a Cooking cape; the yield is the Hosidius range at 99 with the elite diary.'),
('Cooking Dark Crab', 'Cooking', NULL, NULL, '[{"item_id":11934,"qty":1}]', '[{"item_id":11936,"qty":0.96875}]', 0, 1300, 'fixed', 'curated', 'Requires 90 Cooking. Burns at every level without a Cooking cape; the yield is the Hosidius range at 99 with the elite diary.'),
('Cooking Bluefin', 'Cooking', NULL, NULL, '[{"item_id":32341,"qty":1}]', '[{"item_id":32344,"qty":1}]', 0, 1300, 'fixed', 'curated', 'Requires 87 Cooking. No burns at 99 only on the Hosidius range with the elite diary.'),
('Cooking Anglerfish', 'Cooking', NULL, NULL, '[{"item_id":13439,"qty":1}]', '[{"item_id":13441,"qty":1}]', 0, 1300, 'fixed', 'curated', 'Requires 84 Cooking. No burns at 99 only with cooking gauntlets on a range.'),
('Cooking Dashing Kebbit', 'Cooking', NULL, NULL, '[{"item_id":29107,"qty":1}]', '[{"item_id":29134,"qty":0.9765625}]', 0, 1300, 'fixed', 'curated', 'Requires 82 Cooking and 50 Hunters'' Rumours. Burns at every level without a Cooking cape; the yield is the Hosidius range at 99 with the elite diary.'),
('Cooking Sea Turtle', 'Cooking', NULL, NULL, '[{"item_id":395,"qty":1}]', '[{"item_id":397,"qty":0.96875}]', 0, 1300, 'fixed', 'curated', 'Requires 82 Cooking. Burns at every level without a Cooking cape; the yield is the Hosidius range at 99 with the elite diary.'),
('Cooking Yellowfin', 'Cooking', NULL, NULL, '[{"item_id":32325,"qty":1}]', '[{"item_id":32328,"qty":1}]', 0, 1300, 'fixed', 'curated', 'Requires 79 Cooking. No burns at 99 only on the Hosidius range with the elite diary.'),
('Cooking Haddock', 'Cooking', NULL, NULL, '[{"item_id":32317,"qty":1}]', '[{"item_id":32320,"qty":1}]', 0, 1300, 'fixed', 'curated', 'Requires 73 Cooking. No burns at 99 only on the Hosidius range (the easy diary is enough).'),
('Cooking Jumbo Squid', 'Cooking', NULL, NULL, '[{"item_id":31561,"qty":1}]', '[{"item_id":31564,"qty":1}]', 0, 1300, 'fixed', 'curated', 'Requires 71 Cooking. No burns at 99 only on the Hosidius range (the easy diary is enough).'),
('Cooking Giant Krill', 'Cooking', NULL, NULL, '[{"item_id":32309,"qty":1}]', '[{"item_id":32312,"qty":1}]', 0, 1300, 'fixed', 'curated', 'Requires 69 Cooking. No burns at 99 only on the Hosidius range (the easy diary is enough).'),
('Cooking Sunlight Antelope', 'Cooking', NULL, NULL, '[{"item_id":29116,"qty":1}]', '[{"item_id":29140,"qty":1}]', 0, 1300, 'fixed', 'curated', 'Requires 68 Cooking and 50 Hunters'' Rumours. No burns at 99 on a range.'),
('Cooking Monkfish', 'Cooking', NULL, NULL, '[{"item_id":7944,"qty":1}]', '[{"item_id":7946,"qty":1}]', 0, 1300, 'fixed', 'curated', 'Requires 62 Cooking. No burns at 99 on a range.'),
-- ── GWD Processing ──
('Fortify Masori Mask via Helm', 'GWD Processing', 'Masori mask (f) (from Armadyl helmet)', 'forward', NULL, NULL, 0, 24, 'fixed', 'curated', NULL),
('Fortify Masori Chaps via Chainskirt', 'GWD Processing', 'Masori chaps (f) (from Armadyl chainskirt)', 'forward', NULL, NULL, 0, 24, 'fixed', 'curated', NULL),
('Fortify Masori Body via Chest', 'GWD Processing', 'Masori body (f) (from Armadyl chestplate)', 'forward', NULL, NULL, 0, 24, 'fixed', 'curated', NULL),
('Fortify Masori Body via Chainskirt + Helm', 'GWD Processing', 'Masori body (f) (from Armadyl chainskirt + helmet)', 'forward', NULL, NULL, 0, 17, 'fixed', 'curated', NULL)
ON CONFLICT (name) DO UPDATE SET
  category = EXCLUDED.category, relation_name = EXCLUDED.relation_name,
  relation_direction = EXCLUDED.relation_direction,
  inputs = EXCLUDED.inputs, outputs = EXCLUDED.outputs, fee_gp = EXCLUDED.fee_gp,
  actions_per_hour = EXCLUDED.actions_per_hour, throughput = EXCLUDED.throughput,
  source = EXCLUDED.source, notes = EXCLUDED.notes;

DELETE FROM process_recipes
WHERE source = 'curated'
  AND name NOT IN ('Cooking Manta Ray', 'Cooking Dark Crab', 'Cooking Bluefin', 'Cooking Anglerfish', 'Cooking Dashing Kebbit', 'Cooking Sea Turtle', 'Cooking Yellowfin', 'Cooking Haddock', 'Cooking Jumbo Squid', 'Cooking Giant Krill', 'Cooking Sunlight Antelope', 'Cooking Monkfish', 'Fortify Masori Mask via Helm', 'Fortify Masori Chaps via Chainskirt', 'Fortify Masori Body via Chest', 'Fortify Masori Body via Chainskirt + Helm');

COMMIT;
