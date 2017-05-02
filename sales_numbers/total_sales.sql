-- If you have a table called tickets that have fields: kiosk_id, amount, timestamp
-- This query finds the sales by kiosk for each of the past four Mondays with
-- each PostgreSQL timestamp in PST time zone.
-- For each kiosk, there will be four rows with kiosk_id, date, sales
SELECT temp.kiosk_id, temp.days, temp.sales
-- using a subquery so I can use a WHERE clause
FROM (
  -- subquery to get the kiosk_id, date, total sales PER day, PER kiosk
  SELECT kiosk_id, DATE_TRUNC('day', date) AS days, SUM(amount) AS sales
  FROM tickets
  -- truncating the timestamp so it will combine the timestamps by day
  GROUP BY kiosk_id, DATE_TRUNC('day', date)
) temp
-- includes only the last four Mondays without hard coding the exact date
WHERE temp.days = CURRENT_DATE - CAST(EXTRACT(DOW FROM CURRENT_DATE) AS INT) + 1
   OR temp.days = CURRENT_DATE - CAST(EXTRACT(DOW FROM CURRENT_DATE) AS INT) + 1
                  - INTERVAL '1 week'
   OR temp.days = CURRENT_DATE - CAST(EXTRACT(DOW FROM CURRENT_DATE) AS INT) + 1
                  - INTERVAL '2 week'
   OR temp.days = CURRENT_DATE - CAST(EXTRACT(DOW FROM CURRENT_DATE) AS INT) + 1
                  - INTERVAL '3 week'