-- Xom Data · Chuỗi tháng ghé đều dài nhất
-- Problem: https://xomdata.com/practice/hard-streak-001
-- Solved: 2026-09-01

WITH months as (
    SELECT DISTINCT
        customer_id, 
        strftime('%Y-%m', order_date) as month
    FROM orders
),
prev_months as(
    SELECT 
        customer_id, 
        month, 
        LAG(month) OVER(PARTITION BY customer_id ORDER BY month asc) as prev_month
    FROM months
), 
mark_streaks as(
    SELECT 
        customer_id, 
        month, 
        CASE WHEN prev_month IS NULL THEN 1
            WHEN month = strftime('%Y-%m', DATE(prev_month || '-01', '+1 month')) THEN 0
            ELSE 1
        END as start_streak
    FROM prev_months
), 
list_streak as(
    SELECT  
        customer_id, 
        month, 
        SUM(start_streak) OVER (PARTITION BY customer_id ORDER BY month asc
                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as streak_id
    FROM mark_streaks
), 
grp as(
    SELECT 
        customer_id, 
        streak_id,
        count(*) as streak_length
    FROM list_streak
    GROUP BY customer_id, streak_id
) 
SELECT  
    customer_id, 
    max(streak_length) as longest_streak
from grp
GROUP By customer_id
ORDER BY longest_streak desc, customer_id asc
