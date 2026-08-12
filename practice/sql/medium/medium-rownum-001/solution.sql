-- Xom Data · Interview call numbers
-- Problem: https://xomdata.com/practice/medium-rownum-001
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
SELECT 
    row_number() OVER (order by score desc, candidate_name asc) as call_no, 
    candidate_name,
    score
from candidates
order by call_no asc
