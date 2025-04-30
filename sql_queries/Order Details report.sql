## Orders Details Report

-- 1. Payment Completion Status
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

-- 2. Payment Success Rate by Order Status
SELECT 
    o.order_status,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN p.payment_status = 'Completed' THEN 1 ELSE 0 END) AS successful_payments,
    ROUND(SUM(CASE WHEN p.payment_status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS payment_success_rate
FROM customer_orders o
LEFT JOIN payments p ON o.order_id = p.order_id
GROUP BY o.order_status;

-- 3. Delivered Orders Payment Realization Summary
SELECT 
    ROUND(SUM(o.order_amount), 2) AS total_delivered_revenue,

    -- Revenue from delivered orders that are unpaid (Pending, Failed, or no payment record)
    ROUND(SUM(CASE 
                 WHEN p.payment_status IN ('Pending', 'Failed') OR p.payment_status IS NULL 
                 THEN o.order_amount 
                 ELSE 0 
              END), 2) AS unpaid_delivered_revenue
FROM customer_orders o
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'Delivered';

-- 4. Customers with Delivery Fulfilled but Payment Incomplete
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

-- 5. Customer-Level Metrics 

WITH customer_orders_summary AS (
    SELECT 
        customer_id,
        COUNT(*) AS total_orders,
        SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_orders
    FROM customer_orders
    GROUP BY customer_id
),
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
