create table t (x int, y int);

insert into t values (1, 2), (3, 4);

create table v as select x, x as x1, y, y as y1, 'read-only' as skdb_access from t where x=1;

select x, x1, y, y1, skdb_access from v;

