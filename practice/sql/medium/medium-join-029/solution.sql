-- Xom Data · Instructor teaching load
-- Problem: https://xomdata.com/practice/medium-join-029
-- Solved: 2026-07-19

WITH count_subjects_taught AS(
    SELECT 
        l.full_name,
        l.academic_degree,
        COUNT(s.id) AS subjects_taught
    FROM lecturers l JOIN subjects s ON l.id = s.lecturer_id
    GROUP BY l.full_name, l.academic_degree   
)
SELECT 
    full_name, 
    academic_degree,
    subjects_taught,
    RANK() OVER (ORDER BY subjects_taught DESC) AS workload_rank, 
    SUM(subjects_taught) OVER (ORDER BY subjects_taught DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_subjects
FROM count_subjects_taught 
ORDER BY workload_rank ASC, full_name ASC
