USE wineshop;

-- 07A: Wines + Filters (15)

-- A01
SELECT sku, name, country, year, price, in_stock FROM wines ORDER BY name LIMIT 10;
-- A02
SELECT sku, name, price FROM wines ORDER BY price DESC LIMIT 10;
-- A03
SELECT sku, name, price FROM wines ORDER BY price ASC LIMIT 10;
-- A04
SELECT sku, name, year, price FROM wines WHERE country='France' ORDER BY price DESC;
-- A05
SELECT sku, name, year, price FROM wines WHERE country='Italy' ORDER BY price DESC;
-- A06
SELECT sku, name, country, price FROM wines WHERE price BETWEEN 10 AND 20 ORDER BY price;
-- A07
SELECT sku, name, country, year, price FROM wines WHERE year >= 2022 ORDER BY year DESC, price DESC;
-- A08
SELECT sku, name, price FROM wines WHERE name LIKE '%Cab%' ORDER BY price DESC;
-- A09
SELECT sku, name, country, price FROM wines WHERE description LIKE '%oak%' ORDER BY price DESC;
-- A10
SELECT sku, name, in_stock, price FROM wines WHERE in_stock <= 30 ORDER BY in_stock ASC, price DESC;
-- A11
SELECT country, COUNT(*) AS wines_count FROM wines GROUP BY country ORDER BY wines_count DESC, country;
-- A12
SELECT country, ROUND(AVG(price),2) AS avg_price, COUNT(*) AS cnt
FROM wines GROUP BY country HAVING cnt >= 2 ORDER BY avg_price DESC;
-- A13
SELECT country, ROUND(AVG(price),2) AS avg_price FROM wines GROUP BY country ORDER BY avg_price DESC LIMIT 5;
-- A14
SELECT ROUND(AVG(price),2) AS avg_price, MIN(price) AS min_price, MAX(price) AS max_price FROM wines;
-- A15
SELECT sku, name, price FROM wines
WHERE price > (SELECT AVG(price) FROM wines)
ORDER BY price DESC;
