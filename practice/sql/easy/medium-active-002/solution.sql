-- Xom Data · Who showed up in two consecutive months
-- Problem: https://xomdata.com/practice/medium-active-002
-- Solved: 2026-10-20

SELECT customer_id
FROM 
    (
        SELECT
            CASE WHEN order_date LIKE '2024-03%' THEN customer_id END as customer_id
        FROM orders
        INTERSECT
        SELECT 
            CASE WHEN order_date LIKE '2024-04%' THEN customer_id END 
        FROM orders
    )
WHERE customer_id IS NOT NULL
