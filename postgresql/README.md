# Implementación PostgreSQL - Ecommify

## Descripción general

La implementación PostgreSQL de Ecommify corresponde al componente transaccional de la arquitectura híbrida de base de datos. Este motor almacena la información crítica que requiere consistencia fuerte, integridad referencial y control transaccional.

PostgreSQL fue utilizado para modelar y gestionar las siguientes capacidades principales:

* Usuarios y autenticación.
* Direcciones de usuarios.
* Categorías y productos normalizados.
* Inventarios.
* Carritos de compra.
* Órdenes.
* Detalle de órdenes.
* Pagos.
* Envíos.
* Reseñas asociadas a compras.
* Historial transaccional para trazabilidad.
* Auditoría de sincronización.

El diseño implementado se basa en el documento técnico de Ecommify, donde PostgreSQL se asigna a los datos críticos de negocio, especialmente órdenes, pagos, inventario y usuarios.

## Estructura de carpetas PostgreSQL

```text
postgresql/
├── ddl/
│   ├── 00_extensions.sql
│   ├── 01_schema.sql
│   ├── 02_partitioning.sql
│   ├── 03_staging_olist.sql
│   ├── 04_load_from_olist.sql
│   └── 05_indexes.sql
│   ├── 07_queries_before_indexes.sql
│   └── 08_queries_after_indexes.sql
├── results/
│   └── postgresql_performance_results.csv
├── notebooks/
│   └── grafica_rendimiento_postgresql.py
└── evidencias/
    ├── schema/
    ├── seed/
    ├── indexes/
    ├── explain_before/
    ├── explain_after/
    ├── partitioning/
    └── charts/
```

## Scripts implementados

### 00_extensions.sql

Este script habilita las extensiones requeridas para la solución:

| Extensión    | Uso en Ecommify                                                    |
| ------------ | ------------------------------------------------------------------ |
| `uuid-ossp`  | Generación de identificadores UUID                                 |
| `pgcrypto`   | Funciones criptográficas y hash                                    |
| `pg_trgm`    | Búsqueda textual por similitud                                     |
| `postgis`    | Soporte geoespacial para direcciones                               |
| `pg_partman` | Administración de particiones, documentada como extensión objetivo |

En Supabase, `pg_partman` puede no estar disponible según el plan o configuración del entorno. Por ese motivo, el proyecto usa particionamiento declarativo nativo de PostgreSQL.

### 01_schema.sql

Este script crea el modelo relacional principal de Ecommify. Incluye tablas normalizadas, llaves primarias, llaves foráneas, restricciones de negocio y tipos avanzados.

Tablas principales:

| Tabla                 | Propósito                               |
| --------------------- | --------------------------------------- |
| `users`               | Usuarios de la plataforma               |
| `addresses`           | Direcciones asociadas a usuarios        |
| `categories`          | Categorías de productos                 |
| `products`            | Productos normalizados                  |
| `inventories`         | Existencias disponibles y reservadas    |
| `carts`               | Carritos activos o expirados            |
| `cart_items`          | Productos agregados al carrito          |
| `orders`              | Órdenes de compra                       |
| `order_details`       | Detalle de productos por orden          |
| `payments`            | Pagos asociados a órdenes               |
| `shipments`           | Información de envío                    |
| `reviews`             | Reseñas de productos comprados          |
| `transaction_history` | Eventos transaccionales                 |
| `sync_audit`          | Auditoría de procesos de sincronización |

### Tipos avanzados usados

La implementación PostgreSQL utiliza características avanzadas solicitadas en la actividad:

| Tipo avanzado                 | Tabla                         | Uso                                         |
| ----------------------------- | ----------------------------- | ------------------------------------------- |
| `JSONB`                       | `products.attributes`         | Atributos flexibles del producto            |
| `JSONB`                       | `orders.metadata`             | Metadatos de orden y trazabilidad con Olist |
| `JSONB`                       | `transaction_history.payload` | Registro flexible de eventos                |
| `TEXT[]`                      | `products.tags`               | Etiquetas de búsqueda y clasificación       |
| Tipo compuesto `address_type` | `addresses.address_data`      | Estructura compuesta para dirección         |
| `geography(Point, 4326)`      | `addresses.location`          | Coordenadas geográficas con PostGIS         |

### 02_partitioning.sql

Se implementó particionamiento declarativo por rango de fechas en las tablas de mayor crecimiento:

| Tabla                 | Campo de particionamiento | Criterio              |
| --------------------- | ------------------------- | --------------------- |
| `orders`              | `created_at`              | Particiones mensuales |
| `payments`            | `payment_date`            | Particiones mensuales |
| `transaction_history` | `created_at`              | Particiones mensuales |

El particionamiento permite reducir el volumen de datos escaneado en consultas por rango de fecha y mejora el rendimiento en escenarios analíticos y transaccionales.

### 03_staging_olist.sql

Este script crea las tablas temporales de carga para el dataset Olist/Kaggle. Las tablas staging permiten importar los archivos CSV sin alterar directamente el modelo relacional final.

Tablas staging:

