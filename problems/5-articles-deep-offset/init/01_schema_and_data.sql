-- 件数が期待どおりなら何もしない（再実行でデータを変えず、後から足したインデックスも残す）
SELECT (
  to_regclass('public.articles') IS NOT NULL
)::int AS tables_exist \gset

\if :tables_exist
SELECT (
  (SELECT count(*) FROM articles) = 1000000
)::int AS already_loaded \gset
\else
\set already_loaded 0
\endif

\if :already_loaded
\else
DROP TABLE IF EXISTS articles;

CREATE TABLE articles (
  id           bigserial PRIMARY KEY,
  title        text NOT NULL,
  body         text NOT NULL,
  published_at timestamptz NOT NULL
);

CREATE INDEX articles_published_at_id_idx ON articles (published_at DESC, id DESC);

-- 記事 100万件（新しいほど id も大きいイメージで並べる）。seed を固定して再構築しても同じ内容にする
SELECT setseed(0.42);

INSERT INTO articles (title, body, published_at)
SELECT
  'article_' || g,
  'body_' || g,
  timestamptz '2020-01-01' + (g * interval '2 minutes')
FROM generate_series(1, 1000000) AS g;

ANALYZE articles;
\endif
