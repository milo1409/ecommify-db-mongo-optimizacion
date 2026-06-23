# Evaluación crítica de la arquitectura híbrida Ecommify

## 1. Introducción

Esta actividad corresponde a la fase de evaluación crítica de la arquitectura híbrida implementada para Ecommify. El objetivo es analizar el rendimiento, la escalabilidad, los puntos de quiebre, los trade-offs arquitectónicos y la toma de decisiones basada en evidencia empírica.

La solución evaluada utiliza dos motores de base de datos complementarios:

| Motor                 | Rol dentro de Ecommify                                                                |
| --------------------- | ------------------------------------------------------------------------------------- |
| PostgreSQL / Supabase | Modelo transaccional, consistencia fuerte, órdenes, pagos, inventario y usuarios      |
| MongoDB Atlas         | Modelo documental, catálogo flexible, reseñas, comportamiento, recomendaciones y logs |

La evaluación se centra en determinar si la arquitectura híbrida es adecuada para los requerimientos de negocio de Ecommify y en identificar escenarios donde cada tecnología ofrece mayor valor.

---

## 2. Metodología de pruebas de rendimiento y escalabilidad

Se diseñó una suite de pruebas con tres enfoques principales:

1. Pruebas de carga con usuarios concurrentes.
2. Pruebas de escalabilidad con datasets crecientes.
3. Pruebas de queries complejas para dashboards y reportes.

Las pruebas fueron implementadas mediante scripts Python y SQL ubicados en la carpeta:

```text
evaluation/
├── scripts/
│   ├── 01_performance_concurrency.py
│   ├── 02_scalability_dataset_growth.py
│   └── 03_complex_queries.sql
└── results/
```

### 2.1 Pruebas de carga concurrente

El script utilizado fue:

```text
evaluation/scripts/01_performance_concurrency.py
```

La prueba simuló usuarios concurrentes ejecutando consultas críticas sobre PostgreSQL y MongoDB.

Niveles evaluados:

| Escenario       | Usuarios concurrentes |
| --------------- | --------------------: |
| Bajo            |                     1 |
| Medio           |                     5 |
| Alto controlado |                    10 |

Inicialmente se intentó una prueba con 25 usuarios concurrentes en PostgreSQL/Supabase, pero se identificó un punto de quiebre operativo por cierre inesperado de conexión SSL.

### 2.2 Métricas registradas

| Métrica           | Descripción                                                    |
| ----------------- | -------------------------------------------------------------- |
| Latencia promedio | Tiempo promedio de respuesta por solicitud                     |
| Latencia P95      | Percentil 95 de latencia                                       |
| Latencia máxima   | Mayor tiempo registrado                                        |
| Throughput        | Solicitudes procesadas por segundo                             |
| Punto de quiebre  | Nivel donde el sistema o servicio administrado presenta fallos |

### 2.3 Pruebas de escalabilidad con datasets crecientes

El script utilizado fue:

```text
evaluation/scripts/02_scalability_dataset_growth.py
```

Se evaluaron consultas con volúmenes crecientes de datos:

| Escenario | Límite de dataset |
| --------- | ----------------: |
| E1        |             1.000 |
| E2        |             5.000 |
| E3        |            10.000 |
| E4        |            25.000 |
| E5        |            50.000 |

El objetivo fue observar la degradación del tiempo de respuesta a medida que aumenta el volumen de datos procesado.

### 2.4 Queries complejas

El archivo utilizado fue:

```text
evaluation/scripts/03_complex_queries.sql
```

Incluye consultas orientadas a:

* Dashboard financiero mensual.
* Ventas por categoría.
* Reporte de pagos aprobados.
* Productos con bajo inventario.

Estas consultas representan escenarios de reporting y analítica operativa para Ecommify.

---

## 3. Resultados de pruebas de concurrencia

### 3.1 Resultados obtenidos

