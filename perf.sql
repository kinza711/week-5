-- -- W1: Create an index on tasks.project_id to fast Search
-- -- queries that filter or join tasks by project_id.

-- create index idx_tasks_project_id
-- on tasks(project_id);


-- -- W2: Create 2 more index on tasks.status , tasks.assignee_id , or on task_tags 
-- -- queries that filter or join tasks.

-- CREATE INDEX IF not EXISTS idx_tasks_status
-- ON tasks(status);

-- create index if not exists idx_tasks_assignee_id
-- on tasks(assignee_id);


-- -- C1: Reassign tasks and remove project membership atomically
-- BEGIN;

-- -- Reassign all tasks from the leaving user to the new assignee.
-- UPDATE tasks
-- SET assignee_id = 2
-- WHERE assignee_id = 1;

-- -- Remove the leaving user's project membership.
-- DELETE FROM project_members
-- WHERE user_id = 1
--   AND project_id = 1;

-- -- Commit both changes together.
-- COMMIT;



-- C2: demonstrate rollback


-- Record the number of memberships before the transaction.
SELECT COUNT(*) AS before_count
FROM project_members;

BEGIN;

-- Temporary change that should be undone.
DELETE FROM project_members
WHERE user_id = 2
  AND project_id = 1;

-- Undo the transaction.
ROLLBACK;

-- The count should be identical to before_count.
SELECT COUNT(*) AS after_count
FROM project_members;