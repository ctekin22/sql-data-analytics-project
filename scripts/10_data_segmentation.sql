--------------------------------------------------------------------------------------------------------------------
-- Step 10: Part-to-Whole Analysis
-- Analyze how an individual part is performing compared to the overall,
-- allowing us to understand which category has the greatest impact on the business
-- [Measure]/[Total Measure] * [dimention]
--------------------------------------------------------------------------------------------------------------------
-- Which category contributes the most to overall sale
-- Based on the complexity of the query you can use either CTE or subquery

-- With simple subquery
SELECT *,
    SUM(total_sales) OVER () AS overall_sale,
    CONCAT('%' ,ROUND((CAST(total_sales AS float)/SUM(total_sales) OVER ()) * 100, 2)) AS percent_contribution
FROM
    (SELECT 
        p.category,
        SUM(s.sales_amount) AS total_sales
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p ON s.product_key = p.product_key
    GROUP BY p.category)t
ORDER BY total_sales DESC

-- With CTE
WITH total_sales_by_category AS
    (SELECT 
        p.category,
        SUM(s.sales_amount) AS total_sales
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p ON s.product_key = p.product_key
    GROUP BY p.category)
SELECT *,
    SUM(total_sales) OVER () AS overall_sale,
    CONCAT('%' ,ROUND((CAST(total_sales AS float)/SUM(total_sales) OVER ()) * 100, 2)) AS percent_contribution
FROM total_sales_by_category
ORDER BY total_sales DESC