| Motor      | Usuarios concurrentes | Solicitudes totales | Latencia promedio (ms) | Latencia P95 (ms) | Latencia máxima (ms) | Throughput (req/s) |
| ---------- | --------------------: | ------------------: | ---------------------: | ----------------: | -------------------: | -----------------: |
| PostgreSQL |                     1 |                  10 |                 531.14 |            590.15 |               573.46 |               1.88 |
| MongoDB    |                     1 |                  10 |                 728.96 |            866.35 |               825.29 |               1.37 |
| PostgreSQL |                     5 |                  50 |                 567.21 |            658.80 |               672.28 |               8.59 |
| MongoDB    |                     5 |                  50 |                 730.70 |            782.26 |               790.94 |               6.82 |
| PostgreSQL |                    10 |                 100 |                 756.17 |            966.00 |               981.94 |              12.87 |
| MongoDB    |                    10 |                 100 |                 804.16 |            922.33 |               937.31 |              12.35 |

### 3.2 Interpretación

PostgreSQL presentó mejor latencia promedio en todos los niveles evaluados. Con 1 usuario concurrente obtuvo **531.14 ms**, frente a **728.96 ms** de MongoDB. Con 5 usuarios concurrentes, PostgreSQL registró **567.21 ms**, frente a **730.70 ms** de MongoDB. Con 10 usuarios concurrentes, PostgreSQL registró **756.17 ms**, mientras MongoDB registró **804.16 ms**.

En términos de throughput, PostgreSQL también obtuvo valores superiores:

| Usuarios concurrentes | PostgreSQL req/s | MongoDB req/s | Ganador    |
| --------------------: | ---------------: | ------------: | ---------- |
|                     1 |             1.88 |          1.37 | PostgreSQL |
|                     5 |             8.59 |          6.82 | PostgreSQL |
|                    10 |            12.87 |         12.35 | PostgreSQL |

La diferencia entre ambos motores se reduce en el escenario de 10 usuarios concurrentes. Esto indica que MongoDB escala de forma competitiva en cargas concurrentes de lectura agregada, aunque PostgreSQL mantuvo una ligera ventaja en esta prueba específica.

### 3.3 Punto de quiebre identificado

Durante la prueba con **25 usuarios concurrentes** en PostgreSQL/Supabase se presentó el siguiente error:

```text
OperationalError: (EDBHANDLEREXITED) DbHandler exited.
SSL connection has been closed unexpectedly.
```

Este comportamiento se documenta como punto de quiebre operativo del entorno administrado utilizado para la actividad. La causa probable está asociada a límites de conexiones concurrentes, recursos disponibles, timeout o configuración del proveedor Supabase.

Por esta razón, las pruebas finales se estabilizaron en los niveles de **1, 5 y 10 usuarios concurrentes**, donde ambos motores pudieron ser medidos de forma consistente.

Este hallazgo demuestra que la escalabilidad no depende únicamente del motor de base de datos, sino también de factores como:

* Plan del servicio administrado.
* Límites de conexiones.
* Pooling.
* Región del servicio.
* Recursos asignados.
* Configuración de timeout.

---

## 4. Resultados de escalabilidad con datasets crecientes

### 4.1 Resultados obtenidos

| Límite de dataset | PostgreSQL ejecución (ms) | MongoDB ejecución (ms) |
| ----------------: | ------------------------: | ---------------------: |
|             1.000 |                   1775.04 |                 749.62 |
|             5.000 |                    533.00 |                 664.17 |
|            10.000 |                    527.38 |                 690.64 |
|            25.000 |                    535.36 |                 716.42 |
|            50.000 |                    531.35 |                 771.77 |

### 4.2 Interpretación

En el escenario de **1.000 registros**, MongoDB fue más rápido, con **749.62 ms**, frente a **1775.04 ms** de PostgreSQL. Sin embargo, a partir de **5.000 registros**, PostgreSQL mostró tiempos más estables, manteniéndose entre **527 ms y 535 ms**.

MongoDB presentó una degradación gradual al aumentar el volumen de datos:

