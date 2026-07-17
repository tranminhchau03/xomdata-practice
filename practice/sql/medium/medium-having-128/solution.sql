-- Xom Data · Employees averaging over 5 overtime hours
-- Problem: https://xomdata.com/practice/medium-having-128
-- Solved: 2026-07-17

WITH avg_working AS(
    SELECT 
        e.full_name,
        e.employee_code,
        AVG(a.work_days) AS avg_work_days,
        AVG(a.overtime_hours) AS avg_overtime_hours,
        AVG(p.net_salary) AS avg_salary
    FROM employees e JOIN attendance a ON e.id = a.employee_id
                     JOIN payroll p ON e.id = p.employee_id 
    GROUP BY e.full_name, e.employee_code
    ORDER BY e.employee_code ASC
),
OT_intensity AS(
    select 
        *, 
        ROUND( avg_overtime_hours / avg_work_days, 4) AS overtime_intensity
    FROM avg_working
)
select 
    *,  
    RANK() OVER (ORDER BY overtime_intensity DESC) AS intensity_rank,
    NTILE(4) OVER (ORDER BY overtime_intensity DESC) AS workload_quartile
FROM OT_intensity
WHERE avg_overtime_hours > 5 AND avg_work_days >= 18
ORDER BY intensity_rank ASC, employee_code ASC
