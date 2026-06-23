-- 03_staging_olist.sql
-- Tablas staging para importar CSV del dataset Olist/Kaggle.
-- Ejecutar después de 00_extensions.sql, 01_schema.sql y 02_partitioning.sql.

SET search_path TO public;

DROP TABLE IF EXISTS stg_olist_order_reviews CASCADE;
DROP TABLE IF EXISTS stg_olist_order_payments CASCADE;
DROP TABLE IF EXISTS stg_olist_order_items CASCADE;
DROP TABLE IF EXISTS stg_olist_orders CASCADE;
DROP TABLE IF EXISTS stg_olist_products CASCADE;
DROP TABLE IF EXISTS stg_olist_sellers CASCADE;
DROP TABLE IF EXISTS stg_olist_customers CASCADE;
DROP TABLE IF EXISTS stg_olist_geolocation CASCADE;
DROP TABLE IF EXISTS stg_product_category_translation CASCADE;

CREATE TABLE stg_olist_customers (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix INTEGER,
    customer_city TEXT,
    customer_state TEXT
);

CREATE TABLE stg_olist_sellers (
    seller_id TEXT,
    seller_zip_code_prefix INTEGER,
    seller_city TEXT,
    seller_state TEXT
);

CREATE TABLE stg_olist_geolocation (
    geolocation_zip_code_prefix INTEGER,
    geolocation_lat NUMERIC(12,8),
    geolocation_lng NUMERIC(12,8),
    geolocation_city TEXT,
    geolocation_state TEXT
);

CREATE TABLE stg_olist_products (
    product_id TEXT,
    product_category_name TEXT,
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);

CREATE TABLE stg_product_category_translation (
    product_category_name TEXT,
    product_category_name_english TEXT
);

CREATE TABLE stg_olist_orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE stg_olist_order_items (
    order_id TEXT,
    order_item_id INTEGER,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TIMESTAMP,
    price NUMERIC(12,2),
    freight_value NUMERIC(12,2)
);

CREATE TABLE stg_olist_order_payments (
    order_id TEXT,
    payment_sequential INTEGER,
    payment_type TEXT,
    payment_installments INTEGER,
    payment_value NUMERIC(12,2)
);

CREATE TABLE stg_olist_order_reviews (
    review_id TEXT,
    order_id TEXT,
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

-- ==========================================================
-- Auxiliar geolocalización por ZIP
-- Reduce duplicados del dataset geolocation
-- ==========================================================

DROP TABLE IF EXISTS aux_geolocation_zip;

CREATE TABLE aux_geolocation_zip AS
SELECT
    geolocation_zip_code_prefix,
    AVG(geolocation_lat) AS avg_lat,
    AVG(geolocation_lng) AS avg_lng
FROM stg_olist_geolocation
GROUP BY geolocation_zip_code_prefix;

CREATE INDEX idx_aux_geolocation_zip
ON aux_geolocation_zip(geolocation_zip_code_prefix);

SELECT COUNT(*) AS total_zip_codes
FROM aux_geolocation_zip;