# Guía y Guion de la Presentación Final (Video 12-15 Minutos)
## Ecommify Database Optimization: PostgreSQL + MongoDB

Esta guía contiene la estructura detallada, los tiempos recomendados y el guion técnico sugerido para realizar el video de presentación final del proyecto y obtener la máxima calificación de la rúbrica (0.75 puntos).

---

## 1. Planificación de Tiempos del Video (12 a 15 Minutos)

Sigue este desglose cronológico recomendado para garantizar que abordes cada punto evaluado:

| Sección | Duración Estimada | Diapositivas | Enfoque Principal |
| :--- | :---: | :---: | :--- |
| **1. Introducción y Objetivos** | 1.5 min | Diapositivas 1-2 | Presentación de integrantes, modelo transaccional y documental, y objetivos del proyecto. |
| **2. Arquitectura Híbrida y CAP** | 2.0 min | Diapositivas 3-4 | Explicación de la separación de responsabilidades: PostgreSQL (transaccional ACID) y MongoDB (lecturas rápidas, catálogo flexible). Teorema CAP aplicado por módulo. |
| **3. Proceso de Sincronización** | 1.5 min | Diapositiva 5 | Explicación del flujo batch de sincronización idempotente PostgreSQL -> MongoDB y validación. |
| **4. Demo en Vivo** | 3.5 min | Pantalla Compartida | Demostración en vivo de la base de datos Supabase, MongoDB Atlas, ejecución del script de sincronización y scripts de pruebas de rendimiento. |
| **5. Evaluación de Rendimiento** | 2.5 min | Diapositivas 6-7 | Análisis de métricas cuantitativas antes/después de la indexación relacional/documental. |
| **6. Concurrencia y Escalabilidad** | 2.0 min | Diapositivas 8-9 | Explicación de las pruebas de carga concurrente y crecimiento de dataset. Muestra de gráficos SVG. Identificación de cuellos de botella y puntos de quiebre. |
| **7. Lecciones y Conclusiones** | 1.5 min | Diapositiva 10 | Trade-offs operacionales, ClickHouse vs MongoDB, pg_trgm vs Atlas Search, y conclusiones finales. |

---

## 2. Estructura de las Diapositivas (Markdown Slide Outline)

### Diapositiva 1: Portada y Autores
* **Título**: Solución Híbrida de Persistencia Políglota para Ecommify
* **Subtítulo**: Optimización de PostgreSQL y MongoDB
* **Autores**: Daniel Porras, Oscar Clavijo, Camilo Porras
* **Fecha**: Junio de 2026

### Diapositiva 2: Planteamiento de la Arquitectura
* **PostgreSQL / Supabase**: Motor transaccional para órdenes, pagos, inventario, con extensiones avanzadas (PostGIS, pg_trgm), tipos JSONB/Arrays y particionamiento mensual.
* **MongoDB Atlas**: Motor documental para catálogo flexible (Attribute Pattern), reseñas (Subset Pattern), eventos de navegación (Bucket Pattern) y analítica (Aggregation pipelines).

### Diapositiva 3: Teorema CAP por Módulo
* **Clasificación CP/CA (PostgreSQL)**: Registro de órdenes, inventario y procesamiento financiero. Se prioriza consistencia estricta para evitar sobreventas o transacciones inconsistentes.
* **Clasificación AP (MongoDB)**: Catálogo, recomendaciones y logs. Se prioriza alta disponibilidad y rapidez en lecturas, tolerando consistencia eventual.

### Diapositiva 4: Sincronización de Datos
* **Flujo**: PostgreSQL (Fuente relacional) $\rightarrow$ Sync Script (Python batch idempotente) $\rightarrow$ MongoDB Atlas (Destino documental).
* **Idempotencia**: Procesamiento bulk write `UpdateOne` con `upsert=True` para evitar duplicación.
* **Auditoría**: Registro y validación automática de conteo de colecciones (`sync_audit`).

### Diapositiva 5: Pruebas de Carga y Concurrencia (Metodología)
* **Concurrencia**: Simulación de 1, 5 y 10 VUs concurrentes con `ThreadPoolExecutor`.
* **Crecimiento**: Medición de latencia de consultas con 1,000, 5,000, 10,000, 25,000 y 50,000 registros.
* **Resultados**: p50, p95, rendimiento (req/s) y latencias máximas.

### Diapositiva 6: Resultados: Indexación y Optimización
* **PostgreSQL**: Q5 (pg_trgm) mejoró un **85.70%** (15.5ms a 2.2ms); Q6 (PostGIS) mejoró un **67.21%** (700ms a 229ms).
* **MongoDB**: Optimización del pipeline analítico con una mejora del **62.27%** al evitar `$unwind` de arrays e implementar proyección temprana.

