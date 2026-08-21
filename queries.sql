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

-- SELECT u.name, COUNT(t.id)
-- FROM users AS u
-- LEFT JOIN tasks AS t
-- ON u.id = t.assignee_id
-- GROUP BY u.id, u.name;


-- Q4 : part a => tasks that carry a given tag name, joined through task_tags .
-- first join task to task_tag

--  select t.id, t.title FROM tasks AS t JOIN task_tags AS tt ON t.id = tt.task_id
--  -- now join task-tags with tags
--  JOIN tags AS tg ON tt.tag_id = tg.id
--  -- now finally filter task with tags
--   WHERE tg.name = 'frontend'


  -- Q4 : part b => ooooovers duee tasks 
-- SELECT  t.id, t.title, t.due_date, t.status, u.name FROM tasks as t

-- JOIN users as u
-- on t.assignee_id = u.id

--  -- condition 1
-- where t.due_date < CURRENT_DATE
--  -- condition 2
-- and t.status <> 'done'


-- Q6:  user with done top 3 asc

-- SELECT u.id, u.name, count(t.id) from tasks AS t 
-- join  users as u
-- on t.assignee_id= u.id
-- where t.status = 'done'
-- group by u.id, u.name
-- order by count(t.id) Desc limit 3


-- Q7: SELECT *
-- select  p.id, p.name  FROM projects AS p
-- LEFT JOIN tasks AS t
-- ON p.id = t.project_id
-- where t.id is null


-- Q8: Calculate the average number of tags assigned to each task,
-- including tasks that have no tags.

SELECT AVG(tag_count) AS avg_tags_per_task
FROM (
    SELECT t.id, COUNT(tt.tag_id) AS tag_count
    FROM tasks AS t
    LEFT JOIN task_tags AS tt
    ON t.id = tt.task_id
    GROUP BY t.id
) AS task_tag_counts;