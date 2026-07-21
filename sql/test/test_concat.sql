create table t1(id INTEGER PRIMARY KEY, val VARCHAR(23));

insert into t1 values(1, 'hello');

select val || val from t1;
