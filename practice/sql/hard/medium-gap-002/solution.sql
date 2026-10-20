-- Xom Data · How long before a customer decides to come back a second time
-- Problem: https://xomdata.com/practice/medium-gap-002
-- Solved: 2026-10-20

WITH rn as(
    SELECT 
        customer_id,
        order_date::DATE,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date asc) as rn
    FROM orders
    -- GROUP BY customer_id
),
flag as(
    SELECT 
        customer_id, 
        CASE WHEN rn = 1 THEN order_date END as first_order_date,
        CASE WHEN rn = 2 THEN order_date END as second_order_date
    FROM rn
    WHERE rn <= 2
), 
merged as(
    SELECT 
        customer_id, 
        first_order_date, 
        lead(second_order_date) OVER (PARTITION BY customer_id ORDER BY first_order_date) as second_order_date
    FROM flag
)
SELECT
    customer_id, 
    first_order_date, 
    second_order_date, 
    second_order_date - first_order_date as days_between
FROM merged
WHERE second_order_date IS NOT NULL
ORDER BY days_between asc, customer_id asc
