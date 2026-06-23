# 06_generate_recommendations.py
# Genera recomendaciones simuladas para usuarios de Ecommify.
# Usa product_catalog y user_behavior como fuente documental.

from pymongo import MongoClient, UpdateOne
from datetime import datetime
import random

# ==========================================================
# 1. Conexión MongoDB Atlas
# ==========================================================

MONGO_URI = "mongodb+srv://ecommify_user:Y6xLoVUpkST8EpZ8@ecommify.a9hp3x7.mongodb.net/?appName=Ecommify"
DATABASE_NAME = "ecommify_db"

client = MongoClient(MONGO_URI)
db = client[DATABASE_NAME]

product_catalog = db["product_catalog"]
user_behavior = db["user_behavior"]
recommendations = db["recommendations"]


# ==========================================================
# 2. Obtener productos populares por categoría
# ==========================================================

popular_products = list(product_catalog.aggregate([
    {
        "$project": {
            "product_id": 1,
            "name": 1,
            "category": 1,
            "price": 1,
            "rating_summary": 1,
            "score": {
                "$add": [
                    {"$ifNull": ["$rating_summary.average_rating", 0]},
                    {
                        "$multiply": [
                            {"$ifNull": ["$rating_summary.total_reviews", 0]},
                            0.01
                        ]
                    }
                ]
            }
        }
    },
    {
        "$sort": {
            "score": -1
        }
    },
    {
        "$limit": 1000
    }
]))

print(f"Productos populares cargados: {len(popular_products)}")


# ==========================================================
# 3. Obtener usuarios desde user_behavior
# ==========================================================

users = list(user_behavior.aggregate([
    {
        "$group": {
            "_id": "$user_id",
            "categories": {
                "$addToSet": "$events.category"
            }
        }
    },
    {
        "$limit": 1000
    }
]))

print(f"Usuarios con comportamiento encontrados: {len(users)}")


# ==========================================================
# 4. Función para generar recomendaciones por usuario
# ==========================================================

def generate_user_recommendations(user_doc):
    user_id = user_doc["_id"]

    raw_categories = user_doc.get("categories", [])
    user_categories = []

    for item in raw_categories:
        if isinstance(item, list):
            user_categories.extend(item)
        elif isinstance(item, str):
            user_categories.append(item)

    user_categories = list(set([c for c in user_categories if c]))

    if user_categories:
        candidate_products = [
            p for p in popular_products
            if p.get("category") in user_categories
        ]
    else:
        candidate_products = popular_products

    if len(candidate_products) < 5:
        candidate_products = popular_products

    selected = random.sample(
        candidate_products,
        min(10, len(candidate_products))
    )

    recommendation_items = []

    for product in selected:
        recommendation_items.append({
            "product_id": product.get("product_id"),
            "name": product.get("name"),
            "category": product.get("category"),
            "score": round(float(product.get("score", 0)), 4),
            "reason": "Recommended based on category affinity and product popularity"
        })

    return {
        "user_id": user_id,
        "generated_at": datetime.utcnow(),
        "recommendations": recommendation_items,
        "algorithm": {
            "name": "category_popularity_recommender",
            "version": "1.0",
            "strategy": "Category affinity + rating popularity"
        }
    }


# ==========================================================
# 5. Insertar / actualizar recomendaciones
# ==========================================================

operations = []

for user_doc in users:
    recommendation_doc = generate_user_recommendations(user_doc)

    operations.append(
        UpdateOne(
            {"user_id": recommendation_doc["user_id"]},
            {"$set": recommendation_doc},
            upsert=True
        )
    )

if operations:
    result = recommendations.bulk_write(operations)
    print("Recomendaciones generadas correctamente.")
    print("Insertadas:", result.upserted_count)
    print("Actualizadas:", result.modified_count)
else:
    print("No se encontraron usuarios para generar recomendaciones.")


# ==========================================================
# 6. Índices para recommendations
# ==========================================================

recommendations.create_index("user_id", unique=True)
recommendations.create_index("generated_at")
recommendations.create_index("recommendations.product_id")
recommendations.create_index("recommendations.category")


# ==========================================================
# 7. Validación final
# ==========================================================

print("\nConteo final recommendations:")
print(recommendations.count_documents({}))

sample = recommendations.find_one()

print("\nDocumento de ejemplo:")
print(sample)