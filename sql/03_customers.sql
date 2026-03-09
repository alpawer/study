USE wineshop;

-- ==========================================
-- 03_customers.sql
-- Мета: окремо працювати з клієнтами (customers)
-- - додати/оновити клієнтів (без дублікатів) через UPSERT
-- - приклади вибірок по клієнтах
-- ==========================================

-- 1) Додати/оновити (UPSERT): якщо email існує, оновимо name
INSERT INTO customers (name, email) VALUES
('Robert',   'robert@example.com'),
('Olena',    'olena@example.com'),
('Max',      'max@example.com'),
('Ira',      'ira@example.com'),
('Andrii',   'andrii@example.com'),
('Sofiia',   'sofiia@example.com'),
('Dmytro',   'dmytro@example.com'),
('Kateryna', 'kateryna@example.com'),
('Taras',    'taras@example.com'),
('Yulia',    'yulia@example.com'),
('Denys',    'denys@example.com'),
('Oksana',   'oksana@example.com'),
('Pavlo',    'pavlo@example.com'),
('Viktoria', 'viktoria@example.com'),
('Serhii',   'serhii@example.com')
ON DUPLICATE KEY UPDATE
  name = VALUES(name);

-- 2) Додамо ще кілька “рандомних” клієнтів для тесту (варіативність)
INSERT INTO customers (name, email) VALUES
('Nazar',  'nazar@example.com'),
('Lilia',  'lilia@example.com'),
('Ihor',   'ihor@example.com'),
('Anastasia','anastasia@example.com')
ON DUPLICATE KEY UPDATE
  name = VALUES(name);

-- =========================
-- ПРИКЛАДИ ВИБІРОК (SELECT)
-- =========================

-- A) Подивитись всіх клієнтів
SELECT id, name, email, created_at
FROM customers
ORDER BY id;

-- B) Пошук по email
SELECT * FROM customers WHERE email='robert@example.com';

-- C) Пошук по частині імені
SELECT * FROM customers WHERE name LIKE '%ia%' ORDER BY name;

-- D) Клієнти, які мають хоча б 1 замовлення
SELECT c.id, c.name, c.email, COUNT(o.id) AS orders_count
FROM customers c
JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.name, c.email
ORDER BY orders_count DESC, c.id;

-- E) Клієнти без замовлень
SELECT c.id, c.name, c.email
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
WHERE o.id IS NULL
ORDER BY c.id;

-- F) Скільки замовлень по статусах для кожного клієнта
SELECT c.id, c.name,
       SUM(o.status='NEW') AS new_cnt,
       SUM(o.status='PAID') AS paid_cnt,
       SUM(o.status='CANCELLED') AS cancelled_cnt
FROM customers c
LEFT JOIN orders o ON o.customer_id=c.id
GROUP BY c.id, c.name
ORDER BY paid_cnt DESC, c.id;
