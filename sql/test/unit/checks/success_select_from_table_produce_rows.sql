create table if not exists test(x integer);
delete from test;
insert into test values (0), (1), (2);
select check(x < 3), x from test;
--should succeed, 3 rows, no check col
