--===================================================================================================================
-- DATA ANALYTICS -> 2 - ADVANCED DATA ANALYTICS
--===================================================================================================================

/* 
    -- Step 7: Change Over Time
    -- Step 8: Cumulative Analysis
    -- Step 9: Performance Analysis
    -- Step 10: Part-to-Whole
    -- Step 11: Data Segmentation
    -- Step 12: Reporting
*/

--------------------------------------------------------------------------------------------------------------------
-- Step 7: Change Over Time
-- Trends
-- Analyze how a measure evolves over time
-- Helps track trends and identify seasonality in data
-- Aggregated measure by time
-- A high-level overview of insights that help with strategic decision making 
--------------------------------------------------------------------------------------------------------------------

-- Analyze sales performance over the year
SELECT 
    YEAR(order_date) AS order_year,
    COUNT(DISTINCT customer_key) AS total_customer,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS quantity 
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year DESC

-- Analyze sales performance over the year and months - 1
SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    COUNT(DISTINCT customer_key) AS total_customer,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS quantity 
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year DESC, order_month DESC

-- Analyze sales performance over the year and months - 2
-- One function for both month and year
SELECT
    DATETRUNC(month,order_date) AS order_date,
    COUNT(DISTINCT customer_key) AS total_customer,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS quantity 
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
ORDER BY order_date DESC

-- Truncate year
SELECT
    DATETRUNC(year,order_date) AS order_date,
    COUNT(DISTINCT customer_key) AS total_customer,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS quantity 
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(year,order_date)
ORDER BY order_date DESC

-- Truncate by year using DATETRUNC
SELECT
    DATETRUNC(year,order_date) AS order_date,
    COUNT(DISTINCT customer_key) AS total_customer,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS quantity 
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(year,order_date)
ORDER BY order_date DESC

-- FORMAT by year using FORMAT
-- Data will be string, not date, will not be sorted by month as it is done with DATETRUNC and YEAR/MONTH functions
SELECT
    FORMAT(order_date, 'yyyy-MMM') AS order_date, 
    COUNT(DISTINCT customer_key) AS total_customer,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS quantity 
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY order_date DESC 
