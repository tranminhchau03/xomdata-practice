-- Xom Data · Summary of issues to handle
-- Problem: https://xomdata.com/practice/medium-union-175
-- Solved: 2026-07-18

WITH classification_problem AS(
    SELECT 'Complaint' as type, COUNT(*) as quantity --count_pending
    FROM complaints c 
    WHERE c.status = 'Pending' 
    UNION ALL
    SELECT 'Cancelled Order' as type, COUNT(*) AS quantity -- count_cancelled
    FROM orders o
    WHERE o.status = 'Cancelled' 
    UNION ALL 
    SELECT 'Out of Stock Product' as type, COUNT(*) AS quantity --count_ofs
    FROM products p
    WHERE p.status = 'Out of Stock' 
),
pct_of_total_quantity AS(
    select 
        -- CASE 
        --     WHEN type = 'Pending' THEN 'Complaint'
        --     WHEN type = 'Cancelled' THEN 'Cancelled Order'
        --     ELSE 'Out of Stock Product'
        -- END AS type, 
        type,
        quantity,
        quantity * 100.00 / SUM(quantity) OVER() AS pct_of_total,
        RANK() OVER(ORDER BY quantity DESC) AS rank_pos
    FROM classification_problem 
)
SELECT 
    type, 
    quantity,
    ROUND(pct_of_total, 2) AS pct_of_total,
    rank_pos,
    ROUND(SUM(pct_of_total) OVER (ORDER BY rank_pos ASC, type ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS cumulative_pct
FROM pct_of_total_quantity
ORDER BY rank_pos ASC, type ASC
