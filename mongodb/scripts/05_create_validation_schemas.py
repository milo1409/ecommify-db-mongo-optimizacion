# 05_create_validation_schemas.py
# Crea validaciones JSON Schema para las colecciones documentales de Ecommify.
# Ejecutar después de cargar los datos base en MongoDB Atlas.

from pymongo import MongoClient
from pymongo.errors import CollectionInvalid, OperationFailure

# ==========================================================
# 1. Conexión MongoDB Atlas
# ==========================================================

MONGO_URI = "mongodb+srv://ecommify_user:Y6xLoVUpkST8EpZ8@ecommify.a9hp3x7.mongodb.net/?appName=Ecommify"
DATABASE_NAME = "ecommify_db"

client = MongoClient(MONGO_URI)
db = client[DATABASE_NAME]


# ==========================================================
# 2. Utilidad para crear o actualizar validaciones
# ==========================================================

def apply_validator(collection_name, validator):
    """
    Crea una colección con JSON Schema.
    Si la colección ya existe, actualiza su validador.
    """

    if collection_name not in db.list_collection_names():
        try:
            db.create_collection(
                collection_name,
                validator=validator,
                validationLevel="moderate",
                validationAction="warn"
            )
            print(f"[OK] Colección creada con validación: {collection_name}")
        except CollectionInvalid:
            print(f"[INFO] La colección ya existe: {collection_name}")
    else:
        try:
            db.command({
                "collMod": collection_name,
                "validator": validator,
                "validationLevel": "moderate",
                "validationAction": "warn"
            })
            print(f"[OK] Validador actualizado: {collection_name}")
        except OperationFailure as e:
            print(f"[ERROR] No se pudo actualizar {collection_name}: {e}")


# ==========================================================
# 3. JSON Schema - product_catalog
# Patrón: Attribute Pattern + Embedding
# ==========================================================

product_catalog_validator = {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "product_id",
            "name",
            "category",
            "price",
            "attributes",
            "tags",
            "rating_summary"
        ],
        "properties": {
            "product_id": {
                "bsonType": "string",
                "description": "Identificador de producto proveniente del modelo Ecommify/Olist"
            },
            "name": {
                "bsonType": "string"
            },
            "category": {
                "bsonType": "string"
            },
            "price": {
                "bsonType": ["double", "decimal", "int", "long"]
            },
            "attributes": {
                "bsonType": "object",
                "description": "Atributos dinámicos del producto"
            },
            "tags": {
                "bsonType": "array",
                "items": {
                    "bsonType": "string"
                }
            },
            "seller": {
                "bsonType": "object",
                "properties": {
                    "seller_id": {"bsonType": "string"},
                    "city": {"bsonType": "string"},
                    "state": {"bsonType": "string"}
                }
            },
            "rating_summary": {
                "bsonType": "object",
                "properties": {
                    "average_rating": {
                        "bsonType": ["double", "int", "decimal"]
                    },
                    "total_reviews": {
                        "bsonType": ["int", "long"]
                    }
                }
            },
            "reviews_embedded": {
                "bsonType": "array",
                "description": "Reseñas embebidas resumidas para consulta rápida"
            },
            "created_at": {
                "bsonType": "date"
            }
        }
    }
}


# ==========================================================
# 4. JSON Schema - product_reviews
# Patrón: Extended Reference
# ==========================================================

product_reviews_validator = {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "review_id",
            "product_id",
            "user_id",
            "rating",
            "created_at"
        ],
        "properties": {
            "review_id": {
                "bsonType": "string"
            },
            "product_id": {
                "bsonType": "string"
            },
            "user_id": {
                "bsonType": "string"
            },
            "order_id": {
                "bsonType": "string"
            },
            "rating": {
                "bsonType": ["int", "long"],
                "minimum": 1,
                "maximum": 5
            },
            "comment": {
                "bsonType": ["string", "null"]
            },
            "product_snapshot": {
                "bsonType": "object",
                "description": "Referencia extendida con datos básicos del producto"
            },
            "created_at": {
                "bsonType": "date"
            }
        }
    }
}


# ==========================================================
# 5. JSON Schema - user_behavior
# Patrón: Bucket Pattern
# ==========================================================

user_behavior_validator = {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "user_id",
            "period",
            "events"
        ],
        "properties": {
            "user_id": {
                "bsonType": "string"
            },
            "period": {
                "bsonType": "string",
                "description": "Periodo del bucket, por ejemplo 2018-01"
            },
            "events": {
                "bsonType": "array",
                "items": {
                    "bsonType": "object",
                    "required": ["event_type", "event_date"],
                    "properties": {
                        "event_type": {
                            "bsonType": "string"
                        },
                        "event_date": {
                            "bsonType": "date"
                        },
                        "product_id": {
                            "bsonType": ["string", "null"]
                        },
                        "metadata": {
                            "bsonType": "object"
                        }
                    }
                }
            },
            "event_count": {
                "bsonType": ["int", "long"]
            },
            "updated_at": {
                "bsonType": "date"
            }
        }
    }
}


# ==========================================================
# 6. JSON Schema - recommendations
# ==========================================================

recommendations_validator = {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "user_id",
            "generated_at",
            "recommendations"
        ],
        "properties": {
            "user_id": {
                "bsonType": "string"
            },
            "generated_at": {
                "bsonType": "date"
            },
            "recommendations": {
                "bsonType": "array",
                "items": {
                    "bsonType": "object",
                    "required": ["product_id", "score", "reason"],
                    "properties": {
                        "product_id": {
                            "bsonType": "string"
                        },
                        "score": {
                            "bsonType": ["double", "int", "decimal"]
                        },
                        "reason": {
                            "bsonType": "string"
                        },
                        "category": {
                            "bsonType": ["string", "null"]
                        }
                    }
                }
            }
        }
    }
}


# ==========================================================
# 7. JSON Schema - search_logs
# ==========================================================

search_logs_validator = {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "user_id",
            "query",
            "searched_at"
        ],
        "properties": {
            "user_id": {
                "bsonType": "string"
            },
            "query": {
                "bsonType": "string"
            },
            "searched_at": {
                "bsonType": "date"
            },
            "results_count": {
                "bsonType": ["int", "long"]
            },
            "filters": {
                "bsonType": "object"
            },
            "clicked_product_id": {
                "bsonType": ["string", "null"]
            }
        }
    }
}


# ==========================================================
# 8. Aplicar validadores
# ==========================================================

validators = {
    "product_catalog": product_catalog_validator,
    "product_reviews": product_reviews_validator,
    "user_behavior": user_behavior_validator,
    "recommendations": recommendations_validator,
    "search_logs": search_logs_validator
}

for collection_name, validator in validators.items():
    apply_validator(collection_name, validator)


# ==========================================================
# 9. Validación final
# ==========================================================

print("\nColecciones actuales:")
for name in db.list_collection_names():
    print("-", name)

print("\nValidadores aplicados correctamente.")