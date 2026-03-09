USE wineshop;

-- =========================================================
-- 07_examples_4x15.sql
-- 4 блоки по 15 прикладів:
-- A) Wines: список вин + фільтри (15)
-- B) Orders: замовлення з сумами (15)
-- C) Revenue/Top: топ клієнтів / виручка (15)
-- D) Training: JOIN / GROUP BY (15)
-- Використовує VIEW: vw_order_totals, vw_orders_full
-- =========================================================

-- =========================
-- A) WINES + FILTERS (15)
-- =========================

-- A01: Перші 10 вин за алфавітом
SELECT sku, name, country, year, price, in_stock
FROM wines
ORDER BY name
LIMIT 10;

-- A02: Топ-10 найдорожчих
SELECT sku, name, price
FROM wines
ORDER BY price DESC
LIMIT 10;

-- A03: Найдешевші 10
SELECT sku, name, price
FROM wines
ORDER BY price ASC
LIMIT 10;

-- A04: Вина по країні (France)
SELECT sku, name, year, price
FROM wines
WHERE country='France'
ORDER BY price DESC;

-- A05: Вина по країні (Italy)
SELECT sku, name, year, price
FROM wines
WHERE country='Italy'
ORDER BY price DESC;

-- A06: Ціна між 10 і 20
SELECT sku, name, country, price
FROM wines
WHERE price BETWEEN 10 AND 20
ORDER BY price;

-- A07: Рік >= 2022
SELECT sku, name, country, year, price
FROM wines
WHERE year >= 2022
ORDER BY year DESC, price DESC;

-- A08: Пошук по назві (містить 'Cab')
SELECT sku, name, price
FROM wines
WHERE name LIKE '%Cab%'
ORDER BY price DESC;

-- A09: Пошук по опису (містить 'oak')
SELECT sku, name, country, price
FROM wines
WHERE description LIKE '%oak%'
ORDER BY price DESC;

-- A10: Закінчується на складі (<=30)
SELECT sku, name, in_stock, price
FROM wines
WHERE in_stock <= 30
ORDER BY in_stock ASC, price DESC;

-- A11: Розподіл вин по країнах
SELECT country, COUNT(*) AS wines_count
FROM wines
GROUP BY country
ORDER BY wines_count DESC, country;

-- A12: Середня ціна по країнах (тільки де >=2 вин)
SELECT country, ROUND(AVG(price),2) AS avg_price, COUNT(*) AS cnt
FROM wines
GROUP BY country
HAVING cnt >= 2
ORDER BY avg_price DESC;

-- A13: ТОП-5 країн за середньою ціною
SELECT country, ROUND(AVG(price),2) AS avg_price
FROM wines
GROUP BY country
ORDER BY avg_price DESC
LIMIT 5;

-- A14: Середня/мін/макс ціна
SELECT ROUND(AVG(price),2) AS avg_price, MIN(price) AS min_price, MAX(price) AS max_price
FROM wines;

-- A15: Вина, що дорожчі за середню ціну
SELECT sku, name, price
FROM wines
WHERE price > (SELECT AVG(price) FROM wines)
ORDER BY price DESC;


-- =========================
-- B) ORDERS WITH TOTALS (15)
-- =========================

-- B01: Останні 10 замовлень (повна вітрина)
SELECT order_id, customer_name, status, created_at, total_amount
FROM vw_orders_full
ORDER BY created_at DESC
LIMIT 10;

-- B02: Усі PAID замовлення за датою
SELECT order_id, customer_name, created_at, total_amount
FROM vw_orders_full
WHERE status='PAID'
ORDER BY created_at DESC;

-- B03: Усі NEW замовлення
SELECT order_id, customer_name, created_at, total_amount
FROM vw_orders_full
WHERE status='NEW'
ORDER BY created_at DESC;

-- B04: Усі CANCELLED замовлення
SELECT order_id, customer_name, created_at, total_amount
FROM vw_orders_full
WHERE status='CANCELLED'
ORDER BY created_at DESC;

-- B05: Найбільші 10 замовлень (за сумою)
SELECT order_id, customer_name, status, created_at, total_amount
FROM vw_orders_full
ORDER BY total_amount DESC
LIMIT 10;

