-- Xom Data · Top 5 highest-paid employees
-- Problem: https://xomdata.com/practice/easy-limit-004
-- Solved: 2026-07-16

SELECT full_name, salaries
FROM employees
ORDER BY salaries DESC
LIMIT 5
