-- Xom Data · Users active 5+ consecutive days
-- Problem: https://xomdata.com/practice/nightmare-active-users-001
-- Solved: 2026-09-13

WITH prev_login_dates as(
    SELECT 
        id, 
        login_date, 
        LAG(login_date) OVER (PARTITION BY id ORDER BY login_date) as prev_date
    FROM Logins
),
list_consecusive as(
    SELECT 
        id,
        SUM(
            CASE WHEN prev_date IS NULL THEN 1
                WHEN login_date = DATE(prev_date, '+1 day') THEN 0
                ELSE 1
            END 
        ) OVER (PARTITION BY id ORDER BY login_date asc) as streak_id
    FROM prev_login_dates
),
rn as(
    SELECT * ,
        ROW_NUMBER() OVER (PARTITION BY id, streak_id ORDER BY streak_id) as rn
    FROM list_consecusive
)
SELECT DISTINCT id
FROM rn
WHERE rn = 5
ORDER BY id asc
