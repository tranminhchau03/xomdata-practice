-- Xom Data · D7 and D30 retention rate
-- Problem: https://xomdata.com/practice/hard-retention-001
-- Solved: 2026-08-17

WITH count_total_user as(
    SELECT COUNT(*) as total_users
    FROM signups
), 
d7 AS(
    SELECT 
        COUNT(DISTINCT s.user_id) AS d7_retained
    FROM signups s
    JOIN activity a ON s.user_id = a.user_id 
        AND a.active_date > s.signup_date
        AND a.active_date <= date(s.signup_date, '+7 days')
),
d30 AS(
    SELECT 
        COUNT(DISTINCT s.user_id) AS d30_retained
    FROM signups s
    JOIN activity a ON s.user_id = a.user_id 
        AND a.active_date > s.signup_date
        AND a.active_date <= date(s.signup_date, '+30 days')
)
SELECT total_users, 
    d7_retained, 
    COALESCE(ROUND(d7_retained * 100.0 / NULLIF(total_users, 0), 2), 0) as d7_rate,
    d30_retained,
    COALESCE(ROUND(d30_retained * 100.0 / NULLIF(total_users, 0), 2), 0) as d30_rate
FROM count_total_user 
        cross join d7   
        cross join d30
