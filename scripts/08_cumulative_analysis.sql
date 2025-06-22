
--------------------------------------------------------------------------------------------------------------------
-- Step 8: Cumulative Analysis
-- Aggregate data progressively over time
-- Helps to understand whether our business is growing or declining
-- Cumulative measure by date dimention
-- Use of Window Functions
--------------------------------------------------------------------------------------------------------------------
-- Calculate the total sales per month and the running total of sales over time
-- Add each row's value to the sum of all the previous rows' values
-- DEFAULT Window frame for window function SUM() OVER() is BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- UNBOUNDED PRECEDING means all the values before current row
-- Windowed functions can only appear in the SELECT or ORDER BY clauses

SELECT 
    sales_per_month,
    total_sales,
    SUM(total_sales) OVER(ORDER BY sales_per_month) AS cumulative_sales_by_month
FROM
    (SELECT 
    DATETRUNC(month, order_date) AS sales_per_month,
    SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date))t

-- Cumulative by year - 1 
SELECT 
    sales_per_year,
    total_sales,
    SUM(total_sales) OVER(ORDER BY sales_per_year) AS cumulative_sales_by_year
FROM
    (SELECT 
    DATETRUNC(year, order_date) AS sales_per_year,
    SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date))t

-- Only gets same value from total_sales because each month is a window now
SELECT 
    sales_per_month,
    total_sales,
    SUM(total_sales) OVER(PARTITION BY sales_per_month ORDER BY sales_per_month) AS cumulative_sales_by_month
FROM
    (SELECT 
    DATETRUNC(month, order_date) AS sales_per_month,
    SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date))t

-- Cumulative everage price per year
SELECT 
    sales_per_year,
    total_sales,
    SUM(total_sales) OVER(ORDER BY sales_per_year) AS cumulative_sales_by_year,
    avg_price,
    SUM(avg_price) OVER(ORDER BY sales_per_year) AS cumulative_avg_price_by_year
FROM
    (SELECT 
    DATETRUNC(year, order_date) AS sales_per_year,
    SUM(sales_amount) AS total_sales,
    AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date))t;
