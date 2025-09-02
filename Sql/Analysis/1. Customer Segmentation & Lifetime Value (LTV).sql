-- Customer Segmentation & Lifetime Value (LTV):
-- •Business Problem: The company needs to understand its customer base better to create targeted marketing campaigns. 



WITH CustomerOrderGaps AS (
    WITH CustomerOrderDates AS (
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
        SELECT
            customer_id,
            DATE_PART('day', AGE(order_date, previous_order_date)) AS days_between_orders
        FROM
            CustomerOrderDates
        WHERE
            previous_order_date IS NOT NULL
    )
    SELECT
        customer_id,
        ROUND(AVG(days_between_orders)) AS avg_days_between_orders
    FROM
        OrderGaps
    GROUP BY
        customer_id
),
CustomerSales AS (
    SELECT
        customer_id,
        ROUND(SUM(sales)) AS total_sales
    FROM
        main_table
    GROUP BY
        customer_id
),
CustomerSegmentation AS (
    SELECT
        cs.customer_id,
        cs.total_sales,
        CASE
            -- Segment 1: High-Value (top 50%) AND Frequent Shoppers
            WHEN NTILE(2) OVER (ORDER BY cs.total_sales DESC) = 1
                 AND cog.avg_days_between_orders < (SELECT AVG(avg_days_between_orders) FROM CustomerOrderGaps) THEN 'High-Value & Frequent'
            -- Segment 2: High-Value (top 50%) ONLY
            WHEN NTILE(2) OVER (ORDER BY cs.total_sales DESC) = 1 THEN 'High-Value'
            -- Segment 3: Frequent Shoppers ONLY (in the bottom 50% by sales)
            WHEN cog.avg_days_between_orders < (SELECT AVG(avg_days_between_orders) FROM CustomerOrderGaps) THEN 'Frequent Shopper'
            -- Segment 4: The rest
            ELSE 'Other'
        END AS customer_segment
    FROM
        CustomerSales AS cs
    LEFT JOIN
        CustomerOrderGaps AS cog ON cs.customer_id = cog.customer_id
SELECT
    customer_segment,
    COUNT(customer_id) AS customer_count,
    ROUND(CAST(COUNT(customer_id) AS NUMERIC) * 100 / SUM(COUNT(customer_id)) OVER (), 1) AS customer_percentage,
    SUM(total_sales) AS total_ltv
FROM
    CustomerSegmentation
GROUP BY
    customer_segment
ORDER BY
    total_ltv DESC;
