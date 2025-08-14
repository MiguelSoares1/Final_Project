-- This query refines the customer frequency segments based on the finding
-- that all customers are highly engaged (short-gap).

WITH CustomerOrderDates AS (
    -- Step 1: List all order dates for each customer, sorted chronologically.
    SELECT
        customer_id,
        order_date,
        LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date
    FROM
        main_table
    GROUP BY
        customer_id, order_date
),
OrderGaps AS (
    -- Step 2: Calculate the time difference (in days) between consecutive orders.
    SELECT
        customer_id,
        DATE_PART('day', AGE(order_date, previous_order_date)) AS days_between_orders
    FROM
        CustomerOrderDates
    WHERE
        previous_order_date IS NOT NULL
),
CustomerAvgGaps AS (
    -- Step 3: Find the average of these time differences for each individual customer.
    SELECT
        customer_id,
        ROUND(AVG(days_between_orders)) AS avg_days_between_orders
    FROM
        OrderGaps
    GROUP BY
        customer_id
)
-- Step 4: Segment customers into refined frequency groups and count them.
SELECT
    CASE
        WHEN avg_days_between_orders <= 7 THEN 'Very Frequent (Weekly)'
        WHEN avg_days_between_orders > 7 AND avg_days_between_orders <= 14 THEN 'Frequent (Bi-Weekly)'
        WHEN avg_days_between_orders > 14 AND avg_days_between_orders <= 29 THEN 'Regular (Monthly)'
        ELSE 'Other' -- This category should be empty based on your findings.
    END AS customer_frequency_segment,
    COUNT(customer_id) AS customer_count,
    ROUND(AVG(avg_days_between_orders)) AS avg_gap_for_segment
FROM
    CustomerAvgGaps
GROUP BY
    customer_frequency_segment
ORDER BY
    customer_count DESC;
