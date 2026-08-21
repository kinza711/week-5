-- Q1: All tasks for one project, ordered by due date ascending with NULL due dates last.

-- SELECT * FROM tasks
-- WHERE project_id = 1
-- ORDER BY due_date ASC NULLS LAST;

-- Q2: Count the number of tasks in each status.

-- SELECT status, COUNT(*)
-- FROM tasks
-- GROUP BY status;

-- Q3: Dispaly No of tasks & users with 0 tasks must still appear.

-- i use left join not inner bcz i want Every user, including users with 0 tasks, must appear.

SELECT u.name, COUNT(t.id)
FROM users AS u
LEFT JOIN tasks AS t
ON u.id = t.assignee_id
GROUP BY u.id, u.name;
