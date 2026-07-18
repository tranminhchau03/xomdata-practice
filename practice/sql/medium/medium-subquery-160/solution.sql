-- Xom Data · Low-activity users
-- Problem: https://xomdata.com/practice/medium-subquery-160
-- Solved: 2026-07-18

WITH calc_value AS(
    SELECT 
        u.user_name, 
        COUNT(o.id) AS order_count,
        SUM(o.value) AS total_value,
        AVG(o.value) AS avg_order_value
    FROM users u LEFT JOIN orders o ON u.id = o.user_id
    GROUP BY u.user_name
),
---- important 
sum_avg_value AS(
    SELECT *,
        AVG(total_value) OVER() as avg_total_value
    FROM calc_value
)
SELECT
    user_name,
    order_count, 
    total_value,
    avg_order_value,
    CASE
        WHEN order_count = 0 THEN 'Inactive'
        WHEN total_value <= avg_total_value THEN 'Low'
        ELSE 'Normal'
    END AS tier,
    RANK() OVER (ORDER BY total_value ASC) AS activity_rank,
    ROUND(PERCENT_RANK() OVER (ORDER BY total_value ASC) * 100.00, 2) AS pct_above_peers
FROM sum_avg_value
WHERE total_value < avg_total_value or order_count = 0
ORDER BY activity_rank ASC, user_name ASC
