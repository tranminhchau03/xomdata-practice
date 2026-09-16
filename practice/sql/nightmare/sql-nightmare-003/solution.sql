-- Xom Data · 3-month consecutive disbursement rate by department
-- Problem: https://xomdata.com/practice/sql-nightmare-003
-- Solved: 2026-09-16

WITH roll3m as(
    SELECT 
        dept, 
        month,
        SUM(budget) OVER (PARTITION BY dept 
                          ORDER BY month
                          ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as roll3_budget,
        SUM(actual) OVER (PARTITION BY dept 
                          ORDER BY month
                          ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as roll3_actual    
    FROM budgets
    ORDER BY dept, month
)
SELECT 
    dept, 
    month, 
    roll3_budget, 
    roll3_actual, 
    ROUND(roll3_actual * 100.0 / roll3_budget, 2) as utilization_pct
FROM roll3m
ORDER BY dept, month
