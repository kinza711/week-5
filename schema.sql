-- create user table 

create table users (
id INTEGER generated always as identity primary KEY,
name text not NULL,
email text not null unique,
created_at timestamptz default now()
);

-- create project table 
CREATE TABLE projects (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    owner_id INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- create tags table 
create table tags(
    id INTEGER generated always as identity primary key,
     name text UNIQUE NOT NULL
);

-- create project-members table 
create table project_members(
    user_id INTEGER,
    project_id INTEGER,
    role TEXT NOT NULL 
);
 
 -- create tasks table 
create table tasks(
    id INTEGER generated always as identity primary key,
    title text NOT NULL,
    description text ,
    status text ,
    priority integer,
    project_id INTEGER  NOT NULL,
    assignee_id integer NULL,
    due_date timestamptz,
    created_at  timestamptz default now()
);

-- create task-tags table 
create table task_tags(
    task_id integer ,
    tag_id integer 
     
);

-- create comments table 
create table comments(
    id INTEGER generated always as identity primary key,
    task_id integer NOT NULL,
    author_id integer NOT NULL, 
    body text NOT NULL, 
    created_at  timestamptz default now()
);


