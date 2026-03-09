#!/usr/bin/env bash
set -euo pipefail

DB="wineshop"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="$HOME/${DB}_run.log"
BACKUP="$HOME/${DB}_backup.sql"

MODE="${1:-random}"

run_mysql_file_log_only() {
  local file="$1"
  mysql -D "$DB" < "$file" >> "$LOG" 2>&1 || {
    echo "!! ERROR while running $file. See log: $LOG"
    exit 1
  }
}

run_sql_preview() {
  local label="$1"
  local file="$2"

  echo "==> ${label}"
  echo "---- (preview: first 25 lines) ----"

  mysql -D "$DB" < "$file" >> "$LOG" 2>&1 || {
    echo "!! ERROR while running $file. See log: $LOG"
    exit 1
  }

  mysql -D "$DB" < "$file" | head -n 25
  echo "---- end preview ----"
  echo
}

run_checks_preview() {
  echo "==> Checks"
  echo "---- (preview) ----"

  mysql -D "$DB" -e "
SELECT 'COUNTS' AS section;
SELECT
  (SELECT COUNT(*) FROM wines) AS wines,
  (SELECT COUNT(*) FROM customers) AS customers,
  (SELECT COUNT(*) FROM orders) AS orders,
  (SELECT COUNT(*) FROM order_items) AS order_items;

SELECT 'ORPHAN order_items -> orders' AS section;
SELECT COUNT(*) AS orphan_order_items_orders
FROM order_items oi
LEFT JOIN orders o ON o.id = oi.order_id
WHERE o.id IS NULL;

SELECT 'ORPHAN orders -> customers' AS section;
SELECT COUNT(*) AS orphan_orders_customers
FROM orders o
LEFT JOIN customers c ON c.id = o.customer_id
WHERE c.id IS NULL;

SELECT 'ORPHAN order_items -> wines' AS section;
SELECT COUNT(*) AS orphan_order_items_wines
FROM order_items oi
LEFT JOIN wines w ON w.id = oi.wine_id
WHERE w.id IS NULL;

SELECT 'NULL CHECKS' AS section;
SELECT
  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS wines_id_nulls
FROM wines;

SELECT
  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS customers_id_nulls
FROM customers;

SELECT
  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS orders_id_nulls,
  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS orders_customer_id_nulls
FROM orders;

SELECT
  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS order_items_id_nulls,
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_items_order_id_nulls,
  SUM(CASE WHEN wine_id IS NULL THEN 1 ELSE 0 END) AS order_items_wine_id_nulls
FROM order_items;

SELECT 'BAD VALUES' AS section;
SELECT
  SUM(CASE WHEN qty <= 0 THEN 1 ELSE 0 END) AS bad_qty,
  SUM(CASE WHEN price_each < 0 THEN 1 ELSE 0 END) AS bad_price
FROM order_items;
" >> "$LOG" 2>&1 || {
    echo "!! ERROR while running checks. See log: $LOG"
    exit 1
  }

  mysql -D "$DB" -e "
SELECT 'COUNTS' AS section;
SELECT
  (SELECT COUNT(*) FROM wines) AS wines,
  (SELECT COUNT(*) FROM customers) AS customers,
  (SELECT COUNT(*) FROM orders) AS orders,
  (SELECT COUNT(*) FROM order_items) AS order_items;

SELECT 'ORPHAN order_items -> orders' AS section;
SELECT COUNT(*) AS orphan_order_items_orders
FROM order_items oi
LEFT JOIN orders o ON o.id = oi.order_id
WHERE o.id IS NULL;

SELECT 'ORPHAN orders -> customers' AS section;
SELECT COUNT(*) AS orphan_orders_customers
FROM orders o
LEFT JOIN customers c ON c.id = o.customer_id
WHERE c.id IS NULL;

SELECT 'ORPHAN order_items -> wines' AS section;
SELECT COUNT(*) AS orphan_order_items_wines
FROM order_items oi
LEFT JOIN wines w ON w.id = oi.wine_id
WHERE w.id IS NULL;

SELECT 'NULL CHECKS' AS section;
SELECT
  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS wines_id_nulls
FROM wines;

SELECT
  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS customers_id_nulls
FROM customers;

SELECT
  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS orders_id_nulls,
  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS orders_customer_id_nulls
FROM orders;

SELECT
  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS order_items_id_nulls,
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_items_order_id_nulls,
  SUM(CASE WHEN wine_id IS NULL THEN 1 ELSE 0 END) AS order_items_wine_id_nulls
FROM order_items;

SELECT 'BAD VALUES' AS section;
SELECT
  SUM(CASE WHEN qty <= 0 THEN 1 ELSE 0 END) AS bad_qty,
  SUM(CASE WHEN price_each < 0 THEN 1 ELSE 0 END) AS bad_price
FROM order_items;
" | head -n 80

  echo "---- end preview ----"
  echo
}

case "$MODE" in
  fixed)
    SEED_FILE="$DIR/02_seed_wineshop_big.sql"
    DO_SEED="yes"
    ;;
  random)
    SEED_FILE="$DIR/02_seed_wineshop_random.sql"
    DO_SEED="yes"
    ;;
  check)
    SEED_FILE=""
    DO_SEED="no"
    ;;
  *)
    echo "Usage: $0 [fixed|random|check]"
    exit 1
    ;;
esac

echo "==> Using SQL directory: $DIR"
echo "==> Log file: $LOG"
echo "==> Mode: $MODE"
if [[ "$DO_SEED" == "yes" ]]; then
  echo "==> Seed file: $SEED_FILE"
else
  echo "==> Seed step skipped"
fi

: > "$LOG"

echo "==> Checking DB exists: $DB"
mysql -D "$DB" -e "SELECT 'OK' AS connected;" >/dev/null

if [[ "$DO_SEED" == "yes" ]]; then
  echo "==> Seeding data... (log only)"
  run_mysql_file_log_only "$SEED_FILE"
fi

run_checks_preview
run_sql_preview "Reports (04_reports.sql)" "$DIR/04_reports.sql"
run_sql_preview "Examples 07A (wines)" "$DIR/07A_wines_filters.sql"
run_sql_preview "Examples 07B (orders)" "$DIR/07B_orders_totals.sql"
run_sql_preview "Examples 07C (revenue/top)" "$DIR/07C_revenue_top.sql"
run_sql_preview "Examples 07D (join/group by)" "$DIR/07D_join_groupby.sql"

echo "==> Creating backup: $BACKUP"
mysqldump --no-tablespaces "$DB" > "$BACKUP"
ls -lh "$BACKUP"

echo "==> Done."
echo "==> Full output saved to: $LOG"