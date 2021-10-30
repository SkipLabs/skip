-- using 1433771997 as a seed to the RNG

create virtual view v1 as select
c_custkey
from
customer
group by
c_custkey,
c_name,
c_acctbal,
c_phone,
c_address,
c_comment
;
