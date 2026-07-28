-- Xom Data · 4-step onboarding conversion rate
-- Problem: https://xomdata.com/practice/hard-funnel-001
-- Solved: 2026-07-28

WITH 
four_steps AS(
    SELECT 'signup' as step, 1 as step_order
    UNION ALL 
    SELECT 'verify_email', 2
    UNION ALL 
    SELECT 'first_login', 3
    UNION ALL 
    SELECT 'first_purchase', 4
),
count_user_step as(
    SELECT 
        fs.step,
        fs.step_order,
        COUNT(distinct user_id) as n_users
    FROM events e RIGHT JOIN four_steps fs ON e.event_name = fs.step
    GROUP BY fs.step, fs.step_order
),
count_user_signup as(
    SELECT 
        COUNT(*) as count_signup
    FROM events
    WHERE event_name = 'signup'
)
SELECT 
    step, 
    n_users,
    COALESCE(ROUND((n_users * 100.00) / NULLIF(count_signup, 0), 2), 0) as conversion_pct
FROM count_user_signup signup CROSS JOIN count_user_step steps 
ORDER BY step_order asc
