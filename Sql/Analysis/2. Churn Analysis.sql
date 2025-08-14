-- This query calculates the cumulative churn rate for each yearly customer cohort.
-- It has been refactored to resolve the "aggregate function calls cannot be nested" error.

WITH CustomerFirstOrder AS (
    -- Step 1: Find the year of the very first order for each customer.
    -- This defines their customer cohort.
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date,
        EXTRACT(YEAR FROM MIN(order_date)) AS cohort_year
    FROM
        orders
    GROUP BY
        customer_id
),
CustomerLastOrder AS (
    -- Step 2 (NEW): Find the most recent order date for each customer.
    -- We need this to determine their churn status.
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date
    FROM
        orders
    GROUP BY
        customer_id
),
ChurnStatus AS (
    -- Step 3 (NEW): Join the first and last order dates to determine churn status per customer.
    -- A customer is churned if their last order was more than a year ago.
    SELECT
        cfo.customer_id,
        cfo.cohort_year,
        CASE
            WHEN DATE_PART('year', AGE((SELECT MAX(order_date) FROM orders), clo.last_order_date)) > 0 THEN 1
            ELSE 0
        END AS is_churned
    FROM
        CustomerFirstOrder AS cfo
    JOIN
        CustomerLastOrder AS clo ON cfo.customer_id = clo.customer_id
)
-- Step 4: Aggregate the results by cohort year to get the totals.
SELECT
    acquisition_year,
    COUNT(customer_id) AS new_customers,
    SUM(SUM(is_churned)) OVER (ORDER BY acquisition_year) AS cumulative_churned,
    SUM(COUNT(customer_id)) OVER (ORDER BY acquisition_year) AS cumulative_customers,
    ROUND(
        (SUM(SUM(is_churned)) OVER (ORDER BY acquisition_year)::NUMERIC /
         SUM(COUNT(customer_id)) OVER (ORDER BY acquisition_year)) * 100,
        2
    ) AS cumulative_churn_rate_percentage
FROM
    (
        SELECT
            cohort_year AS acquisition_year,
            customer_id,
            is_churned
        FROM
            ChurnStatus
    ) AS a
GROUP BY
    acquisition_year
ORDER BY
    acquisition_year;
