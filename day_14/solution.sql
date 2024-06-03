-- Solution 1: 
WITH min_max AS (
    SELECT MIN(serial_no) AS min_serial,
        MAX(serial_no) AS max_serial
    FROM invoice
),
full_invoice_list AS (
    SELECT value
    FROM GENERATE_SERIES(
            (
                SELECT min_serial
                FROM min_max
            ),
            (
                SELECT max_serial
                FROM min_max
            )
        ) AS value
)
SELECT value AS MISSING_SERIAL_NO
FROM full_invoice_list
    LEFT JOIN invoice ON full_invoice_list.value = invoice.serial_no
WHERE invoice.serial_no IS NULL;
-- Solution 2:
WITH full_invoice_list AS (
    SELECT value
    FROM GENERATE_SERIES(
            (
                SELECT MIN(serial_no)
                FROM invoice
            ),
            (
                SELECT MAX(serial_no)
                FROM invoice
            )
        ) AS value
)
SELECT value AS MISSING_SERIAL_NO
FROM full_invoice_list
    LEFT JOIN invoice ON full_invoice_list.value = invoice.serial_no
WHERE invoice.serial_no IS NULL;
-- Solution 3:
DROP TABLE IF EXISTS tmp_min_max;
CREATE TEMP table tmp_min_max AS
SELECT MIN(serial_no) AS min_serial,
    MAX(serial_no) AS max_serial
FROM invoice;
WITH full_invoice_list AS (
    SELECT value
    FROM GENERATE_SERIES(
            (
                SELECT min_serial
                FROM tmp_min_max
            ),
            (
                SELECT max_serial
                FROM tmp_min_max
            )
        ) AS value
)
SELECT value AS MISSING_SERIAL_NO
FROM full_invoice_list
    LEFT JOIN invoice ON full_invoice_list.value = invoice.serial_no
WHERE invoice.serial_no IS NULL DELETE table tmp_min_max;

-- Solution 4:

WITH serial_numbers AS (
    SELECT serial_no, LEAD(serial_no) OVER (ORDER BY serial_no) AS next_serial
    FROM invoice
),
missing_serials AS (
    SELECT GENERATE_SERIES(serial_no + 1, next_serial - 1) AS value
    FROM serial_numbers
    WHERE next_serial IS NOT NULL
)
SELECT value AS MISSING_SERIAL_NO FROM missing_serials

-- missing_serials CTE generates the number of every row coming from serial_numbers CTE

-- Solution 5:

SELECT GENERATE_SERIES(MIN(serial_no),MAX(serial_no)) AS missing_data FROM invoice
EXCEPT
SELECT serial_no FROM invoice
ORDER BY missing_data;

-- Solution 5:
WITH RECURSIVE cte AS
	(SELECT min(serial_no) AS n FROM invoice 
	UNION
	SELECT n+1 AS n
	FROM cte 
	WHERE n < (SELECT max(serial_no) FROM invoice)
	 )
SELECT n AS missing_serial_no FROM cte	 
except 
SELECT serial_no FROM invoice
ORDER BY 1;