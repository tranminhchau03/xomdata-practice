-- Xom Data · Median salary per department
-- Problem: https://xomdata.com/practice/sql-nightmare-002
-- Solved: 2026-09-15

WITH rn as(
    SELECT 
        dept, 
        COUNT(*) OVER (PARTITION BY dept) as total_emp, 
        ROW_NUMBER() OVER(PARTITION BY dept ORDER BY salary desc) as rn, 
        salary
    FROM employees
    ORDER BY salary desc
)
SELECT 
    dept, 
    ROUND(AVG(salary)) as median_salary
FROM rn 
WHERE  rn = (ROUND(total_emp / 2.0))
    OR rn IN ((total_emp / 2.0), ROUND((total_emp + 1) / 2.0))
GROUP BY dept, total_emp
