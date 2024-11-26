SELECT
  	sales.customer_id,sum(menu.price)
FROM dannys_diner.sales
join dannys_diner.menu
on sales.product_id = menu.product_id
group by sales.customer_id
order by customer_id
;

select 
	customer_id ,count(distinct order_date)
 from dannys_diner.sales
 group by sales.customer_id
 order by customer_id;
 
 select 
 	ranked_orders.customer_id,
    ranked_orders.product_name
 from (select 
      sales.customer_id,menu.product_name,
      row_number() over (partition by sales.customer_id order by sales.order_date) as rn
      from dannys_diner.sales
      left join dannys_diner.menu
      on sales.product_id = menu.product_id) as ranked_orders
where rn =1;
    
SELECT
  	menu.product_name,count(menu.product_id)
FROM dannys_diner.sales
join dannys_diner.menu
on sales.product_id = menu.product_id
group by menu.product_name;

 select 
 	ranked_orders.customer_id,
    ranked_orders.product_name
 from (select 
      sales.customer_id,menu.product_name,COUNT(sales.product_id) AS purchase_count,
      rank() over (partition by sales.customer_id order by count(menu.product_name) desc ) as rn
      from dannys_diner.sales
      left join dannys_diner.menu
      on sales.product_id = menu.product_id
      group by sales.customer_id,menu.product_name) as ranked_orders
where rn=1;

SELECT 
    sales.customer_id,
    menu.product_name,
    sales.order_date,
    members.join_date
FROM 
    sales
JOIN 
    menu ON sales.product_id = menu.product_id
JOIN 
    members ON sales.customer_id = members.customer_id
WHERE 
    sales.order_date = (
        SELECT MIN(order_date)
        FROM sales AS sub_sales
        WHERE 
            sub_sales.customer_id = sales.customer_id
            AND sub_sales.order_date >= members.join_date
    )
ORDER BY 
    sales.order_date;

SELECT 
    sales.customer_id,
    menu.product_name,
    sales.order_date,
    members.join_date
FROM 
    sales
JOIN 
    menu ON sales.product_id = menu.product_id
JOIN 
    members ON sales.customer_id = members.customer_id
WHERE 
    sales.order_date = (
        SELECT MIN(order_date)
        FROM sales AS sub_sales
        WHERE 
            sub_sales.customer_id = sales.customer_id
            AND sub_sales.order_date < members.join_date
    )
ORDER BY 
    sales.order_date;

WITH cte as (
SELECT 
   sales.customer_id,
   menu.product_name,
   menu.price
   
FROM 
    sales
JOIN 
    menu ON sales.product_id = menu.product_id
JOIN 
    members ON sales.customer_id = members.customer_id
WHERE 
    sales.order_date = (
        SELECT MIN(order_date)
        FROM sales AS sub_sales
        WHERE 
            sub_sales.customer_id = sales.customer_id
            AND sub_sales.order_date < members.join_date)
)

  
 SELECT
  	cte.customer_id,
  	count (cte.customer_id), 
  	sum(cte.price)
  FROM cte
  GROUP BY cte.customer_id;


WITH customer_points as ( 
SELECT 
	sales.customer_id,
    menu.product_name,
    menu.price,
    CASE  
    	WHEN product_name = 'sushi' then price*20
        ElSE price*10
     END as points
FROM sales
JOIN menu
on sales.product_id = menu.product_id)

SELECT 
	customer_points.customer_id,
    SUM(points)
FROM
	customer_points
GROUP BY 
	customer_points.customer_id
ORDER BY 
	customer_id;

WITH customer_points as ( 
SELECT 
	sales.customer_id,
    menu.product_name,
    menu.price,
    CASE  
    	WHEN product_name = 'sushi' and order_date < join_date  then price*20
        WHEN product_name != 'sushi' and order_date < join_date  then price*10
  		WHEN order_date>=join_date then price*20
     END as points
FROM sales
JOIN menu
on sales.product_id = menu.product_id
JOIN members
ON sales.customer_id = members.customer_id
WHERE order_date < '2021-2-1')

SELECT 
	customer_points.customer_id,
    SUM(points)
FROM
	customer_points
GROUP BY 
	customer_points.customer_id
ORDER BY 
	customer_id;