-- create a database named OnlineStore
CREATE DATABASE OnlineStore;
USE OnlineStore;

-- Create table Customers (CUSTOMER_ID, NAME, EMAIL, PHONE, ADDRESS) 
CREATE TABLE Customers (
CUSTOMER_ID SERIAL PRIMARY KEY,
NAME TEXT NOT NULL,
EMAIL TEXT NOT NULL,
PHONE NUMERIC NOT NULL,
ADDRESS TEXT
);

-- Create table Products (PRODUCT_ID, PRODUCT_NAME, CATEGORY, PRICE, STOCK)
CREATE TABLE Products (
PRODUCT_ID SERIAL PRIMARY KEY,
PRODUCT_NAME TEXT NOT NULL,
CATEGORY TEXT NOT NULL,
PRICE NUMERIC(10, 2) NOT NULL,
STOCK INTEGER NOT NULL
);

-- Create table Orders (ORDER_ID, CUSTOMER_ID, PRODUCT_ID, QUANTITY, ORDER_DATE) Set up foreign keys linking Orders to Customers and Products
CREATE TABLE Orders (
ORDER_ID SERIAL PRIMARY KEY,
CUSTOMER_ID INT REFERENCES Customers(CUSTOMER_ID),
PRODUCT_ID INT REFERENCES Products(PRODUCT_ID),
QUANTITY INT NOT NULL,
ORDER_DATE DATE NOT NULL
);

-- Data Creation
-- Insert sample into Customers table
INSERT INTO Customers (NAME, EMAIL, PHONE, ADDRESS) VALUES
('Elan', 'elan@gmail.com', '9034567890', '123 Bharat St'),
('David', 'david@gmail.com', '9345678901', '456 Thomas St'),
('Charlie', 'charlie@gmail.com', '9456789012', '789 Pine St'),
('Diana', 'diana@gmail.com', '9567890123', '321 Gandhi St'),
('Lora', 'lora@gmail.com', '9967890123', '321 Anandha St'),
('Carol', 'carol@gamil.com', '9678901234', '654 Joseph St');

-- Insert sample into Products table
INSERT INTO Products (PRODUCT_NAME, CATEGORY, PRICE, STOCK) VALUES
('Laptop', 'Electronics', 1200.00, 5),
('Phone', 'Electronics', 800.00, 0),
('Desk Chair', 'Furniture', 150.00, 10),
('Notebook', 'Stationery', 5.00, 50),
('Headphones', 'Electronics', 100.00, 0),
('Phone', 'Electronics', 700.00, 0),
('Pen', 'Stationery', 2.00, 100);

-- Insert sample into Products table
INSERT INTO Orders (CUSTOMER_ID, PRODUCT_ID, QUANTITY, ORDER_DATE) VALUES
(1, 1, 1, '2025-08-01'),
(1, 4, 5, '2025-08-03'),
(2, 3, 2, '2025-07-15'),
(2, 6, 10, '2025-07-16'),
(3, 2, 1, '2025-06-10'),
(3, 5, 2, '2025-08-10'),
(4, 3, 1, '2025-01-05'),
(1, 1, 1, '2024-08-01'),
(5, 2, 1, '2024-01-01'),
(5, 1, 1, '2025-08-20'),
(2, 4, 5, '2023-08-03');

-- Order Management
-- Retrieve all orders placed by a specific customer
SELECT O.*
FROM Orders O
JOIN Customers C ON O.CUSTOMER_ID = C.CUSTOMER_ID
WHERE C.NAME = 'Elan';

-- Find products that are out of stock
SELECT * FROM Products
WHERE STOCK = 0;

-- Calculate the total revenue generated per product
SELECT 
P.PRODUCT_NAME,
SUM(O.QUANTITY * P.PRICE) AS TOTAL_REVENUE
FROM Orders O
JOIN Products P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY P.PRODUCT_NAME;

-- Retrieve the top 5 customers by total purchase amount
SELECT 
C.NAME,
SUM(O.QUANTITY * P.PRICE) AS TOTAL_SPENT
FROM Orders O
JOIN Customers C ON O.CUSTOMER_ID = C.CUSTOMER_ID
JOIN Products P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY C.NAME
ORDER BY TOTAL_SPENT DESC
LIMIT 5;

-- Find customers who placed orders in at least two different product categories

SELECT C.NAME
FROM Orders O
JOIN Customers C ON O.CUSTOMER_ID = C.CUSTOMER_ID
JOIN Products P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY C.NAME
HAVING COUNT(DISTINCT P.CATEGORY) >= 2;

-- Analytics
-- Find the month with the highest total sales
SELECT 
DATE_FORMAT(O.ORDER_DATE, '%Y-%m') AS MONTH,
SUM(O.QUANTITY * P.PRICE) AS TOTAL_SALES
FROM Orders O
JOIN Products P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY DATE_FORMAT(O.ORDER_DATE, '%Y-%m')
ORDER BY TOTAL_SALES DESC
LIMIT 1;

-- Identify products with no orders in the last 6 months
SELECT DISTINCT 
p.PRODUCT_ID,
p.PRODUCT_NAME,
p.CATEGORY
FROM 
Products p
LEFT JOIN 
Orders o 
ON p.PRODUCT_ID = o.PRODUCT_ID 
AND o.ORDER_DATE >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH)
WHERE 
o.PRODUCT_ID IS NULL;

-- Retrieve customers who have never placed an order
SELECT * FROM Customers
WHERE CUSTOMER_ID NOT IN (
SELECT DISTINCT CUSTOMER_ID FROM Orders
);

-- Calculate the average order value across all orders
SELECT 
ROUND(AVG(O.QUANTITY * P.PRICE),0) AS AVERAGE_ORDER_VALUE
FROM Orders O
JOIN Products P ON O.PRODUCT_ID = P.PRODUCT_ID;