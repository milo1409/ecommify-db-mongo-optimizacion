# 02_sync_validation.py
# Valida conteos de colecciones sincronizadas en MongoDB.

from pymongo import MongoClient
import pandas as pd
import os

MONGO_URI = "mongodb+srv://ecommify_user:Y6xLoVUpkST8EpZ8@ecommify.a9hp3x7.mongodb.net/?appName=Ecommify"
MONGO_DATABASE = "ecommify_db"

client = MongoClient(MONGO_URI)
db = client[MONGO_DATABASE]

collections = [
    "product_catalog",
    "product_reviews",
    "user_behavior",
    "recommendations",
    "search_logs",
    "sync_audit"
]

rows = []

for collection_name in collections:
    count = db[collection_name].count_documents({})

    rows.append({
        "collection": collection_name,
        "documents": count,
        "validated_at": pd.Timestamp.now()
    })

df = pd.DataFrame(rows)

os.makedirs("sync/results", exist_ok=True)
df.to_csv("sync/results/sync_validation_results.csv", index=False)

print(df.to_string(index=False))

client.close()