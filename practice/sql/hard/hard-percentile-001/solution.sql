-- Xom Data · Median and percentile salary by department
-- Problem: https://xomdata.com/practice/hard-percentile-001
-- Solved: 2026-10-13

WITH percent_ranked as(
    SELECT
        id, 
        department, 
        salary,
        PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary asc) as percent_rk
    FROM employees
), 
distance_abs_p as(
    SELECT 
        department, 
        salary,
        abs(percent_rk - 0.25) as p25,
        abs(percent_rk - 0.5) as p50,
        abs(percent_rk - 0.75) as p75
    FROM percent_ranked
),
distance_rn as(
    SELECT
        department,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department
                        ORDER BY p25 asc, salary asc) as rn_p25,
        ROW_NUMBER() OVER (PARTITION BY department
                        ORDER BY p50 asc, salary asc) as rn_p50,
        ROW_NUMBER() OVER (PARTITION BY department
                        ORDER BY p75 asc, salary asc) as rn_p75
    FROM distance_abs_p
)
SELECT 
    department, 
    MAX(CASE WHEN rn_p25 = 1 THEN salary END) as p25,
    MAX(CASE WHEN rn_p50 = 1 THEN salary END) as p50,
    MAX(CASE WHEN rn_p75 = 1 THEN salary END) as p75
FROM distance_rn
GROUP BY department
ORDER BY department
