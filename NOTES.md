### CMIT Week-5 Assignment 3

## W1 - Index on `tasks.project_id`

### What I did

Created an index on the `project_id` column of the `tasks` table:

<!-- --- sql command i used for careting index --- -->

CREATE INDEX idx_tasks_project_id
ON tasks(project_id);


## W2 - Additional Indexes

### 1. `idx_tasks_status`, tasks_assignee_id, tasks_tags

<!-- --- sql command i used for careting index --- -->

CREATE INDEX IF not EXISTS idx_tasks_status
ON tasks(status);

create index if not exists idx_tasks_assignee_id
on tasks(assignee_id);



