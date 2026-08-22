# Assignment 3 — Indexing, Transactions & Query Plans

CMIT Internship Program · Week 5 (Data Phase) · Task Management schema

## Overview

This assignment covers three performance and correctness concerns on top of the
Week 5 Task Management schema (`schema.sql`, `seed.sql` from Assignment 1):

1. **Indexing** — adding targeted indexes and justifying each one
2. **Transactions** — a multi-statement write wrapped in `BEGIN...COMMIT`, and a
   `ROLLBACK` demo proving atomicity
3. **Query plans** — reading real `EXPLAIN ANALYZE` output before and after
   indexing to see what the Postgres planner actually did, not what "feels" faster

## Files

| File | Contents |
|---|---|
| `perf.sql` | Index creation, the reassignment transaction, the rollback demo, all `EXPLAIN ANALYZE` queries, and the Challenge problems (composite index, large-dataset re-test, lost-update demo) |
| `NOTES.md` | Written justification for each index, transaction verification, and the before/after `EXPLAIN ANALYZE` readings |

## Prerequisites

- PostgreSQL 14+ (native install or Docker)
- `schema.sql` and `seed.sql` from Assignment 1 already applied to the target database

## Setup

```bash
# 1. Create a fresh database (skip if reusing Assignment 1's database)
dropdb --if-exists task_management
createdb task_management

# 2. Load the schema and seed data
psql -d task_management -f schema.sql
psql -d task_management -f seed.sql

# 3. Run this assignment's script
psql -d task_management -f perf.sql
```

## What each section does

- **Indexes** — `CREATE INDEX` on `tasks.project_id`, `tasks.status`,
  `tasks.assignee_id`, and (Challenge) a composite index on
  `(project_id, status)`. Reasoning for each is in `NOTES.md`.
- **Transaction (required)** — reassigns a leaving user's tasks to another user
  and removes their `project_members` row inside a single `BEGIN...COMMIT`, so
  both writes succeed or neither does.
- **Rollback demo (required)** — deletes a row inside `BEGIN...ROLLBACK` and
  confirms row counts are identical before and after.
- **EXPLAIN ANALYZE pairs (required)** — captures the query plan before and
  after adding an index, for two different columns.
- **Challenge (optional, extra marks)**
  - Leftmost-prefix test on the composite index across three `WHERE` shapes
  - 20,000-row `generate_series` insert + `ANALYZE` to re-test index impact at scale
  - Lost-update race condition, demonstrated across two `psql` sessions, and
    fixed with `SELECT ... FOR UPDATE`

## Verifying it worked

```sql
-- Indexes exist
\di

-- Transaction result: task reassigned, membership removed
SELECT * FROM tasks WHERE assignee_id = 2;
SELECT * FROM project_members WHERE user_id = 1 AND project_id = 1;  -- expect 0 rows

-- Rollback left row counts unchanged (see NOTES.md for before/after counts)
```

Full plan readings, cost/time comparisons, and the reasoning behind each index
are written up in `NOTES.md`.