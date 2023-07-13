create table t1 (a INTEGER PRIMARY KEY, b STRING, c STRING default 'hello');
create table t2 (a INTEGER PRIMARY KEY, b STRING, c STRING not null default 'hello');
create table t3 (a INTEGER PRIMARY KEY, b STRING, c STRING default 'hello' not null);
insert into t1 (b, c) values ('test1', 'test2');
insert into t1 (a, c) values (id(), 'foo');
insert into t1 (a, b) values (id(), 'bar');
select * from t1;
