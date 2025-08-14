WITH SubCategoryProfit AS (
    -- Step 1: Calculate the total profit for each sub-category
    -- by joining all the necessary tables.
    SELECT
        c.category AS category,
        sc.sub_category AS sub_category,
        ROUND(SUM(o.profit)) AS total_profit
    FROM
        orders AS o
    JOIN
        products_to_orders AS pto ON o.order_id = pto.order_id
    JOIN
        product_to_category AS ptc ON pto.product_id = ptc.product_id
    JOIN
        category AS c ON ptc.category_id = c.category_id
    JOIN
        sub_category AS sc ON c.sub_category_id = sc.sub_category_id
    GROUP BY
        c.category,
        sc.sub_category
)
-- Step 2: Rank the sub-categories by profit within each category and select the top one.
SELECT
    category,
    sub_category,
    total_profit
FROM (
    SELECT
        category,
        sub_category,
        total_profit,
        -- ROW_NUMBER() assigns a unique rank, ensuring only one result
        -- is returned for each category.
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_profit DESC) AS rank_num
    FROM
        SubCategoryProfit
) AS RankedSubCategories
WHERE
    rank_num = 1
ORDER BY
    category,
    total_profit DESC;





