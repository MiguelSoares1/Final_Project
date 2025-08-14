-- This query analyzes sales and order count by month for the year 2017,
-- and calculates each month's sales as a percentage of the annual total.

WITH MonthlySales AS (
    -- Step 1: Calculate the total sales and total orders for each month in 2017.
    -- Explicitly cast the SUM to a NUMERIC type to ensure consistent data types.
    SELECT
        DATE(DATE_TRUNC('month', order_date)) AS sales_month,
        SUM(sales)::NUMERIC AS total_sales,
        COUNT(DISTINCT order_id) AS total_orders
    FROM
        main_table
    WHERE
        DATE_PART('year', order_date) = 2017
    GROUP BY
        sales_month
),
AnnualTotals AS (
    -- Step 2: Calculate the grand total sales for the entire year 2017.
    -- The empty OVER() clause makes this a window function over the entire result set.
    SELECT
        sales_month,
        total_sales,
        total_orders,
        SUM(total_sales) OVER () AS annual_sales_total
    FROM
        MonthlySales
)
-- Step 3: Calculate the percentage of the annual sales for each month.
SELECT
    sales_month,
    total_sales,
    total_orders,
    -- The ROUND function is now correctly applied to the entire calculation,
    -- and the data types should be compatible.
    ROUND((total_sales / annual_sales_total) * 100, 1) AS percentage_of_year
FROM
    AnnualTotals
ORDER BY
    sales_month;
