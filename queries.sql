-- Brazilian E-commerce Performance Analysis
-- Analysis of 100K+ orders from Brazilian marketplace (2016-2018)
-- Covers revenue trends, geographic distribution, customer segmentation, and growth metrics

-- ===== DATA EXPLORATION =====
-- Initial data overview
SELECT 'Customers' as table_name, 
COUNT(*) as row_count FROM customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL  
SELECT 'Order Items', COUNT(*) FROM order_items
UNION ALL
SELECT 'Products', COUNT(*) FROM products;


-- ===== DATA CLEANING =====
-- Found max and min date but came to problem where the first row was the column header
-- so it kept giving max date as the header (order_purchase_timestamp)
-- To fix:

DELETE FROM orders 
WHERE order_purchase_timestamp = 'order_purchase_timestamp';


-- ===== DATA EXPLORATION CONT.=====
SELECT 
	MIN(order_purchase_timestamp) AS first_order,
	MAX(order_purchase_timestamp) AS last_order,
	COUNT(*) as total_orders
FROM orders;



SELECT 
    COUNT(DISTINCT o.order_id) as total_orders,
    COUNT(DISTINCT o.customer_id) as unique_customers,
    ROUND(SUM(oi.price::NUMERIC), 2) as total_revenue,
    ROUND(AVG(oi.price::NUMERIC), 2) as avg_item_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';



-- ===== REVENUE ANALYSIS =====
-- Calculate total revenue by month
SELECT 
    DATE_TRUNC('month', order_purchase_timestamp::TIMESTAMP) as month,
    COUNT(DISTINCT o.order_id) as monthly_orders,
    ROUND(SUM(oi.price::NUMERIC), 2) as monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_TRUNC('month', order_purchase_timestamp::TIMESTAMP)
ORDER BY month;


-- ===== PRODUCT CATEGORY ANALYSIS =====
SELECT 
    p.product_category_name,
    COUNT(*) as items_sold,
    ROUND(SUM(oi.price::NUMERIC), 2) as category_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY category_revenue DESC
LIMIT 10;


-- ===== GEOGRAPHIC SALES ANALYSIS =====
SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) as orders,
    ROUND(SUM(oi.price::NUMERIC), 2) as state_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY state_revenue DESC
LIMIT 10;



-- ===== CUSTOMER SEGMENTATION ANALYSIS =====
WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        COUNT(DISTINCT o.order_id) as order_count,
        SUM(oi.price::NUMERIC) as total_spent,
        MIN(o.order_purchase_timestamp::DATE) as first_order,
        MAX(o.order_purchase_timestamp::DATE) as last_order
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_id
)
SELECT 
    CASE 
        WHEN total_spent < 50 THEN 'Low Value'
        WHEN total_spent BETWEEN 50 AND 200 THEN 'Medium Value'
        WHEN total_spent BETWEEN 200 AND 500 THEN 'High Value'
        ELSE 'VIP'
    END as customer_segment,
    COUNT(*) as customers,
    ROUND(AVG(total_spent), 2) as avg_clv,
    ROUND(AVG(order_count), 1) as avg_orders
FROM customer_metrics
GROUP BY customer_segment
ORDER BY avg_clv DESC;



-- ===== QUARTER-OVER-QUARTER GROWTH ANALYSIS =====
SELECT 
    EXTRACT(YEAR FROM order_purchase_timestamp::TIMESTAMP) as year,
    EXTRACT(QUARTER FROM order_purchase_timestamp::TIMESTAMP) as quarter,
    COUNT(DISTINCT o.order_id) as orders,
    ROUND(SUM(oi.price::NUMERIC), 2) as revenue,
    ROUND(
        100.0 * (SUM(oi.price::NUMERIC) - LAG(SUM(oi.price::NUMERIC)) OVER (ORDER BY EXTRACT(YEAR FROM order_purchase_timestamp::TIMESTAMP), EXTRACT(QUARTER FROM order_purchase_timestamp::TIMESTAMP))) 
        / LAG(SUM(oi.price::NUMERIC)) OVER (ORDER BY EXTRACT(YEAR FROM order_purchase_timestamp::TIMESTAMP), EXTRACT(QUARTER FROM order_purchase_timestamp::TIMESTAMP))
    , 1) as growth_rate_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY year, quarter
ORDER BY year, quarter;



-- ===== PRODUCT PROFITABILITY ANALYSIS =====
SELECT 
    p.product_category_name,
    COUNT(DISTINCT oi.product_id) as unique_products,
    COUNT(*) as total_items_sold,
    ROUND(AVG(oi.price::NUMERIC), 2) as avg_price,
    ROUND(SUM(oi.price::NUMERIC), 2) as total_revenue,
    ROUND(SUM(oi.price::NUMERIC) / COUNT(*), 2) as revenue_per_item
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(*) > 100  -- Only categories with significant volume
ORDER BY revenue_per_item DESC
LIMIT 15;


-- ===== EXECUTIVE KPI DASHBOARD =====
SELECT 
    'Total Revenue' as metric,
    CONCAT('$', ROUND(SUM(oi.price::NUMERIC)/1000000, 1), 'M') as value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'

UNION ALL

SELECT 
    'Active Customers',
    COUNT(DISTINCT o.customer_id)::TEXT
FROM orders o
WHERE o.order_status = 'delivered'

UNION ALL

SELECT 
    'Avg Order Value',
    CONCAT('$', ROUND(AVG(order_total), 2))
FROM (
    SELECT o.order_id, SUM(oi.price::NUMERIC) as order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.order_id
) order_totals;

