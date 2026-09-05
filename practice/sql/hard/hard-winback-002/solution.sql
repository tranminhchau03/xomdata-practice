-- Xom Data · Đếm những sự trở lại mỗi tháng
-- Problem: https://xomdata.com/practice/hard-winback-002
-- Solved: 2026-09-05

WITH months as(
    SELECT DISTINCT
        customer_id,
        strftime('%Y-%m', order_date) as month
    FROM orders 
),
prev_months as(
    SELECT  
        customer_id,
        month,
        LAG(month) OVER (PARTITION BY customer_id ORDER BY month) as prev_month
        -- MIN(month) OVER (PARTITION BY customer_id ORDER BY month) as 
    from months
),
streak_info as(
    SELECT 
        customer_id, 
        month, 
        prev_month, 
        case when month is not null and prev_month is null THEN 1 
            else 0 
        end as start_streak, 
        case when month >= strftime('%Y-%m', DATE(prev_month || '-01', '+3 months')) THEN 1 
            else 0 
        end as return_after_2m
    FROM prev_months
)
SELECT
    month, 
    count(case when start_streak = 0 and return_after_2m = 1 then 1 end) as resurrected_customers 
FROM streak_info
GROUP BY month
HAVING resurrected_customers > 0
