# Resumen de rendimiento PostgreSQL

| Query | Antes (ms) | Después (ms) | Mejora (%) | Técnica |
|---|---:|---:|---:|---|
| Q1 Historial de órdenes por usuario | 37.83 | 13.765 | 63.61 | B-tree + partition indexes |
| Q2 Ventas por categoría y mes | 2431.127 | 1405.278 | 42.2 | B-tree + partition pruning |
| Q3 Productos por atributos JSONB | 3.25 | 4.544 | -39.82 | GIN sobre JSONB |
| Q4 Productos por tags ARRAY | 0.138 | 0.151 | -9.42 | GIN sobre ARRAY |
| Q5 Búsqueda textual con pg_trgm | 15.547 | 2.223 | 85.7 | GIN + pg_trgm |
| Q6 Consulta geoespacial con PostGIS | 700.755 | 229.75 | 67.21 | GiST sobre geography |
| Q7 Pagos aprobados por fecha | 733.974 | 276.963 | 62.27 | B-tree + BRIN + partitioning |
| Q8 Historial transaccional por evento | 1298.803 | 539.737 | 58.44 | B-tree + BRIN + partitioning |
