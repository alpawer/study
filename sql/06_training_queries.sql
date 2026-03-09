USE wineshop;

-- ==========================================
-- 06_training_queries.sql
-- Тренувальні запити (SELECT-only)
-- Таблиці: wines, customers, orders, order_items
-- VIEW: vw_order_totals, vw_orders_full
-- ==========================================

-- Q01: Показати 10 перших вин за алфавітом
SELECT sku, name, country, year, price
FROM wines
ORDER BY name
LIMIT 10;

-- Q02: Вина, де ціна > 20
SELECT sku, name, price
FROM wines
WHERE price > 20
ORDER BY price DESC;

-- Q03: Вина з країни France
SELECT sku, name, year, price
FROM wines
WHERE country='France'
ORDER BY year DESC;

-- Q04: Вина 2022+ (нові)
SELECT sku, name, country, year, price
FROM wines
WHERE year >= 2022
ORDER BY year DESC, price DESC;

-- Q05: Вина, які закінчуються (in_stock <= 30)
SELECT sku, name, in_stock
FROM wines
WHERE in_stock <= 30
ORDER BY in_stock ASC;

-- Q06: Середня/мін/макс ціна по всьому асортименту
SELECT ROUND(AVG(price),2) AS avg_price, MIN(price) AS min_price, MAX(price) AS max_price
FROM wines;

-- Q07: Скільки вин по країнах
SELECT country, COUNT(*) AS wines_count
FROM wines
GROUP BY country
ORDER BY wines_count DESC, country;

-- Q08: Середня ціна по країнах (показати тільки країни з >=2 вин)
SELECT country, ROUND(AVG(price),2) AS avg_price, COUNT(*) AS cnt
FROM wines
GROUP BY country
HAVING cnt >= 2
ORDER BY avg_price DESC;

-- Q09: Пошук по назві (містить 'Cab')
SELECT sku, name, price
FROM wines
WHERE name LIKE '%Cab%'
ORDER BY price DESC;

-- Q10: Топ-5 найдорожчих вин
SELECT sku, name, price
FROM wines
ORDER BY price DESC
LIMIT 5;

-- Q11: Показати всіх клієнтів (id, name, email)
SELECT id, name, email
FROM customers
ORDER BY id;

-- Q12: Клієнти, у кого email з 'example'
SELECT id, name, email
FROM customers
WHERE email LIKE '%example%'
ORDER BY name;

-- Q13: Кількість замовлень у кожного клієнта (включно з тими, у кого 0)
SELECT c.id, c.name, COUNT(o.id) AS orders_count
FROM customers c
LEFT JOIN orders o ON o.customer_id=c.id
GROUP BY c.id, c.name
ORDER BY orders_count DESC, c.id;

-- Q14: Клієнти без замовлень
SELECT c.id, c.name, c.email
FROM customers c
LEFT JOIN orders o ON o.customer_id=c.id
WHERE o.id IS NULL
ORDER BY c.id;

-- Q15: Останні 10 замовлень (повна вітрина)
SELECT order_id, customer_name, status, created_at, total_amount
FROM vw_orders_full
ORDER BY created_at DESC
LIMIT 10;

-- Q16: Замовлення зі статусом NEW
SELECT order_id, customer_name, created_at, total_amount
FROM vw_orders_full
WHERE status='NEW'
ORDER BY created_at DESC;

-- Q17: Замовлення зі статусом PAID, total_amount > 80
SELECT order_id, customer_name, created_at, total_amount
FROM vw_orders_full
WHERE status='PAID' AND total_amount > 80
ORDER BY total_amount DESC;

-- Q18: Скільки замовлень по статусах
SELECT status, COUNT(*) AS cnt
FROM orders
GROUP BY status
ORDER BY cnt DESC;

-- Q19: Виручка по місяцях (PAID)
SELECT DATE_FORMAT(created_at,'%Y-%m') AS month,
       COUNT(*) AS paid_orders,
       ROUND(SUM(total_amount),2) AS revenue,
       ROUND(AVG(total_amount),2) AS avg_check
FROM vw_order_totals
WHERE status='PAID'
GROUP BY DATE_FORMAT(created_at,'%Y-%m')
ORDER BY month;

-- Q20: Загальна виручка (PAID)
SELECT ROUND(SUM(total_amount),2) AS total_revenue
FROM vw_order_totals
WHERE status='PAID';

-- Q21: Середній чек (PAID)
SELECT ROUND(AVG(total_amount),2) AS avg_check
FROM vw_order_totals
WHERE status='PAID';

-- Q22: Топ-10 клієнтів за витратами (PAID)
SELECT c.id, c.name, c.email,
       COUNT(*) AS paid_orders,
       ROUND(SUM(t.total_amount),2) AS spent_total
FROM customers c
JOIN vw_order_totals t ON t.customer_id=c.id
WHERE t.status='PAID'
GROUP BY c.id, c.name, c.email
ORDER BY spent_total DESC
LIMIT 10;

-- Q23: Топ-10 замовлень за сумою (PAID)
SELECT order_id, customer_id, created_at, total_amount
FROM vw_order_totals
WHERE status='PAID'
ORDER BY total_amount DESC
LIMIT 10;

-- Q24: Деталі конкретного замовлення (order_id = 1)
SELECT o.id AS order_id, w.sku, w.name AS wine, oi.qty, oi.price_each,
       (oi.qty*oi.price_each) AS line_total
