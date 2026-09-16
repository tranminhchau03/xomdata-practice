-- Xom Data · Inventory value using FIFO
-- Problem: https://xomdata.com/practice/sql-nightmare-007
-- Solved: 2026-09-16

WITH calc_remain as(
    SELECT 
        *,
        SUM(quantity) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) - demand_qty as remain
    FROM inventory CROSS JOIN sales_demand
), 
flag as(
    SELECT 
        *,  LAG(remain) OVER (ORDER BY batch_date),
        case when remain < 0 THEN remain
            
            WHEN remain > 0 AND LAG(remain) OVER (ORDER BY batch_date) >= 0 THEN '0'
            else remain
        END as flag
    FROM calc_remain
), 
remaining_qties as(
    SELECT *,
        case when flag = '0' THEN quantity 
            else remain
        END as remaining_qty
    FROM flag
    WHERE remain > 0
)
SELECT 
    batch_id, 
    batch_date,
    remaining_qty, 
    unit_cost, 
    remaining_qty * unit_cost as remaining_value
FROM remaining_qties 
ORDER BY batch_date asc, batch_id asc
