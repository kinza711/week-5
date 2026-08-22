# Assignment 3 — Indexing, Transactions & Query Plans


## 1. Indexes W (1 & 2)

Postgres does not auto-index foreign keys, so each of these was added deliberately.

### `idx_tasks_project_id` on `tasks(project_id)`
**Why:** `project_id` is used in `WHERE project_id = ?` filters and in joins from
`projects` to `tasks` (e.g. "all tasks in a project," "projects with no tasks").
Without this index, every one of those queries does a full sequential scan of `tasks`.

### `idx_tasks_status` on `tasks(status)`
**Why:** `status` is filtered directly in several Assignment 2 queries (e.g. overdue
tasks: `status <> 'done'`; status counts: `GROUP BY status`). An index here lets
Postgres narrow rows by status without reading the whole table — though see the
EXPLAIN ANALYZE reading below for whether the planner actually chose to use it.

### `idx_tasks_assignee_id` on `tasks(assignee_id)`
**Why:** `assignee_id` is used in the "tasks per user" join (`LEFT JOIN tasks ON
tasks.assignee_id = users.id`) and in per-user filters. This is the FK Postgres
does not index automatically.

### (Challenge) `idx_tasks_project_status` composite on `tasks(project_id, status)`
**Why:** Tests the leftmost-prefix rule — see Section 4 below.

---

## 2. Transaction — Reassign tasks + remove membership (C1)

**Scenario:** A user is leaving a project. Their open tasks must be reassigned to
someone else, and their `project_members` row must be deleted — both must happen,
or neither should.

<!-- sql command  -->
BEGIN;
UPDATE tasks SET assignee_id = 2 WHERE assignee_id = 1;
DELETE FROM project_members WHERE user_id = 1 AND project_id = 1;
COMMIT;
```

**Verification — [FILL IN: paste your real output]**

<!-- sql command  -->
-- Before:
SELECT count(*) FROM tasks WHERE assignee_id = 1;   -- expect > 0 before commit
SELECT count(*) FROM project_members WHERE user_id = 1 AND project_id = 1;  -- expect 1

-- After COMMIT:
SELECT count(*) FROM tasks WHERE assignee_id = 1;   -- expect 0
SELECT count(*) FROM tasks WHERE assignee_id = 2;   -- expect original count + reassigned count
SELECT count(*) FROM project_members WHERE user_id = 1 AND project_id = 1;  -- expect 0
```

**Reading:** [FILL IN — one or two sentences confirming both writes landed together]

---

## 3. Rollback demo (C2)

**Purpose:** Prove that `ROLLBACK` undoes a half-finished change completely —
the data must be byte-for-byte identical to before the transaction started.

<!-- sql command  -->
SELECT COUNT(*) AS before_count FROM project_members;   -- [FILL IN: result]

BEGIN;
DELETE FROM project_members WHERE user_id = 2 AND project_id = 1;
ROLLBACK;

SELECT COUNT(*) AS after_count FROM project_members;    -- [FILL IN: result]
```

| | Count |
|---|---|
| Before | [FILL IN] |
| After rollback | [FILL IN] |

**Reading:** [FILL IN — confirm the two numbers are equal, one sentence on why this
matters: uncommitted writes inside `BEGIN...ROLLBACK` are never visible after rollback]

---

## 4. EXPLAIN ANALYZE — before/after index pairs (C3)

> ⚠️ **Before running this section, fix the script ordering bug**: the
> `idx_tasks_status` and `idx_tasks_assignee_id` indexes must NOT already exist
> when you run the "before" EXPLAIN. Either remove their creation from the W2
> block and create them for the first time here, or `DROP INDEX` them right
> before the "before" query and recreate right before the "after" query.

### Pair 1 — `tasks.assignee_id`

**Before** (no index on `assignee_id`):
```
[FILL IN: paste full EXPLAIN ANALYZE output here]
```

**After** (`idx_tasks_assignee_id` created):
```
[FILL IN: paste full EXPLAIN ANALYZE output here]
```

**Reading:** [FILL IN — name the plan node that changed (e.g. `Seq Scan` →
`Index Scan` / `Bitmap Heap Scan`, or "no change"), quote the `cost=` and
`actual time=` values from each, and say which direction they moved. If nothing
changed, say why — e.g. "table is only ~15 rows, planner estimated a sequential
scan is cheaper than an index lookup plus heap fetch."]

### Pair 2 — `tasks.status`

**Before** (no index on `status`):
```
[FILL IN: paste full EXPLAIN ANALYZE output here]
```

**After** (`idx_tasks_status` created):
```
[FILL IN: paste full EXPLAIN ANALYZE output here]
```

**Reading:** [FILL IN — same structure as above]

---

## 5. Challenge — Composite index & leftmost-prefix rule (X1)

Index: `idx_tasks_project_status` on `(project_id, status)`

| Query | Uses this index? | Why |
|---|---|---|
| `WHERE project_id = ?` | [FILL IN: yes/no] | leftmost column matches |
| `WHERE project_id = ? AND status = ?` | [FILL IN: yes/no] | both columns match, in order |
| `WHERE status = ?` alone | [FILL IN: yes/no — should be "not directly"] | `status` is not the leftmost column, so the index can't be entered from it |

**Reading:** [FILL IN — one or two sentences on what you saw in each `EXPLAIN` output]

---

## 6. Challenge — Larger dataset re-test (X2)

After inserting 20,000 rows via `generate_series` and running `ANALYZE tasks;`:

```
[FILL IN: paste EXPLAIN ANALYZE output on the larger table]
```

**Reading:** [FILL IN — compare actual time on 15 rows vs 20,000+ rows; explain
why `ANALYZE` was necessary (updates the planner's row-count/statistics estimates
so it can make an accurate cost decision) and why the index now clearly wins where
it didn't before]

---

## 7. Challenge — Lost update & FOR UPDATE (X3)

**The unsafe interleaving (two separate `psql` sessions, run manually — not scriptable
in one file):**

1. Session A: `BEGIN; SELECT priority FROM tasks WHERE id = 1;` → reads `priority = [FILL IN]`
2. Session B: `BEGIN; SELECT priority FROM tasks WHERE id = 1;` → reads the *same* value, before A commits
3. Session A: `UPDATE tasks SET priority = priority + 1 WHERE id = 1; COMMIT;`
4. Session B: `UPDATE tasks SET priority = priority + 1 WHERE id = 1; COMMIT;` — B computed
   `+1` from the *stale* value it read in step 2, overwriting A's change

**Result:** final `priority` is only `+1` higher than the start, even though two
transactions each tried to increment it — one update was silently lost.

**The fix — `SELECT ... FOR UPDATE`:**
<!-- sql command  -->
BEGIN;
SELECT priority FROM tasks WHERE id = 1 FOR UPDATE;  -- locks the row
UPDATE tasks SET priority = LEAST(priority + 1, 5) WHERE id = 1;
COMMIT;
```
`FOR UPDATE` forces the second session to block until the first session's
transaction commits, so it reads the *updated* value instead of the stale one —
ending at `+2` as expected.

