-- Xom Data · Patients without a health-insurance declaration
-- Problem: https://xomdata.com/practice/easy-isnull-002
-- Solved: 2026-07-16

SELECT full_name
FROM patients 
WHERE health_insurance IS NULL
ORDER BY full_name ASC
