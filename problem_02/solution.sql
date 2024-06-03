-- SQL Server Soltuion
WITH employee_manager_cte AS (
    SELECT id,
        name,
        department,
        manager_id,
        manager_name,
        1 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.id,
        e.name,
        e.department,
        e.manager_id,
        e.manager_name,
        level + 1
    FROM employees e
        INNER JOIN employee_manager_cte r ON e.manager_id = r.id
)
SELECT *
FROM employee_manager_cte;
-- Postgres / MySQL Soltuion
WITH RECURSIVE employee_manager_cte AS (
    SELECT id,
        name,
        department,
        manager_id,
        manager_name,
        1 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.id,
        e.name,
        e.department,
        e.manager_id,
        e.manager_name,
        level + 1
    FROM employees e
        INNER JOIN employee_manager_cte r ON e.manager_id = r.id
)
SELECT *
FROM employee_manager_cte;