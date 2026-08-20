# CMIT Week 5 - Assignment 1
## PostgreSQL Task Management Database

A relational PostgreSQL database designed for the CMIT Internship Program Week 5 Assignment 1.

The project models a Task Management platform with users, projects, project memberships, tasks, tags, task-tag relationships, and comments.

---

## Project Overview

This assignment focuses on designing a relational database using PostgreSQL with:

- Primary keys
- Foreign keys
- Composite primary keys
- NOT NULL constraints
- UNIQUE constraints
- CHECK constraints
- ON DELETE behavior
- Many-to-many relationships
- Reproducible schema and seed scripts

The database is designed so that important business rules are enforced at the database level rather than relying only on application code.

---

## Database Schema

The database contains seven tables:

```text
users
  │
  ├── projects
  │
  ├── project_members
  │
  ├── tasks
  │
  └── comments
       
projects
  │
  ├── project_members
  └── tasks

tasks
  │
  ├── task_tags
  └── comments

tags
  │
  └── task_tags


👤 Author
Kinza AI-Powered MERN Stack Developer CMIT Internship Program — Coding Pixel

📄 License
This project was built for educational purposes as part of the CMIT Internship Program.