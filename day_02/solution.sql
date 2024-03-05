-- Create mountain_huts table
DROP TABLE IF EXISTS mountain_huts;
CREATE TABLE mountain_huts 
(
    id       INTEGER NOT NULL UNIQUE,
    name     VARCHAR(40) NOT NULL UNIQUE,
    altitude INTEGER NOT NULL
);

-- Insert data into mountain_huts
INSERT INTO mountain_huts VALUES (1, 'Dakonat', 1900);
INSERT INTO mountain_huts VALUES (2, 'Natisa', 2100);
INSERT INTO mountain_huts VALUES (3, 'Gajantut', 1600);
INSERT INTO mountain_huts VALUES (4, 'Rifat', 782);
INSERT INTO mountain_huts VALUES (5, 'Tupur', 1370);

-- Create trails table
DROP TABLE IF EXISTS trails;
CREATE TABLE trails 
(
    hut1 INTEGER NOT NULL,
    hut2 INTEGER NOT NULL
);

-- Insert data into trails
INSERT INTO trails VALUES (1, 3);
INSERT INTO trails VALUES (3, 2);
INSERT INTO trails VALUES (3, 5);
INSERT INTO trails VALUES (4, 5);
INSERT INTO trails VALUES (1, 5);

-- Common Table Expressions (CTEs)
WITH cte_trails_1 AS
(
    SELECT t1.hut1 AS start_hut, h1.name AS start_hut_name,
           h1.altitude AS start_hut_altitude, t1.hut2 AS end_hut
    FROM mountain_huts h1
    INNER JOIN trails t1 ON t1.hut1 = h1.id
),
cte_trails_2 AS
(
    SELECT t2.*, h2.name AS end_hut_name, h2.altitude AS end_hut_altitude,
           CASE WHEN start_hut_altitude > h2.altitude THEN 1 ELSE 0 END AS altitude_flag
    FROM cte_trails_1 t2
    INNER JOIN mountain_huts h2 ON h2.id = t2.end_hut
),
cte_final_trails AS
(
    SELECT CASE WHEN altitude_flag = 1 THEN start_hut ELSE end_hut END AS start_hut,
           CASE WHEN altitude_flag = 1 THEN start_hut_name ELSE end_hut_name END AS start_hut_name,
           CASE WHEN altitude_flag = 1 THEN end_hut ELSE start_hut END AS end_hut,
           CASE WHEN altitude_flag = 1 THEN end_hut_name ELSE start_hut_name END AS end_hut_name
    FROM cte_trails_2
)

-- Main Query
SELECT c1.start_hut_name AS startpt,
       c1.end_hut_name AS middilept,
       c2.end_hut_name AS endpt
FROM cte_final_trails c1
INNER JOIN cte_final_trails c2 ON c1.end_hut = c2.start_hut;
