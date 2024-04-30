create table if not exists a(x integer, y integer);
create table if not exists b(x integer, z integer);
delete from a;
delete from b;
insert into a values (0,0), (1,1), (2,2);
insert into b values (0,0), (1,1), (2,2);
select a.x, y, z, check(y = z) from a inner join b on a.x = b.x;
