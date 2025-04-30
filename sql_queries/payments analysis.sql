## Payment Status Analysis

-- 1. Overall Distribution of Payment Status
SELECT 
    payment_status,
    COUNT(*) AS total_payments,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM payments), 2) AS percentage
FROM payments
GROUP BY payment_status
ORDER BY total_payments DESC;

-- 2. Total and Average Payment Amount by Status
SELECT 
    payment_status,
    ROUND(SUM(payment_amount), 2) AS total_payment_amount,
    ROUND(AVG(payment_amount), 2) AS average_payment_amount
FROM payments
GROUP BY payment_status
ORDER BY total_payment_amount DESC;

-- 3. Monthly Trend in Payment Failures Last 1 Year
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    COUNT(*) AS total_payments,
    SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) AS failed_payments,
    ROUND(SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM payments
WHERE payment_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY month
ORDER BY month;

-- 4. Top Customers by Failed Payments and failed payments on delivered items
SELECT 
    o.customer_id,
    COUNT(*) AS failed_payment_count,
    ROUND(SUM(p.payment_amount), 2) AS total_failed_amount,
    SUM(CASE WHEN o.order_status = 'Delivered' THEN 1 ELSE 0 END) AS failed_for_delivered_orders,
    ROUND(SUM(CASE WHEN o.order_status = 'Delivered' THEN p.payment_amount ELSE 0 END), 2) AS failed_amount_for_delivered
FROM payments p
JOIN customer_orders o ON p.order_id = o.order_id
WHERE p.payment_status = 'Failed'
GROUP BY o.customer_id
ORDER BY total_failed_amount DESC
LIMIT 10;


-- 6 Monthly Payment Method Performance Analysis (Since beginning of 2025)
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    payment_method,
    COUNT(*) AS total_payments,
    SUM(CASE WHEN payment_status = 'Completed' THEN 1 ELSE 0 END) AS completed_payments,
    SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) AS failed_payments,
    SUM(CASE WHEN payment_status = 'Pending' THEN 1 ELSE 0 END) AS pending_payments,
    ROUND(SUM(CASE WHEN payment_status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate,
    ROUND(SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate,
    ROUND(SUM(CASE WHEN payment_status = 'Pending' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pending_rate
FROM payments
WHERE payment_date >= '2025-01-01'
GROUP BY month, payment_method
ORDER BY month, payment_method;