-- B06: Найменші 10 замовлень (за сумою)
SELECT order_id, customer_name, status, created_at, total_amount
FROM vw_orders_full
ORDER BY total_amount ASC
LIMIT 10;

-- B07: Замовлення в конкретному місяці (наприклад 2026-03)
SELECT order_id, customer_name, status, created_at, total_amount
FROM vw_orders_full
WHERE created_at >= '2026-03-01' AND created_at < '2026-04-01'
ORDER BY created_at;

-- B08: Замовлення конкретного клієнта (за email)
SELECT order_id, status, created_at, total_amount
FROM vw_orders_full
WHERE customer_email='olena@example.com'
ORDER BY created_at DESC;

-- B09: Деталі позицій для order_id=1
SELECT o.id AS order_id, w.sku, w.name AS wine, oi.qty, oi.price_each,
       (oi.qty*oi.price_each) AS line_total
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.id=1
ORDER BY w.name;

-- B10: Скільки позицій у кожному замовленні
SELECT o.id AS order_id, COUNT(oi.id) AS positions
FROM orders o
LEFT JOIN order_items oi ON oi.order_id=o.id
GROUP BY o.id
ORDER BY positions DESC, o.id;

-- B11: Скільки пляшок у кожному замовленні (sum qty)
SELECT o.id AS order_id, SUM(oi.qty) AS total_bottles
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
GROUP BY o.id
ORDER BY total_bottles DESC;

-- B12: Замовлення з 3+ різними позиціями
SELECT o.id AS order_id, COUNT(*) AS positions
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
GROUP BY o.id
HAVING positions >= 3
ORDER BY positions DESC;

-- B13: Замовлення, де сумарно > 5 пляшок
SELECT o.id AS order_id, SUM(oi.qty) AS total_bottles
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
GROUP BY o.id
HAVING total_bottles > 5
ORDER BY total_bottles DESC;

-- B14: Замовлення без позицій (має бути 0)
SELECT o.id, o.status, o.created_at
FROM orders o
LEFT JOIN order_items oi ON oi.order_id=o.id
WHERE oi.id IS NULL;

-- B15: Перевірка total: звірити view vs перерахунок з order_items
SELECT t.order_id,
       ROUND(t.total_amount,2) AS view_total,
       ROUND(COALESCE(x.recalc,0),2) AS recalculated_total
FROM vw_order_totals t
LEFT JOIN (
  SELECT order_id, SUM(qty*price_each) AS recalc
  FROM order_items
  GROUP BY order_id
) x ON x.order_id=t.order_id
ORDER BY t.order_id;


-- =========================
-- C) TOP CLIENTS / REVENUE (15)
-- =========================

-- C01: Загальна виручка (PAID)
SELECT ROUND(SUM(total_amount),2) AS total_revenue
FROM vw_order_totals
WHERE status='PAID';

-- C02: Середній чек (PAID)
SELECT ROUND(AVG(total_amount),2) AS avg_check
FROM vw_order_totals
WHERE status='PAID';

-- C03: Виручка по місяцях (PAID)
SELECT DATE_FORMAT(created_at,'%Y-%m') AS month,
       COUNT(*) AS paid_orders,
       ROUND(SUM(total_amount),2) AS revenue,
       ROUND(AVG(total_amount),2) AS avg_check
FROM vw_order_totals
WHERE status='PAID'
GROUP BY DATE_FORMAT(created_at,'%Y-%m')
ORDER BY month;

-- C04: Виручка по днях (PAID)
SELECT DATE(created_at) AS day,
       COUNT(*) AS paid_orders,
       ROUND(SUM(total_amount),2) AS revenue
FROM vw_order_totals
WHERE status='PAID'
GROUP BY DATE(created_at)
ORDER BY day;

-- C05: Топ-10 клієнтів за витратами (PAID)
SELECT c.id, c.name, c.email,
       COUNT(*) AS paid_orders,
       ROUND(SUM(t.total_amount),2) AS spent_total
FROM customers c
JOIN vw_order_totals t ON t.customer_id=c.id
WHERE t.status='PAID'
GROUP BY c.id, c.name, c.email
ORDER BY spent_total DESC
LIMIT 10;

