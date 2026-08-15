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
('combine', 'Dragonfire shield',            false, '[{"item_id":1540,"qty":1},{"item_id":11286,"qty":1}]',  '[{"item_id":11284,"qty":1}]', 'Requires 90 Smithing, or pay Oziach 1,250,000 gp to combine. Output is the uncharged shield (the GE-traded variant).'),

-- ── Decants, expansion 2026-08-11 ────────────────────────────────────────
-- Same Bob Barter mechanics as above. IDs verified against prod `items`.
('decant', 'Antifire potion 3<->4',             true, '[{"item_id":2454,"qty":4}]',  '[{"item_id":2452,"qty":3}]',  'Bob Barter at the GE, free, no requirements.'),
('decant', 'Super antifire potion 3<->4',       true, '[{"item_id":21981,"qty":4}]', '[{"item_id":21978,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Extended super antifire 3<->4',     true, '[{"item_id":22212,"qty":4}]', '[{"item_id":22209,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Magic potion 3<->4',                true, '[{"item_id":3042,"qty":4}]',  '[{"item_id":3040,"qty":3}]',  'Bob Barter at the GE, free, no requirements.'),
('decant', 'Defence potion 3<->4',              true, '[{"item_id":133,"qty":4}]',   '[{"item_id":2432,"qty":3}]',  'Bob Barter at the GE, free, no requirements.'),
('decant', 'Sanfew serum 3<->4',                true, '[{"item_id":10927,"qty":4}]', '[{"item_id":10925,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Anti-venom 3<->4',                  true, '[{"item_id":12907,"qty":4}]', '[{"item_id":12905,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Divine magic potion 3<->4',         true, '[{"item_id":23748,"qty":4}]', '[{"item_id":23745,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Forgotten brew 3<->4',              true, '[{"item_id":27632,"qty":4}]', '[{"item_id":27629,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Prayer regeneration potion 3<->4',  true, '[{"item_id":30128,"qty":4}]', '[{"item_id":30125,"qty":3}]', 'Bob Barter at the GE, free, no requirements.'),
-- 1/2-dose books misprice constantly; dose-conserving pairs vs the 4-dose.
('decant', 'Prayer potion 2<->4',               true, '[{"item_id":141,"qty":2}]',   '[{"item_id":2434,"qty":1}]',  'Bob Barter at the GE, free, no requirements.'),
('decant', 'Prayer potion 1<->4',               true, '[{"item_id":143,"qty":4}]',   '[{"item_id":2434,"qty":1}]',  'Bob Barter at the GE, free, no requirements.'),
('decant', 'Super restore 2<->4',               true, '[{"item_id":3028,"qty":2}]',  '[{"item_id":3024,"qty":1}]',  'Bob Barter at the GE, free, no requirements.'),
('decant', 'Super restore 1<->4',               true, '[{"item_id":3030,"qty":4}]',  '[{"item_id":3024,"qty":1}]',  'Bob Barter at the GE, free, no requirements.'),
('decant', 'Saradomin brew 2<->4',              true, '[{"item_id":6689,"qty":2}]',  '[{"item_id":6685,"qty":1}]',  'Bob Barter at the GE, free, no requirements.'),
('decant', 'Saradomin brew 1<->4',              true, '[{"item_id":6691,"qty":4}]',  '[{"item_id":6685,"qty":1}]',  'Bob Barter at the GE, free, no requirements.'),
('decant', 'Stamina potion 2<->4',              true, '[{"item_id":12629,"qty":2}]', '[{"item_id":12625,"qty":1}]', 'Bob Barter at the GE, free, no requirements.'),
('decant', 'Stamina potion 1<->4',              true, '[{"item_id":12631,"qty":4}]', '[{"item_id":12625,"qty":1}]', 'Bob Barter at the GE, free, no requirements.'),

