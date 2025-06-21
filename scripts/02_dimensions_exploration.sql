--------------------------------------------------------------------------------------------------------------------
-- Step 2: Explore the Dimensions
-- Identfy the unique values/catagories in each dimention. 
-- That helps recognizing how data might be grouped for later analysis.
--------------------------------------------------------------------------------------------------------------------
-- Explore All Countries where customers come from
SELECT DISTINCT country FROM gold.dim_customers;

-- Explore All Categories "The major Divisions"
SELECT DISTINCT category, subcategory, product_name 
FROM gold.dim_products
ORDER BY 1,2,3;
