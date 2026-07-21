-- Xom Data · Consultation revenue by doctor
-- Problem: https://xomdata.com/practice/medium-join-141
-- Solved: 2026-07-21

WITH 
revenue as(
    SELECT 
        f.id as faculty_id,
        f.faculty_name,
        d.full_name as doctor_name,
        COUNT(m.id) as visit_count,
        ROUND(AVG(visit_fee), 0) as avg_exam_fee,
        SUM(visit_fee) as total_exam_fee
    FROM faculties f JOIN doctors d ON f.id = d.faculty_id
                    JOIN medical_visits m ON m.doctor_id = d.id
    GROUP BY f.faculty_name, d.full_name, f.id
)
SELECT 
    faculty_name,
    doctor_name,
    visit_count,
    avg_exam_fee,
    total_exam_fee,
    RANK() OVER (ORDER BY total_exam_fee DESC) as overall_rank,
    DENSE_RANK() OVER (PARTITION BY faculty_id ORDER BY total_exam_fee DESC) as rank_in_faculty
FROM revenue
ORDER BY total_exam_fee DESC, doctor_name ASC
LIMIT 15
