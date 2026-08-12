-- Xom Data · Visit number within each day
-- Problem: https://xomdata.com/practice/medium-rownum-003
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
SELECT 
    checkin_date, 
    ROW_NUMBER() OVER (PARTITION BY checkin_date ORDER BY checkin_time asc, member_name asc) as visit_no, 
    member_name, 
    checkin_time
FROM checkins
ORDER BY checkin_date, visit_no
