-- Xom Data · Each expense's share of the fund
-- Problem: https://xomdata.com/practice/medium-winagg-006
-- Solved: 2026-10-23

-- Write your SQL here
SELECT 
    expense_name, 
    amount,
    ROUND(amount * 100. / SUM(amount) OVER(), 2) as pct_of_total
FROM fund_expenses
ORDER BY pct_of_total desc, expense_name
