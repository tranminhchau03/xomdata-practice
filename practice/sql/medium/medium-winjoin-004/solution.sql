-- Xom Data · The same customer's previous order
-- Problem: https://xomdata.com/practice/medium-winjoin-004
-- Solved: 2026-10-08

-- Write your SQL here
SELECT 
    member_name,
    purchase_date,
    amount,
    LAG(amount) OVER (PARTITION BY p.member_id ORDER BY purchase_date asc) as prev_amount
FROM members m JOIN purchases p ON m.id = p.member_id
ORDER BY member_name, purchase_date
