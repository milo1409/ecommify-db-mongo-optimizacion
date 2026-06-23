# 08_collection_counts.py
# Genera conteo de documentos por colección MongoDB.
# Salida: mongodb/results/collection_counts.csv

from pymongo import MongoClient
import pandas as pd
import os

# ==========================================================
# 1. Conexión MongoDB Atlas
# ==========================================================

MONGO_URI = "mongodb+srv://ecommify_user:Y6xLoVUpkST8EpZ8@ecommify.a9hp3x7.mongodb.net/?appName=Ecommify"
DATABASE_NAME = "ecommify_db"

client = MongoClient(MONGO_URI)
db = client[DATABASE_NAME]

# ==========================================================
# 2. Colecciones esperadas en el diseño Ecommify
# ==========================================================

collections = [
    "product_catalog",
    "product_reviews",
    "user_behavior",
    "recommendations",
    "search_logs"
]

# También se conserva si existe como colección auxiliar
optional_collections = [
    "sellers"
]

rows = []

for collection_name in collections + optional_collections:
    if collection_name in db.list_collection_names():
        count = db[collection_name].count_documents({})
        status = "OK"
    else:
        count = 0
        status = "MISSING"

    rows.append({
        "collection": collection_name,
        "documents": count,
        "status": status
    })

# ==========================================================
# 3. Exportar CSV
# ==========================================================

output_dir = "mongodb/results"
os.makedirs(output_dir, exist_ok=True)

df = pd.DataFrame(rows)
output_path = os.path.join(output_dir, "collection_counts.csv")

df.to_csv(output_path, index=False, encoding="utf-8")

print("Conteo de colecciones MongoDB")
print(df.to_string(index=False))

print(f"\nArchivo generado: {output_path}")