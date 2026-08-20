
-- craete user tabel
create table users (
id INTEGER generated always as identity primary KEY,
name text not NULL,
email text not null,
created_at timestamptz default now()
);
-- unique key with ignore case-sens
create unique index users_email_lower_unique on users (lower(email));


-- create projects table

CREATE TABLE projects (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    owner_id INTEGER not Null references users(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- -- craete tags table
create table tags(
    id INTEGER generated always as identity primary key,
     name text UNIQUE NOT NULL
);

-- -- craete project_members tabel 
create table project_members(
    user_id INTEGER not Null references users(id) on delete CASCADE,
    project_id INTEGER not Null  references projects(id) on delete CASCADE,
    role TEXT NOT NULL check (role in ('owner' , 'admin' , 'member' , 'viewer')),
    PRIMARY KEY (user_id, project_id)

);

--create enum for status challenge task
create type task_status as enum (
    'todo' , 'in_progress' , 'done'
);
-- --carete task table 
create table tasks(
    id INTEGER generated always as identity primary key,
    title text NOT NULL,
    description text ,
    status task_status Not null,
    priority integer check (priority between 1 and 5) ,
    project_id INTEGER NOT NULL references projects(id) on delete CASCADE,
    assignee_id integer NULL references users(id) ON DELETE SET NULL,
    due_date timestamptz,
    created_at  timestamptz default now()
);

-- --craete task-tag table 
create table task_tags(
    task_id integer references tasks(id) on delete CASCADE,
    tag_id integer references tags(id) on delete CASCADE,
    --composit keys
    PRIMARY KEY (task_id, tag_id)    
);

-- carete comments table
create table comments(
    id INTEGER generated always as identity primary key,
    task_id integer NOT NULL references tasks(id) on delete CASCADE,
    author_id integer NOT NULL references users(id), 
    body text NOT NULL, 
    created_at  timestamptz default now()
);


