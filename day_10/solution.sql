SELECT velocity,
    COALESCE(good, 0) AS Good,
    COALESCE(regular, 0) AS Regular,
    COALESCE(wrong, 0) AS Wrong
FROM CROSSTAB(
        'SELECT v.value AS velocity, l.value as level, count(*)
     FROM auto_repair l
     JOIN auto_repair v ON l.client = v.client AND l.repair_date = v.repair_date 
     WHERE l.indicator = ''level'' 
     AND v.indicator = ''velocity''
     GROUP BY 1, 2
     ORDER BY 1, 2',
        'SELECT DISTINCT value 
     FROM auto_repair 
     WHERE indicator = ''level'' 
     ORDER BY value'
    ) AS result(
        velocity VARCHAR,
        good bigint,
        regular bigint,
        wrong bigint
    );
-- Another solution
SELECT v.value AS velocity,
    COALESCE(
        SUM(
            CASE
                WHEN l.value = 'good' THEN 1
                ELSE 0
            END
        ),
        0
    ) AS Good,
    COALESCE(
        SUM(
            CASE
                WHEN l.value = 'regular' THEN 1
                ELSE 0
            END
        ),
        0
    ) AS Regular,
    COALESCE(
        SUM(
            CASE
                WHEN l.value = 'wrong' THEN 1
                ELSE 0
            END
        ),
        0
    ) AS Wrong
FROM auto_repair v
    LEFT JOIN auto_repair l ON v.client = l.client
    AND v.repair_date = l.repair_date
WHERE v.indicator = 'velocity'
    AND l.indicator = 'level'
GROUP BY v.value
ORDER BY v.value;