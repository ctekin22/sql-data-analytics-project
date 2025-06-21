--------------------------------------------------------------------------------------------------------------------
-- Step 6: Ranking
-- Order the values of dimentions by measure
-- Top N Performers | Bottom  N Performers 
-- There are 2 ways for ranking in SQL; GROUP BY with TOP and Window Functions (RANK, DENSE_RANK, ROW_NUMBER)
-- Use window functions for more flexible and complex queries with extra details.
--------------------------------------------------------------------------------------------------------------------
-- Which 5 products generate the highest revenue
SELECT TOP 5
    s.product_key,
    p.product_name,
    SUM(s.sales_amount) AS sales_amount
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p  ON p.product_key = s.product_key
GROUP BY  s.product_key, p.product_name
ORDER BY  sales_amount DESC;

-- Window Function version-1 - ROW_NUMBER
SELECT TOP 5
    s.product_key,
    p.product_name,
    SUM(s.sales_amount) AS total_revenue,
    ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS sales_amount_rank
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p ON p.product_key = s.product_key
GROUP BY  s.product_key, p.product_name

-- Window Function version-2 - ROW_NUMBER
SELECT *
FROM
    (SELECT
        s.product_key,
        p.product_name,
        SUM(s.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS sales_amount_rank
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p ON p.product_key = s.product_key
    GROUP BY  s.product_key, p.product_name)t
WHERE sales_amount_rank <= 5;

-- Window Function version-3 - RANK
SELECT *
FROM
    (SELECT
        s.product_key,
        p.product_name,
        SUM(s.sales_amount) AS total_revenue,
        RANK() OVER(ORDER BY SUM(s.sales_amount) DESC) AS sales_amount_rank
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p ON p.product_key = s.product_key
    GROUP BY  s.product_key, p.product_name)t
WHERE sales_amount_rank <= 5

-- Find the top customers who have generated the highest revenue -1
SELECT TOP 1
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(s.sales_amount) AS total_revenue,
    ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS total_revenue_rank
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c ON s.customer_key = c.customer_key
GROUP BY  c.customer_key, c.first_name, c.last_name

-- Find the Top-10 customers who have generated the highest revenue 
-- Find the  3 costumers with the fewest orders placed
SELECT *
FROM
    (SELECT
        c.customer_key,
        c.first_name,
        c.last_name,
        SUM(s.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS total_revenue_rank
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_customers c ON s.customer_key = c.customer_key
    GROUP BY  c.customer_key, c.first_name, c.last_name)t
WHERE total_revenue_rank <=10;

-- Find the 3 costumers with the fewest orders placed
SELECT *
FROM
    (SELECT
        c.customer_key,
        c.first_name,
        c.last_name,
        COUNT(DISTINCT s.order_number) AS total_order,
        ROW_NUMBER() OVER(ORDER BY COUNT(s.order_number) ASC) AS total_order_rank
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_customers c ON s.customer_key = c.customer_key
    GROUP BY  c.customer_key, c.first_name, c.last_name)t
WHERE total_order_rank<=3;

-- What are the worst-performing products in terms of sales?
SELECT TOP 5
    s.product_key,
    p.product_name,
    SUM(s.sales_amount) AS sales_amount
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p  ON p.product_key = s.product_key
GROUP BY  s.product_key, p.product_name
ORDER BY  sales_amount ASC;

