-- Xom Data · National rank and province rank
-- Problem: https://xomdata.com/practice/medium-rank-004
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
SELECT 
    student_name, 
    province, 
    exam_score, 
    RANK() OVER (ORDER BY exam_score desc) as national_rank, 
    RANK() OVER (PARTITION BY province ORDER BY exam_score desc) as province_rank
FROM students
ORDER BY national_rank asc, student_name asc
