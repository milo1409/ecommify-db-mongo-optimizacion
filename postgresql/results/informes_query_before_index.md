## Q1. Historial de órdenes por usuario

| QUERY PLAN                                                                                                                                                              |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Limit  (cost=8.79..48.86 rows=20 width=81) (actual time=36.764..36.779 rows=1 loops=1)                                                                                  |
|   Buffers: shared hit=24 read=46                                                                                                                                        |
|   ->  Merge Append  (cost=8.79..98.96 rows=45 width=81) (actual time=36.761..36.776 rows=1 loops=1)                                                                     |
|         Sort Key: o.created_at DESC                                                                                                                                     |
|         Buffers: shared hit=24 read=46                                                                                                                                  |
|         ->  Index Scan using orders_2016_09_user_id_created_at_idx on orders_2016_09 o_1  (cost=0.13..2.35 rows=1 width=118) (actual time=1.132..1.132 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=3 read=1                                                                                                                              |
|         ->  Index Scan using orders_2016_10_user_id_created_at_idx on orders_2016_10 o_2  (cost=0.27..2.49 rows=1 width=39) (actual time=1.853..1.853 rows=0 loops=1)   |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2016_11_user_id_created_at_idx on orders_2016_11 o_3  (cost=0.15..3.48 rows=2 width=118) (actual time=0.015..0.015 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2016_12_user_id_created_at_idx on orders_2016_12 o_4  (cost=0.12..2.34 rows=1 width=118) (actual time=0.024..0.024 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=1                                                                                                                                    |
|         ->  Index Scan using orders_2017_01_user_id_created_at_idx on orders_2017_01 o_5  (cost=0.28..2.49 rows=1 width=39) (actual time=1.822..1.822 rows=0 loops=1)   |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2017_02_user_id_created_at_idx on orders_2017_02 o_6  (cost=0.28..2.50 rows=1 width=39) (actual time=1.272..1.272 rows=0 loops=1)   |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2017_03_user_id_created_at_idx on orders_2017_03 o_7  (cost=0.28..2.50 rows=1 width=39) (actual time=2.808..2.808 rows=0 loops=1)   |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2017_04_user_id_created_at_idx on orders_2017_04 o_8  (cost=0.28..2.50 rows=1 width=39) (actual time=1.390..1.390 rows=0 loops=1)   |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2017_05_user_id_created_at_idx on orders_2017_05 o_9  (cost=0.28..2.50 rows=1 width=39) (actual time=1.471..1.471 rows=0 loops=1)   |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2017_06_user_id_created_at_idx on orders_2017_06 o_10  (cost=0.28..2.50 rows=1 width=39) (actual time=1.335..1.335 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2017_07_user_id_created_at_idx on orders_2017_07 o_11  (cost=0.28..2.50 rows=1 width=39) (actual time=1.169..1.169 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2017_08_user_id_created_at_idx on orders_2017_08 o_12  (cost=0.28..2.50 rows=1 width=39) (actual time=0.602..0.602 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2017_09_user_id_created_at_idx on orders_2017_09 o_13  (cost=0.28..2.50 rows=1 width=39) (actual time=1.921..1.921 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2017_10_user_id_created_at_idx on orders_2017_10 o_14  (cost=0.28..2.50 rows=1 width=39) (actual time=2.277..2.278 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2017_11_user_id_created_at_idx on orders_2017_11 o_15  (cost=0.28..2.50 rows=1 width=39) (actual time=1.337..1.338 rows=1 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=1 read=2                                                                                                                              |
|         ->  Index Scan using orders_2017_12_user_id_created_at_idx on orders_2017_12 o_16  (cost=0.28..2.50 rows=1 width=39) (actual time=1.612..1.613 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2018_01_user_id_created_at_idx on orders_2018_01 o_17  (cost=0.28..2.50 rows=1 width=39) (actual time=2.028..2.028 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2018_02_user_id_created_at_idx on orders_2018_02 o_18  (cost=0.28..2.50 rows=1 width=39) (actual time=1.878..1.878 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2018_03_user_id_created_at_idx on orders_2018_03 o_19  (cost=0.28..2.50 rows=1 width=39) (actual time=2.326..2.327 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2018_04_user_id_created_at_idx on orders_2018_04 o_20  (cost=0.28..2.50 rows=1 width=39) (actual time=1.297..1.297 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2018_05_user_id_created_at_idx on orders_2018_05 o_21  (cost=0.28..2.50 rows=1 width=39) (actual time=2.755..2.755 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2018_06_user_id_created_at_idx on orders_2018_06 o_22  (cost=0.28..2.50 rows=1 width=39) (actual time=1.737..1.737 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2018_07_user_id_created_at_idx on orders_2018_07 o_23  (cost=0.28..2.50 rows=1 width=39) (actual time=1.324..1.324 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2018_08_user_id_created_at_idx on orders_2018_08 o_24  (cost=0.28..2.50 rows=1 width=39) (actual time=0.696..0.696 rows=0 loops=1)  |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=2                                                                                                                                    |
|         ->  Index Scan using orders_2018_09_user_id_created_at_idx on orders_2018_09 o_25  (cost=0.14..2.35 rows=1 width=118) (actual time=0.557..0.557 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=1                                                                                                                                    |
|         ->  Index Scan using orders_2018_10_user_id_created_at_idx on orders_2018_10 o_26  (cost=0.13..2.35 rows=1 width=118) (actual time=0.026..0.026 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared read=1                                                                                                                                    |
|         ->  Index Scan using orders_2018_11_user_id_created_at_idx on orders_2018_11 o_27  (cost=0.15..3.48 rows=2 width=118) (actual time=0.009..0.009 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2018_12_user_id_created_at_idx on orders_2018_12 o_28  (cost=0.15..3.48 rows=2 width=118) (actual time=0.014..0.014 rows=0 loops=1) |
|               Index Cond: (user_id = 1000)                                                                                                                              |
|               Buffers: shared hit=2                                                                                                                                     |
|         ->  Index Scan using orders_2025_01_user_id_created_at_idx on orders_2025_01 o_29  (cost=0.15..3.48 rows=2 width=118) (actual time=0.006..0.006 rows=0 loops=1) |
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
|   Buffers: shared hit=4588 read=143                                                                                                                                     |
| Planning Time: 220.492 ms                                                                                                                                               |
| Execution Time: 37.830 ms                                                                                                                                               |



## Q2. Ventas por categoría y mes

| QUERY PLAN                                                                                                                                                                                                                                                    |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Limit  (cost=6822.88..6822.89 rows=1 width=73) (actual time=2425.410..2430.455 rows=10 loops=1)                                                                                                                                                               |
|   Buffers: shared hit=302701 read=2626, temp read=418 written=420                                                                                                                                                                                             |
|   ->  Sort  (cost=6822.88..6822.89 rows=1 width=73) (actual time=2425.409..2430.452 rows=10 loops=1)                                                                                                                                                          |
|         Sort Key: (sum(((od.quantity)::numeric * od.unit_price))) DESC                                                                                                                                                                                        |
|         Sort Method: top-N heapsort  Memory: 26kB                                                                                                                                                                                                             |
|         Buffers: shared hit=302701 read=2626, temp read=418 written=420                                                                                                                                                                                       |
|         ->  GroupAggregate  (cost=6822.72..6822.87 rows=1 width=73) (actual time=2377.071..2430.178 rows=531 loops=1)                                                                                                                                         |
|               Group Key: (date_trunc('month'::text, o.created_at)), c.name                                                                                                                                                                                    |
|               Buffers: shared hit=302698 read=2626, temp read=418 written=420                                                                                                                                                                                 |
|               ->  Gather Merge  (cost=6822.72..6822.84 rows=1 width=43) (actual time=2377.039..2404.920 rows=60324 loops=1)                                                                                                                                   |
|                     Workers Planned: 1                                                                                                                                                                                                                        |
|                     Workers Launched: 1                                                                                                                                                                                                                       |
|                     Buffers: shared hit=302698 read=2626, temp read=418 written=420                                                                                                                                                                           |
|                     ->  Sort  (cost=5822.71..5822.72 rows=1 width=43) (actual time=2362.068..2369.841 rows=30162 loops=2)                                                                                                                                     |
|                           Sort Key: (date_trunc('month'::text, o.created_at)), c.name, o.id                                                                                                                                                                   |
|                           Sort Method: external merge  Disk: 1672kB                                                                                                                                                                                           |
|                           Buffers: shared hit=302698 read=2626, temp read=418 written=420                                                                                                                                                                     |
|                           Worker 0:  Sort Method: external merge  Disk: 1672kB                                                                                                                                                                                |
|                           ->  Nested Loop  (cost=3759.10..5822.70 rows=1 width=43) (actual time=383.326..2304.874 rows=30162 loops=2)                                                                                                                         |
|                                 Buffers: shared hit=302675 read=2626                                                                                                                                                                                          |
|                                 ->  Nested Loop  (cost=3758.96..5822.54 rows=1 width=34) (actual time=383.292..2250.789 rows=30162 loops=2)                                                                                                                   |
|                                       Buffers: shared hit=182026 read=2626                                                                                                                                                                                    |
|                                       ->  Parallel Hash Join  (cost=3758.67..5822.21 rows=1 width=34) (actual time=380.027..741.758 rows=30162 loops=2)                                                                                                       |
|                                             Hash Cond: ((od.order_id = o.id) AND (od.order_created_at = o.created_at))                                                                                                                                        |
|                                             Buffers: shared hit=3679                                                                                                                                                                                          |
|                                             ->  Parallel Seq Scan on order_details od  (cost=0.00..1715.65 rows=66265 width=34) (actual time=0.582..183.965 rows=56325 loops=2)                                                                               |
|                                                   Buffers: shared hit=1053                                                                                                                                                                                    |
|                                             ->  Parallel Hash  (cost=3292.96..3292.96 rows=31047 width=16) (actual time=378.865..378.871 rows=26392 loops=2)                                                                                                  |
|                                                   Buckets: 65536  Batches: 1  Memory Usage: 3008kB                                                                                                                                                            |
|                                                   Buffers: shared hit=2581                                                                                                                                                                                    |
|                                                   ->  Parallel Append  (cost=0.15..3292.96 rows=31047 width=16) (actual time=0.624..369.281 rows=26392 loops=2)                                                                                               |
|                                                         Buffers: shared hit=2581                                                                                                                                                                              |
|                                                         ->  Parallel Index Scan Backward using orders_2018_11_status_created_at_idx on orders_2018_11 o_11  (cost=0.15..2.37 rows=1 width=16) (actual time=0.011..0.011 rows=0 loops=1)                       |
|                                                               Index Cond: (((status)::text = 'DELIVERED'::text) AND (created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone)) |
|                                                               Buffers: shared hit=2                                                                                                                                                                           |
|                                                         ->  Parallel Index Scan Backward using orders_2018_12_status_created_at_idx on orders_2018_12 o_12  (cost=0.15..2.37 rows=1 width=16) (actual time=0.004..0.005 rows=0 loops=1)                       |
|                                                               Index Cond: (((status)::text = 'DELIVERED'::text) AND (created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone)) |
|                                                               Buffers: shared hit=2                                                                                                                                                                           |
|                                                         ->  Parallel Seq Scan on orders_2018_01 o_1  (cost=0.00..421.83 rows=4158 width=16) (actual time=1.087..235.909 rows=7069 loops=1)                                                                    |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 200                                                                                                                                                                     |
|                                                               Buffers: shared hit=347                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_03 o_3  (cost=0.00..418.23 rows=4119 width=16) (actual time=0.805..77.272 rows=3502 loops=2)                                                                     |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 104                                                                                                                                                                     |
|                                                               Buffers: shared hit=344                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_04 o_4  (cost=0.00..402.43 rows=3998 width=16) (actual time=1.307..73.263 rows=6798 loops=1)                                                                     |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 141                                                                                                                                                                     |
|                                                               Buffers: shared hit=331                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_05 o_5  (cost=0.00..398.75 rows=3969 width=16) (actual time=0.033..9.188 rows=6749 loops=1)                                                                      |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 124                                                                                                                                                                     |
|                                                               Buffers: shared hit=328                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_02 o_2  (cost=0.00..390.26 rows=3855 width=16) (actual time=1.308..238.473 rows=6555 loops=1)                                                                    |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 173                                                                                                                                                                     |
|                                                               Buffers: shared hit=321                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_08 o_8  (cost=0.00..377.04 rows=3735 width=16) (actual time=0.010..6.594 rows=6351 loops=1)                                                                      |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 161                                                                                                                                                                     |
|                                                               Buffers: shared hit=310                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_07 o_7  (cost=0.00..364.77 rows=3622 width=16) (actual time=0.009..7.612 rows=6159 loops=1)                                                                      |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 133                                                                                                                                                                     |
|                                                               Buffers: shared hit=300                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_06 o_6  (cost=0.00..357.48 rows=3587 width=16) (actual time=0.078..7.399 rows=6099 loops=1)                                                                      |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 68                                                                                                                                                                      |
|                                                               Buffers: shared hit=294                                                                                                                                                                         |
|                                                         ->  Parallel Seq Scan on orders_2018_09 o_9  (cost=0.00..1.16 rows=1 width=16) (actual time=0.024..0.024 rows=0 loops=1)                                                                              |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 16                                                                                                                                                                      |
|                                                               Buffers: shared hit=1                                                                                                                                                                           |
|                                                         ->  Parallel Seq Scan on orders_2018_10 o_10  (cost=0.00..1.04 rows=1 width=16) (actual time=0.040..0.040 rows=0 loops=1)                                                                             |
|                                                               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((status)::text = 'DELIVERED'::text))     |
|                                                               Rows Removed by Filter: 4                                                                                                                                                                       |
|                                                               Buffers: shared hit=1                                                                                                                                                                           |
|                                       ->  Index Scan using products_pkey on products p  (cost=0.29..0.33 rows=1 width=16) (actual time=0.049..0.049 rows=1 loops=60324)                                                                                       |
|                                             Index Cond: (id = od.product_id)                                                                                                                                                                                  |
|                                             Buffers: shared hit=178347 read=2626                                                                                                                                                                              |
|                                 ->  Index Scan using categories_pkey on categories c  (cost=0.14..0.16 rows=1 width=25) (actual time=0.001..0.001 rows=1 loops=60324)                                                                                         |
|                                       Index Cond: (id = p.category_id)                                                                                                                                                                                        |
|                                       Buffers: shared hit=120649                                                                                                                                                                                              |
| Planning:                                                                                                                                                                                                                                                     |
|   Buffers: shared hit=2229 read=42                                                                                                                                                                                                                            |
| Planning Time: 72.623 ms                                                                                                                                                                                                                                      |
| Execution Time: 2431.127 ms                                                                                                                                                                                                                                   |

## Q3. Productos por atributos JSONB


| QUERY PLAN                                                                                                                               |
| ---------------------------------------------------------------------------------------------------------------------------------------- |
| Limit  (cost=9.76..13.08 rows=3 width=426) (actual time=3.174..3.175 rows=0 loops=1)                                                     |
|   Buffers: shared hit=2 read=5                                                                                                           |
|   ->  Bitmap Heap Scan on products  (cost=9.76..13.08 rows=3 width=426) (actual time=3.173..3.174 rows=0 loops=1)                        |
|         Recheck Cond: (attributes @> '{"color": "black"}'::jsonb)                                                                        |
|         Buffers: shared hit=2 read=5                                                                                                     |
|         ->  Bitmap Index Scan on idx_products_attributes_gin  (cost=0.00..9.76 rows=3 width=0) (actual time=3.168..3.168 rows=0 loops=1) |
|               Index Cond: (attributes @> '{"color": "black"}'::jsonb)                                                                    |
|               Buffers: shared hit=2 read=5                                                                                               |
| Planning:                                                                                                                                |
|   Buffers: shared hit=270 read=4                                                                                                         |
| Planning Time: 6.795 ms                                                                                                                  |
| Execution Time: 3.250 ms                                                                                                                 |


## Q4. Productos por tags ARRAY

| QUERY PLAN                                                                                                      |
| --------------------------------------------------------------------------------------------------------------- |
| Limit  (cost=0.00..1.79 rows=20 width=92) (actual time=0.049..0.074 rows=20 loops=1)                            |
|   Buffers: shared hit=10                                                                                        |
|   ->  Seq Scan on products  (cost=0.00..2946.89 rows=32951 width=92) (actual time=0.048..0.070 rows=20 loops=1) |
|         Filter: (tags @> '{olist}'::text[])                                                                     |
|         Buffers: shared hit=10                                                                                  |
| Planning:                                                                                                       |
|   Buffers: shared hit=329 read=1                                                                                |
| Planning Time: 2.625 ms                                                                                         |
| Execution Time: 0.138 ms                                                                                        |

## Q5. Búsqueda textual por nombre con pg_trgm

| QUERY PLAN                                                                                                                                   |
| -------------------------------------------------------------------------------------------------------------------------------------------- |
| Limit  (cost=27.82..27.82 rows=1 width=35) (actual time=15.366..15.367 rows=0 loops=1)                                                       |
|   Buffers: shared hit=11 read=9                                                                                                              |
|   ->  Sort  (cost=27.82..27.82 rows=1 width=35) (actual time=15.364..15.365 rows=0 loops=1)                                                  |
|         Sort Key: price DESC                                                                                                                 |
|         Sort Method: quicksort  Memory: 25kB                                                                                                 |
|         Buffers: shared hit=11 read=9                                                                                                        |
|         ->  Bitmap Heap Scan on products  (cost=26.70..27.81 rows=1 width=35) (actual time=15.339..15.339 rows=0 loops=1)                    |
|               Recheck Cond: ((name)::text ~~* '%technology%'::text)                                                                          |
|               Buffers: shared hit=8 read=9                                                                                                   |
|               ->  Bitmap Index Scan on idx_products_name_trgm  (cost=0.00..26.70 rows=1 width=0) (actual time=15.333..15.333 rows=0 loops=1) |
|                     Index Cond: ((name)::text ~~* '%technology%'::text)                                                                      |
|                     Buffers: shared hit=8 read=9                                                                                             |
| Planning:                                                                                                                                    |
|   Buffers: shared hit=288 read=1 dirtied=1                                                                                                   |
| Planning Time: 19.835 ms                                                                                                                     |
| Execution Time: 15.547 ms                                                                                                                    |


## Q6. Consulta geoespacial con PostGIS

| QUERY PLAN                                                                                                                                                                        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Limit  (cost=1284.25..201546.98 rows=10 width=32) (actual time=630.591..699.319 rows=20 loops=1)                                                                                  |
|   Buffers: shared hit=504 read=321                                                                                                                                                |
|   ->  Gather  (cost=1284.25..201546.98 rows=10 width=32) (actual time=630.590..699.313 rows=20 loops=1)                                                                           |
|         Workers Planned: 1                                                                                                                                                        |
|         Workers Launched: 1                                                                                                                                                       |
|         Buffers: shared hit=504 read=321                                                                                                                                          |
|         ->  Parallel Bitmap Heap Scan on addresses  (cost=284.25..200545.98 rows=6 width=32) (actual time=604.604..609.118 rows=19 loops=2)                                       |
|               Recheck Cond: (location IS NOT NULL)                                                                                                                                |
|               Filter: st_dwithin(location, '0101000020E6100000454772F90F5147C0B0726891ED8C37C0'::geography, '50000'::double precision, true)                                      |
|               Rows Removed by Filter: 2                                                                                                                                           |
|               Heap Blocks: exact=2                                                                                                                                                |
|               Buffers: shared hit=504 read=321                                                                                                                                    |
|               ->  Bitmap Index Scan on idx_addresses_location_gist  (cost=0.00..284.25 rows=13424 width=0) (actual time=508.873..508.873 rows=26653 loops=1)                      |
|                     Index Cond: ((location IS NOT NULL) AND (location && _st_expand('0101000020E6100000454772F90F5147C0B0726891ED8C37C0'::geography, '50000'::double precision))) |
|                     Buffers: shared read=304                                                                                                                                      |
| Planning:                                                                                                                                                                         |
|   Buffers: shared hit=217 read=12 dirtied=1                                                                                                                                       |
| Planning Time: 259.740 ms                                                                                                                                                         |
| Execution Time: 700.755 ms                                                                                                                                                        |


## Q7. Pagos aprobados por rango de fecha

| QUERY PLAN                                                                                                                                                                                                                     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Sort  (cost=2465.97..2466.47 rows=200 width=50) (actual time=733.766..733.772 rows=4 loops=1)                                                                                                                                  |
|   Sort Key: (sum(payments.amount)) DESC                                                                                                                                                                                        |
|   Sort Method: quicksort  Memory: 25kB                                                                                                                                                                                         |
|   Buffers: shared hit=842                                                                                                                                                                                                      |
|   ->  HashAggregate  (cost=2455.82..2458.32 rows=200 width=50) (actual time=733.717..733.725 rows=4 loops=1)                                                                                                                   |
|         Group Key: payments.payment_method                                                                                                                                                                                     |
|         Batches: 1  Memory Usage: 40kB                                                                                                                                                                                         |
|         Buffers: shared hit=839                                                                                                                                                                                                |
|         ->  Append  (cost=0.00..2053.28 rows=53672 width=16) (actual time=1.138..717.739 rows=53677 loops=1)                                                                                                                   |
|               Buffers: shared hit=839                                                                                                                                                                                          |
|               ->  Seq Scan on payments_2018_01 payments_1  (cost=0.00..239.19 rows=7233 width=16) (actual time=1.138..110.828 rows=7234 loops=1)                                                                               |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 34                                                                                                                                                                                 |
|                     Buffers: shared hit=112                                                                                                                                                                                    |
|               ->  Seq Scan on payments_2018_02 payments_2  (cost=0.00..221.72 rows=6653 width=16) (actual time=1.040..101.508 rows=6654 loops=1)                                                                               |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 73                                                                                                                                                                                 |
|                     Buffers: shared hit=104                                                                                                                                                                                    |
|               ->  Seq Scan on payments_2018_03 payments_3  (cost=0.00..237.23 rows=7186 width=16) (actual time=1.156..96.218 rows=7187 loops=1)                                                                                |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 26                                                                                                                                                                                 |
|                     Buffers: shared hit=111                                                                                                                                                                                    |
|               ->  Seq Scan on payments_2018_04 payments_4  (cost=0.00..228.43 rows=6923 width=16) (actual time=1.217..103.902 rows=6924 loops=1)                                                                               |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 15                                                                                                                                                                                 |
|                     Buffers: shared hit=107                                                                                                                                                                                    |
|               ->  Seq Scan on payments_2018_05 payments_5  (cost=0.00..226.28 rows=6848 width=17) (actual time=0.607..88.745 rows=6849 loops=1)                                                                                |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 24                                                                                                                                                                                 |
|                     Buffers: shared hit=106                                                                                                                                                                                    |
|               ->  Seq Scan on payments_2018_06 payments_6  (cost=0.00..202.87 rows=6145 width=17) (actual time=0.593..76.287 rows=6146 loops=1)                                                                                |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 18                                                                                                                                                                                 |
|                     Buffers: shared hit=95                                                                                                                                                                                     |
|               ->  Seq Scan on payments_2018_07 payments_7  (cost=0.00..207.16 rows=6253 width=16) (actual time=1.071..72.916 rows=6254 loops=1)                                                                                |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 41                                                                                                                                                                                 |
|                     Buffers: shared hit=97                                                                                                                                                                                     |
|               ->  Seq Scan on payments_2018_08 payments_8  (cost=0.00..214.96 rows=6427 width=17) (actual time=0.037..61.303 rows=6428 loops=1)                                                                                |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 84                                                                                                                                                                                 |
|                     Buffers: shared hit=101                                                                                                                                                                                    |
|               ->  Seq Scan on payments_2018_09 payments_9  (cost=0.00..1.28 rows=1 width=134) (actual time=0.033..0.036 rows=1 loops=1)                                                                                        |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 15                                                                                                                                                                                 |
|                     Buffers: shared hit=1                                                                                                                                                                                      |
|               ->  Seq Scan on payments_2018_10 payments_10  (cost=0.00..1.07 rows=1 width=134) (actual time=0.585..0.585 rows=0 loops=1)                                                                                       |
|                     Filter: ((payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone) AND ((payment_status)::text = 'APPROVED'::text))     |
|                     Rows Removed by Filter: 4                                                                                                                                                                                  |
|                     Buffers: shared hit=1                                                                                                                                                                                      |
|               ->  Index Scan using payments_2018_11_payment_status_payment_date_idx on payments_2018_11 payments_11  (cost=0.14..2.37 rows=1 width=134) (actual time=0.017..0.017 rows=0 loops=1)                              |
|                     Index Cond: (((payment_status)::text = 'APPROVED'::text) AND (payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone)) |
|                     Buffers: shared hit=2                                                                                                                                                                                      |
|               ->  Index Scan using payments_2018_12_payment_status_payment_date_idx on payments_2018_12 payments_12  (cost=0.14..2.37 rows=1 width=134) (actual time=0.021..0.021 rows=0 loops=1)                              |
|                     Index Cond: (((payment_status)::text = 'APPROVED'::text) AND (payment_date >= '2018-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2019-01-01 00:00:00'::timestamp without time zone)) |
|                     Buffers: shared hit=2                                                                                                                                                                                      |
| Planning:                                                                                                                                                                                                                      |
|   Buffers: shared hit=1847 read=72                                                                                                                                                                                             |
| Planning Time: 103.424 ms                                                                                                                                                                                                      |
| Execution Time: 733.974 ms                                                                                                                                                                                                     |

## Q8. Historial transaccional por evento

| QUERY PLAN                                                                                                                                                                                                          |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GroupAggregate  (cost=0.29..3424.51 rows=1 width=23) (actual time=1298.603..1298.609 rows=1 loops=1)                                                                                                                |
|   Buffers: shared hit=1646 read=58                                                                                                                                                                                  |
|   ->  Append  (cost=0.29..3289.49 rows=54002 width=15) (actual time=5.379..1294.071 rows=54011 loops=1)                                                                                                             |
|         Buffers: shared hit=1646 read=58                                                                                                                                                                            |
|         ->  Index Scan using transaction_history_2018_01_event_type_idx on transaction_history_2018_01 transaction_history_1  (cost=0.29..405.41 rows=7268 width=15) (actual time=5.378..218.689 rows=7269 loops=1) |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=221 read=8                                                                                                                                                                        |
|         ->  Index Scan using transaction_history_2018_02_event_type_idx on transaction_history_2018_02 transaction_history_2  (cost=0.29..377.02 rows=6727 width=15) (actual time=6.477..189.646 rows=6728 loops=1) |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=204 read=7                                                                                                                                                                        |
|         ->  Index Scan using transaction_history_2018_03_event_type_idx on transaction_history_2018_03 transaction_history_3  (cost=0.29..401.88 rows=7210 width=15) (actual time=3.051..161.020 rows=7211 loops=1) |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=219 read=8                                                                                                                                                                        |
|         ->  Index Scan using transaction_history_2018_04_event_type_idx on transaction_history_2018_04 transaction_history_4  (cost=0.29..385.54 rows=6938 width=15) (actual time=3.765..187.744 rows=6939 loops=1) |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=211 read=7                                                                                                                                                                        |
|         ->  Index Scan using transaction_history_2018_05_event_type_idx on transaction_history_2018_05 transaction_history_5  (cost=0.29..382.24 rows=6872 width=15) (actual time=3.547..96.953 rows=6873 loops=1)  |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=209 read=7                                                                                                                                                                        |
|         ->  Index Scan using transaction_history_2018_06_event_type_idx on transaction_history_2018_06 transaction_history_6  (cost=0.29..344.30 rows=6166 width=15) (actual time=4.542..147.950 rows=6167 loops=1) |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=187 read=7                                                                                                                                                                        |
|         ->  Index Scan using transaction_history_2018_07_event_type_idx on transaction_history_2018_07 transaction_history_7  (cost=0.29..351.24 rows=6291 width=15) (actual time=3.167..157.859 rows=6292 loops=1) |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=191 read=7                                                                                                                                                                        |
|         ->  Index Scan using transaction_history_2018_08_event_type_idx on transaction_history_2018_08 transaction_history_8  (cost=0.29..364.41 rows=6511 width=15) (actual time=3.104..127.159 rows=6512 loops=1) |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=198 read=7                                                                                                                                                                        |
|         ->  Seq Scan on transaction_history_2018_09 transaction_history_9  (cost=0.00..1.56 rows=16 width=15) (actual time=0.771..0.778 rows=16 loops=1)                                                            |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((event_type)::text = 'ORDER_CREATED'::text))   |
|               Rows Removed by Filter: 16                                                                                                                                                                            |
|               Buffers: shared hit=1                                                                                                                                                                                 |
|         ->  Seq Scan on transaction_history_2018_10 transaction_history_10  (cost=0.00..1.14 rows=1 width=218) (actual time=0.618..0.621 rows=4 loops=1)                                                            |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone) AND ((event_type)::text = 'ORDER_CREATED'::text))   |
|               Rows Removed by Filter: 4                                                                                                                                                                             |
|               Buffers: shared hit=1                                                                                                                                                                                 |
|         ->  Index Scan using transaction_history_2018_11_event_type_idx on transaction_history_2018_11 transaction_history_11  (cost=0.14..2.37 rows=1 width=218) (actual time=0.029..0.030 rows=0 loops=1)         |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=2                                                                                                                                                                                 |
|         ->  Index Scan using transaction_history_2018_12_event_type_idx on transaction_history_2018_12 transaction_history_12  (cost=0.14..2.37 rows=1 width=218) (actual time=0.007..0.008 rows=0 loops=1)         |
|               Index Cond: ((event_type)::text = 'ORDER_CREATED'::text)                                                                                                                                              |
|               Filter: ((created_at >= '2018-01-01 00:00:00'::timestamp without time zone) AND (created_at < '2019-01-01 00:00:00'::timestamp without time zone))                                                    |
|               Buffers: shared hit=2                                                                                                                                                                                 |
| Planning:                                                                                                                                                                                                           |
|   Buffers: shared hit=1451 read=48                                                                                                                                                                                  |
| Planning Time: 85.130 ms                                                                                                                                                                                            |
| Execution Time: 1298.803 ms                                                                                                                                                                                         |