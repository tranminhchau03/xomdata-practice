-- Xom Data · Revenue split by new vs returning customers
-- Problem: https://xomdata.com/practice/sql-nightmare-006
-- Solved: 2026-10-07

WITH RECURSIVE 
to_dates as(
    SELECT 
        user_id, 
        TO_DATE(month, 'YYYY-MM') as month,
        SUM(revenue) as revenue
    FROM sales
    GROUP BY user_id, month
), 
scope as(
    SELECT  
        MIN(month) as started,
        MAX(month) as ended
    FROM to_dates
),
generate_months as(
    SELECT 
        started as list
    FROM scope

    UNION ALL 

    SELECT
        (list + INTERVAL '1 month')::DATE
    FROM generate_months m CROSS JOIN scope s
    WHERE list < ended
),
user_list as(
    SELECT DISTINCT user_id
    FROM to_dates
),
user_month as(
    SELECT  
        user_id, 
        list, 
        EXTRACT(YEAR FROM list) * 12 + EXTRACT(MONTH FROM list) as midx
    FROM user_list CROSS JOIN generate_months
), 
revenues as(
    SELECT 
        grp.user_id, 
        grp.list,
        midx,
        COALESCE(revenue,0) as revenue
    FROM user_month grp 
    LEFT JOIN to_dates s ON grp.user_id = s.user_id 
                        AND grp.list = s.month
),
prev_months as(
    SELECT 
        user_id, 
        list, 
        midx,
        revenue, 
        LAG(revenue) OVER (PARTITION BY user_id ORDER BY list asc) as prev_revenue,
        LAG(midx) OVER (PARTITION BY user_id ORDER BY list asc) as prev_month,
        MIN(
            CASE WHEN revenue > 0 THEN midx END
        ) OVER (PARTITION BY user_id) as first_month
    FROM revenues
),
flag as(
    SELECT 
        -- user_id,
        -- list as month,
        -- revenue,
        *,
        CASE WHEN midx = first_month THEN revenue ELSE 0 END as new,
        CASE WHEN midx - prev_month >= 1 THEN revenue ELSE 0 END as returned,
        CASE WHEN (midx - prev_month = 1) AND revenue = 0 THEN prev_revenue ELSE 0 END as churned

        -- CASE WHEN (revenue IS NOT NULL AND prev_revenue IS NOT NULL) THEN revenue
        --      ELSE 0
        -- END as returned
        -- CASE WHEN list - prev >= 1 THEN 1 ELSE 0 END as returned 
        -- CASE WHEN prev IS NOT NULL AND revenue IS NOT NULL 
    FROM prev_months
    -- GROUP BY month
)
SELECT --* from flag
    to_char(list, 'YYYY-MM') as month,
    SUM(
        CASE WHEN new > 0 THEN new ELSE 0 END
    ) as new_revenue,
    SUM(
        CASE WHEN new <> returned THEN returned ELSE 0 END
    ) as returning_revenue,
    SUM(CASE WHEN churned > 0 THEN churned ELSE 0 END) as churned_revenue
from flag 
-- FROM generate_months LEFT JOIN to_dates ON list = month
GROUP BY month
ORDER BY month
--     user_id,
--     list, 
--     revenue
-- FROM generate_months LEFT JOIN new_sales on list = month--list = month
-- GROUP BY user_id




-- WITH grp_month as(
--     SELECT DISTINCT
--         user_id, 
--         TO_DATE(month, 'YYYY-MM') as month, 
--         SUM(revenue) as revenue
--     FROM sales
--     GROUP BY user_id, month
-- ),
-- m_int as(
--     SELECT 
--         user_id,
--         month, 
--         EXTRACT(YEAR FROM month) * 12 +
--         EXTRACT(MONTH FROM month) as midx,
--         revenue        
--     FROM grp_month
--     -- GROUP BY month
--     ORDER BY user_id
-- ), 
-- prev_months as(
--     SELECT
--         user_id, 
--         month, 
--         midx,
--         revenue,
--         LAG(midx) OVER (PARTITION BY user_id ORDER BY midx asc) as prev, 
--         LEAD(midx) OVER (PARTITION BY user_id ORDER BY midx asc) as next
--     FROM m_int
-- ),
-- flag as(
--     SELECT
--         user_id,
--         month,
--         revenue,
--         CASE WHEN prev IS NULL THEN 1 ELSE 0 END as new, 
--         CASE WHEN midx - prev >= 1 THEN 1 ELSE 0 END as returned,
--         CASE WHEN midx - prev > 1 THEN 1 ELSE 0 END as churned
--     from prev_months
-- )
-- SELECT 
--     TO_CHAR(month, 'YYYY-MM') as month, 
--     SUM(
--         CASE 
--             WHEN new = 1 THEN revenue
--             ELSE 0
--         END
--     ) as new_revenue,
--     SUM(
--         CASE 
--             WHEN returned >= 1 THEN revenue 
--             ELSE 0 
--         END 
--     ) as returning_revenue,
--     SUM(
--         CASE 
--             WHEN churned = 1 THEN revenue
--             ELSE 0 
--         END 
--     ) as churned_revenue
-- FROM flag
-- GROUP BY month
-- ORDER BY month


