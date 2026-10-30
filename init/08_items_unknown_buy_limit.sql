-- 08_items_unknown_buy_limit.sql
--
-- /mapping has no "limit" for about 500 items, because the Wiki doesn't know theirs
-- (Module:Exchange/Nihil_horn says limit = nil). The ingester decoded that into a Go
-- int, so items.buy_limit read 0, and process_quotes_now took it as a cap of 0: every
-- recipe buying one of those items read 0 gp/hr, with unknown_limit_legs also 0.
--
-- The ingester now writes NULL and corrects these rows at its next /mapping refresh.
-- This also clears the few delisted items that refresh no longer touches. It sets the
-- two items /mapping really lists at 0 to NULL as well; the refresh puts those back.
--
-- Re-runnable. Prod apply (manual, on eldo, AS THE ge-data ROLE), only after every
-- reader of buy_limit is deployed: ge-orchestrator scanned one sweep's limit as non-null.
--   psql -h 127.0.0.1 -p 5432 -U ge-data -d ge-data -v ON_ERROR_STOP=1 -f init/08_items_unknown_buy_limit.sql

UPDATE items SET buy_limit = NULL WHERE buy_limit = 0;
