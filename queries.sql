-- Q1: All tasks for one project, ordered by due date ascending with NULL due dates last.

SELECT * FROM tasks
WHERE project_id = 1
ORDER BY due_date ASC NULLS LAST;

-- Q2: Count the number of tasks in each status.

SELECT status, COUNT(*)
FROM tasks
GROUP BY status;

-- Q3: Dispaly No of tasks & users with 0 tasks must still appear.

-- i use left join not inner bcz i want Every user, including users with 0 tasks, must appear.

SELECT u.name, COUNT(t.id)
FROM users AS u
LEFT JOIN tasks AS t
ON u.id = t.assignee_id
GROUP BY u.id, u.name;


-- Q4 : part a => tasks that carry a given tag name, joined through task_tags .
-- first join task to task_tag

 select t.id, t.title FROM tasks AS t JOIN task_tags AS tt ON t.id = tt.task_id
 -- now join task-tags with tags
 JOIN tags AS tg ON tt.tag_id = tg.id
 -- now finally filter task with tags
WHERE tg.name = 'frontend'


 -- Q5: Retrieve overdue tasks that are not completed,
-- including the assigned user's name.

SELECT  t.id, t.title, t.due_date, t.status, u.name FROM tasks as t
JOIN users as u
on t.assignee_id = u.id
 -- condition 1
where t.due_date < CURRENT_DATE
 -- condition 2
and t.status <> 'done'


-- Q6: Retrieve the top 3 users by the number of completed tasks,
-- ordered from the highest completed-task count to the lowest.

SELECT u.id, u.name, count(t.id) from tasks AS t 
join  users as u
on t.assignee_id= u.id
where t.status = 'done'
group by u.id, u.name
order by count(t.id) Desc limit 3


-- Q7: Retrieve projects that have no tasks assigned to them.
-- LEFT JOIN preserves all projects, while IS NULL identifies
-- projects without a matching task.

select  p.id, p.name  FROM projects AS p
LEFT JOIN tasks AS t
ON p.id = t.project_id
where t.id is null


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


-- Q9: Count comments for every task, including tasks with zero comments,
-- and order the results by comment count descending.

SELECT t.id, t.title, COUNT(c.id) AS comment_count
FROM tasks AS t
LEFT JOIN comments AS c
ON t.id = c.task_id GROUP BY t.id, t.title
ORDER BY comment_count DESC;


-- Q10: List every project with its members and their assigned roles.

SELECT
    p.id AS project_id,
    p.name AS project_name,
    u.id AS user_id,
    u.name AS member_name,
    pm.role
FROM projects AS p
LEFT JOIN project_members AS pm
ON p.id = pm.project_id
LEFT JOIN users AS u
ON pm.user_id = u.id
ORDER BY p.id, u.id;


-- challenge tasks

-- X2: Return one row per project and count its members by role.
-- Each supported role is represented as a separate column.

SELECT
    p.id,
    p.name,
    COUNT(*) FILTER (WHERE pm.role = 'owner') AS owners,
    COUNT(*) FILTER (WHERE pm.role = 'admin') AS admins,
    COUNT(*) FILTER (WHERE pm.role = 'member') AS members,
    COUNT(*) FILTER (WHERE pm.role = 'viewer') AS viewers
FROM projects AS p
LEFT JOIN project_members AS pm
    ON p.id = pm.project_id
GROUP BY p.id, p.name
ORDER BY p.id;


-- X1: Return the top 3 users by completed tasks,
-- including all users tied at the third rank.

WITH ranked_users AS (
    SELECT
        u.id,
        u.name,
        COUNT(t.id) AS done_count,
        RANK() OVER (ORDER BY COUNT(t.id) DESC) AS rank
    FROM users AS u
    JOIN tasks AS t
        ON u.id = t.assignee_id
    WHERE t.status = 'done'
    GROUP BY u.id, u.name
)
SELECT
    id,
    name,
    done_count
FROM ranked_users
WHERE rank <= 3
ORDER BY rank;