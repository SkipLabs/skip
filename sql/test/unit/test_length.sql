create table t (x text, y text, z text);

insert into t values ('', null, 'test');

select x, length(x), y, length(y), z, length(z) from t;
