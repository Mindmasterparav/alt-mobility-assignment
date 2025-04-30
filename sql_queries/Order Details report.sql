-- ORDER DETAILS REPORT

## Q1. Classify delivered orders based on whether payment was completed or not
-- Helps identify delivered orders that are unpaid
SELECT 
    o.order_id,
    o.customer_id,
    o.order_status,
    p.payment_status,
    CASE 
        WHEN o.order_status = 'Delivered' AND p.payment_status = 'Completed' THEN 'Delivered & Paid'
        WHEN o.order_status = 'Delivered' AND p.payment_status != 'Completed' THEN 'Delivered & Unpaid'
        ELSE 'Other'
    END AS payment_completion_status
FROM customer_orders o
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'Delivered';

## Q2. Payment success rate by each order status
-- Useful to analyze which types of orders are more likely to get paid successfully
SELECT 
    o.order_status,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN p.payment_status = 'Completed' THEN 1 ELSE 0 END) AS successful_payments,
    ROUND(SUM(CASE WHEN p.payment_status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS payment_success_rate
FROM customer_orders o
LEFT JOIN payments p ON o.order_id = p.order_id
GROUP BY o.order_status;

## Q3. Total revenue from delivered orders and how much of it remains unpaid
-- Unpaid includes failed, pending, or missing payments
SELECT 
    ROUND(SUM(o.order_amount), 2) AS total_delivered_revenue,
    ROUND(SUM(CASE 
                 WHEN p.payment_status IN ('Pending', 'Failed') OR p.payment_status IS NULL 
                 THEN o.order_amount 
                 ELSE 0 
              END), 2) AS unpaid_delivered_revenue
FROM customer_orders o
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'Delivered';

## Q4. Top customers with delivered orders that are not paid
-- Helps in risk mitigation
SELECT 
    o.customer_id,
    COUNT(*) AS unpaid_delivered_orders,
    ROUND(SUM(o.order_amount), 2) AS unpaid_delivered_amount
FROM customer_orders o
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'Delivered'
  AND (p.payment_status IN ('Failed', 'Pending') OR p.payment_status IS NULL)
GROUP BY o.customer_id
ORDER BY unpaid_delivered_amount DESC
LIMIT 10;

## Q5. Customer-level summary of order fulfillment and payment completion
-- CTE: Total and delivered orders per customer
WITH customer_orders_summary AS (
    SELECT 
        customer_id,
        COUNT(*) AS total_orders,
        SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_orders
    FROM customer_orders
    GROUP BY customer_id
),
-- CTE: Payment stats per customer including number of successful transactions and amount paid
customer_payments_summary AS (
    SELECT 
        o.customer_id,
        COUNT(*) AS total_payments,
        SUM(CASE WHEN p.payment_status = 'Completed' THEN 1 ELSE 0 END) AS successful_payments,
        ROUND(SUM(CASE WHEN p.payment_status = 'Completed' THEN p.payment_amount ELSE 0 END), 2) AS total_paid
    FROM customer_orders o
    LEFT JOIN payments p ON o.order_id = p.order_id
    GROUP BY o.customer_id
)
-- Main query: Combine both summaries to calculate payment success rate, fulfillment rate, and total value
SELECT 
    co.customer_id,
    co.total_orders,
    co.delivered_orders,
    cp.total_payments,
    cp.successful_payments,
    ROUND(cp.successful_payments * 100.0 / NULLIF(cp.total_payments, 0), 2) AS payment_success_rate,
    ROUND(co.delivered_orders * 100.0 / NULLIF(co.total_orders, 0), 2) AS fulfillment_rate,
    cp.total_paid AS total_customer_value
FROM customer_orders_summary co
JOIN customer_payments_summary cp ON co.customer_id = cp.customer_id
ORDER BY total_customer_value DESC;

