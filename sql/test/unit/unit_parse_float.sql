create table t1(f FLOAT);

select 1000000000.0;
select 10000000000.0;
select 100000000000000.0;
select 1000000000000000.0;
select 0.00001;
select 0.000011;
select 0.00009;
select 0.0001;
select 0.0009;
select 58.;
select 4e2;
select 123.456e-67;
select 0.1E4;

select -100000000000000.0;
select -1000000000000000.0;
select -0.0001;
select -0.00001;
select -0.000000001;
select -0.0000000001;
select -58.;
select -4e2;
select -123.456e-67;
select -0.1E4;


insert into t1 values(100000000000000.0);
insert into t1 values(1000000000000000.0);
insert into t1 values(0.00001);
insert into t1 values(0.000011);
insert into t1 values(0.00009);
insert into t1 values(0.0001);
insert into t1 values(0.0009);
insert into t1 values(0.0001);
insert into t1 values(0.00001);
insert into t1 values(58.);
insert into t1 values(4e2);
insert into t1 values(123.456e-67);
insert into t1 values(0.1E4);


insert into t1 values(-100000000000000.0);
insert into t1 values(-1000000000000000.0);
insert into t1 values(-0.0001);
insert into t1 values(-0.00001);
insert into t1 values(-0.00000001);
insert into t1 values(-0.000000001);
insert into t1 values(-58.);
insert into t1 values(-4e2);
insert into t1 values(-123.456e-67);
insert into t1 values(-0.1E4);


select * from t1 order by f desc;
