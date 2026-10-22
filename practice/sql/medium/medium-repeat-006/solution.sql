-- Xom Data · Diligent customers across all four quarters
-- Problem: https://xomdata.com/practice/medium-repeat-006
-- Solved: 2026-10-22

SELECT 
    customer_id,
    COUNT(order_id) AS orders_2024
FROM orders
WHERE TO_CHAR(order_date::DATE, 'YYYY') = '2024'
GROUP BY customer_id
HAVING COUNT(DISTINCT DATE_PART('quarter', order_date::DATE)) = 4;
