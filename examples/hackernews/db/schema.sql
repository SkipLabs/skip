CREATE TABLE users (
       "id" SERIAL PRIMARY KEY,
       "name" TEXT,
       "email" TEXT
);
CREATE TABLE posts (
       "id" SERIAL PRIMARY KEY,
       "author_id" INTEGER,
       "title" TEXT,
       "url" TEXT,
       "body" TEXT,
       "date" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE upvotes (
       "id" SERIAL PRIMARY KEY,
       "user_id" INTEGER,
       "post_id" INTEGER
);

-- Fixtures
INSERT INTO users("id", "name", "email") VALUES
       (1, 'Benno', 'benno@skiplabs.io'),
       (2, 'Charles', 'charles@skiplabs.io'),
       (3, 'Daniel', 'daniel@skiplabs.io'),
       (4, 'Josh', 'josh@skiplabs.io'),
       (5, 'Julien', 'julien@skiplabs.io'),
       (6, 'Laure', 'laure@skiplabs.io'),
       (7, 'Lucas', 'lucas@skiplabs.io'),
       (8, 'Mehdi', 'mehdi@skiplabs.io'),
       (9, 'Hugo', 'hugo@skiplabs.io');
SELECT setval('users_id_seq', max(id) + 1) FROM users;

INSERT INTO posts("id", "title", "url", "body", "author_id", "date") VALUES
       (0, 'Skip''s Origins', 'https://skiplabs.io/blog/skips-origins', '', 5, '2025-02-11 00:00:00+00'),
       (1, 'New skiplabs website!', 'https://skiplabs.io', '', 2, '2025-01-12 00:00:00+00'),
       (2, 'Why Skip?', 'https://skiplabs.io/blog/why-skip', '', 5, '2025-02-11 00:00:00+00'),
       (3, 'Skip alpha just dropped', 'https://skiplabs.io/blog/skip-alpha', '', 3, '2024-12-24 00:00:00+00'),
       (4, 'Skip docs website', 'https://skiplabs.io/docs/introduction', '', 4, '2024-11-11 00:00:00+00'),
       (5, 'Building a HN clone with Skip', 'https://github.com/SkipLabs/skip/pull/343/', '', 7, '2024-09-28 00:00:00+00');
SELECT setval('posts_id_seq', max(id) + 1) FROM posts;

INSERT INTO upvotes("user_id", "post_id") VALUES
       (1, 0), (2, 0), (5, 0), (8, 0),
       (1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1), (8, 1),
       (3, 2), (5, 2), (7, 2),
       (1, 3), (3, 3),
       (2, 4), (3, 4), (5, 4),
       (1, 5), (2, 5), (3, 5), (4, 5), (5, 5), (6, 5), (8, 5);
