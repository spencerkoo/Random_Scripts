--Look into: RUSH HOUR

--OUTSIDE OF RUSH HOUR
SELECT REPLACE(temp.mode, ' ', '') AS mode_fixed,
       EXTRACT(HOUR FROM AVG(temp.arrivale - temp.departure))||':'||
       EXTRACT(MINUTE FROM AVG(temp.arrivale - temp.departure)) AS avg_duration,
       ROUND(CAST(AVG(temp.cost) AS NUMERIC), 2) AS average_cost,
       COUNT(*) AS times_used,
       ROUND(CAST(AVG(temp.comfort) AS NUMERIC), 2) AS average_comfort
FROM (
  SELECT * FROM (
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
  WHERE NOT
        ((data.departure > '08:00:00' AND data.arrivale < '10:00:00')
          OR
         (data.departure > '17:00:00' AND data.arrivale < '19:00:00'))
  ) temp
GROUP BY mode_fixed
ORDER BY avg_duration, average_cost;


--OUTSIDE OF RUSH HOUR for 5 or more times used
SELECT * FROM (
  SELECT REPLACE(temp.mode, ' ', '') AS mode_fixed,
         EXTRACT(HOUR FROM AVG(temp.arrivale - temp.departure))||':'||
         EXTRACT(MINUTE FROM AVG(temp.arrivale - temp.departure)) AS avg_duration,
         ROUND(CAST(AVG(temp.cost) AS NUMERIC), 2) AS average_cost,
         COUNT(*) AS times_used,
         ROUND(CAST(AVG(temp.comfort) AS NUMERIC), 2) AS average_comfort
  FROM (
    SELECT * FROM (
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
    WHERE NOT
          ((data.departure > '08:00:00' AND data.arrivale < '10:00:00')
            OR
           (data.departure > '17:00:00' AND data.arrivale < '19:00:00'))
    ) temp
  GROUP BY mode_fixed
  ORDER BY avg_duration, average_cost
  ) temp2
WHERE temp2.times_used >= 5;



--DURING RUSH HOUR
SELECT REPLACE(temp.mode, ' ', '') AS mode_fixed,
      EXTRACT(HOUR FROM AVG(temp.arrivale - temp.departure))||':'||
      EXTRACT(MINUTE FROM AVG(temp.arrivale - temp.departure)) AS avg_duration,
      ROUND(CAST(AVG(temp.cost) AS NUMERIC), 2) AS average_cost,
      COUNT(*) AS times_used,
      ROUND(CAST(AVG(temp.comfort) AS NUMERIC), 2) AS average_comfort
FROM (
  SELECT * FROM (
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
  WHERE
        ((data.departure > '08:00:00' AND data.arrivale < '10:00:00')
          OR
        (data.departure > '17:00:00' AND data.arrivale < '19:00:00'))
  ) temp
GROUP BY mode_fixed
ORDER BY avg_duration, average_cost;


--DURING RUSH HOUR for 5 or more times used
SELECT * FROM (
  SELECT REPLACE(temp.mode, ' ', '') AS mode_fixed,
         EXTRACT(HOUR FROM AVG(temp.arrivale - temp.departure))||':'||
         EXTRACT(MINUTE FROM AVG(temp.arrivale - temp.departure)) AS avg_duration,
         ROUND(CAST(AVG(temp.cost) AS NUMERIC), 2) AS average_cost,
         COUNT(*) AS times_used,
         ROUND(CAST(AVG(temp.comfort) AS NUMERIC), 2) AS average_comfort
  FROM (
    SELECT * FROM (
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
    WHERE
          ((data.departure > '08:00:00' AND data.arrivale < '10:00:00')
            OR
           (data.departure > '17:00:00' AND data.arrivale < '19:00:00'))
    ) temp
  GROUP BY mode_fixed
  ORDER BY avg_duration, average_cost
  ) temp2
WHERE temp2.times_used >= 5



