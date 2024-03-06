-- Create Table
DROP TABLE IF EXISTS FOOTER;
CREATE TABLE FOOTER (
    id INT PRIMARY KEY,
    car VARCHAR(20),
    length INT,
    width INT,
    height INT
);

-- Insert Data
INSERT INTO FOOTER VALUES (1, 'Hyundai Tucson', 15, 6, NULL);
INSERT INTO FOOTER VALUES (2, NULL, NULL, NULL, 20);
INSERT INTO FOOTER VALUES (3, NULL, 12, 8, 15);
INSERT INTO FOOTER VALUES (4, 'Toyota Rav4', NULL, 15, NULL);
INSERT INTO FOOTER VALUES (5, 'Kia Sportage', NULL, NULL, 18);

-- Select All Data
SELECT * FROM FOOTER;

-- Solution 1
SELECT 
    car_result.car,
    length_result.length,
    width_result.width,
    height_result.height
FROM
    (SELECT car FROM FOOTER WHERE car IS NOT NULL ORDER BY id DESC LIMIT 1) AS car_result
CROSS JOIN
    (SELECT length FROM FOOTER WHERE length IS NOT NULL ORDER BY id DESC LIMIT 1) AS length_result
CROSS JOIN
    (SELECT width FROM FOOTER WHERE width IS NOT NULL ORDER BY id DESC LIMIT 1) AS width_result
CROSS JOIN
    (SELECT height FROM FOOTER WHERE height IS NOT NULL ORDER BY id DESC LIMIT 1) AS height_result;

-- Solution 2
WITH cte AS (
    SELECT *,
        SUM(CASE WHEN car IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY id) AS car_segment,
        SUM(CASE WHEN length IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY id) AS length_segment,
        SUM(CASE WHEN width IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY id) AS width_segment,
        SUM(CASE WHEN height IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY id) AS height_segment
    FROM FOOTER
)
SELECT 
    FIRST_VALUE(car) OVER (PARTITION BY car_segment ORDER BY id) AS new_car,
    FIRST_VALUE(length) OVER (PARTITION BY length_segment ORDER BY id) AS new_length,
    FIRST_VALUE(width) OVER (PARTITION BY width_segment ORDER BY id) AS new_width,
    FIRST_VALUE(height) OVER (PARTITION BY height_segment ORDER BY id) AS new_height
FROM cte
ORDER BY id DESC
LIMIT 1;
