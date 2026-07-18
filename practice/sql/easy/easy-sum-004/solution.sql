-- Xom Data · Total shipping fees collected
-- Problem: https://xomdata.com/practice/easy-sum-004
-- Solved: 2026-07-18

SELECT SUM(shipping_fee) as total_fee
FROM shipments
