CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_phone VARCHAR(20)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price INT CHECK (price > 0),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT CHECK (quantity > 0),
    price INT CHECK (price > 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =========================
-- 3) DỮ LIỆU MẪU LAB 2
-- =========================
INSERT INTO suppliers (supplier_name, contact_phone) VALUES
('Công ty Sữa Việt Nam', '0901111111'),
('Coca Cola Việt Nam', '0902222222'),
('Vinamit', '0903333333');

INSERT INTO customers (full_name, phone_number) VALUES
('Nguyễn Văn A', '0911111111'),
('Trần Thị B', '0922222222'),
('Lê Văn C', '0933333333'),
('Phạm Thị D', '0944444444');

INSERT INTO products (product_name, price, supplier_id) VALUES
('Sữa tươi Vinamilk', 20000, 1),
('Sữa chua Vinamilk', 10000, 1),
('Coca Cola lon', 15000, 2),
('Nước cam ép', 18000, 2),
('Mít sấy Vinamit', 25000, 3),
('Sữa đặc Vinamilk', 30000, 1);

INSERT INTO orders (customer_id, order_date) VALUES
(1, '2024-03-01'),
(2, '2024-03-02'),
(1, '2024-03-05');

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 20000),
(1, 3, 1, 15000),
(2, 2, 5, 10000),
(3, 5, 2, 25000);
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

