-- Xom Data · Balance after each transaction
-- Problem: https://xomdata.com/practice/medium-runtotal-003
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
SELECT 
    txn_date, 
    amount,
    sum(amount) over(order by txn_date asc) as balance
FROM transactions
order by txn_date
