-- 06_indexes.sql
-- Índices especializados PostgreSQL para Ecommify.
-- Schema usado por Supabase: public.

SET search_path TO public;

-- ==========================================================
-- 1. Índices B-tree para users
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_users_status
ON users(status);

CREATE INDEX IF NOT EXISTS idx_users_created_at
ON users(created_at);

CREATE INDEX IF NOT EXISTS idx_users_email_btree
ON users(email);


-- ==========================================================
-- 2. Índices para addresses
-- PostGIS + búsquedas por ciudad / país
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_addresses_user_id
ON addresses(user_id);

CREATE INDEX IF NOT EXISTS idx_addresses_city_country
ON addresses(city, country);

CREATE INDEX IF NOT EXISTS idx_addresses_location_gist
ON addresses USING GIST(location);


-- ==========================================================
-- 3. Índices para categories
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_categories_name
ON categories(name);


-- ==========================================================
-- 4. Índices para products
-- B-tree, GIN, pg_trgm
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_products_category_id
ON products(category_id);

CREATE INDEX IF NOT EXISTS idx_products_status
ON products(status);

CREATE INDEX IF NOT EXISTS idx_products_price
ON products(price);

CREATE INDEX IF NOT EXISTS idx_products_created_at
ON products(created_at);

-- JSONB: atributos dinámicos
CREATE INDEX IF NOT EXISTS idx_products_attributes_gin
ON products USING GIN(attributes);

-- ARRAY: tags
CREATE INDEX IF NOT EXISTS idx_products_tags_gin
ON products USING GIN(tags);

-- Búsquedas textuales avanzadas con pg_trgm
CREATE INDEX IF NOT EXISTS idx_products_name_trgm
ON products USING GIN(name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_products_description_trgm
ON products USING GIN(description gin_trgm_ops);

-- Índice funcional para trazabilidad con Olist
CREATE UNIQUE INDEX IF NOT EXISTS uq_products_source_product_id
ON products ((attributes->>'source_product_id'));


-- ==========================================================
-- 5. Índices para inventories
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_inventories_product_id
ON inventories(product_id);

CREATE INDEX IF NOT EXISTS idx_inventories_stock
ON inventories(stock);

CREATE INDEX IF NOT EXISTS idx_inventories_available_stock
ON inventories((stock - reserved_stock));


-- ==========================================================
-- 6. Índices para carts y cart_items
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_carts_user_id
ON carts(user_id);

CREATE INDEX IF NOT EXISTS idx_carts_status_expires
ON carts(status, expires_at);

CREATE INDEX IF NOT EXISTS idx_cart_items_cart_id
ON cart_items(cart_id);

CREATE INDEX IF NOT EXISTS idx_cart_items_product_id
ON cart_items(product_id);


-- ==========================================================
-- 7. Índices para orders
-- Tabla particionada por created_at
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_orders_user_created_at
ON orders(user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_orders_status_created_at
ON orders(status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_orders_created_at_brin
ON orders USING BRIN(created_at);

CREATE INDEX IF NOT EXISTS idx_orders_metadata_gin
ON orders USING GIN(metadata);

CREATE INDEX IF NOT EXISTS idx_orders_source_order_id
ON orders ((metadata->>'source_order_id'));


-- ==========================================================
-- 8. Índices para order_details
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_order_details_order
ON order_details(order_id, order_created_at);

CREATE INDEX IF NOT EXISTS idx_order_details_product
ON order_details(product_id);

CREATE INDEX IF NOT EXISTS idx_order_details_product_order
ON order_details(product_id, order_id);

CREATE INDEX IF NOT EXISTS idx_order_details_unit_price
ON order_details(unit_price);


-- ==========================================================
-- 9. Índices para payments
-- Tabla particionada por payment_date
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_payments_order
ON payments(order_id, order_created_at);

CREATE INDEX IF NOT EXISTS idx_payments_status_date
ON payments(payment_status, payment_date DESC);

CREATE INDEX IF NOT EXISTS idx_payments_method
ON payments(payment_method);

CREATE INDEX IF NOT EXISTS idx_payments_date_brin
ON payments USING BRIN(payment_date);

CREATE INDEX IF NOT EXISTS idx_payments_external_reference
ON payments(external_reference);


-- ==========================================================
-- 10. Índices para shipments
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_shipments_order
ON shipments(order_id, order_created_at);

CREATE INDEX IF NOT EXISTS idx_shipments_status
ON shipments(shipment_status);

CREATE INDEX IF NOT EXISTS idx_shipments_tracking
ON shipments(tracking_number);


-- ==========================================================
-- 11. Índices para reviews
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_reviews_user_id
ON reviews(user_id);

CREATE INDEX IF NOT EXISTS idx_reviews_product_id
ON reviews(product_id);

CREATE INDEX IF NOT EXISTS idx_reviews_rating_created_at
ON reviews(rating, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_reviews_comment_trgm
ON reviews USING GIN(comment gin_trgm_ops);


-- ==========================================================
-- 12. Índices para transaction_history
-- Tabla particionada por created_at
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_transaction_history_entity
ON transaction_history(entity_name, entity_id);

CREATE INDEX IF NOT EXISTS idx_transaction_history_event_type
ON transaction_history(event_type);

CREATE INDEX IF NOT EXISTS idx_transaction_history_created_at_brin
ON transaction_history USING BRIN(created_at);

CREATE INDEX IF NOT EXISTS idx_transaction_history_payload_gin
ON transaction_history USING GIN(payload);


-- ==========================================================
-- 13. Índices para sync_audit
-- ==========================================================

CREATE INDEX IF NOT EXISTS idx_sync_audit_name_status
ON sync_audit(sync_name, status);

CREATE INDEX IF NOT EXISTS idx_sync_audit_started_at
ON sync_audit(started_at DESC);


-- ==========================================================
-- 14. Validación de índices creados
-- ==========================================================

SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename IN (
      'users',
      'addresses',
      'categories',
      'products',
      'inventories',
      'carts',
      'cart_items',
      'orders',
      'order_details',
      'payments',
      'shipments',
      'reviews',
      'transaction_history',
      'sync_audit'
  )
ORDER BY tablename, indexname;