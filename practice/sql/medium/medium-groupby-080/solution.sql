-- Xom Data · Monthly income and expense report
-- Problem: https://xomdata.com/practice/medium-groupby-080
-- Solved: 2026-07-19

WITH revenue_info AS(
    SELECT 
        strftime('%Y-%m', transaction_date) as month, 
        SUM(
            CASE 
                WHEN type = 'Thu' THEN amount
                ELSE 0
            END
        ) as total_income,
        SUM(
            CASE 
                WHEN type = 'Chi' THEN amount
                ELSE 0
            END
        ) as total_expense
    FROM transactions 
    GROUP BY month
),
profit AS(
    SELECT 
        month, 
        total_income,
        total_expense,
        total_income - total_expense AS balance
    FROM revenue_info
)
SELECT 
    month, 
    total_income, 
    total_expense, 
    balance, 
    SUM(balance
        -- CASE
        --     WHEN balance > 0 THEN balance
        --     ELSE 0
        -- END
    ) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_balance,
    CASE
        WHEN total_income > total_expense THEN 'Surplus'
        WHEN total_income < total_expense THEN 'Deficit'
        ELSE 'Balanced'
    END AS status
FROM profit
ORDER BY month
