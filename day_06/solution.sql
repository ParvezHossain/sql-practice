-- Solution 1 | problem -> 1
SELECT t1.test_id,
    t1.marks
FROM student_tests t1
    JOIN student_tests t2 ON t1.test_id = t2.test_id + 1
WHERE t1.marks >= t2.marks;
-- Solution 2 | problem -> 1
SELECT test_id,
    marks
FROM (
        SELECT *,
            LAG(marks, 1, 0) OVER (
                ORDER BY test_id
            ) AS prev_test_mark
        FROM student_tests
    ) x
WHERE x.marks > prev_test_mark;
-- Solution 3 | problem -> 1
WITH cte AS (
    SELECT test_id,
        marks,
        LAG(marks, 1, 0) OVER (
            ORDER BY test_id
        ) AS prev_marks
    FROM student_tests
)
select test_id,
    marks
from cte
where marks > prev_marks -- Solution 2 | problem -> 1
SELECT t1.test_id,
    t1.marks
FROM student_tests t1
    JOIN student_tests t2 ON t1.test_id = t2.test_id + 1
WHERE t1.marks > t2.marks;
-- Solution 2 | problem -> 2
SELECT test_id,
    marks
FROM (
        SELECT *,
            LAG(marks, 1, marks) OVER (
                ORDER BY test_id
            ) AS prev_test_mark
        FROM student_tests
    ) x
WHERE x.marks > prev_test_mark;