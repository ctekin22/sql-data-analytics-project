--------------------------------------------------------------------------------------------------------------------
-- Step 9: Performance Analysis
-- Comparing the current value to a target value
-- Helps measure success and compare performance
-- Difference between current and target measure
-- Use of Window Functions
--------------------------------------------------------------------------------------------------------------------

-- Analyze the yearly performance of products by comparing their sales 
-- to both the average sales and the previous year' s sales

-- Create and use CTE
WITH yearly_total_sales_by_product AS (
    SELECT 
        YEAR(s.order_date) AS order_year,
        p.product_name,
        SUM(s.sales_amount) AS total_sales_amount
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p ON p.product_key = s.product_key
    WHERE s.order_date IS NOT NULL
    GROUP BY YEAR(s.order_date), p.product_name
)
SELECT *,
    AVG(total_sales_amount) OVER(PARTITION BY product_name) AS avg_year_sales,
    total_sales_amount - AVG(total_sales_amount) OVER(PARTITION BY product_name) AS totalsales_avg_diff,
    CASE 
        WHEN total_sales_amount - AVG(total_sales_amount) OVER(PARTITION BY product_name) > 0 THEN 'Above Average'
        WHEN total_sales_amount - AVG(total_sales_amount) OVER(PARTITION BY product_name) < 0 THEN 'Below Average'
        ELSE 'Average'
    END avg_change,
    -- Year-Over-Year Analysis
    total_sales_amount - LAG(total_sales_amount) OVER(PARTITION BY product_name ORDER BY order_year) AS previous_year_sales_diff,
    CASE 
        WHEN total_sales_amount - LAG(total_sales_amount) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN total_sales_amount - LAG(total_sales_amount) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END previous_year_change
FROM yearly_total_sales_by_product
--ORDER BY product_name, order_year; -- If you use the query only with aggregate function we neew to order outside the query,
                                     -- but for other window functions which requires ORDER BY it orders inside OVER 

-- Same thing as above with more explicit window fuction for average
-- PARTITION BY only ->	Total average per group
-- PARTITION BY + ORDER BY	-> Running average (by default)
-- PARTITION BY + ORDER BY + full ROWS frame ->	Total average (explicitly written)
-- Only aggregation functions use/are affected by frame clauses (ROWS, RANGE).
-- No ORDER BY	-> Entire partition → equivalent to: ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
-- With ORDER BY ->	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
/*
SELECT *,
  AVG(total_sales_amount) OVER (PARTITION BY product_name ORDER BY order_year 
  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS avg_year_sales
FROM yearly_total_sales_by_product;
*/
