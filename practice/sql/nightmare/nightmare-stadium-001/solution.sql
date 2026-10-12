-- Xom Data · Stadium high-attendance streaks (3+ consecutive days ≥ 100)
-- Problem: https://xomdata.com/practice/nightmare-stadium-001
-- Solved: 2026-10-12

WITH 
text_date as(
    SELECT 
        id, 
        TO_DATE(visit_date, 'YYYY-MM-DD') as visit_date,
        people
    FROM Stadium
    WHERE people >= 100
),
rnum as(
    SELECT
        id, 
        visit_date, 
        people,
        ROW_NUMBER() OVER (ORDER BY visit_date asc) as rn
    FROM text_date
), 
grp_dates as(
    SELECT 
        id, 
        visit_date, 
        people,
        visit_date - (rn * INTERVAL '1 day') as grp_date
    FROM rnum
),
count_streak as(
    SELECT  
        id,
        visit_date, 
        people,
        COUNT(grp_date) OVER (PARTITION BY grp_date)as streak
    FROM grp_dates
)
SELECT 
    id, 
    visit_date, 
    people
FROM count_streak
WHERE streak >= 3
ORDER BY visit_date asc
