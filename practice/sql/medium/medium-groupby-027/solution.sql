-- Xom Data · Average score per subject
-- Problem: https://xomdata.com/practice/medium-groupby-027
-- Solved: 2026-07-17

WITH score AS(
    SELECT 
        s.subject_name, 
        s.credits, 
        COUNT(g.id) AS student_count, 
        ROUND(AVG(final_score), 2) AS avg_score,
        ROUND(
            SUM(
                CASE
                    WHEN final_score >= 5 THEN 1
                    ELSE 0
                END) * 100.00 / COUNT(*), 2) AS pass_rate -- P.S CASE SCORE IS NULL STILL COUNT
    FROM subjects s JOIN grades g ON s.id = g.subject_id
    GROUP BY s.subject_name, s.credits
    ORDER BY s.subject_name ASC
)
SELECT 
    subject_name,
    credits,
    student_count, 
    avg_score, 
    pass_rate, 
    RANK() OVER (ORDER BY avg_score DESC) AS rank_by_avg,
    NTILE(4) OVER(ORDER BY avg_score DESC) AS difficulty_quartile
FROM score
ORDER BY rank_by_avg ASC, subject_name ASC
