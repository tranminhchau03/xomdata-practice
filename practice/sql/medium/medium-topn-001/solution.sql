-- Xom Data · Sales champion of each region
-- Problem: https://xomdata.com/practice/medium-topn-001
-- Solved: 2026-10-01

WITH ranked as(
    SELECT 
        region, 
        rep_name, 
        sales_amount, 
        RANK() OVER(PARTITION BY region ORDER BY sales_amount desc, rep_name asc) as rk
    FROM reps
)
SELECT 
    region, 
    rep_name, 
    sales_amount
FROM ranked 
WHERE rk = 1
ORDER BY region asc
