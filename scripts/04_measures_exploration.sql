--------------------------------------------------------------------------------------------------------------------
-- Step 4: Measure Exploration
-- Calculate the key metric of the business (Big Numbers)
-- Highest Level of Aggregation | Lowest Level of Details
--------------------------------------------------------------------------------------------------------------------
-- Find the Total Sales
SELECT 
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- Find how many items are sold
SELECT 
    SUM(quantity) AS total_items_sold
FROM gold.fact_sales;

-- Find the Average selling price
SELECT 
    SUM(sales_amount)/SUM(quantity) AS average_selling_price
FROM gold.fact_sales;

SELECT 
    AVG(price) AS average_selling_price
FROM gold.fact_sales;

-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales; -- 60398
SELECT  COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales; -- 27659, different product ordered in one order.

-- Find the Total number of products
SELECT COUNT(product_key) AS total_products FROM gold.dim_products;
SELECT COUNT(DISTINCT product_key) AS total_products FROM gold.dim_products;


-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_ordered_customers  -- Eliminating multiple orders from same customer
FROM gold.fact_sales;

-- Generate a report that shows all key metrics of the business
SELECT 'Total_Sales' AS measure_name, SUM(sales_amount) AS measure_value 
FROM gold.fact_sales
UNION ALL 
SELECT 'Total_Quantity' AS measure_name, SUM(quantity) AS measure_value 
FROM gold.fact_sales
UNION ALL
SELECT 'Average_Price' AS measure_name, AVG(price) AS measure_value 
FROM gold.fact_sales
UNION ALL
SELECT 'Total_Number_Orders' AS measure_name, COUNT(DISTINCT(order_number)) AS measure_value 
FROM gold.fact_sales
UNION ALL
SELECT 'Total_Number_Products' AS measure_name, COUNT(product_name) AS measure_value 
FROM gold.dim_products
UNION ALL
SELECT 'Total_Number_Customers' AS measure_name, COUNT(customer_key) AS measure_value 
FROM gold.dim_customers
