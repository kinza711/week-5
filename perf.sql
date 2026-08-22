-- W1: Create an index on tasks.project_id to fast Search
-- queries that filter or join tasks by project_id.

create index idx_tasks_project_id
on tasks(project_id)

