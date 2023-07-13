CREATE VIRTUAL VIEW V0 AS select a, sum(b) from t1 group by a;
CREATE VIRTUAL VIEW V1 AS select sum(b) from t1;
