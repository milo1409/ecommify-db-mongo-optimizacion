# 07_generate_search_logs.py
# Genera logs de búsqueda simulados para Ecommify.
# Colección: search_logs
# Propósito: registrar consultas de usuarios sobre el catálogo.

from pymongo import MongoClient
from datetime import datetime, timedelta
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
search_logs = db["search_logs"]


# ==========================================================
# 2. Limpiar colección para carga controlada
# ==========================================================

search_logs.delete_many({})


# ==========================================================
# 3. Obtener usuarios y categorías reales
# ==========================================================

users = list(user_behavior.distinct("user_id"))

categories = list(product_catalog.distinct("category"))

categories = [c for c in categories if c]

print(f"Usuarios disponibles: {len(users)}")
print(f"Categorías disponibles: {len(categories)}")


# ==========================================================
# 4. Consultas simuladas basadas en categorías reales
# ==========================================================

generic_queries = [
    "best price",
    "free shipping",
    "discount",
    "new products",
    "popular products",
    "high rating",
    "fast delivery",
    "recommended"
]

search_terms = categories[:100] + generic_queries

if not users:
    print("No hay usuarios disponibles en user_behavior.")
    exit()

if not search_terms:
    print("No hay términos disponibles para generar búsquedas.")
    exit()


# ==========================================================
# 5. Generar logs de búsqueda
# ==========================================================

logs = []

total_logs = min(5000, len(users) * 5)

for _ in range(total_logs):
    user_id = random.choice(users)
    query = random.choice(search_terms)

    # Simula una fecha entre 2017 y 2018
    base_date = datetime(2017, 1, 1)
    random_days = random.randint(0, 700)
    searched_at = base_date + timedelta(days=random_days)

    clicked_product = product_catalog.find_one(
        {"category": query},
        {"product_id": 1, "category": 1}
    )

    clicked_product_id = None

    if clicked_product and random.random() < 0.65:
        clicked_product_id = clicked_product.get("product_id")

    log_doc = {
        "user_id": user_id,
        "query": query,
        "searched_at": searched_at,
        "results_count": random.randint(0, 120),
        "filters": {
            "category": query if query in categories else None,
            "min_rating": random.choice([None, 3, 4, 5]),
            "max_price": random.choice([None, 50, 100, 250, 500])
        },
        "clicked_product_id": clicked_product_id,
        "source": "simulated_from_ecommify_catalog"
    }

    logs.append(log_doc)


# ==========================================================
# 6. Insertar documentos
# ==========================================================

if logs:
    result = search_logs.insert_many(logs)
    print(f"Logs insertados: {len(result.inserted_ids)}")
else:
    print("No se generaron logs.")


# ==========================================================
# 7. Crear índices
# ==========================================================

search_logs.create_index("user_id")
search_logs.create_index("query")
search_logs.create_index("searched_at")
search_logs.create_index([("query", 1), ("searched_at", -1)])
search_logs.create_index("clicked_product_id")


# ==========================================================
# 8. Validación final
# ==========================================================

print("\nConteo final search_logs:")
print(search_logs.count_documents({}))

print("\nDocumento de ejemplo:")
print(search_logs.find_one())

print("\nTop 10 búsquedas:")
for item in search_logs.aggregate([
    {
        "$group": {
            "_id": "$query",
            "total_searches": {"$sum": 1}
        }
    },
    {
        "$sort": {
            "total_searches": -1
        }
    },
    {
        "$limit": 10
    }
]):
    print(item)