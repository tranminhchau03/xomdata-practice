-- Xom Data · Sales rank within each region
-- Problem: https://xomdata.com/practice/medium-rank-002
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
SELECT 
    region, 
    rank() OVER (PARTITION BY region ORDER BY sales_amount desc)as region_rank, 
    rep_name, 
    sales_amount
FROM reps
ORDER BY region asc, region_rank asc, rep_name asc
