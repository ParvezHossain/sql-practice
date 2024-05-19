-- frame clause of window function in postgresql |  range between unbounded preceding and current row | this is default settings
SELECT * FROM hotel_ratings; 
WITH cte AS(
    SELECT *,
        ROUND(
            AVG(rating) OVER(
                PARTITION BY hotel
                ORDER BY year RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ),
            2
        ) AS avg_rating
    FROM hotel_ratings
), cte_rnk AS (
	SELECT *, ABS(rating - avg_rating),
	RANK() OVER(PARTITION BY hotel ORDER BY ABS(rating - avg_rating) DESC) AS rnk
FROM cte
) SELECT hotel, year, rating FROM cte_rnk WHERE rnk > 1
ORDER BY 1 DESC, 2 ASC;

-- The below soltions are based on the dataset; not for generic
 
-- Solution 1
SELECT hotel,
    year,
    ROUND(rating, 2) AS rating
FROM hotel_ratings
WHERE rating NOT IN (
        (
            SELECT MAX(rating)
            FROM hotel_ratings
        ),
        (
            SELECT MIN(rating)
            FROM hotel_ratings
        )
    )
ORDER BY 1 DESC,
    2 ASC;
-- Solution 2 | Using a CTE
WITH MinMaxRatings AS (
    SELECT MAX(rating) AS max_rating,
        MIN(rating) AS min_rating
    FROM hotel_ratings
)
SELECT hotel,
    year,
    ROUND(rating, 2) AS rating
FROM hotel_ratings
WHERE rating NOT IN (
        SELECT max_rating
        FROM MinMaxRatings
        UNION ALL
        SELECT min_rating
        FROM MinMaxRatings
    )
ORDER BY 1 DESC,
    2 ASC;
-- Solution 3 | Using a Subquery with a JOIN
SELECT hotel,
    year,
    ROUND(rating, 2) AS rating
FROM hotel_ratings
WHERE rating != (
        SELECT MAX(rating)
        FROM hotel_ratings
    )
    AND rating != (
        SELECT MIN(rating)
        FROM hotel_ratings
    )
ORDER BY 1 DESC,
    2 ASC;
-- Using window function | Here has some bug 
SELECT hotel,
    year,
    ROUND(rating, 2) AS rating
FROM (
        SELECT hotel,
            year,
            rating,
            RANK() OVER (
                ORDER BY rating DESC
            ) AS rnk_desc,
            RANK() OVER (
                ORDER BY rating ASC
            ) AS rnk_asc
        FROM hotel_ratings
    ) sub
WHERE rnk_desc > 1
    AND rnk_asc > 1
ORDER BY hotel DESC,
    year ASC;
-- Using not exist | This approach also does not work somehow
SELECT hotel,
    year,
    ROUND(rating, 2) AS rating
FROM hotel_ratings hr
WHERE NOT EXISTS (
        SELECT 1
        FROM hotel_ratings
        WHERE rating = (
                SELECT MAX(rating)
                FROM hotel_ratings
            )
            OR rating = (
                SELECT MIN(rating)
                FROM hotel_ratings
            )
            AND hr.rating = rating
    )
ORDER BY hotel DESC,
    year ASC;
-- Using EXCEPT
SELECT hotel,
    year,
    ROUND(rating, 2) AS rating
FROM hotel_ratings
EXCEPT
SELECT hotel,
    year,
    ROUND(rating, 2) as rating
FROM hotel_ratings
WHERE rating = (
        SELECT MAX(rating)
        FROM hotel_ratings
    )
    OR rating = (
        SELECT MIN(rating)
        FROM hotel_ratings
    )
ORDER BY hotel DESC,
    year ASC;