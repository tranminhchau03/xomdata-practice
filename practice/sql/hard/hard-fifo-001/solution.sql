-- Xom Data · Running inventory balance over time
-- Problem: https://xomdata.com/practice/hard-fifo-001
-- Solved: 2026-07-22

SELECT 
    sku,
    occurred_at,
    type,
    quantity,
    SUM(
        CASE 
            WHEN type = 'IN' THEN quantity
            ELSE -quantity
        END 
    ) OVER (PARTITION BY sku ORDER BY sku asc, occurred_at asc, id asc) as running_balance
FROM inventory_movements
ORDER BY sku asc, occurred_at asc, id asc
