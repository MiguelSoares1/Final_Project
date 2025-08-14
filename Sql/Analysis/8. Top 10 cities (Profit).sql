-- Top 10 cities with most Profit
SELECT 
    l.city,
    ROUND(SUM(o.profit)) AS total_profit
FROM
    orders AS o
JOIN
    location AS l ON o.location_id = l.location_id
GROUP BY
    l.city
ORDER BY
    total_profit DESC
LIMIT 10;
