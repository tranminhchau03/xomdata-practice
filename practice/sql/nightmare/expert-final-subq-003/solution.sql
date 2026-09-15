-- Xom Data · Second-highest-paid employee per department
-- Problem: https://xomdata.com/practice/expert-final-subq-003
-- Solved: 2026-09-15

WITH ranked as(
    SELECT 
        department, 
        full_name, 
        salary, 
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary desc) as rk
    FROM employees
)
SELECT 
    department, 
    full_name, 
    salary
FROM ranked
WHERE rk = 2
ORDER BY department, full_name
