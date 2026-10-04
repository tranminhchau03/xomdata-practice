-- Xom Data · The category's flagship next to each item
-- Problem: https://xomdata.com/practice/medium-firstval-001
-- Solved: 2026-10-04

SELECT
    category,
    product_name,
    price,

    FIRST_VALUE(product_name) OVER (
        PARTITION BY category
        ORDER BY price DESC, product_name ASC
    ) AS top_product

FROM catalog

ORDER BY
    category ASC,
    price DESC,
    product_name ASC;
