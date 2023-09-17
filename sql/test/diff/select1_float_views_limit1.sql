CREATE VIRTUAL VIEW V0 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V1 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V2 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(b-c),
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,2,1,3,5
 LIMIT 1;

CREATE VIRTUAL VIEW V3 AS SELECT c,
       d-e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0,
       e
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR c BETWEEN b-2.0 AND d+2.0
    OR (e>c OR e<d)
 ORDER BY 1,5,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V4 AS SELECT a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       abs(a),
       e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d
  FROM t1
 WHERE b>c
   AND c>d
 ORDER BY 3,4,5,1,2,6
 LIMIT 1;

CREATE VIRTUAL VIEW V5 AS SELECT a+b*2.0+c*3.0+d*4.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 4,2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V6 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V7 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c>d
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V8 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       a-b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR a>b
    OR b>c
 ORDER BY 1,4,3,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V9 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 4,1,5,2,6,3,7
 LIMIT 1;

CREATE VIRTUAL VIEW V10 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR a>b
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 5,3,6,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V11 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       a+b*2.0+c*3.0+d*4.0,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR c>d
 ORDER BY 3,5,4,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V12 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b,
       abs(b-c),
       c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 4,3,6,2,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V13 AS SELECT a+b*2.0,
       a,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (a+b+c+d+e)/5.0,
       e,
       c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE a>b
 ORDER BY 5,4,6,2,1,7,3
 LIMIT 1;

CREATE VIRTUAL VIEW V14 AS SELECT a,
       b
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V15 AS SELECT c,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V16 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a-b
  FROM t1
 WHERE b>c
   AND a>b
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,1,6,4,3,5
 LIMIT 1;

CREATE VIRTUAL VIEW V17 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a),
       b-c,
       c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1,5,4,2,6,3
 LIMIT 1;

CREATE VIRTUAL VIEW V18 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0
  FROM t1
 ORDER BY 4,3,5,1,6,2,7
 LIMIT 1;

CREATE VIRTUAL VIEW V19 AS SELECT a,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       a+b*2.0
  FROM t1
 ORDER BY 6,2,4,5,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V20 AS SELECT d-e,
       abs(a),
       b,
       c-d,
       a+b*2.0+c*3.0,
       abs(b-c),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND c>d
 ORDER BY 1,3,7,5,2,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V21 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0,
       b-c,
       c
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,5,1,7,3,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V22 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d,
       c
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,4,5,6,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V23 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND c>d
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V24 AS SELECT a+b*2.0+c*3.0,
       abs(b-c),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 6,1,7,3,4,5,2
 LIMIT 1;

CREATE VIRTUAL VIEW V25 AS SELECT a+b*2.0,
       a+b*2.0+c*3.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE d>e
   AND (c<=d-2.0 OR c>=d+2.0)
   AND b>c
 ORDER BY 2,3,1,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V26 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       abs(b-c),
       a+b*2.0,
       d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>c OR e<d)
    OR a>b
 ORDER BY 4,5,3,7,1,6,2
 LIMIT 1;

CREATE VIRTUAL VIEW V27 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d,
       a-b
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,5,4,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V28 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND a>b
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V29 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2.0 AND d+2.0
    OR c>d
 ORDER BY 3,2,1,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V30 AS SELECT d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       c-d,
       (a+b+c+d+e)/5.0,
       a-b
  FROM t1
 ORDER BY 3,4,2,6,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V31 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (a+b+c+d+e)/5.0,
       abs(b-c),
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 7,2,5,1,3,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V32 AS SELECT d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       c,
       e
  FROM t1
 WHERE b>c
 ORDER BY 1,2,4,3,5
 LIMIT 1;

CREATE VIRTUAL VIEW V33 AS SELECT a-b,
       a,
       a+b*2.0+c*3.0,
       b,
       d,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,6,4,1,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V34 AS SELECT (a+b+c+d+e)/5.0,
       a+b*2.0,
       c-d,
       a,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
 ORDER BY 2,6,5,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V35 AS SELECT b,
       (a+b+c+d+e)/5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       b-c
  FROM t1
 WHERE a>b
 ORDER BY 2,5,3,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V36 AS SELECT abs(b-c),
       a,
       a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 1,4,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V37 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c,
       d-e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND c>d
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V38 AS SELECT a,
       e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b
  FROM t1
 ORDER BY 2,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V39 AS SELECT (a+b+c+d+e)/5.0,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V40 AS SELECT a-b,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
 ORDER BY 4,1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V41 AS SELECT a+b*2.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR a>b
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V42 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,6,3,5,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V43 AS SELECT a,
       c-d,
       d
  FROM t1
 WHERE c>d
   AND a>b
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V44 AS SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c,
       (a+b+c+d+e)/5.0,
       b
  FROM t1
 ORDER BY 5,4,1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V45 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d,
       abs(a),
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,5,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V46 AS SELECT c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(a),
       (a+b+c+d+e)/5.0,
       a+b*2.0,
       d-e
  FROM t1
 WHERE b>c
   AND (a>b-2.0 AND a<b+2.0)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 4,5,3,1,2,6
 LIMIT 1;

CREATE VIRTUAL VIEW V47 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d
  FROM t1
 WHERE d>e
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,2,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V48 AS SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
 ORDER BY 2,3,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V49 AS SELECT a+b*2.0+c*3.0
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V50 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0
  FROM t1
 WHERE d>e
 ORDER BY 3,4,1,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V51 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE b>c
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V52 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0,
       b-c
  FROM t1
 WHERE d>e
 ORDER BY 4,1,5,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V53 AS SELECT a-b,
       a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V54 AS SELECT d,
       a+b*2.0,
       a,
       b,
       b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 5,2,7,1,4,6,3
 LIMIT 1;

CREATE VIRTUAL VIEW V55 AS SELECT e
  FROM t1
 WHERE b>c
   AND d>e
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V56 AS SELECT b,
       e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V57 AS SELECT b-c,
       d-e,
       c-d,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 1,2,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V58 AS SELECT abs(b-c),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V59 AS SELECT e,
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V60 AS SELECT abs(a),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d
  FROM t1
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V61 AS SELECT abs(a),
       c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0,
       d-e
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND d>e
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 5,3,1,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V62 AS SELECT (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>a AND e<b)
   AND c>d
 ORDER BY 2,5,6,4,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V63 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       b-c,
       (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a-b
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (e>c OR e<d)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 7,2,4,1,5,6,3
 LIMIT 1;

CREATE VIRTUAL VIEW V64 AS SELECT a+b*2.0,
       d,
       a,
       b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110.0 AND 150.0
   AND e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1,2,4,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V65 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 3,2,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V66 AS SELECT e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V67 AS SELECT abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,4,5,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V68 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND d>e
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V69 AS SELECT b-c
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V70 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       d-e,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,6,2,4,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V71 AS SELECT d,
       c,
       b,
       a+b*2.0+c*3.0+d*4.0,
       b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,5,6,2,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V72 AS SELECT b-c,
       (a+b+c+d+e)/5.0,
       c-d,
       b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE d>e
   AND d NOT BETWEEN 110.0 AND 150.0
   AND (e>a AND e<b)
 ORDER BY 1,3,2,5,4,6
 LIMIT 1;

CREATE VIRTUAL VIEW V73 AS SELECT abs(a),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 4,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V74 AS SELECT b,
       c,
       a-b,
       d-e,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d>e
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,1,4,3,5
 LIMIT 1;

CREATE VIRTUAL VIEW V75 AS SELECT a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND b>c
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V76 AS SELECT b,
       abs(a),
       a,
       c
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (e>c OR e<d)
    OR b>c
 ORDER BY 4,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V77 AS SELECT a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a+b*2.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
 ORDER BY 2,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V78 AS SELECT b,
       abs(b-c)
  FROM t1
 WHERE c>d
   AND a>b
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V79 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d-e,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       a,
       e
  FROM t1
 ORDER BY 4,5,1,3,7,6,2
 LIMIT 1;

CREATE VIRTUAL VIEW V80 AS SELECT d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d-e
  FROM t1
 ORDER BY 1,6,2,3,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V81 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V82 AS SELECT a+b*2.0+c*3.0+d*4.0,
       abs(b-c),
       c-d
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V83 AS SELECT a-b,
       abs(a),
       d
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V84 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2.0 OR c>=d+2.0)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V85 AS SELECT (a+b+c+d+e)/5.0,
       abs(a),
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V86 AS SELECT a+b*2.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a-b,
       abs(b-c),
       c,
       b,
       e
  FROM t1
 WHERE d>e
 ORDER BY 4,5,3,6,2,1,7
 LIMIT 1;

CREATE VIRTUAL VIEW V87 AS SELECT a,
       d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (a>b-2.0 AND a<b+2.0)
    OR b>c
 ORDER BY 1,3,5,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V88 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0,
       d-e,
       b,
       a,
       c,
       a+b*2.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR (e>a AND e<b)
    OR d>e
 ORDER BY 5,6,3,7,2,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V89 AS SELECT b-c,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE c>d
    OR (a>b-2.0 AND a<b+2.0)
    OR b>c
 ORDER BY 1,3,5,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V90 AS SELECT b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       c-d,
       d
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110.0 AND 150.0
    OR (e>c OR e<d)
 ORDER BY 4,6,5,1,3,7,2
 LIMIT 1;

CREATE VIRTUAL VIEW V91 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (c<=d-2.0 OR c>=d+2.0)
    OR c>d
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V92 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V93 AS SELECT a+b*2.0+c*3.0+d*4.0,
       c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0,
       a+b*2.0,
       d-e
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,3,7,2,5,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V94 AS SELECT abs(a),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       d,
       a
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 6,2,4,3,1,7,5
 LIMIT 1;

CREATE VIRTUAL VIEW V95 AS SELECT (a+b+c+d+e)/5.0,
       a-b,
       b,
       a+b*2.0,
       a
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND (e>c OR e<d)
   AND d>e
 ORDER BY 4,2,5,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V96 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       e,
       c-d,
       a+b*2.0+c*3.0+d*4.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND c>d
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,4,3,2,5,6
 LIMIT 1;

CREATE VIRTUAL VIEW V97 AS SELECT c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a,
       abs(a),
       abs(b-c),
       a+b*2.0+c*3.0,
       e
  FROM t1
 WHERE d>e
   AND (e>a AND e<b)
 ORDER BY 7,2,6,1,3,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V98 AS SELECT c-d,
       d-e,
       abs(a),
       a,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE a>b
    OR c>d
 ORDER BY 1,5,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V99 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       abs(a),
       a-b,
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
 ORDER BY 4,6,3,1,5,2
 LIMIT 1;

