## Q1. Historial de órdenes por usuario


| QUERY PLAN                                                                                                                                                              |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Limit  (cost=8.79..48.86 rows=20 width=81) (actual time=13.360..13.373 rows=1 loops=1)                                                                                  |
|   Buffers: shared hit=70                                                                                                                                                |
|   ->  Merge Append  (cost=8.79..98.96 rows=45 width=81) (actual time=13.358..13.370 rows=1 loops=1)                                                                     |
|         Sort Key: o.created_at DESC                                                                                                                                     |
|         Buffers: shared hit=70                                                                                                                                          |
|         ->  Index Scan using orders_2016_09_user_id_created_at_idx on orders_2016_09 o_1  (cost=0.13..2.35 rows=1 width=118) (actual time=0.034..0.034 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=4                                                                                                                                     |
|         ->  Index Scan using orders_2016_10_user_id_created_at_idx on orders_2016_10 o_2  (cost=0.27..2.49 rows=1 width=39) (actual time=0.662..0.662 rows=0 loops=1)   |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2016_11_user_id_created_at_idx on orders_2016_11 o_3  (cost=0.15..3.48 rows=2 width=118) (actual time=0.017..0.018 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2016_12_user_id_created_at_idx on orders_2016_12 o_4  (cost=0.12..2.34 rows=1 width=118) (actual time=0.104..0.104 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=1                                                                                                                                     |
|         ->  Index Scan using orders_2017_01_user_id_created_at_idx on orders_2017_01 o_5  (cost=0.28..2.49 rows=1 width=39) (actual time=1.125..1.125 rows=0 loops=1)   |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2017_02_user_id_created_at_idx on orders_2017_02 o_6  (cost=0.28..2.50 rows=1 width=39) (actual time=1.218..1.219 rows=0 loops=1)   |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2017_03_user_id_created_at_idx on orders_2017_03 o_7  (cost=0.28..2.50 rows=1 width=39) (actual time=0.627..0.627 rows=0 loops=1)   |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2017_04_user_id_created_at_idx on orders_2017_04 o_8  (cost=0.28..2.50 rows=1 width=39) (actual time=0.027..0.027 rows=0 loops=1)   |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2017_05_user_id_created_at_idx on orders_2017_05 o_9  (cost=0.28..2.50 rows=1 width=39) (actual time=0.022..0.023 rows=0 loops=1)   |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2017_06_user_id_created_at_idx on orders_2017_06 o_10  (cost=0.28..2.50 rows=1 width=39) (actual time=0.735..0.735 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2017_07_user_id_created_at_idx on orders_2017_07 o_11  (cost=0.28..2.50 rows=1 width=39) (actual time=0.663..0.664 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2017_08_user_id_created_at_idx on orders_2017_08 o_12  (cost=0.28..2.50 rows=1 width=39) (actual time=0.017..0.017 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2017_09_user_id_created_at_idx on orders_2017_09 o_13  (cost=0.28..2.50 rows=1 width=39) (actual time=0.651..0.651 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2017_10_user_id_created_at_idx on orders_2017_10 o_14  (cost=0.28..2.50 rows=1 width=39) (actual time=0.523..0.523 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2017_11_user_id_created_at_idx on orders_2017_11 o_15  (cost=0.28..2.50 rows=1 width=39) (actual time=0.637..0.638 rows=1 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=3                                                                                                                                     |
|         ->  Index Scan using orders_2017_12_user_id_created_at_idx on orders_2017_12 o_16  (cost=0.28..2.50 rows=1 width=39) (actual time=0.645..0.645 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2018_01_user_id_created_at_idx on orders_2018_01 o_17  (cost=0.28..2.50 rows=1 width=39) (actual time=0.017..0.018 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2018_02_user_id_created_at_idx on orders_2018_02 o_18  (cost=0.28..2.50 rows=1 width=39) (actual time=1.101..1.101 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2018_03_user_id_created_at_idx on orders_2018_03 o_19  (cost=0.28..2.50 rows=1 width=39) (actual time=1.427..1.427 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2018_04_user_id_created_at_idx on orders_2018_04 o_20  (cost=0.28..2.50 rows=1 width=39) (actual time=0.587..0.587 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2018_05_user_id_created_at_idx on orders_2018_05 o_21  (cost=0.28..2.50 rows=1 width=39) (actual time=1.180..1.180 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2018_06_user_id_created_at_idx on orders_2018_06 o_22  (cost=0.28..2.50 rows=1 width=39) (actual time=0.518..0.518 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2018_07_user_id_created_at_idx on orders_2018_07 o_23  (cost=0.28..2.50 rows=1 width=39) (actual time=0.025..0.025 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2018_08_user_id_created_at_idx on orders_2018_08 o_24  (cost=0.28..2.50 rows=1 width=39) (actual time=0.703..0.703 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2018_09_user_id_created_at_idx on orders_2018_09 o_25  (cost=0.14..2.35 rows=1 width=118) (actual time=0.011..0.011 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=1                                                                                                                                     |
|         ->  Index Scan using orders_2018_10_user_id_created_at_idx on orders_2018_10 o_26  (cost=0.13..2.35 rows=1 width=118) (actual time=0.011..0.011 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=1                                                                                                                                     |
|         ->  Index Scan using orders_2018_11_user_id_created_at_idx on orders_2018_11 o_27  (cost=0.15..3.48 rows=2 width=118) (actual time=0.008..0.008 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2018_12_user_id_created_at_idx on orders_2018_12 o_28  (cost=0.15..3.48 rows=2 width=118) (actual time=0.009..0.009 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2025_01_user_id_created_at_idx on orders_2025_01 o_29  (cost=0.15..3.48 rows=2 width=118) (actual time=0.005..0.005 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2025_02_user_id_created_at_idx on orders_2025_02 o_30  (cost=0.15..3.48 rows=2 width=118) (actual time=0.005..0.005 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2025_03_user_id_created_at_idx on orders_2025_03 o_31  (cost=0.15..3.48 rows=2 width=118) (actual time=0.005..0.005 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2025_04_user_id_created_at_idx on orders_2025_04 o_32  (cost=0.15..3.48 rows=2 width=118) (actual time=0.005..0.005 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2025_05_user_id_created_at_idx on orders_2025_05 o_33  (cost=0.15..3.48 rows=2 width=118) (actual time=0.007..0.007 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2025_06_user_id_created_at_idx on orders_2025_06 o_34  (cost=0.15..3.48 rows=2 width=118) (actual time=0.006..0.006 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_default_user_id_created_at_idx on orders_default o_35  (cost=0.15..3.48 rows=2 width=118) (actual time=0.005..0.005 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
| Planning:                                                                                                                                                               |
|   Buffers: shared hit=4731                                                                                                                                              |
| Planning Time: 105.914 ms                                                                                                                                               |
| Execution Time: 13.765 ms                                                                                                                                               |


## Q2. Ventas por categoría y mes

| QUERY PLAN                                                                                                                                                                                                                                                    |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Limit  (cost=6822.88..6822.89 rows=1 width=73) (actual time=1396.986..1404.618 rows=10 loops=1)                                                                                                                                                               |
|   Buffers: shared hit=305327, temp read=418 written=420                                                                                                                                                                                                       |
|   ->  Sort  (cost=6822.88..6822.89 rows=1 width=73) (actual time=1396.985..1404.615 rows=10 loops=1)                                                                                                                                                          |
|         Sort Key: (sum(((od.quantity)::numeric * od.unit_price))) DESC                                                                                                                                                                                        |
|         Sort Method: top-N heapsort  Memory: 26kB                                                                                                                                                                                                             |
|         Buffers: shared hit=305327, temp read=418 written=420                                                                                                                                                                                                 |
|         ->  GroupAggregate  (cost=6822.72..6822.87 rows=1 width=73) (actual time=1349.420..1404.344 rows=531 loops=1)                                                                                                                                         |
|               Group Key: (date_trunc('month'::text, o.created_at)), c.name                                                                                                                                                                                    |
|               Buffers: shared hit=305324, temp read=418 written=420                                                                                                                                                                                           |
|               ->  Gather Merge  (cost=6822.72..6822.84 rows=1 width=43) (actual time=1349.377..1379.419 rows=60324 loops=1)                                                                                                                                   |
|                     Workers Planned: 1                                                                                                                                                                                                                        |
|                     Workers Launched: 1                                                                                                                                                                                                                       |
|                     Buffers: shared hit=305324, temp read=418 written=420                                                                                                                                                                                     |
|                     ->  Sort  (cost=5822.71..5822.72 rows=1 width=43) (actual time=1331.960..1339.523 rows=30162 loops=2)                                                                                                                                     |
|                           Sort Key: (date_trunc('month'::text, o.created_at)), c.name, o.id                                                                                                                                                                   |
|                           Sort Method: external merge  Disk: 1648kB                                                                                                                                                                                           |
|                           Buffers: shared hit=305324, temp read=418 written=420                                                                                                                                                                               |
|                           Worker 0:  Sort Method: external merge  Disk: 1696kB                                                                                                                                                                                |
|                           ->  Nested Loop  (cost=3759.10..5822.70 rows=1 width=43) (actual time=555.273..1276.538 rows=30162 loops=2)                                                                                                                         |
|                                 Buffers: shared hit=305301                                                                                                                                                                                                    |
|                                 ->  Nested Loop  (cost=3758.96..5822.54 rows=1 width=34) (actual time=555.247..1221.882 rows=30162 loops=2)                                                                                                                   |
|                                       Buffers: shared hit=184652                                                                                                                                                                                              |
|                                       ->  Parallel Hash Join  (cost=3758.67..5822.21 rows=1 width=34) (actual time=554.889..752.297 rows=30162 loops=2)                                                                                                       |
|                                             Hash Cond: ((od.order_id = o.id) AND (od.order_created_at = o.created_at))                                                                                                                                        |
|                                             Buffers: shared hit=3679                                                                                                                                                                                          |
|                                             ->  Parallel Seq Scan on order_details od  (cost=0.00..1715.65 rows=66265 width=34) (actual time=0.555..91.645 rows=56325 loops=2)                                                                                |
|                                                   Buffers: shared hit=1053                                                                                                                                                                                    |
|                                             ->  Parallel Hash  (cost=3292.96..3292.96 rows=31047 width=16) (actual time=553.632..553.638 rows=26392 loops=2)                                                                                                  |
|                                                   Buckets: 65536  Batches: 1  Memory Usage: 3040kB                                                                                                                                                            |
|                                                   Buffers: shared hit=2581                                                                                                                                                                                    |
|                                                   ->  Parallel Append  (cost=0.15..3292.96 rows=31047 width=16) (actual time=3.394..543.403 rows=26392 loops=2)                                                                                               |
|                                                         Buffers: shared hit=2581                                                                                                                                                                              |
|                                                         ->  Parallel Index Scan Backward using orders_2018_11_status_created_at_idx on orders_2018_11 o_11  (cost=0.15..2.37 rows=1 width=16) (actual time=0.010..0.010 rows=0 loops=1)                       |
|                                                               Index Cond: (((status)::text = 'DELIVERED'::text) AND (created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone)) |
|                                                               Buffers: shared hit=2                                                                                                                                                                           |
|                                                         ->  Parallel Index Scan Backward using orders_2018_12_status_created_at_idx on orders_2018_12 o_12  (cost=0.15..2.37 rows=1 width=16) (actual time=0.004..0.004 rows=0 loops=1)                       |
|                                                               Index Cond: (((status)::text = 'DELIVERED'::text) AND (created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone)) |
|                                                               Buffers: shared hit=2                                                                                                                                                                           |
|                                                         ->  Parallel Seq Scan on orders_2018_01 o_1  (cost=0.00..421.83 rows=4158 width=16) (actual time=1.170..253.033 rows=7069 loops=1)                                                                    |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 200                                                                                                                                                                     |
|                                                               Buffers: shared hit=347                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_03 o_3  (cost=0.00..418.23 rows=4119 width=16) (actual time=1.588..168.469 rows=7003 loops=1)                                                                    |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 208                                                                                                                                                                     |
|                                                               Buffers: shared hit=344                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_04 o_4  (cost=0.00..402.43 rows=3998 width=16) (actual time=1.103..96.448 rows=6798 loops=1)                                                                     |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 141                                                                                                                                                                     |
|                                                               Buffers: shared hit=331                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_05 o_5  (cost=0.00..398.75 rows=3969 width=16) (actual time=0.326..31.112 rows=3374 loops=2)                                                                     |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 62                                                                                                                                                                      |
|                                                               Buffers: shared hit=328                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_02 o_2  (cost=0.00..390.26 rows=3855 width=16) (actual time=0.011..104.674 rows=6555 loops=1)                                                                    |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 173                                                                                                                                                                     |
|                                                               Buffers: shared hit=321                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_08 o_8  (cost=0.00..377.04 rows=3735 width=16) (actual time=0.012..94.194 rows=6351 loops=1)                                                                     |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 161                                                                                                                                                                     |
|                                                               Buffers: shared hit=310                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_07 o_7  (cost=0.00..364.77 rows=3622 width=16) (actual time=0.013..99.700 rows=6159 loops=1)                                                                     |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 133                                                                                                                                                                     |
|                                                               Buffers: shared hit=300                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_06 o_6  (cost=0.00..357.48 rows=3587 width=16) (actual time=3.135..200.131 rows=6099 loops=1)                                                                    |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 68                                                                                                                                                                      |
|                                                               Buffers: shared hit=294                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_09 o_9  (cost=0.00..1.16 rows=1 width=16) (actual time=1.150..1.151 rows=0 loops=1)                                                                              |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 16                                                                                                                                                                      |
|                                                               Buffers: shared hit=1                                                                                                                                                                           |
|                                                         ->  Parallel Seq Scan on orders_2018_10 o_10  (cost=0.00..1.04 rows=1 width=16) (actual time=1.315..1.316 rows=0 loops=1)                                                                             |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 4                                                                                                                                                                       |
|                                                               Buffers: shared hit=1                                                                                                                                                                           |
|                                       ->  Index Scan using products_pkey on products p  (cost=0.29..0.33 rows=1 width=16) (actual time=0.014..0.014 rows=1 loops=60324)                                                                                       |
|                                             Index Cond: (id = od.product_id)                                                                                                                                                                                  |
|                                             Buffers: shared hit=180973                                                                                                                                                                                        |
|                                 ->  Index Scan using categories_pkey on categories c  (cost=0.14..0.16 rows=1 width=25) (actual time=0.001..0.001 rows=1 loops=60324)                                                                                         |
|                                       Index Cond: (id = p.category_id)                                                                                                                                                                                        |
|                                       Buffers: shared hit=120649                                                                                                                                                                                              |
| Planning:                                                                                                                                                                                                                                                     |
|   Buffers: shared hit=2271                                                                                                                                                                                                                                    |
| Planning Time: 217.360 ms                                                                                                                                                                                                                                     |
| Execution Time: 1405.278 ms                                                                                                                                                                                                                                   |

## Q3. Productos por atributos JSONB

| QUERY PLAN                                                                                                                               |
| ---------------------------------------------------------------------------------------------------------------------------------------- |
| Limit  (cost=9.76..13.08 rows=3 width=426) (actual time=4.483..4.483 rows=0 loops=1)                                                     |
|   Buffers: shared hit=7                                                                                                                  |
|   ->  Bitmap Heap Scan on products  (cost=9.76..13.08 rows=3 width=426) (actual time=4.481..4.482 rows=0 loops=1)                        |
|         Recheck Cond: (attributes @> '{"color": "black"}'::jsonb)                                                                        |
|         Buffers: shared hit=7                                                                                                            |
|         ->  Bitmap Index Scan on idx_products_attributes_gin  (cost=0.00..9.76 rows=3 width=0) (actual time=4.476..4.476 rows=0 loops=1) |
|               Index Cond: (attributes @> '{"color": "black"}'::jsonb)                                                                    |
|               Buffers: shared hit=7                                                                                                      |
| Planning:                                                                                                                                |
|   Buffers: shared hit=274                                                                                                                |
| Planning Time: 3.186 ms                                                                                                                  |
| Execution Time: 4.544 ms                                                                                                                 |


## Q4. Productos por tags ARRAY

| QUERY PLAN                                                                                                      |
| --------------------------------------------------------------------------------------------------------------- |
| Limit  (cost=0.00..1.79 rows=20 width=92) (actual time=0.051..0.076 rows=20 loops=1)                            |
|   Buffers: shared hit=10                                                                                        |
|   ->  Seq Scan on products  (cost=0.00..2946.89 rows=32951 width=92) (actual time=0.049..0.072 rows=20 loops=1) |
|         Filter: (tags @> '{olist}'::text[])                                                                     |
|         Buffers: shared hit=10                                                                                  |
| Planning:                                                                                                       |
|   Buffers: shared hit=330                                                                                       |
| Planning Time: 1.695 ms                                                                                         |
| Execution Time: 0.151 ms                                                                                        |

## Q5. Búsqueda textual por nombre con pg_trgm

| QUERY PLAN                                                                                                                                 |
| ------------------------------------------------------------------------------------------------------------------------------------------ |
| Limit  (cost=27.82..27.82 rows=1 width=35) (actual time=2.030..2.031 rows=0 loops=1)                                                       |
|   Buffers: shared hit=20                                                                                                                   |
|   ->  Sort  (cost=27.82..27.82 rows=1 width=35) (actual time=2.028..2.029 rows=0 loops=1)                                                  |
|         Sort Key: price DESC                                                                                                               |
|         Sort Method: quicksort  Memory: 25kB                                                                                               |
|         Buffers: shared hit=20                                                                                                             |
|         ->  Bitmap Heap Scan on products  (cost=26.70..27.81 rows=1 width=35) (actual time=2.004..2.005 rows=0 loops=1)                    |
|               Recheck Cond: ((name)::text ~~* '%technology%'::text)                                                                        |
|               Buffers: shared hit=17                                                                                                       |
|               ->  Bitmap Index Scan on idx_products_name_trgm  (cost=0.00..26.70 rows=1 width=0) (actual time=1.997..1.998 rows=0 loops=1) |
|                     Index Cond: ((name)::text ~~* '%technology%'::text)                                                                    |
|                     Buffers: shared hit=17                                                                                                 |
| Planning:                                                                                                                                  |
|   Buffers: shared hit=289                                                                                                                  |
| Planning Time: 17.623 ms                                                                                                                   |
| Execution Time: 2.223 ms                                                                                                                   |

## Q6. Consulta geoespacial con PostGIS

| QUERY PLAN                                                                                                                                                                        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Limit  (cost=1284.25..201546.98 rows=10 width=32) (actual time=212.106..229.504 rows=20 loops=1)                                                                                  |
|   Buffers: shared hit=824                                                                                                                                                         |
|   ->  Gather  (cost=1284.25..201546.98 rows=10 width=32) (actual time=212.105..229.498 rows=20 loops=1)                                                                           |
|         Workers Planned: 1                                                                                                                                                        |
|         Workers Launched: 1                                                                                                                                                       |
|         Buffers: shared hit=824                                                                                                                                                   |
|         ->  Parallel Bitmap Heap Scan on addresses  (cost=284.25..200545.98 rows=6 width=32) (actual time=192.254..193.509 rows=18 loops=2)                                       |
|               Recheck Cond: (location IS NOT NULL)                                                                                                                                |
|               Filter: st_dwithin(location, '0101000020E6100000454772F90F5147C0B0726891ED8C37C0'::geography, '50000'::double precision, true)                                      |
|               Rows Removed by Filter: 2                                                                                                                                           |
|               Heap Blocks: exact=2                                                                                                                                                |
|               Buffers: shared hit=824                                                                                                                                             |
|               ->  Bitmap Index Scan on idx_addresses_location_gist  (cost=0.00..284.25 rows=13424 width=0) (actual time=122.813..122.813 rows=26653 loops=1)                      |
|                     Index Cond: ((location IS NOT NULL) AND (location && _st_expand('0101000020E6100000454772F90F5147C0B0726891ED8C37C0'::geography, '50000'::double precision))) |
|                     Buffers: shared hit=304                                                                                                                                       |
| Planning:                                                                                                                                                                         |
|   Buffers: shared hit=229                                                                                                                                                         |
| Planning Time: 253.322 ms                                                                                                                                                         |
| Execution Time: 229.750 ms                                                                                                                                                        |

## Q7. Pagos aprobados por rango de fecha

| QUERY PLAN                                                                                                                                                                                                                     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Sort  (cost=2465.97..2466.47 rows=200 width=50) (actual time=276.743..276.749 rows=4 loops=1)                                                                                                                                  |
|   Sort Key: (sum(payments.amount)) DESC                                                                                                                                                                                        |
|   Sort Method: quicksort  Memory: 25kB                                                                                                                                                                                         |
|   Buffers: shared hit=842                                                                                                                                                                                                      |
|   ->  HashAggregate  (cost=2455.82..2458.32 rows=200 width=50) (actual time=276.708..276.716 rows=4 loops=1)                                                                                                                   |
|         Group Key: payments.payment_method                                                                                                                                                                                     |
|         Batches: 1  Memory Usage: 40kB                                                                                                                                                                                         |
|         Buffers: shared hit=839                                                                                                                                                                                                |
|         ->  Append  (cost=0.00..2053.28 rows=53672 width=16) (actual time=0.600..261.005 rows=53677 loops=1)                                                                                                                   |
|               Buffers: shared hit=839                                                                                                                                                                                          |
|               ->  Seq Scan on payments_2018_01 payments_1  (cost=0.00..239.19 rows=7233 width=16) (actual time=0.599..70.447 rows=7234 loops=1)                                                                                |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 34                                                                                                                                                                                 |
|                     Buffers: shared hit=112                                                                                                                                                                                    |
|               ->  Seq Scan on payments_2018_02 payments_2  (cost=0.00..221.72 rows=6653 width=16) (actual time=1.244..32.954 rows=6654 loops=1)                                                                                |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 73                                                                                                                                                                                 |
|                     Buffers: shared hit=104                                                                                                                                                                                    |
|               ->  Seq Scan on payments_2018_03 payments_3  (cost=0.00..237.23 rows=7186 width=16) (actual time=0.636..37.896 rows=7187 loops=1)                                                                                |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 26                                                                                                                                                                                 |
|                     Buffers: shared hit=111                                                                                                                                                                                    |
|               ->  Seq Scan on payments_2018_04 payments_4  (cost=0.00..228.43 rows=6923 width=16) (actual time=0.046..39.821 rows=6924 loops=1)                                                                                |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 15                                                                                                                                                                                 |
|                     Buffers: shared hit=107                                                                                                                                                                                    |
|               ->  Seq Scan on payments_2018_05 payments_5  (cost=0.00..226.28 rows=6848 width=17) (actual time=0.036..24.797 rows=6849 loops=1)                                                                                |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 24                                                                                                                                                                                 |
|                     Buffers: shared hit=106                                                                                                                                                                                    |
|               ->  Seq Scan on payments_2018_06 payments_6  (cost=0.00..202.87 rows=6145 width=17) (actual time=0.831..19.174 rows=6146 loops=1)                                                                                |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 18                                                                                                                                                                                 |
|                     Buffers: shared hit=95                                                                                                                                                                                     |
|               ->  Seq Scan on payments_2018_07 payments_7  (cost=0.00..207.16 rows=6253 width=16) (actual time=0.033..10.658 rows=6254 loops=1)                                                                                |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 41                                                                                                                                                                                 |
|                     Buffers: shared hit=97                                                                                                                                                                                     |
|               ->  Seq Scan on payments_2018_08 payments_8  (cost=0.00..214.96 rows=6427 width=17) (actual time=0.033..19.972 rows=6428 loops=1)                                                                                |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 84                                                                                                                                                                                 |
|                     Buffers: shared hit=101                                                                                                                                                                                    |
|               ->  Seq Scan on payments_2018_09 payments_9  (cost=0.00..1.28 rows=1 width=134) (actual time=0.031..0.034 rows=1 loops=1)                                                                                        |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 15                                                                                                                                                                                 |
|                     Buffers: shared hit=1                                                                                                                                                                                      |
|               ->  Seq Scan on payments_2018_10 payments_10  (cost=0.00..1.07 rows=1 width=134) (actual time=0.017..0.017 rows=0 loops=1)                                                                                       |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 4                                                                                                                                                                                  |
|                     Buffers: shared hit=1                                                                                                                                                                                      |
|               ->  Index Scan using payments_2018_11_payment_status_payment_date_idx on payments_2018_11 payments_11  (cost=0.14..2.37 rows=1 width=134) (actual time=0.012..0.012 rows=0 loops=1)                              |
|                     Index Cond: (((payment_status)::text = 'APPROVED'::text) AND (payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone)) |
|                     Buffers: shared hit=2                                                                                                                                                                                      |
|               ->  Index Scan using payments_2018_12_payment_status_payment_date_idx on payments_2018_12 payments_12  (cost=0.14..2.37 rows=1 width=134) (actual time=0.019..0.019 rows=0 loops=1)                              |
|                     Index Cond: (((payment_status)::text = 'APPROVED'::text) AND (payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone)) |
|                     Buffers: shared hit=2                                                                                                                                                                                      |
| Planning:                                                                                                                                                                                                                      |
|   Buffers: shared hit=1919                                                                                                                                                                                                     |
| Planning Time: 41.625 ms                                                                                                                                                                                                       |
| Execution Time: 276.963 ms                                                                                                                                                                                                     |

## Q8. Historial transaccional por evento

| QUERY PLAN                                                                                                                                                                                                          |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GroupAggregate  (cost=0.29..3424.51 rows=1 width=23) (actual time=539.556..539.562 rows=1 loops=1)                                                                                                                  |
|   Buffers: shared hit=1704                                                                                                                                                                                          |
|   ->  Append  (cost=0.29..3289.49 rows=54002 width=15) (actual time=2.277..535.307 rows=54011 loops=1)                                                                                                              |
|         Buffers: shared hit=1704                                                                                                                                                                                    |
|         ->  Index Scan using transaction_history_2018_01_event_type_idx on transaction_history_2018_01 transaction_history_1  (cost=0.29..405.41 rows=7268 width=15) (actual time=2.276..98.331 rows=7269 loops=1)  |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=229                                                                                                                                                                               |
|         ->  Index Scan using transaction_history_2018_02_event_type_idx on transaction_history_2018_02 transaction_history_2  (cost=0.29..377.02 rows=6727 width=15) (actual time=2.231..114.507 rows=6728 loops=1) |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=211                                                                                                                                                                               |
|         ->  Index Scan using transaction_history_2018_03_event_type_idx on transaction_history_2018_03 transaction_history_3  (cost=0.29..401.88 rows=7210 width=15) (actual time=1.664..86.010 rows=7211 loops=1)  |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=227                                                                                                                                                                               |
|         ->  Index Scan using transaction_history_2018_04_event_type_idx on transaction_history_2018_04 transaction_history_4  (cost=0.29..385.54 rows=6938 width=15) (actual time=0.054..63.494 rows=6939 loops=1)  |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=218                                                                                                                                                                               |
|         ->  Index Scan using transaction_history_2018_05_event_type_idx on transaction_history_2018_05 transaction_history_5  (cost=0.29..382.24 rows=6872 width=15) (actual time=1.736..52.550 rows=6873 loops=1)  |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=216                                                                                                                                                                               |
|         ->  Index Scan using transaction_history_2018_06_event_type_idx on transaction_history_2018_06 transaction_history_6  (cost=0.29..344.30 rows=6166 width=15) (actual time=0.057..39.865 rows=6167 loops=1)  |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=194                                                                                                                                                                               |
|         ->  Index Scan using transaction_history_2018_07_event_type_idx on transaction_history_2018_07 transaction_history_7  (cost=0.29..351.24 rows=6291 width=15) (actual time=0.633..41.246 rows=6292 loops=1)  |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=198                                                                                                                                                                               |
|         ->  Index Scan using transaction_history_2018_08_event_type_idx on transaction_history_2018_08 transaction_history_8  (cost=0.29..364.41 rows=6511 width=15) (actual time=1.471..33.733 rows=6512 loops=1)  |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=205                                                                                                                                                                               |
|         ->  Seq Scan on transaction_history_2018_09 transaction_history_9  (cost=0.00..1.56 rows=16 width=15) (actual time=0.037..0.044 rows=16 loops=1)                                                            |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((event_type)::text = 'ORDER_CREATED'::text))   |
|               Rows Removed by Filter: 16                                                                                                                                                                            |
|               Buffers: shared hit=1                                                                                                                                                                                 |
|         ->  Seq Scan on transaction_history_2018_10 transaction_history_10  (cost=0.00..1.14 rows=1 width=218) (actual time=0.029..0.031 rows=4 loops=1)                                                            |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((event_type)::text = 'ORDER_CREATED'::text))   |
|               Rows Removed by Filter: 4                                                                                                                                                                             |
|               Buffers: shared hit=1                                                                                                                                                                                 |
|         ->  Index Scan using transaction_history_2018_11_event_type_idx on transaction_history_2018_11 transaction_history_11  (cost=0.14..2.37 rows=1 width=218) (actual time=0.022..0.023 rows=0 loops=1)         |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=2                                                                                                                                                                                 |
|         ->  Index Scan using transaction_history_2018_12_event_type_idx on transaction_history_2018_12 transaction_history_12  (cost=0.14..2.37 rows=1 width=218) (actual time=0.006..0.006 rows=0 loops=1)         |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=2                                                                                                                                                                                 |
| Planning:                                                                                                                                                                                                           |
|   Buffers: shared hit=1499                                                                                                                                                                                          |
| Planning Time: 30.859 ms                                                                                                                                                                                            |
| Execution Time: 539.737 ms                                                                                                                                                                                          |

