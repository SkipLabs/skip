create table if not exists aggr(g integer, x integer);
delete from aggr;
insert into aggr values (0,0), (0,1), (0,2), (1,0);
SELECT CHECK(count(*) > 1) from aggr group by g;