CREATE VIRTUAL VIEW V100 AS SELECT a+b*2.0+c*3.0,
       a
  FROM t1
 WHERE (e>c OR e<d)
    OR a>b
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V101 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (a>b-2.0 AND a<b+2.0)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V102 AS SELECT a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       a+b*2.0+c*3.0
  FROM t1
 WHERE d>e
 ORDER BY 4,2,1,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V103 AS SELECT e
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V104 AS SELECT c-d,
       b,
       d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c>d
 ORDER BY 4,3,5,6,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V105 AS SELECT abs(b-c),
       c-d,
       a,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
 ORDER BY 4,2,1,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V106 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0
  FROM t1
 WHERE c>d
   AND b>c
   AND e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,4,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V107 AS SELECT (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V108 AS SELECT a+b*2.0,
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
 ORDER BY 6,5,4,1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V109 AS SELECT a+b*2.0+c*3.0+d*4.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d,
       e
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V110 AS SELECT a+b*2.0+c*3.0,
       a+b*2.0,
       a-b,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE a>b
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
 ORDER BY 2,1,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V111 AS SELECT (a+b+c+d+e)/5.0,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V112 AS SELECT abs(a),
       d,
       e,
       a+b*2.0+c*3.0+d*4.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c,
       a
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 3,2,7,6,4,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V113 AS SELECT c,
       d,
       a+b*2.0+c*3.0,
       a-b,
       e
  FROM t1
 ORDER BY 3,2,1,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V114 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       (a+b+c+d+e)/5.0,
       abs(b-c),
       a+b*2.0+c*3.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND (e>c OR e<d)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 6,7,2,1,3,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V115 AS SELECT (a+b+c+d+e)/5.0,
       c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0,
       d-e
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2.0 AND d+2.0
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,3,4,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V116 AS SELECT c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0,
       a,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR b>c
 ORDER BY 3,5,4,2,6,7,1
 LIMIT 1;

CREATE VIRTUAL VIEW V117 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(a),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d>e
    OR b>c
 ORDER BY 2,3,1,5,4,6
 LIMIT 1;

CREATE VIRTUAL VIEW V118 AS SELECT b-c,
       a+b*2.0,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,3,6,2,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V119 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V120 AS SELECT b,
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
    OR c BETWEEN b-2.0 AND d+2.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V121 AS SELECT a+b*2.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       c-d,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 5,1,4,7,3,2,6
 LIMIT 1;

CREATE VIRTUAL VIEW V122 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>a AND e<b)
   AND (e>c OR e<d)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V123 AS SELECT a+b*2.0+c*3.0+d*4.0,
       b,
       a-b
  FROM t1
 WHERE c>d
    OR d>e
    OR b>c
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V124 AS SELECT a-b
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V125 AS SELECT e,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,2,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V126 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0
  FROM t1
 ORDER BY 2,4,1,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V127 AS SELECT b-c,
       c,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d NOT BETWEEN 110.0 AND 150.0
    OR b>c
 ORDER BY 3,5,4,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V128 AS SELECT b-c,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE b>c
   AND a>b
   AND (e>a AND e<b)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V129 AS SELECT a+b*2.0,
       b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE b>c
   AND a>b
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V130 AS SELECT a+b*2.0+c*3.0,
       d,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND b>c
   AND c>d
 ORDER BY 3,5,1,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V131 AS SELECT d-e,
       (a+b+c+d+e)/5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 2,1,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V132 AS SELECT c-d,
       e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND c>d
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V133 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V134 AS SELECT a-b,
       b-c
  FROM t1
 WHERE b>c
   AND d>e
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V135 AS SELECT b,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V136 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V137 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       a+b*2.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V138 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V139 AS SELECT a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V140 AS SELECT e,
       a,
       a+b*2.0+c*3.0,
       b,
       d
  FROM t1
 WHERE c>d
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,5,1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V141 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE a>b
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V142 AS SELECT abs(a),
       (a+b+c+d+e)/5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0,
       d-e
  FROM t1
 ORDER BY 3,1,2,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V143 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       (a+b+c+d+e)/5.0,
       a+b*2.0,
       c-d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 5,3,2,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V144 AS SELECT c,
       a+b*2.0,
       abs(b-c)
  FROM t1
 WHERE b>c
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V145 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       a+b*2.0+c*3.0+d*4.0,
       c,
       a+b*2.0
  FROM t1
 ORDER BY 7,3,2,6,4,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V146 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a),
       a-b
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V147 AS SELECT d
  FROM t1
 WHERE (e>a AND e<b)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V148 AS SELECT (a+b+c+d+e)/5.0,
       abs(b-c),
       c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a),
       e
  FROM t1
 WHERE b>c
   AND d>e
 ORDER BY 4,5,6,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V149 AS SELECT a+b*2.0+c*3.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V150 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       a
  FROM t1
 WHERE b>c
   AND d>e
 ORDER BY 4,1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V151 AS SELECT a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       a,
       abs(a),
       c-d,
       c
  FROM t1
 ORDER BY 2,5,4,6,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V152 AS SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V153 AS SELECT abs(b-c),
       b,
       e
  FROM t1
 WHERE a>b
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V154 AS SELECT abs(a),
       a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c),
       d-e
  FROM t1
 ORDER BY 3,1,4,5,2
 LIMIT 1;

CREATE VIRTUAL VIEW V155 AS SELECT abs(b-c),
       e
  FROM t1
 WHERE c>d
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V156 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V157 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
 ORDER BY 7,2,4,6,1,3,5
 LIMIT 1;

