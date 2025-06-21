--------------------------------------------------------------------------------------------------------------------
-- Step 3: Date Exploration
-- Identfy the earliest and latest dates (boundaries)
-- Understand the scope of data and the timespan
--------------------------------------------------------------------------------------------------------------------
-- Find the date of the first and last order
SELECT MIN(order_date) AS first_order_date, MAX(order_date) AS last_order_date 
FROM gold.fact_sales;

-- How many years of sales available
SELECT ABS(DATEDIFF(year, MAX(order_date),MIN(order_date))) 
FROM gold.fact_sales;

-- Find youngest and oldest customer
SELECT 
MIN(birthdate) AS youngest_birthdate, 
MAX(birthdate) AS oldest_birthdate
FROM gold.dim_customers;

-- Find age of youngest and oldest customer
SELECT 
DATEDIFF(year,MIN(birthdate), GETDATE()) AS youngest_age, 
DATEDIFF(year,MAX(birthdate), GETDATE()) AS oldest_age 
FROM gold.dim_customers;
