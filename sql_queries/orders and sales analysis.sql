-- ORDERS AND SALES ANALYSIS

## Q1. Get total orders by order status and their percentage share
-- Helps understand how many orders are completed vs. still in progress
SELECT 
    order_status, 
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_orders), 2) AS percentage
FROM customer_orders
GROUP BY order_status
ORDER BY total_orders DESC;

## Q2. Calculate total revenue and average order value for each order status
-- Useful for comparing the total revenue and A.O.V of completed vs. pending/shipped orders
SELECT 
    order_status,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue,
    ROUND(AVG(order_amount), 2) AS average_order_value
FROM customer_orders
GROUP BY order_status
ORDER BY average_order_value DESC;

## Q3. Monthly trend of orders and revenue over the past 12 months
-- Shows growth trends in both order volume and revenue
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue,
    ROUND(AVG(order_amount), 2) AS average_order_value
FROM customer_orders
WHERE STR_TO_DATE(order_date, '%Y-%m-%d') >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY month
ORDER BY month;

## Q4. Monthly percentage of orders that are still pending
-- Helps track operational backlog or delays in recent months
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Pending' THEN 1 ELSE 0 END) AS pending_orders,
    ROUND(SUM(CASE WHEN order_status = 'Pending' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pending_percentage
FROM customer_orders
WHERE order_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 MONTH)
GROUP BY month
ORDER BY month;

## Q5. Identify customers with the highest revenue from pending or shipped orders
-- Useful to prioritize order completion for top-value customers
SELECT 
    customer_id,
    COUNT(*) AS unfulfilled_orders,
    ROUND(SUM(order_amount), 2) AS outstanding_revenue,
    ROUND(AVG(order_amount), 2) AS avg_unfulfilled_order_value
FROM customer_orders
WHERE order_status IN ('Pending', 'Shipped')
GROUP BY customer_id
ORDER BY outstanding_revenue DESC
LIMIT 10;

## Q6. Compare revenue from fulfilled vs. unfulfilled orders
-- Highlights how much revenue is still locked in pending/shipped stages
SELECT 
    CASE 
        WHEN order_status = 'Delivered' THEN 'Fulfilled'
        WHEN order_status IN ('Pending', 'Shipped') THEN 'Unfulfilled'
        ELSE 'Other'
    END AS fulfillment_status,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue,
    ROUND(SUM(order_amount) * 100.0 / 
        (SELECT SUM(order_amount) 
         FROM customer_orders 
         WHERE order_status IN ('Delivered', 'Pending', 'Shipped')), 2) AS revenue_percentage
FROM customer_orders
WHERE order_status IN ('Delivered', 'Pending', 'Shipped')
GROUP BY fulfillment_status
ORDER BY fulfillment_status;

## Q7. Top customers by total revenue and average order value (min 3 orders)
-- Helps identify high-value and consistently spending customers
SELECT 
    customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_order_value,
    ROUND(AVG(order_amount), 2) AS average_order_value
FROM customer_orders
GROUP BY customer_id
HAVING total_orders >= 3
ORDER BY total_order_value DESC, average_order_value DESC
LIMIT 10;

## Q8. Customers with the highest pending or shipped order value
-- Shows which accounts are holding the most outstanding revenue
SELECT 
    customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_pending_or_shipped_value
FROM customer_orders
WHERE order_status IN ('Pending', 'Shipped')
GROUP BY customer_id
ORDER BY total_pending_or_shipped_value DESC
LIMIT 10;


