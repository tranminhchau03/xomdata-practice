-- Xom Data · Daily revenue including zero-sale days
-- Problem: https://xomdata.com/practice/hard-gapfill-001
-- Solved: 2026-08-20

WITH RECURSIVE 
daily AS (
    SELECT
        date,
        SUM(d.amount) AS revenue
    FROM daily_revenue d
    GROUP BY date
),
dates(day) as (
    SELECT DATE(MIN(date)) 
    FROM daily_revenue

    UNION ALL 

    SELECT DATE(day, '+1 day')
    FROM dates
    WHERE day < DATE((SELECT max(date) from daily_revenue))
)
SELECT distinct
    day as date, 
    CASE 
        WHEN revenue is not null THEN revenue 
        ELSE 0 
    END as revenue
FROm dates d LEFT JOIN daily r ON d.day = r.date
ORDER BY date asc
