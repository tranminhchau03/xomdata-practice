-- Xom Data · Three-day rolling total per store
-- Problem: https://xomdata.com/practice/medium-rolling-002
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
select 
    store, 
    sale_date, 
    units_sold, 
    SUM(units_sold) OVER (PARTITION BY store oRDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as sum_3d
from daily_sales
order by store asc, sale_date asc
