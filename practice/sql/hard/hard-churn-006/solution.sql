-- Xom Data · A risk detector tuned to each person's habit
-- Problem: https://xomdata.com/practice/hard-churn-006
-- Solved: 2026-10-26

WITH calc_gap as(
    SELECT
        customer_id, 
        order_date::DATE,
        order_date::DATE - LAG(order_date::DATE) OVER (PARTITION BY customer_id ORDER BY order_date asc) as gap_days
    FROM orders
),
calc_avg_gap as(
    SELECT
        customer_id, 
        MAX(order_date) as last_order,
        ROUND(avg(gap_days), 2) as avg_gap
    FROM calc_gap
    GROUP BY customer_id
) 
SELECT
    customer_id, 
    '2024-06-30'::DATE - last_order as days_silent,
    avg_gap,
    CASE 
        WHEN '2024-06-30'::DATE - last_order > avg_gap * 1.5 THEN 'at_risk'
        WHEN '2024-06-30'::DATE - last_order <= avg_gap * 1.5 THEN 'healthy'
        ELSE 'unknown'
    END as risk
FROM calc_avg_gap
