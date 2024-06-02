Solution 1:

select man.name AS manager_name, count(*)  from employee_managers emp LEFT JOIN employee_managers man ON emp.manager = man.id WHERE man.name IS NOT NULL GROUP BY man.name ORDER BY count(*) DESC;


SELECT manager_name, COUNT(*) AS employee_count
FROM (
    SELECT man.name AS manager_name
    FROM employee_managers emp
    LEFT JOIN employee_managers man ON emp.manager = man.id
    WHERE man.name IS NOT NULL
) sub
GROUP BY manager_name
ORDER BY employee_count DESC;


WITH ManagerList AS (
    SELECT emp.manager, man.name
    FROM employee_managers emp
    LEFT JOIN employee_managers man ON emp.manager = man.id
)
SELECT name AS manager_name, COUNT(*) AS employee_count
FROM ManagerList
WHERE name IS NOT NULL
GROUP BY name
ORDER BY employee_count DESC;


SELECT man.name AS manager_name, COUNT(emp.id) AS employee_count
FROM employee_managers emp
INNER JOIN employee_managers man ON emp.manager = man.id
GROUP BY man.name
ORDER BY employee_count DESC;


SELECT DISTINCT
    man.name AS manager_name,
    COUNT(emp.id) OVER (PARTITION BY man.name) AS employee_count
FROM employee_managers emp
LEFT JOIN employee_managers man ON emp.manager = man.id
WHERE man.name IS NOT NULL
ORDER BY employee_count DESC;

SELECT
    man.name AS manager_name,
    SUM(CASE WHEN emp.id IS NOT NULL THEN 1 ELSE 0 END) AS employee_count
FROM employee_managers emp
LEFT JOIN employee_managers man ON emp.manager = man.id
WHERE  man.name IS NOT NULL
GROUP BY man.name
ORDER BY employee_count DESC;
