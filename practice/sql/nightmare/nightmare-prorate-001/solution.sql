-- Xom Data · Allocate contract revenue across years
-- Problem: https://xomdata.com/practice/nightmare-prorate-001
-- Solved: 2026-10-15

WITH generate_year as(
    SELECT 
        id, 
        amount, 
        start_date::DATE,
        end_date::DATE,
        generate_series(
            DATE_TRUNC('year', start_date::DATE) + INTERVAL '1 year - 1 day',
            DATE_TRUNC('year', end_date::DATE) + INTERVAL '1 year - 1 day',
            INTERVAL '1 year'
        )::DATE as eoy_id
    FROM contracts
    GROUP BY id
)
SELECT 
    id as contract_id,
    EXTRACT(YEAR FROM eoy_id)::INT as year,
    ROUND(
        amount * 1.0
        * ((LEAST(end_date, eoy_id)) - GREATEST(start_date, (DATE_TRUNC('year', eoy_id))::DATE) +1)
        / (end_date - start_date + 1)
    , 2) as prorated_amount
FROM generate_year
ORDER BY id, year
