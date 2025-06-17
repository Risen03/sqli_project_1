-- create database
CREATE DATABASE sql_project_1;


-- create a table 
CREATE TABLE retail_sales(
		transactions_id INT PRIMARY KEY,
        sale_date DATE,
        sale_time TIME,	
        customer_id INT,
        gender VARCHAR(15),
        age INT,
        category VARCHAR(15),
        quantiy INT,	
        price_per_unit FLOAT,
        cogs FLOAT,	
        total_sale FLOAT
);

SELECT *  FROM retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;



UPDATE retail_sales
SET quantiy = NULL, price_per_unit = NULL,cogs=NULL, total_sale = NULL
WHERE transactions_id = 1010;

-- DATA CLEANSING
DELETE FROM retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

-- DATA EXPLORATION
-- HOW MANY SALES WE HAVE
SELECT COUNT(*) AS TOTAL_SALES FROM retail_sales;

-- HOW MANY CUSTOMERS WE HAVE
SELECT COUNT(DISTINCT customer_id) AS TOTAL_CUSTOMERS FROM retail_sales;

-- HOW MANY CATEGORY WE HAVE
SELECT DISTINCT category AS TOTAL_CUSTOMERS FROM retail_sales;


-- Data Analysis & Business Key Problems & Answers\

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE 
	category = 'clothing' 
    AND
    quantiy >= 4
    AND 
	sale_date LIKE '2022-11-__';
    
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category, 
    SUM(total_sale) AS Total_sale
FROM retail_sales
GROUP BY 1;

USE sql_project_1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	category, 
    ROUND(AVG(age), 2) AS Average
    FROM retail_sales
WHERE category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT COUNT(*) FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	category,
	gender,
    COUNT(*) AS total_transaction
FROM retail_sales
GROUP BY 
	category,
	gender
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	YEAR,
    MONTH,
    avg_sale  FROM 
(SELECT 
	YEAR(sale_date) AS YEAR,
    MONTH(sale_date) AS MONTH,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as BEST_SELLING_MONTH
   FROM retail_sales
  GROUP BY 1, 2
)as t1
WHERE BEST_SELLING_MONTH = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id, SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
 category,
 COUNT(DISTINCT customer_id)
 FROM retail_sales
 GROUP BY category;
 
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift