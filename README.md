# Ecommify DB Optimization

## Integrantes - Equipo E26

- Camilo Andres Porras Martinez
- Oscar Eduardo Clavijo Alarcon
- Edward Daniel Porras Martin

## Descripción del proyecto

Este repositorio contiene la implementación de una arquitectura híbrida de bases de datos para la plataforma **Ecommify**, una solución de comercio electrónico diseñada con enfoque Cloud Native, microservicios y arquitectura orientada a eventos.

La solución utiliza dos motores de base de datos complementarios:

* **PostgreSQL / Supabase** para los datos transaccionales críticos.
* **MongoDB Atlas** para datos documentales, flexibles, analíticos y de alto volumen.

El objetivo principal del proyecto es diseñar, implementar y optimizar una solución de persistencia poliglota que permita soportar operaciones de comercio electrónico como usuarios, productos, inventarios, órdenes, pagos, envíos, reseñas, comportamiento de usuario, recomendaciones y búsquedas.

## Arquitectura de persistencia

La arquitectura de datos se divide en dos componentes principales:

| Motor      | Responsabilidad                                                                          |
| ---------- | ---------------------------------------------------------------------------------------- |
| PostgreSQL | Consistencia fuerte, integridad referencial, órdenes, pagos, usuarios, inventarios       |
| MongoDB    | Catálogo flexible, reseñas, comportamiento de usuario, recomendaciones, logs de búsqueda |

PostgreSQL se orienta a los procesos donde se requiere control transaccional, restricciones, relaciones y consistencia. MongoDB se utiliza para estructuras flexibles, consultas documentales, patrones de lectura optimizados y datos derivados para analítica.

## Dataset utilizado

El proyecto utiliza el dataset público **Brazilian E-Commerce Public Dataset by Olist** como fuente semilla de datos.

El dataset no se usa como modelo final de base de datos. En su lugar, los archivos CSV son cargados en tablas staging y luego transformados al modelo conceptual de Ecommify.

Archivos principales utilizados:

| Archivo                                 | Uso                     |
| --------------------------------------- | ----------------------- |
| `olist_customers_dataset.csv`           | Usuarios y direcciones  |
| `olist_geolocation_dataset.csv`         | Coordenadas geográficas |
| `olist_products_dataset.csv`            | Productos               |
| `product_category_name_translation.csv` | Categorías traducidas   |
| `olist_orders_dataset.csv`              | Órdenes                 |
| `olist_order_items_dataset.csv`         | Detalles de órdenes     |
| `olist_order_payments_dataset.csv`      | Pagos                   |
| `olist_order_reviews_dataset.csv`       | Reseñas                 |
| `olist_sellers_dataset.csv`             | Vendedores              |

## Estructura del repositorio

```text
ecommify-db-optimization/
├── README.md
├── .gitignore
├── integrantes.txt
├── docs/
│   └── documento_tecnico_implementacion.md
├── postgresql/
│   ├── README_POSTGRESQL.md
│   ├── ddl/
│   │   ├── 00_extensions.sql
│   │   ├── 01_schema.sql
│   │   ├── 02_partitioning.sql
│   │   ├── 03_staging_olist.sql
│   │   ├── 05_load_from_olist.sql
│   │   └── 06_indexes.sql
│   ├── queries/
│   │   ├── 07_queries_before_indexes.sql
│   │   └── 08_queries_after_indexes.sql
│   ├── results/
│   │   └── postgresql_performance_results.csv
│   ├── notebooks/
│   │   └── grafica_rendimiento_postgresql.py
│   └── evidencias/
│       ├── schema/
│       ├── seed/
│       ├── indexes/
│       ├── explain_before/
│       ├── explain_after/
│       ├── partitioning/
│       └── charts/
├── mongodb/
│   ├── README_MONGODB.md
│   ├── schemas/
│   ├── scripts/
│   │   ├── 01_load_olist_dataset.py
│   │   ├── 02_create_indexes.py
│   │   ├── 03_pipeline_optimization.py
│   │   ├── 04_sharding_replica_design.md
│   │   ├── 05_create_validation_schemas.py
│   │   ├── 06_generate_recommendations.py
│   │   ├── 07_generate_search_logs.py
│   │   └── 08_collection_counts.py
│   ├── notebooks/
│   │   └── Mongodb_ecommify_U5_Act1.ipynb
│   ├── results/
│   │   ├── collection_counts.csv
│   │   ├── index_productivity_results.csv
│   │   ├── index_usage_stats.csv
│   │   └── pipeline_results.csv
│   └── evidencias/
│       ├── collections/
│       ├── validation/
│       ├── indexes/
│       ├── aggregations/
│       ├── atlas_metrics/
│       ├── performance_advisor/
│       └── explain/
└── sync/
```

