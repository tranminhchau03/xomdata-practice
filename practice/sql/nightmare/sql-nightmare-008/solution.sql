-- Xom Data · Score customers by RFM
-- Problem: https://xomdata.com/practice/sql-nightmare-008
-- Solved: 2026-09-13

WITH find_end_record_date as(
    SELECT
        customer_id,
        JULIANDAY(DATE(MAX(txn_date) OVER(), '+1 day')) -
        JULIANDAY(txn_date) as recency, 
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY txn_date desc) as rn,
        COUNT(*) OVER (PARTITION BY customer_id) as frequency, 
        SUM(amount) OVER (PARTITION BY customer_id) as monetary
    FROM transactions 
),
rfm_score as(
    SELECT 
        customer_id, 
        recency, 
        frequency, 
        monetary,
        NTILE(5) OVER (ORDER BY recency desc) as r_score,
        NTILE(5) OVER (ORDER BY frequency asc) as f_score, 
        NTILE(5) OVER (ORDER BY monetary asc) as m_score
    FROM find_end_record_date
    WHERE rn = 1
)
SELECT 
    customer_id, 
    recency, 
    frequency, 
    monetary, 
    r_score, 
    f_score, 
    m_score, 
    ROUND(r_score * 0.4 + f_score * 0.3 + m_score * 0.3, 2) as rfm_score
FROM rfm_score
ORDER BY rfm_score desc, customer_id asc
