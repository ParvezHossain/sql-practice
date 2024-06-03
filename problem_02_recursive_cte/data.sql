
-- More on this link:  https://learnsql.com/blog/recursive-cte-sql-server/



CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    manager_id INT,
    manager_name VARCHAR(50)
);


INSERT INTO employees (id, name, department, manager_id, manager_name) VALUES
(1, 'Alice', 'HR', NULL, NULL),
(2, 'Bob', 'IT', 1, 'Alice'),
(3, 'Charlie', 'IT', 1, 'Alice'),
(4, 'Dave', 'Sales', 2, 'Bob'),
(5, 'Eve', 'Sales', 2, 'Bob'),
(6, 'Frank', 'Marketing', 3, 'Charlie');
