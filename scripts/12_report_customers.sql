--------------------------------------------------------------------------------------------------------------------
-- Step 12: Reporting 
-- Starting with fact table and joining with dimention tables to collect the necessary data in one table
-- It includes many subqueries, we will use intermediate CTEs
-- We will do some transfromation on the way
--------------------------------------------------------------------------------------------------------------------
/*
Customer Report:
    Purpose: Consolidate key customer metrics and behaviors
    Highlights:
        1. Gather essential fields such as names, ages, and transaction details.
        2. Segments customers into categories (VIP, Regular, New) and age groups.
        3. Aggregates customer-level metrics: 
            - total orders
            - total sales 
            - total quantity purchased
            - total products
            - lifespan(in months)
        4. Calculates valuables KPIs:
            - recency (months since last order)
            - average order value
            - average monthly spend
*/

WITH base_query AS(
    -- 1) Base Query: Retrive core columns from tables
    SELECT 
        s.order_number,
        s.product_key,
        s.order_date,
        s.sales_amount,
        s.quantity,
        c.customer_key,
        customer_number,
        CONCAT(first_name, ' ', c.last_name) as customer_name,
        DATEDIFF(year,c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_customers c ON s.customer_key = c.customer_key
    WHERE order_date IS NOT NULL
    )
-- 2. Segments customers into categories (VIP, Regular, New) and age groups.
-- 3. Aggregates customer-level metrics
-- Which data can be aggregated
, customer_aggregation AS ( -- Creating another CTE, nested CTE
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key)  AS total_products,
    MAX(order_date) AS last_order_date,
    DATEDIFF(month, MIN(order_date),MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
    customer_key,
    customer_number,
    customer_name,
    age
)
-- 4. Calculates valuables KPIs
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
     CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END age_segment,
    CASE 
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        WHEN lifespan < 12 THEN 'New'
    END spending_behavior_segment,
    total_sales,
    total_quantity,
    total_products,
    last_order_date,
    DATEDIFF(month, last_order_date, GETDATE()) AS recency,  -- shows if costumer still actively ordering
    lifespan,
    CASE 
        WHEN total_orders != 0 THEN total_sales/total_orders -- Average order value
        ELSE 0
    END AS avg_order_value,
    CASE 
        WHEN lifespan != 0 THEN total_sales/lifespan -- Average  monthly spend 
        ELSE total_sales
    END AS avg_monthly_spend 
FROM customer_aggregation;

--------------------------------------------------------------------------------------------------------------------
-- FINAL: CREATE VIEW and put to database so everyone can use this information for their purpose
-- Data Analist can use to create dashboard to visualize tje data (Tableau, Power BI)
--------------------------------------------------------------------------------------------------------------------

CREATE VIEW gold.report_customers AS 
    WITH base_query AS(
        SELECT 
            s.order_number,
            s.product_key,
            s.order_date,
            s.sales_amount,
            s.quantity,
            c.customer_key,
            customer_number,
            CONCAT(first_name, ' ', c.last_name) as customer_name,
            DATEDIFF(year,c.birthdate, GETDATE()) AS age
        FROM gold.fact_sales s
        LEFT JOIN gold.dim_customers c ON s.customer_key = c.customer_key
        WHERE order_date IS NOT NULL
        )
    , customer_aggregation AS ( 
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key)  AS total_products,
        MAX(order_date) AS last_order_date,
        DATEDIFF(month, MIN(order_date),MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY 
        customer_key,
        customer_number,
        customer_name,
        age
    )
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        CASE 
            WHEN age < 20 THEN 'Under 20'
            WHEN age BETWEEN 20 AND 29 THEN '20-29'
            WHEN age BETWEEN 30 AND 39 THEN '30-39'
            WHEN age BETWEEN 40 AND 49 THEN '40-49'
            ELSE '50 and above'
        END age_segment,
        CASE 
            WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
            WHEN lifespan < 12 THEN 'New'
        END spending_behavior_segment,
        total_sales,
        total_quantity,
        total_products,
        last_order_date,
        DATEDIFF(month, last_order_date, GETDATE()) AS recency, 
        lifespan,
        CASE 
            WHEN total_orders != 0 THEN total_sales/total_orders 
            ELSE 0
        END AS avg_order_value,
        CASE 
            WHEN lifespan != 0 THEN total_sales/lifespan 
            ELSE total_sales
        END AS avg_monthly_spend 
    FROM customer_aggregation

-- SELECT * FROM gold.report_customers
