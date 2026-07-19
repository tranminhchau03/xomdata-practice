-- Xom Data · Top 2 salespeople by sales each month
-- Problem: https://xomdata.com/practice/expert-final-multi-007
-- Solved: 2026-07-19

WITH revenue_info AS(
    SELECT 
        s.month, 
        s.employee_id,
        e.full_name,
        SUM(revenue) AS total_sales
    FROM employees e JOIN sales s ON e.id = s.employee_id
    GROUP BY s.month, s.employee_id, e.full_name
    ORDER BY s.month ASC
),
ranking AS (
    SELECT 
        month, 
        DENSE_RANK() OVER (PARTITION BY month ORDER BY total_sales DESC) AS hang,
        employee_id,
        full_name,
        total_sales
    FROM revenue_info
    ORDER BY month ASC, hang ASC, employee_id ASC
)
SELECT 
    month, 
    hang,
    employee_id, 
    full_name,
    total_sales
FROM ranking
WHERE hang BETWEEN 1 AND 2
