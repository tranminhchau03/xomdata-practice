-- Xom Data · Each customer's latest contact number
-- Problem: https://xomdata.com/practice/medium-dedup-001
-- Solved: 2026-08-17

-- Viết SQL của bạn ở đây
SELECT 
    customer_name, 
    phone,
    MAX(updated_date) as updated_date
FROM contact_updates
WHERE updated_date in (SELECT MAX(updated_date)
                       FROM contact_updates
                       GROUP BY customer_name)
GROUP BY customer_name, phone
ORDER BY customer_name
