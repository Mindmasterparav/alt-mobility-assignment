# Customer Retention Cohort Analysis Visualizations

This folder contains Power BI visualizations designed to analyze customer retention through cohort analysis. The goal is to track how many customers from a specific first-order month (cohort) make repeat purchases in subsequent months.

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

## Files in This Folder

- alt_mobility_customer_retention_dashboard.pbix: Interactive Power BI dashboard
- retention_dashboard_screenshot.png: Screenshot of the matrix and line chart
