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
       "body" TEXT
);
CREATE TABLE upvotes (
       "id" SERIAL PRIMARY KEY,
       "user_id" INTEGER,
       "post_id" INTEGER
);

-- Fixtures
INSERT INTO users("id", "name", "email") VALUES
       (1, 'Lucas', 'lucas@skiplabs.io'),
       (2, 'Daniel', 'daniel@skiplabs.io');
INSERT INTO posts("title", "url", "body", "author_id") VALUES
       ('Hello!', 'http://foo.org', 'This is a post', 1),
       ('Reactive stuff', 'http://bar.net', 'This is neat.', 2);
