# Implementación MongoDB - Ecommify

## Descripción general

La implementación MongoDB de Ecommify corresponde al componente documental, flexible y analítico de la arquitectura híbrida de base de datos. MongoDB se utiliza para almacenar información semiestructurada, eventos de comportamiento, catálogo enriquecido, reseñas, búsquedas y recomendaciones.

Mientras PostgreSQL gestiona los datos transaccionales críticos como usuarios, órdenes, pagos e inventario, MongoDB permite representar estructuras flexibles y optimizadas para lectura, analítica y escalabilidad horizontal.

## Colecciones implementadas

| Colección         | Documentos | Propósito                                   |
| ----------------- | ---------: | ------------------------------------------- |
| `product_catalog` |     32.951 | Catálogo documental de productos            |
| `product_reviews` |    102.172 | Reseñas asociadas a productos               |
| `user_behavior`   |    112.650 | Eventos de comportamiento de usuarios       |
| `recommendations` |      1.000 | Recomendaciones generadas para usuarios     |
| `search_logs`     |      5.000 | Logs de búsquedas realizadas en el catálogo |
| `sellers`         |      3.095 | Información auxiliar de vendedores          |

## Uso del dataset Olist

El dataset Olist/Kaggle fue utilizado como fuente semilla para construir el modelo documental de Ecommify. Las colecciones resultantes no representan una copia directa del dataset original, sino una transformación hacia un modelo documental orientado a comercio electrónico.

El objetivo fue reutilizar datos reales de productos, órdenes, reseñas, vendedores y comportamiento de compra para construir colecciones compatibles con el diseño técnico de Ecommify.

## Colección product_catalog

La colección `product_catalog` representa el catálogo flexible de productos. Esta colección permite manejar atributos variables por producto, información de vendedor, etiquetas, calificaciones y reseñas resumidas.

### Patrón aplicado

Se aplica principalmente el **Attribute Pattern**, ya que los productos pueden tener atributos diferentes según su categoría. También se aplica **Embedding** para incluir información resumida como calificaciones y reseñas destacadas dentro del documento del producto.

### Ejemplo conceptual

```json
{
  "product_id": "abc123",
  "name": "health_beauty product",
  "category": "health_beauty",
  "price": 79.90,
  "attributes": {
    "weight_g": 300,
    "height_cm": 10,
    "width_cm": 20,
    "source_category": "beleza_saude"
  },
  "tags": ["health_beauty", "olist", "ecommify"],
  "seller": {
    "seller_id": "seller001",
    "city": "sao paulo",
    "state": "SP"
  },
  "rating_summary": {
    "average_rating": 4.5,
    "total_reviews": 25
  }
}
```

## Colección product_reviews

La colección `product_reviews` almacena reseñas de productos. Esta información se mantiene como colección independiente para soportar consultas analíticas y evitar crecimiento excesivo del documento del producto.

### Patrón aplicado

Se usa el patrón **Extended Reference**, ya que cada reseña puede guardar información básica del producto y usuario sin necesidad de consultar múltiples colecciones.

## Colección user_behavior

La colección `user_behavior` almacena eventos de comportamiento derivados de la actividad de compra. Esta colección permite representar visualizaciones, compras, interacciones y eventos históricos.

### Patrón aplicado

Se usa el **Bucket Pattern**, agrupando eventos de usuario para facilitar consultas históricas y analíticas.

## Colección recommendations

La colección `recommendations` almacena recomendaciones generadas para usuarios. Estas recomendaciones se derivan de productos populares, calificaciones y comportamiento histórico.

Esta colección permite separar el resultado del motor de recomendación del catálogo principal, facilitando actualizaciones independientes y consultas rápidas por usuario.

## Colección search_logs

La colección `search_logs` registra búsquedas simuladas realizadas por usuarios sobre el catálogo. Esta colección permite analizar términos frecuentes, filtros aplicados, productos clicados y patrones de descubrimiento.

## Validación JSON Schema

Se implementaron validadores JSON Schema para las colecciones principales:

| Colección         | Validación                                              |
| ----------------- | ------------------------------------------------------- |
| `product_catalog` | Producto, categoría, precio, atributos, tags y rating   |
| `product_reviews` | Reseña, producto, usuario, calificación y fecha         |
| `user_behavior`   | Usuario, periodo, eventos y metadatos                   |
| `recommendations` | Usuario, fecha de generación y lista de recomendaciones |
| `search_logs`     | Usuario, consulta, fecha, filtros y producto clicado    |

La validación fue configurada con `validationLevel="moderate"` y `validationAction="warn"`, permitiendo controlar la estructura sin bloquear cargas derivadas del dataset semilla.

## Índices MongoDB

Se crearon índices para mejorar consultas frecuentes sobre catálogo, reseñas, comportamiento, recomendaciones y búsquedas.

| Colección         | Índices principales                             |
| ----------------- | ----------------------------------------------- |
| `product_catalog` | categoría, precio, rating, tags, atributos      |
| `product_reviews` | producto, usuario, rating, fecha                |
| `user_behavior`   | usuario, periodo, eventos                       |
| `recommendations` | usuario, fecha, producto recomendado, categoría |
| `search_logs`     | usuario, query, fecha, producto clicado         |

Los índices permiten optimizar búsquedas por categoría, análisis de comportamiento, recuperación de recomendaciones por usuario y consultas sobre términos frecuentes.

## Pipelines de agregación

Se implementaron pipelines de agregación para análisis documental, entre ellos:

* Productos más populares.
* Promedio de calificación por categoría.
* Cantidad de reseñas por producto.
* Búsquedas más frecuentes.
* Recomendaciones por usuario.
* Eventos de comportamiento agrupados.

Estos pipelines permiten demostrar el uso de MongoDB como motor documental orientado a analítica operativa.

## Evidencias generadas

Las evidencias de MongoDB se organizaron en las siguientes carpetas:

```text
mongodb/evidencias/collections/
mongodb/evidencias/validation/
mongodb/evidencias/indexes/
mongodb/evidencias/aggregations/
mongodb/evidencias/atlas_metrics/
mongodb/evidencias/performance_advisor/
mongodb/evidencias/explain/
```

Archivos principales:

| Evidencia                          | Descripción                            |
| ---------------------------------- | -------------------------------------- |
| `05_json_schema_validation.png`    | Validadores JSON Schema aplicados      |
| `06_recommendations_generated.png` | Recomendaciones generadas              |
| `07_search_logs_generated.png`     | Logs de búsqueda generados             |
| `08_collection_counts.png`         | Conteo final de colecciones            |
| `collection_counts.csv`            | Conteo exportado a CSV                 |
| `index_productivity_results.csv`   | Resultados de productividad de índices |
| `pipeline_results.csv`             | Resultados de pipelines                |

## Resultados de carga

El resultado final de carga documental fue:

| Colección         | Documentos |
| ----------------- | ---------: |
| `product_catalog` |     32.951 |
| `product_reviews` |    102.172 |
| `user_behavior`   |    112.650 |
| `recommendations` |      1.000 |
| `search_logs`     |      5.000 |
| `sellers`         |      3.095 |

## Conclusión MongoDB

La implementación MongoDB cumple con el componente documental del diseño Ecommify. Se implementaron colecciones flexibles, patrones de modelado documental, validación JSON Schema, generación de recomendaciones, logs de búsqueda, índices y pipelines de agregación.

MongoDB complementa a PostgreSQL dentro de una arquitectura híbrida: PostgreSQL conserva la consistencia fuerte de los procesos transaccionales, mientras MongoDB soporta catálogo flexible, comportamiento de usuarios, recomendaciones, reseñas y analítica documental.