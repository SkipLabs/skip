CREATE REACTIVE VIEW V0 AS select a, sum(b) from t1 group by a LIMIT 5;
CREATE REACTIVE VIEW V1 AS select sum(b) from t1 LIMIT 5;
