-- Given the table returned from the total_sales query, this query finds the difference
-- between each Monday's sales. This gives three rows with kiosk_id, date1, date2,
-- and sales_difference
-- Assuming that the total_sales query is the table, named sales, that I am selecting from
-- The columns are kiosk_id, date, sales
SELECT s1.kiosk_id, s1.date AS date1, s2.date AS date2, s2.sales - s1.sales AS sales_difference
FROM sales s1
-- Joining the sales table on itself by the date plus a 1 week interval
-- To make sure that I am not taking the difference between different kiosks, I am
-- also joining by the kiosk_id number
-- Use an INNER JOIN so that there are no NULL values for the most recent date
INNER JOIN sales s2 ON s2.date = s1.date + INTERVAL '1 week'
                   AND s1.kiosk_id = s2.kiosk_id;