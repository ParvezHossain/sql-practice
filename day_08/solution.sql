-- Solution 1
WITH segmented_data AS (
    SELECT *,
        SUM(
            CASE
                WHEN job_role IS NOT NULL THEN 1
                ELSE 0
            END
        ) OVER(
            ORDER BY row_id
        ) AS segment
    FROM job_skills
)
SELECT row_id,
    first_value(job_role) OVER (
        PARTITION BY segment
        ORDER BY row_id
    ) AS job_role,
    skills
from segmented_data;
-- Solution 2
WITH RECURSIVE filled_roles AS (
    SELECT row_id,
        job_role,
        skills,
        ROW_NUMBER() OVER (
            ORDER BY row_id
        ) AS rn
    FROM job_skills
),
recursive_cte AS (
    SELECT row_id,
        job_role,
        skills,
        rn
    FROM filled_roles
    WHERE rn = 1
    UNION ALL
    SELECT fr.row_id,
        COALESCE(fr.job_role, rc.job_role) AS job_role,
        fr.skills,
        fr.rn
    FROM filled_roles fr
        JOIN recursive_cte rc ON fr.rn = rc.rn + 1
)
SELECT *
FROM recursive_cte;
-- Recursive query structure
WITH Recursive cte AS (
    BASE query
    UNION
    /
    UNION ALL
    RECURSIVE query WITH termination condition
)
SELECT *
FROM cte;