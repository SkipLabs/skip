create table if not exists aggr(g integer, x integer);
delete from aggr;
insert into aggr values (0,0), (0,1), (0,2), (1,0);
SELECT g, CHECK(count(*) < 2), count(*) as n from aggr group by g;