-- -- SELECT
-- --     user_id, 
-- --     month, floor((month - prev) / 30),
-- --     CASE WHEN prev IS NULL THEN 1 ELSE 0 END as new,
-- --     case when month - prev = 1 then 1 else 0 end as returned
-- -- FROM prev_months
-- -- SELECT --from prev_months
-- --     to_char(month, 'YYYY-MM') as month, 
-- --     SUM(
-- --         CASE 
-- --             WHEN prev IS NULL THEN revenue 
-- --             ELSE 0 
-- --         END
-- --     ) as new_revenue,
-- --     sum(
-- --         CASE 
-- --             WHEN month >= prev + interval '1 month' THEN revenue
-- --             ELSE 0
-- --         END
-- --     ) as returning_revenue,
-- --     SUM(
-- --         CASE 
-- --             WHEN churned = 1 THEN LAG(revenue) OVER (ORDER BY month)
-- --             ELSE 0
-- --         END
-- --     ) as churned
-- -- FROM prev_months
-- -- GROUP BY month
-- -- ORDER BY month
-- -- WITH cus_info as(
-- --     SELECT DISTINCT
-- --         user_id, 
-- --         month, 
-- --         EXTRACT(YEAR FROM (month || '-01')::date) * 12+
-- --         EXTRACT(MONTH FROM (month || '-01')::date) as midx,
-- --         revenue
-- --     FROM sales
-- --     ORDER BY user_id, month
-- -- ), 
-- -- prev_months as(
-- --     SELECT  
-- --         user_id, 
-- --         month, 
-- --         midx, 
-- --         LAG(midx) OVER (PARTITION BY user_id ORDER BY midx asc) as prev,
-- --         revenue
-- --     FROM cus_info
-- -- )
-- -- SELECT *, case when midx - (prev) > 1 then lag(revenue) over(PARTITION BY user_id order by month) end as jjj from prev_months order by month
-- --     month, 
-- --     SUM(CASE WHEN prev IS NULL THEN revenue ELSE 0 END) as new_revenue, 
-- --     SUM(CASE WHEN prev IS NOT NULL THEN revenue ELSE 0 END) as returning_revenue, 
-- --     SUM(CASE WHEN midx - prev > 1 THEN LAG(revenue) OVER (PARTITION BY user_id ORDER BY month) ELSE 0 END) as churned_revenue
-- -- FROM prev_months
-- -- GROUP BY month
-- -- ORDER BY month
-- -- SELECT  (month || '-01')::date - 
-- --         ((prev || '-01')::date + INTERVAL '1 month')::date from cus_info
-- --     -- user_id, 
-- --     month,
-- --     SUM(case when prev is null then revenue else 0 end) as new_revenue, 
-- --     SUM(case when prev IS NOT NULL then revenue else 0 end) as returning_revenue, 
-- --     SUM(case when (month || '-01')::date - ((prev || '-01')::date + INTERVAL '1 month', 'YYYY-MM')::date = 1 then revenue else 0 end) as churned
-- -- FROM cus_info
-- -- GROUP BY month
-- -- ORDER BY month
-- -- WITH cus_month as(
-- --     SELECT 
-- --         user_id, 
-- --         month, 
-- --         revenue,
-- --         LAG(month) OVER (PARTITION BY user_id ORDER BY month asc) as prev
-- --     FROM sales
-- -- ),
-- -- flags as(
-- --     SELECT 
-- --         user_id,
-- --         month,
-- --         case when month = TO_CHAR((prev|| '-01')::date + INTERVAL '1 month', 'YYYY-MM') then 0
-- --              when prev IS NULL THEN 1
-- --              ELSE 1 
-- --         END as flag_new,
-- --         -- revenue,
-- --         SUM(case when prev IS NULL then revenue else 0 end) OVER (PARTITION BY month)  as new_revenue
-- --         -- SUM(case when month = TO_CHAR((prev|| '-01')::date + INTERVAL '1 month', 'YYYY-MM') then revenue else 0 end) as returning_revenue
-- --     FROM cus_month
-- --     -- GROUP BY month
-- --     ORDER BY user_id, month
-- -- )
-- -- SELECT DISTINCT
-- --     -- sum(flag_new) OVER ( ORDER BY month),
-- --     month,
-- --     new_revenue
-- --     -- case when 
-- -- FROm flags
-- -- GROUP BY month, flag_new, new_revenue
-- -- ORDER BY month
