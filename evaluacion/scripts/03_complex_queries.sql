-- 03_complex_queries.sql
-- Queries complejas para dashboards y reportes multi-tabla Ecommify

SET search_path TO public;

-- Q1. Dashboard financiero por mes
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    DATE_TRUNC('month', o.created_at) AS month,
    COUNT(DISTINCT o.id) AS total_orders,
    SUM(o.total) AS gross_revenue,
    COUNT(DISTINCT o.user_id) AS active_users,
    AVG(o.total) AS avg_order_value
FROM orders o
WHERE o.created_at >= '2018-01-01'
  AND o.created_at < '2019-01-01'
GROUP BY DATE_TRUNC('month', o.created_at)
ORDER BY month;

-- Q2. Dashboard de ventas por categoría
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    c.name AS category,
    COUNT(*) AS total_items,
    SUM(od.quantity * od.unit_price) AS revenue,
    AVG(od.unit_price) AS avg_price
FROM order_details od
JOIN products p
    ON od.product_id = p.id
JOIN categories c
    ON p.category_id = c.id
GROUP BY c.name
ORDER BY revenue DESC
LIMIT 20;

-- Q3. Reporte de pagos aprobados
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    payment_method,
    payment_status,
    COUNT(*) AS total_payments,
    SUM(amount) AS total_amount
FROM payments
WHERE payment_date >= '2018-01-01'
  AND payment_date < '2019-01-01'
GROUP BY payment_method, payment_status
ORDER BY total_amount DESC;

-- Q4. Productos con bajo inventario
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    p.id,
    p.name,
    c.name AS category,
    i.stock,
    i.reserved_stock,
    (i.stock - i.reserved_stock) AS available_stock
FROM products p
JOIN categories c
    ON p.category_id = c.id
JOIN inventories i
    ON p.id = i.product_id
WHERE (i.stock - i.reserved_stock) <= 10
ORDER BY available_stock ASC
LIMIT 50;