-- SQL Retail Sales Analysis
create database sql_project_p1;

-- Create Table
drop table if exists retail_sales;
Create table sql_project_p1.retail_sales(
	transactions_id int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(15),
	age int,
	category varchar(25),
	quantiy int,	
    price_per_unit float, 
	cogs float,
	total_sale float
);

-- Check for Nulls
select * from retail_sales
where 
	transactions_id is null
    or
    sale_date is null
    or
    sale_time is null
    or
    customer_id is null
    or
    gender is null
    or
    age is null
    or
    category is null
    or
    'quantity' is null
    or
    price_per_unit is null
    or
    cogs is null
    or 
    total_sale is null;

SET SQL_SAFE_UPDATES = 0;
-- Removing the Nulls
delete from retail_sales
where 
	transactions_id is null
    or
    sale_date is null
    or
    sale_time is null
    or
    customer_id is null
    or
    gender is null
    or
    age is null
    or
    category is null
    or
    'quantity' is null
    or
    price_per_unit is null
    or
    cogs is null
    or 
    total_sale is null;
    
-- Data Exploration
    
-- Number of Sales we have
select count(*) as total_sales from retail_sales;
    
-- Number of unique customers we have
select count(distinct customer_id) as total_customers from retail_sales;

-- Number of Unique Categories Present
select distinct category as unique_categories from retail_sales;

-- Data Analysis & usiness Key Problems

-- 1) Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales
where sale_date = '2022-11-05';

-- 2) Write a SQL query to retrieve all transactions where the 
--    category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing' AND quantiy >= 4
        AND sale_date LIKE '2022-11%';

-- 3) Write a SQL query to calculate the total sales (total_sale) for each category
SELECT 
    category,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_orders
FROM
    retail_sales
GROUP BY category;

-- 4) Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    ROUND(AVG(age), 0) AS Average_Age
FROM
    retail_sales
WHERE
    category = 'Beauty';

-- 5) Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;

-- 6) Write a SQL query to find the total number of transactions (transaction_id) 
--    made by each gender in each category.
SELECT 
    gender,
    category,
    COUNT(transactions_id) AS total_transactions
FROM
    retail_sales
GROUP BY gender , category
ORDER BY category;

-- 7) Write a SQL query to calculate the average sale for each month. 
-- Find out best selling month in each year:

select year,month,Average_sale from
(
select 
	year(sale_date) as year,
    month(sale_date) as month,
    avg(total_sale) as Average_sale,
    rank() over(partition by year(sale_date) order by avg(total_sale) Desc) as `Rank`
from retail_sales
group by year,month
) as t1
where `Rank` = 1;
-- order by year,Average_sale desc;

-- 8) Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
    SUM(total_sale) AS sales, customer_id
FROM
    retail_sales
GROUP BY customer_id
ORDER BY sales DESC
LIMIT 5;

-- 9) Write a SQL query to find the 
-- number of unique customers who purchased items from each category.
SELECT 
    category, COUNT(DISTINCT (customer_id)) AS item_counter
FROM
    retail_sales
GROUP BY category;

-- 10) Write a SQL query to create each shift and  
-- number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17
with Hourly_Sale as
(
select 
	case
		when hour(sale_time)<12 then 'Morning'
        when hour(sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
	end as shift
from retail_sales
)
select 
	count(*) as Orders,shift
from Hourly_Sale
group by shift;
