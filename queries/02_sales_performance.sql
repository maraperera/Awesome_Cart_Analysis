/*
2. Monthly Sales Trend & Growth
    - Business Question: "Is our business growing month-over-month?"
*/

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS sales_month,
        SUM(oi.quantity * oi.price_at_time_of_order) AS total_sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY sales_month
)
SELECT
    sales_month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY sales_month) AS previous_month_sales,
    ROUND(
        ((total_sales - LAG(total_sales) OVER (ORDER BY sales_month)) / LAG(total_sales) OVER (ORDER BY sales_month)) * 100, 2
    ) AS growth_percentage
FROM monthly_sales
ORDER BY sales_month;