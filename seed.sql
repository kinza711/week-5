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