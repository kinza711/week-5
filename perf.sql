-- W1: Create an index on tasks.project_id to fast Search
--  queries that filter or join tasks by project_id.

create index idx_tasks_project_id
on tasks(project_id);


-- -- W2: Create 2 more index on tasks.status , tasks.assignee_id , or on task_tags 
-- -- queries that filter or join tasks.

CREATE INDEX IF not EXISTS idx_tasks_status
ON tasks(status);

create index if not exists idx_tasks_assignee_id
on tasks(assignee_id);


--  C1: Reassign tasks and remove project membership atomically
BEGIN;

--  Reassign all tasks from the leaving user to the new assignee.
UPDATE tasks
SET assignee_id = 2
WHERE assignee_id = 1;

--  Remove the leaving user's project membership.
DELETE FROM project_members
WHERE user_id = 1
AND project_id = 1;
-- -- Commit both changes together.
COMMIT;

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

 -- C3: EXPLAIN ANALYZE before and after indexing

    -- C3.1 BEFORE INDEX
    EXPLAIN ANALYZE
    SELECT *
    FROM tasks
    WHERE assignee_id = 2;

--  Create an index for the query above.
    CREATE INDEX IF NOT EXISTS idx_tasks_assignee_id
    ON tasks(assignee_id);
    
-- C3.2 AFTER INDEX
    
    EXPLAIN ANALYZE
    SELECT *
    FROM tasks
    WHERE assignee_id = 2;
    
-- C3.3 BEFORE INDEX for status

    EXPLAIN ANALYZE
    SELECT *
    FROM tasks
    WHERE status = 'done';

--  Create an index for status filtering.
    CREATE INDEX IF NOT EXISTS idx_tasks_status
    ON tasks(status);


-- C3.4 AFTER INDEX for status
    EXPLAIN ANALYZE
    SELECT *
    FROM tasks
    WHERE status = 'done';


-- X1: Composite index and leftmost-prefix rule

CREATE index if not EXISTS idx_tasks_project_status
ON tasks(project_id, status);
    
    -- Uses the first column of the composite index.
    EXPLAIN
    SELECT *
    FROM tasks
    WHERE project_id = 1;

    -- Uses both columns of the composite index.
    EXPLAIN
    SELECT *
    FROM tasks
    WHERE project_id = 1
    AND status = 'done';

    -- Does not directly benefit from the composite index
    -- because status is not the leftmost column.
    EXPLAIN
    SELECT *
    FROM tasks
    WHERE status = 'done';
    
  
    -- X2: Test index performance with a larger dataset

    -- Generate additional tasks for a realistic performance test.
    insert into tasks (
        title,
        description,
        status,
        priority,
        project_id,
        assignee_id,
        due_date
    )
    SELECT
        'Performance test task ' || gs,
        'Generated for index performance testing',
        CASE
            WHEN gs % 3 = 0 THEN 'done'
            WHEN gs % 3 = 1 THEN 'todo'
            ELSE 'in_progress'
        END,
        (gs % 5) + 1,
        CASE
            WHEN gs % 2 = 0 THEN 1
            ELSE 2
        END,
        CASE
            WHEN gs % 4 = 0 THEN NULL
            ELSE 2
        END,
        CURRENT_DATE + (gs % 30)
    FROM generate_series(1, 20000) AS gs;
    
    -- Update PostgreSQL's statistics after inserting many rows.
    ANALYZE tasks;
    
    -- Run the performance test again.
    EXPLAIN ANALYZE
    SELECT *
    FROM tasks
    WHERE project_id = 1
    AND status = 'done';
    
    
    -- X3: Demonstrate a lost update and prevent it with FOR UPDATE
    -- Read the current priority before demonstrating concurrency.
    SELECT id, priority
    FROM tasks
    WHERE id = 1;
    
    -- The following represents the unsafe pattern:
    -- Transaction A reads priority.
    -- Transaction B reads the same priority.
    -- Both calculate priority + 1.
    -- One update can overwrite the other.
    
    
    -- Safe version using row-level locking.
    BEGIN;
    
    SELECT priority
    FROM tasks
    WHERE id = 1
    FOR UPDATE;
    
    UPDATE tasks
    SET priority = LEAST(priority + 1, 5)
    WHERE id = 1;
    
    COMMIT;
    
    
    -- Verify the final value.
    SELECT id, priority
    FROM tasks
    WHERE id = 1;