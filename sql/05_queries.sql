USE wineshop;

-- ==========================================
-- 05_queries.sql — набір запитів для тесту
-- Використовує VIEW: vw_order_totals, vw_orders_full
-- ==========================================

-- 0) Швидка статистика
SELECT
  (SELECT COUNT(*) FROM wines) AS wines,
  (SELECT COUNT(*) FROM customers) AS customers,
  (SELECT COUNT(*) FROM orders) AS orders,
  (SELECT COUNT(*) FROM order_items) AS items;

-- 1) ТОП-10 найдорожчих вин
SELECT sku, name, country, year, price, in_stock
FROM wines
ORDER BY price DESC
LIMIT 10;

-- 2) Вина по країні + ціна між 10 та 20
SELECT sku, name, country, price
FROM wines
WHERE country IN ('Italy','France','Spain')
  AND price BETWEEN 10 AND 20
ORDER BY price;

-- 3) Замовлення “повністю”: замовлення + клієнт + total
SELECT order_id, customer_name, status, created_at, total_amount
FROM vw_orders_full
ORDER BY created_at DESC;

-- 4) Деталі замовлення (поміняй order_id)
SELECT o.id AS order_id, c.name AS customer, o.status, o.created_at,
       w.sku, w.name AS wine, oi.qty, oi.price_each,
       (oi.qty * oi.price_each) AS line_total
FROM orders o
JOIN customers c ON c.id=o.customer_id
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.id = 1
ORDER BY w.name;

-- 5) Виручка по місяцях (PAID)
SELECT DATE_FORMAT(created_at,'%Y-%m') AS month,
       COUNT(*) AS paid_orders,
       ROUND(SUM(total_amount),2) AS revenue,
       ROUND(AVG(total_amount),2) AS avg_check
FROM vw_order_totals
WHERE status='PAID'
GROUP BY DATE_FORMAT(created_at,'%Y-%m')
ORDER BY month;

-- 6) Топ клієнтів за витратами (PAID)
SELECT c.id, c.name, c.email,
       COUNT(*) AS paid_orders,
       ROUND(SUM(t.total_amount),2) AS spent_total
FROM customers c
JOIN vw_order_totals t ON t.customer_id=c.id
WHERE t.status='PAID'
GROUP BY c.id, c.name, c.email
ORDER BY spent_total DESC
LIMIT 10;

-- 7) Топ SKU за виручкою (PAID)
SELECT w.sku, w.name,
       SUM(oi.qty) AS qty_sold,
       ROUND(SUM(oi.qty*oi.price_each),2) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.id, w.sku, w.name
ORDER BY revenue DESC
LIMIT 10;

-- 8) Виручка по країнах (PAID)
SELECT w.country,
       SUM(oi.qty) AS bottles_sold,
       ROUND(SUM(oi.qty*oi.price_each),2) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.country
ORDER BY revenue DESC;

-- 9) Замовлення без позицій
SELECT o.id, o.status, o.created_at
FROM orders o
LEFT JOIN order_items oi ON oi.order_id=o.id
WHERE oi.id IS NULL;

-- 10) Склад: що закінчується (<= 30)
SELECT sku, name, in_stock, price
FROM wines
WHERE in_stock <= 30
ORDER BY in_stock ASC, price DESC;
