create table t1 (a INTEGER PRIMARY KEY, b INTEGER);
create table t2 (a INTEGER, b INTEGER);
create table t3 (a INTEGER UNIQUE, b INTEGER, c INTEGER UNIQUE);
insert into t1 values(22, 23);
insert into t1 values(24, 25);
insert or ignore into t1 values(22, 24);
insert or replace into t1 values(24, 26);
insert or replace into t1 values(25, 27);

insert or replace into t2 values(31, 32);
insert or replace into t2 values(33, 34);

insert or replace into t3 values(41, 42, 43);
insert or replace into t3 values(51, 52, 53);
insert or replace into t3 values(51, 42, 43);
select * from t1;
select * from t2;
select * from t3;

