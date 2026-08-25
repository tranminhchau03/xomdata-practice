-- Xom Data · Who has spent past the five-million mark
-- Problem: https://xomdata.com/practice/medium-monetary-001
-- Solved: 2026-08-25

SELECT 
    customer_id, 
    sum(amount) as total_spent, 
    case 
        when sum(amount) >= 5000000 then 'VIP'
        ELse 'Standard'
    END as segment
FROM orders 
GROUP BY customer_id
