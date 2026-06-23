## Sincronización PostgreSQL - MongoDB

Además de la implementación independiente en PostgreSQL y MongoDB, el proyecto incluye un proceso de sincronización entre ambos motores. Este proceso representa el flujo de integración entre el modelo transaccional y el modelo documental de la arquitectura híbrida de Ecommify.

La sincronización se implementa mediante un proceso batch idempotente en Python, donde PostgreSQL actúa como fuente transaccional confiable y MongoDB como destino documental para lectura, análisis y servicios derivados.

### Flujo de sincronización

```text
PostgreSQL / Supabase
        ↓
Python Sync Process
        ↓
MongoDB Atlas
```

### Datos sincronizados

| PostgreSQL                              | MongoDB           | Propósito                             |
| --------------------------------------- | ----------------- | ------------------------------------- |
| `products`, `categories`, `inventories` | `product_catalog` | Catálogo documental enriquecido       |
| `reviews`, `products`, `categories`     | `product_reviews` | Reseñas con referencia extendida      |
| `transaction_history`                   | `user_behavior`   | Eventos de comportamiento y auditoría |

### Estrategia de sincronización

Para efectos de la actividad académica se implementó una sincronización batch idempotente mediante Python. Esta estrategia representa una aproximación al flujo orientado a eventos definido en el diseño técnico de Ecommify.

En un entorno productivo, este flujo podría evolucionar hacia una arquitectura basada en eventos utilizando tecnologías como Kafka, Debezium, Change Data Capture o colas administradas en la nube.

### Idempotencia

La sincronización usa operaciones `UpdateOne` con `upsert=True`, lo cual permite ejecutar el proceso múltiples veces sin duplicar documentos.

Esta estrategia garantiza que, si un documento ya existe en MongoDB, se actualiza; y si no existe, se inserta. De esta forma, el proceso puede repetirse de manera controlada durante pruebas o cargas incrementales.

### Archivos de sincronización

| Archivo                                    | Descripción                                            |
| ------------------------------------------ | ------------------------------------------------------ |
| `sync/README_SYNC.md`                      | Documentación específica del proceso de sincronización |
| `sync/01_sync_postgres_to_mongo.py`        | Sincroniza datos desde PostgreSQL hacia MongoDB        |
| `sync/02_sync_validation.py`               | Valida conteos finales en MongoDB                      |
| `sync/results/sync_validation_results.csv` | Resultado de validación de la sincronización           |

### Ejecución de sincronización

Instalar dependencias:

```bash
pip install psycopg2-binary pymongo pandas
```

Configurar las conexiones en los scripts:

```python
POSTGRES_CONFIG = {
    "host": "<host_supabase>",
    "port": 5432,
    "database": "postgres",
    "user": "<usuario>",
    "password": "<password>",
    "sslmode": "require"
}

MONGO_URI = "mongodb+srv://<usuario>:<password>@<cluster>.mongodb.net/"
MONGO_DATABASE = "ecommify_db"
```

Ejecutar sincronización:

```bash
python sync/01_sync_postgres_to_mongo.py
```

Validar resultados:

```bash
python sync/02_sync_validation.py
```

### Evidencias de sincronización

Las evidencias de sincronización deben guardarse en:

```text
sync/evidencias/
```

Archivos esperados:

| Evidencia                                  | Descripción                                            |
| ------------------------------------------ | ------------------------------------------------------ |
| `sync/evidencias/EjecucionSync.png`        | Captura de ejecución del proceso PostgreSQL -> MongoDB |
| `sync/evidencias/Validacion.png`           | Captura de validación de conteos sincronizados         |
| `sync/results/sync_results.csv`            | Archivo CSV con los resultados de validación           |

### Estructura de la carpeta sync

```text
sync/
├── README_SYNC.md
├── 01_sync_postgres_to_mongo.py
├── 02_sync_validation.py
├── results/
│   └── sync_results.csv
└── evidencias/
    ├── EjecucionSync.png
    └── Validacion.png
```

### Conclusión de sincronización

La sincronización demuestra la integración entre el modelo relacional y el modelo documental de Ecommify. PostgreSQL actúa como fuente transaccional confiable, mientras MongoDB funciona como repositorio flexible para lectura, análisis, comportamiento de usuario y servicios derivados.

Se implementó un proceso de sincronización batch idempotente PostgreSQL -> MongoDB, representando el flujo de integración entre el modelo transaccional y el modelo documental de la arquitectura Ecommify.
