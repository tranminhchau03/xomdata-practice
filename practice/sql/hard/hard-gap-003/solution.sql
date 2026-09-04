-- Xom Data · Dự đoán ngày khách ghé tiếp theo
-- Problem: https://xomdata.com/practice/hard-gap-003
-- Solved: 2026-09-04

WITH status_orders AS(
    SELECT 
        customer_id,
        MAX(order_date) OVER (PARTITION BY customer_id ORDER BY customer_id asc) as last_order_date, 
        COUNT(*) OVER (PARTITION BY customer_id) as total_order,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date asc) as prev_order_date
    FROM orders
),
calc_avg_gap_days as(
    SELECT distinct
        customer_id, 
        last_order_date, 
        FLOOR(AVG(JULIANDAY(order_date) - JULIANDAY(prev_order_date))) as avg_gap_days
    FROM status_orders
    WHERE total_order > 1
    GROUP BY customer_id 
)
SELECT 
    customer_id, 
    last_order_date, 
    avg_gap_days,
    DATE(last_order_date, '+' || avg_gap_days || ' days') as predicted_next_date
FROM calc_avg_gap_days
ORDER BY predicted_next_date asc, customer_id asc
