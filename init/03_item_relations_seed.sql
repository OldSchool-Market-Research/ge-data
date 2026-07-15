-- item_relations seed: curated 2026-07-14 from the OSRS Wiki /mapping data
-- (same source the ingester writes to `items`, so every item_id here must
-- exist there — see the sanity query in docs/database-setup.md).
--
-- Re-runnable: ON CONFLICT (name) DO UPDATE refreshes curation in place.

INSERT INTO item_relations (kind, name, reversible, inputs, outputs, notes) VALUES

-- ── Decants ──────────────────────────────────────────────────────────────
-- 4x 3-dose <-> 3x 4-dose (dose-conserving). Bob Barter (Grand Exchange)
-- decants free of charge in either direction, no requirements.
('decant', 'Prayer potion 3<->4',            true, '[{"item_id":139,"qty":4}]',   '[{"item_id":2434,"qty":3}]',  'Bob Barter at the GE, free, no requirements.'),
('decant', 'Super restore 3<->4',            true, '[{"item_id":3026,"qty":4}]',  '[{"item_id":3024,"qty":3}]',  'Bob Barter at the GE, free, no requirements.'),
('decant', 'Saradomin brew 3<->4',           true, '[{"item_id":6687,"qty":4}]',  '[{"item_id":6685,"qty":3}]',  'Bob Barter at the GE, free, no requirements.'),
('decant', 'Stamina potion 3<->4',           true, '[{"item_id":12627,"qty":4}]', '[{"item_id":12625,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Extended stamina potion 3<->4',  true, '[{"item_id":31641,"qty":4}]', '[{"item_id":31638,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Super combat potion 3<->4',      true, '[{"item_id":12697,"qty":4}]', '[{"item_id":12695,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Divine super combat 3<->4',      true, '[{"item_id":23688,"qty":4}]', '[{"item_id":23685,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Ranging potion 3<->4',           true, '[{"item_id":169,"qty":4}]',   '[{"item_id":2444,"qty":3}]',  'Bob Barter at the GE, free, no requirements.'),
('decant', 'Divine ranging potion 3<->4',    true, '[{"item_id":23736,"qty":4}]', '[{"item_id":23733,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Bastion potion 3<->4',           true, '[{"item_id":22464,"qty":4}]', '[{"item_id":22461,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Divine bastion potion 3<->4',    true, '[{"item_id":24638,"qty":4}]', '[{"item_id":24635,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Battlemage potion 3<->4',        true, '[{"item_id":22452,"qty":4}]', '[{"item_id":22449,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Divine battlemage potion 3<->4', true, '[{"item_id":24626,"qty":4}]', '[{"item_id":24623,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Anti-venom+ 3<->4',              true, '[{"item_id":12915,"qty":4}]', '[{"item_id":12913,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Extended anti-venom+ 3<->4',     true, '[{"item_id":29827,"qty":4}]', '[{"item_id":29824,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Extended antifire 3<->4',        true, '[{"item_id":11953,"qty":4}]', '[{"item_id":11951,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),

-- ── Sets ─────────────────────────────────────────────────────────────────
-- Grand Exchange clerk exchanges components <-> set item, free, both ways.
('set', 'Dharok''s armour set',       true, '[{"item_id":4716,"qty":1},{"item_id":4720,"qty":1},{"item_id":4722,"qty":1},{"item_id":4718,"qty":1}]', '[{"item_id":12877,"qty":1}]', 'GE clerk, free, both directions. Components must be undamaged (not degraded ''0'' variants).'),
('set', 'Ahrim''s armour set',        true, '[{"item_id":4708,"qty":1},{"item_id":4712,"qty":1},{"item_id":4714,"qty":1},{"item_id":4710,"qty":1}]', '[{"item_id":12881,"qty":1}]', 'GE clerk, free, both directions. Components must be undamaged.'),
('set', 'Karil''s armour set',        true, '[{"item_id":4732,"qty":1},{"item_id":4736,"qty":1},{"item_id":4738,"qty":1},{"item_id":4734,"qty":1}]', '[{"item_id":12883,"qty":1}]', 'GE clerk, free, both directions. Components must be undamaged.'),
('set', 'Guthan''s armour set',       true, '[{"item_id":4724,"qty":1},{"item_id":4728,"qty":1},{"item_id":4730,"qty":1},{"item_id":4726,"qty":1}]', '[{"item_id":12873,"qty":1}]', 'GE clerk, free, both directions. Components must be undamaged.'),
('set', 'Torag''s armour set',        true, '[{"item_id":4745,"qty":1},{"item_id":4749,"qty":1},{"item_id":4751,"qty":1},{"item_id":4747,"qty":1}]', '[{"item_id":12879,"qty":1}]', 'GE clerk, free, both directions. Components must be undamaged.'),
('set', 'Verac''s armour set',        true, '[{"item_id":4753,"qty":1},{"item_id":4757,"qty":1},{"item_id":4759,"qty":1},{"item_id":4755,"qty":1}]', '[{"item_id":12875,"qty":1}]', 'GE clerk, free, both directions. Components must be undamaged.'),
('set', 'Ancestral robes set',        true, '[{"item_id":21018,"qty":1},{"item_id":21021,"qty":1},{"item_id":21024,"qty":1}]',                        '[{"item_id":21049,"qty":1}]', 'GE clerk, free, both directions.'),
('set', 'Inquisitor''s armour set',   true, '[{"item_id":24419,"qty":1},{"item_id":24420,"qty":1},{"item_id":24421,"qty":1}]',                        '[{"item_id":24488,"qty":1}]', 'GE clerk, free, both directions.'),
('set', 'Justiciar armour set',       true, '[{"item_id":22326,"qty":1},{"item_id":22327,"qty":1},{"item_id":22328,"qty":1}]',                        '[{"item_id":22438,"qty":1}]', 'GE clerk, free, both directions.'),
('set', 'Masori armour set (f)',      true, '[{"item_id":27235,"qty":1},{"item_id":27238,"qty":1},{"item_id":27241,"qty":1}]',                        '[{"item_id":27355,"qty":1}]', 'GE clerk, free, both directions. Fortified pieces only.'),
('set', 'Rune armour set (lg)',       true, '[{"item_id":1163,"qty":1},{"item_id":1127,"qty":1},{"item_id":1079,"qty":1},{"item_id":1201,"qty":1}]',  '[{"item_id":13024,"qty":1}]', 'GE clerk, free, both directions. F2P.'),
('set', 'Blue dragonhide set',        true, '[{"item_id":2499,"qty":1},{"item_id":2493,"qty":1},{"item_id":2487,"qty":1}]',                           '[{"item_id":12867,"qty":1}]', 'GE clerk, free, both directions. High-volume crafting output.'),
('set', 'Green dragonhide set',       true, '[{"item_id":1135,"qty":1},{"item_id":1099,"qty":1},{"item_id":1065,"qty":1}]',                           '[{"item_id":12865,"qty":1}]', 'GE clerk, free, both directions. F2P, high-volume crafting output.'),
('set', 'Black dragonhide set',       true, '[{"item_id":2503,"qty":1},{"item_id":2497,"qty":1},{"item_id":2491,"qty":1}]',                           '[{"item_id":12871,"qty":1}]', 'GE clerk, free, both directions.'),
('set', 'Red dragonhide set',         true, '[{"item_id":2501,"qty":1},{"item_id":2495,"qty":1},{"item_id":2489,"qty":1}]',                           '[{"item_id":12869,"qty":1}]', 'GE clerk, free, both directions.'),

-- ── Combines ─────────────────────────────────────────────────────────────
('combine', 'Godsword blade (from shards)', false, '[{"item_id":11818,"qty":1},{"item_id":11820,"qty":1},{"item_id":11822,"qty":1}]', '[{"item_id":11798,"qty":1}]', 'Requires 80 Smithing at an anvil. Not reversible.'),
('combine', 'Armadyl godsword',             true,  '[{"item_id":11798,"qty":1},{"item_id":11810,"qty":1}]', '[{"item_id":11802,"qty":1}]', 'Attach hilt to blade, no requirements; godswords dismantle back into blade + hilt.'),
('combine', 'Bandos godsword',              true,  '[{"item_id":11798,"qty":1},{"item_id":11812,"qty":1}]', '[{"item_id":11804,"qty":1}]', 'Attach hilt to blade, no requirements; dismantles back.'),
('combine', 'Saradomin godsword',           true,  '[{"item_id":11798,"qty":1},{"item_id":11814,"qty":1}]', '[{"item_id":11806,"qty":1}]', 'Attach hilt to blade, no requirements; dismantles back.'),
('combine', 'Zamorak godsword',             true,  '[{"item_id":11798,"qty":1},{"item_id":11816,"qty":1}]', '[{"item_id":11808,"qty":1}]', 'Attach hilt to blade, no requirements; dismantles back.'),
('combine', 'Ancient godsword',             true,  '[{"item_id":11798,"qty":1},{"item_id":26370,"qty":1}]', '[{"item_id":26233,"qty":1}]', 'Attach hilt to blade, no requirements; dismantles back.'),
('combine', 'Blessed spirit shield',        false, '[{"item_id":12829,"qty":1},{"item_id":12833,"qty":1}]', '[{"item_id":12831,"qty":1}]', 'Requires 85 Prayer to bless the shield with the holy elixir at an altar.'),
('combine', 'Arcane spirit shield',         false, '[{"item_id":12831,"qty":1},{"item_id":12827,"qty":1}]', '[{"item_id":12825,"qty":1}]', 'Requires 90 Prayer and 85 Smithing to attach the sigil.'),
('combine', 'Elysian spirit shield',        false, '[{"item_id":12831,"qty":1},{"item_id":12819,"qty":1}]', '[{"item_id":12817,"qty":1}]', 'Requires 90 Prayer and 85 Smithing to attach the sigil.'),
('combine', 'Spectral spirit shield',       false, '[{"item_id":12831,"qty":1},{"item_id":12823,"qty":1}]', '[{"item_id":12821,"qty":1}]', 'Requires 90 Prayer and 85 Smithing to attach the sigil.'),
('combine', 'Kodai wand',                   false, '[{"item_id":6914,"qty":1},{"item_id":21043,"qty":1}]',  '[{"item_id":21006,"qty":1}]', 'Attach insignia to master wand, no requirements.'),
('combine', 'Uncut zenyte',                 false, '[{"item_id":19529,"qty":1},{"item_id":6573,"qty":1}]',  '[{"item_id":19496,"qty":1}]', 'Zenyte shard + onyx at a furnace; requires Monkey Madness II completion.'),
('combine', 'Zenyte (cut)',                 false, '[{"item_id":19496,"qty":1}]',                           '[{"item_id":19493,"qty":1}]', 'Requires 89 Crafting (chisel).'),
('combine', 'Dragonfire shield',            false, '[{"item_id":1540,"qty":1},{"item_id":11286,"qty":1}]',  '[{"item_id":11284,"qty":1}]', 'Requires 90 Smithing, or pay Oziach 1,250,000 gp to combine. Output is the uncharged shield (the GE-traded variant).')
ON CONFLICT (name) DO UPDATE SET
  kind = EXCLUDED.kind,
  reversible = EXCLUDED.reversible,
  inputs = EXCLUDED.inputs,
  outputs = EXCLUDED.outputs,
  notes = EXCLUDED.notes;
