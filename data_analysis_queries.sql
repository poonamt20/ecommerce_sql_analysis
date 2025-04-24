
-- Create tables
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

DROP TABLE IF EXISTS order_details, orders, products, customers;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    category VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample customers
INSERT INTO customers (customer_name, email, city) VALUES
('Alice Johnson', 'alice@example.com', 'New York'),
('Bob Smith', 'bob@example.com', 'Los Angeles'),
('Charlie Brown', 'charlie@example.com', 'Chicago');

-- Insert sample products
INSERT INTO products (product_name, price, category) VALUES
('Laptop', 1000.00, 'Electronics'),
('Smartphone', 500.00, 'Electronics'),
('Desk Chair', 150.00, 'Furniture'),
('Headphones', 75.00, 'Electronics'),
('Coffee Maker', 60.00, 'Appliances');

-- Insert sample orders
INSERT INTO orders (customer_id, order_date) VALUES
(1, '2024-05-10'),
(2, '2024-05-11'),
(1, '2024-05-12');

-- Insert sample order details
INSERT INTO order_details (order_id, product_id, quantity) VALUES
(1, 1, 1), -- Alice buys 1 Laptop
(1, 4, 2), -- Alice buys 2 Headphones
(2, 2, 1), -- Bob buys 1 Smartphone
(3, 3, 1), -- Alice buys 1 Desk Chair
(3, 5, 1); -- Alice buys 1 Coffee Maker

SHOW TABLES;

DESCRIBE customers;
DESCRIBE orders;
DESCRIBE products;
DESCRIBE order_details;

-- Find all products with price above 100, ordered by price descending

-- Count of orders by each customer
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- INNER JOIN: Show all orders with customer names
SELECT o.order_id, c.customer_name, o.order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;
-- LEFT JOIN: Show all customers, even if they haven’t ordered
SELECT c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Get names of customers who placed orders for products over $500

-- Get names of customers who placed orders for products over $500
SELECT DISTINCT customer_name
FROM customers
WHERE customer_id IN (
    SELECT o.customer_id
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    WHERE p.price > 500
);
-- Total revenue from all orders
SELECT SUM(p.price * od.quantity) AS total_revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id;
-- Average order value
SELECT AVG(order_total) AS avg_order_value
FROM (
    SELECT o.order_id, SUM(p.price * od.quantity) AS order_total
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY o.order_id
) AS sub;
-- Create a view for top spenders
CREATE VIEW top_customers AS
SELECT c.customer_id, c.customer_name, SUM(p.price * od.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;
CREATE INDEX idx_customer_id ON orders(customer_id);
CREATE INDEX idx_product_id ON order_details(product_id);


