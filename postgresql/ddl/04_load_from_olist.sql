SET search_path TO public;

-- ==========================================================
-- Limpieza de tablas finales
-- ==========================================================

TRUNCATE TABLE
    sync_audit,
    transaction_history,
    reviews,
    shipments,
    payments,
    order_details,
    orders,
    cart_items,
    carts,
    inventories,
    products,
    categories,
    addresses,
    users
RESTART IDENTITY CASCADE;


-- ==========================================================
-- 1. Categorías
-- ==========================================================

INSERT INTO categories (
    name,
    description
)
SELECT DISTINCT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS name,
    'Category imported from Olist dataset' AS description
FROM stg_olist_products p
LEFT JOIN stg_product_category_translation t
    ON p.product_category_name = t.product_category_name
WHERE COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') IS NOT NULL
ON CONFLICT (name) DO NOTHING;


-- ==========================================================
-- 2. Usuarios desde customers
-- ==========================================================

INSERT INTO users (
    name,
    email,
    password_hash,
    phone,
    created_at,
    status
)
SELECT
    'Customer ' || customer_unique_id AS name,
    customer_id || '@olist.local' AS email,
    encode(digest(customer_id, 'sha256'), 'hex') AS password_hash,
    NULL AS phone,
    NOW() AS created_at,
    'ACTIVE' AS status
FROM stg_olist_customers
ON CONFLICT (email) DO NOTHING;


-- ==========================================================
-- 3. Direcciones desde customers + geolocation
-- Usa PostGIS para poblar addresses.location
-- ==========================================================

INSERT INTO addresses (
    user_id,
    city,
    country,
    address,
    postal_code,
    location,
    address_data
)
SELECT
    u.id AS user_id,
    c.customer_city AS city,
    'Brazil' AS country,
    'Address generated from Olist customer zip code' AS address,
    c.customer_zip_code_prefix::TEXT AS postal_code,
    CASE
        WHEN g.avg_lng IS NOT NULL AND g.avg_lat IS NOT NULL THEN
            ST_SetSRID(
                ST_MakePoint(g.avg_lng, g.avg_lat),
                4326
            )::geography
        ELSE NULL::geography
    END AS location,
    ROW(
        'Address generated from Olist',
        c.customer_zip_code_prefix::TEXT,
        c.customer_city,
        c.customer_state
    )::address_type AS address_data
FROM stg_olist_customers c
JOIN users u
    ON u.email = c.customer_id || '@olist.local'
LEFT JOIN (
    SELECT
        geolocation_zip_code_prefix,
        AVG(geolocation_lat) AS avg_lat,
        AVG(geolocation_lng) AS avg_lng
    FROM stg_olist_geolocation
    GROUP BY geolocation_zip_code_prefix
) g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;


-- ==========================================================
-- 3. Direcciones desde customers + geolocation
-- Usa PostGIS para poblar addresses.location
-- ==========================================================

INSERT INTO addresses (
    user_id,
    city,
    country,
    address,
    postal_code,
    location,
    address_data
)
SELECT
    u.id AS user_id,
    c.customer_city AS city,
    'Brazil' AS country,
    'Address generated from Olist customer zip code' AS address,
    c.customer_zip_code_prefix::TEXT AS postal_code,
    CASE
        WHEN g.avg_lng IS NOT NULL AND g.avg_lat IS NOT NULL THEN
            ST_SetSRID(
                ST_MakePoint(g.avg_lng, g.avg_lat),
                4326
            )::geography
        ELSE NULL::geography
    END AS location,
    ROW(
        'Address generated from Olist',
        c.customer_zip_code_prefix::TEXT,
        c.customer_city,
        c.customer_state
    )::address_type AS address_data
FROM stg_olist_customers c
JOIN users u
    ON u.email = c.customer_id || '@olist.local'
LEFT JOIN aux_geolocation_zip g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;


- ==========================================================
-- 4. Productos desde products + order_items + sellers
-- Usa JSONB y ARRAY
-- ==========================================================

INSERT INTO products (
    name,
    description,
    price,
    category_id,
    attributes,
    tags,
    created_at,
    status
)
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') || ' product' AS name,
    'Product imported from Olist dataset' AS description,
    COALESCE(AVG(oi.price), 0)::NUMERIC(12,2) AS price,
    c.id AS category_id,
    jsonb_build_object(
        'source_product_id', p.product_id,
        'source_category', p.product_category_name,
        'weight_g', p.product_weight_g,
        'length_cm', p.product_length_cm,
        'height_cm', p.product_height_cm,
        'width_cm', p.product_width_cm,
        'photos_qty', p.product_photos_qty,
        'name_length', p.product_name_lenght,
        'description_length', p.product_description_lenght,
        'seller_id', MIN(oi.seller_id),
        'seller_city', MIN(s.seller_city),
        'seller_state', MIN(s.seller_state)
    ) AS attributes,
    ARRAY[
        COALESCE(t.product_category_name_english, p.product_category_name, 'unknown'),
        'olist',
        'ecommify'
    ]::TEXT[] AS tags,
    NOW() AS created_at,
    CASE
        WHEN COUNT(oi.order_id) > 0 THEN 'ACTIVE'
        ELSE 'INACTIVE'
    END AS status
