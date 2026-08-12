-- Xom Data · Revenue rank of each category
-- Problem: https://xomdata.com/practice/medium-rank-003
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
WITH calc_revenue as (
    SELECT
        category, 
        SUM(amount) as total_revenue
    FROM sales
    GROUP BY category
)
SELECT distinct
    category, 
    total_revenue, 
    RANK() OVER (ORDER BY total_revenue desc) as revenue_rank
FROM calc_revenue
ORDER BY revenue_rank asc, category asc
