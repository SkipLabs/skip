CREATE DATABASE uptrace;
CREATE USER uptrace WITH ENCRYPTED PASSWORD 'uptrace';
GRANT ALL PRIVILEGES ON DATABASE uptrace TO uptrace;
\c uptrace
GRANT ALL ON SCHEMA public TO uptrace;