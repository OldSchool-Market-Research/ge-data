-- item_relations.family: the sub-type of a conversion, finer than `kind`.
--
-- `kind` says how a conversion works (GE clerk set, Bob Barter decant, combine).
-- `family` says what market it trades in, because those behave very differently:
-- over Oct 16-30 2026 a moon set earned ~5.5M per ship and a dragonhide set ~0.4M,
-- both of kind 'set'. Family drives reporting and calibration only; the recipe's
-- mechanics still come from `kind`, so a family needs no code of its own.
--
-- Slugs are unique across families and never equal a kind: a calibration row is
-- keyed "C:<kind>" or "C:<family>" in one column. Curated by hand, by exact name.
-- A recipe added later stays NULL ("unlabelled") until it is listed here.
--
-- Re-runnable. Prod apply (manual, on eldo, AS THE ge-data ROLE; 02+03 applied):
--   psql -h 127.0.0.1 -p 5432 -U ge-data -d ge-data -f init/07_item_relation_families.sql

BEGIN;

ALTER TABLE item_relations ADD COLUMN IF NOT EXISTS family text;

UPDATE item_relations r SET family = f.family
FROM (VALUES
  -- kind set
  ('barrows', ARRAY['Ahrim''s armour set','Dharok''s armour set','Guthan''s armour set','Karil''s armour set','Torag''s armour set','Verac''s armour set']),
  ('moon', ARRAY['Blood moon armour set','Blue moon armour set','Eclipse moon armour set']),
  ('endgame', ARRAY['Ancestral robes set','Inquisitor''s armour set','Justiciar armour set','Masori armour set (f)','Oathplate armour set','Sunfire fanatic armour set','Torva armour set','Virtus armour set']),
  ('dragonhide', ARRAY['Ancient dragonhide set','Armadyl dragonhide set','Bandos dragonhide set','Black dragonhide set','Blue dragonhide set','Green dragonhide set','Guthix dragonhide set','Red dragonhide set','Saradomin dragonhide set','Zamorak dragonhide set']),
  ('robes', ARRAY['Dagon''hai robes set','Mystic set (blue)','Mystic set (dark)','Mystic set (dusk)','Mystic set (light)']),
  ('metal', ARRAY['Adamant set (lg)','Dragon armour set (lg)','Dragonstone armour set','Mithril set (lg)','Obsidian armour set','Rune armour set (lg)','Rune armour set (sk)']),
  -- kind combine
  ('dismantle', ARRAY['Armadyl chainskirt -> armadylean plates','Armadyl chestplate -> armadylean plates','Armadyl helmet -> armadylean plate','Bale of flax -> flax','Bandos chestplate -> bandosian components','Bandos tassets -> bandosian components','Bracelet of ethereum (uncharged) -> revenant ether','Craw''s bow (u) -> revenant ether','Eye of Ayak (uncharged) -> demon tears','Magic fang -> Zulrah''s scales','Oathplate chest -> oathplate shards','Oathplate helm -> oathplate shards','Oathplate legs -> oathplate shards','Serpentine helm (uncharged) -> Zulrah''s scales','Serpentine visage -> Zulrah''s scales','Tanzanite fang -> Zulrah''s scales','Thammaron''s sceptre (u) -> revenant ether','Toxic blowpipe (empty) -> Zulrah''s scales','Viggora''s chainmace (u) -> revenant ether']),
  ('godsword', ARRAY['Ancient godsword','Armadyl godsword','Bandos godsword','Saradomin godsword','Zamorak godsword','Godsword blade (from shards)']),
  ('shield', ARRAY['Ancient wyvern shield','Arcane spirit shield','Blessed spirit shield','Dragonfire shield','Dragonfire ward','Dragon kiteshield','Dragon sq shield','Elysian spirit shield','Malediction ward','Odium ward','Spectral spirit shield']),
  ('boots', ARRAY['Boots of Brimstone','Devout boots','Eternal boots','Pegasian boots','Primordial boots']),
  ('jewellery', ARRAY['Amulet of rancour','Necklace of rupture','Uncut zenyte','Zenyte (cut)']),
  ('repair', ARRAY['Belle''s folly (repair)','Torva full helm (restore)','Torva platebody (restore)','Torva platelegs (restore)','Zombie axe (repair)','Zombie helmet (repair)']),
  ('weapon', ARRAY['Accursed sceptre (u)','Accursed sceptre (u)<->(au)','Burning claws','Dragon hunter lance','Kodai wand','Thammaron''s sceptre (u)<->(au)','Toxic staff of the dead','Twinflame staff','Uncharged toxic trident','Uncharged toxic trident (e) (from trident (e))','Uncharged toxic trident (e) (Lieve)','Uncharged trident (e) (Lieve)','Ursine chainmace (u)','Venator bow','Voidwaker','Webweaver bow (u)','Zaryte crossbow']),
  ('armour', ARRAY['Dragon platebody','Masori body (f)','Masori chaps (f)','Masori mask (f)','Serpentine helm']),
  ('misc', ARRAY['Crystal key']),
  -- kind decant
  ('restore', ARRAY['Prayer potion 1<->4','Prayer potion 2<->4','Prayer potion 3<->4','Prayer regeneration potion 3<->4','Sanfew serum 3<->4','Saradomin brew 1<->4','Saradomin brew 2<->4','Saradomin brew 3<->4','Super restore 1<->4','Super restore 2<->4','Super restore 3<->4']),
  ('combat', ARRAY['Bastion potion 3<->4','Battlemage potion 3<->4','Defence potion 3<->4','Divine bastion potion 3<->4','Divine battlemage potion 3<->4','Divine magic potion 3<->4','Divine ranging potion 3<->4','Divine super combat 3<->4','Forgotten brew 3<->4','Magic potion 3<->4','Ranging potion 3<->4','Super combat potion 3<->4']),
  ('utility', ARRAY['Antifire potion 3<->4','Anti-venom 3<->4','Anti-venom+ 3<->4','Extended antifire 3<->4','Extended anti-venom+ 3<->4','Extended stamina potion 3<->4','Extended super antifire 3<->4','Stamina potion 1<->4','Stamina potion 2<->4','Stamina potion 3<->4','Super antifire potion 3<->4'])
) AS f(family, names), unnest(f.names) AS n(name)
WHERE r.name = n.name;

COMMIT;