| Dataset | MongoDB ejecución (ms) |
| ------: | ---------------------: |
|   1.000 |                 749.62 |
|   5.000 |                 664.17 |
|  10.000 |                 690.64 |
|  25.000 |                 716.42 |
|  50.000 |                 771.77 |

PostgreSQL presentó estabilidad después del primer escenario:

| Dataset | PostgreSQL ejecución (ms) |
| ------: | ------------------------: |
|   5.000 |                    533.00 |
|  10.000 |                    527.38 |
|  25.000 |                    535.36 |
|  50.000 |                    531.35 |

El resultado inicial de PostgreSQL con 1.000 registros puede estar influenciado por calentamiento de conexión, caché, planificación inicial o condiciones temporales del entorno. Para el análisis comparativo, el comportamiento más relevante es que PostgreSQL mantuvo tiempos casi constantes entre 5.000 y 50.000 registros.

### 4.3 Comparación general

| Criterio evaluado                           | Mejor resultado observado | Justificación                                              |
| ------------------------------------------- | ------------------------- | ---------------------------------------------------------- |
| Latencia promedio con baja concurrencia     | PostgreSQL                | Menor tiempo promedio con 1 usuario concurrente            |
| Latencia promedio con concurrencia media    | PostgreSQL                | Mejor latencia con 5 y 10 usuarios concurrentes            |
| Throughput                                  | PostgreSQL                | Mayor número de solicitudes por segundo                    |
| Escalabilidad estable desde 5.000 registros | PostgreSQL                | Tiempo casi constante entre 5.000 y 50.000 registros       |
| Lectura documental flexible                 | MongoDB                   | Mejor ajuste para catálogo, reseñas, comportamiento y logs |
| Tolerancia a crecimiento documental         | MongoDB                   | Tiempo de ejecución crece gradualmente sin fallos          |
| Punto de quiebre operativo                  | PostgreSQL/Supabase       | Falla observada con 25 usuarios concurrentes               |

---

## 5. Evidencia empírica previa de optimización PostgreSQL

Durante la fase de optimización se ejecutaron consultas con:

```sql
EXPLAIN (ANALYZE, BUFFERS)
```

Resultados obtenidos:

| Query                              |       Antes |     Después |  Mejora |
| ---------------------------------- | ----------: | ----------: | ------: |
| Historial de órdenes por usuario   |   37.830 ms |   13.765 ms |  63.61% |
| Ventas por categoría y mes         | 2431.127 ms | 1405.278 ms |  42.20% |
| Productos por atributos JSONB      |    3.250 ms |    4.544 ms | -39.82% |
| Productos por tags ARRAY           |    0.138 ms |    0.151 ms |  -9.42% |
| Búsqueda textual con pg_trgm       |   15.547 ms |    2.223 ms |  85.70% |
| Consulta geoespacial con PostGIS   |  700.755 ms |  229.750 ms |  67.21% |
| Pagos aprobados por fecha          |  733.974 ms |  276.963 ms |  62.27% |
| Historial transaccional por evento | 1298.803 ms |  539.737 ms |  58.44% |

### 5.1 Cuellos de botella identificados

| Cuello de botella                              | Evidencia                                  | Impacto                   | Recomendación                                              |
| ---------------------------------------------- | ------------------------------------------ | ------------------------- | ---------------------------------------------------------- |
| Límite de concurrencia en Supabase/PostgreSQL  | Error con 25 usuarios concurrentes         | Cierre de conexión SSL    | Usar connection pooling, PgBouncer o plan con más recursos |
| Consultas analíticas multi-tabla               | Q2 tuvo el mayor tiempo incluso optimizada | Impacto en dashboards     | Materialized views o agregados precomputados               |
| Baja selectividad en tags                      | Q4 no mejoró con índice GIN                | Índice poco efectivo      | Rediseñar tags o usar filtros más selectivos               |
| JSONB sin coincidencias                        | Q3 no evidenció mejora                     | No se aprovechó el índice | Definir atributos consultados frecuentemente               |
| Joins repetitivos en dashboards                | Consultas multi-tabla costosas             | Mayor latencia            | Tablas resumen, vistas materializadas o capa OLAP          |
| Latencia MongoDB superior en concurrencia baja | MongoDB entre 728 ms y 804 ms              | Mayor tiempo promedio     | Revisar índices, región del cluster y agregaciones         |
| Escalamiento documental progresivo             | MongoDB sube hasta 771.77 ms               | Degradación gradual       | Aplicar sharding e índices compuestos                      |

