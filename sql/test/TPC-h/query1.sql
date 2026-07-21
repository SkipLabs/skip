create reactive view query1 as select
  c_custkey,
  c_name,
  sum(l_extendedprice * (1.0 - l_discount)) as revenue,
  c_acctbal,
  n_name,
  c_address,
  c_phone,
  c_comment
from
  view1
where
    o_orderdate >= date('1994-01-01')
and o_orderdate < date('1994-01-01', '+ 3 months')
and l_returnflag = 'R'
group by
  c_custkey,
  c_name,
  c_acctbal,
  c_phone,
  n_name,
  c_address,
  c_comment
;
