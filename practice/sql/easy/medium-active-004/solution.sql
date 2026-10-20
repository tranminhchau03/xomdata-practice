-- Xom Data · Who stayed loyal all quarter
-- Problem: https://xomdata.com/practice/medium-active-004
-- Solved: 2026-10-20

SELECT 
    customer_id
FROM orders
WHERE TO_CHAR(order_date::DATE, 'YYYY-MM') In ('2024-01', '2024-02', '2024-03')
GROUP BY customer_id
HAVING COUNT(DISTINCT TO_CHAR(order_date::DATE, 'YYYY-MM')) = 3
