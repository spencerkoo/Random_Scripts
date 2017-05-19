
--This query combines the Summary Stats queries and the Time queries to give
--a more complete look at the data set
--Average commute based on the mode of transport
SELECT REPLACE(data.mode, ' ', '') AS mode_fixed,
       EXTRACT(HOUR FROM AVG(data.arrivale - data.departure))||':'||
       EXTRACT(MINUTE FROM AVG(data.arrivale - data.departure)) AS avg_duration,
       ROUND(CAST(AVG(data.cost) AS NUMERIC), 2) AS average_cost,
       COUNT(*) AS times_used,
       ROUND(CAST(AVG(data.comfort) AS NUMERIC), 2) AS average_comfort
FROM (
SELECT date,
       CASE WHEN direction = 'Home-bound' THEN CAST(arrivale AS time) + INTERVAL '12 hours'
            ELSE cast(arrivale as time)
       END AS arrivale,
       CASE WHEN direction = 'Home-bound' THEN CAST(departure AS time) + INTERVAL '12 hours'
            ELSE cast(departure as time)
       END AS departure,
       direction, cost, comfort, mode
FROM everlane.commutes ec
INNER JOIN everlane.commute_modes ecm ON ec.mode_id = ecm.id
) data
GROUP BY mode_fixed
ORDER BY avg_duration, average_cost;


--The same query, but only for modes of transport used at least 5 times so the
--averages are somewhat reasonable
SELECT * FROM (
  SELECT REPLACE(data.mode, ' ', '') AS mode_fixed,
         EXTRACT(HOUR FROM AVG(data.arrivale - data.departure))||':'||
         EXTRACT(MINUTE FROM AVG(data.arrivale - data.departure)) AS avg_duration,
         ROUND(CAST(AVG(data.cost) AS NUMERIC), 2) AS average_cost,
         COUNT(*) AS times_used,
         ROUND(CAST(AVG(data.comfort) AS NUMERIC), 2) AS average_comfort
  FROM (
  SELECT date,
         CASE WHEN direction = 'Home-bound' THEN CAST(arrivale AS time) + INTERVAL '12 hours'
              ELSE cast(arrivale as time)
         END AS arrivale,
         CASE WHEN direction = 'Home-bound' THEN CAST(departure AS time) + INTERVAL '12 hours'
              ELSE cast(departure as time)
         END AS departure,
         direction, cost, comfort, mode
  FROM everlane.commutes ec
  INNER JOIN everlane.commute_modes ecm ON ec.mode_id = ecm.id
  ) data
  GROUP BY mode_fixed
  ORDER BY avg_duration, average_cost
) temp
WHERE temp.times_used >= 5