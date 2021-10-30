begin transaction;

insert into t1 select sum(col0) from t1;
insert into t1 select sum(col0) from t1;
insert into t1 select 1 + sum(col0) from t1;
delete from t1 where col0 % 2 = 0;
insert into t1 select sum(col0) from t1;
insert into t1 select 1 + sum(col0) from t1;
update t1 set col0 = col0 + 2 where col0 % 2 = 1;
insert into t1 select 1 + sum(col0) from t1;
update t1 set col0 = col0 + 2 where col0 % 2 = 0;
insert into t1 select 1 + sum(col0) from t1;
delete from t1 where col0 = 1;
insert into t1 values(1);

--update t1 set col0 = col0 + 2 where col0 % 2 = 1;
--delete from t1 where col0=1;
commit;


