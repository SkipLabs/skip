create table t_int (c_int INTEGER);

insert into t_int values (@one), (@zero), (@null), (@true), (@false);

select * from t_int order by c_int asc;
select * from t_int where c_int<>@zero order by c_int asc;

delete from t_int where c_int=@zero;
select * from t_int order by c_int asc;

update t_int set c_int = @zero where c_int <> @zero;
select * from t_int order by c_int asc;

create table t_bool (c_bool BOOLEAN);

insert into t_bool values (@one), (@zero), (@null), (@true), (@false);

select * from t_bool order by c_bool asc;
select * from t_bool where c_bool <> @false order by c_bool asc;

create table t_real (c_real REAL);

insert into t_real values (@one), (@zero), (@null), (@true), (@false), (@life), (@pi), (@Avogadro), (@elementary_charge);

select * from t_real order by c_real asc;
select * from t_real where c_real <> @pi order by c_real asc;

create table t_string (c_string TEXT);

insert into t_string values (@one_string), (@zero_string), (@null), (@null_string), (@true_string), (@false_string), (@life_string), (@pi_string), (@expression_string), (@string), (@at_string), (@horns);

select * from t_string order by c_string asc;
select * from t_string where c_string <> @false_string order by c_string asc;
