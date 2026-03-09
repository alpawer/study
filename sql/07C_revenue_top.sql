USE wineshop;

-- 07C: Revenue + Top (15) using vw_order_totals / vw_orders_full

-- C01
SELECT ROUND(SUM(total_amount),2) AS total_revenue FROM vw_order_totals WHERE status='PAID';
-- C02
SELECT ROUND(AVG(total_amount),2) AS avg_check FROM vw_order_totals WHERE status='PAID';
-- C03
SELECT DATE_FORMAT(created_at,'%Y-%m') AS month,
       COUNT(*) AS paid_orders,
       ROUND(SUM(total_amount),2) AS revenue,
       ROUND(AVG(total_amount),2) AS avg_check
FROM vw_order_totals
WHERE status='PAID'
GROUP BY DATE_FORMAT(created_at,'%Y-%m')
ORDER BY month;
-- C04
SELECT DATE(created_at) AS day, COUNT(*) AS paid_orders, ROUND(SUM(total_amount),2) AS revenue
FROM vw_order_totals
WHERE status='PAID'
GROUP BY DATE(created_at)
ORDER BY day;
-- C05
SELECT c.id, c.name, c.email, COUNT(*) AS paid_orders, ROUND(SUM(t.total_amount),2) AS spent_total
FROM customers c
JOIN vw_order_totals t ON t.customer_id=c.id
WHERE t.status='PAID'
GROUP BY c.id, c.name, c.email
ORDER BY spent_total DESC
LIMIT 10;
-- C06
SELECT c.id, c.name, ROUND(AVG(t.total_amount),2) AS avg_check, ROUND(SUM(t.total_amount),2) AS spent_total
FROM customers c
JOIN vw_order_totals t ON t.customer_id=c.id
WHERE t.status='PAID'
GROUP BY c.id, c.name
ORDER BY spent_total DESC;
-- C07
SELECT order_id, customer_id, created_at, total_amount
FROM vw_order_totals
WHERE status='PAID'
ORDER BY total_amount DESC
LIMIT 10;
-- C08
SELECT status, COUNT(*) AS cnt FROM orders GROUP BY status ORDER BY cnt DESC;
-- C09
SELECT w.sku, w.name, SUM(oi.qty) AS bottles_sold
FROM orders o JOIN order_items oi ON oi.order_id=o.id JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.id, w.sku, w.name
ORDER BY bottles_sold DESC
LIMIT 10;
-- C10
SELECT w.sku, w.name, ROUND(SUM(oi.qty*oi.price_each),2) AS revenue
FROM orders o JOIN order_items oi ON oi.order_id=o.id JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.id, w.sku, w.name
ORDER BY revenue DESC
LIMIT 10;
-- C11
SELECT w.country, SUM(oi.qty) AS bottles_sold, ROUND(SUM(oi.qty*oi.price_each),2) AS revenue
FROM orders o JOIN order_items oi ON oi.order_id=o.id JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.country
ORDER BY revenue DESC;
-- C12
SELECT w.year, SUM(oi.qty) AS bottles_sold
FROM orders o JOIN order_items oi ON oi.order_id=o.id JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.year
ORDER BY w.year DESC;
-- C13
SELECT w.sku, w.name
FROM wines w
LEFT JOIN (SELECT DISTINCT oi.wine_id FROM orders o JOIN order_items oi ON oi.order_id=o.id WHERE o.status='PAID') sold
ON sold.wine_id=w.id
WHERE sold.wine_id IS NULL
ORDER BY w.name;
-- C14
SELECT sku, name, in_stock FROM wines ORDER BY in_stock ASC LIMIT 5;
-- C15
SELECT sku, name, country, year, in_stock, price
FROM wines
WHERE in_stock <= 30
ORDER BY in_stock ASC, price DESC;
