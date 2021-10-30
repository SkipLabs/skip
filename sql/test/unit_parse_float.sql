create table t1(f FLOAT);

select 100000000000000.0;
select 58.;
select 4e2;
select 123.456e-67;
select 0.1E4;

select -100000000000000.0;
select -58.;
select -4e2;
select -123.456e-67;
select -0.1E4;


insert into t1 values(100000000000000.0);
insert into t1 values(58.);
insert into t1 values(4e2);
insert into t1 values(123.456e-67);
insert into t1 values(0.1E4);


insert into t1 values(-100000000000000.0);
insert into t1 values(-58.);
insert into t1 values(-4e2);
insert into t1 values(-123.456e-67);
insert into t1 values(-0.1E4);


select * from t1;
