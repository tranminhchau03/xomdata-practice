-- Xom Data · An unusually long absence
-- Problem: https://xomdata.com/practice/hard-gap-004
-- Solved: 2026-10-25

WITH calc_distance as(
    SELECT 
        customer_id,
        order_date::DATE,
        order_date::DATE - 
        LAG(order_date::DATE) OVER (PARTITION BY customer_id ORDER BY order_date) as gap_days
    FROM orders
),
calc_avg as(
    SELECT 
        customer_id,
        gap_days,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) as gap_start,
        AVG(gap_days) OVER (PARTITION BY customer_id) as avg_gap
    FROM calc_distance
) 
SELECT 
    customer_id,    
    gap_start,
    order_date as gap_end,
    gap_days,
    ROUND(avg_gap, 2) as avg_gap
FROM calc_avg
WHERE gap_days > avg_gap * 2
