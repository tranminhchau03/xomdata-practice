-- Xom Data · Customers active and purchasing 3 weeks in a row
-- Problem: https://xomdata.com/practice/nightmare-streak-001
-- Solved: 2026-09-10

WITH 
no_weeks as (
    SELECT DISTINCT
        user_id, 
        strftime('%Y-%W', event_date) as week,
        CAST(strftime('%Y', event_date) AS INTEGER) * 53 + 
        CAST(strftime('%W', event_date) AS INTEGER) AS week_num
    FROM events
    WHERE subtype = 'purchase'
), 
prevs as(
    SELECT
        user_id, 
        week, 
        week_num,
        week_num
        -
        LAG(week_num) OVER (PARTITION BY user_id ORDER BY week_num asc) as diff
    FROM no_weeks
),
marked_streak as(
    SELECT 
        *, 
        CASE WHEN diff IS NULL  THEN 1 
             WHEN diff <> 1     THEN 1
             ELSE 0 
        END as flag   
    FROM prevs
), 
create_id_streak as(
    SELECT 
        *, 
        SUM(flag) OVER (PARTITION BY user_id ORDER BY week_num asc
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cus_streak_id
    FROM marked_streak
)
SELECT 
    user_id, 
    MIN(week) as streak_start_week, 
    MAX(week) as streak_end_week,
    COUNT(*) as n_weeks
FROM create_id_streak
GROUP BY user_id, cus_streak_id
HAVING n_weeks >= 3
ORDER BY user_id asc, streak_start_week asc
