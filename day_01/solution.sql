-- Drop the table if it already exists
DROP TABLE IF EXISTS brands;

-- Create the 'brands' table with columns
CREATE TABLE brands 
(
    brand1      VARCHAR(20),
    brand2      VARCHAR(20),
    year        INT,
    custom1     INT,
    custom2     INT,
    custom3     INT,
    custom4     INT
);

-- Insert sample data into the 'brands' table
INSERT INTO brands VALUES ('apple', 'samsung', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('samsung', 'apple', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('apple', 'samsung', 2021, 1, 2, 5, 3);
INSERT INTO brands VALUES ('samsung', 'apple', 2021, 5, 3, 1, 2);
INSERT INTO brands VALUES ('google', NULL, 2020, 5, 9, NULL, NULL);
INSERT INTO brands VALUES ('oneplus', 'nothing', 2020, 5, 9, 6, 3);

-- Select rows where custom1 is not equal to custom3 or custom2 is not equal to custom4
SELECT * FROM brands WHERE (custom1 != custom3) OR (custom2 != custom4);

-- Common Table Expression (CTE) to generate a pair_id based on brand1, brand2, and year
WITH cte AS
(
    SELECT *,
        CASE
            WHEN brand1 < brand2 THEN CONCAT(brand1, brand2, year)
            ELSE CONCAT(brand2, brand1, year)
        END pair_id
    FROM brands
),

-- CTE with row numbers partitioned by pair_id
cte_rn AS
(
    SELECT *, ROW_NUMBER() OVER (PARTITION BY pair_id ORDER BY pair_id) AS rn
    FROM cte
)

-- Select distinct rows based on pair_id and row number, or when custom1 <> custom3 and custom2 <> custom4
SELECT brand1, brand2, year, custom1, custom2, custom3, custom4, rn
FROM cte_rn 
WHERE rn = 1 OR (custom1 <> custom3 AND custom2 <> custom4);
