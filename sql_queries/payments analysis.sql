-- PAYMENTS ANALYSIS

## Q1. Distribution of payment statuses (e.g., Completed, Failed, Pending)
-- Useful to understand overall success/failure rates of payment processing
SELECT 
    payment_status,
    COUNT(*) AS total_payments,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM payments), 2) AS percentage
FROM payments
GROUP BY payment_status
ORDER BY total_payments DESC;

## Q2. Total and average payment amount by status
-- Helps evaluate the monetary impact of failed or pending payments
SELECT 
    payment_status,
    ROUND(SUM(payment_amount), 2) AS total_payment_amount,
    ROUND(AVG(payment_amount), 2) AS average_payment_amount
FROM payments
GROUP BY payment_status
ORDER BY total_payment_amount DESC;

## Q3. Monthly trend in payment failures over the last 12 months
-- Tracks how failure rate is changing month-over-month
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    COUNT(*) AS total_payments,
    SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) AS failed_payments,
    ROUND(SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM payments
WHERE payment_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY month
ORDER BY month;

## Q4. Top customers by failed payments
-- Identifies customers who experience the most failed transactions, and then calculating how many failed for delivered orders
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

## Q5. Monthly performance of each payment method since January 2025
-- Shows total transactions per method and their success, failure, and pending rates
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
