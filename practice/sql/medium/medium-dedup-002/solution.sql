-- Xom Data · The current price of each product
-- Problem: https://xomdata.com/practice/medium-dedup-002
-- Solved: 2026-08-17

-- Viết SQL của bạn ở đây
SELECT
    product_name, 
    price, 
    MAX(effective_date) as effective_date
FROM price_history
WHERE effective_date in (SELECT MAX(effective_date)
                         FROM price_history
                         GROUP BY product_name)
GROUP BY product_name, price 
ORDER BY product_name
