-- Xom Data · Điểm tươi mới cộng điểm chuyên cần
-- Problem: https://xomdata.com/practice/hard-rfm-003
-- Solved: 2026-09-08

WITH customer_info as(
    SELECT 
        customer_id, 
        max(order_date) as lastest_order_date,
        COUNT(order_date) as total_orders
    FROm orders 
    GROUP BY customer_id
),
ranked as(
    SELECT  
        customer_id,
        6 - NTILE(5) OVER (ORDER BY lastest_order_date desc, customer_id asc) as r_score, 
        CASE WHEN total_orders >= 8 THEN 3 
            WHEN total_orders BETWEEN 4 AND 7 THEN 2
            ELSE 1 
        END as f_score
    FROM customer_info
)
SELECT 
    customer_id, 
    r_score, 
    f_score,
    r_score + f_score as total_score, 
    CASE WHEN r_score + f_score >= 7 THEN 'Gold'
         WHEN r_score + f_score BETWEEN 5 AND 6 THEN 'Silver'
         ELSE 'Bronze'
    END as label
FROM ranked
