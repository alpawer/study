CREATE DATABASE IF NOT EXISTS wineshop
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE wineshop;

CREATE TABLE IF NOT EXISTS customers (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_customers_email (email)
);

CREATE TABLE IF NOT EXISTS wines (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  sku VARCHAR(32) NOT NULL,
  name VARCHAR(160) NOT NULL,
  description TEXT NULL,
  country VARCHAR(80) NULL,
  year SMALLINT NULL,
  price DECIMAL(10,2) NOT NULL,
  in_stock INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_wines_sku (sku),
  KEY idx_wines_name (name),
  KEY idx_wines_price (price)
);

CREATE TABLE IF NOT EXISTS orders (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  customer_id BIGINT UNSIGNED NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status ENUM('NEW','PAID','CANCELLED') NOT NULL DEFAULT 'NEW',
  PRIMARY KEY (id),
  KEY idx_orders_customer (customer_id),
  KEY idx_orders_created_at (created_at),
  CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers(id)
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS order_items (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id BIGINT UNSIGNED NOT NULL,
  wine_id BIGINT UNSIGNED NOT NULL,
  qty INT NOT NULL,
  price_each DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_order_wine (order_id, wine_id),
  KEY idx_items_order (order_id),
  KEY idx_items_wine (wine_id),
  CONSTRAINT fk_items_order
    FOREIGN KEY (order_id) REFERENCES orders(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_items_wine
    FOREIGN KEY (wine_id) REFERENCES wines(id)
    ON DELETE RESTRICT
);

-- Views (structured)
DROP VIEW IF EXISTS order_totals;

CREATE OR REPLACE VIEW vw_order_totals AS
SELECT
  o.id AS order_id,
  o.customer_id,
  o.created_at,
  o.status,
  COALESCE(SUM(oi.qty * oi.price_each), 0.00) AS total_amount
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, o.customer_id, o.created_at, o.status;

CREATE OR REPLACE VIEW vw_orders_full AS
SELECT
  o.id AS order_id,
  o.created_at,
  o.status,
  c.id AS customer_id,
  c.name AS customer_name,
  c.email AS customer_email,
  t.total_amount
FROM orders o
JOIN customers c ON c.id = o.customer_id
JOIN vw_order_totals t ON t.order_id = o.id;

