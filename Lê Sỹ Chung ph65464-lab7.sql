-- =========================================================
-- ITA104 - LAB 7: INDEX & PHÂN TÍCH HIỆU NĂNG (ĐÃ FIX)
-- =========================================================

-- =========================================================
-- THÊM CỘT address (FIX LỖI)
-- =========================================================
ALTER TABLE customers
ADD COLUMN IF NOT EXISTS address TEXT;

-- =========================================================
-- KIỂM TRA DỮ LIỆU
-- =========================================================
SELECT * FROM customers LIMIT 5;

-- =========================================================
-- BÀI 1: CHƯA CÓ INDEX (SEQ SCAN)
-- =========================================================
DROP INDEX IF EXISTS idx_customers_phone;
DROP INDEX IF EXISTS idx_customers_address;

EXPLAIN ANALYZE
SELECT *
FROM customers
WHERE phone_number = '0910099999';

-- =========================================================
-- BÀI 2: TẠO INDEX (INDEX SCAN)
-- =========================================================
CREATE INDEX idx_customers_phone
ON customers(phone_number);

EXPLAIN ANALYZE
SELECT *
FROM customers
WHERE phone_number = '0910099999';

-- =========================================================
-- BÀI 3: INSERT (ẢNH HƯỞNG INDEX)
-- =========================================================
EXPLAIN ANALYZE
INSERT INTO customers (full_name, phone_number, address)
VALUES ('Test Index User', '0999999999', '123 Test');

SELECT *
FROM customers
WHERE phone_number = '0999999999';

-- =========================================================
-- BÀI 4: BITMAP SCAN
-- =========================================================
CREATE INDEX idx_customers_address
ON customers(address);

EXPLAIN
SELECT *
FROM customers
WHERE address = 'Address 500'
   OR phone_number LIKE '091001%';

-- =========================================================
-- KIỂM TRA INDEX
-- =========================================================
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'customers';
