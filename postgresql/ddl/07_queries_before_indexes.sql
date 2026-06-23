-- 07_queries_before_indexes.sql


SET search_path TO public;


-- ==========================================================
-- Q1. Historial de órdenes por usuario
-- Caso crítico: seguimiento de compras del usuario
-- ==========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    o.id,
    o.user_id,
    o.status,
    o.total,
    o.created_at
FROM orders o
WHERE o.user_id = 1000
ORDER BY o.created_at DESC
LIMIT 20;


-- ==========================================================
-- Q2. Ventas por categoría y mes
-- Caso crítico: analítica comercial
-- ==========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    DATE_TRUNC('month', o.created_at) AS month,
    c.name AS category,
    SUM(od.quantity * od.unit_price) AS revenue,
    COUNT(DISTINCT o.id) AS total_orders,
    COUNT(*) AS total_items
FROM orders o
JOIN order_details od
    ON o.id = od.order_id
   AND o.created_at = od.order_created_at
JOIN products p
    ON od.product_id = p.id
JOIN categories c
    ON p.category_id = c.id
WHERE o.status = 'DELIVERED'
  AND o.created_at >= '2018-01-01'
  AND o.created_at < '2019-01-01'
GROUP BY
    DATE_TRUNC('month', o.created_at),
    c.name
ORDER BY revenue DESC
LIMIT 10;


-- ==========================================================
-- Q3. Productos por atributos JSONB
-- Caso crítico: catálogo flexible por atributos dinámicos
-- ==========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    name,
    price,
    attributes
FROM products
WHERE attributes @> '{"color": "black"}'::jsonb
LIMIT 20;


-- ==========================================================
-- Q4. Productos por tags ARRAY
-- Caso crítico: búsqueda rápida por etiquetas
-- ==========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    name,
    tags
FROM products
WHERE tags @> ARRAY['olist']::TEXT[]
LIMIT 20;


-- ==========================================================
-- Q5. Búsqueda textual por nombre con pg_trgm
-- Caso crítico: búsqueda de catálogo
-- ==========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    name,
    price
FROM products
WHERE name ILIKE '%technology%'
ORDER BY price DESC
LIMIT 20;


-- ==========================================================
-- Q6. Consulta geoespacial con PostGIS
-- Caso crítico: usuarios cercanos a una ubicación
-- ==========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    id,
    user_id,
    city,
    postal_code
FROM addresses
WHERE location IS NOT NULL
  AND ST_DWithin(
        location,
        ST_SetSRID(ST_MakePoint(-46.6333, -23.5505), 4326)::geography,
        50000
  )
LIMIT 20;


-- ==========================================================
-- Q7. Pagos aprobados por rango de fecha
-- Caso crítico: análisis financiero
-- ==========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    payment_method,
    COUNT(*) AS total_payments,
    SUM(amount) AS total_amount
FROM payments
WHERE payment_status = 'APPROVED'
  AND payment_date >= '2018-01-01'
  AND payment_date < '2019-01-01'
GROUP BY payment_method
ORDER BY total_amount DESC;


-- ==========================================================
-- Q8. Historial transaccional por evento
-- Caso crítico: auditoría Event-Driven
-- ==========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    event_type,
    COUNT(*) AS total_events
FROM transaction_history
WHERE created_at >= '2018-01-01'
  AND created_at < '2019-01-01'
  AND event_type = 'ORDER_CREATED'
GROUP BY event_type;