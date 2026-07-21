-- Xom Data · Accounts with no posts
-- Problem: https://xomdata.com/practice/medium-leftjoin-096
-- Solved: 2026-07-21

SELECT
    u.full_name,
    u.username,
    u.account_type, 
    ROW_NUMBER() OVER (ORDER BY u.created_at ASC, u.username ASC) as signup_order,
    NTILE(4) OVER (ORDER BY u.created_at ASC) as tenure_quartile 
FROM users u LEFT JOIN posts p ON u.id = p.user_id
WHERE p.id IS NULL
ORDER BY signup_order
