CREATE REACTIVE VIEW V0 AS select a, sum(b) from t1 group by a;
CREATE REACTIVE VIEW V1 AS select sum(b) from t1;
