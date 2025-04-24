
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
