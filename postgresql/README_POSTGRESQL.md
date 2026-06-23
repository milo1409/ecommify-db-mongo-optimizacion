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

## Evidencias cuantitativas PostgreSQL

Para validar la optimización en PostgreSQL se ejecutaron consultas críticas usando `EXPLAIN (ANALYZE, BUFFERS)`. Las pruebas compararon el comportamiento antes y después de aplicar índices especializados y particionamiento declarativo.

Las consultas evaluadas cubren los principales casos de uso del modelo relacional de Ecommify:

| Query | Caso evaluado                                         |
| ----- | ----------------------------------------------------- |
| Q1    | Historial de órdenes por usuario                      |
| Q2    | Ventas por categoría y mes                            |
| Q3    | Búsqueda de productos por atributos dinámicos `JSONB` |
| Q4    | Búsqueda de productos por etiquetas `ARRAY`           |
| Q5    | Búsqueda textual de productos con `pg_trgm`           |
| Q6    | Consulta geoespacial con PostGIS                      |
| Q7    | Pagos aprobados por rango de fecha                    |
| Q8    | Historial transaccional por tipo de evento            |

### Resultados comparativos

| Query                                  | Tiempo antes | Tiempo después |  Mejora | Técnica aplicada                       |
| -------------------------------------- | -----------: | -------------: | ------: | -------------------------------------- |
| Q1. Historial de órdenes por usuario   |    37.830 ms |      13.765 ms |  63.61% | Índice B-tree por usuario y fecha      |
| Q2. Ventas por categoría y mes         |  2431.127 ms |    1405.278 ms |  42.20% | Particionamiento + índices en joins    |
| Q3. Productos por atributos JSONB      |     3.250 ms |       4.544 ms | -39.82% | Índice GIN sobre `attributes`          |
| Q4. Productos por tags ARRAY           |     0.138 ms |       0.151 ms |  -9.42% | Índice GIN sobre `tags`                |
| Q5. Búsqueda textual con pg_trgm       |    15.547 ms |       2.223 ms |  85.70% | Índice GIN con `pg_trgm`               |
| Q6. Consulta geoespacial con PostGIS   |   700.755 ms |     229.750 ms |  67.21% | Índice GiST sobre `location`           |
| Q7. Pagos aprobados por fecha          |   733.974 ms |     276.963 ms |  62.27% | Particionamiento + índices B-tree/BRIN |
| Q8. Historial transaccional por evento |  1298.803 ms |     539.737 ms |  58.44% | Particionamiento + índices B-tree/BRIN |

### Interpretación de resultados

La consulta Q1 presentó una mejora del **63.61%**, pasando de **37.830 ms** a **13.765 ms**. Esta mejora se debe al uso de índices B-tree sobre `user_id` y `created_at` en la tabla particionada `orders`, lo cual optimiza el historial de compras por usuario.

La consulta Q2 mejoró un **42.20%**, reduciendo el tiempo de ejecución de **2431.127 ms** a **1405.278 ms**. Esta consulta involucra varias tablas relacionales (`orders`, `order_details`, `products` y `categories`), por lo que la mejora se explica por el particionamiento de órdenes y el uso de índices en llaves de relación.

La consulta Q5 fue la de mayor mejora, con una reducción de **15.547 ms** a **2.223 ms**, equivalente a **85.70%**. Este resultado evidencia el beneficio de `pg_trgm` para búsquedas textuales avanzadas en el catálogo de productos.

La consulta Q6, asociada a geolocalización, mejoró un **67.21%** gracias al índice GiST sobre el campo `location` de tipo `geography`. Esta evidencia soporta el uso de PostGIS para consultas espaciales.

La consulta Q7 mejoró un **62.27%**, lo cual demuestra el beneficio de particionar `payments` por fecha y aplicar índices sobre estado y fecha de pago. Esta consulta representa un caso financiero crítico para análisis de pagos aprobados.

La consulta Q8 mejoró un **58.44%**, validando el uso de particionamiento en `transaction_history` y de índices sobre `event_type` para soportar trazabilidad y auditoría en una arquitectura orientada a eventos.

Las consultas Q3 y Q4 no presentaron mejora. En Q3, la condición sobre `JSONB` no retornó filas, por lo que el uso del índice no generó beneficio. En Q4, el tag `olist` está presente en la mayoría de productos, lo que reduce la selectividad del índice GIN. Estos resultados se documentan como evidencia técnica de que un índice no siempre mejora el rendimiento; su efectividad depende de la selectividad del filtro y del patrón real de consulta.


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
