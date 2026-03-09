USE wineshop;

-- Перезапуск без дублікатів (чистимо дані)
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE order_items;
TRUNCATE TABLE orders;
TRUNCATE TABLE wines;
TRUNCATE TABLE customers;
SET FOREIGN_KEY_CHECKS=1;

-- 20 вин (id буде 1..20)
INSERT INTO wines (sku, name, description, country, year, price, in_stock) VALUES
('WINE-IT-CHI-2019','Chianti Classico','Dry red, cherry & spice.','Italy',2019,14.90,120),
('WINE-FR-BOR-2018','Bordeaux Rouge','Blackcurrant, oak notes.','France',2018,19.50,80),
('WINE-ES-RIO-2020','Rioja Crianza','Oak-aged, vanilla hints.','Spain',2020,16.20,60),
('WINE-DE-RIE-2021','Riesling Kabinett','Citrus, apple, fresh acidity.','Germany',2021,12.30,150),
('WINE-US-NAP-2017','Napa Cabernet','Full-bodied, dark fruit.','USA',2017,38.00,25),
('WINE-PT-DOU-2019','Douro Red','Dark berries, pepper.','Portugal',2019,13.80,70),
('WINE-AR-MAL-2020','Malbec Mendoza','Plum, cocoa, medium tannins.','Argentina',2020,17.40,55),
('WINE-NZ-SAV-2022','Sauvignon Blanc','Tropical fruit, crisp.','New Zealand',2022,15.60,90),
('WINE-CL-CAR-2020','Carmenere Reserva','Herbal notes, smooth finish.','Chile',2020,14.10,65),
('WINE-AU-SHR-2021','Shiraz Barossa','Pepper, blackberry, bold.','Australia',2021,21.90,40),
('WINE-ZA-PIN-2021','Pinotage','Smoky, berry jam notes.','South Africa',2021,13.50,50),
('WINE-GR-AGI-2020','Agiorgitiko','Red fruit, medium body.','Greece',2020,12.90,45),
('WINE-AT-GRU-2022','Gruner Veltliner','White pepper, fresh.','Austria',2022,11.70,110),
('WINE-GE-SAP-2021','Saperavi','Deep color, blackberry.','Georgia',2021,18.80,35),
('WINE-HU-TOK-2021','Tokaji Late Harvest','Honey, apricot, sweet.','Hungary',2021,22.50,30),
('WINE-FR-CHA-2020','Chardonnay','Butter, citrus, balanced.','France',2020,17.90,75),
('WINE-IT-PRO-2022','Prosecco','Sparkling, pear notes.','Italy',2022,10.90,200),
('WINE-ES-ALB-2022','Albarino','Saline, citrus, bright.','Spain',2022,18.20,55),
('WINE-US-ROS-2023','Rose California','Light, strawberry notes.','USA',2023,9.90,160),
('WINE-FR-CHM-2019','Champagne Brut','Fine bubbles, brioche.','France',2019,45.00,18);

-- 15 клієнтів (id буде 1..15)
INSERT INTO customers (name, email) VALUES
('Robert','robert@example.com'),
('Olena','olena@example.com'),
('Max','max@example.com'),
('Ira','ira@example.com'),
('Andrii','andrii@example.com'),
('Sofiia','sofiia@example.com'),
('Dmytro','dmytro@example.com'),
('Kateryna','kateryna@example.com'),
('Taras','taras@example.com'),
('Yulia','yulia@example.com'),
('Denys','denys@example.com'),
('Oksana','oksana@example.com'),
('Pavlo','pavlo@example.com'),
('Viktoria','viktoria@example.com'),
('Serhii','serhii@example.com');

-- 25 замовлень (id буде 1..25). Дати розкидані по місяцях.
INSERT INTO orders (customer_id, status, created_at) VALUES
(1,'PAID','2026-01-05 10:12:00'),
(2,'PAID','2026-01-12 18:40:00'),
(3,'CANCELLED','2026-01-20 09:05:00'),
(4,'PAID','2026-02-02 13:22:00'),
(5,'NEW','2026-02-07 20:10:00'),
(6,'PAID','2026-02-15 11:30:00'),
(7,'PAID','2026-02-21 16:45:00'),
(8,'PAID','2026-03-01 12:00:00'),
(9,'NEW','2026-03-04 19:15:00'),
(10,'PAID','2026-03-10 08:55:00'),
(11,'PAID','2026-03-18 21:05:00'),
(12,'CANCELLED','2026-03-22 14:12:00'),
(13,'PAID','2026-04-03 09:35:00'),
(14,'PAID','2026-04-11 17:20:00'),
(15,'NEW','2026-04-19 10:10:00'),
(1,'PAID','2026-05-02 12:44:00'),
(2,'PAID','2026-05-09 15:05:00'),
(3,'PAID','2026-05-16 19:33:00'),
(4,'PAID','2026-06-01 11:01:00'),
(5,'PAID','2026-06-08 13:49:00'),
(6,'NEW','2026-06-14 20:00:00'),
(7,'PAID','2026-07-03 09:10:00'),
(8,'PAID','2026-07-11 22:18:00'),
(9,'PAID','2026-08-05 16:30:00'),
(10,'PAID','2026-08-21 10:55:00');

