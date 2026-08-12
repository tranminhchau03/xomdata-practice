-- Xom Data · Sales rankings with department names
-- Problem: https://xomdata.com/practice/medium-winjoin-001
-- Solved: 2026-08-12

-- Viết SQL của bạn ở đây
SELECT 
    d.dept_name, 
    RANK() OVER (PARTITION BY d.id ORDER BY sales_amount desc) as dept_rank, 
    staff_name, 
    sales_amount
FROM departments d JOIN staff s On d.id = s.dept_id
ORDER BY d.dept_name asc, dept_rank asc, staff_name asc
