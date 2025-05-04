CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,	
				sale_time TIME,	
				customer_id	INT,
				gender VARCHAR(15),	
				age	INT,
				category VARCHAR(15),	 	
				quantiy	INT,
				price_per_unit FLOAT,	
				cogs FLOAT,	
				total_sale FLOAT

			)


SELECT * FROM retail_sales
LIMIT 10

SELECT 	
	COUNT(*)
FROM retail_sales



SELECT * FROM retail_sales
WHERE 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR		
	total_sale IS NULL

	DELETE FROM retail_sales
	WHERE 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR		
	total_sale IS NULL

-- What is the sum of sales?

SELECT SUM(total_sale)
FROM retail_sales

-- How many customers are there?
SELECT MAX (customer_id) 
FROM retail_sales
--OR
SELECT COUNT (DISTINCT customer_id) as total_customers
FROM retail_sales

--What are the categories?
SELECT DISTINCT category as dis_categories
FROM retail_sales

-- Data Analysis & Business Key Problems

--1. What are the sales made on 2022-11-05?

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'

--2. All transactions where the category is clothing and the quantity sold is more than or equal to 4 in the month of nov - 22

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4

--3. Calculate the total sales for each category
SELECT 
	category,
	SUM(total_sale) AS net_sales,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1


--4. Find the avg age of customers who purchased items in the beauty category
SELECT 
	ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

--5. Find all the transactions where the total_sale is greater than 1000

SELECT *
FROM retail_sales
WHERE total_sale > 1000


--6. Find the total number of transactions (id) made by each gender in each category
SELECT
category,
gender,
COUNT (transactions_id)
FROM retail_sales
GROUP BY 1,2 
ORDER BY 1,2 DESC

--7. Calculate the avg sale for each month. Find the best selling month in each year

SELECT 
	year,
	month,
	avg_sale
FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK () OVER (PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY 1,2
) as t1
WHERE rank = 1


--8. find the top 5 customers based on the highest total sales
SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5


--9. Find the number of unique customers who purchased items from each category

SELECT 
category, 
COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category


--10. Create each shift and number of orders (example morning <12, afternoon 12 & 17, Evening >17)

WITH hourly_sales
AS
(
SELECT *, 
CASE
	WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END as shift
FROM retail_sales
)
SELECT 
shift,
COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift

--End of project :))
