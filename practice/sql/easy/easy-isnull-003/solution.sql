-- Xom Data · Records with a contact number
-- Problem: https://xomdata.com/practice/easy-isnull-003
-- Solved: 2026-09-29

-- Write your SQL here
SELECT 
    patient_name, 
    phone
FROM patients
WHERE phone IS NOT NULL
