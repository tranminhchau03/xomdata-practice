-- Xom Data · Countries our students come from
-- Problem: https://xomdata.com/practice/easy-distinct-008
-- Solved: 2026-10-14

-- Write your SQL here
SELECT COUNT(DISTINCT country) as num_countries
FROM students
