## ORDERS AND SALES ANALYSIS

-- 1. Customer Order Status Distribution
SELECT order_status, 
       COUNT(*) AS total_orders,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_orders), 2) AS percentage
FROM customer_orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 2. Average Order Value by Status
SELECT 
    order_status,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue,
    ROUND(AVG(order_amount), 2) AS average_order_value
FROM customer_orders
GROUP BY order_status
ORDER BY average_order_value DESC;

-- 3. Monthly Order and Revenue Trend - Last 12 Months
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue,
    ROUND(AVG(order_amount), 2) AS average_order_value
FROM customer_orders
WHERE STR_TO_DATE(order_date, '%Y-%m-%d') >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY month
ORDER BY month;

-- 4. Monthly Pending Order Rate - Last 12 Months
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Pending' THEN 1 ELSE 0 END) AS pending_orders,
    ROUND(SUM(CASE WHEN order_status = 'Pending' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pending_percentage
FROM customer_orders
WHERE order_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 MONTH)
GROUP BY month
ORDER BY month;

-- 5. Unrealized Revenue by Customer (Pending or Shipped Orders)
SELECT 
    customer_id,
    COUNT(*) AS unfulfilled_orders,
    ROUND(SUM(order_amount), 2) AS unrealized_revenue,
    ROUND(AVG(order_amount), 2) AS avg_unfulfilled_order_value
FROM customer_orders
WHERE order_status IN ('Pending', 'Shipped')
GROUP BY customer_id
ORDER BY unrealized_revenue DESC
LIMIT 10;

-- 6. Top customers by revenue and avg order value
SELECT 
    customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_order_value,
    ROUND(AVG(order_amount), 2) AS average_order_value
FROM customer_orders
GROUP BY customer_id
HAVING total_orders >= 3 -- Filter for customers with at least 3 orders
ORDER BY total_order_value DESC, average_order_value DESC
LIMIT 10;


-- 7. Customers with orders having pending or shipped status
SELECT 
    customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_pending_or_shipped_value
FROM customer_orders
WHERE order_status IN ('Pending', 'Shipped')
GROUP BY customer_id
ORDER BY total_pending_or_shipped_value DESC
LIMIT 10;

-- 7. Comparison of Revenue from Fulfilled (Delivered) vs Unfulfilled (Pending/Shipped) Orders
SELECT 
    CASE 
        WHEN order_status = 'Delivered' THEN 'Fulfilled'
        WHEN order_status IN ('Pending', 'Shipped') THEN 'Unfulfilled'
        ELSE 'Other'
    END AS fulfillment_status,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_amount), 2) AS total_revenue,
    ROUND(SUM(order_amount) * 100.0 / 
        (SELECT SUM(order_amount) FROM customer_orders 
         WHERE order_status IN ('Delivered', 'Pending', 'Shipped')), 2) AS revenue_percentage
FROM customer_orders
WHERE order_status IN ('Delivered', 'Pending', 'Shipped')
GROUP BY fulfillment_status
ORDER BY fulfillment_status;
