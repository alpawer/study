USE wineshop;

-- 07B: Orders with totals (15) using vw_orders_full / vw_order_totals

-- B01
SELECT order_id, customer_name, status, created_at, total_amount
FROM vw_orders_full ORDER BY created_at DESC LIMIT 10;
-- B02
SELECT order_id, customer_name, created_at, total_amount
FROM vw_orders_full WHERE status='PAID' ORDER BY created_at DESC;
-- B03
SELECT order_id, customer_name, created_at, total_amount
FROM vw_orders_full WHERE status='NEW' ORDER BY created_at DESC;
-- B04
SELECT order_id, customer_name, created_at, total_amount
FROM vw_orders_full WHERE status='CANCELLED' ORDER BY created_at DESC;
-- B05
SELECT order_id, customer_name, status, created_at, total_amount
FROM vw_orders_full ORDER BY total_amount DESC LIMIT 10;
-- B06
SELECT order_id, customer_name, status, created_at, total_amount
FROM vw_orders_full ORDER BY total_amount ASC LIMIT 10;
-- B07
SELECT order_id, customer_name, status, created_at, total_amount
FROM vw_orders_full
WHERE created_at >= '2026-03-01' AND created_at < '2026-04-01'
ORDER BY created_at;
-- B08
SELECT order_id, status, created_at, total_amount
FROM vw_orders_full
WHERE customer_email='olena@example.com'
ORDER BY created_at DESC;
-- B09
SELECT o.id AS order_id, w.sku, w.name AS wine, oi.qty, oi.price_each, (oi.qty*oi.price_each) AS line_total
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.id=1
ORDER BY w.name;
-- B10
SELECT o.id AS order_id, COUNT(oi.id) AS positions
FROM orders o LEFT JOIN order_items oi ON oi.order_id=o.id
GROUP BY o.id ORDER BY positions DESC, o.id;
-- B11
SELECT o.id AS order_id, SUM(oi.qty) AS total_bottles
FROM orders o JOIN order_items oi ON oi.order_id=o.id
GROUP BY o.id ORDER BY total_bottles DESC;
-- B12
SELECT o.id AS order_id, COUNT(*) AS positions
FROM orders o JOIN order_items oi ON oi.order_id=o.id
GROUP BY o.id HAVING positions >= 3 ORDER BY positions DESC;
-- B13
SELECT o.id AS order_id, SUM(oi.qty) AS total_bottles
FROM orders o JOIN order_items oi ON oi.order_id=o.id
GROUP BY o.id HAVING total_bottles > 5 ORDER BY total_bottles DESC;
-- B14
SELECT o.id, o.status, o.created_at
FROM orders o LEFT JOIN order_items oi ON oi.order_id=o.id
WHERE oi.id IS NULL;
-- B15
SELECT t.order_id,
       ROUND(t.total_amount,2) AS view_total,
       ROUND(COALESCE(x.recalc,0),2) AS recalculated_total
FROM vw_order_totals t
LEFT JOIN (SELECT order_id, SUM(qty*price_each) AS recalc FROM order_items GROUP BY order_id) x
ON x.order_id=t.order_id
ORDER BY t.order_id;
