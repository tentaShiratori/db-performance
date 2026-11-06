-- 件数が期待どおりなら何もしない（再実行でデータを変えず、後から足したインデックスも残す）
SELECT (
  to_regclass('public.shops') IS NOT NULL
  AND to_regclass('public.events') IS NOT NULL
)::int AS tables_exist \gset

\if :tables_exist
SELECT (
  (SELECT count(*) FROM shops) = 10000
  AND (SELECT count(*) FROM events) = 3000000
)::int AS already_loaded \gset
\else
\set already_loaded 0
\endif

\if :already_loaded
\else
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS shops;

CREATE TABLE shops (
  id    bigserial PRIMARY KEY,
  name  text NOT NULL
);

CREATE TABLE events (
  id          bigserial PRIMARY KEY,
  shop_id     bigint NOT NULL REFERENCES shops(id),
  kind        text NOT NULL,
  payload     text NOT NULL,
  created_at  timestamptz NOT NULL
);

-- 「日付と店舗で探すから」と貼ったインデックス。列の順番、本当にこれでいいのか？
CREATE INDEX events_created_at_shop_id_idx ON events (created_at, shop_id);

-- 店舗 1万件
INSERT INTO shops (name)
SELECT 'shop_' || g
FROM generate_series(1, 10000) AS g;

-- イベント 300万件（店舗にばらまく）。seed を固定して再構築しても同じ内容にする
SELECT setseed(0.42);

INSERT INTO events (shop_id, kind, payload, created_at)
SELECT
  (random() * 9999)::bigint + 1,
  (ARRAY['click', 'view', 'purchase', 'signup'])[1 + (random() * 3)::int],
  'payload_' || g,
  timestamptz '2024-01-01' + (random() * interval '700 days')
FROM generate_series(1, 3000000) AS g;

ANALYZE shops;
ANALYZE events;
\endif
