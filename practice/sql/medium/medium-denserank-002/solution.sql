-- Xom Data · Salary bands within each department
-- Problem: https://xomdata.com/practice/medium-denserank-002
-- Solved: 2026-08-17

-- Viết SQL của bạn ở đây
SELECT 
    department, 
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary desc) as salary_tier,
    full_name, 
    salary
FROM employees
ORDER BY department, salary_tier, full_name
