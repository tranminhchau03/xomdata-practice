-- Xom Data · Which channel produces loyal customers
-- Problem: https://xomdata.com/practice/medium-repeat-005
-- Solved: 2026-10-21

WITH count_order_by_cus as(
    SELECT 
        customer_id,
        COUNT(order_date) as total_orders
    FROM orders 
    GROUP BY customer_id
    HAVING COUNT(order_date) >= 3 
), 
count_loyals as(
    SELECT 
        channel,
        COUNT(total_orders) as loyal_customers
    FROM count_order_by_cus RIGHT JOIN customers USING(customer_id)
    GROUP BY channel
),
merged as(
    SELECT DISTINCT
        channel, 
        COUNT(customer_id) OVER (PARTITION BY channel) as customers, 
        loyal_customers
    FROM customers JOIN count_loyals USING(channel)
)
SELECT
    channel, 
    customers, 
    loyal_customers, 
    ROUND(loyal_customers * 100.0 / customers, 2) as loyal_rate_pct
FROM merged
ORDER BY loyal_rate_pct desc, channel asc
