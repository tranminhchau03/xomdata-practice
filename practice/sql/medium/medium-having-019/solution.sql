-- Xom Data · High-rated sellers with many orders
-- Problem: https://xomdata.com/practice/medium-having-019
-- Solved: 2026-07-17

WITH count_order AS(
    SELECT 
        s.store_name, 
        s.reputation_score, 
        count(o.id) AS order_count
    FROM sellers s JOIN orders o ON s.id = o.seller_id
    WHERE s.reputation_score >= 4.5 
    GROUP BY s.store_name
    ORDER BY s.store_name
)
SELECT 
    store_name,
    reputation_score,
    order_count, 
    DENSE_RANK() OVER (ORDER BY order_count DESC) AS rank_by_orders,
    SUM(order_count) OVER 
                (ORDER BY order_count DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                AS cumulative_orders
FROM count_order
WHERE order_count >= 3
ORDER BY rank_by_orders ASC, store_name ASC
