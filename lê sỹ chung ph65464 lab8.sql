- Bảng khách hàng
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    address TEXT
);

-- Bảng sản phẩm
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price NUMERIC(12,2) NOT NULL CHECK (price > 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0)
);

-- Bảng đơn hàng
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- Bảng chi tiết đơn hàng
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price NUMERIC(12,2) NOT NULL CHECK (price > 0),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


-- =========================================================
-- PHẦN 2. THÊM DỮ LIỆU MẪU
-- =========================================================

-- Thêm khách hàng
INSERT INTO customers (customer_name, phone, email, address) VALUES
('Nguyễn Văn An', '0901000001', 'an@gmail.com', 'Hà Nội'),
('Trần Thị Bình', '0901000002', 'binh@gmail.com', 'Hải Phòng'),
('Lê Văn Cường', '0901000003', 'cuong@gmail.com', 'Đà Nẵng'),
('Phạm Thị Dung', '0901000004', 'dung@gmail.com', 'TP HCM'),
('Hoàng Minh Đức', '0901000005', 'duc@gmail.com', 'Cần Thơ');

-- Thêm sản phẩm
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('Sữa tươi Vinamilk', 'Thực phẩm', 32000, 100),
('Bánh Oreo', 'Thực phẩm', 18000, 150),
('Mì Hảo Hảo', 'Thực phẩm', 5000, 300),
('Coca Cola', 'Đồ uống', 12000, 200),
('Pepsi', 'Đồ uống', 12000, 180),
('Nước suối Lavie', 'Đồ uống', 7000, 250),
('Dầu gội Clear', 'Hóa mỹ phẩm', 85000, 80),
('Kem đánh răng P/S', 'Hóa mỹ phẩm', 28000, 90),
('Nước rửa chén Sunlight', 'Hóa mỹ phẩm', 45000, 70),
('Khăn giấy Bless You', 'Đồ gia dụng', 22000, 120);

-- Thêm đơn hàng
INSERT INTO orders (customer_id, order_date) VALUES
(1, '2026-03-01'),
(2, '2026-03-01'),
(3, '2026-03-02'),
(1, '2026-03-03'),
(4, '2026-03-03'),
(5, '2026-03-04'),
(2, '2026-03-05'),
(3, '2026-03-06');

-- Thêm chi tiết đơn hàng
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 32000),
(1, 4, 3, 12000),

(2, 2, 4, 18000),
(2, 6, 2, 7000),

(3, 7, 1, 85000),
(3, 8, 2, 28000),

(4, 3, 10, 5000),
(4, 4, 5, 12000),

(5, 9, 1, 45000),
(5, 10, 3, 22000),

(6, 1, 1, 32000),
(6, 5, 4, 12000),

(7, 2, 2, 18000),
(7, 7, 1, 85000),

(8, 6, 6, 7000),
(8, 8, 1, 28000);


-- =========================================================
-- PHẦN 3. XEM DỮ LIỆU SAU KHI TẠO
-- =========================================================
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;


-- =========================================================
-- LAB 8 - WINDOW FUNCTIONS
-- =========================================================

-- =========================================================
-- BÀI 1. SO SÁNH WINDOW FUNCTION VỚI GROUP BY
-- =========================================================

-- 1. Thử với GROUP BY
-- Vấn đề: nếu GROUP BY theo tên sản phẩm và giá
-- thì mỗi sản phẩm gần như là 1 nhóm riêng.
SELECT
    product_name,
    price,
    AVG(price) AS avg_price_groupby
FROM products
GROUP BY product_name, price
ORDER BY price DESC;

-- Nhận xét:
-- AVG(price) ở đây thường bằng chính price,
-- nên không cho thấy được giá trung bình của toàn bộ sản phẩm.

-- 2. Dùng Window Function
SELECT
    product_name,
    price,
    AVG(price) OVER () AS avg_overall_price
FROM products
ORDER BY price DESC;

-- Kết luận:
-- GROUP BY làm gộp dòng.
-- Window Function không gộp dòng, vẫn giữ từng sản phẩm
-- và thêm được cột giá trung bình toàn bộ.


-- =========================================================
-- BÀI 2. PHÂN TÍCH TRONG TỪNG NHÓM VỚI PARTITION BY
-- =========================================================
SELECT
    category,
    product_name,
    price,
    AVG(price) OVER (PARTITION BY category) AS avg_category_price
FROM products
ORDER BY category, price DESC;

-- Giải thích:
-- PARTITION BY category chia dữ liệu thành từng nhóm danh mục.
-- AVG(price) sẽ tính trung bình riêng cho từng category.


-- =========================================================
-- BÀI 3. XẾP HẠNG SẢN PHẨM
-- =========================================================

-- 1. Chuẩn bị:
-- Cho 2 sản phẩm có cùng giá để thấy rõ sự khác nhau
-- giữa ROW_NUMBER, RANK và DENSE_RANK.
UPDATE products
SET price = 35000
WHERE product_id IN (1, 7);

-- Kiểm tra lại giá
SELECT product_id, product_name, price
FROM products
ORDER BY price DESC, product_id;

-- 2. Xếp hạng sản phẩm từ đắt đến rẻ
SELECT
    product_name,
    price,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS row_num,
    RANK() OVER (ORDER BY price DESC) AS rank_num,
    DENSE_RANK() OVER (ORDER BY price DESC) AS dense_rank_num
FROM products
ORDER BY price DESC, product_name;

-- Nhận xét:
-- ROW_NUMBER: đánh số liên tiếp 1,2,3,...
-- RANK: cùng giá thì cùng hạng, hạng sau bị nhảy số.
-- DENSE_RANK: cùng giá thì cùng hạng, hạng sau không nhảy số.


-- =========================================================
-- BÀI 4. TÍNH TỔNG LŨY KẾ DOANH THU THEO NGÀY
-- =========================================================
WITH daily_revenue AS (
    SELECT
        o.order_date,
        SUM(oi.quantity * oi.price) AS total_daily_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_date
)
SELECT
    order_date,
    total_daily_revenue,
    SUM(total_daily_revenue) OVER (ORDER BY order_date) AS running_total_revenue
FROM daily_revenue
ORDER BY order_date;