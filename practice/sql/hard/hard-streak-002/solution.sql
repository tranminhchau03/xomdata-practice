-- Xom Data · Ai đang giữ phong độ đến tận hôm nay
-- Problem: https://xomdata.com/practice/hard-streak-002
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
            WHEN month = strftime('%Y-%m', prev_month || '-01', '+1 month') THEN 0
            ELSE 1
        END as start_streak
    FROM prev_months
), 
list_streak as(
    SELECT  
        customer_id, 
        month, 
        SUM(start_streak) OVER (PARTITION BY customer_id ORDER BY month asc) as streak_id
    FROM mark_streaks
), 
find_streak_with_June as(
    SELECT 
        customer_id, 
        streak_id
    FROM list_streak
    WHERE month = '2024-06'
)
SELECT 
    j.customer_id, 
    count(*) as current_streak
FROM list_streak l JOIN find_streak_with_June j ON j.customer_id = l.customer_id AND j.streak_id = l.streak_id
GROUP BY j.customer_id
