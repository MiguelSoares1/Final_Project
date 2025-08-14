SELECT
    c.category,
    CASE
        WHEN o.discount > 0 THEN 'With Discount'
        ELSE 'Without Discount'
    END AS discount_status,
    ROUND(SUM(o.sales)) AS total_sales,
    COUNT(o.order_id) AS total_orders
FROM
    orders AS o
JOIN
    products_to_orders AS pto ON o.order_id = pto.order_id
JOIN
    product_to_category AS ptc ON pto.product_id = ptc.product_id
JOIN
    category AS c ON ptc.category_id = c.category_id
GROUP BY
    c.category,
    discount_status
ORDER BY
    c.category,
    discount_status;
