-- using 1433771997 as a seed to the RNG


select
	s_name,
	s_address
from
	supplier,
	nation
where
	s_suppkey in (
		select
			ps_suppkey
		from
			partsupp
		where
			ps_partkey in (
				select
					p_partkey
				from
					part
				where
					p_name like 'frosted%'
			)
			and ps_availqty > (
				select
					0.5 * sum(l_quantity)
				from
					lineitem
				where
					l_partkey = ps_partkey
					and l_suppkey = ps_suppkey
					and l_shipdate >= cast('1994-01-01' as datetime)
					and l_shipdate < cast('1994-01-01' as datetime) + cast({'year': 1} as interval)
			)
	)
	and s_nationkey = n_nationkey
	and n_name = 'IRAN'
order by
	s_name;
