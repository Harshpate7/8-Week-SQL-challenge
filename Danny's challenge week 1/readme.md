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
```
### 2. **Frequency of Visits**
Query to count the number of unique visits for each customer:
```sql
SELECT 
    customer_id,
    COUNT(DISTINCT order_date) AS visit_count
FROM dannys_diner.sales
GROUP BY customer_id
ORDER BY customer_id;
```

### 3. **First Purchased Item**
Query to identify the first product purchased by each customer:

```sql
SELECT 
    ranked_orders.customer_id,
    ranked_orders.product_name
FROM (
    SELECT 
        sales.customer_id,
        menu.product_name,
        ROW_NUMBER() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) AS rn
    FROM dannys_diner.sales
    LEFT JOIN dannys_diner.menu
    ON sales.product_id = menu.product_id
) AS ranked_orders
WHERE rn = 1;
```

### 4. **Most Popular Items**
Query to find the most frequently purchased products:

```sql
SELECT
    menu.product_name,
    COUNT(menu.product_id) AS purchase_count
FROM dannys_diner.sales
JOIN dannys_diner.menu
ON sales.product_id = menu.product_id
GROUP BY menu.product_name
ORDER BY purchase_count DESC;
```

### 5. **Top Products by Customer**
Query to get the most purchased product for each customer:

```sql
SELECT 
    ranked_orders.customer_id,
    ranked_orders.product_name
FROM (
    SELECT 
        sales.customer_id,
        menu.product_name,
        COUNT(sales.product_id) AS purchase_count,
        RANK() OVER (PARTITION BY sales.customer_id ORDER BY COUNT(menu.product_name) DESC) AS rn
    FROM dannys_diner.sales
    LEFT JOIN dannys_diner.menu
    ON sales.product_id = menu.product_id
    GROUP BY sales.customer_id, menu.product_name
) AS ranked_orders
WHERE rn = 1;
```

### 6. **First Purchase After Joining**
Query to find the first purchase made by loyalty members after joining the program:
```sql
SELECT 
    sales.customer_id,
    menu.product_name,
    sales.order_date,
    members.join_date
FROM sales
JOIN menu ON sales.product_id = menu.product_id
JOIN members ON sales.customer_id = members.customer_id
WHERE sales.order_date = (
    SELECT MIN(order_date)
    FROM sales AS sub_sales
    WHERE 
        sub_sales.customer_id = sales.customer_id
        AND sub_sales.order_date >= members.join_date
)
ORDER BY sales.order_date;
```

### 7. **Points Calculation**
Query to calculate loyalty points for purchases:
```sql
WITH customer_points AS (
    SELECT 
        sales.customer_id,
        menu.product_name,
        menu.price,
        CASE  
            WHEN product_name = 'sushi' THEN price * 20
            ELSE price * 10
        END AS points
    FROM sales
    JOIN menu
    ON sales.product_id = menu.product_id
)
SELECT 
    customer_points.customer_id,
    SUM(points) AS total_points
FROM customer_points
GROUP BY customer_points.customer_id
ORDER BY customer_id;
```

## Tools and Technologies
- SQL: To query and analyze the datasets.
- PostgreSQL: The database environment used for executing queries.

## Key Takeaways

- Customer spending patterns show key trends in revenue generation.
- Loyalty programs drive significant value, especially through high-reward items like sushi.
- Menu insights help prioritize the most popular and profitable items for better inventory and marketing strategies.



