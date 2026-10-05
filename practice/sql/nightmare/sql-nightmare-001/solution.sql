-- Xom Data · Longest consecutive login streak
-- Problem: https://xomdata.com/practice/sql-nightmare-001
-- Solved: 2026-10-05

WITH 
prev_logs as(
    SELECT
        user_id,
        login_date, 
        LAG(login_date) OVER (PARTITION BY user_id ORDER BY login_date asc) as prev
    FROM logins
)
SELECT DISTINCT
    user_id, 
    SUM( 
        CASE WHEN prev IS NULL THEN 1 
             WHEN JULIANDAY(login_date) - JULIANDAY(prev) = 1 THEN 1 
             ELSE 0 
        END 
    ) OVER (PARTITION BY user_id) as max_streak
FROM prev_logs
ORDER BY user_id asc
