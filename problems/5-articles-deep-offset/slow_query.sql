EXPLAIN (ANALYZE, BUFFERS)
SELECT id, title, published_at
FROM articles
ORDER BY published_at DESC, id DESC
LIMIT 20 OFFSET 500000;
