create reactive view view1 select * from customer, orders, lineitem, nation where c_custkey = o_custkey and l_orderkey = o_orderkey and c_nationkey = n_nationkey;
