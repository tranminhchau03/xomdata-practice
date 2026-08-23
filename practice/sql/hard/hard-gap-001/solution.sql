-- Xom Data · Nhịp mua hàng và tín hiệu rời bỏ
-- Problem: https://xomdata.com/practice/hard-gap-001
-- Solved: 2026-08-23

WITH count_order as(
    SELECT 
        customer_id, 
        COUNT(order_date) as total_order    
    FROM orders 
    GROUP BY customer_id
), 
calc_gap_days as(
    SELECT 
        customer_id,
        -- order_date,
        -- LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date asc) as prev_order, 
        JULIANDAY(order_date) - JULIANDAY(LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date asc)) as gap_days
    FROM orders
), 
calc_avg_days as(
    SELECT 
        DISTINCT o.customer_id, 
        AVG(gap_days) OVER(PARTITION BY g.customer_id) as avg_gap_days, 
        total_order
    FROM calc_gap_days g JOIN count_order o ON o.customer_id = g.customer_id
)
SELECT 
    customer_id, 
    ROUND(avg_gap_days, 1) as avg_gap_days, 
    CASE 
        WHEN total_order = 1 and avg_gap_days IS NULL THEN 'single'
        WHEN avg_gap_days <= 30 THEN 'fast'
        WHEN avg_gap_days > 30 THEN 'slow'
    END as pace
FROM calc_avg_days
