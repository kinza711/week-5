-- ============ C 3  Seed Data =============

-- user data seeds

INSERT INTO users (name, email)
VALUES
    ('Asad', 'asad@gmail.com'),
    ('faiza', 'faiza@gmail.com'),
    ('bilal', 'bilal@gmail.com'),
    ('Ansa', 'ansa@gmail.com'),
    ('Muneeba Tariq', 'muneeba.tariq@gmail.com'),
    ('Kinza', 'kinza@.gmailcom');

-- projects seeds data
INSERT INTO projects (name, owner_id)
VALUES
    ('Website Redesign', 1),
    ('Mobile Application', 2),
    ('Internal Dashboard', 3);

-- projects members seeds 
INSERT INTO project_members (user_id, project_id, role)
VALUES
    (1, 1, 'owner'),
    (2, 1, 'admin'),
    (3, 1, 'member'),

    (2, 2, 'owner'),
    (4, 2, 'admin'),
    (5, 2, 'member'),

    (3, 3, 'owner'),
    (6, 3, 'viewer');

    -- tags seeds 
    INSERT INTO tags (name)
VALUES
    ('frontend'),
    ('backend'),
    ('bug'),
    ('urgent'),
    ('feature'),
    ('documentation');



    -- ============================================
-- CMIT WEEK 5
-- ASSIGNMENT 1 - C3
-- SEED DATA
-- ============================================


-- ============================================
-- 1. USERS
-- Minimum required: 6
-- User 6 will intentionally have zero tasks
-- ============================================

INSERT INTO users (name, email)
VALUES
    ('Ali Khan', 'ali.khan@example.com'),
    ('Sara Ahmed', 'sara.ahmed@example.com'),
    ('Hamza Malik', 'hamza.malik@example.com'),
    ('Ayesha Noor', 'ayesha.noor@example.com'),
    ('Usman Tariq', 'usman.tariq@example.com'),
    ('Kinza Ahmed', 'kinza.ahmed@example.com');


-- ============================================
-- 2. PROJECTS
-- Minimum required: 3
-- Project 3 will intentionally have zero tasks
-- ============================================

INSERT INTO projects (name, owner_id)
VALUES
    ('Website Redesign', 1),
    ('Mobile Application', 2),
    ('Internal Dashboard', 3);


-- ============================================
-- 3. PROJECT MEMBERS
-- Minimum required: 6
-- Includes a mix of roles
-- ============================================

INSERT INTO project_members (user_id, project_id, role)
VALUES
    (1, 1, 'owner'),
    (2, 1, 'admin'),
    (3, 1, 'member'),

    (2, 2, 'owner'),
    (4, 2, 'admin'),
    (5, 2, 'member'),

    (3, 3, 'owner'),
    (6, 3, 'viewer');


-- ============================================
-- 4. TAGS
-- Minimum required: 6
-- ============================================

INSERT INTO tags (name)
VALUES
    ('frontend'),
    ('backend'),
    ('bug'),
    ('urgent'),
    ('feature'),
    ('documentation');



-- Special cases for tasks seeds data :
-- - Task 5 has NULL assignee
-- - Task 6 is overdue and not done
-- - Project 3 has zero tasks
-- - User 6 has zero assigned tasks

INSERT INTO tasks (
    title,
    description,
    status,
    priority,
    project_id,
    assignee_id,
    due_date
)
VALUES

-- Project 1
(
    'Create homepage',
    'Build the main homepage UI',
    'done',
    3,
    1,
    1,
    CURRENT_DATE - INTERVAL '10 days'
),

(
    'Fix navbar',
    'Fix responsive navigation',
    'done',
    4,
    1,
    2,
    CURRENT_DATE - INTERVAL '5 days'
),

(
    'Add authentication',
    'Implement login and signup',
    'in_progress',
    5,
    1,
    3,
    CURRENT_DATE + INTERVAL '5 days'
),

(
    'Write API documentation',
    'Document backend endpoints',
    'todo',
    2,
    1,
    4,
    CURRENT_DATE + INTERVAL '10 days'
),

(
    'Design dashboard',
    'Create dashboard wireframes',
    'todo',
    3,
    1,
    NULL,
    CURRENT_DATE + INTERVAL '7 days'
),

(
    'Fix login bug',
    'Investigate failed login issue',
    'in_progress',
    5,
    1,
    2,
    CURRENT_DATE - INTERVAL '3 days'
),

(
    'Create testing guide',
    'Write testing documentation',
    'todo',
    2,
    1,
    5,
    CURRENT_DATE + INTERVAL '20 days'
),

(
    'Fix button alignment',
    'Fix inconsistent button spacing',
    'in_progress',
    3,
    1,
    3,
    CURRENT_DATE + INTERVAL '3 days'
),

(
    'Update README',
    'Update project documentation',
    'done',
    1,
    1,
    1,
    CURRENT_DATE - INTERVAL '6 days'
),


-- Project 2

(
    'Create mobile layout',
    'Build responsive mobile layout',
    'done',
    3,
    2,
    4,
    CURRENT_DATE - INTERVAL '2 days'
),

(
    'Setup push notifications',
    'Configure push notification service',
    'todo',
    4,
    2,
    5,
    CURRENT_DATE + INTERVAL '12 days'
),

(
    'Implement profile screen',
    'Build user profile page',
    'in_progress',
    3,
    2,
    2,
    CURRENT_DATE + INTERVAL '8 days'
),

(
    'Fix mobile crash',
    'Resolve crash on startup',
    'done',
    5,
    2,
    1,
    CURRENT_DATE - INTERVAL '1 day'
),

(
    'Add dark mode',
    'Implement application dark mode',
    'todo',
    2,
    2,
    3,
    CURRENT_DATE + INTERVAL '15 days'
),

(
    'Improve performance',
    'Optimize application performance',
    'done',
    4,
    2,
    4,
    CURRENT_DATE - INTERVAL '4 days'
);


-- task_tags data 

INSERT INTO task_tags (task_id, tag_id)
VALUES
    (1, 1),
    (1, 5),

    (2, 1),
    (2, 3),

    (3, 2),
    (3, 5),
    (3, 4),

    (4, 6),

    (5, 1),

    (6, 2),
    (6, 3),
    (6, 4),

    (7, 6),

    (8, 1),
    (8, 3),

    (9, 6),

    (10, 1),
    (10, 5),

    (11, 2),

    (12, 1),
    (12, 5),

    (13, 3),
    (13, 4),

    (14, 1),
    (14, 5),

    (15, 2),
    (15, 3);

-- commits seeds data
INSERT INTO comments (
    task_id,
    author_id,
    body
)
VALUES
    (1, 2, 'Homepage looks good.'),
    (1, 1, 'Approved for production.'),

    (2, 3, 'Navbar issue reproduced.'),

    (3, 1, 'Authentication work is in progress.'),

    (6, 2, 'This bug needs urgent attention.'),
    (6, 3, 'I found the source of the problem.'),

    (7, 4, 'Testing guide needs more examples.'),

    (10, 4, 'Mobile layout is ready.'),

    (12, 2, 'Profile screen needs another review.'),

    (13, 1, 'Mobile crash has been fixed.');