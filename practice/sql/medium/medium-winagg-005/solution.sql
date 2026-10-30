-- Xom Data · Ward headcount next to each nurse
-- Problem: https://xomdata.com/practice/medium-winagg-005
-- Solved: 2026-10-30

-- Write your SQL here
SELECT
    ward,
    nurse_name, 
    COUNT(nurse_name) OVER (PARTITION BY ward) as team_size
FROM roster
ORDER BY ward, nurse_name
