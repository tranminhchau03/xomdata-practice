-- Xom Data · Stock-in history by supplier
-- Problem: https://xomdata.com/practice/medium-join-014
-- Solved: 2026-07-19

WITH count_info AS(
    SELECT
        w.warehouse_name,
        COUNT(*) AS import_count, 
        COUNT(DISTINCT p.id) AS distinct_product_count,
        COUNT(DISTINCT s.suppliers) AS distinct_supplier_count,
        MAX(import_date) AS last_import_date
    FROM stock_imports s JOIN products p ON s.product_id = p.id
                        JOIN warehouses w ON s.warehouse_id = w.id
    GROUP BY w.warehouse_name
),
ranking AS(
    SELECT 
        warehouse_name, 
        import_count,
        distinct_product_count, 
        distinct_supplier_count,
        last_import_date, 
        RANK() OVER (ORDER BY import_count DESC) as activity_rank
    FROM count_info
)
SELECT 
    warehouse_name, 
    import_count, 
    distinct_product_count, 
    distinct_supplier_count,
    last_import_date, 
    activity_rank,
    LAG(warehouse_name) OVER (ORDER BY activity_rank ASC) AS prev_warehouse
FROM ranking
ORDER BY activity_rank ASC, warehouse_name ASC
