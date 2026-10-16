-- Xom Data · Which channel brings in the most durable customers
-- Problem: https://xomdata.com/practice/hard-retention-009
-- Solved: 2026-10-16

WITH cus_month as(
    SELECT DISTINCT
        c.customer_id, 
        c.channel,
        DATE_TRUNC('month', to_date(order_date, 'YYYY-MM-DD')) as order_date
    FROM customers c JOIN orders o ON c.customer_id = o.customer_id
), 
prev_orders as(
    SELECT 
        customer_id, 
        channel, 
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id, channel ORDER BY order_date) as prev
    FROM cus_month
),
customer_state as(
    SELECT  
        channel,
        COUNT(DISTINCT customer_id) as cohort_customers, 
        COUNT(CASE WHEN order_date = prev + INTERVAL '1 month' THEN 1 END) as retained
    FROM prev_orders
    GROUP BY channel
)
SELECT
    channel, 
    cohort_customers, 
    retained,
    ROUND(retained * 100.0 / cohort_customers, 2) as retention_pct
FROM customer_state
ORDER BY retention_pct desc
