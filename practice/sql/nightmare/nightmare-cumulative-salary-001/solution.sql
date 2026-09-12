-- Xom Data · 3-month rolling payroll (excluding each employee's latest month)
-- Problem: https://xomdata.com/practice/nightmare-cumulative-salary-001
-- Solved: 2026-09-12

WITH m as(
    SELECT id, max(month) as newest_m
    FROM Employee 
    GROUP BY id
)
SELECT 
    e.id, 
    e.month,
    SUM(e.salary) OVER (PARTITION BY id
                        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as Salary
FROM Employee e LEFT JOIN m USING(id)
WHERE e.month < newest_m
ORDER BY id, month desc
