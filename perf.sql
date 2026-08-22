-- W1: Create an index on tasks.project_id to fast Search
-- queries that filter or join tasks by project_id.

create index idx_tasks_project_id
on tasks(project_id);


-- W2: Create 2 more index on tasks.status , tasks.assignee_id , or on task_tags 
-- queries that filter or join tasks.

CREATE INDEX IF not EXISTS idx_tasks_status
ON tasks(status);

create index if not exists idx_tasks_assignee_id
on tasks(assignee_id);
