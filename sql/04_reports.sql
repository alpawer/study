USE wineshop;

-- 0) Контроль кількості
SELECT
  (SELECT COUNT(*) FROM wines)       AS wines_count,
  (SELECT COUNT(*) FROM customers)   AS customers_count,
  (SELECT COUNT(*) FROM orders)      AS orders_count,
  (SELECT COUNT(*) FROM order_items) AS items_count;

-- 1) Список замовлень з total (рахується з VIEW order_totals)
SELECT ot.order_id, c.name AS customer, ot.status, ot.created_at, ot.total_amount
FROM order_totals ot
JOIN customers c ON c.id = ot.customer_id
ORDER BY ot.created_at DESC;

-- 2) Деталі одного замовлення (поміняй WHERE ot.order_id = 1)
SELECT o.id AS order_id, c.name AS customer, o.status, o.created_at,
       w.sku, w.name AS wine, oi.qty, oi.price_each, (oi.qty*oi.price_each) AS line_total
FROM orders o
JOIN customers c ON c.id = o.customer_id
JOIN order_items oi ON oi.order_id = o.id
JOIN wines w ON w.id = oi.wine_id
WHERE o.id = 1
ORDER BY w.name;

-- 3) Виручка по місяцях (тільки PAID)
SELECT DATE_FORMAT(ot.created_at, '%Y-%m') AS month,
       COUNT(*) AS paid_orders,
       ROUND(SUM(ot.total_amount), 2) AS revenue,
       ROUND(AVG(ot.total_amount), 2) AS avg_check
FROM order_totals ot
WHERE ot.status='PAID'
GROUP BY DATE_FORMAT(ot.created_at, '%Y-%m')
ORDER BY month;

-- 4) Виручка по країнах (тільки PAID)
SELECT w.country,
       SUM(oi.qty) AS bottles_sold,
       ROUND(SUM(oi.qty*oi.price_each),2) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.country
ORDER BY revenue DESC;

-- 5) Топ 10 SKU за виручкою (PAID)
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

-- 6) Топ клієнтів за витратами (PAID)
SELECT c.id, c.name, c.email,
       COUNT(*) AS paid_orders,
       ROUND(SUM(ot.total_amount),2) AS spent_total
FROM customers c
JOIN order_totals ot ON ot.customer_id=c.id
WHERE ot.status='PAID'
GROUP BY c.id, c.name, c.email
ORDER BY spent_total DESC;

-- 7) “Погані” замовлення: без позицій
SELECT o.id, o.status, o.created_at
FROM orders o
LEFT JOIN order_items oi ON oi.order_id=o.id
WHERE oi.id IS NULL
ORDER BY o.id;

-- 8) Склад: що закінчується (поріг 30)
SELECT sku, name, country, year, in_stock, price
FROM wines
WHERE in_stock <= 30
ORDER BY in_stock ASC, price DESC;

-- 9) Асортимент: фільтр ціни + країни
SELECT sku, name, country, year, price
FROM wines
WHERE country IN ('France','Italy','Spain')
  AND price BETWEEN 10 AND 25
ORDER BY price;

-- 10) Частка статусів
SELECT status, COUNT(*) AS cnt
FROM orders
GROUP BY status
ORDER BY cnt DESC;