| Tabla staging                      | Archivo CSV origen                      |
| ---------------------------------- | --------------------------------------- |
| `stg_olist_customers`              | `olist_customers_dataset.csv`           |
| `stg_olist_sellers`                | `olist_sellers_dataset.csv`             |
| `stg_olist_geolocation`            | `olist_geolocation_dataset.csv`         |
| `stg_olist_products`               | `olist_products_dataset.csv`            |
| `stg_product_category_translation` | `product_category_name_translation.csv` |
| `stg_olist_orders`                 | `olist_orders_dataset.csv`              |
| `stg_olist_order_items`            | `olist_order_items_dataset.csv`         |
| `stg_olist_order_payments`         | `olist_order_payments_dataset.csv`      |
| `stg_olist_order_reviews`          | `olist_order_reviews_dataset.csv`       |

### 05_load_from_olist.sql

Este script transforma los datos del dataset Olist al modelo Ecommify. El dataset se usa como fuente de datos semilla, pero no como modelo final.

Resultados de carga:

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

La diferencia entre `orders` y `payments` se debe a que existe una orden sin pago consolidado en el dataset fuente. Las reseñas superan el número de órdenes porque una reseña de orden puede asociarse a múltiples productos comprados.

### 06_indexes.sql

Se crearon índices especializados para soportar consultas críticas:

| Tipo de índice  | Uso                                                  |
| --------------- | ---------------------------------------------------- |
| B-tree          | Filtros por usuario, estado, fecha y llaves foráneas |
| GIN             | Consultas sobre `JSONB` y arreglos `TEXT[]`          |
| GiST            | Consultas geoespaciales con PostGIS                  |
| BRIN            | Rangos de fecha en tablas particionadas              |
| GIN + `pg_trgm` | Búsqueda textual avanzada                            |

## Evidencias de rendimiento

Se ejecutaron consultas antes y después de aplicar optimizaciones usando:

```sql
EXPLAIN (ANALYZE, BUFFERS)
```

Las consultas evaluadas fueron:

| Query | Caso de uso                        |
| ----- | ---------------------------------- |
| Q1    | Historial de órdenes por usuario   |
| Q2    | Ventas por categoría y mes         |
| Q3    | Productos por atributos `JSONB`    |
| Q4    | Productos por etiquetas `ARRAY`    |
| Q5    | Búsqueda textual con `pg_trgm`     |
| Q6    | Consulta geoespacial con PostGIS   |
| Q7    | Pagos aprobados por rango de fecha |
| Q8    | Historial transaccional por evento |

Resultados:

| Query |       Antes |     Después |  Mejora |
| ----- | ----------: | ----------: | ------: |
| Q1    |   37.830 ms |   13.765 ms |  63.61% |
| Q2    | 2431.127 ms | 1405.278 ms |  42.20% |
| Q3    |    3.250 ms |    4.544 ms | -39.82% |
| Q4    |    0.138 ms |    0.151 ms |  -9.42% |
| Q5    |   15.547 ms |    2.223 ms |  85.70% |
| Q6    |  700.755 ms |  229.750 ms |  67.21% |
| Q7    |  733.974 ms |  276.963 ms |  62.27% |
| Q8    | 1298.803 ms |  539.737 ms |  58.44% |

## Interpretación

Los resultados evidencian mejoras significativas en consultas transaccionales, analíticas, textuales, geoespaciales y de auditoría.

Las mayores mejoras se observaron en:

* Búsqueda textual con `pg_trgm`: 85.70%.
* Consulta geoespacial con PostGIS: 67.21%.
* Historial de órdenes por usuario: 63.61%.
* Pagos aprobados por fecha: 62.27%.
* Historial transaccional por evento: 58.44%.

Las consultas Q3 y Q4 no presentaron mejora porque sus filtros tuvieron baja selectividad. En Q3, la condición sobre `JSONB` no retornó filas. En Q4, el tag usado estaba presente en casi todos los productos. Estos casos demuestran que la creación de índices debe justificarse con evidencia y análisis del patrón real de consulta.

## Evidencias generadas

Las evidencias se organizaron en las siguientes carpetas:

```text
postgresql/evidencias/schema/
postgresql/evidencias/seed/
postgresql/evidencias/indexes/
postgresql/evidencias/explain_before/
postgresql/evidencias/explain_after/
postgresql/evidencias/partitioning/
postgresql/evidencias/charts/
```

Archivos principales de evidencia:

| Archivo                              | Descripción                      |
| ------------------------------------ | -------------------------------- |
| `05_load_from_olist_counts.png`      | Conteos finales de carga         |
| `06_indexes_created.png`             | Índices creados                  |
| `partitions_created.png`             | Particiones declarativas         |
| `postgresql_before_after_times.png`  | Gráfica de tiempos antes/después |
| `postgresql_improvement_percent.png` | Gráfica de mejora porcentual     |
| `postgresql_performance_results.csv` | Resultados cuantitativos         |
| `postgresql_performance_summary.md`  | Resumen generado desde Python    |

## Conclusión PostgreSQL

La implementación PostgreSQL cumple con los criterios de diseño, carga, optimización y evidencia cuantitativa definidos para la actividad. Se implementó un modelo relacional normalizado, se utilizaron tipos avanzados, se habilitaron extensiones especializadas, se aplicó particionamiento declarativo y se crearon índices especializados con validación mediante `EXPLAIN ANALYZE`.

PostgreSQL quedó orientado al manejo de datos críticos de Ecommify, garantizando consistencia fuerte para usuarios, órdenes, pagos e inventarios, mientras que MongoDB será utilizado para los componentes flexibles, analíticos y de alto volumen documental.
