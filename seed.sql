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