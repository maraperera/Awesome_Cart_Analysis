/*
3. Product Performance & Profitability Analysis
    - Business Question: "What are our best and worst performing products in terms of profit?"
*/

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.price_at_time_of_order) AS total_revenue,
    SUM(oi.quantity * p.cost) AS total_cost,
    SUM(oi.quantity * (oi.price_at_time_of_order - p.cost)) AS total_profit,
    ROUND((SUM(oi.quantity * (oi.price_at_time_of_order - p.cost)) / SUM(oi.quantity * oi.price_at_time_of_order)) * 100, 2) AS profit_margin_percent
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status != 'Returned' -- Exclude returned items
GROUP BY p.product_id
ORDER BY total_profit DESC;