create table if not exists test(x integer);
delete from test;
insert into test values (0), (1), (2);
select check(x < 2) from test;
-- should fail
