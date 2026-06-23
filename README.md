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

### Conclusión de optimización PostgreSQL

La optimización PostgreSQL cumplió con los criterios técnicos definidos en la actividad. Se implementaron índices especializados B-tree, GIN, GiST y BRIN; se aplicó particionamiento declarativo sobre tablas de alto volumen; y se generaron evidencias cuantitativas antes/después mediante `EXPLAIN (ANALYZE, BUFFERS)`.

Los resultados muestran mejoras significativas en consultas transaccionales, analíticas, textuales, geoespaciales y de auditoría. Además, los casos donde no hubo mejora fueron analizados técnicamente, demostrando que la optimización debe basarse en evidencia y no únicamente en la creación de índices.

