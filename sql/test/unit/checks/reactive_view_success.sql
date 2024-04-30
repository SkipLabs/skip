CREATE TABLE IF NOT EXISTS testneg(x integer);
DELETE FROM testneg;
CREATE REACTIVE VIEW testnegcheck AS SELECT CHECK(x < 0) FROM testneg;
INSERT INTO testneg VALUES (-10);
SELECT * FROM testneg;