---

## 6. Análisis comparativo PostgreSQL vs MongoDB para Ecommify

### 6.1 Comparación cuantitativa y funcional

| Aspecto                           | PostgreSQL | MongoDB    | Ganador para Ecommify | Justificación                                           |
| --------------------------------- | ---------- | ---------- | --------------------- | ------------------------------------------------------- |
| Consultas transaccionales         | Alto       | Medio      | PostgreSQL            | Órdenes, pagos e inventario requieren ACID              |
| Integridad referencial            | Alto       | Bajo/Medio | PostgreSQL            | Llaves foráneas y restricciones garantizan consistencia |
| Flexibilidad de catálogo          | Medio      | Alto       | MongoDB               | Product catalog tiene atributos variables               |
| Búsqueda documental               | Medio      | Alto       | MongoDB               | Modelo flexible para catálogo, reseñas y eventos        |
| Analítica de comportamiento       | Medio      | Alto       | MongoDB               | user_behavior permite eventos semiestructurados         |
| Reportes financieros              | Alto       | Medio      | PostgreSQL            | Pagos y órdenes requieren exactitud                     |
| Recomendaciones                   | Medio      | Alto       | MongoDB               | recommendations se actualiza de forma derivada          |
| Logs de búsqueda                  | Bajo/Medio | Alto       | MongoDB               | search_logs es volumen alto y flexible                  |
| Consistencia fuerte               | Alto       | Medio      | PostgreSQL            | Pagos, órdenes e inventario no admiten inconsistencia   |
| Escalabilidad horizontal          | Medio      | Alto       | MongoDB               | Sharding favorece crecimiento documental                |
| Consultas multi-tabla             | Alto       | Medio      | PostgreSQL            | SQL es más adecuado para joins complejos                |
| Cambios de esquema                | Medio      | Alto       | MongoDB               | Permite evolución rápida del modelo documental          |
| Throughput en prueba controlada   | Alto       | Medio/Alto | PostgreSQL            | Mayor req/s en 1, 5 y 10 usuarios                       |
| Estabilidad con dataset creciente | Alto       | Medio/Alto | PostgreSQL            | Tiempo casi constante desde 5.000 registros             |

### 6.2 Casos donde PostgreSQL superó expectativas

PostgreSQL mostró buen desempeño en consultas transaccionales, integridad referencial, particionamiento por fecha e índices especializados. Las mayores mejoras se observaron en búsqueda textual con `pg_trgm`, consultas geoespaciales con PostGIS y filtros por fecha/estado.

En las pruebas de concurrencia, PostgreSQL obtuvo menor latencia promedio y mayor throughput frente a MongoDB en los tres escenarios controlados.

### 6.3 Casos donde MongoDB superó expectativas

MongoDB resultó adecuado para catálogo flexible, reseñas, comportamiento de usuario, recomendaciones y logs de búsqueda. Su modelo documental permitió representar estructuras variables sin rediseñar el esquema relacional.

MongoDB también mostró comportamiento estable en crecimiento progresivo de dataset, con tiempos que aumentaron de forma gradual y sin fallos durante la prueba.

### 6.4 Módulos donde la decisión puede ser híbrida

El módulo de productos funciona mejor como módulo híbrido:

* PostgreSQL conserva el producto normalizado y relacionado con inventario.
* MongoDB mantiene el catálogo enriquecido para lectura, filtros, atributos flexibles y recomendaciones.

El módulo de reseñas también puede operar en ambos motores:

* PostgreSQL permite validar que un usuario reseñe productos comprados.
* MongoDB permite lectura rápida, analítica y visualización junto al catálogo.

