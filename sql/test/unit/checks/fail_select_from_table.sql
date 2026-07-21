create table if not exists test(x integer);
delete from test;
insert into test values (0), (1), (2);
select check(t.x < 2) from test t;
-- should fail
