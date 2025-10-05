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
    HAVING COUNT(DISTINCT oi1.order_id) >= 1
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

/*
7. Customer Cohort Analysis (Retention Rate)
    - Business Question: "How well are we retaining customers over time after their first purchase?"
*/

WITH customer_cohorts AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(order_date)) AS cohort_month
    FROM orders
    GROUP BY customer_id
),
order_periods AS (
    SELECT
        o.customer_id,
        cc.cohort_month,
        DATE_TRUNC('month', o.order_date) AS order_month,
        EXTRACT(YEAR FROM AGE(o.order_date, cc.cohort_month)) * 12 + 
        EXTRACT(MONTH FROM AGE(o.order_date, cc.cohort_month)) AS period_number
    FROM orders o
    JOIN customer_cohorts cc ON o.customer_id = cc.customer_id
),
cohort_data AS (
    SELECT
        cohort_month,
        period_number,
        COUNT(DISTINCT customer_id) AS customers
    FROM order_periods
    GROUP BY cohort_month, period_number
),
cohort_sizes AS (
    SELECT
        cohort_month,
        customers AS cohort_size
    FROM cohort_data
    WHERE period_number = 0
)
SELECT
    cd.cohort_month,
    cd.period_number,
    cd.customers,
    cs.cohort_size,
    ROUND((cd.customers * 100.0 / cs.cohort_size), 2) AS retention_rate
FROM cohort_data cd
JOIN cohort_sizes cs ON cd.cohort_month = cs.cohort_month
ORDER BY cd.cohort_month, cd.period_number;

/*
8. Supplier Performance Analysis
    - Business Question: "Which suppliers are performing best in terms of sales and profitability?"
*/

WITH supplier_performance AS (
    SELECT
        s.supplier_id,
        s.supplier_name,
        s.country,
        COUNT(DISTINCT oi.product_id) AS unique_products,
        SUM(oi.quantity) AS total_units_sold,
        SUM(oi.quantity * oi.price_at_time_of_order) AS total_revenue,
        SUM(oi.quantity * p.cost) AS total_cost,
        SUM(oi.quantity * (oi.price_at_time_of_order - p.cost)) AS total_profit,
        COUNT(DISTINCT o.order_id) AS orders_containing_products
    FROM suppliers s
    JOIN products p ON s.supplier_id = p.supplier_id
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status != 'Returned'
    GROUP BY s.supplier_id, s.supplier_name, s.country
)
SELECT
    supplier_name,
    country,
    unique_products,
    total_units_sold,
    total_revenue,
    total_profit,
    ROUND((total_profit / total_revenue) * 100, 2) AS profit_margin_pct,
    ROUND(total_revenue / NULLIF(unique_products, 0), 2) AS revenue_per_product,
    DENSE_RANK() OVER (ORDER BY total_profit DESC) AS profit_rank
FROM supplier_performance
ORDER BY total_profit DESC;

/*
9. Time-to-Second-Purchase Analysis
    - Business Question: "How long does it take for customers to make their second purchase?"
*/

WITH customer_orders AS (
    SELECT
        customer_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_sequence
    FROM orders
),
first_second_orders AS (
    SELECT
        co1.customer_id,
        co1.order_date AS first_order_date,
        co2.order_date AS second_order_date,
        co2.order_date::DATE - co1.order_date::DATE AS days_to_second_purchase
    FROM customer_orders co1
    JOIN customer_orders co2 ON co1.customer_id = co2.customer_id
    WHERE co1.order_sequence = 1 AND co2.order_sequence = 2
)
SELECT
    CASE
        WHEN days_to_second_purchase <= 7 THEN '0-7 days'
        WHEN days_to_second_purchase <= 30 THEN '8-30 days'
        WHEN days_to_second_purchase <= 90 THEN '31-90 days'
        ELSE '90+ days'
    END AS time_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(days_to_second_purchase), 2) AS avg_days,
    MIN(days_to_second_purchase) AS min_days,
    MAX(days_to_second_purchase) AS max_days
FROM first_second_orders
GROUP BY time_segment
ORDER BY MIN(days_to_second_purchase);

/*
10. Monthly Revenue by Category with Running Total
    - Business Question: "How do sales trends look for each product category over time with cumulative performance?"
*/

WITH monthly_category_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS sales_month,
        p.category,
        SUM(oi.quantity * oi.price_at_time_of_order) AS monthly_revenue,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.status != 'Returned'
    GROUP BY sales_month, p.category
)
SELECT
    sales_month,
    category,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        PARTITION BY category 
        ORDER BY sales_month 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue,
    LAG(monthly_revenue) OVER (
        PARTITION BY category 
        ORDER BY sales_month
    ) AS previous_month_revenue,
    ROUND(
        ((monthly_revenue - LAG(monthly_revenue) OVER (
            PARTITION BY category 
            ORDER BY sales_month
        )) / NULLIF(LAG(monthly_revenue) OVER (
            PARTITION BY category 
            ORDER BY sales_month
        ), 0)) * 100, 2
    ) AS month_over_month_growth
FROM monthly_category_sales
ORDER BY category, sales_month;


/*
11. Top-Selling Products by Region
    - Business Question: "What are the best-selling products in each geographic region?"
*/

WITH regional_sales AS (
    SELECT
        c.state,
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.quantity * oi.price_at_time_of_order) AS revenue,
        RANK() OVER (PARTITION BY c.state ORDER BY SUM(oi.quantity) DESC) AS rank_in_state
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.status != 'Returned'
    GROUP BY c.state, p.product_id, p.product_name, p.category
)
SELECT
    state,
    product_name,
    category,
    units_sold,
    revenue,
    rank_in_state
FROM regional_sales
WHERE rank_in_state <= 3  -- Top 3 products per state
ORDER BY state, rank_in_state;

/*

--- Sales & Performance Analysis ---
 i. Is our business growing month-over-month? - Monthly sales trends with growth percentages
 ii. What are our best and worst performing products? - Product performance and profitability analysis
 iii. Which customers haven't purchased in the last 90 days? - Re-engagement campaign identification

--- Product & Operational Insights ---
 i. What products are frequently purchased together? - Market basket analysis for cross-selling
 ii. Which suppliers are performing best? - Supplier performance ranking by profitability
 iii. What are the best-selling products in each geographic region? - Regional sales performance analysis

*/