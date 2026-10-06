-- Xom Data · Next-month customer retention rate by cohort
-- Problem: https://xomdata.com/practice/expert-final-cohort-002
-- Solved: 2026-10-06

WITH grp_month as(
    SELECT  DISTINCT
        user_id, 
        strftime('%Y-%m', order_date) as month, 
        LEAD(strftime('%Y-%m', order_date)) 
            OVER (PARTITION BY user_id
                  ORDER BY strftime('%Y-%m', order_date) asc) as prev
    FROM orders
),
count_users as(
    SELECT 
        month as first_month,
        COUNT(*) as first_month_users,
        COUNT(
            CASE 
                WHEN prev = strftime('%Y-%m', DATE(month || '-01', '+1 month')) THEN 1 
            END 
        )as return_count
    FROM grp_month
    GROUP BY month
)
SELECT 
    first_month,
    first_month_users,
    return_count,
    ROUND(return_count * 100.0 / first_month_users, 1) as retention_rate
FROm count_users
ORDER BY first_month
