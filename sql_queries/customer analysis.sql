-- CUSTOMER ANALYSIS QUERIES

## Q1. Count unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM customer_orders;

## Q2. Count repeat customers and their revenue contribution
-- CTE: Identify customers who placed more than one order
WITH repeat_customers AS (
    SELECT customer_id
    FROM customer_orders
    GROUP BY customer_id
    HAVING COUNT(*) > 1
)
-- Main query: Count repeat customers and their share of total revenue
SELECT 
    COUNT(*) AS repeat_customers,
    ROUND(SUM(o.order_amount), 2) AS repeat_customer_revenue,
    ROUND(SUM(o.order_amount) * 100.0 / (SELECT SUM(order_amount) FROM customer_orders), 2) AS revenue_percentage
FROM customer_orders AS o
JOIN repeat_customers AS r ON o.customer_id = r.customer_id;

## Q3. Segment customers by order count and calculate revenue metrics
-- CTE: Summarize total orders and total revenue per customer
WITH order_summary AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count,
        SUM(order_amount) AS total_revenue
    FROM customer_orders
    GROUP BY customer_id
),
-- CTE: Assign customer segment labels
segmented_customers AS (
    SELECT 
        customer_id,
        order_count,
        total_revenue,
        CASE
            WHEN order_count = 1 THEN 'One-time'
            WHEN order_count BETWEEN 2 AND 4 THEN 'Repeat'
            ELSE 'Loyal'
        END AS customer_segment
    FROM order_summary
)
-- Main query: Count customers in each segment and compute total and average revenue of each segment
SELECT 
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_revenue), 2) AS total_segment_revenue,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_customer
FROM segmented_customers
GROUP BY customer_segment;

## Q4. Monthly customer acquisition in the last 24 months
-- CTE: Get first order date per customer
WITH first_orders AS (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM customer_orders
    GROUP BY customer_id
)
-- Main query: Count new customers per month
SELECT 
    DATE_FORMAT(first_order_date, '%Y-%m') AS month,
    COUNT(*) AS new_customers
FROM first_orders
WHERE first_order_date >= DATE_SUB(CURDATE(), INTERVAL 24 MONTH)
GROUP BY month
ORDER BY month DESC;

## Q5. Order status distribution by customer segment
-- CTE: Assign customer segments
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
-- CTE: Join customer segments to order data
orders_with_segments AS (
    SELECT o.*, s.segment
    FROM customer_orders o
    JOIN customer_segments s ON o.customer_id = s.customer_id
)
-- Main query: Count orders by status and segment
SELECT 
    segment,
    COUNT(CASE WHEN order_status = 'Pending' THEN 1 END) AS Pending,
    COUNT(CASE WHEN order_status = 'Shipped' THEN 1 END) AS Shipped,
    COUNT(CASE WHEN order_status = 'Delivered' THEN 1 END) AS Delivered
FROM orders_with_segments
GROUP BY segment
ORDER BY 
    CASE segment
        WHEN 'One-time' THEN 1
        WHEN 'Repeat' THEN 2
        WHEN 'Loyal' THEN 3
    END;





