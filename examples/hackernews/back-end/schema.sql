CREATE TABLE IF NOT EXISTS users (
       "id" INTEGER PRIMARY KEY AUTOINCREMENT,
       "name" TEXT,
       "email" TEXT
);
CREATE TABLE IF NOT EXISTS posts (
       "id" INTEGER PRIMARY KEY AUTOINCREMENT,
       "author_id" INTEGER,
       "title" TEXT,
       "url" TEXT,
       "body" TEXT
);
CREATE TABLE IF NOT EXISTS upvotes (
       "id" INTEGER PRIMARY KEY AUTOINCREMENT,
       "user_id" INTEGER,
       "post_id" INTEGER
);

-- Fixtures
INSERT INTO posts("title", "url", "body") VALUES
       ('Hello!', 'http://foo.org', 'This is a post'),
       ('Reactive stuff', 'http://bar.net', 'This is neat.');