-- 60+ позицій (order_items). В одному замовленні один wine_id не повторюємо.
-- Формула line_total буде в запитах через qty*price_each.

-- order 1 (3 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(1, 1, 2, (SELECT price FROM wines WHERE id=1)),
(1, 4, 1, (SELECT price FROM wines WHERE id=4)),
(1, 17, 3, (SELECT price FROM wines WHERE id=17));

-- order 2 (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(2, 2, 1, (SELECT price FROM wines WHERE id=2)),
(2, 20, 1, (SELECT price FROM wines WHERE id=20));

-- order 3 cancelled (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(3, 9, 2, (SELECT price FROM wines WHERE id=9)),
(3, 19, 4, (SELECT price FROM wines WHERE id=19));

-- order 4 (3 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(4, 6, 1, (SELECT price FROM wines WHERE id=6)),
(4, 7, 2, (SELECT price FROM wines WHERE id=7)),
(4, 16, 1, (SELECT price FROM wines WHERE id=16));

-- order 5 new (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(5, 8, 2, (SELECT price FROM wines WHERE id=8)),
(5, 13, 1, (SELECT price FROM wines WHERE id=13));

-- order 6 (3 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(6, 10, 1, (SELECT price FROM wines WHERE id=10)),
(6, 1, 1, (SELECT price FROM wines WHERE id=1)),
(6, 18, 2, (SELECT price FROM wines WHERE id=18));

-- order 7 (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(7, 5, 1, (SELECT price FROM wines WHERE id=5)),
(7, 17, 6, (SELECT price FROM wines WHERE id=17));

-- order 8 (3 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(8, 3, 2, (SELECT price FROM wines WHERE id=3)),
(8, 12, 1, (SELECT price FROM wines WHERE id=12)),
(8, 14, 1, (SELECT price FROM wines WHERE id=14));

-- order 9 new (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(9, 11, 2, (SELECT price FROM wines WHERE id=11)),
(9, 15, 1, (SELECT price FROM wines WHERE id=15));

-- order 10 (3 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(10, 4, 4, (SELECT price FROM wines WHERE id=4)),
(10, 19, 2, (SELECT price FROM wines WHERE id=19)),
(10, 16, 1, (SELECT price FROM wines WHERE id=16));

-- order 11 (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(11, 2, 2, (SELECT price FROM wines WHERE id=2)),
(11, 6, 3, (SELECT price FROM wines WHERE id=6));

-- order 12 cancelled (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(12, 20, 1, (SELECT price FROM wines WHERE id=20)),
(12, 5, 2, (SELECT price FROM wines WHERE id=5));

-- order 13 (3 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(13, 8, 3, (SELECT price FROM wines WHERE id=8)),
(13, 18, 1, (SELECT price FROM wines WHERE id=18)),
(13, 1, 1, (SELECT price FROM wines WHERE id=1));

-- order 14 (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(14, 7, 2, (SELECT price FROM wines WHERE id=7)),
(14, 9, 1, (SELECT price FROM wines WHERE id=9));

-- order 15 new (3 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(15, 13, 2, (SELECT price FROM wines WHERE id=13)),
(15, 17, 5, (SELECT price FROM wines WHERE id=17)),
(15, 19, 2, (SELECT price FROM wines WHERE id=19));

-- order 16 (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(16, 16, 2, (SELECT price FROM wines WHERE id=16)),
(16, 10, 1, (SELECT price FROM wines WHERE id=10));

-- order 17 (3 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(17, 3, 1, (SELECT price FROM wines WHERE id=3)),
(17, 4, 2, (SELECT price FROM wines WHERE id=4)),
(17, 15, 1, (SELECT price FROM wines WHERE id=15));

-- order 18 (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(18, 14, 1, (SELECT price FROM wines WHERE id=14)),
(18, 5, 1, (SELECT price FROM wines WHERE id=5));

-- order 19 (3 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(19, 20, 1, (SELECT price FROM wines WHERE id=20)),
(19, 2, 1, (SELECT price FROM wines WHERE id=2)),
(19, 17, 4, (SELECT price FROM wines WHERE id=17));

-- order 20 (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(20, 6, 2, (SELECT price FROM wines WHERE id=6)),
(20, 12, 3, (SELECT price FROM wines WHERE id=12));

-- order 21 new (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(21, 18, 2, (SELECT price FROM wines WHERE id=18)),
(21, 8, 1, (SELECT price FROM wines WHERE id=8));

-- order 22 (3 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(22, 1, 1, (SELECT price FROM wines WHERE id=1)),
(22, 7, 1, (SELECT price FROM wines WHERE id=7)),
(22, 10, 1, (SELECT price FROM wines WHERE id=10));

-- order 23 (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(23, 9, 2, (SELECT price FROM wines WHERE id=9)),
(23, 11, 1, (SELECT price FROM wines WHERE id=11));

-- order 24 (3 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(24, 4, 3, (SELECT price FROM wines WHERE id=4)),
(24, 16, 1, (SELECT price FROM wines WHERE id=16)),
(24, 19, 6, (SELECT price FROM wines WHERE id=19));

-- order 25 (2 items)
INSERT INTO order_items (order_id, wine_id, qty, price_each) VALUES
(25, 5, 1, (SELECT price FROM wines WHERE id=5)),
(25, 20, 1, (SELECT price FROM wines WHERE id=20));
