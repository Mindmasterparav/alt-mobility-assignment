# SQL Queries – Alt Mobility Assignment
  
This folder includes all the SQL queries I wrote for the Alt Mobility Data Analyst Intern assignment. The goal was to explore order patterns, customer behavior, payment reliability, and overall business health using the provided datasets.

---

##  What’s Inside

The queries are grouped into four key areas, each aligned with a specific business question:

###  `order_and_sales_analysis.sql`
Helps understand how orders are flowing and where revenue might be getting stuck:
- Breakdown of order statuses (Pending, Delivered, Shipped)
- Monthly revenue and order trends
- Outstanding revenue tied to incomplete orders
- Comparison of fulfilled vs. unfulfilled revenue
- Top customers based on order value

###  `customer_analysis.sql`
Digs into customer behavior and retention:
- How many customers are repeat buyers?
- Segmenting customers into One-time, Repeat, and Loyal
- Revenue contributions by segment
- Monthly customer acquisition trends
- Order status patterns across different segments

###  `payment_status_analysis.sql`
Analyzes payment performance and risk areas:
- Overall breakdown of payment statuses (Pending, Failed, Completed)
- Trends in payment failures over time
- Payment failures even for delivered orders
- High-risk customers with frequent failed payments
- Payment method performance breakdown

###  `order_details_report.sql`
Brings orders and payments together for a full picture:
- Payment completion status for each order
- Which delivered orders are still unpaid
- Customer-level metrics like fulfillment rate and total paid value

---

##  Data Used

- `customer_orders.csv`: Order info including customer ID, status, amount, and dates  
- `payments.csv`: Payment details tied to each order, including payment method and status

---

##  How These Were Used

The insights from these queries fed into:
- A visual **retention analysis dashboard** in Power BI (see `/visualizations/`)
- A detailed **summary report** highlighting key patterns and business recommendations (`summary_of_findings.pdf`)

Each query is cleanly written and commented to help reviewers follow the logic easily.

---


