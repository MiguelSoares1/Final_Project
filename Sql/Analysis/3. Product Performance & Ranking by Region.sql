SELECT
    state,
    category,
    ROUND(SUM(sales)) AS total_sales,
    ROUND(SUM(profit)) AS total_profit,
    ROUND(SUM(profit) * 100.0 / SUM(sales), 2) AS profit_margin_percentage
FROM
    main_table
WHERE
    DATE_PART('Year', order_date) = 2017
GROUP BY
    state,
    category
ORDER BY
    state,
    category;
