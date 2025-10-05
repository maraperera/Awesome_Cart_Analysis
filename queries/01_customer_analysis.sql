/* 
1. Customer Order History & Lifetime Value (LTV)
    - Business Question: "Who are our most valuable customers?"
*/

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS number_of_orders,
    SUM(oi.quantity * oi.price_at_time_of_order) AS total_lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY total_lifetime_value DESC;