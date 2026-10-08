-- Xom Data · Monthly recurring revenue (MRR) by subscription plan
-- Problem: https://xomdata.com/practice/hard-mrr-001
-- Solved: 2026-10-07

WITH to_dates as(
    SELECT 
        user_id, 
        plan, 
        DATE(started_at) as started_at,
        DATE(NULLIF(ended_at, '')) as ended_at,
        mrr
    FROM subscriptions
),
scope as(
    SELECT 
        MIN(started_at) as started,
        MAX(started_at) as ended
    FROM to_dates
),
list_months as(
    SELECT
        DATE(started, 'start of month') as list_m
    FROM scope

    UNION ALL 

    SELECT 
        DATE(list_m, '+1 month')
    FROM scope CROSS JOIN list_months
    WHERE list_m < DATE(ended, 'start of month')
),
new_subs as(
    SELECT 
        user_id,
        plan,
        started_at, 
        ended_at,
        list_m,
        mrr        
    FROM list_months 
        LEFT JOIN to_dates 
        ON strftime('%Y-%m', started_at) <= strftime('%Y-%m', list_m)
        AND (ended_at IS NULL OR ended_at > date(list_m, '+1 month', '-1 day'))
)
SELECT 
    strftime('%Y-%m', list_m) as month,
    COUNT(user_id) as active_subs,
    COALESCE(SUM(mrr), 0) as total_mrr
FROM new_subs
GROUP BY month
ORDER BY month
