-- Bài 1
SELECT 
    COUNT(*) AS SoLuongSanPham,
    AVG(price) AS GiaTrungBinh,
    MIN(price) AS GiaThapNhat,
    MAX(price) AS GiaCaoNhat
FROM products;

-- Bài 2
SELECT 
    s.supplier_name AS TenNhaCungCap,
    COUNT(p.product_id) AS TongSoSanPham
FROM suppliers s
JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name
HAVING COUNT(p.product_id) > 1
ORDER BY TongSoSanPham DESC;

-- Bài 3
SELECT 
    order_id AS MaDonHang,
    TO_CHAR(order_date, 'DD/MM/YYYY') AS NgayDatHang
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2025
  AND EXTRACT(MONTH FROM order_date) = 10
ORDER BY order_date;

-- Bài 4
SELECT 
    c.full_name AS TenKhachHang,
    SUM(oi.quantity * p.price) AS TongChiTieu
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.full_name
HAVING SUM(oi.quantity * p.price) > 100000
ORDER BY TongChiTieu DESC;