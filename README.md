# Danny's Diner - 8 Week SQL Challenge

## Overview
This repository contains the case study solution for **Danny's Diner**, part of the **8 Week SQL Challenge**. The case study revolves around Danny, who wants to analyze his restaurant's performance and customer behavior. Using SQL, we derive key business insights from the available datasets.

---

## Problem Statement
Danny owns a small diner and wants to:
1. Analyze customer spending habits.
2. Understand loyalty program performance.
3. Optimize his menu offerings based on customer preferences.

Using the provided datasets, the analysis addresses the following:
- Customer spending.
- Frequency of visits.
- Most frequently purchased items.
- Performance of loyalty members.
- Points calculation system for loyalty members.

---

## Datasets
The case study uses three datasets:
1. **Sales**: Transaction details including customer ID, product ID, and order date.
2. **Menu**: Menu items with corresponding prices.
3. **Members**: Information about customers who joined Danny's loyalty program.

---

## SQL Analysis and Insights

### 1. **Customer Spending**
Query to calculate total spend by each customer:
```sql
SELECT
    sales.customer_id,
    SUM(menu.price) AS total_spend
FROM dannys_diner.sales
JOIN dannys_diner.menu
ON sales.product_id = menu.product_id
GROUP BY sales.customer_id
ORDER BY customer_id;
