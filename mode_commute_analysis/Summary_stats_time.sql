--Testing out casting strings to time data types
SELECT AVG(CAST(arrivale AS time)-CAST(departure AS time))
FROM everlane.commutes ec
INNER JOIN everlane.commute_modes ecm ON ec.mode_id = ecm.id;

--I noticed that these times are not in 24-hour time, but they
--don't have an am or pm attached to them so...
--I am assuming that all home bound trips are made in the pm
--so I am adding a 12 hour interval to each of those times so
--I can do more time analysis later
SELECT CASE WHEN direction = 'Home-bound' THEN CAST(arrivale AS time) + INTERVAL '12 hours'
            ELSE CAST(arrivale AS time)
       END AS arrivale,
       CASE WHEN direction = 'Home-bound' THEN CAST(departure AS time) + INTERVAL '12 hours'
            ELSE CAST(departure AS time)
       END AS departure,
       direction
FROM everlane.commutes;

--Getting the duration of the commute in a nice format
SELECT EXTRACT(HOUR FROM data.arrivale - data.departure)||':'||
       EXTRACT(MINUTE FROM data.arrivale - data.departure) AS duration,
       data.departure, data.arrivale, data.direction
FROM (
SELECT CASE WHEN direction = 'Home-bound' THEN CAST(arrivale AS time) + INTERVAL '12 hours'
            ELSE cast(arrivale as time)
       END AS arrivale,
       CASE WHEN direction = 'Home-bound' THEN CAST(departure AS time) + INTERVAL '12 hours'
            ELSE cast(departure as time)
       END AS departure,
       direction
FROM everlane.commutes
) data;


--Average commute based on the mode of transport
SELECT REPLACE(data.mode, ' ', '') AS mode_fixed,
       EXTRACT(HOUR FROM avg(data.arrivale - data.departure))||':'||
       EXTRACT(MINUTE FROM avg(data.arrivale - data.departure)) AS avg_duration
FROM (
SELECT CASE WHEN direction = 'Home-bound' THEN CAST(arrivale AS time) + INTERVAL '12 hours'
            ELSE CAST(arrivale AS time)
       END AS arrivale,
       CASE WHEN direction = 'Home-bound' THEN CAST(departure AS time) + INTERVAL '12 hours'
            ELSE CAST(departure AS time)
       END AS departure,
       direction,
       mode
FROM everlane.commutes ec
INNER JOIN everlane.commute_modes ecm ON ec.mode_id = ecm.id
) data
GROUP BY mode_fixed
ORDER BY avg_duration;


--Testing to see if all times are during what I have deemed as rush hour:
--8-10am and 5-7pm
--There are 43 results not included in the "rush hour" window
SELECT data.id, data.departure, data.arrivale, data.direction
FROM (
SELECT CASE WHEN direction = 'Home-bound' THEN CAST(arrivale AS time) + INTERVAL '12 hours'
            ELSE CAST(arrivale AS time)
       END AS arrivale,
       CASE WHEN direction = 'Home-bound' THEN CAST(departure AS time) + INTERVAL '12 hours'
            ELSE CAST(departure AS time)
       END AS departure,
       direction,
       mode,
       ec.id
FROM everlane.commutes ec
INNER JOIN everlane.commute_modes ecm ON ec.mode_id = ecm.id
) data
WHERE NOT
      ((data.departure > '08:00:00' AND data.arrivale < '10:00:00')
        OR
       (data.departure > '17:00:00' AND data.arrivale < '19:00:00'))



