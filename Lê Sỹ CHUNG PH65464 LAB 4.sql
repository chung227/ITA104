-- PHẦN I - BÀI 1
-- Tạo toàn bộ cấu trúc CSDL bằng câu lệnh
-- =========================================================

-- Xóa bảng nếu đã tồn tại để chạy lại từ đầu cho tiện
DROP TABLE IF EXISTS invoice_detail;
DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS test_table;

-- 1. Tạo bảng customer
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(255)
);

-- 2. Tạo bảng product
CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0)
);

-- 3. Tạo bảng invoice
CREATE TABLE invoice (
    invoice_id SERIAL PRIMARY KEY,
    created_date DATE NOT NULL,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    CONSTRAINT fk_invoice_customer
        FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- 4. Tạo bảng invoice_detail
CREATE TABLE invoice_detail (
    invoice_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (invoice_id, product_id),
    CONSTRAINT fk_invoice_detail_invoice
        FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
    CONSTRAINT fk_invoice_detail_product
        FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- =========================================================
-- Thêm dữ liệu mẫu cho tất cả các bảng
-- =========================================================

-- Dữ liệu bảng customer
INSERT INTO customer (customer_name, phone, address) VALUES
('Nguyễn Văn An', '0901111111', 'Hà Nội'),
('Trần Thị Bình', '0902222222', 'Hải Phòng'),
('Lê Văn Cường', '0903333333', 'Đà Nẵng');

-- Dữ liệu bảng product
-- Cố tình tạo đủ product_id = 8 để làm Bài 4 phần DELETE
INSERT INTO product (product_name, price) VALUES
('Sữa Vinamilk 1L', 32000),
('Mì Acecook Hảo Hảo', 5000),
('Bánh Oreo', 12000),
('Coca Cola 1.5L', 18000),
('Gạo ST25 5kg', 145000),
('Nước mắm Nam Ngư', 35000),
('Dầu ăn Neptune 1L', 52000),
('Nước suối Aquafina', 7000);

-- Dữ liệu bảng invoice
INSERT INTO invoice (created_date, customer_id, total_amount) VALUES
('2026-03-20', 1, 42000),
('2026-03-21', 2, 50000),
('2026-03-22', 3, 152000);

-- Dữ liệu bảng invoice_detail
INSERT INTO invoice_detail (invoice_id, product_id, quantity, unit_price) VALUES
(1, 2, 2, 5000),
(1, 3, 1, 12000),
(1, 4, 1, 18000),
(2, 1, 1, 32000),
(2, 4, 1, 18000),
(3, 5, 1, 145000),
(3, 2, 1, 5000),
(3, 8, 1, 7000);

-- =========================================================
-- BÀI 2
-- Mở rộng CSDL - Tạo bảng suppliers
-- =========================================================

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    contact_phone VARCHAR(15) UNIQUE
);

-- =========================================================
-- PHẦN II - BÀI 3
-- Cập nhật cấu trúc bảng
-- 1. Thêm cột email vào suppliers
-- 2. Thêm supplier_id vào product và tạo khóa ngoại
-- =========================================================

ALTER TABLE suppliers
ADD COLUMN email VARCHAR(100);

ALTER TABLE product
ADD COLUMN supplier_id INT;

ALTER TABLE product
ADD CONSTRAINT fk_product_supplier
FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);

-- =========================================================
-- BÀI 4
-- Thao tác với dữ liệu Nhà cung cấp và Sản phẩm
-- INSERT, UPDATE, DELETE
-- =========================================================

-- 1. INSERT: thêm 2 nhà cung cấp mới
INSERT INTO suppliers (supplier_name, contact_phone, email) VALUES
('Công ty Sữa Việt Nam', '0987654321', 'contact@vinamilk.vn'),
('Công ty Thực phẩm Á Châu', '0912345678', 'contact@acecook.vn');

-- Cập nhật supplier_id cho một số sản phẩm để có liên kết dữ liệu
UPDATE product
SET supplier_id = 1
WHERE product_name = 'Sữa Vinamilk 1L';

UPDATE product
SET supplier_id = 2
WHERE product_name = 'Mì Acecook Hảo Hảo';

-- 2. UPDATE: sửa số điện thoại nhà cung cấp bị sai
UPDATE suppliers
SET contact_phone = '0911112222'
WHERE supplier_name = 'Công ty Thực phẩm Á Châu';

-- 3. DELETE: xóa sản phẩm "Nước suối Aquafina" có product_id = 8
-- Vì invoice_detail đang tham chiếu đến product_id = 8,
-- cần xóa ở bảng chi tiết hóa đơn trước để tránh lỗi khóa ngoại
DELETE FROM invoice_detail
WHERE product_id = 8;

DELETE FROM product
WHERE product_id = 8;

-- =========================================================
-- BÀI 5
-- DROP COLUMN và DROP TABLE
-- =========================================================

-- 1. Tạo bảng nháp test_table
CREATE TABLE test_table (
    id INT
);

-- 2. DROP COLUMN: xóa cột contact_phone khỏi bảng suppliers
ALTER TABLE suppliers
DROP COLUMN contact_phone;

-- 3. DROP TABLE: xóa hoàn toàn bảng test_table
DROP TABLE test_table;

-- =========================================================
-- Kiểm tra dữ liệu sau khi thực hiện
-- =========================================================
SELECT * FROM customer;
SELECT * FROM product;
SELECT * FROM invoice;
SELECT * FROM invoice_detail;
SELECT * FROM suppliers;