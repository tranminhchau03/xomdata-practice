-- Xom Data · Spending tiers of loyal customers
-- Problem: https://xomdata.com/practice/medium-denserank-003
-- Solved: 2026-10-08

-- Write your SQL here
WITH calc_amount as(
    SELECT 
        customer_name, 
        SUM(amount) as total_spent
    FROM purchases
    GROUP BY customer_name
)
SELECT 
    customer_name, 
    total_spent,
    DENSE_RANK() OVER (ORDER BY total_spent desc) as spend_tier
FROM calc_amount
ORDER BY spend_tier, customer_name