-- C06: Середній чек по клієнтах (PAID)
SELECT c.id, c.name,
       ROUND(AVG(t.total_amount),2) AS avg_check,
       ROUND(SUM(t.total_amount),2) AS spent_total
FROM customers c
JOIN vw_order_totals t ON t.customer_id=c.id
WHERE t.status='PAID'
GROUP BY c.id, c.name
ORDER BY spent_total DESC;

-- C07: Топ-10 замовлень за сумою (PAID)
SELECT order_id, customer_id, created_at, total_amount
FROM vw_order_totals
WHERE status='PAID'
ORDER BY total_amount DESC
LIMIT 10;

-- C08: Частка статусів замовлень
SELECT status, COUNT(*) AS cnt
FROM orders
GROUP BY status
ORDER BY cnt DESC;

-- C09: Топ SKU за кількістю (PAID)
SELECT w.sku, w.name, SUM(oi.qty) AS bottles_sold
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.id, w.sku, w.name
ORDER BY bottles_sold DESC
LIMIT 10;

-- C10: Топ SKU за виручкою (PAID)
SELECT w.sku, w.name,
       ROUND(SUM(oi.qty*oi.price_each),2) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.id, w.sku, w.name
ORDER BY revenue DESC
LIMIT 10;

-- C11: Продажі по країнах (PAID)
SELECT w.country,
       SUM(oi.qty) AS bottles_sold,
       ROUND(SUM(oi.qty*oi.price_each),2) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.country
ORDER BY revenue DESC;

-- C12: Продажі по роках вина (PAID)
SELECT w.year, SUM(oi.qty) AS bottles_sold
FROM orders o
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
GROUP BY w.year
ORDER BY w.year DESC;

-- C13: Які вина не купували в PAID замовленнях
SELECT w.sku, w.name
FROM wines w
LEFT JOIN (
  SELECT DISTINCT oi.wine_id
  FROM orders o
  JOIN order_items oi ON oi.order_id=o.id
  WHERE o.status='PAID'
) sold ON sold.wine_id=w.id
WHERE sold.wine_id IS NULL
ORDER BY w.name;

-- C14: Склад — топ-5 найменших залишків
SELECT sku, name, in_stock
FROM wines
ORDER BY in_stock ASC
LIMIT 5;

-- C15: Склад — список “потрібно дозамовити” (<= 30)
SELECT sku, name, country, year, in_stock, price
FROM wines
WHERE in_stock <= 30
ORDER BY in_stock ASC, price DESC;


-- =========================
-- D) TRAINING JOIN / GROUP BY (15)
-- =========================

-- D01: JOIN orders + customers (базовий)
SELECT o.id AS order_id, c.name AS customer, o.status, o.created_at
FROM orders o
JOIN customers c ON c.id=o.customer_id
ORDER BY o.id;

-- D02: LEFT JOIN: клієнти + кількість замовлень (включно з 0)
SELECT c.id, c.name, COUNT(o.id) AS orders_count
FROM customers c
LEFT JOIN orders o ON o.customer_id=c.id
GROUP BY c.id, c.name
ORDER BY orders_count DESC, c.id;

-- D03: JOIN + GROUP: скільки позицій у кожного клієнта (в усіх замовленнях)
SELECT c.id, c.name, COUNT(oi.id) AS items_rows
FROM customers c
JOIN orders o ON o.customer_id=c.id
JOIN order_items oi ON oi.order_id=o.id
GROUP BY c.id, c.name
ORDER BY items_rows DESC;

-- D04: JOIN + GROUP: скільки пляшок купив кожен клієнт (PAID)
SELECT c.id, c.name, SUM(oi.qty) AS bottles_bought
FROM customers c
JOIN orders o ON o.customer_id=c.id
JOIN order_items oi ON oi.order_id=o.id
WHERE o.status='PAID'
GROUP BY c.id, c.name
ORDER BY bottles_bought DESC;

-- D05: JOIN + GROUP: середня ціна позиції у замовленнях (PAID) по клієнтах
SELECT c.id, c.name, ROUND(AVG(oi.price_each),2) AS avg_item_price
FROM customers c
JOIN orders o ON o.customer_id=c.id
JOIN order_items oi ON oi.order_id=o.id
WHERE o.status='PAID'
GROUP BY c.id, c.name
ORDER BY avg_item_price DESC;

