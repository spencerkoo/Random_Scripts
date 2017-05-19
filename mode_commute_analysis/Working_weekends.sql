--This query checks to see if there is any data for commuting on the weekends.
--It is vitally important b/c it most likely has an effect on the type of travel
--and the comfort level. (And I was just curious).
SELECT data.date
FROM (
SELECT * FROM everlane.commutes  ec
INNER JOIN everlane.commute_modes ecm ON ec.mode_id = ecm.id
) data
--Extracting the day of the week.
WHERE EXTRACT(DOW FROM data.date) IN (0, 6)