-- Xom Data · Suppliers that deliver late frequently
-- Problem: https://xomdata.com/practice/medium-having-162
-- Solved: 2026-07-17

WITH calc_delivery AS(
    SELECT 
        s.supplier_name,
        s.material_type,
        COUNT(*) AS purchase_count, 
        SUM(p.total_value) AS total_purchase_value,
        ROUND(AVG(JULIANDAY(p.actual_receipt) - JULIANDAY(p.expected_receipt)), 2) AS avg_late_days,
        ROUND(SUM(
            CASE 
                WHEN JULIANDAY(actual_receipt) <= JULIANDAY(expected_receipt) THEN 1
                ELSE 0
            END
            ) * 100.00 / COUNT(*), 2) AS on_time_rate
    FROM suppliers s JOIN purchase_orders p ON s.id = p.supplier_id
    GROUP BY s.supplier_name, s.material_type
)
SELECT 
    supplier_name, 
    material_type,
    purchase_count,
    total_purchase_value,
    avg_late_days,
    on_time_rate,
    RANK() OVER (ORDER BY avg_late_days DESC) AS late_rank,
    NTILE(4) OVER (ORDER BY avg_late_days DESC) AS risk_tier
FROM calc_delivery
WHERE purchase_count >= 3 AND avg_late_days > 0
ORDER BY late_rank ASC, supplier_name ASC
