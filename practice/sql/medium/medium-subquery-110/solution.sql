-- Xom Data · Employees paid above their department average
-- Problem: https://xomdata.com/practice/medium-subquery-110
-- Solved: 2026-07-18

WITH avg_salary_per_dept AS(
    SELECT 
        e.full_name, 
        d.dept_name, 
        e.salary,
        AVG(salary) OVER (PARTITION BY d.id) AS dept_avg_salary
    FROM departments d JOIN employees e ON d.id = e.department_id
)
SELECT 
    full_name,
    dept_name,
    salary,
    ROUND(dept_avg_salary, 0) as dept_avg_salary,
    ROUND((salary * 100.00 / dept_avg_salary) - 100, 2) AS premium_pct
FROM avg_salary_per_dept
WHERE salary > dept_avg_salary
ORDER BY premium_pct DESC, dept_name, full_name
