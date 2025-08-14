WITH CustomerAcquisition AS (
    -- This CTE finds the earliest order date for each unique customer and includes their segment.
    SELECT
        c.customer_id,
        s.segment,
        MIN(o.order_date) AS acquisition_date
    FROM
        customer AS c
    JOIN
        orders AS o ON c.customer_id = o.customer_id
    JOIN
        segment AS s ON c.segment_id = s.segment_id
    GROUP BY
        c.customer_id, s.segment
),
YearlyNewCustomers AS (
    -- This CTE counts the number of new customers for each year and segment.
    SELECT
        EXTRACT(YEAR FROM acquisition_date) AS acquisition_year,
        segment,
        COUNT(customer_id) AS new_customers_count
    FROM
        CustomerAcquisition
    GROUP BY
        acquisition_year,
        segment
)
-- This final SELECT statement compares each year's new customer count to the first year's count for that segment.
SELECT
    acquisition_year,
    segment,
    new_customers_count,
    -- This window function finds the count for the first year for each segment.
    FIRST_VALUE(new_customers_count) OVER (PARTITION BY segment ORDER BY acquisition_year) AS first_year_count,
    ROUND(
        (new_customers_count::NUMERIC / FIRST_VALUE(new_customers_count) OVER (PARTITION BY segment ORDER BY acquisition_year)) * 100,
        2
    ) AS percentage_of_first_year
FROM
    YearlyNewCustomers
ORDER BY
    segment,
    acquisition_year;
