-- Create users table (for the cache)
CREATE TABLE users (
    "id" SERIAL PRIMARY KEY,
    "username" TEXT UNIQUE NOT NULL,
    "email" TEXT UNIQUE NOT NULL,
    "password_hash" TEXT NOT NULL,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create posts table (including drafts)
CREATE TABLE posts (
    "id" SERIAL PRIMARY KEY,
    "author_id" INTEGER REFERENCES users(id),
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "status" TEXT NOT NULL CHECK (status IN ('draft', 'published')),
    "published_at" TIMESTAMP WITH TIME ZONE,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create tags table for categorizing posts
CREATE TABLE tags (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT UNIQUE NOT NULL
);

-- Create post_tags junction table for many-to-many relationship
CREATE TABLE post_tags (
    "post_id" INTEGER REFERENCES posts(id) ON DELETE CASCADE,
    "tag_id" INTEGER REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (post_id, tag_id)
);

-- Create indexes for better performance
CREATE INDEX idx_posts_status ON posts(status);
CREATE INDEX idx_posts_author ON posts(author_id);
CREATE INDEX idx_posts_published_at ON posts(published_at);

-- Insert SkipLabs team members
INSERT INTO users (username, email, password_hash) VALUES
    ('benno', 'benno@skiplabs.io', 'benno'),
    ('charles', 'charles@skiplabs.io', 'charles'),
    ('daniel', 'daniel@skiplabs.io', 'daniel'),
    ('josh', 'josh@skiplabs.io', 'josh'),
    ('julien', 'julien@skiplabs.io', 'julien'),
    ('laure', 'laure@skiplabs.io', 'laure'),
    ('lucas', 'lucas@skiplabs.io', 'lucas'),
    ('mehdi', 'mehdi@skiplabs.io', 'mehdi'),
    ('sumner', 'sumner@skiplabs.io', 'sumner'),
    ('hugo', 'hugo@skiplabs.io', 'hugo');

-- Insert sample tags
INSERT INTO tags (name) VALUES
    ('Technology'),
    ('Programming'),
    ('Web Development');

-- Insert sample posts (one draft, one published)
INSERT INTO posts (author_id, title, content, status, published_at) VALUES
    (1, 'My First Blog Post', 'This is my first blog post content...', 'published', CURRENT_TIMESTAMP),
    (1, 'Working on Something New', 'This is a draft post...', 'draft', NULL);

-- Link posts to tags
INSERT INTO post_tags (post_id, tag_id) VALUES
    (1, 1),
    (1, 2),
    (2, 1);
