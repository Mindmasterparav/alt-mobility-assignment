# Customer Retention Cohort Analysis Visualizations

This folder contains Power BI visualizations designed to analyze customer retention through cohort analysis. The goal is to track how many customers from a specific first-order month (cohort) make repeat purchases in subsequent months.

---
## 🔹 What the Dashboard Shows

The visuals help identify:
- How customer retention changes over time.
- Which cohorts retain customers longer.
- When most customers tend to drop off.

This supports Alt Mobility's goal of improving lifetime value and reducing churn.

---

## How to Read the Matrix

Each row in the matrix represents a **cohort** — customers who made their first purchase in a specific month (e.g., april 2022).  
Each column shows how many **months after that first purchase** those customers returned to place another order.

**Example:**

- If Cohort 2022-04 shows:
  - `110` at Month 0 → 110 customers made their first purchase in April 2022.
  - `2` at Month 1 → 2 of them returned in May 2022.
  - `2` at Month 2 → 2 customers returned in June 2020.
  - `6` at Month 36 → 6 customers were still active 36 months later.

This structure allows for clear visual tracking of retention trends.

---
## Matrix Heatmap

The matrix visualizes customer cohort behavior over time:

- Rows: First purchase month (CohortMonth)
- Columns: Months since first order (MonthsSinceFirstOrder)
- Values: Distinct count of returning customers
- Color Gradient: Darker cells indicate higher repeat engagement

This visual enables easy comparison of retention across cohorts and highlights drop-off patterns.

---

## Line Chart (Dynamic by Cohort)

An interactive line chart displays retention trends for a selected cohort:

- X-axis: Months since first purchase
- Y-axis: Number of returning customers
- Filter: Dynamically updates when a cohort is selected in the matrix

This chart helps business users analyze long-term engagement, such as for customers acquired during promotions.

---

## Interactivity

The matrix and line chart are linked. Selecting a cohort in the matrix filters the line chart to show that cohort’s retention trend, creating an interactive and insightful dashboard.

---

## DAX Calculations Behind the Visual

These custom columns were created to enable cohort-based retention tracking in Power BI:

### FirstOrderMonth
Captures the first order date for each customer.

FirstOrderMonth = 
CALCULATE(
    MIN('customer_orders'[order_date]),
    ALLEXCEPT('customer_orders', 'customer_orders'[customer_id])
)

### CohortMonth
Formats the customer's first purchase month to YYYY-MM format for easier cohort grouping.

CohortMonth = FORMAT('customer_orders'[FirstOrderMonth], "YYYY-MM")

### MonthsSinceFirstOrder
Calculates how many months passed between a customer's first and subsequent orders.

MonthsSinceFirstOrder = 
DATEDIFF(
    'customer_orders'[FirstOrderMonth],
    'customer_orders'[order_date],
    MONTH
)

---

## Key Insights from the Visuals

- For the April 2022 cohort (first-time buyers), **initial engagement was strong** with high order volume in Month 0.
- **Retention dropped sharply in Month 1**, where only a small number of customers returned for a second purchase.
- Subsequent months (Month 2 onwards) showed **minimal re-engagement**, indicating that the majority of customers were not retained beyond their first transaction.
- The matrix heatmap clearly shows this decline, while the line chart visualizes the drop-off trend over time for this specific cohort.
- These findings suggest a need to improve post-purchase communication and loyalty strategies to increase second and third purchases.


## Files in This Folder

- alt_mobility_customer_retention_dashboard.pbix: Interactive Power BI dashboard
- retention_dashboard_screenshot.png: Screenshot of the matrix and line chart
