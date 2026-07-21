CREATE TABLE t (id INTEGER PRIMARY KEY, x VARCHAR(10), Y VARCHAR(10), abcDEF VARCHAR(10));

insert into t(id, x, Y, abcDEF) values (0, 'a', 'a', 'a');
insert into t(id, x, y, abcdef) values (1, 'b', 'b', 'b');
INSERT INTO T(ID, X, Y, ABCDEF) VALUES (2, 'c', 'c', 'c');

SELECT id, x, Y, abcDEF from t;
select id, x, y, abcdef from t;
SELECT ID, X, Y, ABCDEF FROM T;
SELECT ID, T.X, Y, ABCDEF FROM T;
select id, x, Y, abcDEF from t where abcdef > 'a';
select id, x, Y, abcDEF from t where ABCDEF > 'a';
select id, x, Y, abcDEF from t where abcDEF > 'a';
select id, T.x, Y, abcDEF from t where abcDEF > 'a';

CREATE INDEX tx ON t (x);
CREATE INDEX ty ON t (y);
CREATE INDEX tabcDef ON t (ABCDEF);

SELECT 'updates:';

update t set x = 'z';
UPDATE T SET X = 'Z';

SELECT * FROM t;

SELECT 'deletes:';

delete from t where Y = 'a';
DELETE FROM T WHERE Y = 'b';
delete from t where y = 'c';
delete from t where t.y = 'c';
delete from t where T.Y = 'c';

SELECT * FROM T;

drop table T;

SELECT 'done';
