-- Q1: All tasks for one project, ordered by due date ascending with NULL due dates last.

SELECT * FROM tasks
WHERE project_id = 1
ORDER BY due_date ASC NULLS LAST;