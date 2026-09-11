-- Xom Data · Top 3 salaries per department
-- Problem: https://xomdata.com/practice/nightmare-top3-dept-001
-- Solved: 2026-09-11

WITH ranked as(
    SELECT 
        d.name as Department, 
        e.name as Employee,
        e.salary, 
        DENSE_RANK() OVER (PARTITION BY departmentId ORDER BY salary desc) as rk
    FROM Employee e JOIN Department d ON e.departmentId = d.id
    ORDER BY Department asc, salary desc, Employee asc
)
SELECT 
    Department, 
    Employee, 
    salary
FROM ranked
WHERE rk <= 3
