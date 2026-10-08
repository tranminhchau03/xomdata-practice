-- Xom Data · Splitting customers into four spending tiers
-- Problem: https://xomdata.com/practice/medium-ntile-001
-- Solved: 2026-10-08

-- Write your SQL here
SELECT 
    customer_name,
    total_spent,
    NTILE(4) OVER (ORDER BY total_spent desc, customer_name asc) as spend_quartile
FROM customer_spending
ORDER BY spend_quartile asc
