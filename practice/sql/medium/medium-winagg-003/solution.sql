-- Xom Data · Distance from the class average
-- Problem: https://xomdata.com/practice/medium-winagg-003
-- Solved: 2026-10-08

-- Write your SQL here
WITH calc_avg as(
    SELECT 
        class_name, 
        AVG(score) as avg_score
    FROM scores
    GROUP BY class_name
)
SELECT 
    class_name,
    student_name, 
    score, 
    ROUND(score - avg_score, 2) as diff_from_avg
FROM scores LEFT JOIN calc_avg USING(class_name)
ORDER BY class_name, student_name
