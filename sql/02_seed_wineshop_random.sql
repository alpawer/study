USE wineshop;

SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE order_items;
TRUNCATE TABLE orders;
TRUNCATE TABLE wines;
TRUNCATE TABLE customers;
SET FOREIGN_KEY_CHECKS=1;

-- =========================
-- RANDOM WINES
-- =========================
INSERT INTO wines (sku, name, description, country, year, price, in_stock) VALUES
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Cabernet Sauvignon', 'Dry red wine', 'France', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Merlot', 'Soft red wine', 'Italy', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Pinot Noir', 'Elegant red wine', 'Spain', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Sauvignon Blanc', 'Fresh white wine', 'New Zealand', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Chardonnay', 'Balanced white wine', 'USA', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Riesling', 'Crisp aromatic white wine', 'Germany', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Malbec', 'Dark fruit red wine', 'Argentina', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Syrah', 'Bold spicy red wine', 'Australia', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Prosecco', 'Sparkling white wine', 'Italy', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Rose', 'Light rose wine', 'Portugal', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Zinfandel', 'Rich red wine', 'USA', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Tempranillo', 'Spanish red wine', 'Spain', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Saperavi', 'Deep colored red wine', 'Georgia', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Tokaji', 'Sweet dessert wine', 'Hungary', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Albarino', 'Fresh citrus white wine', 'Spain', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Chianti', 'Classic Italian red', 'Italy', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Bordeaux', 'Oak-aged French red', 'France', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Carmenere', 'Herbal smooth red', 'Chile', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Pinot Grigio', 'Clean white wine', 'Austria', 2018 + FLOOR(RAND()*7), ROUND(10 + RAND()*40,2), FLOOR(10 + RAND()*200)),
(CONCAT('WINE-', UPPER(SUBSTRING(MD5(RAND()),1,8))), 'Champagne Brut', 'Premium sparkling wine', 'France', 2018 + FLOOR(RAND()*7), ROUND(25 + RAND()*50,2), FLOOR(5 + RAND()*80));

-- =========================
-- RANDOM CUSTOMERS
-- =========================
INSERT INTO customers (name, email) VALUES
('Robert', CONCAT('robert', FLOOR(RAND()*10000), '@example.com')),
('Olena', CONCAT('olena', FLOOR(RAND()*10000), '@example.com')),
('Max', CONCAT('max', FLOOR(RAND()*10000), '@example.com')),
('Ira', CONCAT('ira', FLOOR(RAND()*10000), '@example.com')),
('Andrii', CONCAT('andrii', FLOOR(RAND()*10000), '@example.com')),
('Sofiia', CONCAT('sofiia', FLOOR(RAND()*10000), '@example.com')),
('Dmytro', CONCAT('dmytro', FLOOR(RAND()*10000), '@example.com')),
('Kateryna', CONCAT('kateryna', FLOOR(RAND()*10000), '@example.com')),
('Taras', CONCAT('taras', FLOOR(RAND()*10000), '@example.com')),
('Yulia', CONCAT('yulia', FLOOR(RAND()*10000), '@example.com')),
('Denys', CONCAT('denys', FLOOR(RAND()*10000), '@example.com')),
('Oksana', CONCAT('oksana', FLOOR(RAND()*10000), '@example.com')),
('Pavlo', CONCAT('pavlo', FLOOR(RAND()*10000), '@example.com')),
('Viktoria', CONCAT('viktoria', FLOOR(RAND()*10000), '@example.com')),
('Serhii', CONCAT('serhii', FLOOR(RAND()*10000), '@example.com'));

-- =========================
-- RANDOM ORDERS
-- =========================
INSERT INTO orders (customer_id, status, created_at)
WITH RECURSIVE seq AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1
  FROM seq
  WHERE n < 25
)
SELECT
  FLOOR(1 + RAND() * 15) AS customer_id,
  ELT(FLOOR(1 + RAND() * 3), 'NEW', 'PAID', 'CANCELLED') AS status,
  TIMESTAMP('2026-01-01 00:00:00')
    + INTERVAL FLOOR(RAND() * 240) DAY
    + INTERVAL FLOOR(RAND() * 86400) SECOND AS created_at
FROM seq;

-- =========================
-- RANDOM ORDER ITEMS
-- 2-4 items per order
-- =========================
INSERT INTO order_items (order_id, wine_id, qty, price_each)
WITH RECURSIVE nums AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1
  FROM nums
  WHERE n < 4
)
SELECT
  o.id AS order_id,
  FLOOR(1 + RAND(o.id * 100 + nums.n) * 20) AS wine_id,
  FLOOR(1 + RAND(o.id * 200 + nums.n) * 6) AS qty,
  (
    SELECT w.price
    FROM wines w
    WHERE w.id = FLOOR(1 + RAND(o.id * 100 + nums.n) * 20)
  ) AS price_each
FROM orders o
JOIN nums
  ON nums.n <= 2 + FLOOR(RAND(o.id) * 3);