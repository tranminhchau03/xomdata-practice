-- Xom Data · Bản đồ tám nhóm khách hàng
-- Problem: https://xomdata.com/practice/hard-rfm-006
-- Solved: 2026-09-01

WITH count_silent_days_and_orders AS(
    SELECT 
        customer_id, 
        JULIANDAY('2024-06-30') - JULIANDAY(MAX(order_date)) as days_since, 
        COUNT(*) as total_orders
    FROM orders
    GROUP BY customer_id
), 
rf_score as(
    SELECT 
        customer_id,
        CASE WHEN days_since <= 30 THEN 4
            WHEN days_since BETWEEN 31 AND 60 THEN 3
            WHEN days_since BETWEEN 61 AND 120 THEN 2
            WHEN days_since > 120 THEN 1
        END as r,
        CASE WHEN total_orders >= 10 THEN 4
            WHEN total_orders BETWEEN 5 AND 9 THEN 3
            WHEN total_orders BETWEEN 2 AND 4 THEN 2
            WHEN total_orders = 1 THEN 1
        END as f
    FROM count_silent_days_and_orders
)
SELECT 
    customer_id, 
    r as r_score, 
    f as f_score, 
    CASE WHEN r >= 3 AND F >= 3 THEN 'Champions'
         WHEN r >= 3 AND f = 2 THEN 'Potential Loyalist'
         WHEN r >= 3 AND f = 1 THEN 'New Customers'
         WHEN r = 2 AND f >= 3 THEN 'At risk'
         WHEN r = 2 ANd f <=2 THEN 'About To Sleep'
         WHEN r = 1 AND f >= 3 THEN 'Cannot Lose Them'
         WHEN r = 1 AND f = 2 THEN 'Hibernating'
         WHEN r = 1 ANd f = 1 THEN 'Lost'
    END as segment
FROM rf_score
