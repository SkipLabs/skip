create table if not exists test(x integer);
delete from test;
insert into test values (0), (1), (2);
select check(x < 3) from test;
--should succeed, no rows