-- ── Sets, expansion 2026-08-11 ───────────────────────────────────────────
-- GE clerk exchanges components <-> set item, free, both ways.
('set', 'Mithril set (lg)',           true, '[{"item_id":1159,"qty":1},{"item_id":1121,"qty":1},{"item_id":1071,"qty":1},{"item_id":1197,"qty":1}]',     '[{"item_id":13000,"qty":1}]', 'GE clerk, free, both directions. F2P.'),
('set', 'Adamant set (lg)',           true, '[{"item_id":1161,"qty":1},{"item_id":1123,"qty":1},{"item_id":1073,"qty":1},{"item_id":1199,"qty":1}]',     '[{"item_id":13012,"qty":1}]', 'GE clerk, free, both directions. F2P.'),
('set', 'Rune armour set (sk)',       true, '[{"item_id":1163,"qty":1},{"item_id":1127,"qty":1},{"item_id":1093,"qty":1},{"item_id":1201,"qty":1}]',     '[{"item_id":13026,"qty":1}]', 'GE clerk, free, both directions. F2P.'),
('set', 'Dragon armour set (lg)',     true, '[{"item_id":11335,"qty":1},{"item_id":21892,"qty":1},{"item_id":4087,"qty":1},{"item_id":21895,"qty":1}]',  '[{"item_id":21882,"qty":1}]', 'GE clerk, free, both directions.'),
('set', 'Saradomin dragonhide set',   true, '[{"item_id":10390,"qty":1},{"item_id":10386,"qty":1},{"item_id":10388,"qty":1},{"item_id":10384,"qty":1}]', '[{"item_id":13163,"qty":1}]', 'GE clerk, free, both directions. Coif, body, chaps, bracers.'),
('set', 'Guthix dragonhide set',      true, '[{"item_id":10382,"qty":1},{"item_id":10378,"qty":1},{"item_id":10380,"qty":1},{"item_id":10376,"qty":1}]', '[{"item_id":13165,"qty":1}]', 'GE clerk, free, both directions. Coif, body, chaps, bracers.'),
('set', 'Zamorak dragonhide set',     true, '[{"item_id":10374,"qty":1},{"item_id":10370,"qty":1},{"item_id":10372,"qty":1},{"item_id":10368,"qty":1}]', '[{"item_id":13161,"qty":1}]', 'GE clerk, free, both directions. Coif, body, chaps, bracers.'),
('set', 'Armadyl dragonhide set',     true, '[{"item_id":12512,"qty":1},{"item_id":12508,"qty":1},{"item_id":12510,"qty":1},{"item_id":12506,"qty":1}]', '[{"item_id":13169,"qty":1}]', 'GE clerk, free, both directions. Coif, body, chaps, bracers.'),
('set', 'Bandos dragonhide set',      true, '[{"item_id":12504,"qty":1},{"item_id":12500,"qty":1},{"item_id":12502,"qty":1},{"item_id":12498,"qty":1}]', '[{"item_id":13167,"qty":1}]', 'GE clerk, free, both directions. Coif, body, chaps, bracers.'),
('set', 'Ancient dragonhide set',     true, '[{"item_id":12496,"qty":1},{"item_id":12492,"qty":1},{"item_id":12494,"qty":1},{"item_id":12490,"qty":1}]', '[{"item_id":13171,"qty":1}]', 'GE clerk, free, both directions. Coif, body, chaps, bracers.'),
('set', 'Mystic set (blue)',          true, '[{"item_id":4089,"qty":1},{"item_id":4091,"qty":1},{"item_id":4093,"qty":1},{"item_id":4095,"qty":1},{"item_id":4097,"qty":1}]',      '[{"item_id":23113,"qty":1}]', 'GE clerk, free, both directions. Hat, top, bottom, gloves, boots.'),
('set', 'Mystic set (light)',         true, '[{"item_id":4109,"qty":1},{"item_id":4111,"qty":1},{"item_id":4113,"qty":1},{"item_id":4115,"qty":1},{"item_id":4117,"qty":1}]',      '[{"item_id":23110,"qty":1}]', 'GE clerk, free, both directions. Hat, top, bottom, gloves, boots.'),
('set', 'Mystic set (dark)',          true, '[{"item_id":4099,"qty":1},{"item_id":4101,"qty":1},{"item_id":4103,"qty":1},{"item_id":4105,"qty":1},{"item_id":4107,"qty":1}]',      '[{"item_id":23116,"qty":1}]', 'GE clerk, free, both directions. Hat, top, bottom, gloves, boots.'),
('set', 'Mystic set (dusk)',          true, '[{"item_id":23047,"qty":1},{"item_id":23050,"qty":1},{"item_id":23053,"qty":1},{"item_id":23056,"qty":1},{"item_id":23059,"qty":1}]', '[{"item_id":23119,"qty":1}]', 'GE clerk, free, both directions. Hat, top, bottom, gloves, boots.'),
('set', 'Dagon''hai robes set',       true, '[{"item_id":24288,"qty":1},{"item_id":24291,"qty":1},{"item_id":24294,"qty":1}]', '[{"item_id":24333,"qty":1}]', 'GE clerk, free, both directions.'),
('set', 'Obsidian armour set',        true, '[{"item_id":21298,"qty":1},{"item_id":21301,"qty":1},{"item_id":21304,"qty":1}]', '[{"item_id":21279,"qty":1}]', 'GE clerk, free, both directions.'),
('set', 'Sunfire fanatic armour set', true, '[{"item_id":28933,"qty":1},{"item_id":28936,"qty":1},{"item_id":28939,"qty":1}]', '[{"item_id":29424,"qty":1}]', 'GE clerk, free, both directions.'),
-- Moon sets are FOUR components: the set item includes the weapon (wiki:
-- "all four components"). Omitting it booked the weapon's value as phantom
-- conversion profit (strategies 1291/1293, ~218M, 2026-08-14).
('set', 'Blood moon armour set',      true, '[{"item_id":29028,"qty":1},{"item_id":29022,"qty":1},{"item_id":29025,"qty":1},{"item_id":28997,"qty":1}]', '[{"item_id":31136,"qty":1}]', 'GE clerk, free, both directions. Helm, chestplate, tassets, dual macuahuitl.'),
('set', 'Blue moon armour set',       true, '[{"item_id":29019,"qty":1},{"item_id":29013,"qty":1},{"item_id":29016,"qty":1},{"item_id":28988,"qty":1}]', '[{"item_id":31139,"qty":1}]', 'GE clerk, free, both directions. Helm, chestplate, tassets, blue moon spear.'),
('set', 'Eclipse moon armour set',    true, '[{"item_id":29010,"qty":1},{"item_id":29004,"qty":1},{"item_id":29007,"qty":1},{"item_id":29000,"qty":1}]', '[{"item_id":31142,"qty":1}]', 'GE clerk, free, both directions. Helm, chestplate, tassets, eclipse atlatl.'),
('set', 'Torva armour set',           true, '[{"item_id":26382,"qty":1},{"item_id":26384,"qty":1},{"item_id":26386,"qty":1}]', '[{"item_id":31145,"qty":1}]', 'GE clerk, free, both directions. Restored (tradeable) pieces.'),
('set', 'Virtus armour set',          true, '[{"item_id":26241,"qty":1},{"item_id":26243,"qty":1},{"item_id":26245,"qty":1}]', '[{"item_id":31148,"qty":1}]', 'GE clerk, free, both directions.'),
('set', 'Oathplate armour set',       true, '[{"item_id":30750,"qty":1},{"item_id":30753,"qty":1},{"item_id":30756,"qty":1}]', '[{"item_id":30744,"qty":1}]', 'GE clerk, free, both directions.'),
('set', 'Dragonstone armour set',     true, '[{"item_id":24034,"qty":1},{"item_id":24037,"qty":1},{"item_id":24040,"qty":1},{"item_id":24046,"qty":1},{"item_id":24043,"qty":1}]', '[{"item_id":23667,"qty":1}]', 'GE clerk, free, both directions. Full helm, platebody, platelegs, gauntlets, boots.'),

