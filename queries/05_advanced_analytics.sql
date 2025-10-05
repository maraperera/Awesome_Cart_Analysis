/*
5. Customer Segmentation by Purchase Frequency
    - Business Question: "Can we segment our customers into groups (New, Regular, VIP) based on their order frequency and value?"
*/

WITH customer_stats AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        COUNT(DISTINCT o.order_id) AS order_count,
        SUM(oi.quantity * oi.price_at_time_of_order) AS total_spent,
        MAX(o.order_date) AS last_order_date
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id
),
customer_segments AS (
    SELECT
        *,
        CASE
            WHEN order_count = 0 THEN 'Inactive'
            WHEN order_count = 1 THEN 'New Customer'
            WHEN order_count BETWEEN 2 AND 4 THEN 'Regular Customer'
            ELSE 'VIP Customer'
        END AS frequency_segment,
        CASE
            WHEN total_spent = 0 THEN 'No Purchase'
            WHEN total_spent < 100 THEN 'Low Value'
            WHEN total_spent BETWEEN 100 AND 500 THEN 'Medium Value'
            ELSE 'High Value'
        END AS value_segment
    FROM customer_stats
)
SELECT
    frequency_segment,
    value_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spent), 2) AS avg_spent_per_segment
FROM customer_segments
GROUP BY frequency_segment, value_segment
ORDER BY frequency_segment, value_segment;