FROM order_items oi
JOIN orders o ON o.id=oi.order_id
JOIN wines w ON w.id=oi.wine_id
WHERE o.id=1
ORDER BY w.name;

-- Q25: Скільки позицій у кожному замовленні (items_count)
SELECT o.id AS order_id, COUNT(oi.id) AS items_count
FROM orders o
LEFT JOIN order_items oi ON oi.order_id=o.id
GROUP BY o.id
ORDER BY items_count DESC, order_id;

-- Q26: Замовлення без позицій (має бути 0)
SELECT o.id, o.status, o.created_at
FROM orders o
LEFT JOIN order_items oi ON oi.order_id=o.id
WHERE oi.id IS NULL;

-- Q27: Топ SKU за кількістю проданих пляшок (PAID)
SELECT w.sku, w.name, SUM(oi.qty) AS bottles_sold
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.id, w.sku, w.name
ORDER BY bottles_sold DESC
LIMIT 10;

-- Q28: Топ SKU за виручкою (PAID)
SELECT w.sku, w.name,
       ROUND(SUM(oi.qty*oi.price_each),2) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.id, w.sku, w.name
ORDER BY revenue DESC
LIMIT 10;

-- Q29: Продажі по країнах (PAID)
SELECT w.country,
       SUM(oi.qty) AS bottles_sold,
       ROUND(SUM(oi.qty*oi.price_each),2) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.country
ORDER BY revenue DESC;

-- Q30: Продажі по роках вина (PAID) — цікаво як “вік” продається
SELECT w.year, SUM(oi.qty) AS bottles_sold
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.year
ORDER BY w.year DESC;

-- Q31: Які вина ніхто не купував у PAID замовленнях
SELECT w.sku, w.name
FROM wines w
LEFT JOIN (
  SELECT DISTINCT oi.wine_id
  FROM orders o
  JOIN order_items oi ON oi.order_id=o.id
  WHERE o.status='PAID'
) sold ON sold.wine_id = w.id
WHERE sold.wine_id IS NULL
ORDER BY w.name;

-- Q32: Топ-5 клієнтів за кількістю PAID замовлень
SELECT c.id, c.name, COUNT(*) AS paid_orders
FROM customers c
JOIN vw_order_totals t ON t.customer_id=c.id
WHERE t.status='PAID'
GROUP BY c.id, c.name
ORDER BY paid_orders DESC
LIMIT 5;

-- Q33: “Середній чек” по кожному клієнту (PAID)
SELECT c.id, c.name,
       ROUND(AVG(t.total_amount),2) AS avg_check,
       ROUND(SUM(t.total_amount),2) AS spent_total
FROM customers c
JOIN vw_order_totals t ON t.customer_id=c.id
WHERE t.status='PAID'
GROUP BY c.id, c.name
ORDER BY spent_total DESC;

-- Q34: Найдорожче вино в кожній країні
SELECT w.country, w.sku, w.name, w.price
FROM wines w
JOIN (
  SELECT country, MAX(price) AS max_price
  FROM wines
  GROUP BY country
) mx ON mx.country=w.country AND mx.max_price=w.price
ORDER BY w.price DESC;

-- Q35: Вина, де ціна вище середньої по своїй країні
SELECT w.sku, w.name, w.country, w.price,
       ROUND(ca.avg_price,2) AS country_avg
FROM wines w
JOIN (
  SELECT country, AVG(price) AS avg_price
  FROM wines
  GROUP BY country
) ca ON ca.country=w.country
WHERE w.price > ca.avg_price
ORDER BY w.country, w.price DESC;

-- Q36: Перевірка totals: перерахунок total для кожного order_id прямо з order_items
SELECT o.id AS order_id,
       ROUND(COALESCE(SUM(oi.qty*oi.price_each),0),2) AS recalculated_total
FROM orders o
LEFT JOIN order_items oi ON oi.order_id=o.id
GROUP BY o.id
ORDER BY o.id;

-- Q37: Знайти замовлення клієнта за email (поміняй email)
SELECT f.order_id, f.customer_name, f.status, f.created_at, f.total_amount
FROM vw_orders_full f
WHERE f.customer_email='olena@example.com'
ORDER BY f.created_at DESC;

-- Q38: Замовлення, де купили більше 5 пляшок сумарно
SELECT o.id AS order_id,
       SUM(oi.qty) AS total_bottles
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
GROUP BY o.id
HAVING total_bottles > 5
ORDER BY total_bottles DESC;

-- Q39: Замовлення з 3+ різними позиціями
SELECT o.id AS order_id,
       COUNT(*) AS positions
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
GROUP BY o.id
HAVING positions >= 3
ORDER BY positions DESC;

-- Q40: Вина, які найчастіше купують разом з конкретним wine_id (наприклад, wine_id=4)
-- (ко-купівлі в одному замовленні)
SELECT w2.sku, w2.name, COUNT(*) AS together_count
FROM order_items a
JOIN order_items b ON b.order_id=a.order_id AND b.wine_id <> a.wine_id
JOIN wines w2 ON w2.id=b.wine_id
WHERE a.wine_id = 4
GROUP BY w2.id, w2.sku, w2.name
ORDER BY together_count DESC, w2.name
LIMIT 10;
