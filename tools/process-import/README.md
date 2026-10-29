# process-import

Generates `init/05_process_recipes_seed.sql` from the "Processing Flips" Google
Sheet (a friend's processing money-maker calculator). Re-run it whenever the
sheet gains or changes recipes.

## Run

1. Export the sheet: **File → Download → Microsoft Excel (.xlsx)**. The live
   API pulls don't survive the export; only the recipe formulas and the last
   cached prices do, and that's all this needs.
2. Fetch the Wiki item mapping (the same source as the `items` table):
   ```sh
   curl -A '<your contact>' https://prices.runescape.wiki/api/v1/osrs/mapping -o mapping.json
   ```
3. From `ge-data/`:
   ```sh
   nix-shell -p 'python3.withPackages(p:[p.openpyxl p.sympy])' --run \
     "python -I tools/process-import/import.py 'Processing Flips.xlsx' mapping.json"
   ```
4. Review the diff of `init/05_process_recipes_seed.sql` and the held-back list
   printed to stderr (also written at the bottom of the SQL).

## How it parses

Each Main-tab row is one hand-written formula: column C is profit per action
(outputs at `ROUNDUP(high*0.98)`, inputs at low, minus fees), column E is gp/hr
(`C * <actions/hr> / 1e6`), and X/Y are the high/low prices of the item named in
column W. The importer translates C into a sympy expression with prices as
symbols and the literal `0.98` as a `TAX` symbol, then reads the legs straight
off the coefficients: taxed positive terms are outputs, negative terms inputs,
the constant is the per-action fee.

A row is written only if:
- the translated formula evaluates exactly to the sheet's cached C value (so the
  translation itself is right), **and**
- the extracted legs, re-priced at the sheet's cached prices, land within the
  rounding slack of that value (so no term was lost or misread), **and**
- every item ID exists in the Wiki mapping.

Rows that match an `item_relations` recipe link to it instead of copying legs.

## Curation tables (top of `import.py`)

- `LINK`: rows whose formula takes the cheapest of several sources (masori,
  torva), linked to the curated `item_relations` recipe instead.
- `ACCEPT`: rows where the sheet is wrong and the parse is right.
- `DEFER` / `DEFER_ROWS`: categories or rows held back, with the reason.
- `RENAME` / `RECATEGORY`: typo fixes; `source` keeps the original sheet row.

Don't carry over the sheet's quirks: its tax is a flat 2% with no 5M cap (the
consumers apply the real tax), and a few rows use different actions/hr in the
slow and insta columns (the slow-column rate is kept).