FROM stg_olist_products p
LEFT JOIN stg_product_category_translation t
    ON p.product_category_name = t.product_category_name
LEFT JOIN stg_olist_order_items oi
    ON p.product_id = oi.product_id
LEFT JOIN stg_olist_sellers s
    ON oi.seller_id = s.seller_id
JOIN categories c
    ON c.name = COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
GROUP BY
    p.product_id,
    p.product_category_name,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    t.product_category_name_english,
    c.id;


-- ==========================================================
-- 5. Inventarios simulados desde ventas reales
-- ==========================================================

INSERT INTO inventories (
    product_id,
    stock,
    reserved_stock,
    last_update
)
SELECT
    p.id AS product_id,
    GREATEST(100 - COALESCE(sales.total_items, 0), 0)::INTEGER AS stock,
    0 AS reserved_stock,
    NOW() AS last_update
FROM products p
LEFT JOIN (
    SELECT
        product_id,
        COUNT(*) AS total_items
    FROM stg_olist_order_items
    GROUP BY product_id
) sales
    ON p.attributes->>'source_product_id' = sales.product_id;


-- ==========================================================
-- 6. Carritos derivados de usuarios
-- ==========================================================

INSERT INTO carts (
    user_id,
    status,
    created_at,
    updated_at,
    expires_at
)
SELECT
    id AS user_id,
    'ACTIVE' AS status,
    NOW() AS created_at,
    NOW() AS updated_at,
    NOW() + INTERVAL '30 days' AS expires_at
FROM users
WHERE id <= 500;


-- ==========================================================
-- 7. Órdenes desde stg_olist_orders
-- ==========================================================

INSERT INTO orders (
    user_id,
    total,
    status,
    created_at,
    metadata
)
SELECT
    u.id AS user_id,
    COALESCE(order_totals.total, 0)::NUMERIC(12,2) AS total,
    CASE
        WHEN o.order_status = 'delivered' THEN 'DELIVERED'
        WHEN o.order_status = 'shipped' THEN 'SHIPPED'
        WHEN o.order_status = 'canceled' THEN 'CANCELLED'
        WHEN o.order_status = 'approved' THEN 'PAID'
        WHEN o.order_status = 'invoiced' THEN 'PAID'
        ELSE 'CREATED'
    END AS status,
    COALESCE(o.order_purchase_timestamp, NOW()) AS created_at,
    jsonb_build_object(
        'source_order_id', o.order_id,
        'source_status', o.order_status,
        'approved_at', o.order_approved_at,
        'delivered_carrier_date', o.order_delivered_carrier_date,
        'delivered_customer_date', o.order_delivered_customer_date,
        'estimated_delivery_date', o.order_estimated_delivery_date,
        'source', 'olist'
    ) AS metadata
FROM stg_olist_orders o
JOIN stg_olist_customers c
    ON o.customer_id = c.customer_id
JOIN users u
    ON u.email = c.customer_id || '@olist.local'
LEFT JOIN (
    SELECT
        order_id,
        SUM(price + freight_value) AS total
    FROM stg_olist_order_items
    GROUP BY order_id
) order_totals
    ON o.order_id = order_totals.order_id;


-- ==========================================================
-- 8. Detalle de órdenes desde order_items
-- ==========================================================

INSERT INTO order_details (
    order_id,
    order_created_at,
    product_id,
    quantity,
    unit_price
)
SELECT
    o.id AS order_id,
    o.created_at AS order_created_at,
    p.id AS product_id,
    1 AS quantity,
    oi.price AS unit_price
FROM stg_olist_order_items oi
JOIN orders o
    ON o.metadata->>'source_order_id' = oi.order_id
JOIN products p
    ON p.attributes->>'source_product_id' = oi.product_id;


-- ==========================================================
-- 9. Pagos desde order_payments
-- Olist puede tener varios pagos por orden.
-- El modelo Ecommify consolida un pago por orden.
-- ==========================================================

INSERT INTO payments (
    order_id,
    order_created_at,
    payment_method,
    payment_status,
    external_reference,
    payment_date,
    amount
)
SELECT
    o.id AS order_id,
    o.created_at AS order_created_at,
    MIN(op.payment_type) AS payment_method,
    CASE
        WHEN o.status = 'CANCELLED' THEN 'CANCELLED'
        ELSE 'APPROVED'
    END AS payment_status,
    op.order_id AS external_reference,
    o.created_at + INTERVAL '5 minutes' AS payment_date,
    SUM(op.payment_value)::NUMERIC(12,2) AS amount
