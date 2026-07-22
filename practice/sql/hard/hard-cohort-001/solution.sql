-- Xom Data · Retention rate by signup-month cohort
-- Problem: https://xomdata.com/practice/hard-cohort-001
-- Solved: 2026-07-22

WITH status_users as(
    SELECT 
        s.user_id,
        strftime('%Y-%m', signup_date) as signup_month,
        strftime('%Y-%m', active_date) as active_month
    FROM signups s JOIN activity a ON s.user_id = a.user_id
)
SELECT 
    signup_month, 
    active_month,
    COUNT(DISTINCT user_id) as n_active
FROM status_users
WHERE active_month >= signup_month
GROUP BY signup_month, active_month
ORDER BY signup_month, active_month
