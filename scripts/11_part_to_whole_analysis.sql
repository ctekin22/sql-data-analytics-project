--------------------------------------------------------------------------------------------------------------------
-- Step 11: Data Segmentation Analysis
-- Group the data based on a specific range
-- Helps understand the correlation between two measures
-- Measere by Measure
-- Introducing a new segment/category/dimension based on measure and 
-- then aggregating another measure based on this new category/dimension/segment
-- Use of CASE WHEN STATEMENTS
-- Convert measure to dimension
--------------------------------------------------------------------------------------------------------------------
-- Segment products into cost ranges and count how many products fall into each segment
-- MAX cost 2171, MIN cost 1
-- Convert measure to dimention -> cost to dimention

SELECT 
    MAX(cost),
    MIN(cost)
FROM gold.dim_products
WHERE cost != 0;

-- Cost segmentation
WITH cost_segment AS(
SELECT 
    product_name,
    cost,
    CASE 
        WHEN cost < 100 THEN 'Below 100'
        WHEN cost BETWEEN 100 AND 500 THEN '100-500'
        WHEN cost BETWEEN 500 AND 1000 THEN '100-1000'
        WHEN cost BETWEEN 1000 AND 1500 THEN '100-1500'
        WHEN cost BETWEEN 1500 AND 2000 THEN '1500-2000'
        ELSE 'Above 2000'
    END cost_segment_range
FROM gold.dim_products
WHERE cost !=0
)
SELECT 
    cost_segment_range,
    COUNT(cost_segment_range)  AS product_count
FROM cost_segment 
GROUP BY cost_segment_range
ORDER BY product_count DESC

-- Group customers into 3 segments based on their spending behavior:
    -- VIP: At least 12 months of history and spending more than $5000
    -- Regular: At least 12 months of history but spending $5000 or less
    -- New: Lifespan less than months
-- And find the total number of customers in each group

-- CTE must be the first clause in a statement** — no SELECT, WHERE, or anything else can come before it in the same query.
-- You can use a CTE in a subquery as long as the CTE is declared at the top level of the full query.
-- You cannot define a CTE inside a subquery.
-- Define the CTE first, then use it anywhere inside that same query, including subqueries.
WITH total_sales_by_customer AS (
SELECT
    s.customer_key,
    MIN(s.order_date) AS min_order_date,
    MAX(s.order_date) AS max_order_date,
    DATEDIFF(month, MIN(s.order_date),MAX(s.order_date)) AS month_lifespan,
    SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales s 
LEFT JOIN gold.dim_customers c ON s.customer_key = c.customer_key
GROUP BY s.customer_key
)
SELECT 
  spending_behavior_segment,
  COUNT(customer_key) AS total_customer -- find the total number of customers in each group
FROM
(
SELECT 
     customer_key,
--   month_lifespan,
--   total_sales,
    CASE 
        WHEN month_lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN month_lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        WHEN month_lifespan < 12 THEN 'New'
    END spending_behavior_segment
FROM total_sales_by_customer
)t
WHERE spending_behavior_segment IS NOT NULL
GROUP BY spending_behavior_segment
ORDER BY total_customer DESC
