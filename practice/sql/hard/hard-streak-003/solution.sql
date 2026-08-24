-- Xom Data · Chuỗi tuần ghé đều không nghỉ
-- Problem: https://xomdata.com/practice/hard-streak-003
-- Solved: 2026-08-24

WITH calc_streak as(
    SELECT distinct
        customer_id,
        CAST((
            JULIANDAY(order_date) - JULIANDAY('2024-01-01'))
            / 7 as integer) + 1 as week
    FROM orders
), 
check_streak as(
    select *,
        week - ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY week asc) as rn
    from calc_streak
),
streak as(
    SELECT *, 
        COUNT(*) as streak_length
    FROM check_streak
    GROUP BY customer_id, rn
)
SELECT 
    customer_id,
    max(streak_length) as longest_week_streak
FROM streak
GROUP BY customer_id
ORDER BY longest_week_streak desc, customer_id asc
