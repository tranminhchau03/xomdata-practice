-- Xom Data · Accounts still missing a tax code
-- Problem: https://xomdata.com/practice/easy-count-011
-- Solved: 2026-10-14

-- Write your SQL here
SELECT COUNT(CASE WHEN tax_code IS NULL THEN 1 END) as missing_tax_code
FROM accounts
