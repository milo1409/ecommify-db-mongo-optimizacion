# 02_scalability_dataset_growth.py
# Pruebas de escalabilidad con datasets crecientes

import time
import psycopg2
from psycopg2.extras import RealDictCursor
from pymongo import MongoClient
import pandas as pd
import os


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

DATASET_LIMITS = [1000, 5000, 10000, 25000, 50000]

os.makedirs("evaluation/results", exist_ok=True)


def test_postgres(limit_value):
    query = f"""
        SELECT
            c.name AS category,
            COUNT(*) AS total_items,
            SUM(od.quantity * od.unit_price) AS revenue
        FROM order_details od
        JOIN products p
            ON od.product_id = p.id
        JOIN categories c
            ON p.category_id = c.id
        GROUP BY c.name
        ORDER BY revenue DESC
        LIMIT {limit_value};
    """

    start = time.time()

    conn = psycopg2.connect(**POSTGRES_CONFIG)
    with conn.cursor(cursor_factory=RealDictCursor) as cursor:
        cursor.execute(query)
        cursor.fetchall()
    conn.close()

    end = time.time()
    return round((end - start) * 1000, 2)


def test_mongo(limit_value):
    start = time.time()

    client = MongoClient(MONGO_URI)
    db = client[MONGO_DATABASE]

    list(db.product_reviews.aggregate([
        {"$limit": limit_value},
        {
            "$group": {
                "_id": "$product_id",
                "total_reviews": {"$sum": 1},
                "avg_rating": {"$avg": "$rating"}
            }
        },
        {"$sort": {"total_reviews": -1}},
        {"$limit": 20}
    ]))

    client.close()

    end = time.time()
    return round((end - start) * 1000, 2)


rows = []

for limit_value in DATASET_LIMITS:
    print(f"Probando dataset con límite {limit_value}...")

    pg_time = test_postgres(limit_value)
    mongo_time = test_mongo(limit_value)

    rows.append({
        "dataset_limit": limit_value,
        "postgres_execution_ms": pg_time,
        "mongo_execution_ms": mongo_time
    })

df = pd.DataFrame(rows)
df.to_csv("evaluation/results/scalability_dataset_growth_results.csv", index=False)

print(df.to_string(index=False))