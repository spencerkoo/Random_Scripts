--This query just gets some basic summary statistics on the dataset such as:
--average cost, most used mode of transport, average trip time, average comfort,
--average comfort based on mode of transport

--Just noticed that there are two entries for UberPool and Uber Pool, which
--must be combined
SELECT REPLACE(data.mode, ' ', '') AS mode_fixed,
       ROUND(CAST(AVG(data.cost) AS NUMERIC), 2) AS average_cost,
       COUNT(*) AS times_used,
       ROUND(CAST(AVG(data.comfort) AS NUMERIC), 2) AS average_comfort
FROM (
select * from everlane.commutes  ec
inner join everlane.commute_modes ecm on ec.mode_id = ecm.id
) data
GROUP BY mode_fixed
ORDER BY average_cost

--Seriously... semicolons were messing up the query?

--Note:
--Look into: SUMMARY STATS
--average trip time, cost, comfort, mode during certain hours of the day (like rush hour)
--which would be around time from 7-10am and 4-7pm