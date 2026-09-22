-- Xom Data · Sizing parcels by weight
-- Problem: https://xomdata.com/practice/easy-case-002
-- Solved: 2026-09-22

-- Write your SQL here
SELECT
 parcel_code,
 weight_kg,
 CASE WHEN weight_kg < 5 then 'Small'
      WHEN weight_kg BETWEEN 5 AND 20 THEN 'Medium'
      else 'Large'
 END as size_label
FROM parcels
