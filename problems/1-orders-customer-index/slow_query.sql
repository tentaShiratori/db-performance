EXPLAIN (ANALYZE, BUFFERS)
SELECT id, status, total_amount, ordered_at
FROM orders
WHERE customer_id = 12345
ORDER BY ordered_at DESC
LIMIT 50;
