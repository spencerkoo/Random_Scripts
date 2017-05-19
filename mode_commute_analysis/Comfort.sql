--Look into: COMFORT
--average comfort levels based on which direction, going home and going to work
--average comfort levels based on departure time
--average comfort levels based on cost
--average comfort levels based on mode (covered in summary stats)
--average comfort levels based on time of trip
--average comfort levels during rush hour (covered in rush hour queries)


--DIRECTION
SELECT direction, AVG(comfort) AS average_comfort
FROM everlane.commutes
GROUP BY direction;


--DEPARTURE TIME to work
SELECT temp.departure_time, AVG(temp.comfort) AS average_comfort, COUNT(*)
FROM (
  SELECT CASE WHEN departure < '05:00:00' THEN '<5'
              WHEN departure >= '05:00:00' AND departure < '06:00:00' THEN '5-6'
              WHEN departure >= '06:00:00' AND departure < '07:00:00' THEN '6-7'
              WHEN departure >= '07:00:00' AND departure < '08:00:00' THEN '7-8'
              WHEN departure >= '08:00:00' AND departure < '09:00:00' THEN '8-9'
              WHEN departure >= '09:00:00' THEN '>9'
         END AS departure_time,
         comfort
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
  WHERE direction = 'Work-bound'
) temp
GROUP BY departure_time
ORDER BY departure_time;

--DEPARTURE TIME to home
SELECT temp.departure_time, AVG(temp.comfort) AS average_comfort, COUNT(*)
FROM (
  SELECT CASE WHEN departure < '15:00:00' THEN '<15'
              WHEN departure >= '15:00:00' AND departure < '16:00:00' THEN '15-16'
              WHEN departure >= '16:00:00' AND departure < '17:00:00' THEN '16-17'
              WHEN departure >= '17:00:00' AND departure < '18:00:00' THEN '17-18'
              WHEN departure >= '18:00:00' AND departure < '19:00:00' THEN '18-19'
              WHEN departure >= '19:00:00' THEN '>19'
         END AS departure_time,
         comfort
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
  WHERE direction = 'Home-bound'
) temp
GROUP BY departure_time
ORDER BY departure_time;


--COST
SELECT cost_group, AVG(comfort) AS average_comfort, COUNT(*)
FROM (
  SELECT CASE WHEN cost < 5 THEN '1. <$5'
              WHEN cost >= '5' AND cost < '10' THEN '2. $5-10'
              WHEN cost >= '10' AND cost < '15' THEN '3. $10-15'
              WHEN cost >= '15' AND cost < '20' THEN '4. $15-20'
              WHEN cost >= '20' AND cost < '25' THEN '5. $20-25'
              WHEN cost >= '25' THEN '6. >$25'
          END AS cost_group,
          comfort
  FROM everlane.commutes
  ) data
GROUP BY cost_group
ORDER BY cost_group;


--TIME OF JOURNEY
SELECT AVG(comfort) AS average_comfort,
       duration, COUNT(*)
FROM (
  SELECT CASE WHEN
              EXTRACT(HOUR FROM (data.arrivale - data.departure)) = 0 AND
              EXTRACT(MINUTE FROM (data.arrivale - data.departure)) < 15
              THEN '1. <15 min'
              WHEN EXTRACT(HOUR FROM (data.arrivale - data.departure)) = 0 AND
              EXTRACT(MINUTE FROM (data.arrivale - data.departure)) >= 15 AND
              EXTRACT(MINUTE FROM (data.arrivale - data.departure)) < 30
              THEN '2. 15-30 min'
              WHEN EXTRACT(HOUR FROM (data.arrivale - data.departure)) = 0 AND
              EXTRACT(MINUTE FROM (data.arrivale - data.departure)) >= 30 AND
              EXTRACT(MINUTE FROM (data.arrivale - data.departure)) < 40
              THEN '3. 30-40 min'
              WHEN EXTRACT(HOUR FROM (data.arrivale - data.departure)) = 0 AND
              EXTRACT(MINUTE FROM (data.arrivale - data.departure)) >= 40 AND
              EXTRACT(MINUTE FROM (data.arrivale - data.departure)) < 50
              THEN '4. 40-50 min'
              WHEN EXTRACT(HOUR FROM (data.arrivale - data.departure)) = 0 AND
              EXTRACT(MINUTE FROM (data.arrivale - data.departure)) >= 50 AND
              EXTRACT(MINUTE FROM (data.arrivale - data.departure)) < 60
              THEN '5. 50-60 min'
              ELSE '6. >1 hour'
         END AS duration,
         data.comfort
  FROM (
    SELECT CASE WHEN direction = 'Home-bound' THEN CAST(arrivale AS time) + INTERVAL '12 hours'
                ELSE CAST(arrivale AS time)
           END AS arrivale,
           CASE WHEN direction = 'Home-bound' THEN CAST(departure AS time) + INTERVAL '12 hours'
                ELSE CAST(departure AS time)
           END AS departure,
           direction,
           mode,
           comfort
    FROM everlane.commutes ec
    INNER JOIN everlane.commute_modes ecm ON ec.mode_id = ecm.id
  ) data
) temp
GROUP BY duration
ORDER BY duration;