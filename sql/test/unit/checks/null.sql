create table if not exists contains_null (x integer);
delete from contains_null;
insert into contains_null values (1), (NULL), (2);
SELECT x, check(x < 3) from contains_null order by x;
