CREATE TABLE sk_users(userID INTEGER PRIMARY KEY, userName STRING);
CREATE INDEX sk_users_userName ON sk_users(userName);
