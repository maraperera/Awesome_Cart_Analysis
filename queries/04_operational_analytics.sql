/*
4. Identifying Customers for a Re-engagement Campaign
    - Business Question: "Which customers haven't purchased in the last 90 days?"
*/

SELECT
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    email,
    (SELECT MAX(order_date) FROM orders o WHERE o.customer_id = c.customer_id) AS last_order_date
FROM customers c
WHERE (SELECT MAX(order_date) FROM orders o WHERE o.customer_id = c.customer_id) < CURRENT_DATE - INTERVAL '90 days'
   OR (SELECT MAX(order_date) FROM orders o WHERE o.customer_id = c.customer_id) IS NULL;