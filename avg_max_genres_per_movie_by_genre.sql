-- this query returns finds the average and maximum number of genres that any movie can have per genre
-- as the challenge states, to find out which genres are the most "clearly defined"
-- one thing to note: the maximum function is not as useful as it appears b/c many genres will
-- end up with the same number
-- this occurs b/c each does not have a "principle" genre and subsequent sub-genres so many numbers
-- are repeated as one movie with many different genres covers the maximum for many genres
-- selecting the aggregate average and max needed for this query
SELECT g.name, ROUND(AVG(temp.total_genres), 3) AS average_genres, MAX(temp.total_genres) AS max_genres
FROM (
    SELECT genre_id, total_genres
    FROM genres_movies gm
    LEFT JOIN (
    -- left joining so that I can get all the movies listed in the database
    -- the joiner table will contain the count of all the genres for each movie
        SELECT movie_id, COUNT(*) AS total_genres
        FROM genres_movies
        GROUP BY movie_id
    ) genre_count
    -- join based on the movie id, but ONLY select the genre_id so I have a list
    -- of all the genres for each movie labeled only by each genre
    -- that's a little confusing, but from here I can use this table to get the
    -- aggregate averages and max counts wanted for this challenge
    ON gm.movie_id = genre_count.movie_id
) temp
-- adding the genre name instead of just the id
INNER JOIN genres g on temp.genre_id = g.id
GROUP BY g.name
ORDER BY average_genres DESC;