CREATE VIRTUAL VIEW V158 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V159 AS SELECT b,
       e
  FROM t1
 WHERE d>e
    OR (a>b-2.0 AND a<b+2.0)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V160 AS SELECT a+b*2.0+c*3.0,
       a+b*2.0
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V161 AS SELECT (a+b+c+d+e)/5.0,
       d,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V162 AS SELECT abs(b-c),
       c-d
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V163 AS SELECT a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       a+b*2.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR a>b
    OR b>c
 ORDER BY 3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V164 AS SELECT a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d,
       a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
   AND (c<=d-2.0 OR c>=d+2.0)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,3,1,6,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V165 AS SELECT c,
       b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V166 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d,
       d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V167 AS SELECT b
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V168 AS SELECT a+b*2.0+c*3.0
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V169 AS SELECT abs(a),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND d NOT BETWEEN 110.0 AND 150.0
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V170 AS SELECT (a+b+c+d+e)/5.0,
       a+b*2.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       d-e
  FROM t1
 WHERE d>e
   AND (e>a AND e<b)
   AND b>c
 ORDER BY 1,5,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V171 AS SELECT a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
    OR a>b
    OR (e>a AND e<b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V172 AS SELECT a+b*2.0+c*3.0,
       e,
       a-b
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND b>c
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V173 AS SELECT d-e,
       a,
       b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V174 AS SELECT b,
       d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0
  FROM t1
 WHERE d>e
   AND c>d
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 6,5,2,1,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V175 AS SELECT (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110.0 AND 150.0
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V176 AS SELECT a+b*2.0+c*3.0,
       c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
    OR (c<=d-2.0 OR c>=d+2.0)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,2,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V177 AS SELECT (a+b+c+d+e)/5.0,
       abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a-b,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 3,5,1,2,7,4,6
 LIMIT 1;

CREATE VIRTUAL VIEW V178 AS SELECT a,
       abs(a),
       d,
       (a+b+c+d+e)/5.0,
       c-d
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
 ORDER BY 2,1,3,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V179 AS SELECT a+b*2.0+c*3.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,5,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V180 AS SELECT c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND d>e
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 7,2,1,5,6,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V181 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE a>b
 ORDER BY 7,6,5,2,1,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V182 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
   AND (c<=d-2.0 OR c>=d+2.0)
   AND c>d
 ORDER BY 6,5,4,2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V183 AS SELECT c,
       a+b*2.0,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V184 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0,
       b,
       b-c,
       e,
       a
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,2,1,6,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V185 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0,
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V186 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d
  FROM t1
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V187 AS SELECT d-e,
       abs(b-c),
       (a+b+c+d+e)/5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND (e>a AND e<b)
   AND a>b
 ORDER BY 3,4,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V188 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0,
       b-c,
       d-e
  FROM t1
 ORDER BY 1,2,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V189 AS SELECT d,
       a+b*2.0+c*3.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V190 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       d,
       a+b*2.0+c*3.0+d*4.0,
       c,
       d-e,
       a+b*2.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (a>b-2.0 AND a<b+2.0)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 4,6,2,5,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V191 AS SELECT abs(a),
       abs(b-c),
       c,
       a-b,
       c-d,
       a+b*2.0+c*3.0+d*4.0,
       b
  FROM t1
 ORDER BY 2,6,7,4,1,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V192 AS SELECT b,
       d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
    OR a>b
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V193 AS SELECT a-b,
       a+b*2.0+c*3.0+d*4.0,
       d,
       e
  FROM t1
 ORDER BY 2,4,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V194 AS SELECT a+b*2.0,
       c-d,
       d-e,
       abs(a),
       a-b,
       c,
       b
  FROM t1
 WHERE a>b
 ORDER BY 3,2,1,4,7,5,6
 LIMIT 1;

CREATE VIRTUAL VIEW V195 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2.0+c*3.0+d*4.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0,
       abs(a),
       c-d
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (e>c OR e<d)
 ORDER BY 1,4,2,5,7,3,6
 LIMIT 1;

CREATE VIRTUAL VIEW V196 AS SELECT d,
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       c
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
    OR (e>c OR e<d)
 ORDER BY 2,3,1,4,5,6
 LIMIT 1;

CREATE VIRTUAL VIEW V197 AS SELECT d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V198 AS SELECT a+b*2.0,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V199 AS SELECT a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b,
       c,
       abs(a)
  FROM t1
 WHERE d>e
 ORDER BY 1,3,2,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V200 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d
  FROM t1
 ORDER BY 4,1,2,3,5
 LIMIT 1;

CREATE VIRTUAL VIEW V201 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2.0+c*3.0,
       c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR d>e
 ORDER BY 3,4,2,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V202 AS SELECT abs(a)
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V203 AS SELECT a+b*2.0+c*3.0+d*4.0,
       d,
       a-b,
       abs(a),
       c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 5,2,1,4,6,3
 LIMIT 1;

CREATE VIRTUAL VIEW V204 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       a-b,
       a+b*2.0+c*3.0,
       d-e,
       b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,5,6,2,4,7,3
 LIMIT 1;

CREATE VIRTUAL VIEW V205 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c,
       a
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
   AND a>b
 ORDER BY 2,4,6,5,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V206 AS SELECT a+b*2.0+c*3.0+d*4.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
 ORDER BY 4,1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V207 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V208 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       b-c,
       a+b*2.0+c*3.0+d*4.0,
       c,
       abs(a)
  FROM t1
 WHERE d>e
 ORDER BY 2,1,4,5,6,3,7
 LIMIT 1;

CREATE VIRTUAL VIEW V209 AS SELECT b,
       a+b*2.0+c*3.0+d*4.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 5,4,2,1,3,6
 LIMIT 1;

CREATE VIRTUAL VIEW V210 AS SELECT d,
       a,
       abs(b-c),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c,
       (a+b+c+d+e)/5.0,
       e
  FROM t1
 WHERE (e>c OR e<d)
    OR (a>b-2.0 AND a<b+2.0)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,5,1,4,7,6,2
 LIMIT 1;

CREATE VIRTUAL VIEW V211 AS SELECT a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b
  FROM t1
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V212 AS SELECT b,
       a-b,
       c,
       abs(b-c),
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,6,4,5,2,7,3
 LIMIT 1;

CREATE VIRTUAL VIEW V213 AS SELECT c-d,
       a+b*2.0+c*3.0+d*4.0,
       a,
       abs(b-c),
       abs(a),
       (a+b+c+d+e)/5.0,
       c
  FROM t1
 ORDER BY 2,4,5,6,3,7,1
 LIMIT 1;

CREATE VIRTUAL VIEW V214 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       e,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d,
       a-b
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (e>a AND e<b)
 ORDER BY 7,4,1,2,6,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V215 AS SELECT a+b*2.0,
       b,
       d-e,
       a,
       abs(b-c),
       d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,5,4,3,6
 LIMIT 1;

CREATE VIRTUAL VIEW V216 AS SELECT d
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V217 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a,
       a+b*2.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 5,6,3,1,2,4,7
 LIMIT 1;

CREATE VIRTUAL VIEW V218 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d-e
  FROM t1
 WHERE b>c
   AND d>e
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V219 AS SELECT abs(a),
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
    OR (e>a AND e<b)
 ORDER BY 2,4,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V220 AS SELECT a+b*2.0+c*3.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND c BETWEEN b-2.0 AND d+2.0
   AND b>c
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V221 AS SELECT d,
       abs(b-c),
       a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0,
       e,
       b
  FROM t1
 ORDER BY 2,6,3,5,7,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V222 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V223 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       d-e,
       b,
       abs(b-c),
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 6,1,4,2,5,3,7
 LIMIT 1;

CREATE VIRTUAL VIEW V224 AS SELECT abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       e
  FROM t1
 WHERE c>d
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,3,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V225 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2.0+c*3.0,
       abs(b-c),
       c-d,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 3,2,6,4,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V226 AS SELECT d-e,
       a+b*2.0+c*3.0+d*4.0,
       d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b,
       b
  FROM t1
 WHERE c>d
   AND a>b
 ORDER BY 2,4,3,6,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V227 AS SELECT abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND c>d
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V228 AS SELECT c,
       c-d,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND a>b
   AND c>d
 ORDER BY 7,1,5,3,2,4,6
 LIMIT 1;

CREATE VIRTUAL VIEW V229 AS SELECT a-b,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
    OR d>e
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V230 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0,
       c-d,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 2,3,4,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V231 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V232 AS SELECT d-e
  FROM t1
 WHERE a>b
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V233 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR d NOT BETWEEN 110.0 AND 150.0
    OR b>c
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V234 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d>e
    OR (e>c OR e<d)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V235 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,4,5,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V236 AS SELECT a,
       abs(a),
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V237 AS SELECT b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0,
       b,
       abs(b-c),
       c-d
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND d>e
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,5,6,7,2,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V238 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b,
       abs(b-c)
  FROM t1
 WHERE c>d
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V239 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2.0 AND d+2.0
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V240 AS SELECT (a+b+c+d+e)/5.0,
       a,
       b
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V241 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a-b,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a
  FROM t1
 ORDER BY 2,4,5,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V242 AS SELECT c,
       a-b,
       a+b*2.0+c*3.0,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR d>e
    OR a>b
 ORDER BY 5,3,2,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V243 AS SELECT (a+b+c+d+e)/5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       b-c,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (e>c OR e<d)
   AND (c<=d-2.0 OR c>=d+2.0)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,5,4,6,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V244 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       a,
       abs(a),
       b,
       a+b*2.0
  FROM t1
 WHERE a>b
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,6,3,5,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V245 AS SELECT abs(b-c)
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V246 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c,
       d-e,
       a+b*2.0+c*3.0+d*4.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 6,4,1,5,3,7,2
 LIMIT 1;

CREATE VIRTUAL VIEW V247 AS SELECT a,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,4,5,6,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V248 AS SELECT (a+b+c+d+e)/5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (c<=d-2.0 OR c>=d+2.0)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V249 AS SELECT e
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V250 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V251 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V252 AS SELECT c
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V253 AS SELECT a+b*2.0,
       a,
       d,
       c,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 4,2,3,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V254 AS SELECT a-b,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0,
       d,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,5,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V255 AS SELECT d-e
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V256 AS SELECT abs(b-c),
       a+b*2.0+c*3.0,
       a+b*2.0
  FROM t1
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V257 AS SELECT d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a,
       d-e,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,3,5,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V258 AS SELECT abs(a),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       e,
       a+b*2.0,
       a,
       a-b
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2,5,3,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V259 AS SELECT a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       b-c,
       a+b*2.0+c*3.0+d*4.0,
       b,
       abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND d NOT BETWEEN 110.0 AND 150.0
   AND (e>a AND e<b)
 ORDER BY 4,1,5,6,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V260 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(b-c),
       b-c,
       c,
       a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND b>c
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,5,2,1,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V261 AS SELECT b,
       a-b,
       a,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V262 AS SELECT a+b*2.0+c*3.0,
       c,
       b-c,
       a+b*2.0+c*3.0+d*4.0,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (e>c OR e<d)
   AND c BETWEEN b-2.0 AND d+2.0
   AND (e>a AND e<b)
 ORDER BY 7,5,3,2,6,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V263 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c,
       d-e
  FROM t1
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V264 AS SELECT a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (a>b-2.0 AND a<b+2.0)
   AND c>d
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V265 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e,
       abs(a),
       c-d,
       a,
       b-c
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR (c<=d-2.0 OR c>=d+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 7,1,5,3,4,6,2
 LIMIT 1;

CREATE VIRTUAL VIEW V266 AS SELECT (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0,
       a-b,
       abs(b-c),
       a+b*2.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,1,5,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V267 AS SELECT b-c,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR (a>b-2.0 AND a<b+2.0)
    OR d>e
 ORDER BY 1,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V268 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V269 AS SELECT (a+b+c+d+e)/5.0,
       c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V270 AS SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,2,1,6,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V271 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       a,
       d-e
  FROM t1
 ORDER BY 1,2,3,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V272 AS SELECT a-b,
       b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V273 AS SELECT e,
       a+b*2.0,
       abs(a),
       b
  FROM t1
 ORDER BY 4,2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V274 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c,
       d-e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 5,3,2,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V275 AS SELECT abs(a),
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0,
       b-c
  FROM t1
 ORDER BY 6,1,3,5,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V276 AS SELECT d
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V277 AS SELECT abs(b-c),
       a-b,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V278 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       e,
       b-c
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND b>c
   AND c>d
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V279 AS SELECT c-d,
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       b-c
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
 ORDER BY 2,4,3,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V280 AS SELECT a+b*2.0+c*3.0+d*4.0,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
    OR (e>a AND e<b)
 ORDER BY 4,6,2,5,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V281 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V282 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V283 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b,
       a,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0
  FROM t1
 WHERE a>b
   AND (e>c OR e<d)
 ORDER BY 3,7,2,5,6,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V284 AS SELECT (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0,
       a-b
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND c>d
   AND b>c
 ORDER BY 6,5,7,4,3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V285 AS SELECT b,
       c,
       abs(a),
       d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2.0 AND d+2.0
   AND (e>a AND e<b)
 ORDER BY 2,4,5,6,3,7,1
 LIMIT 1;

CREATE VIRTUAL VIEW V286 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V287 AS SELECT a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 4,5,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V288 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2.0 AND d+2.0
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V289 AS SELECT d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d>e
    OR a>b
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V290 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V291 AS SELECT a-b,
       a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       a+b*2.0+c*3.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE b>c
   AND (c<=d-2.0 OR c>=d+2.0)
   AND c>d
 ORDER BY 2,1,5,6,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V292 AS SELECT abs(a),
       a-b
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V293 AS SELECT b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (a+b+c+d+e)/5.0,
       b,
       c-d,
       a+b*2.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
   AND d>e
 ORDER BY 4,7,5,2,1,6,3
 LIMIT 1;

CREATE VIRTUAL VIEW V294 AS SELECT c-d,
       a-b,
       b,
       b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c,
       a+b*2.0
  FROM t1
 ORDER BY 1,5,4,3,2,6,7
 LIMIT 1;

CREATE VIRTUAL VIEW V295 AS SELECT a+b*2.0+c*3.0,
       a,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(a)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR b>c
 ORDER BY 2,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V296 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       abs(a),
       e,
       a+b*2.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,4,2,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V297 AS SELECT b,
       abs(b-c),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND (e>c OR e<d)
 ORDER BY 2,1,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V298 AS SELECT b-c,
       e,
       c-d,
       a-b
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2.0 AND d+2.0
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 4,1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V299 AS SELECT a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       b
  FROM t1
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V300 AS SELECT c-d,
       (a+b+c+d+e)/5.0,
       abs(b-c),
       c,
       d
  FROM t1
 WHERE c>d
    OR a>b
 ORDER BY 4,2,3,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V301 AS SELECT a+b*2.0+c*3.0,
       d,
       abs(b-c)
  FROM t1
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V302 AS SELECT e,
       a+b*2.0+c*3.0,
       abs(b-c),
       d-e
  FROM t1
 ORDER BY 1,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V303 AS SELECT a,
       abs(a),
       d-e,
       e
  FROM t1
 ORDER BY 2,4,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V304 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V305 AS SELECT b-c,
       a-b,
       a+b*2.0
  FROM t1
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V306 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V307 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND c>d
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V308 AS SELECT c-d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR d>e
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V309 AS SELECT a-b,
       d,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5.0,
       b,
       d-e
  FROM t1
 ORDER BY 1,5,3,7,4,6,2
 LIMIT 1;

CREATE VIRTUAL VIEW V310 AS SELECT a+b*2.0+c*3.0+d*4.0,
       a,
       c-d,
       abs(b-c),
       b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 4,3,2,5,1,6
 LIMIT 1;

CREATE VIRTUAL VIEW V311 AS SELECT abs(b-c),
       (a+b+c+d+e)/5.0,
       d,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 ORDER BY 4,6,2,1,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V312 AS SELECT a,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e,
       a-b
  FROM t1
 ORDER BY 1,4,5,3,6,2
 LIMIT 1;

CREATE VIRTUAL VIEW V313 AS SELECT abs(a)
  FROM t1
 WHERE a>b
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V314 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V315 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b,
       b-c,
       (a+b+c+d+e)/5.0,
       a+b*2.0
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
 ORDER BY 4,6,3,1,5,7,2
 LIMIT 1;

CREATE VIRTUAL VIEW V316 AS SELECT (a+b+c+d+e)/5.0,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,4,5,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V317 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V318 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       c,
       a-b,
       abs(a)
  FROM t1
 ORDER BY 6,1,3,5,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V319 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       a,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 2,3,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V320 AS SELECT abs(a)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND d>e
   AND (e>a AND e<b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V321 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (a+b+c+d+e)/5.0,
       c-d
  FROM t1
 ORDER BY 2,4,5,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V322 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 4,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V323 AS SELECT d,
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 3,2,4,5,7,1,6
 LIMIT 1;

CREATE VIRTUAL VIEW V324 AS SELECT b,
       abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c,
       a-b
  FROM t1
 ORDER BY 4,5,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V325 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (e>a AND e<b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,2,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V326 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR c>d
 ORDER BY 1,2,4,5,6,3
 LIMIT 1;

CREATE VIRTUAL VIEW V327 AS SELECT a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       d,
       e,
       a+b*2.0
  FROM t1
 ORDER BY 2,3,4,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V328 AS SELECT b,
       e,
       b-c
  FROM t1
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V329 AS SELECT a+b*2.0+c*3.0,
       abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (e>a AND e<b)
 ORDER BY 1,5,3,4,6,2,7
 LIMIT 1;

CREATE VIRTUAL VIEW V330 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (e>c OR e<d)
   AND c>d
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V331 AS SELECT abs(b-c),
       a+b*2.0,
       d,
       b-c,
       a-b,
       d-e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND c>d
 ORDER BY 3,1,2,5,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V332 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V333 AS SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V334 AS SELECT abs(b-c),
       e
  FROM t1
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V335 AS SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0,
       a-b,
       a+b*2.0
  FROM t1
 WHERE d>e
   AND c>d
   AND a>b
 ORDER BY 3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V336 AS SELECT b,
       a+b*2.0+c*3.0,
       d-e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V337 AS SELECT a-b,
       a,
       d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,5,1,6,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V338 AS SELECT c-d,
       abs(a),
       a+b*2.0+c*3.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 4,2,5,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V339 AS SELECT a+b*2.0
  FROM t1
 WHERE a>b
    OR (e>c OR e<d)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V340 AS SELECT c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR c BETWEEN b-2.0 AND d+2.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V341 AS SELECT a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0,
       b,
       d
  FROM t1
 WHERE a>b
 ORDER BY 1,5,4,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V342 AS SELECT b,
       a+b*2.0
  FROM t1
 WHERE (e>a AND e<b)
    OR (a>b-2.0 AND a<b+2.0)
    OR (e>c OR e<d)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V343 AS SELECT a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b,
       d-e,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,2,5,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V344 AS SELECT e,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0,
       b,
       a+b*2.0+c*3.0
  FROM t1
 WHERE a>b
    OR (e>c OR e<d)
 ORDER BY 4,3,6,5,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V345 AS SELECT (a+b+c+d+e)/5.0,
       e,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 4,2,5,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V346 AS SELECT b-c,
       a,
       d-e
  FROM t1
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V347 AS SELECT a,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (e>a AND e<b)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V348 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V349 AS SELECT a-b,
       c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       abs(b-c)
  FROM t1
 WHERE b>c
 ORDER BY 5,2,1,7,3,4,6
 LIMIT 1;

CREATE VIRTUAL VIEW V350 AS SELECT d,
       (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE b>c
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V351 AS SELECT abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       b-c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V352 AS SELECT a-b,
       c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 1,4,3,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V353 AS SELECT b-c,
       a-b,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE b>c
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 4,3,1,5,6,2
 LIMIT 1;

CREATE VIRTUAL VIEW V354 AS SELECT a,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0,
       b
  FROM t1
 WHERE c>d
    OR d>e
 ORDER BY 2,5,1,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V355 AS SELECT a+b*2.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b,
       a-b,
       b-c,
       d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR (c<=d-2.0 OR c>=d+2.0)
    OR (e>a AND e<b)
 ORDER BY 2,6,1,4,3,5
 LIMIT 1;

CREATE VIRTUAL VIEW V356 AS SELECT d,
       d-e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       e,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 6,5,1,7,2,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V357 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 3,2,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V358 AS SELECT a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       abs(b-c)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V359 AS SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V360 AS SELECT a-b
  FROM t1
 WHERE c>d
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V361 AS SELECT a+b*2.0+c*3.0,
       d,
       e,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c)
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,4,5,2,6,7,3
 LIMIT 1;

CREATE VIRTUAL VIEW V362 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a,
       abs(a),
       c,
       d-e
  FROM t1
 ORDER BY 5,4,1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V363 AS SELECT a+b*2.0+c*3.0+d*4.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       d-e,
       e
  FROM t1
 ORDER BY 4,3,2,1,5,7,6
 LIMIT 1;

CREATE VIRTUAL VIEW V364 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V365 AS SELECT d,
       c
  FROM t1
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V366 AS SELECT d-e
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V367 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 4,3,2,5,7,1,6
 LIMIT 1;

CREATE VIRTUAL VIEW V368 AS SELECT d-e,
       b-c,
       a-b,
       a+b*2.0+c*3.0+d*4.0,
       abs(a)
  FROM t1
 ORDER BY 1,5,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V369 AS SELECT d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V370 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5.0,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       d-e
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,3,6,7,4,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V371 AS SELECT b-c,
       a+b*2.0+c*3.0+d*4.0,
       c-d,
       a-b
  FROM t1
 ORDER BY 2,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V372 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 4,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V373 AS SELECT (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR c BETWEEN b-2.0 AND d+2.0
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V374 AS SELECT b,
       b-c,
       a+b*2.0+c*3.0,
       abs(a),
       c-d,
       a,
       d-e
  FROM t1
 WHERE b>c
 ORDER BY 4,6,1,3,7,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V375 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR c>d
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V376 AS SELECT c
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V377 AS SELECT a+b*2.0,
       a+b*2.0+c*3.0,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 4,1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V378 AS SELECT (a+b+c+d+e)/5.0,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 6,4,5,1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V379 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       a,
       abs(a)
  FROM t1
 ORDER BY 3,1,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V380 AS SELECT a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V381 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND a>b
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V382 AS SELECT a+b*2.0+c*3.0,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 5,3,1,2,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V383 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V384 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       abs(a)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d>e
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 4,1,5,6,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V385 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V386 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2.0 AND d+2.0
   AND (e>c OR e<d)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V387 AS SELECT a,
       b,
       abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR a>b
 ORDER BY 2,3,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V388 AS SELECT a+b*2.0+c*3.0,
       d-e,
       a+b*2.0+c*3.0+d*4.0,
       d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(a)
  FROM t1
 WHERE b>c
   AND (e>c OR e<d)
 ORDER BY 2,3,4,5,6,1
 LIMIT 1;

CREATE VIRTUAL VIEW V389 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V390 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0,
       a-b
  FROM t1
 WHERE a>b
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V391 AS SELECT b
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V392 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       a,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,5,3,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V393 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b,
       c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a
  FROM t1
 WHERE (e>a AND e<b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 5,3,2,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V394 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a-b,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V395 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V396 AS SELECT d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V397 AS SELECT c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c,
       b
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,4,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V398 AS SELECT abs(b-c),
       c,
       b,
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE d>e
 ORDER BY 6,5,3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V399 AS SELECT b-c
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V400 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (a+b+c+d+e)/5.0,
       abs(a),
       abs(b-c),
       c-d
  FROM t1
 ORDER BY 3,7,1,4,6,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V401 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V402 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 5,1,2,4,3,6,7
 LIMIT 1;

CREATE VIRTUAL VIEW V403 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V404 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (e>c OR e<d)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND c>d
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V405 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0,
       a,
       (a+b+c+d+e)/5.0,
       b
  FROM t1
 WHERE b>c
 ORDER BY 4,2,6,5,3,7,1
 LIMIT 1;

CREATE VIRTUAL VIEW V406 AS SELECT a+b*2.0,
       a-b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 1,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V407 AS SELECT e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (a+b+c+d+e)/5.0,
       d,
       d-e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
    OR (e>c OR e<d)
 ORDER BY 5,4,2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V408 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c,
       d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 4,5,2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V409 AS SELECT c-d,
       abs(b-c),
       a+b*2.0
  FROM t1
 WHERE d>e
   AND a>b
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V410 AS SELECT e,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (e>a AND e<b)
    OR b>c
    OR (e>c OR e<d)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V411 AS SELECT (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V412 AS SELECT a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       b,
       a+b*2.0
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 5,1,2,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V413 AS SELECT e,
       a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V414 AS SELECT (a+b+c+d+e)/5.0,
       d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0,
       a,
       abs(a),
       a-b
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 5,4,1,2,7,6,3
 LIMIT 1;

CREATE VIRTUAL VIEW V415 AS SELECT c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 6,3,1,2,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V416 AS SELECT c-d,
       d-e,
       d,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 3,2,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V417 AS SELECT abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V418 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c
  FROM t1
 WHERE d>e
    OR a>b
 ORDER BY 4,3,2,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V419 AS SELECT (a+b+c+d+e)/5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(a),
       a+b*2.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V420 AS SELECT a,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       b-c,
       a+b*2.0+c*3.0+d*4.0,
       c-d,
       d-e
  FROM t1
 WHERE c>d
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 7,3,6,5,2,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V421 AS SELECT abs(a),
       c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V422 AS SELECT a+b*2.0+c*3.0,
       c-d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 1,6,5,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V423 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V424 AS SELECT b,
       a,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V425 AS SELECT (a+b+c+d+e)/5.0,
       e,
       b
  FROM t1
 WHERE d>e
   AND (a>b-2.0 AND a<b+2.0)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V426 AS SELECT abs(a),
       a+b*2.0+c*3.0,
       (a+b+c+d+e)/5.0,
       b-c
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V427 AS SELECT a-b
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V428 AS SELECT a-b,
       d-e,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V429 AS SELECT c
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V430 AS SELECT a+b*2.0+c*3.0+d*4.0,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 2,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V431 AS SELECT abs(a)
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V432 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0
  FROM t1
 ORDER BY 1,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V433 AS SELECT c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       (a+b+c+d+e)/5.0,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
 ORDER BY 4,5,6,1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V434 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       c-d
  FROM t1
 ORDER BY 2,1,3,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V435 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d,
       e,
       abs(a),
       d
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
 ORDER BY 6,1,5,2,4,7,3
 LIMIT 1;

CREATE VIRTUAL VIEW V436 AS SELECT b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d
  FROM t1
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V437 AS SELECT c-d,
       a-b,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 3,2,4,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V438 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>a AND e<b)
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V439 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e
  FROM t1
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V440 AS SELECT c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c,
       a+b*2.0+c*3.0,
       d-e,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 3,4,6,5,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V441 AS SELECT a+b*2.0,
       a-b,
       c,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 5,3,2,7,4,6,1
 LIMIT 1;

CREATE VIRTUAL VIEW V442 AS SELECT abs(b-c)
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V443 AS SELECT b,
       c,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       e
  FROM t1
 ORDER BY 4,5,1,6,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V444 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1,4,3,5,2
 LIMIT 1;

CREATE VIRTUAL VIEW V445 AS SELECT a,
       c
  FROM t1
 WHERE d>e
    OR b>c
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V446 AS SELECT a+b*2.0+c*3.0+d*4.0,
       c-d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0,
       b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 5,2,4,1,6,3,7
 LIMIT 1;

CREATE VIRTUAL VIEW V447 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       b,
       abs(a),
       a+b*2.0,
       c-d
  FROM t1
 WHERE b>c
 ORDER BY 1,6,5,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V448 AS SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V449 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0,
       e,
       a+b*2.0,
       a+b*2.0+c*3.0,
       d,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 2,1,5,3,6,4,7
 LIMIT 1;

CREATE VIRTUAL VIEW V450 AS SELECT d-e,
       c-d,
       a
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND c>d
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V451 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       a,
       abs(a)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR (c<=d-2.0 OR c>=d+2.0)
    OR d>e
 ORDER BY 3,5,6,2,1,7,4
 LIMIT 1;

CREATE VIRTUAL VIEW V452 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       e,
       (a+b+c+d+e)/5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
    OR d>e
 ORDER BY 1,4,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V453 AS SELECT b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c,
       a+b*2.0,
       d-e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (e>a AND e<b)
 ORDER BY 3,4,1,5,6,2,7
 LIMIT 1;

CREATE VIRTUAL VIEW V454 AS SELECT (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0,
       a,
       a-b,
       d
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 6,1,2,3,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V455 AS SELECT c-d
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V456 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       abs(a),
       c-d
  FROM t1
 ORDER BY 2,3,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V457 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       c
  FROM t1
 WHERE d>e
    OR (e>c OR e<d)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V458 AS SELECT a,
       a+b*2.0+c*3.0+d*4.0,
       d
  FROM t1
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V459 AS SELECT b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d-e,
       abs(a),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR e+d BETWEEN a+b-10.0 AND c+130.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,2,1,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V460 AS SELECT a-b,
       (a+b+c+d+e)/5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(a),
       d-e,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 6,4,5,3,1,2,7
 LIMIT 1;

CREATE VIRTUAL VIEW V461 AS SELECT d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V462 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       abs(a),
       a-b,
       b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE c>d
 ORDER BY 5,4,3,2,1,6
 LIMIT 1;

CREATE VIRTUAL VIEW V463 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE c>d
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V464 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V465 AS SELECT c-d,
       a+b*2.0+c*3.0,
       a
  FROM t1
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V466 AS SELECT (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c>d
   AND b>c
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V467 AS SELECT a,
       abs(a),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
    OR (e>c OR e<d)
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V468 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V469 AS SELECT abs(b-c)
  FROM t1
 WHERE c>d
   AND d NOT BETWEEN 110.0 AND 150.0
   AND a>b
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V470 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a
  FROM t1
 ORDER BY 4,2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V471 AS SELECT e,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0,
       c-d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE c>d
 ORDER BY 1,2,5,3,4,7,6
 LIMIT 1;

CREATE VIRTUAL VIEW V472 AS SELECT abs(a),
       a-b,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V473 AS SELECT a-b,
       abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,2,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V474 AS SELECT b-c,
       c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE a>b
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V475 AS SELECT b,
       a+b*2.0+c*3.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V476 AS SELECT a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c>d
   AND b>c
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V477 AS SELECT c-d,
       b-c,
       abs(b-c),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V478 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       a+b*2.0+c*3.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,4,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V479 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d,
       c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,2,3,1,5,6
 LIMIT 1;

CREATE VIRTUAL VIEW V480 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V481 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       abs(a),
       a+b*2.0,
       a,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       e
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110.0 AND 150.0
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,2,3,7,1,5,6
 LIMIT 1;

CREATE VIRTUAL VIEW V482 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(a),
       c,
       d
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,1,5,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V483 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c,
       e
  FROM t1
 WHERE d>e
 ORDER BY 2,5,1,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V484 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       d-e,
       c
  FROM t1
 WHERE c>d
   AND d>e
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,4,1,5,3,6
 LIMIT 1;

CREATE VIRTUAL VIEW V485 AS SELECT a+b*2.0+c*3.0+d*4.0,
       abs(b-c),
       a+b*2.0+c*3.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(a)
  FROM t1
 WHERE d>e
 ORDER BY 3,4,1,5,2
 LIMIT 1;

CREATE VIRTUAL VIEW V486 AS SELECT b-c,
       d-e,
       abs(a)
  FROM t1
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V487 AS SELECT e
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2.0 OR c>=d+2.0)
   AND (e>c OR e<d)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V488 AS SELECT d
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V489 AS SELECT a+b*2.0,
       abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0,
       c-d
  FROM t1
 ORDER BY 4,1,5,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V490 AS SELECT c-d,
       e,
       a+b*2.0,
       b,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR (e>c OR e<d)
 ORDER BY 2,5,3,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V491 AS SELECT e,
       abs(a),
       c-d,
       a,
       c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,7,6,5,3,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V492 AS SELECT a+b*2.0+c*3.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
    OR (e>c OR e<d)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V493 AS SELECT e,
       a-b,
       c,
       a
  FROM t1
 ORDER BY 1,4,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V494 AS SELECT a+b*2.0,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND d NOT BETWEEN 110.0 AND 150.0
   AND c>d
 ORDER BY 3,4,6,5,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V495 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       e,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(a),
       a
  FROM t1
 WHERE d>e
   AND b>c
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 4,3,6,1,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V496 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0,
       a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 2,5,3,6,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V497 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a-b
  FROM t1
 ORDER BY 1,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V498 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0,
       d-e
  FROM t1
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V499 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 4,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V500 AS SELECT abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V501 AS SELECT a-b,
       abs(a),
       a,
       e,
       b-c
  FROM t1
 ORDER BY 2,4,3,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V502 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR b>c
    OR d>e
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V503 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b,
       d-e
  FROM t1
 ORDER BY 1,4,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V504 AS SELECT (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V505 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 4,1,3,5,2
 LIMIT 1;

CREATE VIRTUAL VIEW V506 AS SELECT (a+b+c+d+e)/5.0,
       e,
       a-b
  FROM t1
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V507 AS SELECT b-c,
       c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR (e>c OR e<d)
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V508 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       d
  FROM t1
 WHERE b>c
 ORDER BY 6,2,5,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V509 AS SELECT d
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V510 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND (a>b-2.0 AND a<b+2.0)
   AND b>c
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V511 AS SELECT abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d,
       b-c,
       b,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 4,2,5,6,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V512 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0,
       a+b*2.0+c*3.0+d*4.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR b>c
    OR (e>a AND e<b)
 ORDER BY 6,5,4,2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V513 AS SELECT abs(b-c)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND c>d
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V514 AS SELECT a-b,
       d-e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V515 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE b>c
    OR a>b
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,2,4,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V516 AS SELECT a+b*2.0+c*3.0,
       d-e,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V517 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V518 AS SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND c>d
   AND d>e
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V519 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 4,2,1,3,5,6
 LIMIT 1;

CREATE VIRTUAL VIEW V520 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       abs(a),
       d,
       c,
       abs(b-c)
  FROM t1
 WHERE a>b
    OR b>c
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,1,3,6,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V521 AS SELECT a,
       c-d
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V522 AS SELECT (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V523 AS SELECT a+b*2.0+c*3.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND a>b
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V524 AS SELECT abs(b-c)
  FROM t1
 WHERE b>c
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V525 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V526 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a)
  FROM t1
 WHERE d>e
   AND b>c
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V527 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       e,
       a,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>c OR e<d)
   AND c>d
 ORDER BY 1,5,2,6,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V528 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V529 AS SELECT a,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR c>d
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V530 AS SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V531 AS SELECT c-d,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0,
       d
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
 ORDER BY 3,1,4,5,2
 LIMIT 1;

CREATE VIRTUAL VIEW V532 AS SELECT c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (a>b-2.0 AND a<b+2.0)
   AND (e>c OR e<d)
 ORDER BY 4,1,3,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V533 AS SELECT c,
       a+b*2.0+c*3.0,
       c-d,
       abs(b-c),
       d-e
  FROM t1
 ORDER BY 3,4,1,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V534 AS SELECT (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V535 AS SELECT e,
       d-e
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR d>e
    OR (e>a AND e<b)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V536 AS SELECT c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (a+b+c+d+e)/5.0,
       b-c,
       e,
       c-d
  FROM t1
 ORDER BY 5,4,6,2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V537 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       b
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR a>b
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V538 AS SELECT a+b*2.0+c*3.0,
       c,
       abs(a),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,4,2,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V539 AS SELECT a-b,
       c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c,
       e,
       c
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 3,5,1,4,6,2
 LIMIT 1;

CREATE VIRTUAL VIEW V540 AS SELECT c,
       a+b*2.0+c*3.0,
       c-d,
       abs(a),
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE d>e
    OR (c<=d-2.0 OR c>=d+2.0)
    OR (e>c OR e<d)
 ORDER BY 1,3,5,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V541 AS SELECT c,
       a+b*2.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c>d
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V542 AS SELECT a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V543 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(a),
       abs(b-c),
       b-c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR d>e
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,4,2,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V544 AS SELECT c-d,
       a+b*2.0+c*3.0+d*4.0,
       d,
       a-b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 2,1,5,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V545 AS SELECT abs(b-c),
       a,
       a+b*2.0+c*3.0+d*4.0,
       c-d,
       c,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 6,3,1,4,5,2
 LIMIT 1;

CREATE VIRTUAL VIEW V546 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V547 AS SELECT b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e,
       a+b*2.0,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR c>d
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,5,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V548 AS SELECT abs(a),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b,
       b,
       a,
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,2,4,6,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V549 AS SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR a>b
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V550 AS SELECT a-b
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V551 AS SELECT abs(b-c)
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V552 AS SELECT a+b*2.0+c*3.0,
       c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a,
       (a+b+c+d+e)/5.0,
       a+b*2.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 3,2,5,7,1,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V553 AS SELECT d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b,
       c-d,
       (a+b+c+d+e)/5.0,
       b-c
  FROM t1
 ORDER BY 3,1,4,2,6,5
 LIMIT 1;

CREATE VIRTUAL VIEW V554 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       d
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,2,1,6,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V555 AS SELECT d,
       b,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V556 AS SELECT a+b*2.0+c*3.0+d*4.0,
       d-e,
       c-d,
       abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
 ORDER BY 3,1,5,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V557 AS SELECT abs(a),
       c-d,
       abs(b-c),
       a+b*2.0+c*3.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,2,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V558 AS SELECT c,
       e,
       b,
       abs(a),
       d,
       a
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 5,3,2,1,4,6
 LIMIT 1;

CREATE VIRTUAL VIEW V559 AS SELECT a-b,
       a+b*2.0
  FROM t1
 WHERE b>c
    OR c>d
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V560 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c)
  FROM t1
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V561 AS SELECT d-e,
       a+b*2.0+c*3.0,
       a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,4,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V562 AS SELECT d,
       d-e,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       b,
       c,
       a+b*2.0+c*3.0
  FROM t1
 WHERE a>b
    OR b>c
 ORDER BY 3,1,5,6,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V563 AS SELECT abs(b-c),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V564 AS SELECT c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d,
       a,
       b
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR c>d
 ORDER BY 1,2,5,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V565 AS SELECT abs(b-c),
       c-d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND d>e
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,2,5,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V566 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE d>e
    OR (a>b-2.0 AND a<b+2.0)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V567 AS SELECT a-b,
       b-c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b
  FROM t1
 ORDER BY 3,1,2,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V568 AS SELECT a+b*2.0,
       a+b*2.0+c*3.0+d*4.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       b,
       c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,5,2,1,4,6
 LIMIT 1;

CREATE VIRTUAL VIEW V569 AS SELECT e,
       a+b*2.0+c*3.0+d*4.0,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE a>b
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,4,7,6,5,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V570 AS SELECT a+b*2.0+c*3.0+d*4.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
   AND c BETWEEN b-2.0 AND d+2.0
   AND (e>c OR e<d)
 ORDER BY 6,2,5,4,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V571 AS SELECT a+b*2.0+c*3.0,
       abs(a),
       e,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d
  FROM t1
 WHERE (e>c OR e<d)
    OR c BETWEEN b-2.0 AND d+2.0
    OR a>b
 ORDER BY 5,2,4,1,3,6
 LIMIT 1;

CREATE VIRTUAL VIEW V572 AS SELECT a+b*2.0,
       abs(a),
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c
  FROM t1
 WHERE b>c
 ORDER BY 5,1,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V573 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(b-c),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,1,6,4,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V574 AS SELECT b-c,
       a+b*2.0,
       b
  FROM t1
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V575 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
 WHERE a>b
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V576 AS SELECT a
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V577 AS SELECT abs(b-c),
       a+b*2.0+c*3.0+d*4.0,
       c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 4,1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V578 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V579 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V580 AS SELECT d,
       a+b*2.0+c*3.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V581 AS SELECT e,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V582 AS SELECT c
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V583 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d>e
   AND (c<=d-2.0 OR c>=d+2.0)
   AND (e>a AND e<b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V584 AS SELECT c,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE b>c
   AND (a>b-2.0 AND a<b+2.0)
   AND (e>a AND e<b)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V585 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(a)
  FROM t1
 WHERE c>d
   AND b>c
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V586 AS SELECT e,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       b-c,
       a+b*2.0+c*3.0+d*4.0,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,4,6,1,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V587 AS SELECT a
  FROM t1
 WHERE d>e
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V588 AS SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE b>c
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V589 AS SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0,
       abs(b-c),
       e
  FROM t1
 ORDER BY 3,4,5,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V590 AS SELECT e,
       b-c,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d,
       abs(a)
  FROM t1
 WHERE b>c
 ORDER BY 3,6,2,1,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V591 AS SELECT b-c
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V592 AS SELECT abs(b-c),
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       c,
       a+b*2.0+c*3.0
  FROM t1
 WHERE a>b
 ORDER BY 3,4,6,1,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V593 AS SELECT d,
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V594 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE d>e
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,4,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V595 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a),
       b-c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V596 AS SELECT c
  FROM t1
 WHERE b>c
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V597 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a,
       a+b*2.0,
       c,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
 ORDER BY 6,1,5,7,4,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V598 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 3,4,7,5,2,6,1
 LIMIT 1;

CREATE VIRTUAL VIEW V599 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a+b*2.0+c*3.0,
       a-b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c
  FROM t1
 WHERE b>c
   AND a>b
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 5,1,3,6,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V600 AS SELECT a+b*2.0+c*3.0+d*4.0,
       a-b,
       a+b*2.0,
       abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 1,5,4,2,6,3
 LIMIT 1;

CREATE VIRTUAL VIEW V601 AS SELECT a+b*2.0+c*3.0+d*4.0,
       abs(b-c),
       b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d>e
 ORDER BY 3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V602 AS SELECT abs(b-c),
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V603 AS SELECT a-b,
       c,
       a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       e,
       b-c,
       d-e
  FROM t1
 ORDER BY 7,2,5,4,1,3,6
 LIMIT 1;

CREATE VIRTUAL VIEW V604 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       b-c,
       a-b,
       a,
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,6,1,2,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V605 AS SELECT abs(a),
       d
  FROM t1
 WHERE (e>a AND e<b)
   AND a>b
   AND c>d
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V606 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       c,
       e,
       a+b*2.0+c*3.0,
       abs(b-c),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND d>e
   AND (e>c OR e<d)
 ORDER BY 1,5,3,6,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V607 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V608 AS SELECT e,
       abs(a)
  FROM t1
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V609 AS SELECT abs(a),
       b
  FROM t1
 WHERE b>c
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V610 AS SELECT d-e,
       b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110.0 AND 150.0
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,4,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V611 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2.0 AND d+2.0
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V612 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d,
       c-d,
       a
  FROM t1
 ORDER BY 3,4,2,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V613 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V614 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND a>b
   AND (e>a AND e<b)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V615 AS SELECT abs(a),
       abs(b-c),
       d,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,3,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V616 AS SELECT abs(a),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d>e
    OR b>c
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,5,6,4,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V617 AS SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110.0 AND 150.0
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V618 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       e,
       d-e,
       b,
       c,
       b-c
  FROM t1
 ORDER BY 3,5,6,2,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V619 AS SELECT a+b*2.0,
       b
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V620 AS SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V621 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       d
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 4,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V622 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       c-d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 4,2,6,1,7,3,5
 LIMIT 1;

CREATE VIRTUAL VIEW V623 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(a),
       e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d-e
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,1,5,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V624 AS SELECT b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(b-c)
  FROM t1
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V625 AS SELECT (a+b+c+d+e)/5.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND d>e
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V626 AS SELECT c,
       (a+b+c+d+e)/5.0,
       a-b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
   AND (a>b-2.0 AND a<b+2.0)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,3,4,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V627 AS SELECT a,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0,
       abs(a)
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V628 AS SELECT d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
    OR a>b
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V629 AS SELECT a+b*2.0+c*3.0+d*4.0,
       d-e,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (a+b+c+d+e)/5.0,
       abs(b-c)
  FROM t1
 ORDER BY 2,4,3,1,5,6
 LIMIT 1;

CREATE VIRTUAL VIEW V630 AS SELECT a+b*2.0+c*3.0+d*4.0,
       a+b*2.0,
       e,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND (e>c OR e<d)
 ORDER BY 2,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V631 AS SELECT b-c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d
  FROM t1
 WHERE a>b
   AND (a>b-2.0 AND a<b+2.0)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V632 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       e,
       b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (a>b-2.0 AND a<b+2.0)
    OR b>c
 ORDER BY 2,1,3,7,5,4,6
 LIMIT 1;

CREATE VIRTUAL VIEW V633 AS SELECT abs(a),
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
 ORDER BY 4,1,5,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V634 AS SELECT (a+b+c+d+e)/5.0,
       b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c,
       d-e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c>d
 ORDER BY 2,5,3,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V635 AS SELECT abs(b-c),
       c-d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V636 AS SELECT c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND (e>a AND e<b)
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V637 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       b,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 1,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V638 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V639 AS SELECT c-d,
       a,
       abs(b-c)
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110.0 AND 150.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V640 AS SELECT a,
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c>d
   AND (c<=d-2.0 OR c>=d+2.0)
   AND (e>c OR e<d)
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V641 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       c-d,
       a
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND (e>c OR e<d)
   AND c>d
 ORDER BY 3,4,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V642 AS SELECT (a+b+c+d+e)/5.0,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V643 AS SELECT a+b*2.0,
       a
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (e>c OR e<d)
    OR (e>a AND e<b)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V644 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (e>a AND e<b)
 ORDER BY 1,3,5,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V645 AS SELECT d-e,
       b,
       a+b*2.0+c*3.0+d*4.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
 ORDER BY 2,3,1,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V646 AS SELECT d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c),
       (a+b+c+d+e)/5.0,
       c-d
  FROM t1
 WHERE a>b
 ORDER BY 1,3,2,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V647 AS SELECT b,
       a,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(a),
       a+b*2.0
  FROM t1
 ORDER BY 4,1,2,7,5,3,6
 LIMIT 1;

CREATE VIRTUAL VIEW V648 AS SELECT e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V649 AS SELECT b,
       c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>c OR e<d)
    OR c>d
    OR (e>a AND e<b)
 ORDER BY 4,1,5,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V650 AS SELECT a+b*2.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V651 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c>d
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V652 AS SELECT a+b*2.0+c*3.0,
       d,
       a,
       a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,3,5,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V653 AS SELECT c-d,
       abs(b-c),
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND (e>a AND e<b)
 ORDER BY 3,4,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V654 AS SELECT c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0,
       c-d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR (e>c OR e<d)
    OR (e>a AND e<b)
 ORDER BY 3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V655 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V656 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       c,
       abs(b-c)
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,3,2,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V657 AS SELECT d-e,
       c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0+d*4.0,
       a
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,2,5,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V658 AS SELECT abs(b-c),
       a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
 ORDER BY 6,2,1,3,4,7,5
 LIMIT 1;

CREATE VIRTUAL VIEW V659 AS SELECT (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 5,6,3,7,2,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V660 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       e,
       abs(a)
  FROM t1
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V661 AS SELECT e
  FROM t1
 WHERE c>d
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V662 AS SELECT a+b*2.0+c*3.0,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(a),
       a+b*2.0,
       a
  FROM t1
 WHERE d>e
    OR c>d
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 6,2,1,7,5,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V663 AS SELECT b-c,
       (a+b+c+d+e)/5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE b>c
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V664 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (e>a AND e<b)
   AND d>e
 ORDER BY 3,4,1,5,7,6,2
 LIMIT 1;

CREATE VIRTUAL VIEW V665 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c,
       abs(a),
       d,
       d-e
  FROM t1
 WHERE b>c
   AND d>e
 ORDER BY 1,6,2,4,3,7,5
 LIMIT 1;

CREATE VIRTUAL VIEW V666 AS SELECT b-c,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2.0 OR c>=d+2.0)
   AND (e>c OR e<d)
 ORDER BY 3,4,2,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V667 AS SELECT a+b*2.0,
       abs(b-c),
       a+b*2.0+c*3.0,
       c,
       e,
       d
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
 ORDER BY 6,3,5,2,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V668 AS SELECT c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2.0 AND a<b+2.0)
    OR c>d
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V669 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE a>b
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V670 AS SELECT (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0,
       d-e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR a>b
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,4,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V671 AS SELECT b-c
  FROM t1
 WHERE d>e
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V672 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V673 AS SELECT b
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR b>c
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V674 AS SELECT e,
       b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(b-c),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110.0 AND 150.0
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,5,3,1,7,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V675 AS SELECT a+b*2.0+c*3.0,
       d-e,
       a-b
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR (e>c OR e<d)
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V676 AS SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       (a+b+c+d+e)/5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 2,5,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V677 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0
  FROM t1
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V678 AS SELECT a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0
  FROM t1
 WHERE b>c
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,3,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V679 AS SELECT abs(a),
       a-b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 4,2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V680 AS SELECT c-d,
       b,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
 ORDER BY 4,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V681 AS SELECT d,
       c,
       a
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
   AND a>b
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V682 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE b>c
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V683 AS SELECT c-d,
       b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 4,3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V684 AS SELECT a+b*2.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0,
       a-b
  FROM t1
 WHERE a>b
   AND (a>b-2.0 AND a<b+2.0)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,4,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V685 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       b
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (e>a AND e<b)
 ORDER BY 6,3,1,5,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V686 AS SELECT a-b
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V687 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c>d
    OR c BETWEEN b-2.0 AND d+2.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V688 AS SELECT d,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       a+b*2.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 5,1,3,6,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V689 AS SELECT abs(a),
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR b>c
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V690 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND d>e
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V691 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR c>d
 ORDER BY 1,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V692 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0,
       d
  FROM t1
 ORDER BY 3,1,2,5,4,6
 LIMIT 1;

CREATE VIRTUAL VIEW V693 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       b,
       d-e,
       d,
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 6,3,2,1,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V694 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
    OR (e>a AND e<b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V695 AS SELECT d,
       b-c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       abs(b-c),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10.0 AND c+130.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,3,6,2,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V696 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1,3,6,2,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V697 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d,
       abs(b-c),
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND a>b
 ORDER BY 4,1,5,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V698 AS SELECT b,
       a,
       (a+b+c+d+e)/5.0,
       b-c,
       e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR a>b
 ORDER BY 3,1,2,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V699 AS SELECT b,
       d-e,
       (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,3,5,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V700 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       c,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,5,6,3,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V701 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       d,
       a-b
  FROM t1
 ORDER BY 2,3,4,5,6,1
 LIMIT 1;

CREATE VIRTUAL VIEW V702 AS SELECT a+b*2.0+c*3.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V703 AS SELECT b-c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
 ORDER BY 5,4,3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V704 AS SELECT d-e,
       abs(a)
  FROM t1
 WHERE b>c
    OR a>b
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V705 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c>d
 ORDER BY 2,1,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V706 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V707 AS SELECT a,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V708 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 5,3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V709 AS SELECT c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND c>d
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V710 AS SELECT a+b*2.0,
       a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110.0 AND 150.0
   AND d>e
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V711 AS SELECT c,
       d-e,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d NOT BETWEEN 110.0 AND 150.0
    OR (e>c OR e<d)
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V712 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c)
  FROM t1
 WHERE d>e
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V713 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       (a+b+c+d+e)/5.0,
       c,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,5,1,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V714 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V715 AS SELECT a+b*2.0,
       abs(b-c),
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 3,2,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V716 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0+d*4.0,
       e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a,
       (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 6,7,4,1,5,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V717 AS SELECT abs(a),
       d-e
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V718 AS SELECT abs(b-c),
       b-c,
       a+b*2.0+c*3.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a
  FROM t1
 ORDER BY 3,4,2,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V719 AS SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE b>c
   AND a>b
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V720 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE b>c
 ORDER BY 6,5,3,2,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V721 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V722 AS SELECT a-b
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V723 AS SELECT a+b*2.0+c*3.0,
       d,
       b-c,
       a,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0
  FROM t1
 ORDER BY 4,3,6,1,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V724 AS SELECT a-b,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
 ORDER BY 1,4,2,5,6,3
 LIMIT 1;

CREATE VIRTUAL VIEW V725 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0,
       a-b,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (a>b-2.0 AND a<b+2.0)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1,3,4,5,2
 LIMIT 1;

CREATE VIRTUAL VIEW V726 AS SELECT c,
       abs(a),
       d,
       b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a
  FROM t1
 ORDER BY 1,4,3,5,6,7,2
 LIMIT 1;

CREATE VIRTUAL VIEW V727 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c,
       a+b*2.0+c*3.0,
       b
  FROM t1
 WHERE b>c
    OR c>d
 ORDER BY 3,5,6,4,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V728 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V729 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e
  FROM t1
 WHERE b>c
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V730 AS SELECT abs(a),
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND c BETWEEN b-2.0 AND d+2.0
   AND (e>a AND e<b)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V731 AS SELECT abs(a),
       c-d
  FROM t1
 WHERE d>e
    OR b>c
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V732 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE b>c
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
 ORDER BY 6,2,1,3,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V733 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2.0 AND d+2.0
    OR (e>c OR e<d)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V734 AS SELECT b,
       a+b*2.0+c*3.0,
       abs(b-c),
       a-b
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V735 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0,
       d,
       b
  FROM t1
 ORDER BY 2,1,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V736 AS SELECT c-d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V737 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c)
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 4,3,5,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V738 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V739 AS SELECT a+b*2.0+c*3.0,
       a-b,
       c-d
  FROM t1
 WHERE a>b
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V740 AS SELECT d,
       a+b*2.0+c*3.0,
       a+b*2.0,
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,3,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V741 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0,
       c,
       d-e,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d,
       a-b
  FROM t1
 ORDER BY 3,1,7,6,4,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V742 AS SELECT c-d,
       e,
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 4,1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V743 AS SELECT a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a
  FROM t1
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V744 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(a),
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND b>c
   AND (e>a AND e<b)
 ORDER BY 4,6,2,5,7,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V745 AS SELECT c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V746 AS SELECT b-c,
       c
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V747 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0,
       c-d
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
    OR c>d
 ORDER BY 3,2,6,5,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V748 AS SELECT d
  FROM t1
 WHERE d>e
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V749 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a-b
  FROM t1
 ORDER BY 4,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V750 AS SELECT abs(a),
       e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND b>c
 ORDER BY 5,3,6,1,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V751 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       b-c,
       abs(a)
  FROM t1
 ORDER BY 4,1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V752 AS SELECT d,
       abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a
  FROM t1
 WHERE a>b
 ORDER BY 1,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V753 AS SELECT abs(a),
       a+b*2.0+c*3.0,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V754 AS SELECT c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0,
       c,
       abs(a)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (e>a AND e<b)
 ORDER BY 2,4,1,3,5,6
 LIMIT 1;

CREATE VIRTUAL VIEW V755 AS SELECT d,
       a+b*2.0
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2.0 AND d+2.0
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V756 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2.0 AND d+2.0
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V757 AS SELECT b
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V758 AS SELECT (a+b+c+d+e)/5.0,
       b-c,
       a
  FROM t1
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V759 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a)
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V760 AS SELECT abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (e>c OR e<d)
 ORDER BY 3,2,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V761 AS SELECT a+b*2.0+c*3.0+d*4.0,
       d-e,
       a+b*2.0+c*3.0,
       abs(b-c),
       d,
       b-c,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,7,1,6,5,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V762 AS SELECT c-d,
       b-c,
       abs(b-c)
  FROM t1
 WHERE d>e
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V763 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 5,3,1,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V764 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b
  FROM t1
 ORDER BY 2,6,3,1,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V765 AS SELECT e,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V766 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V767 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       a+b*2.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V768 AS SELECT b
  FROM t1
 WHERE a>b
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V769 AS SELECT a+b*2.0+c*3.0,
       c-d,
       d,
       a
  FROM t1
 ORDER BY 3,2,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V770 AS SELECT b-c,
       a+b*2.0+c*3.0+d*4.0,
       c-d,
       a,
       d-e,
       c
  FROM t1
 WHERE d>e
 ORDER BY 3,4,1,5,6,2
 LIMIT 1;

CREATE VIRTUAL VIEW V771 AS SELECT c-d,
       c,
       abs(a),
       a+b*2.0+c*3.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (e>c OR e<d)
 ORDER BY 1,4,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V772 AS SELECT d-e,
       abs(b-c),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (e>a AND e<b)
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V773 AS SELECT b-c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,3,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V774 AS SELECT abs(a),
       a,
       c,
       d-e,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 1,6,3,5,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V775 AS SELECT a-b,
       c,
       a+b*2.0+c*3.0,
       b,
       d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d
  FROM t1
 ORDER BY 4,3,5,6,2,1,7
 LIMIT 1;

CREATE VIRTUAL VIEW V776 AS SELECT a,
       d-e,
       c,
       a+b*2.0,
       e
  FROM t1
 WHERE a>b
    OR c>d
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,3,5,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V777 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       a,
       a+b*2.0
  FROM t1
 WHERE (e>a AND e<b)
   AND (e>c OR e<d)
 ORDER BY 3,6,2,1,5,7,4
 LIMIT 1;

CREATE VIRTUAL VIEW V778 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 2,3,1,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V779 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,5,4,6,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V780 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0,
       (a+b+c+d+e)/5.0,
       b,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,5,7,2,4,6,1
 LIMIT 1;

CREATE VIRTUAL VIEW V781 AS SELECT b,
       a-b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       c,
       c-d
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 5,3,4,6,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V782 AS SELECT a-b,
       b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d
  FROM t1
 ORDER BY 5,2,1,4,3,6
 LIMIT 1;

CREATE VIRTUAL VIEW V783 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (e>a AND e<b)
   AND d>e
 ORDER BY 2,1,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V784 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       a+b*2.0+c*3.0+d*4.0,
       a,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d
  FROM t1
 WHERE d>e
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 7,3,2,4,6,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V785 AS SELECT d,
       (a+b+c+d+e)/5.0,
       d-e,
       a,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND (c<=d-2.0 OR c>=d+2.0)
   AND a>b
 ORDER BY 5,2,1,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V786 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
 ORDER BY 1,2,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V787 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0,
       b
  FROM t1
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V788 AS SELECT a
  FROM t1
 WHERE d>e
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V789 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V790 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V791 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a-b
  FROM t1
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V792 AS SELECT a+b*2.0,
       b-c,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V793 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0,
       abs(b-c),
       a+b*2.0,
       d-e
  FROM t1
 ORDER BY 4,3,1,7,2,5,6
 LIMIT 1;

CREATE VIRTUAL VIEW V794 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       abs(b-c),
       e
  FROM t1
 ORDER BY 2,3,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V795 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V796 AS SELECT a+b*2.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V797 AS SELECT (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 4,3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V798 AS SELECT b,
       c,
       e,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (a+b+c+d+e)/5.0,
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
   AND e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 5,6,1,2,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V799 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 4,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V800 AS SELECT a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND d>e
   AND b>c
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V801 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5.0,
       c-d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       a+b*2.0+c*3.0+d*4.0,
       abs(a)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,5,1,3,7,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V802 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a-b,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE b>c
   AND a>b
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V803 AS SELECT b,
       d,
       b-c
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V804 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0,
       a+b*2.0+c*3.0,
       e,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 4,3,1,5,6,2
 LIMIT 1;

CREATE VIRTUAL VIEW V805 AS SELECT (a+b+c+d+e)/5.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V806 AS SELECT d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0,
       abs(a),
       d-e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,5,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V807 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0,
       abs(b-c),
       a+b*2.0+c*3.0,
       c-d,
       a
  FROM t1
 ORDER BY 1,4,2,7,3,6,5
 LIMIT 1;

CREATE VIRTUAL VIEW V808 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE a>b
   AND b>c
   AND (e>c OR e<d)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V809 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e
  FROM t1
 ORDER BY 3,1,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V810 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V811 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110.0 AND 150.0
    OR (e>a AND e<b)
 ORDER BY 4,3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V812 AS SELECT c
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V813 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0,
       a-b,
       c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR d>e
    OR b>c
 ORDER BY 4,2,1,6,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V814 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (a+b+c+d+e)/5.0,
       abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c>d
    OR e+d BETWEEN a+b-10.0 AND c+130.0
    OR (e>a AND e<b)
 ORDER BY 2,1,4,3,5,6,7
 LIMIT 1;

CREATE VIRTUAL VIEW V815 AS SELECT (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V816 AS SELECT c-d
  FROM t1
 WHERE d>e
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND a>b
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V817 AS SELECT a+b*2.0+c*3.0,
       d,
       e,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2.0 AND d+2.0
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V818 AS SELECT d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e,
       a+b*2.0+c*3.0+d*4.0,
       a,
       a+b*2.0+c*3.0,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE b>c
 ORDER BY 7,4,2,6,5,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V819 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       a,
       (a+b+c+d+e)/5.0,
       c,
       a+b*2.0
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 6,1,4,2,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V820 AS SELECT a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0,
       abs(a),
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
 ORDER BY 6,3,1,5,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V821 AS SELECT c
  FROM t1
 WHERE d>e
   AND (a>b-2.0 AND a<b+2.0)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V822 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       a+b*2.0+c*3.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V823 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V824 AS SELECT a-b
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>a AND e<b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V825 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (e>c OR e<d)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V826 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND a>b
   AND (e>c OR e<d)
 ORDER BY 2,5,3,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V827 AS SELECT e,
       c-d
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR a>b
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V828 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       b-c,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 5,6,2,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V829 AS SELECT abs(a),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND c BETWEEN b-2.0 AND d+2.0
   AND d>e
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V830 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V831 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b,
       a+b*2.0
  FROM t1
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V832 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (e>c OR e<d)
    OR a>b
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V833 AS SELECT c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,3,1,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V834 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b,
       b-c,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,4,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V835 AS SELECT d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0
  FROM t1
 ORDER BY 6,2,5,1,4,7,3
 LIMIT 1;

CREATE VIRTUAL VIEW V836 AS SELECT (a+b+c+d+e)/5.0
  FROM t1
 WHERE b>c
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V837 AS SELECT b-c,
       a,
       a+b*2.0+c*3.0+d*4.0,
       d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND c>d
   AND d>e
 ORDER BY 4,2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V838 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       a+b*2.0,
       abs(b-c),
       d
  FROM t1
 WHERE d>e
 ORDER BY 3,4,2,6,5,7,1
 LIMIT 1;

CREATE VIRTUAL VIEW V839 AS SELECT a,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,2,3,6,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V840 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       e,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c
  FROM t1
 ORDER BY 6,4,3,1,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V841 AS SELECT c-d,
       d,
       e
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V842 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0,
       c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR c>d
    OR b>c
 ORDER BY 4,2,3,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V843 AS SELECT b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,5,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V844 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       b
  FROM t1
 ORDER BY 4,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V845 AS SELECT d,
       e,
       a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0,
       abs(a)
  FROM t1
 ORDER BY 1,2,7,6,4,3,5
 LIMIT 1;

CREATE VIRTUAL VIEW V846 AS SELECT b,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 2,3,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V847 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V848 AS SELECT a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR b>c
 ORDER BY 3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V849 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND a>b
 ORDER BY 3,4,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V850 AS SELECT e,
       d-e,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V851 AS SELECT a-b,
       e,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d,
       abs(a),
       a+b*2.0+c*3.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1,5,7,2,6,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V852 AS SELECT a+b*2.0+c*3.0,
       c-d,
       d-e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR (e>a AND e<b)
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V853 AS SELECT (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0,
       e,
       d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 6,4,7,5,2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V854 AS SELECT a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,4,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V855 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V856 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V857 AS SELECT (a+b+c+d+e)/5.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (a>b-2.0 AND a<b+2.0)
    OR d>e
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V858 AS SELECT abs(b-c),
       a+b*2.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 2,3,1,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V859 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE a>b
 ORDER BY 2,4,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V860 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       a-b,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,5,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V861 AS SELECT a+b*2.0+c*3.0+d*4.0,
       a,
       a+b*2.0,
       a-b,
       abs(a),
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 2,3,1,6,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V862 AS SELECT d-e,
       c,
       a+b*2.0+c*3.0,
       b,
       abs(a),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND c>d
 ORDER BY 3,5,1,2,4,6,7
 LIMIT 1;

CREATE VIRTUAL VIEW V863 AS SELECT d-e,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c,
       a+b*2.0+c*3.0,
       b,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE b>c
 ORDER BY 1,4,6,3,5,2
 LIMIT 1;

CREATE VIRTUAL VIEW V864 AS SELECT (a+b+c+d+e)/5.0,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d>e
 ORDER BY 1,6,2,5,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V865 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V866 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,4,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V867 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V868 AS SELECT (a+b+c+d+e)/5.0,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0,
       d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d-e,
       abs(a)
  FROM t1
 WHERE a>b
    OR b>c
    OR c>d
 ORDER BY 1,4,5,2,6,7,3
 LIMIT 1;

CREATE VIRTUAL VIEW V869 AS SELECT abs(a),
       c,
       a+b*2.0,
       a+b*2.0+c*3.0+d*4.0,
       d,
       a
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 5,3,4,1,6,2
 LIMIT 1;

CREATE VIRTUAL VIEW V870 AS SELECT b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2.0 AND d+2.0
   AND d>e
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V871 AS SELECT a-b,
       c-d,
       b
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V872 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 6,1,2,3,7,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V873 AS SELECT c-d,
       a-b,
       b
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V874 AS SELECT b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e,
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,4,2,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V875 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d-e
  FROM t1
 WHERE d>e
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V876 AS SELECT e,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(a),
       c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 6,7,5,4,1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V877 AS SELECT d-e
  FROM t1
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V878 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (e>a AND e<b)
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V879 AS SELECT a+b*2.0,
       e
  FROM t1
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V880 AS SELECT (a+b+c+d+e)/5.0,
       a,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
 ORDER BY 3,1,2,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V881 AS SELECT a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(a),
       d,
       b-c
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (e>a AND e<b)
   AND c>d
 ORDER BY 1,5,4,6,3,2,7
 LIMIT 1;

CREATE VIRTUAL VIEW V882 AS SELECT (a+b+c+d+e)/5.0,
       a+b*2.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       d-e,
       b
  FROM t1
 ORDER BY 6,1,4,3,5,2
 LIMIT 1;

CREATE VIRTUAL VIEW V883 AS SELECT d,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a,
       c-d,
       a-b
  FROM t1
 ORDER BY 6,4,3,2,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V884 AS SELECT a,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(b-c),
       a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
 ORDER BY 2,1,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V885 AS SELECT a+b*2.0,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V886 AS SELECT abs(b-c),
       a-b,
       a+b*2.0
  FROM t1
 WHERE (e>c OR e<d)
    OR d>e
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V887 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 3,5,1,4,2,6
 LIMIT 1;

CREATE VIRTUAL VIEW V888 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a)
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V889 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 4,5,3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V890 AS SELECT a-b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V891 AS SELECT e,
       (a+b+c+d+e)/5.0,
       a+b*2.0,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 6,7,3,4,5,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V892 AS SELECT a+b*2.0+c*3.0+d*4.0,
       c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c
  FROM t1
 WHERE c>d
 ORDER BY 1,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V893 AS SELECT b,
       abs(b-c),
       d,
       a-b,
       d-e,
       c
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,5,1,4,6,3
 LIMIT 1;

CREATE VIRTUAL VIEW V894 AS SELECT b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a,
       d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 4,2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V895 AS SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V896 AS SELECT a-b,
       a+b*2.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR (c<=d-2.0 OR c>=d+2.0)
    OR a>b
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V897 AS SELECT a,
       b,
       abs(b-c),
       e,
       a+b*2.0,
       d-e,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE b>c
   AND c>d
 ORDER BY 6,1,7,2,5,4,3
 LIMIT 1;

CREATE VIRTUAL VIEW V898 AS SELECT b,
       a-b,
       e,
       d,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND d>e
 ORDER BY 2,1,5,3,6,4,7
 LIMIT 1;

CREATE VIRTUAL VIEW V899 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V900 AS SELECT abs(b-c),
       e,
       a-b,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       b
  FROM t1
 WHERE b>c
    OR c>d
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 6,5,7,2,3,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V901 AS SELECT c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d,
       a+b*2.0+c*3.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
   AND c>d
 ORDER BY 3,4,1,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V902 AS SELECT b,
       a-b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND c>d
 ORDER BY 1,2,3,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V903 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       a+b*2.0+c*3.0,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 4,3,5,2,7,1,6
 LIMIT 1;

CREATE VIRTUAL VIEW V904 AS SELECT d-e,
       b,
       abs(b-c),
       c,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 4,6,7,2,5,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V905 AS SELECT a+b*2.0,
       c,
       abs(a),
       b,
       d-e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c>d
 ORDER BY 5,2,3,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V906 AS SELECT a+b*2.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND b>c
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V907 AS SELECT abs(b-c),
       d-e,
       a+b*2.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
    OR c>d
 ORDER BY 4,2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V908 AS SELECT b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1,2,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V909 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V910 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V911 AS SELECT a+b*2.0+c*3.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a
  FROM t1
 ORDER BY 6,4,5,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V912 AS SELECT d-e,
       a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V913 AS SELECT a+b*2.0+c*3.0,
       e,
       d-e
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND c BETWEEN b-2.0 AND d+2.0
   AND d>e
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V914 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d,
       e
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V915 AS SELECT a+b*2.0+c*3.0,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V916 AS SELECT a,
       a+b*2.0+c*3.0,
       abs(a),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND (e>c OR e<d)
 ORDER BY 4,2,5,1,3,6
 LIMIT 1;

CREATE VIRTUAL VIEW V917 AS SELECT a-b,
       (a+b+c+d+e)/5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d-e,
       a,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 1,5,3,6,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V918 AS SELECT a+b*2.0,
       d,
       abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE b>c
    OR (c<=d-2.0 OR c>=d+2.0)
    OR (e>c OR e<d)
 ORDER BY 2,3,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V919 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V920 AS SELECT a-b,
       c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V921 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V922 AS SELECT c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d-e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE b>c
   AND a>b
 ORDER BY 3,4,2,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V923 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE a>b
   AND c>d
   AND d>e
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V924 AS SELECT d,
       c
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND d>e
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V925 AS SELECT a,
       c-d,
       c,
       (a+b+c+d+e)/5.0,
       abs(b-c),
       b
  FROM t1
 ORDER BY 1,2,5,4,6,3
 LIMIT 1;

CREATE VIRTUAL VIEW V926 AS SELECT a+b*2.0+c*3.0+d*4.0,
       d,
       abs(a),
       c-d,
       a
  FROM t1
 ORDER BY 1,3,4,2,5
 LIMIT 1;

CREATE VIRTUAL VIEW V927 AS SELECT c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       e,
       a,
       d-e,
       b-c,
       d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,7,6,2,3,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V928 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d,
       b-c,
       c
  FROM t1
 ORDER BY 3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V929 AS SELECT c
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V930 AS SELECT a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       e
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2.0 OR c>=d+2.0)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V931 AS SELECT a+b*2.0+c*3.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d-e,
       c,
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,1,3,5,2
 LIMIT 1;

CREATE VIRTUAL VIEW V932 AS SELECT (a+b+c+d+e)/5.0,
       e,
       c-d,
       a+b*2.0+c*3.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 5,4,3,1,2,6
 LIMIT 1;

CREATE VIRTUAL VIEW V933 AS SELECT b,
       c
  FROM t1
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V934 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e
  FROM t1
 ORDER BY 1,5,4,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V935 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0,
       e,
       d,
       b-c,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,4,5,6,1,3
 LIMIT 1;

CREATE VIRTUAL VIEW V936 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       d-e
  FROM t1
 ORDER BY 1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V937 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       e,
       d,
       b-c,
       (a+b+c+d+e)/5.0,
       abs(b-c),
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 4,3,5,1,7,2,6
 LIMIT 1;

CREATE VIRTUAL VIEW V938 AS SELECT (a+b+c+d+e)/5.0,
       c-d,
       a+b*2.0+c*3.0+d*4.0,
       d-e,
       b-c,
       e,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 7,1,2,4,6,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V939 AS SELECT c,
       b
  FROM t1
 WHERE a>b
    OR b>c
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V940 AS SELECT b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a,
       a+b*2.0,
       a+b*2.0+c*3.0,
       e
  FROM t1
 WHERE (e>c OR e<d)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,5,2,4,6,3
 LIMIT 1;

CREATE VIRTUAL VIEW V941 AS SELECT a+b*2.0+c*3.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V942 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c),
       abs(a),
       b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND d>e
 ORDER BY 1,5,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V943 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d-e,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1,3,4,2
 LIMIT 1;

CREATE VIRTUAL VIEW V944 AS SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR d>e
    OR a>b
 ORDER BY 2,3,1,4
 LIMIT 1;

CREATE VIRTUAL VIEW V945 AS SELECT b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       a-b,
       abs(a),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110.0 AND 150.0
   AND c>d
 ORDER BY 5,4,2,3,1,6
 LIMIT 1;

CREATE VIRTUAL VIEW V946 AS SELECT e
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2.0 OR c>=d+2.0)
    OR (e>a AND e<b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V947 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND (e>c OR e<d)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V948 AS SELECT abs(a)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR d>e
    OR (e>c OR e<d)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V949 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d,
       a-b,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 4,2,3,6,1,5
 LIMIT 1;

CREATE VIRTUAL VIEW V950 AS SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V951 AS SELECT (a+b+c+d+e)/5.0,
       d,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       c-d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 6,7,2,4,1,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V952 AS SELECT d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (a+b+c+d+e)/5.0,
       b,
       a,
       a+b*2.0,
       d-e
  FROM t1
 ORDER BY 5,1,6,7,2,3,4
 LIMIT 1;

CREATE VIRTUAL VIEW V953 AS SELECT c,
       a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V954 AS SELECT abs(a),
       e,
       a-b,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d-e
  FROM t1
 WHERE a>b
    OR d NOT BETWEEN 110.0 AND 150.0
    OR b>c
 ORDER BY 4,6,1,2,3,5
 LIMIT 1;

CREATE VIRTUAL VIEW V955 AS SELECT e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 4,2,1,6,5,3
 LIMIT 1;

CREATE VIRTUAL VIEW V956 AS SELECT b-c,
       a+b*2.0+c*3.0,
       a+b*2.0,
       c-d,
       (a+b+c+d+e)/5.0,
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND d NOT BETWEEN 110.0 AND 150.0
   AND d>e
 ORDER BY 6,1,5,3,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V957 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(a),
       a+b*2.0,
       a,
       d-e
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 4,2,3,5,1
 LIMIT 1;

CREATE VIRTUAL VIEW V958 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       a-b
  FROM t1
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V959 AS SELECT (a+b+c+d+e)/5.0,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (c<=d-2.0 OR c>=d+2.0)
    OR d>e
 ORDER BY 2,1,3,5,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V960 AS SELECT d,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V961 AS SELECT abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0,
       e,
       d,
       a,
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (e>c OR e<d)
 ORDER BY 5,1,7,2,3,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V962 AS SELECT abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE a>b
    OR b>c
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V963 AS SELECT a-b
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (e>c OR e<d)
   AND a>b
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V964 AS SELECT a,
       (a+b+c+d+e)/5.0,
       c
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2.0 AND d+2.0
    OR (e>c OR e<d)
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V965 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a-b,
       b,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0,
       d-e,
       abs(b-c)
  FROM t1
 WHERE b>c
   AND a>b
   AND c>d
 ORDER BY 4,2,1,7,5,6,3
 LIMIT 1;

CREATE VIRTUAL VIEW V966 AS SELECT a+b*2.0
  FROM t1
 WHERE a>b
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V967 AS SELECT (a+b+c+d+e)/5.0,
       d-e
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V968 AS SELECT d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (e>a AND e<b)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V969 AS SELECT d-e,
       c-d,
       b,
       b-c,
       abs(b-c),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 5,3,4,2,6,1
 LIMIT 1;

CREATE VIRTUAL VIEW V970 AS SELECT a+b*2.0+c*3.0+d*4.0,
       d,
       c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 6,3,7,2,1,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V971 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V972 AS SELECT a+b*2.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V973 AS SELECT b-c,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V974 AS SELECT e,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 2,3,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V975 AS SELECT abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V976 AS SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       abs(a),
       (a+b+c+d+e)/5.0,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 6,5,4,1,3,2
 LIMIT 1;

CREATE VIRTUAL VIEW V977 AS SELECT c,
       a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0,
       d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR a>b
 ORDER BY 1,3,4,5,2
 LIMIT 1;

CREATE VIRTUAL VIEW V978 AS SELECT d-e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b,
       abs(a),
       a+b*2.0+c*3.0
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,3,6,7,1,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V979 AS SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (e>c OR e<d)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V980 AS SELECT b,
       e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d,
       d-e
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
 ORDER BY 2,1,3,4,5
 LIMIT 1;

CREATE VIRTUAL VIEW V981 AS SELECT d-e,
       c,
       d
  FROM t1
 ORDER BY 3,2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V982 AS SELECT d-e,
       c
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V983 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d>e
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,3,2,5,4
 LIMIT 1;

CREATE VIRTUAL VIEW V984 AS SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V985 AS SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V986 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       e,
       a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (a+b+c+d+e)/5.0,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND c>d
 ORDER BY 1,3,5,2,6,4
 LIMIT 1;

CREATE VIRTUAL VIEW V987 AS SELECT a+b*2.0
  FROM t1
 WHERE c>d
    OR e+d BETWEEN a+b-10.0 AND c+130.0
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
 LIMIT 1;

CREATE VIRTUAL VIEW V988 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND d>e
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V989 AS SELECT a-b,
       d,
       d-e,
       a,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE a>b
 ORDER BY 3,5,4,2,1,6
 LIMIT 1;

CREATE VIRTUAL VIEW V990 AS SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e
  FROM t1
 ORDER BY 2,3,4,1
 LIMIT 1;

CREATE VIRTUAL VIEW V991 AS SELECT c,
       a+b*2.0+c*3.0+d*4.0,
       a
  FROM t1
 WHERE (e>a AND e<b)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,2,3
 LIMIT 1;

CREATE VIRTUAL VIEW V992 AS SELECT (a+b+c+d+e)/5.0,
       b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,3,2,5,4,7,6
 LIMIT 1;

CREATE VIRTUAL VIEW V993 AS SELECT d-e,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 2,1
 LIMIT 1;

CREATE VIRTUAL VIEW V994 AS SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a
  FROM t1
 ORDER BY 1,2
 LIMIT 1;

CREATE VIRTUAL VIEW V995 AS SELECT abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       d-e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR d>e
 ORDER BY 3,1,2,4
 LIMIT 1;

CREATE VIRTUAL VIEW V996 AS SELECT c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0,
       e,
       c,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (e>c OR e<d)
 ORDER BY 2,4,6,5,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V997 AS SELECT b,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 5,2,4,1,3,6
 LIMIT 1;

CREATE VIRTUAL VIEW V998 AS SELECT a,
       a+b*2.0+c*3.0,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 2,3,1
 LIMIT 1;

CREATE VIRTUAL VIEW V999 AS SELECT c
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
 LIMIT 1;

