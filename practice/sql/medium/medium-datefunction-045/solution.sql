-- Xom Data · Transaction count and amount by month
-- Problem: https://xomdata.com/practice/medium-datefunction-045
-- Solved: 2026-07-17

WITH transaction_month AS(
    SELECT 
        strftime('%Y-%m', transaction_date) AS month,
        COUNT(*) AS transaction_count, 
        SUM(amount) AS total_amount 
    FROM transactions
    GROUP BY month
    ORDER BY month ASC
)
SELECT 
    month, 
    transaction_count,
    total_amount, 
    total_amount - LAG(total_amount) OVER (ORDER BY month) AS mom_delta
FROM transaction_month
ORDER BY month ASC
