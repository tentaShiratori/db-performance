EXPLAIN (ANALYZE, BUFFERS)
SELECT id, kind, payload, created_at
FROM events
WHERE shop_id = 4242
ORDER BY created_at DESC
LIMIT 50;