### 6.5 Viabilidad de una arquitectura 100% relacional

Una arquitectura 100% PostgreSQL sería viable para consistencia, integridad y reporting SQL. Sin embargo, aumentaría la complejidad para manejar atributos variables, recomendaciones, logs y comportamiento flexible.

Además, las colecciones como `search_logs`, `user_behavior` y `recommendations` tendrían una estructura más rígida y requerirían mayor modelado relacional para eventos de naturaleza variable.

### 6.6 Viabilidad de una arquitectura 100% NoSQL

Una arquitectura 100% MongoDB sería viable para catálogo, comportamiento y escalabilidad horizontal. Sin embargo, incrementaría el riesgo en pagos, órdenes e inventario debido a menor control relacional, menor integridad referencial y mayor complejidad para garantizar consistencia fuerte.

### 6.7 Conclusión comparativa

La arquitectura híbrida es la opción más adecuada para Ecommify. PostgreSQL debe conservar los módulos transaccionales críticos y MongoDB debe manejar los módulos flexibles, documentales y analíticos.

---

## 7. Decisiones arquitectónicas basadas en Teorema CAP

### 7.1 Análisis por módulo

| Módulo                 | Motor                         | Prioridad CAP | Justificación                                         |
| ---------------------- | ----------------------------- | ------------- | ----------------------------------------------------- |
| Usuarios               | PostgreSQL                    | CP            | Se prioriza consistencia de identidad y autenticación |
| Direcciones            | PostgreSQL                    | CP            | Deben permanecer asociadas correctamente al usuario   |
| Inventario             | PostgreSQL                    | CP            | No se permite stock negativo ni sobreventa            |
| Órdenes                | PostgreSQL                    | CP            | La orden debe ser consistente y auditable             |
| Pagos                  | PostgreSQL                    | CP            | La exactitud financiera es crítica                    |
| Envíos                 | PostgreSQL                    | CP            | El envío depende de un pago válido                    |
| Catálogo enriquecido   | MongoDB                       | AP            | Se prioriza disponibilidad y lectura rápida           |
| Reseñas                | MongoDB                       | AP            | Puede tolerar consistencia eventual                   |
| Comportamiento usuario | MongoDB                       | AP            | Eventos pueden llegar con retraso                     |
| Recomendaciones        | MongoDB                       | AP            | Pueden estar desactualizadas temporalmente            |
| Search logs            | MongoDB                       | AP            | Se prioriza escritura y disponibilidad                |
| Sincronización         | Python batch / EDA conceptual | AP eventual   | Se acepta retraso entre PostgreSQL y MongoDB          |

### 7.2 Trade-offs aceptados

En módulos CP se acepta menor disponibilidad ante fallas de partición para evitar inconsistencias. Esto aplica a pagos, órdenes e inventario.

En módulos AP se acepta consistencia eventual para mantener disponibilidad y escalabilidad. Esto aplica a catálogo documental, recomendaciones, logs y comportamiento.

### 7.3 Justificación de negocio

| Decisión              | Justificación                                                    |
| --------------------- | ---------------------------------------------------------------- |
| Pagos en CP           | Un pago duplicado o inconsistente tiene impacto financiero       |
| Inventario en CP      | La sobreventa afecta la operación y experiencia del cliente      |
| Catálogo en AP        | Es aceptable mostrar temporalmente información desactualizada    |
| Recomendaciones en AP | Una recomendación retrasada no bloquea la compra                 |
| Logs en AP            | La pérdida temporal o retraso no afecta la transacción principal |

---

## 8. Análisis de escenarios de falla

### 8.1 Network partition entre PostgreSQL y MongoDB

Si ocurre una partición de red entre PostgreSQL y MongoDB, PostgreSQL debe continuar garantizando consistencia en órdenes, pagos e inventario. MongoDB puede quedar temporalmente desactualizado.

Impacto:

