USE wineshop;

-- 07D: Training JOIN / GROUP BY (15)

-- D01
SELECT o.id AS order_id, c.name AS customer, o.status, o.created_at
FROM orders o JOIN customers c ON c.id=o.customer_id
ORDER BY o.id;
-- D02
SELECT c.id, c.name, COUNT(o.id) AS orders_count
FROM customers c LEFT JOIN orders o ON o.customer_id=c.id
GROUP BY c.id, c.name
ORDER BY orders_count DESC, c.id;
-- D03
SELECT c.id, c.name, COUNT(oi.id) AS items_rows
FROM customers c JOIN orders o ON o.customer_id=c.id JOIN order_items oi ON oi.order_id=o.id
GROUP BY c.id, c.name
ORDER BY items_rows DESC;
-- D04
SELECT c.id, c.name, SUM(oi.qty) AS bottles_bought
FROM customers c JOIN orders o ON o.customer_id=c.id JOIN order_items oi ON oi.order_id=o.id
WHERE o.status='PAID'
GROUP BY c.id, c.name
ORDER BY bottles_bought DESC;
-- D05
SELECT c.id, c.name, ROUND(AVG(oi.price_each),2) AS avg_item_price
FROM customers c JOIN orders o ON o.customer_id=c.id JOIN order_items oi ON oi.order_id=o.id
WHERE o.status='PAID'
GROUP BY c.id, c.name
ORDER BY avg_item_price DESC;
-- D06
SELECT c.id, c.name, ROUND(SUM(t.total_amount),2) AS spent
FROM customers c JOIN vw_order_totals t ON t.customer_id=c.id
WHERE t.status='PAID'
GROUP BY c.id, c.name
HAVING spent > 120
ORDER BY spent DESC;
-- D07
SELECT order_id, total_amount
FROM vw_order_totals
WHERE status='PAID'
  AND total_amount > (SELECT AVG(total_amount) FROM vw_order_totals WHERE status='PAID')
ORDER BY total_amount DESC;
-- D08
SELECT country, revenue
FROM (
  SELECT w.country AS country, SUM(oi.qty*oi.price_each) AS revenue
  FROM orders o JOIN order_items oi ON oi.order_id=o.id JOIN wines w ON w.id=oi.wine_id
  WHERE o.status='PAID'
  GROUP BY w.country
) x
ORDER BY revenue DESC
LIMIT 3;
-- D09
SELECT w2.sku, w2.name, COUNT(*) AS together_count
FROM order_items a
JOIN order_items b ON b.order_id=a.order_id AND b.wine_id <> a.wine_id
JOIN wines w2 ON w2.id=b.wine_id
WHERE a.wine_id = 4
GROUP BY w2.id, w2.sku, w2.name
ORDER BY together_count DESC, w2.name
LIMIT 10;
-- D10
SELECT w.country, w.sku, w.name, w.price
FROM wines w
JOIN (SELECT country, MAX(price) AS max_price FROM wines GROUP BY country) mx
ON mx.country=w.country AND mx.max_price=w.price
ORDER BY w.price DESC;
-- D11
SELECT w.country, w.sku, w.name, w.price, ROUND(ca.avg_price,2) AS country_avg
FROM wines w
JOIN (SELECT country, AVG(price) AS avg_price FROM wines GROUP BY country) ca
ON ca.country=w.country
WHERE w.price > ca.avg_price
ORDER BY w.country, w.price DESC;
-- D12
SELECT c.id, c.name,
       SUM(o.status='NEW') AS new_cnt,
       SUM(o.status='PAID') AS paid_cnt,
       SUM(o.status='CANCELLED') AS cancelled_cnt
FROM customers c
LEFT JOIN orders o ON o.customer_id=c.id
GROUP BY c.id, c.name
ORDER BY paid_cnt DESC, c.id;
-- D13
SELECT c.id, c.name, COUNT(*) AS paid_orders
FROM customers c JOIN orders o ON o.customer_id=c.id
WHERE o.status='PAID'
GROUP BY c.id, c.name
ORDER BY paid_orders DESC
LIMIT 5;
-- D14
SELECT o.id AS order_id, c.name AS customer, w.sku, w.name AS wine, oi.qty, oi.price_each
FROM orders o
JOIN customers c ON c.id=o.customer_id
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
ORDER BY o.created_at DESC
LIMIT 25;
-- D15
SELECT DISTINCT o.id AS order_id, c.name AS customer, o.status, o.created_at
FROM orders o
JOIN customers c ON c.id=o.customer_id
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE w.sku='WINE-IT-PRO-2022'
ORDER BY o.created_at DESC;
