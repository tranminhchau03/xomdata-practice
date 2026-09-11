-- Xom Data · Frequently co-purchased product pairs
-- Problem: https://xomdata.com/practice/sql-nightmare-004
-- Solved: 2026-09-11

WITH cus_prd as (
    SELECT DISTINCT
        a.user_id, 
        a.product_id as a, 
        b.product_id as b
    FROM orders a JOIN orders b ON a.user_id = b.user_id and a.product_id < b.product_id
)
SELECT 
    a as product_a,
    b as product_b, 
    count(user_id) as co_buyers
FROM cus_prd
GROUP BY a, b
ORDER BY co_buyers desc, product_a, product_b
