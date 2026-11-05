DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  id          bigserial PRIMARY KEY,
  name        text NOT NULL,
  email       text NOT NULL
);

CREATE TABLE orders (
  id            bigserial PRIMARY KEY,
  customer_id   bigint NOT NULL REFERENCES customers(id),
  status        text NOT NULL,
  total_amount  numeric(12, 2) NOT NULL,
  ordered_at    timestamptz NOT NULL
);
-- ※ わざと orders.customer_id にインデックスは貼っていない

-- 顧客 5万件
INSERT INTO customers (name, email)
SELECT
  'customer_' || g,
  'user' || g || '@example.com'
FROM generate_series(1, 50000) AS g;

-- 注文 200万件（顧客にばらまく）
INSERT INTO orders (customer_id, status, total_amount, ordered_at)
SELECT
  (random() * 49999)::bigint + 1,
  (ARRAY['pending', 'paid', 'shipped', 'cancelled'])[1 + (random() * 3)::int],
  round((random() * 50000)::numeric, 2),
  timestamptz '2024-01-01' + (random() * interval '700 days')
FROM generate_series(1, 2000000);

ANALYZE customers;
ANALYZE orders;
