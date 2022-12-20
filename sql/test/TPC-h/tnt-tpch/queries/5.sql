-- using 1433771997 as a seed to the RNG


select
	n_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue
from
	customer,
	orders,
	lineitem,
	supplier,
	nation,
	region
where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and l_suppkey = s_suppkey
	and c_nationkey = s_nationkey
	and s_nationkey = n_nationkey
	and n_regionkey = r_regionkey
	and r_name = 'MIDDLE EAST'
	and o_orderdate >= cast('1994-01-01' as datetime)
	and o_orderdate < cast('1994-01-01' as datetime) + cast({'year': 1} as interval)
group by
	n_name
order by
	revenue desc;
