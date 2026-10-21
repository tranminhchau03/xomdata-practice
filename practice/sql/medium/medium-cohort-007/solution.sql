-- Xom Data · Who Joined During Promo Season
-- Problem: https://xomdata.com/practice/medium-cohort-007
-- Solved: 2026-10-21

WITH first_orders as(
    SELECT
        customer_id, 
        MIN(order_date) as first_order_date
    FROM orders
    GROUP BY customer_id
)
SELECT 
    DISTINCT
    f.customer_id, 
    f.first_order_date, 
    COUNT(o.order_date) as campaign_orders
FROM first_orders f JOIN orders o ON f.customer_id = o.customer_id
WHERE DATE_PART('month', o.order_date::DATE) = 3 
  AND DATE_PART('month', f.first_order_date::DATE) = 3
GROUP BY f.customer_id, f.first_order_date
