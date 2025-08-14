-- This query calculates the churn rate for each product category by first
-- identifying the last product category and churn status for each customer.

WITH CustomerLastOrderDetails AS (
    -- Step 1: Find the most recent product category and order date for each customer.
    -- The ROW_NUMBER() function assigns a rank to each order, with the most
    -- recent one getting a rank of 1.
    SELECT
        o.customer_id,
        c.category AS product_category,
        o.order_date,
        ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date DESC) AS rn
    FROM
        orders AS o
    JOIN
        products_to_orders AS pto ON o.order_id = pto.order_id
    JOIN
        product_to_category AS ptc ON pto.product_id = ptc.product_id
    JOIN
        category AS c ON ptc.category_id = c.category_id
),
ChurnStatus AS (
    -- Step 2: Calculate the churn status for each customer using the most recent
    -- order date found in the previous CTE.
    SELECT
        t1.customer_id,
        t1.product_category,
        t1.order_date,
        CASE
            WHEN DATE_PART('year', AGE((SELECT MAX(order_date) FROM orders), t1.order_date)) > 0 THEN 'Churned'
            ELSE 'Not Churned'
        END AS churn_status
    FROM
        CustomerLastOrderDetails AS t1
    WHERE
        t1.rn = 1 -- We only care about the single most recent order.
)
-- Step 3: Aggregate the results to find the churn rate per product category.
SELECT
    product_category,
    COUNT(customer_id) AS total_customers,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        (SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END)::NUMERIC / COUNT(customer_id)) * 100,
        2
    ) AS churn_rate_percentage
FROM
    ChurnStatus
GROUP BY
    product_category
ORDER BY
    churn_rate_percentage DESC;
