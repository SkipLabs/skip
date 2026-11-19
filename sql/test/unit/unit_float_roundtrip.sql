create table t(f FLOAT);

-- Literals that need more than 9 significant digits to round-trip
-- (the pre-Ryu formatter printed 9 digits and lost the rest).
select 0.1 + 0.2;
select 0.30000000000000004;
select 123456789.123456789;
-- Extreme magnitudes: max double, min normal, min subnormal.
select 1.7976931348623157e308;
select 2.2250738585072014e-308;
select 5e-324;
select 1e308;
-- Notation boundaries (fixed vs scientific).
select 0.0001;
select 0.00001;
select 999999999999999.0;
select 1000000000000000.0;
select -0.0;

-- Storage round-trip through a FLOAT column.
insert into t values(0.30000000000000004);
insert into t values(1.7976931348623157e308);
insert into t values(5e-324);
insert into t values(2.2250738585072014e-308);
insert into t values(-0.0);
select * from t order by f;
