# 問題5: 深い OFFSET ページネーション（再現環境）

問題文: https://github.com/tentaShiratori/db-performance/issues/5

## 起動

リポジトリルートで共有 PostgreSQL を起動する。

```sh
docker compose up -d
docker compose logs -f db   # 「database system is ready to accept connections」が出るまで待つ
```

## 初期化

問題用データベース `5-articles-deep-offset` を作り、スキーマとデータを投入する（データ生成に少し時間がかかる）。

```sh
mise run problem5-init
```

## 接続

```sh
docker compose exec db psql -U postgres -d "5-articles-deep-offset"
```

行数確認:

```sql
SELECT relname, reltuples FROM pg_class WHERE relname = 'articles';
```

## 遅いクエリを実行

```sh
mise run problem5-run
```

## リセット（データを作り直す）

```sh
docker compose exec -T db psql -U postgres -d postgres -c 'DROP DATABASE IF EXISTS "5-articles-deep-offset"'
mise run problem5-init
```

共有 DB ごと消す場合:

```sh
docker compose down -v
docker compose up -d
mise run problem5-init
```
