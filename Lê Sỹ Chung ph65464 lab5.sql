#bài 1
SELECT 
    oi.order_id,
    p.product_name,
    oi.quantity,
    oi.price
FROM order_items oi
INNER JOIN products p 
    ON oi.product_id = p.product_id;
SELECT 
    c.full_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;
#Bài 2 - Câu 1
SELECT 
    p.product_name,
    oi.order_id
FROM order_items oi
RIGHT JOIN products p
    ON oi.product_id = p.product_id;
#Bài 2
SELECT 
    full_name AS ContactName,
    phone_number AS PhoneNumber
FROM customers
UNION
SELECT 
    supplier_name AS ContactName,
    contact_phone AS PhoneNumber
FROM suppliers;
#Bài 3
SELECT
    product_name,
    price
FROM products
WHERE supplier_id IN (
    SELECT supplier_id
    FROM suppliers
    WHERE supplier_name = 'Công ty Sữa Việt Nam'
);

-- Câu 2: Subquery trong SELECT - giá sản phẩm và giá trung bình
SELECT
    product_name,
    price,
    (
        SELECT AVG(price)
        FROM products
    ) AS average_price
FROM products;

-- =========================
-- 7) LAB 5 - BÀI 4
-- =========================

-- Câu 1: Subquery trong FROM - đơn hàng có tổng giá trị > 50000
SELECT *
FROM (
    SELECT
        order_id,
        SUM(quantity * price) AS total_amount
    FROM order_items
    GROUP BY order_id
) AS order_summary
WHERE total_amount > 50000;

-- Câu 2: EXISTS - nhà cung cấp có ít nhất một sản phẩm
SELECT
    s.supplier_name
FROM suppliers s
WHERE EXISTS (
    SELECT 1
    FROM products p
    WHERE p.supplier_id = s.supplier_id
);

-- =========================
-- 8) KIỂM TRA NHANH
-- =========================
SELECT * FROM suppliers;
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;

