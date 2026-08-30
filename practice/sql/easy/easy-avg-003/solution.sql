-- Xom Data · Average score in Math
-- Problem: https://xomdata.com/practice/easy-avg-003
-- Solved: 2026-08-30

-- Viết SQL của bạn ở đây
SELECT avg(score) as avg_score
FROM exam_scores
WHERE subject = 'Math'
