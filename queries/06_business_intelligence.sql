/*
6. Product Pair Analysis (Market Basket Analysis)
    - Business Question: "What products are frequently purchased together to inform cross-selling strategies?"
*/

WITH product_pairs AS (
    SELECT
        oi1.product_id AS product_1,
        oi2.product_id AS product_2,
        COUNT(DISTINCT oi1.order_id) AS times_purchased_together
    FROM order_items oi1
    JOIN order_items oi2 ON oi1.order_id = oi2.order_id
    WHERE oi1.product_id < oi2.product_id -- Avoid duplicates (A,B) and (B,A)
    GROUP BY oi1.product_id, oi2.product_id
    HAVING COUNT(DISTINCT oi1.order_id) >= 1 -- Change threshold as needed
)
SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    pp.times_purchased_together,
    ROUND(
        (pp.times_purchased_together * 100.0 / (
            SELECT COUNT(*) FROM orders WHERE status != 'Returned'
        )), 2
    ) AS penetration_rate
FROM product_pairs pp
JOIN products p1 ON pp.product_1 = p1.product_id
JOIN products p2 ON pp.product_2 = p2.product_id
ORDER BY times_purchased_together DESC
LIMIT 10;
