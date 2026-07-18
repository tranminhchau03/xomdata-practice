-- Xom Data · Highest and lowest score in the cohort
-- Problem: https://xomdata.com/practice/easy-minmax-001
-- Solved: 2026-07-18

SELECT max(avg_score) as max_score, MIN(avg_score) AS min_score
FROM students
WHERE avg_score IS NOT NULL
