-- Xom Data · Closing a second order within a month
-- Problem: https://xomdata.com/practice/medium-repeat-004
-- Solved: 2026-10-21

WITH rnum as(
    SELECT
        customer_id, 
        order_date, 
        ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) as rn
    FROM orders
),
first_second_date as(
    SELECT
        customer_id, 
        CASE WHEN rn = 1 THEN order_date END as first_order_date,
        CASE WHEN rn = 2 THEN order_date END as second_order_date
    FROM rnum
    WHERE rn <= 2
),
merged as(
    SELECT 
        customer_id,
        first_order_date,
        LEAD(second_order_date) OVER (PARTITION BY customer_id ORDER BY first_order_date) as second_order_date
    FROM first_second_date
)
SELECT  
    customer_id, 
    first_order_date, 
    second_order_date,
    second_order_date::DATE - first_order_date::DATE as days_to_second
FROM merged 
WHERE second_order_date IS NOT NULL AND second_order_date::DATE - first_order_date::DATE <= 30
