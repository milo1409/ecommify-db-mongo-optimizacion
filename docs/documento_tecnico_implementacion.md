# Informe Técnico Integral de Implementación Optimizada: Ecommify
### Arquitectura Híbrida de Persistencia Políglota: PostgreSQL + MongoDB

**Autores:** Daniel Porras, Oscar Clavijo, Camilo Porras  
**Fecha:** Junio de 2026  
**Proyecto:** Ecommify Database Optimization  
**Repositorio Activo:** [ecommify-db-mongo-optimizacion](https://github.com/milo1409/ecommify-db-mongo-optimizacion)

---

# 1. Resumen Ejecutivo

El presente documento detalla la consolidación, optimización y evaluación crítica de la capa de persistencia de la plataforma **Ecommify**, un sistema de comercio electrónico diseñado bajo un enfoque Cloud Native y una arquitectura orientada a eventos. 

La solución propone un modelo de persistencia políglota para resolver los retos de consistencia y escalabilidad:
1. **PostgreSQL (Supabase Cloud)**: Es la **fuente única de verdad (Single Source of Truth)** para los datos transaccionales de negocio. Asegura la integridad referencial, el cumplimiento estricto de restricciones ACID y la exactitud para usuarios, direcciones, inventarios, órdenes y facturación.
2. **MongoDB (Atlas Cloud)**: Funciona como una **proyección documental de lectura** y analítica de alto volumen. Soporta la flexibilidad del catálogo enriquecido, almacenamiento de eventos de comportamiento del usuario, recomendaciones personalizadas y logs de búsqueda masiva.

Mediante técnicas de particionamiento cronológico, indexación avanzada (B-Tree, GIN, GiST, BRIN y multikey ESR) y optimización de aggregation pipelines, se redujeron las latencias de lectura en consultas críticas hasta en un **85.70%** (pg_trgm en PostgreSQL) y se disminuyeron las operaciones de escaneo de documentos en MongoDB Atlas en un **99.64%**. Asimismo, se implementó un proceso de sincronización idempotente entre ambos motores y se ejecutaron pruebas formales de concurrencia y escalabilidad con datasets crecientes para delimitar la robustez operativa de la arquitectura.

---

# 2. Implementación PostgreSQL

## 2.1 Objetivo de PostgreSQL en Ecommify
PostgreSQL garantiza la consistencia transaccional y referencial de los módulos core de negocio de Ecommify. La base de datos fue blindada con restricciones explicitas `CHECK` a nivel de base de datos para impedir estados no válidos (ej. precios o cantidades negativas, y calificaciones fuera del rango de 1 a 5 estrellas).

Las tablas relacionales creadas en el esquema `ecommify` son:
* `users` y `addresses` (con tipo geográfico PostGIS).
* `categories` y `products` (extendidas con JSONB y Arrays).
* `inventories` (reserva y stock).
* `carts` y `cart_items` (embudo transaccional).
* `orders` y `order_details` (procesamiento transaccional).
* `payments` y `reviews` (pagos y auditoría).
* `transaction_history` y `sync_audit` (logs de auditoría y sincronización).

## 2.2 Estructura del Módulo PostgreSQL
El código fuente relacional se encuentra organizado de la siguiente manera:
* [00_extensions.sql](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/postgresql/ddl/00_extensions.sql): Habilitación de extensiones (`postgis`, `pg_trgm`, `uuid-ossp`, `pgcrypto`).
* [01_schema.sql](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/postgresql/ddl/01_schema.sql): DDL principal de tablas, llaves primarias/foráneas y restricciones.
* [02_partitioning.sql](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/postgresql/ddl/02_partitioning.sql): Particionado declarativo por rango mensual.
* [07_queries_before_indexes.sql](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/postgresql/ddl/07_queries_before_indexes.sql) y [08_queries_after_indexes.sql](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/postgresql/ddl/08_queries_after_indexes.sql): Scripts de análisis comparativo SQL con planes de ejecución.
* [postgresql_performance_results.csv](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/postgresql/results/postgresql_performance_results.csv): Resultados de rendimiento en Supabase.

## 2.3 Tipos de Datos Avanzados y Extensiones
* **JSONB (`products.product_metadata`)**: Almacena características y especificaciones técnicas flexibles del producto sin alterar el esquema.
* **Arrays (`products.tags TEXT[]`)**: Almacena etiquetas de búsqueda agrupadas por producto, permitiendo la búsqueda mediante índices de contención GIN.
* **PostGIS (`addresses.location GEOGRAPHY(Point, 4326)`)**: Almacena ubicaciones espaciales en coordenadas WGS84 para cálculos geodésicos rápidos.
* **pg_trgm**: Permite realizar búsquedas difusas rápidas dividiendo los textos en trigramas de tres letras.

## 2.4 Estrategia de Particionamiento
Se aplicó particionamiento por rangos mensuales sobre la columna de fecha en las tres tablas con mayor crecimiento cronológico: `orders`, `payments` y `transaction_history`. Esto habilita el **Partition Pruning**, descartando particiones fuera del rango consultado en planes de ejecución y reduciendo el volumen físico de lectura en disco.

---

# 3. Implementación MongoDB

## 3.1 Objetivo de MongoDB en Ecommify
MongoDB Atlas sirve como el almacén documental desnormalizado optimizado para búsquedas rápidas, recomendación y analítica flexible. Su estructura de documentos flexibles reduce la latencia de las peticiones Web al precalcular uniones pesadas de tablas.

Las colecciones creadas son:
* `product_catalog` (Catálogo extendido).
* `product_reviews` (Reseñas completas).
* `sellers` (Auxiliar geográfico de vendedores).
* `user_behavior` (Eventos agrupados de navegación del usuario).
* `recommendations` (Recomendaciones por usuario).
* `search_logs` (Historial de términos buscados).

## 3.2 Patrones de Modelado Documental Aplicados
* **Attribute Pattern (`product_catalog.attributes`)**: Mapea atributos variables en parejas clave-valor `[{"k": "peso", "v": 200}]`, optimizando las búsquedas con un único índice multikey en `attributes.k` y `attributes.v`.
* **Subset Pattern (`product_catalog.recent_reviews`)**: Almacena únicamente las 3 reseñas más recientes embebidas en el catálogo de productos para evitar desbordar los 16MB de BSON. Las reseñas históricas se almacenan en `product_reviews`.
* **Extended Reference Pattern (`product_reviews.product_snapshot`)**: Guarda una referencia rápida redundante del nombre y categoría del producto dentro del documento de reseña, evitando un `$lookup` en listados de comentarios.
* **Bucket Pattern (`user_behavior`)**: Agrupa los eventos individuales de navegación de un usuario en documentos mensuales para optimizar la localidad y escrituras.

## 3.3 Validación Estructural (JSON Schema)
Se implementaron validadores estrictos con JSON Schema (mediante [05_create_validation_schemas.py](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/mongodb/scripts/05_create_validation_schemas.py)) para robustecer el catálogo, reseñas, recomendaciones y logs de comportamiento, impidiendo tipos incorrectos o valores fuera de rango.

## 3.4 Estructura del Módulo MongoDB
* [01_load_olist_dataset.py](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/mongodb/scripts/01_load_olist_dataset.py): Script de carga de datos aplicando patrones.
* [02_create_indexes.py](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/mongodb/scripts/02_create_indexes.py): Creación de índices ESR, parciales y multikey.
* [03_pipeline_optimization.py](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/mongodb/scripts/03_pipeline_optimization.py): Optimización de pipelines de agregación.

---

# 4. Sincronización PostgreSQL - MongoDB

Para mantener la consistencia eventual entre la base transaccional y la documental, se implementó un proceso de sincronización asíncrono y robusto.

## 4.1 Flujo de Sincronización
La sincronización se realiza mediante scripts de PyMongo y psycopg2:
* [01_sync_postgres_to_mongo.py](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/sync/01_sync_postgres_to_mongo.py): Script de extracción y transformación de datos.
* [02_validar_sincronizacion.py](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/sync/02_validar_sincronizacion.py): Validación y cruce de datos.
* [sync_results.csv](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/sync/results/sync_results.csv): Resultados de conteo final.

## 4.2 Mapeo e Idempotencia
La sincronización extrae los datos relacionales de productos, categorías e inventario y los unifica en la colección `product_catalog` de MongoDB aplicando operaciones de bulk write `UpdateOne` con la propiedad `upsert=True` basándose en el identificador único `product_id`. Esto garantiza la **idempotencia**: el proceso puede ejecutarse repetidamente en segundo plano, actualizando los documentos existentes y registrando los nuevos sin riesgo de duplicidad de datos. El histórico de auditoría queda registrado en la colección `sync_audit`.

---

# 5. Evaluación de Rendimiento y Escalabilidad

## 5.1 Metodología de Pruebas Aplicada
Se diseñó y ejecutó una suite de pruebas formales para medir la concurrencia y la escalabilidad bajo cargas controladas:
1. **Pruebas de Carga Concurrente ([01_performance_concurrency.py](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/evaluacion/scripts/01_performance_concurrency.py))**: Ejecución de consultas concurrentes mediante un ThreadPool con niveles de 1, 5 y 10 usuarios virtuales (VUs).
2. **Pruebas de Escalabilidad con Dataset Creciente ([02_scalability_dataset_growth.py](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/evaluacion/scripts/02_scalability_dataset_growth.py))**: Medición del impacto en latencia al procesar datasets desde 1,000 hasta 50,000 registros de forma incremental.
3. **Pruebas de Consultas Complejas ([03_complex_queries.sql](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/evaluacion/scripts/03_complex_queries.sql))**: Consultas analíticas pesadas (dashboard de ventas, bajo stock y pagos).

---

## 5.2 Resultados Cuantitativos de Pruebas de Carga y Concurrencia
Los datos obtenidos de latencia y rendimiento se detallan en [performance_concurrency_results.csv](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/evaluacion/results/performance_concurrency_results.csv):

| Motor | Usuarios Concurrentes | Solicitudes Totales | Latencia Promedio (ms) | Latencia P95 (ms) | Throughput (req/s) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **PostgreSQL** | 1 | 10 | 531.14 | 590.15 | 1.88 |
| **MongoDB** | 1 | 10 | 728.96 | 866.35 | 1.37 |
| **PostgreSQL** | 5 | 50 | 567.21 | 658.80 | 8.59 |
| **MongoDB** | 5 | 50 | 730.70 | 782.26 | 6.82 |
| **PostgreSQL** | 10 | 100 | 756.17 | 966.00 | 12.87 |
| **MongoDB** | 10 | 100 | 804.16 | 922.33 | 12.35 |

#### Interpretación de Concurrencia:
PostgreSQL/Supabase demostró latencias promedio y rendimiento (Throughput) ligeramente superiores a MongoDB en los escenarios evaluados. Sin embargo, a medida que la concurrencia escala de 1 a 10 VUs, la brecha de rendimiento entre ambos motores se reduce significativamente.

---

## 5.3 Resultados Cuantitativos de Escalabilidad con Dataset Creciente
Los resultados detallados se encuentran en [scalability_dataset_growth_results.csv](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/evaluacion/results/scalability_dataset_growth_results.csv):

| Registros Evaluados | PostgreSQL Latencia (ms) | MongoDB Latencia (ms) |
| :---: | :---: | :---: |
| **1,000** | 1775.04 | 749.62 |
| **5,000** | 533.00 | 664.17 |
| **10,000** | 527.38 | 690.64 |
| **25,000** | 535.36 | 716.42 |
| **50,000** | 531.35 | 771.77 |

#### Interpretación de Escalabilidad:
PostgreSQL muestra un comportamiento de latencia altamente estable. Después del primer inicio de rampa (calentamiento de buffers), el motor mantiene una latencia casi constante de ~530 ms sin degradación. Por otro lado, MongoDB muestra una latencia inicial baja (749 ms) pero experimenta una degradación lineal y progresiva conforme el dataset crece a 50,000 registros, justificando la necesidad de aplicar sharding en producción.

---

## 5.4 Gráficas y Métricas Clave (Visualización Vectorial SVG)

Las gráficas de rendimiento comparativo fueron generadas de forma automática mediante Python y se incrustan en formato vectorial:

### Gráfica de Latencia de Concurrencia:
![Concurrencia: Latencia Promedio (ms)](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/evaluacion/results/concurrency_latency.svg)

### Gráfica de Escalabilidad de Dataset Creciente:
![Escalabilidad: dataset limit growth](https://github.com/milo1409/ecommify-db-mongo-optimizacion/blob/main/evaluacion/results/dataset_scalability.svg)

---

## 5.5 Análisis Comparativo PostgreSQL vs MongoDB (Tabla Rúbrica)

| Aspecto Evaluado | PostgreSQL (Relacional) | MongoDB (Documental) | Ganador para Ecommify | Justificación Técnica |
| :--- | :---: | :---: | :---: | :--- |
| **Consultas Transaccionales** | Excelente (ACID) | Limitada (Multi-doc) | **PostgreSQL** | Integridad transaccional nativa requerida en órdenes, stock y pagos. |
| **Flexibilidad de Catálogo** | Media (JSONB/Array) | Alta (Atributos Libres)| **MongoDB** | El patrón Attribute y Subset evita rediseñar tablas por nuevos metadatos. |
| **Búsqueda Geoespacial** | Excelente (`PostGIS`) | Buena (2dsphere) | **PostgreSQL** | `ST_Distance` y el operador `<->` indexado por GiST proveen precisión geográfica superior. |
| **Throughput y Concurrencia** | Alto | Medio-Alto | **PostgreSQL** | Superior req/s en pruebas concurrentes controladas de base de datos. |
| **Cambios de Esquema** | Lentos (Requiere DDL) | Dinámicos (Sin downtime)| **MongoDB** | Ideal para adaptaciones rápidas de catálogo en el frontend. |
| **Estabilidad con Datasets** | Muy Alta (Consistente) | Moderada (Degradación) | **PostgreSQL** | La caché y el buffer pool relacional mantienen la latencia constante. |

---

## 5.6 Cuellos de Botella e Identificación de Limitaciones
* **Punto de Quiebre Operativo en PostgreSQL/Supabase (SSL Connection Closed)**: Al intentar elevar las pruebas de carga a **25 usuarios concurrentes**, el servicio de Supabase abortó la conexión SSL debido a límites de pool en el nivel gratuito. Se requiere un pooler (PgBouncer) para producción.
* **Degradación Documental**: Con el crecimiento del dataset (50,000 registros), la latencia en MongoDB creció un 10.3%. Esto indica que las búsquedas no indexadas adecuadamente o agregaciones pesadas degradan la CPU del clúster compartido M0 rápidamente.

---

# 6. Análisis del Teorema CAP por Módulo

El Teorema CAP clasifica los módulos de persistencia de Ecommify según su nivel de tolerancia y consistencia requerida:

1. **Módulo de Usuarios, Direcciones, Órdenes y Pagos (PostgreSQL)**:
   * **Clasificación CAP**: **CP / CA** (Consistencia / Tolerancia a Partición).
   * **Justificación de negocio**: Un pago o cobro inconsistente tiene un impacto directo y severo. Por ello, ante una partición de red se bloquea la transacción (priorizando Consistencia) en lugar de permitir saldos incorrectos.
2. **Módulo de Catálogo Enriquecido, Recomendaciones y Reseñas (MongoDB Atlas)**:
   * **Clasificación CAP**: **AP** (Disponibilidad / Tolerancia a Partición).
   * **Justificación de negocio**: La pérdida temporal de frescura en las recomendaciones o un ligero desfase en el promedio de estrellas no bloquea la navegación, por lo que se prefiere mantener el servicio disponible (Availability).

---

# 7. Recomendaciones Estratégicas y Plan de Escalamiento 10x

Para dar soporte a un tráfico 10x superior (10 millones de visitas al mes):

1. **Clúster Fragmentado (Sharding MongoDB)**:
   * Aplicar sharding sobre `product_catalog` utilizando una clave compuesta: `{"category": 1, "seller_region": 1, "_id": "hashed"}`. La localización de datos por categoría reduce las consultas distribuidas innecesarias.
2. **Réplicas de Lectura y Connection Pooling (PostgreSQL)**:
   * Aprovisionar 1 instancia maestra de escritura y 3 réplicas de lectura (Read Replicas).
   * Utilizar **PgBouncer** para reciclar conexiones de microservicios y evitar la caída del DbHandler experimentada en las pruebas.
3. **Plan de Migración Económico y Técnico**:
   * **Sizing Estimado**: Supabase dedicado XL (8 Core / 32GB RAM) + MongoDB Atlas M30 (AWS, Replica set con 150GB almacenamiento SSD) + Redis Cache administrado.
   * **Presupuesto Estimado**: **$770 USD mensuales** en producción.
4. **Integración de Tecnologías Complementarias**:
   * **Redis**: Almacena sesiones activas y caché de consultas de catálogo, aliviando la carga sobre MongoDB.
   * **Atlas Search**: Proporciona autocompletado inteligente y tolerancia a errores ortográficos.
5. **Estrategia de CI/CD para Cambios de Esquema**:
   * Incorporar **Flyway** / **pg_roll** en PostgreSQL para migraciones relacionales progresivas de despliegue continuo sin bloqueo de tablas.
   * Utilizar **migrate-mongo** en MongoDB para actualizar validaciones de JSON Schema de forma segura y en segundo plano (`background: true`).