| Componente      | Comportamiento                                |
| --------------- | --------------------------------------------- |
| PostgreSQL      | Mantiene consistencia transaccional           |
| MongoDB         | Puede presentar datos desactualizados         |
| Recomendaciones | Pueden no reflejar compras recientes          |
| Search logs     | Pueden acumularse o perderse según estrategia |
| Sincronización  | Se reintenta mediante proceso batch o cola    |

Garantía mantenida:

* Consistencia de pagos.
* Consistencia de órdenes.
* Consistencia de inventario.

Garantía degradada:

* Frescura del catálogo documental.
* Recomendaciones recientes.
* Analítica de comportamiento en tiempo real.

### 8.2 Replication lag

Si existe retraso de replicación, las lecturas desde réplicas pueden mostrar datos antiguos. Este riesgo es aceptable para catálogo, recomendaciones y comportamiento, pero no para pagos ni inventario.

Mitigación:

* Lecturas críticas desde primary.
* Write concern fuerte en pagos.
* Read concern adecuado para datos financieros.
* Reintentos e idempotencia en sincronización.
* Monitoreo de lag.

### 8.3 Caída temporal de MongoDB

Si MongoDB no está disponible, el sistema debe seguir permitiendo operaciones transaccionales críticas en PostgreSQL. Se degradan recomendaciones, logs y catálogo enriquecido, pero no pagos ni órdenes.

Impacto:

| Módulo               | Impacto                                  |
| -------------------- | ---------------------------------------- |
| Órdenes              | Sin impacto directo                      |
| Pagos                | Sin impacto directo                      |
| Inventario           | Sin impacto directo                      |
| Catálogo enriquecido | Degradado                                |
| Recomendaciones      | No disponibles                           |
| Search logs          | Pueden almacenarse temporalmente en cola |

### 8.4 Caída temporal de PostgreSQL

Si PostgreSQL no está disponible, el sistema no debe permitir operaciones críticas como crear órdenes, confirmar pagos o reservar inventario. MongoDB podría seguir mostrando catálogo, recomendaciones y búsquedas, pero la compra debe bloquearse hasta recuperar consistencia.

---

## 9. Análisis de trade-offs operacionales

### 9.1 Escenario 1: Black Friday

Prioridad: disponibilidad para navegación y consistencia para pagos e inventario.

| Componente      | Prioridad    |
| --------------- | ------------ |
| Catálogo        | Availability |
| Search logs     | Availability |
| Recomendaciones | Availability |
| Órdenes         | Consistency  |
| Pagos           | Consistency  |
| Inventario      | Consistency  |

Configuración recomendada:

| Componente | Configuración                                             |
| ---------- | --------------------------------------------------------- |
| PostgreSQL | Pool de conexiones, particionamiento, réplicas de lectura |
| MongoDB    | Sharding por categoría/product_id                         |
| Inventario | Reserva transaccional                                     |
| Pagos      | Write concern fuerte                                      |
| Sync       | Asíncrono, idempotente y reintentable                     |

Trade-off aceptado:

* Se permite retraso en recomendaciones y comportamiento.
* No se permite inconsistencia en pagos ni inventario.

### 9.2 Escenario 2: Auditoría financiera

Prioridad: consistencia.

| Componente | Configuración recomendada        |
| ---------- | -------------------------------- |
| PostgreSQL | Lectura desde primary            |
| Pagos      | Consistencia fuerte              |
| Órdenes    | Trazabilidad completa            |
| MongoDB    | Solo fuente derivada, no oficial |
| Reportes   | Basados en PostgreSQL            |

Trade-off aceptado:

* Se acepta menor disponibilidad si es necesario garantizar exactitud total.
* Se privilegia integridad sobre velocidad.

### 9.3 Escenario 3: Campaña de recomendaciones

Prioridad: disponibilidad y escalabilidad.

| Componente      | Configuración recomendada                 |
| --------------- | ----------------------------------------- |
| MongoDB         | Índices por usuario, categoría y producto |
| Recomendaciones | Precomputadas                             |
| PostgreSQL      | Aislado de la carga analítica             |
| Sync            | Batch o eventos asíncronos                |
| Cache           | Recomendado para lectura frecuente        |

