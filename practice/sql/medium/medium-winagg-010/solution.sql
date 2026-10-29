-- Xom Data · Regional payroll with shares
-- Problem: https://xomdata.com/practice/medium-winagg-010
-- Solved: 2026-10-29

-- Write your SQL here
SELECT
    region,
    staff_name,
    salary,
    SUM(salary) OVER (PARTITION BY region) as region_total,
    ROUND(salary * 100.0 / SUM(salary) OVER (PARTITION BY region), 2) as pct_of_region
FROM payroll
ORDER BY region, salary desc, staff_name