FROM stg_olist_order_payments op
JOIN orders o
    ON o.metadata->>'source_order_id' = op.order_id
GROUP BY
    o.id,
    o.created_at,
    o.status,
    op.order_id;


-- ==========================================================
-- 10. Envíos desde orders
-- ==========================================================

INSERT INTO shipments (
    order_id,
    order_created_at,
    carrier,
    tracking_number,
    shipment_status,
    shipped_at,
    delivered_at,
    estimated_delivery_at
)
SELECT
    o.id AS order_id,
    o.created_at AS order_created_at,
    'Olist Logistics' AS carrier,
    'OLIST-' || (o.metadata->>'source_order_id') AS tracking_number,
    CASE
        WHEN o.status = 'DELIVERED' THEN 'DELIVERED'
        WHEN o.status = 'SHIPPED' THEN 'IN_TRANSIT'
        ELSE 'PENDING'
    END AS shipment_status,
    NULLIF(o.metadata->>'delivered_carrier_date', '')::TIMESTAMP AS shipped_at,
    NULLIF(o.metadata->>'delivered_customer_date', '')::TIMESTAMP AS delivered_at,
    NULLIF(o.metadata->>'estimated_delivery_date', '')::TIMESTAMP AS estimated_delivery_at
FROM orders o;


-- ==========================================================
-- 11. Reseñas desde order_reviews
-- ==========================================================

INSERT INTO reviews (
    user_id,
    product_id,
    order_id,
    order_created_at,
    rating,
    title,
    comment,
    created_at
)
SELECT DISTINCT ON (u.id, p.id, o.id)
    u.id AS user_id,
    p.id AS product_id,
    o.id AS order_id,
    o.created_at AS order_created_at,
    r.review_score AS rating,
    r.review_comment_title AS title,
    r.review_comment_message AS comment,
    COALESCE(r.review_creation_date, o.created_at) AS created_at
FROM stg_olist_order_reviews r
JOIN orders o
    ON o.metadata->>'source_order_id' = r.order_id
JOIN stg_olist_orders so
    ON so.order_id = r.order_id
JOIN stg_olist_customers c
    ON c.customer_id = so.customer_id
JOIN users u
    ON u.email = c.customer_id || '@olist.local'
JOIN stg_olist_order_items oi
    ON oi.order_id = r.order_id
JOIN products p
    ON p.attributes->>'source_product_id' = oi.product_id
WHERE r.review_score BETWEEN 1 AND 5;


-- ==========================================================
-- 12. Historial transaccional desde órdenes
-- ==========================================================

INSERT INTO transaction_history (
    entity_name,
    entity_id,
    event_type,
    payload,
    created_at
)
SELECT
    'orders' AS entity_name,
    o.id AS entity_id,
    'ORDER_CREATED' AS event_type,
    jsonb_build_object(
        'order_id', o.id,
        'source_order_id', o.metadata->>'source_order_id',
        'user_id', o.user_id,
        'status', o.status,
        'total', o.total
    ) AS payload,
    o.created_at
FROM orders o;


-- ==========================================================
-- 13. Historial transaccional desde pagos
-- ==========================================================

INSERT INTO transaction_history (
    entity_name,
    entity_id,
    event_type,
    payload,
    created_at
)
SELECT
    'payments' AS entity_name,
    p.id AS entity_id,
    'PAYMENT_' || p.payment_status AS event_type,
    jsonb_build_object(
        'payment_id', p.id,
        'order_id', p.order_id,
        'amount', p.amount,
        'method', p.payment_method,
        'external_reference', p.external_reference
    ) AS payload,
    p.payment_date
FROM payments p;


-- ==========================================================
-- 14. Auditoría inicial
-- ==========================================================

INSERT INTO sync_audit (
    sync_name,
    status,
    records_processed,
    started_at,
    finished_at
)
VALUES (
    'load_from_olist_kaggle',
    'SUCCESS',
    (SELECT COUNT(*) FROM users)
        + (SELECT COUNT(*) FROM products)
        + (SELECT COUNT(*) FROM orders)
        + (SELECT COUNT(*) FROM payments),
    NOW(),
    NOW()
);





-- ==========================================================
-- 15. Validación de conteos finales
-- ==========================================================

SELECT 'users' AS table_name, COUNT(*) AS total FROM users
UNION ALL
SELECT 'addresses', COUNT(*) FROM addresses
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'inventories', COUNT(*) FROM inventories
UNION ALL
SELECT 'carts', COUNT(*) FROM carts
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_details', COUNT(*) FROM order_details
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'shipments', COUNT(*) FROM shipments
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'transaction_history', COUNT(*) FROM transaction_history
UNION ALL
SELECT 'sync_audit', COUNT(*) FROM sync_audit
ORDER BY table_name;