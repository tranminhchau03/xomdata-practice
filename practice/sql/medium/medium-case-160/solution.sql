-- Xom Data · Delivery performance by size class
-- Problem: https://xomdata.com/practice/medium-case-160
-- Solved: 2026-07-16

WITH count_ship AS(
    SELECT 
        t.vehicle_type, 
        t.capacity_tons, 
        COUNT(*) AS shipment_count,
        CASE 
            WHEN t.capacity_tons >= 10 THEN 'Large Truck'
            WHEN t.capacity_tons >= 5 THEN 'Medium Truck'
            ELSE 'Small Truck'
        END AS size_class,
        SUM(
            CASE 
                WHEN d.results = 'success' THEN 1
                ELSE 0
            END
        ) AS delivered
    FROM trucks t 
        JOIN shipments sh ON t.id = sh.truck_id
        JOIN deliveries d ON sh.id = d.shipment_id
    GROUP BY t.vehicle_type, t.capacity_tons
),
rating_delivery AS(
    SELECT 
        vehicle_type, 
        capacity_tons, 
        shipment_count,
        size_class,
        delivered, 
        ROUND(((delivered * 100.00)/ shipment_count), 2) AS delivery_rate -- p/s chia nguyen = 0
    FROM count_ship
    GROUP BY vehicle_type
)
SELECT 
    vehicle_type, 
    capacity_tons, 
    shipment_count,
    size_class,
    delivered, 
    delivery_rate,
    RANK() OVER (PARTITION BY size_class ORDER BY delivery_rate DESC) AS rank_in_size
FROM rating_delivery 
ORDER BY size_class ASC, rank_in_size ASC, vehicle_type ASC
