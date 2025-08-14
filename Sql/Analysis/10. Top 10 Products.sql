-- This query identifies the top 10 products with the highest total sales.
-- It joins the `orders` and `product` tables and aggregates the sales
-- to rank the best-performing products by revenue.

SELECT
    p.product_name,
    ROUND(SUM(o.sales)) AS total_sales
FROM
    orders AS o
JOIN
    products_to_orders AS pto ON o.order_id = pto.order_id
JOIN
    product AS p ON pto.product_id = p.product_id
GROUP BY
    p.product_name
ORDER BY
    total_sales DESC
LIMIT 10;
