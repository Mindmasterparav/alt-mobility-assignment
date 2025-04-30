## Customer Analysis

-- 1. How many unique customers have placed orders?
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM customer_orders;

-- 2. How many customers placed more than one order? What percentage of total revenue do they contribute?
WITH repeat_customers AS (
    SELECT customer_id
    FROM customer_orders
    GROUP BY customer_id
    HAVING COUNT(*) > 1
)
SELECT 
    COUNT(*) AS repeat_customers,
    ROUND(SUM(o.order_amount), 2) AS repeat_customer_revenue,
    ROUND(SUM(o.order_amount) * 100.0 / (SELECT SUM(order_amount) FROM customer_orders), 2) AS revenue_percentage
FROM customer_orders as o
JOIN repeat_customers as r ON o.customer_id = r.customer_id;

-- 3. Customer Segmentation by Order Frequency

WITH order_summary AS (
    SELECT 
	    customer_id, 
        COUNT(*) AS order_count
    FROM customer_orders
    GROUP BY customer_id
),
segmented_customers AS (
    SELECT 
        customer_id,
        order_count,
        CASE
            WHEN order_count = 1 THEN 'One-time'
            WHEN order_count BETWEEN 2 AND 4 THEN 'Repeat'
            ELSE 'Loyal'
        END AS customer_segment
    FROM order_summary
)
SELECT 
    customer_segment,
    COUNT(*) AS customer_count
FROM segmented_customers
GROUP BY customer_segment;

-- 4. Average and total revenue per customer segment (One-time, Repeat, Loyal)
WITH order_counts AS (
    SELECT customer_id, COUNT(*) AS order_count, SUM(order_amount) AS total_revenue
    FROM customer_orders
    GROUP BY customer_id
),
segmented AS (
    SELECT 
        customer_id,
        total_revenue,
        CASE 
            WHEN order_count = 1 THEN 'One-time'
            WHEN order_count BETWEEN 2 AND 4 THEN 'Repeat'
            ELSE 'Loyal'
        END AS customer_segment
    FROM order_counts
)
SELECT 
    customer_segment,
    COUNT(*) AS customers,
    ROUND(SUM(total_revenue), 2) AS total_segment_revenue,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_customer
FROM segmented
GROUP BY customer_segment;

-- 5. Which customers have the highest total order value?
SELECT 
    customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue
FROM customer_orders
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;

-- 6. Monthly Customer Acquisition Report for Last 2 Years
WITH first_orders AS (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM customer_orders
    GROUP BY customer_id
)
SELECT 
    DATE_FORMAT(first_order_date, '%Y-%m') AS month,
    COUNT(*) AS new_customers
FROM first_orders
WHERE first_order_date >= DATE_SUB(CURDATE(), INTERVAL 24 MONTH)
GROUP BY month
ORDER BY month DESC;

-- 7. Are certain order_status more common among One-time vs. Loyal customers?
WITH customer_segments AS (
    SELECT 
        customer_id,
        CASE 
            WHEN COUNT(*) = 1 THEN 'One-time'
            WHEN COUNT(*) BETWEEN 2 AND 4 THEN 'Repeat'
            ELSE 'Loyal'
        END AS segment
    FROM customer_orders
    GROUP BY customer_id
),
orders_with_segments AS (
    SELECT o.*, s.segment
    FROM customer_orders o
    JOIN customer_segments s ON o.customer_id = s.customer_id
)
SELECT 
    segment,
    order_status,
    COUNT(*) AS total_orders
FROM orders_with_segments
GROUP BY segment, order_status
ORDER BY segment, total_orders DESC;





