-- Xom Data · Display names on profile pages
-- Problem: https://xomdata.com/practice/easy-coalesce-001
-- Solved: 2026-10-14

-- Write your SQL here
SELECT 
    real_name,
    nickname,
    CASE WHEN nickname IS NOT NULL then nickname
         ELSE real_name
    END as display_name
FROM profiles
