-- using 1433771997 as a seed to the RNG


select
	o_orderpriority,
	count(*) as order_count
from
	orders
where
	o_orderdate >= cast('1997-06-01' as datetime)
	and o_orderdate < cast('1997-06-01' as datetime) + cast({'month': 3} as interval)
	and exists (
		select
			*
		from
			lineitem
		where
			l_orderkey = o_orderkey
			and l_commitdate < l_receiptdate
	)
group by
	o_orderpriority
order by
	o_orderpriority;
