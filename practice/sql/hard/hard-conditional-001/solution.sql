-- Xom Data · Cumulative revenue from successful transactions only
-- Problem: https://xomdata.com/practice/hard-conditional-001
-- Solved: 2026-07-22

SELECT 
    date, 
    status,
    amount,
    SUM(
        CASE
            WHEN status = 'success' THEN amount
            ELSE 0
        END
    ) 
    OVER (ORDER BY date asc, status asc, id asc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_success_total
FROM transactions
ORDER BY date asc, status asc, id asc
