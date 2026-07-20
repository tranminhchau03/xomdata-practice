-- Xom Data · Salary by department and title
-- Problem: https://xomdata.com/practice/medium-join-126
-- Solved: 2026-07-20

WITH 
calc_salary_per_dept as(
    SELECT 
        d.department_name,
        p.position_name, 
        COUNT(e.id) as employee_count,
        ROUND(AVG(pr.net_salary), 0) as avg_salary,
        MIN(pr.net_salary) as min_salary,
        MAX(pr.net_salary) as max_salary,
        MAX(pr.net_salary) - MIN(pr.net_salary) as salary_spread
    FROM 
        departments d JOIN employees e ON d.id = e.department_id 
                    JOIN positions p ON p.id = e.position_id
                    JOIN payroll pr  ON pr.employee_id = e.id
    GROUP BY d.department_name, p.position_name
)
SELECT 
    department_name,
    position_name, 
    employee_count,
    avg_salary,
    min_salary,
    max_salary,
    salary_spread,
    RANK() OVER (PARTITION BY department_name ORDER BY avg_salary DESC) as rank_in_dept
FROM calc_salary_per_dept
ORDER BY department_name asc, rank_in_dept asc, position_name asc
