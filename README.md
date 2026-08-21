# Week 5 - PostgreSQL Assignment 2

## Overview

This assignment focuses on writing practical PostgreSQL queries against the relational database designed and seeded in Assignment 1.

The objective is to move from database creation and data modeling to querying, filtering, joining, aggregating, and analyzing relational data.

The assignment contains 10 SQL queries based on a project management system consisting of users, projects, tasks, tags, project members, and comments.

---

## Database

The database contains the following tables:

- `users`
- `projects`
- `tasks`
- `tags`
- `project_members`
- `task_tags`
- `comments`

### Relationships

```text
users
 ├── tasks
 ├── project_members
 └── comments

projects
 ├── tasks
 └── project_members

tasks
 ├── task_tags
 └── comments

tags
 └── task_tags



### Project Structure
week-5/
│
├── schema.sql
├── seed.sql
├── setup.sql
├── queries.sql
└── README.md


### Assignment checkList

 1. All 10 queries are implemented
 2. Queries are numbered
 3. Each query has a descriptive comment
 4. Queries run against the Assignment 1 seed data
 5. Appropriate joins are used
 6. Aggregation and grouping are implemented where required
 7. NULL values are handled correctly
 8. Missing relationships are handled using appropriate joins
 9. Query results have been tested in PostgreSQL
 10. Changes are committed to Git
 11. Assignment 2 is submitted through a Pull Request


### Technologies
PostgreSQL
SQL
psql
Git
GitHub


### Author
Kinza

Computer Science Graduate
Web Developer | AI-Focused Full Stack Developer