-- D06: HAVING: клієнти, що витратили більше 120 (PAID)
SELECT c.id, c.name, ROUND(SUM(t.total_amount),2) AS spent
FROM customers c
JOIN vw_order_totals t ON t.customer_id=c.id
WHERE t.status='PAID'
GROUP BY c.id, c.name
HAVING spent > 120
ORDER BY spent DESC;

-- D07: Підзапит: замовлення, більші за середній чек (PAID)
SELECT order_id, total_amount
FROM vw_order_totals
WHERE status='PAID'
  AND total_amount > (SELECT AVG(total_amount) FROM vw_order_totals WHERE status='PAID')
ORDER BY total_amount DESC;

-- D08: Підзапит: топ-3 країни за виручкою (PAID)
SELECT country, revenue
FROM (
  SELECT w.country AS country, SUM(oi.qty*oi.price_each) AS revenue
  FROM orders o
  JOIN order_items oi ON oi.order_id=o.id
  JOIN wines w ON w.id=oi.wine_id
  WHERE o.status='PAID'
  GROUP BY w.country
) x
ORDER BY revenue DESC
LIMIT 3;

-- D09: CO-PURCHASE: що купують разом з wine_id=4 (ко-купівлі)
SELECT w2.sku, w2.name, COUNT(*) AS together_count
FROM order_items a
JOIN order_items b ON b.order_id=a.order_id AND b.wine_id <> a.wine_id
JOIN wines w2 ON w2.id=b.wine_id
WHERE a.wine_id = 4
GROUP BY w2.id, w2.sku, w2.name
ORDER BY together_count DESC, w2.name
LIMIT 10;

-- D10: Найдорожче вино у кожній країні
SELECT w.country, w.sku, w.name, w.price
FROM wines w
JOIN (
  SELECT country, MAX(price) AS max_price
  FROM wines
  GROUP BY country
) mx ON mx.country=w.country AND mx.max_price=w.price
ORDER BY w.price DESC;

-- D11: Вина дорожче за середню по країні
SELECT w.country, w.sku, w.name, w.price, ROUND(ca.avg_price,2) AS country_avg
FROM wines w
JOIN (
  SELECT country, AVG(price) AS avg_price
  FROM wines
  GROUP BY country
) ca ON ca.country=w.country
WHERE w.price > ca.avg_price
ORDER BY w.country, w.price DESC;

-- D12: Розклад по статусах для кожного клієнта
SELECT c.id, c.name,
       SUM(o.status='NEW') AS new_cnt,
       SUM(o.status='PAID') AS paid_cnt,
       SUM(o.status='CANCELLED') AS cancelled_cnt
FROM customers c
LEFT JOIN orders o ON o.customer_id=c.id
GROUP BY c.id, c.name
ORDER BY paid_cnt DESC, c.id;

-- D13: Топ-5 клієнтів за кількістю PAID замовлень
SELECT c.id, c.name, COUNT(*) AS paid_orders
FROM customers c
JOIN orders o ON o.customer_id=c.id
WHERE o.status='PAID'
GROUP BY c.id, c.name
ORDER BY paid_orders DESC
LIMIT 5;

-- D14: “Вітрина” позицій: PAID замовлення з товарами (перші 25 рядків)
SELECT o.id AS order_id, c.name AS customer, w.sku, w.name AS wine, oi.qty, oi.price_each
FROM orders o
JOIN customers c ON c.id=o.customer_id
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE o.status='PAID'
ORDER BY o.created_at DESC
LIMIT 25;

-- D15: Вибірка: знайти всі замовлення, де є конкретний SKU (наприклад Prosecco)
SELECT DISTINCT o.id AS order_id, c.name AS customer, o.status, o.created_at
FROM orders o
JOIN customers c ON c.id=o.customer_id
JOIN order_items oi ON oi.order_id=o.id
JOIN wines w ON w.id=oi.wine_id
WHERE w.sku='WINE-IT-PRO-2022'
ORDER BY o.created_at DESC;

