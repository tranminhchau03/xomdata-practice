-- Xom Data · Active or stopped subscription
-- Problem: https://xomdata.com/practice/medium-churn-002
-- Solved: 2026-10-19

SELECT 
    sub_id, 
    customer_id, 
    CASE WHEN end_date IS NULL OR end_date >= '2024-06-30' THEN 'active'
         WHEN end_date < '2024-06-30' THEN 'stopped'
    END as status
FROM subscriptions