Trade-off aceptado:

* Recomendaciones pueden estar desactualizadas.
* La experiencia de navegación se mantiene disponible.

---

## 10. Recomendaciones de optimización adicional

### 10.1 PostgreSQL

* Implementar PgBouncer o connection pooling.
* Usar réplicas de lectura para reportes.
* Crear vistas materializadas para dashboards.
* Mantener particionamiento por fecha.
* Revisar índices según consultas reales.
* Separar workloads transaccionales y analíticos.
* Evaluar planes de Supabase con mayor capacidad para concurrencia.

### 10.2 MongoDB

* Aplicar sharding en colecciones de alto volumen.
* Crear índices compuestos para patrones de consulta frecuentes.
* Usar TTL indexes para logs antiguos.
* Precomputar agregados de comportamiento.
* Optimizar pipelines con `$match` temprano.
* Revisar región del cluster para reducir latencia.
* Monitorear uso de índices con Atlas Performance Advisor.

### 10.3 Sincronización

* Migrar proceso batch hacia eventos.
* Evaluar Kafka, Debezium o Change Data Capture.
* Mantener idempotencia en todos los consumidores.
* Registrar auditoría de eventos sincronizados.
* Implementar dead-letter queue para fallos.
* Monitorear retrasos de sincronización.

### 10.4 Observabilidad

* Monitorear latencia promedio y P95.
* Registrar throughput por motor.
* Medir errores por concurrencia.
* Monitorear conexiones activas.
* Medir replication lag.
* Crear alertas para caídas de sync.

---

## 11. Evidencias generadas

Las evidencias de la evaluación deben organizarse en:

```text
evaluation/
├── evidencias/
│   ├── concurrency.png
│   ├── scalability.png
├── results/
│   ├── performance_concurrency_results.csv
│   └── scalability_dataset_growth_results.csv
└── scripts/
    ├── 01_performance_concurrency.py
    ├── 02_scalability_dataset_growth.py
    └── 03_complex_queries.sql
```

Archivos principales:

| Evidencia                                | Descripción                                   |
| ---------------------------------------- | --------------------------------------------- |
| `performance_concurrency_results.csv`    | Resultados de concurrencia                    |
| `scalability_dataset_growth_results.csv` | Resultados de escalabilidad                   |
| `concurrency.png`                        | Captura de resultados de carga                |
| `scalability.png`                        | Captura de resultados de escalabilidad        |

---

## 12. Conclusión general

La evaluación crítica confirma que la arquitectura híbrida implementada para Ecommify es adecuada. PostgreSQL demostró mejor desempeño en las pruebas de concurrencia controlada, mayor throughput y mejor estabilidad en consultas agregadas desde 5.000 registros. Además, mantiene ventajas claras en consistencia, integridad referencial, transacciones, pagos, órdenes e inventario.

MongoDB mantiene ventajas arquitectónicas para datos flexibles y documentales, especialmente en catálogo enriquecido, reseñas, comportamiento de usuario, recomendaciones y logs de búsqueda. Aunque en las pruebas ejecutadas PostgreSQL presentó mejores métricas generales de rendimiento, MongoDB sigue siendo más adecuado para módulos AP donde se prioriza disponibilidad, flexibilidad y escalabilidad horizontal.

La arquitectura 100% relacional aumentaría la rigidez del sistema en módulos flexibles. La arquitectura 100% NoSQL aumentaría el riesgo en procesos críticos como pagos e inventario. Por esta razón, la estrategia híbrida PostgreSQL + MongoDB es la decisión más equilibrada para Ecommify.

El análisis CAP permite concluir que los módulos críticos deben operar bajo una estrategia CP, mientras que los módulos documentales y analíticos pueden operar bajo una estrategia AP con consistencia eventual. Esta separación permite balancear consistencia, disponibilidad, tolerancia a particiones, rendimiento y flexibilidad de acuerdo con las necesidades reales del negocio.
