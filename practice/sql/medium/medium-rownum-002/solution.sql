-- Xom Data · Intake sequence per warehouse
-- Problem: https://xomdata.com/practice/medium-rownum-002
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
SELECT 
    warehouse, 
    ROW_NUMBER() OVER (PARTITION BY warehouse ORDER BY entry_date asc, product asc) as entry_no, 
    product, 
    entry_date
FROM stock_entries
ORDER BY warehouse asc, entry_no asc
