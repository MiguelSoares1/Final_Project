SELECT
    -- Sums the 'profit' column and casts it to NUMERIC before rounding.
    ROUND(SUM(profit)::numeric) AS total_profit,

    -- Sums the 'sales' column and casts it to NUMERIC before rounding.
    ROUND(SUM(sales)::numeric) AS total_sales,

    -- Counts the number of unique order IDs.
    COUNT(DISTINCT order_id) AS total_orders
FROM
    orders;

