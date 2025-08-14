CREATE OR REPLACE VIEW main_table AS
SELECT
    o.order_id,
    o.order_date,
    o.ship_date,
    o.ship_mode,
    o.sales,
    o.quantity,
    o.discount,
    o.profit,
    c.customer_id,
    c.customer_name,
    s.segment,
    loc.location_id,
    loc.postal_code,
    loc.city,
    loc.state,
    loc.country,
    loc.region,
    p.product_id,
    p.product_name,
    cat.category,
    scat.sub_category
FROM
    orders AS o
JOIN
    customer AS c ON o.customer_id = c.customer_id
JOIN
    segment AS s ON c.segment_id = s.segment_id
JOIN
    location AS loc ON o.location_id = loc.location_id
JOIN
    products_to_orders AS pto ON o.order_id = pto.order_id
JOIN
    product AS p ON pto.product_id = p.product_id
JOIN
    product_to_category AS ptc ON p.product_id = ptc.product_id
JOIN
    category AS cat ON ptc.category_id = cat.category_id
JOIN
    sub_category AS scat ON cat.sub_category_id = scat.sub_category_id;

SELECT * FROM main_table


