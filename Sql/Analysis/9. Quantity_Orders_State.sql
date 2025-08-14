-- Quantity of orderd items  by State 

SELECT
    l.state,
    SUM(o.quantity) AS total_quantity
FROM
    orders AS o
JOIN
    location AS l ON o.location_id = l.location_id
GROUP BY
    l.state
ORDER BY
    total_quantity DESC;