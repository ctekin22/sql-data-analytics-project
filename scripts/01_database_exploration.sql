--===================================================================================================================
-- DATA ANALYTICS - EXPLANATORY DATA ANALYSIS(EDA)
--===================================================================================================================

/*
    Before starting any data analytics we first will decide which colums are dimention and which ones are measure
    Not Numeric?:
        Dimention: Catagory, Product, birthdate, id etc. We nee them to group the data
    Numeric and make sense to aggregate?: 
        Measure/Fact: Sales, Quantity, Age, etc. We need them actual calculations.
    
    -- Step 1: Explore the database
    -- Step 2: Explore the Dimensions
    -- Step 3: Date Exploration
    -- Step 4: Measure Exploration
    -- Step 5: Magnitude Analysis
    -- Step 6: Ranking
*/
--------------------------------------------------------------------------------------------------------------------
-- Step 1: Explore the database
--------------------------------------------------------------------------------------------------------------------
-- Explore All objects in the database
USE DataWarehouseAnalytics;

SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Explore All Columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='dim_customers';
