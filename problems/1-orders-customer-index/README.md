# 問題1: 顧客IDで注文を探すと全件スキャン（再現環境）

問題文: https://github.com/tentaShiratori/db-performance/issues/1

## 起動

```sh
cd problems/1-orders-customer-index
docker compose up -d
docker compose logs -f db   # 「database system is ready to accept connections」が出るまで待つ（データ生成に少し時間がかかる）
```

## 接続

```sh
docker compose exec db psql -U postgres -d dojo
```

行数確認:

```sql
SELECT relname, reltuples FROM pg_class WHERE relname IN ('customers','orders');
```

## 遅いクエリを実行

```sh
docker compose exec -T db psql -U postgres -d dojo < slow_query.sql
```

## リセット（データを作り直す）

```sh
docker compose down -v
docker compose up -d
```

`-v` でボリュームごと消えるので、次回起動時に初期化SQLが再実行される。
