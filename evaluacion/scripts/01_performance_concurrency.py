# 01_performance_concurrency.py
# Pruebas de concurrencia PostgreSQL vs MongoDB para Ecommify

import time
import statistics
from concurrent.futures import ThreadPoolExecutor, as_completed

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

CONCURRENT_USERS = [1, 5, 10] # No se puede usar 25 y 50 por los limites de la plataformas 
ITERATIONS_PER_USER = 10

os.makedirs("evaluation/results", exist_ok=True)


def run_postgres_query():
    query = """
        SELECT
            o.user_id,
            COUNT(*) AS total_orders,
            SUM(o.total) AS total_amount
        FROM orders o
        WHERE o.created_at >= '2018-01-01'
          AND o.created_at < '2019-01-01'
        GROUP BY o.user_id
        ORDER BY total_amount DESC
        LIMIT 20;
    """

    start = time.time()

    conn = psycopg2.connect(**POSTGRES_CONFIG)
    with conn.cursor(cursor_factory=RealDictCursor) as cursor:
        cursor.execute(query)
        cursor.fetchall()
    conn.close()

    end = time.time()
    return (end - start) * 1000


def run_mongo_query():
    start = time.time()

    client = MongoClient(MONGO_URI)
    db = client[MONGO_DATABASE]

    list(db.product_catalog.aggregate([
        {
            "$group": {
                "_id": "$category",
                "total_products": {"$sum": 1},
                "avg_price": {"$avg": "$price"}
            }
        },
        {"$sort": {"total_products": -1}},
        {"$limit": 20}
    ]))

    client.close()

    end = time.time()
    return (end - start) * 1000


def execute_load_test(engine_name, query_function, concurrent_users):
    latencies = []

    start_total = time.time()

    with ThreadPoolExecutor(max_workers=concurrent_users) as executor:
        futures = []

        for _ in range(concurrent_users * ITERATIONS_PER_USER):
            futures.append(executor.submit(query_function))

        for future in as_completed(futures):
            latencies.append(future.result())

    end_total = time.time()

    total_requests = len(latencies)
    duration_seconds = end_total - start_total
    throughput = total_requests / duration_seconds

    return {
        "engine": engine_name,
        "concurrent_users": concurrent_users,
        "total_requests": total_requests,
        "avg_latency_ms": round(statistics.mean(latencies), 2),
        "p95_latency_ms": round(statistics.quantiles(latencies, n=20)[18], 2),
        "max_latency_ms": round(max(latencies), 2),
        "throughput_req_sec": round(throughput, 2)
    }


results = []

for users in CONCURRENT_USERS:
    print(f"Ejecutando PostgreSQL con {users} usuarios concurrentes...")
    results.append(
        execute_load_test("PostgreSQL", run_postgres_query, users)
    )

    print(f"Ejecutando MongoDB con {users} usuarios concurrentes...")
    results.append(
        execute_load_test("MongoDB", run_mongo_query, users)
    )

df = pd.DataFrame(results)
df.to_csv("evaluation/results/performance_concurrency_results.csv", index=False)

print("\nResultados:")
print(df.to_string(index=False))