## Implementación PostgreSQL

PostgreSQL almacena el modelo transaccional de Ecommify. Este modelo incluye entidades críticas como usuarios, direcciones, productos, inventarios, carritos, órdenes, detalles de órdenes, pagos, envíos, reseñas, historial transaccional y auditoría de sincronización.

### Características implementadas

| Característica    | Implementación                                                          |
| ----------------- | ----------------------------------------------------------------------- |
| Modelo relacional | Tablas normalizadas con llaves primarias y foráneas                     |
| Restricciones     | `CHECK`, `UNIQUE`, `NOT NULL`, integridad referencial                   |
| Tipos avanzados   | `JSONB`, `TEXT[]`, tipo compuesto, `geography`                          |
| Extensiones       | `uuid-ossp`, `pgcrypto`, `pg_trgm`, `postgis`, `pg_partman` documentado |
| Particionamiento  | Rango mensual en `orders`, `payments`, `transaction_history`            |
| Índices           | B-tree, GIN, GiST, BRIN y trigram                                       |
| Evidencia         | `EXPLAIN (ANALYZE, BUFFERS)` antes/después                              |

### Tablas principales

| Tabla                 | Registros |
| --------------------- | --------: |
| `users`               |    99.441 |
| `addresses`           |    99.441 |
| `categories`          |        74 |
| `products`            |    32.951 |
| `inventories`         |    32.951 |
| `carts`               |       500 |
| `orders`              |    99.441 |
| `order_details`       |   112.650 |
| `payments`            |    99.440 |
| `shipments`           |    99.441 |
| `reviews`             |   101.628 |
| `transaction_history` |   198.881 |
| `sync_audit`          |         1 |

### Resultados de optimización PostgreSQL

| Query                                  |       Antes |     Después |  Mejora |
| -------------------------------------- | ----------: | ----------: | ------: |
| Q1. Historial de órdenes por usuario   |   37.830 ms |   13.765 ms |  63.61% |
| Q2. Ventas por categoría y mes         | 2431.127 ms | 1405.278 ms |  42.20% |
| Q3. Productos por atributos JSONB      |    3.250 ms |    4.544 ms | -39.82% |
| Q4. Productos por tags ARRAY           |    0.138 ms |    0.151 ms |  -9.42% |
| Q5. Búsqueda textual con pg_trgm       |   15.547 ms |    2.223 ms |  85.70% |
| Q6. Consulta geoespacial con PostGIS   |  700.755 ms |  229.750 ms |  67.21% |
| Q7. Pagos aprobados por fecha          |  733.974 ms |  276.963 ms |  62.27% |
| Q8. Historial transaccional por evento | 1298.803 ms |  539.737 ms |  58.44% |

Los resultados muestran mejoras significativas en consultas transaccionales, geoespaciales, textuales, financieras y de auditoría. Las consultas Q3 y Q4 se documentan como casos donde la baja selectividad del filtro reduce el beneficio del índice.

## Implementación MongoDB

MongoDB almacena el modelo documental de Ecommify. Este motor se utiliza para representar información flexible, comportamiento de usuarios, catálogo enriquecido, reseñas, recomendaciones y logs de búsqueda.

### Colecciones principales

| Colección         | Documentos | Propósito                          |
| ----------------- | ---------: | ---------------------------------- |
| `product_catalog` |     32.951 | Catálogo documental de productos   |
| `product_reviews` |    102.172 | Reseñas de productos               |
| `user_behavior`   |    112.650 | Eventos de comportamiento          |
| `recommendations` |      1.000 | Recomendaciones por usuario        |
| `search_logs`     |      5.000 | Logs de búsqueda                   |
| `sellers`         |      3.095 | Información auxiliar de vendedores |

### Patrones de modelado documental