-- ── Combines, expansion 2026-08-11 ───────────────────────────────────────
('combine', 'Malediction ward',           false, '[{"item_id":11931,"qty":1},{"item_id":11932,"qty":1},{"item_id":11933,"qty":1}]', '[{"item_id":11924,"qty":1}]', 'Combine the three shards, no requirements. Not reversible.'),
('combine', 'Odium ward',                 false, '[{"item_id":11928,"qty":1},{"item_id":11929,"qty":1},{"item_id":11930,"qty":1}]', '[{"item_id":11926,"qty":1}]', 'Combine the three shards, no requirements. Not reversible.'),
('combine', 'Toxic staff of the dead',    true,  '[{"item_id":11791,"qty":1},{"item_id":12932,"qty":1}]', '[{"item_id":12902,"qty":1}]', 'Magic fang on staff of the dead, requires 59 Crafting; dismantles back. Uncharged staff is the GE-traded variant.'),
('combine', 'Serpentine helm',            false, '[{"item_id":12927,"qty":1}]',                           '[{"item_id":12929,"qty":1}]', 'Chisel the serpentine visage, requires 52 Crafting. Uncharged helm is the GE-traded variant.'),
('combine', 'Zaryte crossbow',            false, '[{"item_id":11785,"qty":1},{"item_id":26235,"qty":1},{"item_id":26231,"qty":250}]', '[{"item_id":26374,"qty":1}]', 'Armadyl crossbow + zaryte vambraces + 250 nihil shards, no skill requirement. Not reversible.'),
('combine', 'Primordial boots',           false, '[{"item_id":11840,"qty":1},{"item_id":13231,"qty":1}]', '[{"item_id":13239,"qty":1}]', 'Requires 60 Magic and 60 Runecraft. Not reversible.'),
('combine', 'Pegasian boots',             false, '[{"item_id":2577,"qty":1},{"item_id":13229,"qty":1}]',  '[{"item_id":13237,"qty":1}]', 'Requires 60 Magic and 60 Runecraft. Not reversible.'),
('combine', 'Eternal boots',              false, '[{"item_id":6920,"qty":1},{"item_id":13227,"qty":1}]',  '[{"item_id":13235,"qty":1}]', 'Requires 60 Magic and 60 Runecraft. Not reversible.'),
('combine', 'Voidwaker',                  false, '[{"item_id":27684,"qty":1},{"item_id":27681,"qty":1},{"item_id":27687,"qty":1}]', '[{"item_id":27690,"qty":1}]', 'Madam Sikaro in Ferox Enclave assembles for 500,000 gp; no skill requirements. Not reversible.'),
('combine', 'Venator bow',                false, '[{"item_id":27614,"qty":5}]',                           '[{"item_id":27612,"qty":1}]', 'Combine 5 venator shards, no requirements. Uncharged bow is the GE-traded variant. Not reversible.')
ON CONFLICT (name) DO UPDATE SET
  kind = EXCLUDED.kind,
  reversible = EXCLUDED.reversible,
  inputs = EXCLUDED.inputs,
  outputs = EXCLUDED.outputs,
  notes = EXCLUDED.notes;
