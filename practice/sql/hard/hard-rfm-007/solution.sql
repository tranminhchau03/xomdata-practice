-- Xom Data · Customer momentum: trending up or down between two seasons
-- Problem: https://xomdata.com/practice/hard-rfm-007
-- Solved: 2026-10-25

WITH quarters as(
    SELECT
        customer_id, 
        DATE_PART('quarter', order_date::DATE) as quarter
    FROM orders
),
count_q_orders as(
    SELECT 
        customer_id, 
        COUNT(CASE WHEN quarter = 1 THEN 1 END) as p1_orders,
        COUNT(CASE WHEN quarter = 2 THEN 2 END) as p2_orders
    FROM quarters
    GROUP BY customer_id
),
flag as(
    SELECT
        customer_id, 
        p1_orders,
        p2_orders,
        CASE 
            WHEN p1_orders = 0 AND p2_orders > 0 THEN 'new'
            WHEN p1_orders > 0 AND p2_orders = 0 THEN 'lost'
            WHEN p1_orders > 0 AND p2_orders > 0 AND p2_orders > p1_orders THEN 'up'
            WHEN p1_orders > 0 AND p2_orders > 0 AND p2_orders < p1_orders THEN 'down'
            WHEN p1_orders > 0 AND p2_orders > 0 AND p2_orders = p1_orders THEN 'flat'
        END as trend
    FROM count_q_orders
)
SELECT
    customer_id, 
    p1_orders,
    p2_orders,
    trend
FROM flag
WHERE trend IS NOT NULL
