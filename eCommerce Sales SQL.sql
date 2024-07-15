SELECT *
 FROM ecommerce_data;

 SELECT *
 FROM us_state_long_lat_codes;

 -- 1. Total revenue

 SELECT ROUND(SUM(sales_per_order), 2) as total_revenue
 FROM ecommerce_data;

 -- 2. Total Profit
 SELECT ROUND(SUM(profit_per_order), 2) as total_profit
 FROM ecommerce_data;

 -- 3. Revenue by year
 SELECT Year(order_date) as fiscal_year, ROUND(SUM(sales_per_order), 2) as total_yearly_revenue
 FROM ecommerce_data
 GROUP BY Year(order_date)
 ORDER BY fiscal_year DESC;

 -- 4. Yearly revenue percent change
 WITH cte_2022 AS
	 (SELECT Year(order_date) as fiscal_year, ROUND(SUM(sales_per_order), 2) as total_yearly_revenue
	 FROM ecommerce_data
	 WHERE Year(order_date) = 2022
	 GROUP BY Year(order_date)),
cte_2021 AS
	(SELECT Year(order_date) as fiscal_year, ROUND(SUM(sales_per_order), 2) as total_yearly_revenue
	 FROM ecommerce_data
	 WHERE Year(order_date) = 2021
	 GROUP BY Year(order_date))
SELECT cte_2022.fiscal_year,
       cte_2022.total_yearly_revenue AS revenue_2022,
	   cte_2021.fiscal_year,
       cte_2021.total_yearly_revenue AS revenue_2021,
       ROUND(((cte_2022.total_yearly_revenue - cte_2021.total_yearly_revenue)
	   /cte_2021.total_yearly_revenue)*100, 2) AS revenue_percent_change
from cte_2022
JOIN cte_2021 ON cte_2022.fiscal_year = cte_2021.fiscal_year;


-- 5. Profit by year
SELECT Year(order_date) as fiscal_year, ROUND(SUM(profit_per_order), 2) as total_yearly_profit
 FROM ecommerce_data
 GROUP BY Year(order_date);

-- 6. Profit yearly percent change
WITH cte_2022 AS
	(SELECT Year(order_date) as fiscal_year, ROUND(SUM(profit_per_order), 2) as total_yearly_profit
	 FROM ecommerce_data
	 WHERE Year(order_date) = 2022
	 GROUP BY Year(order_date)),
cte_2021 AS
	(SELECT Year(order_date) as fiscal_year, ROUND(SUM(profit_per_order), 2) as total_yearly_profit
	 FROM ecommerce_data
	 WHERE Year(order_date) = 2021
	 GROUP BY Year(order_date))
SELECT cte_2022.fiscal_year, cte_2022.total_yearly_profit,
		cte_2021.fiscal_year, cte_2021.total_yearly_profit,
		ROUND(((cte_2022.total_yearly_profit - cte_2021.total_yearly_profit)
		/cte_2021.total_yearly_profit)*100, 2) AS profit_percent_change
FROM cte_2022
JOIN cte_2021 ON cte_2022.fiscal_year = cte_2021.fiscal_year;

 -- 7. Average order value
 SELECT ROUND(SUM(sales_per_order)/COUNT(order_id), 2) AS avg_order_value
 FROM ecommerce_data;

 -- 8. Average order quantity
 SELECT (SUM(order_quantity)/COUNT(order_id)) AS avg_order_quantity
 FROM ecommerce_data;
 
 -- 9. Average profit per order
 SELECT ROUND(SUM(profit_per_order)/COUNT(order_id), 2) AS avg_profit_per_order
 FROM ecommerce_data;

 -- 10 Top 5 bestselling products
 SELECT TOP 5 product_name, ROUND(SUM(sales_per_order), 2) AS revenue_per_product
 FROM ecommerce_data
 GROUP BY product_name
 ORDER BY revenue_per_product DESC;

 -- 11. 5 worst selling products
 SELECT TOP 5 product_name, ROUND(SUM(sales_per_order), 2) AS revenue_per_product
 FROM ecommerce_data
 GROUP BY product_name
 ORDER BY revenue_per_product;

 -- 12. Bestselling category
 SELECT category_name, ROUND(SUM(sales_per_order), 2) AS revenue_per_category
 FROM ecommerce_data
 GROUP BY category_name
 ORDER BY revenue_per_category DESC;

 -- 13. Bestselling region
 SELECT customer_region AS region, ROUND(SUM(sales_per_order), 2) AS revenue_per_region
 FROM ecommerce_data
 GROUP BY customer_region
 ORDER BY revenue_per_region DESC;

  -- 14. Top 5 bestselling states
 SELECT Top 5 customer_state AS state, ROUND(SUM(sales_per_order), 2) AS revenue_per_state
 FROM ecommerce_data
 GROUP BY customer_state
 ORDER BY revenue_per_state DESC;

  -- 15. Top 5 worst selling states
 SELECT Top 5 customer_state AS state, ROUND(SUM(sales_per_order), 2) AS revenue_per_state
 FROM ecommerce_data
 GROUP BY customer_state
 ORDER BY revenue_per_state;

 -- 16 Top 5 most profitable products
 SELECT TOP 5 product_name AS product, ROUND(SUM(profit_per_order), 2) AS profit
 FROM ecommerce_data
 GROUP BY product_name
 ORDER BY profit DESC;

 -- 17. 5 least profitable products
 SELECT TOP 5 product_name AS product, ROUND(SUM(profit_per_order), 2) AS profit
 FROM ecommerce_data
 GROUP BY product_name
 ORDER BY profit;

 -- 18. profit by category
 SELECT TOP 5 category_name AS category, ROUND(SUM(profit_per_order), 2) AS profit
 FROM ecommerce_data
 GROUP BY category_name
 ORDER BY profit DESC;

 -- 19 highest spending customers
 SELECT TOP 10 CONCAT(customer_first_name, ' ', customer_last_name) as customer_name,
 ROUND(SUM(sales_per_order), 2) AS revenue_per_customer
 FROM ecommerce_data
 GROUP BY CONCAT(customer_first_name, ' ', customer_last_name)
 ORDER BY revenue_per_customer DESC;

 -- 20. Highest grossing months
 SELECT DATEPART(MONTH, order_date) month_number, DATENAME(MONTH, order_date) AS month,
 ROUND(SUM(sales_per_order), 2) AS revenue
 FROM ecommerce_data
 GROUP BY DATENAME(MONTH, order_date), DATEPART(MONTH, order_date)
 ORDER BY month_number;


 -- 21. Relationship between order and delivery 
  SELECT distinct delivery_status,
  COUNT(order_id) OVER (PARTITION BY delivery_status) AS order_by_delivery_status,
 COUNT(order_id) OVER() AS total_order
 FROM ecommerce_data
 ORDER BY order_by_delivery_status DESC;



 SELECT * FROM ecommerce_data