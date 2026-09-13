-- Xom Data · Conversion rate through a 4-step purchase funnel
-- Problem: https://xomdata.com/practice/sql-nightmare-009
-- Solved: 2026-09-13

WITH funnel_types as(
    SELECT 'visit' as step, 1 as level
    UNION ALL 
    SELECT 'cart', 2
    UNION ALL 
    SELECT 'checkout', 3
    UNION ALL 
    SELECT 'payment', 4 
),
count_users as(
    SELECT 
        count(distinct case when event = 'visit' Then user_id end) as total_users
    FROM funnel_events
),
grp as(
    SELECT 
        step, 
        COUNT(*) as users, 
        level      
    FROM funnel_events JOIN funnel_types ON step = event
    GROUP BY step, level
    ORDER BY level
)
SELECT  
    step, 
    users, 
    ROUND(users * 100.0 / total_users, 2) as pct_of_total, 
    ROUND(users * 100.0 / LAG(users) OVER (ORDER BY level), 2) as pct_of_prev
FROM count_users cross join grp
ORDER BY level asc