| Patrón             | Aplicación                                                          |
| ------------------ | ------------------------------------------------------------------- |
| Attribute Pattern  | Atributos variables en `product_catalog`                            |
| Extended Reference | Datos resumidos de producto dentro de reseñas                       |
| Bucket Pattern     | Eventos históricos de usuarios en `user_behavior`                   |
| Embedding          | Reseñas y métricas resumidas dentro del catálogo                    |
| Referencing        | Relación lógica entre usuarios, productos, reseñas y comportamiento |

### Validación e índices

Se implementó JSON Schema validation para las colecciones principales:

* `product_catalog`
* `product_reviews`
* `user_behavior`
* `recommendations`
* `search_logs`

También se crearon índices para consultas por categoría, producto, usuario, fecha, calificación, recomendaciones y búsquedas.

## Reproducibilidad

### Requisitos

* PostgreSQL o Supabase.
* MongoDB Atlas.
* Python 3.10 o superior.
* Librerías Python:

  * `pandas`
  * `matplotlib`
  * `pymongo`

Instalación de dependencias:

```bash
pip install pandas matplotlib pymongo
```

## Ejecución PostgreSQL

Ejecutar los scripts en Supabase SQL Editor o PostgreSQL en el siguiente orden:

```text
postgresql/ddl/00_extensions.sql
postgresql/ddl/01_schema.sql
postgresql/ddl/02_partitioning.sql
postgresql/ddl/03_staging_olist.sql
```

Luego importar los CSV del dataset Olist en las tablas staging.

Después ejecutar:

```text
postgresql/ddl/05_load_from_olist.sql
postgresql/ddl/06_indexes.sql
postgresql/queries/07_queries_before_indexes.sql
postgresql/queries/08_queries_after_indexes.sql
```

Finalmente generar gráficas:

```bash
python postgresql/notebooks/grafica_rendimiento_postgresql.py
```

## Ejecución MongoDB

Configurar la cadena de conexión de MongoDB Atlas en los scripts Python:

```python
MONGO_URI = "mongodb+srv://<usuario>:<password>@<cluster>.mongodb.net/"
DATABASE_NAME = "ecommify_db"
```

Ejecutar los scripts en el siguiente orden:

```bash
python mongodb/scripts/01_load_olist_dataset.py
python mongodb/scripts/02_create_indexes.py
python mongodb/scripts/03_pipeline_optimization.py
python mongodb/scripts/05_create_validation_schemas.py
python mongodb/scripts/06_generate_recommendations.py
python mongodb/scripts/07_generate_search_logs.py
python mongodb/scripts/08_collection_counts.py
```

## Evidencias

Las evidencias se encuentran organizadas en carpetas independientes para PostgreSQL y MongoDB.

### Evidencias PostgreSQL

```text
postgresql/evidencias/schema/
postgresql/evidencias/seed/
postgresql/evidencias/indexes/
postgresql/evidencias/explain_before/
postgresql/evidencias/explain_after/
postgresql/evidencias/partitioning/
postgresql/evidencias/charts/
```

### Evidencias MongoDB

```text
mongodb/evidencias/collections/
mongodb/evidencias/validation/
mongodb/evidencias/indexes/
mongodb/evidencias/aggregations/
mongodb/evidencias/atlas_metrics/
mongodb/evidencias/performance_advisor/
mongodb/evidencias/explain/
```

## Archivos de resultados

| Archivo                                                 | Descripción                            |
| ------------------------------------------------------- | -------------------------------------- |
| `postgresql/results/postgresql_performance_results.csv` | Resultados de rendimiento PostgreSQL   |
| `mongodb/results/collection_counts.csv`                 | Conteo de colecciones MongoDB          |
| `mongodb/results/index_productivity_results.csv`        | Resultados de productividad de índices |
| `mongodb/results/index_usage_stats.csv`                 | Uso de índices MongoDB                 |
| `mongodb/results/pipeline_results.csv`                  | Resultados de pipelines de agregación  |

## Conclusión

La implementación desarrollada cumple con el objetivo de construir una solución híbrida de persistencia para Ecommify. PostgreSQL soporta los procesos transaccionales críticos mediante un modelo relacional consistente, particionado e indexado. MongoDB complementa la solución con un modelo documental flexible orientado a catálogo, comportamiento, reseñas, recomendaciones y búsquedas.

Las evidencias cuantitativas demuestran mejoras de rendimiento mediante índices especializados, particionamiento, consultas explicadas y pipelines de agregación. La solución es reproducible, documentada y alineada con una arquitectura moderna de comercio electrónico.













