### Diapositiva 7: Resultados: Carga y Escalabilidad
* **Gráficos SVG Comparativos**:
  * *Latencia de Concurrencia*: PostgreSQL mantuvo latencias promedio y throughput ligeramente superiores a MongoDB.
  * *Crecimiento de Dataset*: PostgreSQL demostró estabilidad total con tiempos constantes de ~530ms a partir de 5,000 registros; MongoDB experimentó degradación gradual (hasta 771ms).

### Diapositiva 8: Cuellos de Botella y Puntos de Quiebre
* **Punto de Quiebre**: Supabase/PostgreSQL en nivel gratuito falló a los **25 usuarios concurrentes** con error de SSL cerrado inesperadamente por falta de connection pooling.
* **Degradación en MongoDB**: El volumen de dataset incrementa el tiempo linealmente en consultas no indexadas del plan gratuito M0.

### Diapositiva 9: Trade-offs y Análisis Crítico
* **Redis vs MongoDB**: Uso de caching en RAM para reducir latencia de catálogo a microsegundos.
* **PostGIS vs 2dsphere**: Superioridad geodésica y logística de PostgreSQL PostGIS.
* **ClickHouse vs MongoDB**: MongoDB es aceptable a escala media, pero ClickHouse es necesario para millones de eventos de clickstream a escala masiva.

### Diapositiva 10: Recomendaciones 10x y Conclusiones
* **Escalamiento**: Réplicas de lectura y PgBouncer en PostgreSQL; Sharding compuesto por categoría y región en MongoDB.
* **Migración**: Estimación económica de paso a producción (Supabase Dedicado + Atlas M30 + Redis) de **$770 USD mensuales** para 10 millones de visitas.
* **CI/CD**: Integración de Flyway/pg_roll para cambios de esquema relacional y migrate-mongo para JSON Schema.

---

## 3. Guion Sugerido para la Sustentación (Script de Referencia)

### Introducción (0:00 - 1:30)
> *"Hola a todos. Sean bienvenidos a la sustentación del proyecto de optimización de la base de datos de Ecommify. Somos Daniel Porras, Oscar Clavijo y Camilo Porras. Hoy presentaremos nuestra arquitectura híbrida PostgreSQL + MongoDB, y analizaremos críticamente su rendimiento basándonos en pruebas formales de concurrencia y escalabilidad."*

### Arquitectura, CAP y Sincronización (1:30 - 4:00)
> *"Decidimos separar responsabilidades: PostgreSQL en Supabase actúa como fuente única de verdad transaccional bajo garantías ACID y consistencia estricta. MongoDB Atlas mantiene el catálogo flexible enriquecido y comportamiento analítico con consistencia eventual. La sincronización se realiza de forma asíncrona mediante un script de Python batch idempotente utilizando upsert bulk writes, garantizando la consistencia de datos y registrando auditoría en sync_audit."*

### Demo en Vivo (4:00 - 7:30)
> *(Compartir pantalla mostrando el entorno).*
> *"Aquí pueden ver la consola de Supabase con el esquema de Ecommify y tipos avanzados, y en MongoDB Atlas nuestras colecciones. Ejecutamos el script de sincronización... Listo, se han transferido miles de productos, reseñas y eventos. Ahora corramos los scripts de rendimiento de concurrencia y escalabilidad. Como ven, simulan múltiples usuarios virtuales y registran latencias en archivos CSV de resultados de forma automatizada."*

### Análisis de Resultados y Gráficas (7:30 - 11:30)
> *(Mostrar las gráficas SVG de latencia de concurrencia y crecimiento).*
> *"Las gráficas vectoriales muestran datos de gran valor. En las pruebas de concurrencia, PostgreSQL obtuvo mejor latencia promedio, pero a los 10 usuarios concurrentes MongoDB escaló competitivamente. Con 25 usuarios concurrentes encontramos nuestro punto de quiebre en Supabase debido a la falta de connection pooling. En cuanto al crecimiento de datos, PostgreSQL demostró estabilidad absoluta con latencias constantes de 530 ms a partir de 5,000 registros, mientras que MongoDB Atlas M0 reflejó una degradación gradual, lo que justifica la implementación de sharding en producción."*

### Escalamiento 10x y Conclusiones (11:30 - 14:30)
> *"Para dar soporte a un tráfico 10x, recomendamos implementar PgBouncer en PostgreSQL y fragmentar horizontalmente el catálogo de MongoDB. El costo estimado de migración a producción es de 770 dólares al mes. En conclusión, la arquitectura híbrida nos permite equilibrar la consistencia transaccional y la velocidad analítica de forma óptima. Quedamos atentos a sus preguntas y comentarios. Muchas gracias."*
