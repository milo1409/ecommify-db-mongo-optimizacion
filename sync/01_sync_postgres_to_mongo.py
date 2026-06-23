# 01_sync_postgres_to_mongo.py
# Sincronización batch idempotente PostgreSQL -> MongoDB para Ecommify.
# Este script representa el flujo de datos entre el modelo transaccional
# y el modelo documental de la arquitectura híbrida.

import os
from datetime import datetime

import psycopg2
from psycopg2.extras import RealDictCursor
from pymongo import MongoClient, UpdateOne


# ==========================================================
# 1. Configuración de conexiones
# ==========================================================

POSTGRES_CONFIG = {
    "host": "aws-1-us-east-1.pooler.supabase.com",
    "port": 6543,
    "database": "postgres",
    "user": "postgres.soipfgnihqsrivqygwyk",
    "password": "gis12345.,*-+*",
    "sslmode": "require"
}

MONGO_URI = "mongodb+srv://ecommify_user:Y6xLoVUpkST8EpZ8@ecommify.a9hp3x7.mongodb.net/?appName=Ecommify"
MONGO_DATABASE = "ecommify_db"


# ==========================================================
# 2. Conexiones
# ==========================================================

pg_conn = psycopg2.connect(**POSTGRES_CONFIG)
mongo_client = MongoClient(MONGO_URI)
mongo_db = mongo_client[MONGO_DATABASE]


# ==========================================================
# 3. Utilidad para leer PostgreSQL
# ==========================================================

def fetch_postgres(query):
    with pg_conn.cursor(cursor_factory=RealDictCursor) as cursor:
        cursor.execute(query)
        return cursor.fetchall()


# ==========================================================
# 4. Sincronizar catálogo de productos
# ==========================================================

def sync_product_catalog():
    print("\nSincronizando product_catalog...")

    query = """
        SELECT
            p.id AS product_id,
            p.name,
            p.description,
            p.price,
            c.name AS category,
            p.attributes,
            p.tags,
            p.status,
            i.stock,
            i.reserved_stock,
            p.created_at
        FROM products p
        JOIN categories c
            ON p.category_id = c.id
        LEFT JOIN inventories i
            ON p.id = i.product_id;
    """

    rows = fetch_postgres(query)
    operations = []

    for row in rows:
        doc = {
            "product_id": str(row["product_id"]),
            "name": row["name"],
            "description": row["description"],
            "price": float(row["price"]) if row["price"] is not None else 0,
            "category": row["category"],
            "attributes": row["attributes"] or {},
            "tags": row["tags"] or [],
            "status": row["status"],
            "inventory": {
                "stock": row["stock"],
                "reserved_stock": row["reserved_stock"],
                "available_stock": (
                    row["stock"] - row["reserved_stock"]
                    if row["stock"] is not None and row["reserved_stock"] is not None
                    else None
                )
            },
            "created_at": row["created_at"],
            "synced_at": datetime.utcnow(),
            "source": "postgresql_sync"
        }

        operations.append(
            UpdateOne(
                {"product_id": doc["product_id"]},
                {"$set": doc},
                upsert=True
            )
        )

    if operations:
        result = mongo_db.product_catalog.bulk_write(operations)
        print("product_catalog insertados:", result.upserted_count)
        print("product_catalog actualizados:", result.modified_count)

    print("Total procesado:", len(rows))


# ==========================================================
# 5. Sincronizar reseñas de productos
# ==========================================================

def sync_product_reviews():
    print("\nSincronizando product_reviews...")

    query = """
        SELECT
            r.id AS review_id,
            r.user_id,
            r.product_id,
            r.order_id,
            r.rating,
            r.comment,
            r.created_at,
            p.name AS product_name,
            c.name AS category
        FROM reviews r
        JOIN products p
            ON r.product_id = p.id
        JOIN categories c
            ON p.category_id = c.id;
    """

    rows = fetch_postgres(query)
    operations = []

    for row in rows:
        doc = {
            "review_id": str(row["review_id"]),
            "user_id": str(row["user_id"]),
            "product_id": str(row["product_id"]),
            "order_id": str(row["order_id"]),
            "rating": int(row["rating"]) if row["rating"] is not None else None,
            "comment": row["comment"],
            "created_at": row["created_at"],
            "product_snapshot": {
                "name": row["product_name"],
                "category": row["category"]
            },
            "synced_at": datetime.utcnow(),
            "source": "postgresql_sync"
        }

        operations.append(
            UpdateOne(
                {"review_id": doc["review_id"]},
                {"$set": doc},
                upsert=True
            )
        )

    if operations:
        result = mongo_db.product_reviews.bulk_write(operations)
        print("product_reviews insertados:", result.upserted_count)
        print("product_reviews actualizados:", result.modified_count)

    print("Total procesado:", len(rows))


# ==========================================================
# 6. Sincronizar comportamiento de usuario
# ==========================================================

def sync_user_behavior():
    print("\nSincronizando user_behavior...")

    query = """
        SELECT
            entity_id,
            entity_name,
            event_type,
            payload,
            created_at
        FROM transaction_history
        ORDER BY created_at;
    """

    rows = fetch_postgres(query)
    operations = []

    for row in rows:
        payload = row["payload"] or {}

        user_id = payload.get("user_id")
        if user_id is None:
            user_id = "unknown"

        period = row["created_at"].strftime("%Y-%m")

        event_doc = {
            "event_type": row["event_type"],
            "entity_name": row["entity_name"],
            "entity_id": str(row["entity_id"]),
            "event_date": row["created_at"],
            "metadata": payload
        }

        operations.append(
            UpdateOne(
                {
                    "user_id": str(user_id),
                    "period": period
                },
                {
                    "$push": {
                        "events": event_doc
                    },
                    "$inc": {
                        "event_count": 1
                    },
                    "$set": {
                        "updated_at": datetime.utcnow(),
                        "source": "postgresql_sync"
                    }
                },
                upsert=True
            )
        )

    if operations:
        result = mongo_db.user_behavior.bulk_write(operations)
        print("user_behavior insertados:", result.upserted_count)
        print("user_behavior actualizados:", result.modified_count)

    print("Total eventos procesados:", len(rows))


# ==========================================================
# 7. Registrar auditoría de sincronización en MongoDB
# ==========================================================

def register_sync_audit():
    mongo_db.sync_audit.insert_one({
        "sync_name": "postgresql_to_mongodb_batch_sync",
        "status": "SUCCESS",
        "executed_at": datetime.utcnow(),
        "source": "PostgreSQL/Supabase",
        "target": "MongoDB Atlas",
        "collections": [
            "product_catalog",
            "product_reviews",
            "user_behavior"
        ]
    })

    print("\nAuditoría registrada en MongoDB.")


# ==========================================================
# 8. Ejecutar sincronización
# ==========================================================

if __name__ == "__main__":
    try:
        sync_product_catalog()
        sync_product_reviews()
        sync_user_behavior()
        register_sync_audit()

        print("\nSincronización PostgreSQL -> MongoDB finalizada correctamente.")

    finally:
        pg_conn.close()
        mongo_client.close()