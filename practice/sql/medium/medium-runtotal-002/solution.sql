-- Xom Data · Each customer's cumulative spending
-- Problem: https://xomdata.com/practice/medium-runtotal-002
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
SELECT 
    customer_name, 
    month, 
    spend, 
    sum(spend) OVER (PARTITION by customer_name ORDER BY month asc) as cumulative_spend
FROM wallet_monthly
ORDER BY customer_name, month
