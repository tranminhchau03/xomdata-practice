-- Xom Data · Students above the subject average
-- Problem: https://xomdata.com/practice/medium-subquery-028
-- Solved: 2026-07-21

WITH avg_subjects as(
    SELECT  
        st.full_name, 
        sb.subject_name,
        g.final_score,
        ROUND(avg(final_score) OVER (PARTITION BY subject_id), 2) as subject_avg
    FROM grades g JOIN students st ON g.student_id = st.id
                JOIN subjects sb ON g.subject_id = sb.id
    GROUP BY st.full_name, sb.subject_name, g.final_score
) 
SELECT 
    full_name,
    subject_name,
    final_score,
    subject_avg,
    ROUND((final_score - subject_avg), 2) as diff_from_avg
FROM avg_subjects
WHERE final_score > subject_avg
ORDER BY diff_from_avg DESC, subject_name, full_name
