# Alt Mobility – Data Analyst Assignment

This repository contains the completed assignment for the Data Analyst Intern role at Alt Mobility. It includes SQL-based data analysis, visualizations for customer retention, and a summary of findings.

---

##  Folder Structure

- `sql_queries/` – Contains all SQL queries and a description README.
- `visualizations/` – Contains customer retention visualizations and explanation screenshots.
- `summary_of_findings.pdf` – Final report with insights and recommendations.

---

##  Approach Overview

The analysis is based on two datasets: `payments.csv` and `customer_orders.csv`. The tasks were divided into:
1. Order and Sales Analysis
2. Customer Behavior Analysis
3. Payment Status Analysis
4. Combined Order-Payment Report
5. Customer Retention Visualization

Each SQL query is documented in `sql_queries/README.md`.

---

##  Visualization: Customer Retention Analysis

To explore customer retention, we used **cohort analysis** to group users by their first order month and then tracked how many of them made repeat purchases in subsequent months.

Two visualizations were created using Power BI:

### 1. **Cohort Matrix Heatmap**
- **Rows**: CohortMonth (month of first purchase)
- **Columns**: MonthsSinceFirstOrder (how many months later)
- **Values**: Distinct count of returning customers
- **Color Scale**: Darker shades indicate higher retention, helping highlight strong vs. weak cohorts.

### 2. **Interactive Line Chart**
- **X-Axis**: Months since first purchase
- **Y-Axis**: Number of returning customers
- **Purpose**: Allows tracking the drop-off pattern of any specific cohort (e.g., April 2022).
- **Interaction**: Selecting a cohort row in the matrix dynamically updates the line chart.

In addition to retention, the SQL-based analysis opens up opportunities to build other insightful visuals - such as monthly revenue trends, top customer segments by value, order status distribution, payment success rates, and outstanding revenue heatmaps.

---

##  Summary of Findings

A concise PDF report with:
- Key insights from SQL queries
- Retention trends and business implications
- Recommendations for Alt Mobility

---

