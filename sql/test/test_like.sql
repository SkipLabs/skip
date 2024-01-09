create table t1(a TEXT);

insert into t1 values ('abc');
insert into t1 values ('abcd');
insert into t1 values ('abcde');
insert into t1 values ('bcde');
insert into t1 values ('cde');

select * from t1 where a like 'abc%';

create table t2(a TEXT);
create index t2a on t2(a);

insert into t2 values ('abc');
insert into t2 values ('a');
insert into t2 values ('abcd');
insert into t2 values ('abcde');
insert into t2 values ('bcde');
insert into t2 values ('cde');

select * from t2 where a like 'abc%';
