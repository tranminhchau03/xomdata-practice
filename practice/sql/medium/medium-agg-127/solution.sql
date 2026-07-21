-- Xom Data · Top 10 highest-paid employees and their leave days
-- Problem: https://xomdata.com/practice/medium-agg-127
-- Solved: 2026-07-21

-- select * 
-- from departments d JOIN employees e ON d.id = e.department_id 
--                    JOIN payroll p ON p.employee_id = e.id 
--                    JOIN leaves l ON l.employee_id = e.id
WITH 
count_accept_leave as(
    SELECT 
        employee_id,
        COUNT(
            CASE
                WHEN status = 'duyet' THEN id
            END) as leave_count
    FROM leaves 
    GROUP BY employee_id
),
calc_salary_per_employee as(
    SELECT 
        employee_id, 
        SUM(net_salary) as total_received_salary -- total salary per 1 employee
    FROM payroll 
    GROUP BY employee_id
),
calc_salary_per_dept as(
    SELECT 
        e.id,
        e.full_name,
        e.employee_code,
        d.department_name,
        s.total_received_salary,
        ROUND(AVG(s.total_received_salary) OVER (PARTITION BY d.id), 2) as avg_salary_dept 
    FROM calc_salary_per_employee s JOIN employees e ON s.employee_id = e.id 
                                    JOIN departments d ON e.department_id = d.id
)
SELECT
    full_name, 
    employee_code,
    department_name, 
    total_received_salary,
    COALESCE(leave_count, 0) as leave_count, 
    ROUND((total_received_salary - avg_salary_dept) * 100.00 / avg_salary_dept, 2) as pct_above_dept_avg
FROM calc_salary_per_dept sd LEFT JOIN count_accept_leave l ON sd.id = l.employee_id
ORDER BY total_received_salary DESC, employee_code ASC
LIMIT 10
