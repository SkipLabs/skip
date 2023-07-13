CREATE VIRTUAL VIEW V0 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V1 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2 AS SELECT a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V3 AS SELECT a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V4 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       (a+b+c+d+e)/5,
       a+b*2+c*3
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V5 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       (a+b+c+d+e)/5,
       a+b*2+c*3
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,4
;

CREATE VIRTUAL VIEW V6 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       (a+b+c+d+e)/5,
       a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
;

CREATE VIRTUAL VIEW V7 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       (a+b+c+d+e)/5,
       a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
 ORDER BY 3,2,5,1,4
;

CREATE VIRTUAL VIEW V8 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       (a+b+c+d+e)/5,
       a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V9 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       (a+b+c+d+e)/5,
       a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,2,1,5
;

CREATE VIRTUAL VIEW V10 AS SELECT a,
       a+b*2+c*3+d*4,
       e,
       d,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V11 AS SELECT a,
       a+b*2+c*3+d*4,
       e,
       d,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,2,3,5
;

CREATE VIRTUAL VIEW V12 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIRTUAL VIEW V13 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V14 AS SELECT b,
       a+b*2+c*3,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
   AND b>c
;

CREATE VIRTUAL VIEW V15 AS SELECT b,
       a+b*2+c*3,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
   AND b>c
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V16 AS SELECT b,
       a+b*2+c*3,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V17 AS SELECT b,
       a+b*2+c*3,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V18 AS SELECT b,
       a+b*2+c*3,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
   AND (a>b-2 AND a<b+2)
   AND b>c
;

CREATE VIRTUAL VIEW V19 AS SELECT b,
       a+b*2+c*3,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
   AND (a>b-2 AND a<b+2)
   AND b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V20 AS SELECT b,
       a+b*2+c*3,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
   AND (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V21 AS SELECT b,
       a+b*2+c*3,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
   AND (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
 ORDER BY 4,2
;

CREATE VIRTUAL VIEW V22 AS SELECT e,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d>e
;

CREATE VIRTUAL VIEW V23 AS SELECT e,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d>e
 ORDER BY 3,1,5,2,4
;

CREATE VIRTUAL VIEW V24 AS SELECT e,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       d-e
  FROM t1
 WHERE d>e
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V25 AS SELECT e,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       d-e
  FROM t1
 WHERE d>e
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 4,1,5,3,2
;

CREATE VIRTUAL VIEW V26 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIRTUAL VIEW V27 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V28 AS SELECT d-e
  FROM t1
 WHERE b>c
    OR a>b
;

CREATE VIRTUAL VIEW V29 AS SELECT d-e
  FROM t1
 WHERE b>c
    OR a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V30 AS SELECT d
  FROM t1
 WHERE a>b
    OR d>e
;

CREATE VIRTUAL VIEW V31 AS SELECT d
  FROM t1
 WHERE a>b
    OR d>e
 ORDER BY 1
;

CREATE VIRTUAL VIEW V32 AS SELECT d
  FROM t1
 WHERE d>e
    OR a>b
;

CREATE VIRTUAL VIEW V33 AS SELECT d
  FROM t1
 WHERE d>e
    OR a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V34 AS SELECT abs(a),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V35 AS SELECT abs(a),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE a>b
 ORDER BY 7,3,5,1,6
;

CREATE VIRTUAL VIEW V36 AS SELECT d,
       a,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIRTUAL VIEW V37 AS SELECT d,
       a,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V38 AS SELECT d-e,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
    OR b>c
;

CREATE VIRTUAL VIEW V39 AS SELECT d-e,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
    OR b>c
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V40 AS SELECT d-e,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR b>c
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V41 AS SELECT d-e,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR b>c
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V42 AS SELECT d-e,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V43 AS SELECT d-e,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V44 AS SELECT d-e,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR b>c
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V45 AS SELECT d-e,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR b>c
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V46 AS SELECT a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c,
       (a+b+c+d+e)/5,
       d-e,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIRTUAL VIEW V47 AS SELECT a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c,
       (a+b+c+d+e)/5,
       d-e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 4,5
;

CREATE VIRTUAL VIEW V48 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       b-c,
       c
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V49 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       b-c,
       c
  FROM t1
 WHERE c>d
 ORDER BY 1,5,3,2
;

CREATE VIRTUAL VIEW V50 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V51 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V52 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
   AND d>e
;

CREATE VIRTUAL VIEW V53 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
   AND d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V54 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
   AND d>e
;

CREATE VIRTUAL VIEW V55 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
   AND d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V56 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c,
       b,
       abs(a),
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
   AND a>b
;

CREATE VIRTUAL VIEW V57 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c,
       b,
       abs(a),
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
   AND a>b
 ORDER BY 5,1,3,4,2,6
;

CREATE VIRTUAL VIEW V58 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c,
       b,
       abs(a),
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V59 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c,
       b,
       abs(a),
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 6,5,1,2,4
;

CREATE VIRTUAL VIEW V60 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c,
       b,
       abs(a),
       a-b
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110 AND 150
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V61 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c,
       b,
       abs(a),
       a-b
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110 AND 150
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2,3,4,6
;

CREATE VIRTUAL VIEW V62 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c,
       b,
       abs(a),
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
;

CREATE VIRTUAL VIEW V63 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c,
       b,
       abs(a),
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
 ORDER BY 4,3,1
;

CREATE VIRTUAL VIEW V64 AS SELECT a-b,
       d,
       c-d,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
;

CREATE VIRTUAL VIEW V65 AS SELECT a-b,
       d,
       c-d,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
 ORDER BY 3,5,1,2
;

CREATE VIRTUAL VIEW V66 AS SELECT a-b,
       d,
       c-d,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V67 AS SELECT a-b,
       d,
       c-d,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
 ORDER BY 5,1,3
;

CREATE VIRTUAL VIEW V68 AS SELECT d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       a+b*2+c*3+d*4,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V69 AS SELECT d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       a+b*2+c*3+d*4,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 3,1,4
;

CREATE VIRTUAL VIEW V70 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c)
  FROM t1
;

CREATE VIRTUAL VIEW V71 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c)
  FROM t1
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V72 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       b,
       abs(a),
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
;

CREATE VIRTUAL VIEW V73 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       b,
       abs(a),
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
 ORDER BY 3,2,4,5
;

CREATE VIRTUAL VIEW V74 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       b,
       abs(a),
       a
  FROM t1
 WHERE b>c
   AND e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V75 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       b,
       abs(a),
       a
  FROM t1
 WHERE b>c
   AND e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2,4
;

CREATE VIRTUAL VIEW V76 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       b,
       abs(a),
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V77 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       b,
       abs(a),
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 5,1,4,3,2
;

CREATE VIRTUAL VIEW V78 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       c,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V79 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       c,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,5,4,7,1,3
;

CREATE VIRTUAL VIEW V80 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       c,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
;

CREATE VIRTUAL VIEW V81 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       c,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
 ORDER BY 4,3,1
;

CREATE VIRTUAL VIEW V82 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       c,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
   AND d>e
;

CREATE VIRTUAL VIEW V83 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       c,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
   AND d>e
 ORDER BY 5,4,2
;

CREATE VIRTUAL VIEW V84 AS SELECT a,
       (a+b+c+d+e)/5,
       b
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V85 AS SELECT a,
       (a+b+c+d+e)/5,
       b
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V86 AS SELECT a,
       (a+b+c+d+e)/5,
       b
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
;

CREATE VIRTUAL VIEW V87 AS SELECT a,
       (a+b+c+d+e)/5,
       b
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V88 AS SELECT a,
       (a+b+c+d+e)/5,
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V89 AS SELECT a,
       (a+b+c+d+e)/5,
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
   AND (e>c OR e<d)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V90 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       d-e,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
;

CREATE VIRTUAL VIEW V91 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       d-e,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
 ORDER BY 7,5,6
;

CREATE VIRTUAL VIEW V92 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       d-e,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE b>c
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V93 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       d-e,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE b>c
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,6,4,5,3,1,7
;

CREATE VIRTUAL VIEW V94 AS SELECT a+b*2+c*3,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
   AND a>b
;

CREATE VIRTUAL VIEW V95 AS SELECT a+b*2+c*3,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
   AND a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V96 AS SELECT a+b*2+c*3,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
   AND a>b
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V97 AS SELECT a+b*2+c*3,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
   AND a>b
   AND (e>a AND e<b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V98 AS SELECT a+b*2+c*3,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND a>b
;

CREATE VIRTUAL VIEW V99 AS SELECT a+b*2+c*3,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V100 AS SELECT a+b*2+c*3,
       abs(b-c),
       d,
       d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V101 AS SELECT a+b*2+c*3,
       abs(b-c),
       d,
       d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
 ORDER BY 3,1,4,2
;

CREATE VIRTUAL VIEW V102 AS SELECT a+b*2+c*3,
       abs(b-c),
       d,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V103 AS SELECT a+b*2+c*3,
       abs(b-c),
       d,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,2,4
;

CREATE VIRTUAL VIEW V104 AS SELECT a+b*2+c*3,
       abs(b-c),
       d,
       d-e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V105 AS SELECT a+b*2+c*3,
       abs(b-c),
       d,
       d-e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
 ORDER BY 3,4,1,2
;

CREATE VIRTUAL VIEW V106 AS SELECT a+b*2+c*3,
       abs(b-c),
       d,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V107 AS SELECT a+b*2+c*3,
       abs(b-c),
       d,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V108 AS SELECT b-c,
       b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND a>b
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V109 AS SELECT b-c,
       b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND a>b
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V110 AS SELECT b-c,
       b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
   AND a>b
;

CREATE VIRTUAL VIEW V111 AS SELECT b-c,
       b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
   AND a>b
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V112 AS SELECT b-c,
       b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
   AND a>b
;

CREATE VIRTUAL VIEW V113 AS SELECT b-c,
       b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
   AND a>b
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V114 AS SELECT b-c,
       b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V115 AS SELECT b-c,
       b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V116 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       e,
       d-e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V117 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       e,
       d-e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE b>c
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V118 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIRTUAL VIEW V119 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V120 AS SELECT a+b*2+c*3+d*4,
       a-b,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       b-c
  FROM t1
 WHERE d>e
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V121 AS SELECT a+b*2+c*3+d*4,
       a-b,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       b-c
  FROM t1
 WHERE d>e
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 6,5,3,4
;

CREATE VIRTUAL VIEW V122 AS SELECT a-b,
       a,
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
;

CREATE VIRTUAL VIEW V123 AS SELECT a-b,
       a,
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V124 AS SELECT a-b,
       a,
       c
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V125 AS SELECT a-b,
       a,
       c
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V126 AS SELECT b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       b,
       c-d,
       a+b*2
  FROM t1
;

CREATE VIRTUAL VIEW V127 AS SELECT b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       b,
       c-d,
       a+b*2
  FROM t1
 ORDER BY 4,5,1,2,3
;

CREATE VIRTUAL VIEW V128 AS SELECT d-e,
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V129 AS SELECT d-e,
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 5,2,4
;

CREATE VIRTUAL VIEW V130 AS SELECT a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
;

CREATE VIRTUAL VIEW V131 AS SELECT a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V132 AS SELECT a+b*2
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V133 AS SELECT a+b*2
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V134 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       a,
       d-e,
       b
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V135 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       a,
       d-e,
       b
  FROM t1
 WHERE d>e
 ORDER BY 6,2,1,4,5,3
;

CREATE VIRTUAL VIEW V136 AS SELECT a+b*2+c*3+d*4+e*5,
       b-c,
       abs(a),
       abs(b-c),
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
    OR b>c
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V137 AS SELECT a+b*2+c*3+d*4+e*5,
       b-c,
       abs(a),
       abs(b-c),
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
    OR b>c
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,4,5,3
;

CREATE VIRTUAL VIEW V138 AS SELECT a+b*2+c*3+d*4+e*5,
       b-c,
       abs(a),
       abs(b-c),
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR b>c
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V139 AS SELECT a+b*2+c*3+d*4+e*5,
       b-c,
       abs(a),
       abs(b-c),
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR b>c
    OR (e>a AND e<b)
 ORDER BY 3,4,6,1,5
;

CREATE VIRTUAL VIEW V140 AS SELECT e,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V141 AS SELECT e,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V142 AS SELECT e,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V143 AS SELECT e,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>a AND e<b)
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V144 AS SELECT (a+b+c+d+e)/5,
       d-e,
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND d>e
;

CREATE VIRTUAL VIEW V145 AS SELECT (a+b+c+d+e)/5,
       d-e,
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND d>e
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V146 AS SELECT (a+b+c+d+e)/5,
       d-e,
       d
  FROM t1
 WHERE d>e
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V147 AS SELECT (a+b+c+d+e)/5,
       d-e,
       d
  FROM t1
 WHERE d>e
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V148 AS SELECT a,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIRTUAL VIEW V149 AS SELECT a,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V150 AS SELECT abs(b-c),
       e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       c-d,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIRTUAL VIEW V151 AS SELECT abs(b-c),
       e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 4,3,1,7,2
;

CREATE VIRTUAL VIEW V152 AS SELECT a-b
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V153 AS SELECT a-b
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V154 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b>c
   AND c>d
;

CREATE VIRTUAL VIEW V155 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b>c
   AND c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V156 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND b>c
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V157 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND b>c
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V158 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c>d
   AND b>c
;

CREATE VIRTUAL VIEW V159 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c>d
   AND b>c
 ORDER BY 1
;

CREATE VIRTUAL VIEW V160 AS SELECT a+b*2+c*3
  FROM t1
;

CREATE VIRTUAL VIEW V161 AS SELECT a+b*2+c*3
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V162 AS SELECT b,
       a+b*2,
       a
  FROM t1
 WHERE b>c
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V163 AS SELECT b,
       a+b*2,
       a
  FROM t1
 WHERE b>c
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V164 AS SELECT b,
       a+b*2,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
   AND b>c
;

CREATE VIRTUAL VIEW V165 AS SELECT b,
       a+b*2,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
   AND b>c
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V166 AS SELECT b,
       a+b*2,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V167 AS SELECT b,
       a+b*2,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V168 AS SELECT abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       c-d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V169 AS SELECT abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       c-d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 4,2
;

CREATE VIRTUAL VIEW V170 AS SELECT abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       c-d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V171 AS SELECT abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       c-d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 6,1,5,3
;

CREATE VIRTUAL VIEW V172 AS SELECT c-d,
       d-e,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V173 AS SELECT c-d,
       d-e,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 1,4,3
;

CREATE VIRTUAL VIEW V174 AS SELECT c-d,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V175 AS SELECT c-d,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,3,2,5,4,6
;

CREATE VIRTUAL VIEW V176 AS SELECT b-c,
       a+b*2+c*3,
       abs(b-c),
       e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V177 AS SELECT b-c,
       a+b*2+c*3,
       abs(b-c),
       e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
 ORDER BY 4,1,3,6,2
;

CREATE VIRTUAL VIEW V178 AS SELECT b-c,
       a+b*2+c*3,
       abs(b-c),
       e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V179 AS SELECT b-c,
       a+b*2+c*3,
       abs(b-c),
       e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V180 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V181 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,5,2,1,3
;

CREATE VIRTUAL VIEW V182 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       a-b,
       abs(a),
       d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V183 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       a-b,
       abs(a),
       d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 4,1,3
;

CREATE VIRTUAL VIEW V184 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       a-b,
       abs(a),
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V185 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       a-b,
       abs(a),
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 3,2,1,6
;

CREATE VIRTUAL VIEW V186 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V187 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,5,4,1
;

CREATE VIRTUAL VIEW V188 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V189 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V190 AS SELECT e,
       abs(a),
       a,
       b-c,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V191 AS SELECT e,
       abs(a),
       a,
       b-c,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 4,1,3
;

CREATE VIRTUAL VIEW V192 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       (a+b+c+d+e)/5,
       c-d,
       abs(a),
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V193 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       (a+b+c+d+e)/5,
       c-d,
       abs(a),
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 7,3
;

CREATE VIRTUAL VIEW V194 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIRTUAL VIEW V195 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V196 AS SELECT a+b*2+c*3+d*4,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       abs(b-c),
       d
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110 AND 150
    OR d>e
;

CREATE VIRTUAL VIEW V197 AS SELECT a+b*2+c*3+d*4,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       abs(b-c),
       d
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110 AND 150
    OR d>e
 ORDER BY 2,4,3,5
;

CREATE VIRTUAL VIEW V198 AS SELECT a+b*2+c*3+d*4,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       abs(b-c),
       d
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110 AND 150
    OR b>c
;

CREATE VIRTUAL VIEW V199 AS SELECT a+b*2+c*3+d*4,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       abs(b-c),
       d
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110 AND 150
    OR b>c
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V200 AS SELECT a+b*2+c*3+d*4,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       abs(b-c),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR b>c
    OR d>e
;

CREATE VIRTUAL VIEW V201 AS SELECT a+b*2+c*3+d*4,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       abs(b-c),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR b>c
    OR d>e
 ORDER BY 3,4,5,6,1,2
;

CREATE VIRTUAL VIEW V202 AS SELECT b-c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V203 AS SELECT b-c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V204 AS SELECT c,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       abs(b-c),
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V205 AS SELECT c,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       abs(b-c),
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,5,2,3
;

CREATE VIRTUAL VIEW V206 AS SELECT a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V207 AS SELECT a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
 ORDER BY 2,5
;

CREATE VIRTUAL VIEW V208 AS SELECT a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V209 AS SELECT a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 4,1,3
;

CREATE VIRTUAL VIEW V210 AS SELECT b-c,
       a+b*2,
       c,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIRTUAL VIEW V211 AS SELECT b-c,
       a+b*2,
       c,
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V212 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND a>b
   AND d>e
;

CREATE VIRTUAL VIEW V213 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND a>b
   AND d>e
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V214 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE d>e
   AND a>b
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V215 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE d>e
   AND a>b
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V216 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND a>b
;

CREATE VIRTUAL VIEW V217 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND a>b
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V218 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE a>b
   AND (a>b-2 AND a<b+2)
   AND d>e
;

CREATE VIRTUAL VIEW V219 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE a>b
   AND (a>b-2 AND a<b+2)
   AND d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V220 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIRTUAL VIEW V221 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V222 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V223 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V224 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5,
       a+b*2
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND b>c
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V225 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5,
       a+b*2
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND b>c
   AND (e>a AND e<b)
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V226 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
   AND b>c
;

CREATE VIRTUAL VIEW V227 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
   AND b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V228 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5,
       a+b*2
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
   AND b>c
;

CREATE VIRTUAL VIEW V229 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5,
       a+b*2
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
   AND b>c
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V230 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V231 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,1,5,4,6
;

CREATE VIRTUAL VIEW V232 AS SELECT d,
       c-d
  FROM t1
;

CREATE VIRTUAL VIEW V233 AS SELECT d,
       c-d
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V234 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V235 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V236 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND b>c
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V237 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND b>c
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V238 AS SELECT e
  FROM t1
 WHERE b>c
   AND d>e
;

CREATE VIRTUAL VIEW V239 AS SELECT e
  FROM t1
 WHERE b>c
   AND d>e
 ORDER BY 1
;

CREATE VIRTUAL VIEW V240 AS SELECT abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V241 AS SELECT abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V242 AS SELECT d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V243 AS SELECT d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V244 AS SELECT d-e
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V245 AS SELECT d-e
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V246 AS SELECT d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V247 AS SELECT d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V248 AS SELECT d-e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V249 AS SELECT d-e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V250 AS SELECT e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V251 AS SELECT e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V252 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V253 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V254 AS SELECT a+b*2+c*3+d*4+e*5,
       a,
       d,
       (a+b+c+d+e)/5,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIRTUAL VIEW V255 AS SELECT a+b*2+c*3+d*4+e*5,
       a,
       d,
       (a+b+c+d+e)/5,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V256 AS SELECT a,
       abs(b-c),
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c
  FROM t1
 WHERE (e>a AND e<b)
    OR a>b
;

CREATE VIRTUAL VIEW V257 AS SELECT a,
       abs(b-c),
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c
  FROM t1
 WHERE (e>a AND e<b)
    OR a>b
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V258 AS SELECT a,
       abs(b-c),
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c
  FROM t1
 WHERE a>b
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V259 AS SELECT a,
       abs(b-c),
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c
  FROM t1
 WHERE a>b
    OR (e>a AND e<b)
 ORDER BY 2,4,5,3
;

CREATE VIRTUAL VIEW V260 AS SELECT abs(b-c),
       d-e,
       c-d,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
;

CREATE VIRTUAL VIEW V261 AS SELECT abs(b-c),
       d-e,
       c-d,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
 ORDER BY 1,3,7,2,5,4,6
;

CREATE VIRTUAL VIEW V262 AS SELECT abs(b-c),
       d-e,
       c-d,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V263 AS SELECT abs(b-c),
       d-e,
       c-d,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
 ORDER BY 7,3,4,6,2,1,5
;

CREATE VIRTUAL VIEW V264 AS SELECT a-b,
       a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V265 AS SELECT a-b,
       a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V266 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       a+b*2,
       d-e,
       b
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V267 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       a+b*2,
       d-e,
       b
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V268 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       b,
       a+b*2+c*3+d*4,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V269 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       b,
       a+b*2+c*3+d*4,
       abs(a)
  FROM t1
 ORDER BY 6,5
;

CREATE VIRTUAL VIEW V270 AS SELECT abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a-b,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V271 AS SELECT abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a-b,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 3,5,4
;

CREATE VIRTUAL VIEW V272 AS SELECT a+b*2,
       abs(a),
       e,
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V273 AS SELECT a+b*2,
       abs(a),
       e,
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 5,2
;

CREATE VIRTUAL VIEW V274 AS SELECT abs(b-c),
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       c,
       e,
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
    OR a>b
;

CREATE VIRTUAL VIEW V275 AS SELECT abs(b-c),
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       c,
       e,
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
    OR a>b
 ORDER BY 4,2,5
;

CREATE VIRTUAL VIEW V276 AS SELECT abs(b-c),
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       c,
       e,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR a>b
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V277 AS SELECT abs(b-c),
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       c,
       e,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR a>b
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1,6,7,5,3
;

CREATE VIRTUAL VIEW V278 AS SELECT c-d,
       b-c
  FROM t1
 WHERE a>b
    OR c>d
    OR d>e
;

CREATE VIRTUAL VIEW V279 AS SELECT c-d,
       b-c
  FROM t1
 WHERE a>b
    OR c>d
    OR d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V280 AS SELECT c-d,
       b-c
  FROM t1
 WHERE d>e
    OR c>d
    OR a>b
;

CREATE VIRTUAL VIEW V281 AS SELECT c-d,
       b-c
  FROM t1
 WHERE d>e
    OR c>d
    OR a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V282 AS SELECT c-d,
       b-c
  FROM t1
 WHERE d>e
    OR a>b
    OR c>d
;

CREATE VIRTUAL VIEW V283 AS SELECT c-d,
       b-c
  FROM t1
 WHERE d>e
    OR a>b
    OR c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V284 AS SELECT abs(b-c),
       a
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V285 AS SELECT abs(b-c),
       a
  FROM t1
 WHERE c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V286 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       a+b*2+c*3+d*4+e*5,
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
   AND b>c
;

CREATE VIRTUAL VIEW V287 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       a+b*2+c*3+d*4+e*5,
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
   AND b>c
 ORDER BY 3,1,5,4,2
;

CREATE VIRTUAL VIEW V288 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       a+b*2+c*3+d*4+e*5,
       c
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V289 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       a+b*2+c*3+d*4+e*5,
       c
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,5,4,2,1
;

CREATE VIRTUAL VIEW V290 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       a+b*2+c*3+d*4+e*5,
       c
  FROM t1
 WHERE b>c
   AND (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V291 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       a+b*2+c*3+d*4+e*5,
       c
  FROM t1
 WHERE b>c
   AND (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V292 AS SELECT b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V293 AS SELECT b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V294 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a,
       d,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b
  FROM t1
;

CREATE VIRTUAL VIEW V295 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a,
       d,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b
  FROM t1
 ORDER BY 3,1,5,2,6,4,7
;

CREATE VIRTUAL VIEW V296 AS SELECT a,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       a+b*2+c*3+d*4+e*5,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V297 AS SELECT a,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       a+b*2+c*3+d*4+e*5,
       abs(a)
  FROM t1
 ORDER BY 2,6,1,4,3
;

CREATE VIRTUAL VIEW V298 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       d,
       a
  FROM t1
;

CREATE VIRTUAL VIEW V299 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       d,
       a
  FROM t1
 ORDER BY 5,3,2,4
;

CREATE VIRTUAL VIEW V300 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V301 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V302 AS SELECT c-d,
       a+b*2+c*3+d*4+e*5,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       d-e,
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V303 AS SELECT c-d,
       a+b*2+c*3+d*4+e*5,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       d-e,
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 7,4,1
;

CREATE VIRTUAL VIEW V304 AS SELECT c,
       b-c,
       a+b*2+c*3,
       abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V305 AS SELECT c,
       b-c,
       a+b*2+c*3,
       abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 4,1,2,3,6,5
;

CREATE VIRTUAL VIEW V306 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       abs(b-c),
       d,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V307 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       abs(b-c),
       d,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 ORDER BY 3,1,5,6,4
;

CREATE VIRTUAL VIEW V308 AS SELECT c-d,
       a+b*2+c*3+d*4,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a)
  FROM t1
 WHERE b>c
    OR a>b
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V309 AS SELECT c-d,
       a+b*2+c*3+d*4,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a)
  FROM t1
 WHERE b>c
    OR a>b
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,4,5
;

CREATE VIRTUAL VIEW V310 AS SELECT c-d,
       a+b*2+c*3+d*4,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR a>b
    OR b>c
;

CREATE VIRTUAL VIEW V311 AS SELECT c-d,
       a+b*2+c*3+d*4,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR a>b
    OR b>c
 ORDER BY 4,5,1
;

CREATE VIRTUAL VIEW V312 AS SELECT c-d,
       a+b*2+c*3+d*4,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a)
  FROM t1
 WHERE a>b
    OR (c<=d-2 OR c>=d+2)
    OR b>c
;

CREATE VIRTUAL VIEW V313 AS SELECT c-d,
       a+b*2+c*3+d*4,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a)
  FROM t1
 WHERE a>b
    OR (c<=d-2 OR c>=d+2)
    OR b>c
 ORDER BY 1,5,3
;

CREATE VIRTUAL VIEW V314 AS SELECT d-e,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIRTUAL VIEW V315 AS SELECT d-e,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 4,3,6
;

CREATE VIRTUAL VIEW V316 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       e
  FROM t1
;

CREATE VIRTUAL VIEW V317 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       e
  FROM t1
 ORDER BY 3,5,4,1,2
;

CREATE VIRTUAL VIEW V318 AS SELECT a+b*2+c*3,
       b-c,
       abs(a),
       d,
       (a+b+c+d+e)/5,
       b
  FROM t1
;

CREATE VIRTUAL VIEW V319 AS SELECT a+b*2+c*3,
       b-c,
       abs(a),
       d,
       (a+b+c+d+e)/5,
       b
  FROM t1
 ORDER BY 1,5,3,6,4
;

CREATE VIRTUAL VIEW V320 AS SELECT d,
       a,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V321 AS SELECT d,
       a,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 5,3,1,2,4
;

CREATE VIRTUAL VIEW V322 AS SELECT d-e,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
;

CREATE VIRTUAL VIEW V323 AS SELECT d-e,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
 ORDER BY 5,1,4,2,3
;

CREATE VIRTUAL VIEW V324 AS SELECT d-e,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V325 AS SELECT d-e,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,4,3
;

CREATE VIRTUAL VIEW V326 AS SELECT (a+b+c+d+e)/5,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V327 AS SELECT (a+b+c+d+e)/5,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V328 AS SELECT (a+b+c+d+e)/5,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V329 AS SELECT (a+b+c+d+e)/5,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 2,3,4
;

CREATE VIRTUAL VIEW V330 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
;

CREATE VIRTUAL VIEW V331 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V332 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       c-d
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V333 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       c-d
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V334 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       d,
       c,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIRTUAL VIEW V335 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       d,
       c,
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 4,3,5,2,6
;

CREATE VIRTUAL VIEW V336 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V337 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,1,4,2
;

CREATE VIRTUAL VIEW V338 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V339 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,2,4,3
;

CREATE VIRTUAL VIEW V340 AS SELECT b-c,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V341 AS SELECT b-c,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 4,2,5,1,3
;

CREATE VIRTUAL VIEW V342 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V343 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
 ORDER BY 2,1,3,4,5
;

CREATE VIRTUAL VIEW V344 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
;

CREATE VIRTUAL VIEW V345 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
 ORDER BY 2,7,3,5,4
;

CREATE VIRTUAL VIEW V346 AS SELECT a+b*2+c*3,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       c-d,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V347 AS SELECT a+b*2+c*3,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       c-d,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1,2,5,3
;

CREATE VIRTUAL VIEW V348 AS SELECT a+b*2+c*3+d*4+e*5,
       b-c,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V349 AS SELECT a+b*2+c*3+d*4+e*5,
       b-c,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,2,6,3,5,7,1
;

CREATE VIRTUAL VIEW V350 AS SELECT b-c,
       a+b*2+c*3
  FROM t1
;

CREATE VIRTUAL VIEW V351 AS SELECT b-c,
       a+b*2+c*3
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V352 AS SELECT d-e,
       e,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
;

CREATE VIRTUAL VIEW V353 AS SELECT d-e,
       e,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
 ORDER BY 2,1,4
;

CREATE VIRTUAL VIEW V354 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       b-c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V355 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       b-c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,4,2,3
;

CREATE VIRTUAL VIEW V356 AS SELECT a-b,
       (a+b+c+d+e)/5,
       b,
       e,
       b-c
  FROM t1
;

CREATE VIRTUAL VIEW V357 AS SELECT a-b,
       (a+b+c+d+e)/5,
       b,
       e,
       b-c
  FROM t1
 ORDER BY 3,5,4,2,1
;

CREATE VIRTUAL VIEW V358 AS SELECT (a+b+c+d+e)/5,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
   AND c>d
;

CREATE VIRTUAL VIEW V359 AS SELECT (a+b+c+d+e)/5,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
   AND c>d
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V360 AS SELECT (a+b+c+d+e)/5,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND d>e
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V361 AS SELECT (a+b+c+d+e)/5,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND d>e
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V362 AS SELECT (a+b+c+d+e)/5,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND c BETWEEN b-2 AND d+2
   AND d>e
;

CREATE VIRTUAL VIEW V363 AS SELECT (a+b+c+d+e)/5,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND c BETWEEN b-2 AND d+2
   AND d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V364 AS SELECT a+b*2+c*3+d*4,
       d
  FROM t1
 WHERE c>d
   AND c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V365 AS SELECT a+b*2+c*3+d*4,
       d
  FROM t1
 WHERE c>d
   AND c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V366 AS SELECT a+b*2+c*3+d*4,
       d
  FROM t1
 WHERE (e>c OR e<d)
   AND c>d
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V367 AS SELECT a+b*2+c*3+d*4,
       d
  FROM t1
 WHERE (e>c OR e<d)
   AND c>d
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V368 AS SELECT a+b*2+c*3+d*4,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
   AND c>d
;

CREATE VIRTUAL VIEW V369 AS SELECT a+b*2+c*3+d*4,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
   AND c>d
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V370 AS SELECT abs(a),
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V371 AS SELECT abs(a),
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2,4,5,3
;

CREATE VIRTUAL VIEW V372 AS SELECT a,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V373 AS SELECT a,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE a>b
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V374 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V375 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V376 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
;

CREATE VIRTUAL VIEW V377 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V378 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       c-d
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V379 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       c-d
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V380 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V381 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,4,5,3,2
;

CREATE VIRTUAL VIEW V382 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2 AND d+2
   AND c>d
;

CREATE VIRTUAL VIEW V383 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2 AND d+2
   AND c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V384 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       b-c
  FROM t1
 WHERE d>e
    OR c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V385 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       b-c
  FROM t1
 WHERE d>e
    OR c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1,5,2,3,4
;

CREATE VIRTUAL VIEW V386 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
    OR d>e
;

CREATE VIRTUAL VIEW V387 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
    OR d>e
 ORDER BY 4,2,5,1,3,7
;

CREATE VIRTUAL VIEW V388 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       b-c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
    OR d>e
;

CREATE VIRTUAL VIEW V389 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       b-c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
    OR d>e
 ORDER BY 1,6,2,4,5,7
;

CREATE VIRTUAL VIEW V390 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V391 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V392 AS SELECT a+b*2,
       b
  FROM t1
;

CREATE VIRTUAL VIEW V393 AS SELECT a+b*2,
       b
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V394 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V395 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V396 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V397 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V398 AS SELECT d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
;

CREATE VIRTUAL VIEW V399 AS SELECT d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
 ORDER BY 1
;

CREATE VIRTUAL VIEW V400 AS SELECT a+b*2,
       d,
       abs(b-c),
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V401 AS SELECT a+b*2,
       d,
       abs(b-c),
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 6,5,4,7,2
;

CREATE VIRTUAL VIEW V402 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       b,
       a+b*2,
       abs(a),
       a,
       a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V403 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       b,
       a+b*2,
       abs(a),
       a,
       a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,7,5,6,3,4,2
;

CREATE VIRTUAL VIEW V404 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       b,
       a+b*2,
       abs(a),
       a,
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V405 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       b,
       a+b*2,
       abs(a),
       a,
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
 ORDER BY 6,5
;

CREATE VIRTUAL VIEW V406 AS SELECT c,
       a+b*2,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
;

CREATE VIRTUAL VIEW V407 AS SELECT c,
       a+b*2,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V408 AS SELECT c,
       a+b*2,
       abs(b-c)
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V409 AS SELECT c,
       a+b*2,
       abs(b-c)
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V410 AS SELECT b-c,
       b
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
    OR d>e
;

CREATE VIRTUAL VIEW V411 AS SELECT b-c,
       b
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
    OR d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V412 AS SELECT b-c,
       b
  FROM t1
 WHERE (e>c OR e<d)
    OR d>e
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V413 AS SELECT b-c,
       b
  FROM t1
 WHERE (e>c OR e<d)
    OR d>e
    OR (e>a AND e<b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V414 AS SELECT b-c,
       b
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V415 AS SELECT b-c,
       b
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR (e>c OR e<d)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V416 AS SELECT (a+b+c+d+e)/5,
       b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V417 AS SELECT (a+b+c+d+e)/5,
       b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V418 AS SELECT abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       (a+b+c+d+e)/5,
       abs(b-c)
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V419 AS SELECT abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       (a+b+c+d+e)/5,
       abs(b-c)
  FROM t1
 WHERE c>d
 ORDER BY 3,4,5,2,1
;

CREATE VIRTUAL VIEW V420 AS SELECT a+b*2+c*3
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V421 AS SELECT a+b*2+c*3
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V422 AS SELECT (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V423 AS SELECT (a+b+c+d+e)/5
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V424 AS SELECT a+b*2+c*3+d*4,
       abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V425 AS SELECT a+b*2+c*3+d*4,
       abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V426 AS SELECT a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V427 AS SELECT a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V428 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V429 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V430 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V431 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V432 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V433 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,4,2
;

CREATE VIRTUAL VIEW V434 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d>e
;

CREATE VIRTUAL VIEW V435 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V436 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       b-c,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V437 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       b-c,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,3,4,1
;

CREATE VIRTUAL VIEW V438 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       b-c,
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c BETWEEN b-2 AND d+2
   AND b>c
;

CREATE VIRTUAL VIEW V439 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       b-c,
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c BETWEEN b-2 AND d+2
   AND b>c
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V440 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       b-c,
       d
  FROM t1
 WHERE b>c
   AND e+d BETWEEN a+b-10 AND c+130
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V441 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       b-c,
       d
  FROM t1
 WHERE b>c
   AND e+d BETWEEN a+b-10 AND c+130
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,4,1
;

CREATE VIRTUAL VIEW V442 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V443 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V444 AS SELECT c-d,
       a+b*2+c*3,
       d
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V445 AS SELECT c-d,
       a+b*2+c*3,
       d
  FROM t1
 WHERE a>b
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V446 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       b-c,
       c,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V447 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       b-c,
       c,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 4,3,5,1,2,7,6
;

CREATE VIRTUAL VIEW V448 AS SELECT a+b*2+c*3,
       a+b*2
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V449 AS SELECT a+b*2+c*3,
       a+b*2
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V450 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3,
       c,
       b,
       d-e,
       (a+b+c+d+e)/5,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V451 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3,
       c,
       b,
       d-e,
       (a+b+c+d+e)/5,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 1,2,4,6
;

CREATE VIRTUAL VIEW V452 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
   AND d>e
;

CREATE VIRTUAL VIEW V453 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
   AND d>e
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V454 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V455 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V456 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
   AND d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V457 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
   AND d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V458 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V459 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V460 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       a,
       abs(b-c),
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V461 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       a,
       abs(b-c),
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V462 AS SELECT a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       a-b,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V463 AS SELECT a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       a-b,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2 AND d+2
 ORDER BY 4,6,1,2,5,3
;

CREATE VIRTUAL VIEW V464 AS SELECT a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       a-b,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
;

CREATE VIRTUAL VIEW V465 AS SELECT a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       a-b,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
 ORDER BY 6,5,2,3
;

CREATE VIRTUAL VIEW V466 AS SELECT b-c,
       c-d,
       a+b*2+c*3+d*4+e*5,
       a,
       a+b*2+c*3,
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V467 AS SELECT b-c,
       c-d,
       a+b*2+c*3+d*4+e*5,
       a,
       a+b*2+c*3,
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR (a>b-2 AND a<b+2)
 ORDER BY 5,1,3
;

CREATE VIRTUAL VIEW V468 AS SELECT b-c,
       c-d,
       a+b*2+c*3+d*4+e*5,
       a,
       a+b*2+c*3,
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V469 AS SELECT b-c,
       c-d,
       a+b*2+c*3+d*4+e*5,
       a,
       a+b*2+c*3,
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
 ORDER BY 3,1,2,6,4
;

CREATE VIRTUAL VIEW V470 AS SELECT b-c,
       c-d,
       a+b*2+c*3+d*4+e*5,
       a,
       a+b*2+c*3,
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V471 AS SELECT b-c,
       c-d,
       a+b*2+c*3+d*4+e*5,
       a,
       a+b*2+c*3,
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
 ORDER BY 5,7,3
;

CREATE VIRTUAL VIEW V472 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       a,
       e,
       a+b*2,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V473 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       a,
       e,
       a+b*2,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
 ORDER BY 3,1,2,7
;

CREATE VIRTUAL VIEW V474 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       a,
       e,
       a+b*2,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V475 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       a,
       e,
       a+b*2,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 7,2,6,3,1,5
;

CREATE VIRTUAL VIEW V476 AS SELECT a+b*2+c*3,
       e,
       a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
;

CREATE VIRTUAL VIEW V477 AS SELECT a+b*2+c*3,
       e,
       a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V478 AS SELECT a+b*2+c*3,
       e,
       a-b
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V479 AS SELECT a+b*2+c*3,
       e,
       a-b
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V480 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIRTUAL VIEW V481 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 5,2,4
;

CREATE VIRTUAL VIEW V482 AS SELECT abs(b-c),
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V483 AS SELECT abs(b-c),
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,4,2
;

CREATE VIRTUAL VIEW V484 AS SELECT c
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V485 AS SELECT c
  FROM t1
 WHERE a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V486 AS SELECT a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V487 AS SELECT a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>a AND e<b)
 ORDER BY 5,4,3
;

CREATE VIRTUAL VIEW V488 AS SELECT a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V489 AS SELECT a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,2,4
;

CREATE VIRTUAL VIEW V490 AS SELECT b-c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V491 AS SELECT b-c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V492 AS SELECT b-c
  FROM t1
 WHERE (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V493 AS SELECT b-c
  FROM t1
 WHERE (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V494 AS SELECT a+b*2+c*3+d*4+e*5,
       e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V495 AS SELECT a+b*2+c*3+d*4+e*5,
       e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       d-e
  FROM t1
 ORDER BY 1,5,3
;

CREATE VIRTUAL VIEW V496 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       b-c
  FROM t1
;

CREATE VIRTUAL VIEW V497 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       b-c
  FROM t1
 ORDER BY 2,1,6,4
;

CREATE VIRTUAL VIEW V498 AS SELECT abs(a),
       a-b,
       c,
       abs(b-c)
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V499 AS SELECT abs(a),
       a-b,
       c,
       abs(b-c)
  FROM t1
 WHERE d>e
 ORDER BY 2,3,4
;

CREATE VIRTUAL VIEW V500 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V501 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V502 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V503 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V504 AS SELECT a,
       c,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V505 AS SELECT a,
       c,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V506 AS SELECT b,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V507 AS SELECT b,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE b>c
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V508 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V509 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
 ORDER BY 1
;

CREATE VIRTUAL VIEW V510 AS SELECT a+b*2+c*3+d*4,
       b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V511 AS SELECT a+b*2+c*3+d*4,
       b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V512 AS SELECT e,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIRTUAL VIEW V513 AS SELECT e,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V514 AS SELECT a+b*2+c*3+d*4,
       d,
       b,
       a,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V515 AS SELECT a+b*2+c*3+d*4,
       d,
       b,
       a,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 5,3,2,1,4
;

CREATE VIRTUAL VIEW V516 AS SELECT a+b*2+c*3+d*4,
       d,
       b,
       a,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V517 AS SELECT a+b*2+c*3+d*4,
       d,
       b,
       a,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 2,3,5,1
;

CREATE VIRTUAL VIEW V518 AS SELECT b-c
  FROM t1
;

CREATE VIRTUAL VIEW V519 AS SELECT b-c
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V520 AS SELECT (a+b+c+d+e)/5,
       b-c,
       a+b*2+c*3+d*4+e*5,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b
  FROM t1
;

CREATE VIRTUAL VIEW V521 AS SELECT (a+b+c+d+e)/5,
       b-c,
       a+b*2+c*3+d*4+e*5,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b
  FROM t1
 ORDER BY 5,1
;

CREATE VIRTUAL VIEW V522 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       d-e,
       a+b*2+c*3
  FROM t1
;

CREATE VIRTUAL VIEW V523 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       d-e,
       a+b*2+c*3
  FROM t1
 ORDER BY 3,6,2,1,4,5
;

CREATE VIRTUAL VIEW V524 AS SELECT abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V525 AS SELECT abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE c>d
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V526 AS SELECT c,
       abs(b-c),
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d-e,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V527 AS SELECT c,
       abs(b-c),
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d-e,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
 ORDER BY 6,2,3,4,7,1,5
;

CREATE VIRTUAL VIEW V528 AS SELECT a+b*2,
       c-d,
       d-e,
       abs(a),
       a-b,
       c,
       b
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V529 AS SELECT a+b*2,
       c-d,
       d-e,
       abs(a),
       a-b,
       c,
       b
  FROM t1
 WHERE a>b
 ORDER BY 1,6,2,5,3
;

CREATE VIRTUAL VIEW V530 AS SELECT abs(b-c),
       c,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a+b*2+c*3+d*4+e*5,
       a-b
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
    OR c>d
;

CREATE VIRTUAL VIEW V531 AS SELECT abs(b-c),
       c,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a+b*2+c*3+d*4+e*5,
       a-b
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
    OR c>d
 ORDER BY 2,7,6,5,4,1,3
;

CREATE VIRTUAL VIEW V532 AS SELECT abs(b-c),
       c,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a+b*2+c*3+d*4+e*5,
       a-b
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
    OR c>d
;

CREATE VIRTUAL VIEW V533 AS SELECT abs(b-c),
       c,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a+b*2+c*3+d*4+e*5,
       a-b
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
    OR c>d
 ORDER BY 6,3
;

CREATE VIRTUAL VIEW V534 AS SELECT d-e,
       e,
       a+b*2,
       a+b*2+c*3+d*4,
       abs(a),
       abs(b-c)
  FROM t1
 WHERE c>d
    OR d NOT BETWEEN 110 AND 150
    OR a>b
;

CREATE VIRTUAL VIEW V535 AS SELECT d-e,
       e,
       a+b*2,
       a+b*2+c*3+d*4,
       abs(a),
       abs(b-c)
  FROM t1
 WHERE c>d
    OR d NOT BETWEEN 110 AND 150
    OR a>b
 ORDER BY 1,3,6,4,2
;

CREATE VIRTUAL VIEW V536 AS SELECT d-e,
       e,
       a+b*2,
       a+b*2+c*3+d*4,
       abs(a),
       abs(b-c)
  FROM t1
 WHERE c>d
    OR a>b
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V537 AS SELECT d-e,
       e,
       a+b*2,
       a+b*2+c*3+d*4,
       abs(a),
       abs(b-c)
  FROM t1
 WHERE c>d
    OR a>b
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1,5,2
;

CREATE VIRTUAL VIEW V538 AS SELECT d-e,
       e,
       a+b*2,
       a+b*2+c*3+d*4,
       abs(a),
       abs(b-c)
  FROM t1
 WHERE a>b
    OR c>d
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V539 AS SELECT d-e,
       e,
       a+b*2,
       a+b*2+c*3+d*4,
       abs(a),
       abs(b-c)
  FROM t1
 WHERE a>b
    OR c>d
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 6,1
;

CREATE VIRTUAL VIEW V540 AS SELECT d-e
  FROM t1
 WHERE d>e
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V541 AS SELECT d-e
  FROM t1
 WHERE d>e
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V542 AS SELECT d-e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d>e
;

CREATE VIRTUAL VIEW V543 AS SELECT d-e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d>e
 ORDER BY 1
;

CREATE VIRTUAL VIEW V544 AS SELECT (a+b+c+d+e)/5,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V545 AS SELECT (a+b+c+d+e)/5,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V546 AS SELECT a-b
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND b>c
;

CREATE VIRTUAL VIEW V547 AS SELECT a-b
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND b>c
 ORDER BY 1
;

CREATE VIRTUAL VIEW V548 AS SELECT a-b
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
   AND d>e
;

CREATE VIRTUAL VIEW V549 AS SELECT a-b
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
   AND d>e
 ORDER BY 1
;

CREATE VIRTUAL VIEW V550 AS SELECT a-b
  FROM t1
 WHERE d>e
   AND b>c
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V551 AS SELECT a-b
  FROM t1
 WHERE d>e
   AND b>c
   AND (e>a AND e<b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V552 AS SELECT a-b
  FROM t1
 WHERE b>c
   AND d>e
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V553 AS SELECT a-b
  FROM t1
 WHERE b>c
   AND d>e
   AND (e>a AND e<b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V554 AS SELECT abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V555 AS SELECT abs(a)
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V556 AS SELECT a+b*2+c*3+d*4,
       d,
       a-b,
       abs(a),
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V557 AS SELECT a+b*2+c*3+d*4,
       d,
       a-b,
       abs(a),
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 3,2,4
;

CREATE VIRTUAL VIEW V558 AS SELECT abs(b-c),
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
   AND d>e
;

CREATE VIRTUAL VIEW V559 AS SELECT abs(b-c),
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
   AND d>e
 ORDER BY 2,4,5
;

CREATE VIRTUAL VIEW V560 AS SELECT abs(b-c),
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V561 AS SELECT abs(b-c),
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
 ORDER BY 5,1,2
;

CREATE VIRTUAL VIEW V562 AS SELECT abs(b-c),
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
   AND d>e
;

CREATE VIRTUAL VIEW V563 AS SELECT abs(b-c),
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
   AND d>e
 ORDER BY 2,4,3,5,1
;

CREATE VIRTUAL VIEW V564 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       c-d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V565 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       c-d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V566 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V567 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V568 AS SELECT b-c,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V569 AS SELECT b-c,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V570 AS SELECT b-c,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V571 AS SELECT b-c,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V572 AS SELECT b-c,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
   AND a>b
;

CREATE VIRTUAL VIEW V573 AS SELECT b-c,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
   AND a>b
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V574 AS SELECT b-c,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND a>b
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V575 AS SELECT b-c,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND a>b
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V576 AS SELECT c-d,
       abs(b-c),
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       d-e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V577 AS SELECT c-d,
       abs(b-c),
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       d-e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 3,1,4,2,5
;

CREATE VIRTUAL VIEW V578 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V579 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V580 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V581 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V582 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V583 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V584 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE c>d
   AND b>c
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V585 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE c>d
   AND b>c
   AND (e>c OR e<d)
 ORDER BY 1,2,4
;

CREATE VIRTUAL VIEW V586 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
   AND b>c
;

CREATE VIRTUAL VIEW V587 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
   AND b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V588 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE (e>c OR e<d)
   AND c>d
   AND b>c
;

CREATE VIRTUAL VIEW V589 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE (e>c OR e<d)
   AND c>d
   AND b>c
 ORDER BY 1,3,2,4
;

CREATE VIRTUAL VIEW V590 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
   AND c>d
;

CREATE VIRTUAL VIEW V591 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
   AND c>d
 ORDER BY 2,3,1,4
;

CREATE VIRTUAL VIEW V592 AS SELECT a+b*2+c*3+d*4+e*5,
       b,
       e
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V593 AS SELECT a+b*2+c*3+d*4+e*5,
       b,
       e
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V594 AS SELECT a+b*2+c*3+d*4+e*5,
       b,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
;

CREATE VIRTUAL VIEW V595 AS SELECT a+b*2+c*3+d*4+e*5,
       b,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V596 AS SELECT abs(a),
       c,
       c-d,
       a-b,
       abs(b-c)
  FROM t1
;

CREATE VIRTUAL VIEW V597 AS SELECT abs(a),
       c,
       c-d,
       a-b,
       abs(b-c)
  FROM t1
 ORDER BY 3,2,4
;

CREATE VIRTUAL VIEW V598 AS SELECT a+b*2+c*3,
       e,
       a+b*2,
       b-c
  FROM t1
;

CREATE VIRTUAL VIEW V599 AS SELECT a+b*2+c*3,
       e,
       a+b*2,
       b-c
  FROM t1
 ORDER BY 2,4,3
;

CREATE VIRTUAL VIEW V600 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
;

CREATE VIRTUAL VIEW V601 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
 ORDER BY 3,1,2,4
;

CREATE VIRTUAL VIEW V602 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V603 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
    OR (e>a AND e<b)
 ORDER BY 2,3,1,4
;

CREATE VIRTUAL VIEW V604 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       d,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       e,
       a-b
  FROM t1
;

CREATE VIRTUAL VIEW V605 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       d,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       e,
       a-b
  FROM t1
 ORDER BY 1,5,6,7
;

CREATE VIRTUAL VIEW V606 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V607 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V608 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       e,
       abs(b-c),
       c,
       a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
;

CREATE VIRTUAL VIEW V609 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       e,
       abs(b-c),
       c,
       a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
 ORDER BY 7,5
;

CREATE VIRTUAL VIEW V610 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       e,
       abs(b-c),
       c,
       a-b
  FROM t1
 WHERE c>d
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V611 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       e,
       abs(b-c),
       c,
       a-b
  FROM t1
 WHERE c>d
   AND c BETWEEN b-2 AND d+2
 ORDER BY 4,6,2,7
;

CREATE VIRTUAL VIEW V612 AS SELECT b,
       b-c,
       e,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V613 AS SELECT b,
       b-c,
       e,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c>d
 ORDER BY 6,1,5
;

CREATE VIRTUAL VIEW V614 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V615 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
   AND (a>b-2 AND a<b+2)
 ORDER BY 4,1,5,6,3
;

CREATE VIRTUAL VIEW V616 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V617 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 4,1,2
;

CREATE VIRTUAL VIEW V618 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V619 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V620 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V621 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 2,5
;

CREATE VIRTUAL VIEW V622 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V623 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V624 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V625 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V626 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V627 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V628 AS SELECT a+b*2+c*3+d*4,
       b-c,
       d-e,
       (a+b+c+d+e)/5,
       c-d,
       a+b*2,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V629 AS SELECT a+b*2+c*3+d*4,
       b-c,
       d-e,
       (a+b+c+d+e)/5,
       c-d,
       a+b*2,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,4,7,5,2,3,6
;

CREATE VIRTUAL VIEW V630 AS SELECT b,
       a+b*2+c*3+d*4,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V631 AS SELECT b,
       a+b*2+c*3+d*4,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>a AND e<b)
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V632 AS SELECT b,
       a+b*2+c*3+d*4,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V633 AS SELECT b,
       a+b*2+c*3+d*4,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V634 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       e
  FROM t1
;

CREATE VIRTUAL VIEW V635 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       e
  FROM t1
 ORDER BY 4,5
;

CREATE VIRTUAL VIEW V636 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
    OR a>b
;

CREATE VIRTUAL VIEW V637 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
    OR a>b
 ORDER BY 4,2,1,3,5
;

CREATE VIRTUAL VIEW V638 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
    OR b>c
;

CREATE VIRTUAL VIEW V639 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
    OR b>c
 ORDER BY 4,1,5,6,2,3
;

CREATE VIRTUAL VIEW V640 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e
  FROM t1
 WHERE b>c
    OR a>b
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V641 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e
  FROM t1
 WHERE b>c
    OR a>b
    OR (a>b-2 AND a<b+2)
 ORDER BY 1,6,5
;

CREATE VIRTUAL VIEW V642 AS SELECT e,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V643 AS SELECT e,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,5,4,1,3
;

CREATE VIRTUAL VIEW V644 AS SELECT a,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V645 AS SELECT a,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,3,4,2
;

CREATE VIRTUAL VIEW V646 AS SELECT a,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V647 AS SELECT a,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
 ORDER BY 4,1
;

CREATE VIRTUAL VIEW V648 AS SELECT a,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V649 AS SELECT a,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,6,4,2,5,3
;

CREATE VIRTUAL VIEW V650 AS SELECT a,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e
  FROM t1
 WHERE (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V651 AS SELECT a,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e
  FROM t1
 WHERE (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 5,1,2,6,4,3
;

CREATE VIRTUAL VIEW V652 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a
  FROM t1
 WHERE d>e
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V653 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a
  FROM t1
 WHERE d>e
   AND (e>a AND e<b)
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V654 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
;

CREATE VIRTUAL VIEW V655 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V656 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
 WHERE (e>c OR e<d)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V657 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
 WHERE (e>c OR e<d)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 4,5,2
;

CREATE VIRTUAL VIEW V658 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V659 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V660 AS SELECT c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V661 AS SELECT c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V662 AS SELECT a,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V663 AS SELECT a,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V664 AS SELECT a+b*2+c*3+d*4+e*5,
       a,
       abs(b-c),
       c,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V665 AS SELECT a+b*2+c*3+d*4+e*5,
       a,
       abs(b-c),
       c,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 3,6,4,7,1
;

CREATE VIRTUAL VIEW V666 AS SELECT c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V667 AS SELECT c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 5,2
;

CREATE VIRTUAL VIEW V668 AS SELECT a+b*2+c*3
  FROM t1
;

CREATE VIRTUAL VIEW V669 AS SELECT a+b*2+c*3
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V670 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d
  FROM t1
;

CREATE VIRTUAL VIEW V671 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d
  FROM t1
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V672 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       d-e,
       a+b*2+c*3+d*4,
       c
  FROM t1
 WHERE c>d
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V673 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       d-e,
       a+b*2+c*3+d*4,
       c
  FROM t1
 WHERE c>d
    OR c BETWEEN b-2 AND d+2
 ORDER BY 5,7
;

CREATE VIRTUAL VIEW V674 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e
  FROM t1
;

CREATE VIRTUAL VIEW V675 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e
  FROM t1
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V676 AS SELECT d
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V677 AS SELECT d
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V678 AS SELECT a-b,
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V679 AS SELECT a-b,
       d-e
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V680 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V681 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V682 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V683 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V684 AS SELECT a+b*2,
       b-c,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V685 AS SELECT a+b*2,
       b-c,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,4,1
;

CREATE VIRTUAL VIEW V686 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       e,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V687 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       e,
       abs(a)
  FROM t1
 ORDER BY 4,2
;

CREATE VIRTUAL VIEW V688 AS SELECT c,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       a-b,
       a+b*2+c*3
  FROM t1
 WHERE c>d
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V689 AS SELECT c,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       a-b,
       a+b*2+c*3
  FROM t1
 WHERE c>d
    OR (e>c OR e<d)
 ORDER BY 1,2,6,5
;

CREATE VIRTUAL VIEW V690 AS SELECT c,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       a-b,
       a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
    OR c>d
;

CREATE VIRTUAL VIEW V691 AS SELECT c,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       a-b,
       a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
    OR c>d
 ORDER BY 5,3,6,1
;

CREATE VIRTUAL VIEW V692 AS SELECT d-e
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V693 AS SELECT d-e
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V694 AS SELECT d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR b>c
;

CREATE VIRTUAL VIEW V695 AS SELECT d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR b>c
 ORDER BY 1
;

CREATE VIRTUAL VIEW V696 AS SELECT c-d,
       abs(a),
       b-c,
       b,
       a+b*2+c*3+d*4,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V697 AS SELECT c-d,
       abs(a),
       b-c,
       b,
       a+b*2+c*3+d*4,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 4,3,6,5,2,1
;

CREATE VIRTUAL VIEW V698 AS SELECT c-d,
       abs(a),
       b-c,
       b,
       a+b*2+c*3+d*4,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
;

CREATE VIRTUAL VIEW V699 AS SELECT c-d,
       abs(a),
       b-c,
       b,
       a+b*2+c*3+d*4,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
 ORDER BY 3,4,5
;

CREATE VIRTUAL VIEW V700 AS SELECT c-d,
       abs(a),
       b-c,
       b,
       a+b*2+c*3+d*4,
       c
  FROM t1
 WHERE d>e
   AND (c<=d-2 OR c>=d+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V701 AS SELECT c-d,
       abs(a),
       b-c,
       b,
       a+b*2+c*3+d*4,
       c
  FROM t1
 WHERE d>e
   AND (c<=d-2 OR c>=d+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 6,1
;

CREATE VIRTUAL VIEW V702 AS SELECT abs(b-c),
       d,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V703 AS SELECT abs(b-c),
       d,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 2,5,1,4,3
;

CREATE VIRTUAL VIEW V704 AS SELECT c-d,
       a+b*2+c*3+d*4+e*5,
       c,
       abs(b-c),
       e,
       d,
       d-e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
;

CREATE VIRTUAL VIEW V705 AS SELECT c-d,
       a+b*2+c*3+d*4+e*5,
       c,
       abs(b-c),
       e,
       d,
       d-e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
 ORDER BY 3,4,5,2
;

CREATE VIRTUAL VIEW V706 AS SELECT (a+b+c+d+e)/5,
       d-e,
       a-b,
       abs(a),
       b,
       b-c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V707 AS SELECT (a+b+c+d+e)/5,
       d-e,
       a-b,
       abs(a),
       b,
       b-c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 4,6,1,5,2
;

CREATE VIRTUAL VIEW V708 AS SELECT (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V709 AS SELECT (a+b+c+d+e)/5
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V710 AS SELECT d,
       c-d,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b
  FROM t1
;

CREATE VIRTUAL VIEW V711 AS SELECT d,
       c-d,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b
  FROM t1
 ORDER BY 2,5,3,1,4
;

CREATE VIRTUAL VIEW V712 AS SELECT abs(a),
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
;

CREATE VIRTUAL VIEW V713 AS SELECT abs(a),
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V714 AS SELECT abs(a),
       abs(b-c)
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V715 AS SELECT abs(a),
       abs(b-c)
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V716 AS SELECT e,
       c,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V717 AS SELECT e,
       c,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V718 AS SELECT c,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V719 AS SELECT c,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V720 AS SELECT c-d,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V721 AS SELECT c-d,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V722 AS SELECT b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a,
       abs(a),
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V723 AS SELECT b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a,
       abs(a),
       d-e
  FROM t1
 ORDER BY 5,4,2,7,3
;

CREATE VIRTUAL VIEW V724 AS SELECT a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V725 AS SELECT a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V726 AS SELECT abs(b-c),
       b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V727 AS SELECT abs(b-c),
       b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V728 AS SELECT abs(b-c),
       b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V729 AS SELECT abs(b-c),
       b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V730 AS SELECT abs(b-c),
       b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V731 AS SELECT abs(b-c),
       b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V732 AS SELECT abs(b-c),
       b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V733 AS SELECT abs(b-c),
       b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V734 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V735 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V736 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V737 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,3,4
;

CREATE VIRTUAL VIEW V738 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V739 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,4
;

CREATE VIRTUAL VIEW V740 AS SELECT abs(a),
       a-b,
       d,
       a+b*2,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V741 AS SELECT abs(a),
       a-b,
       d,
       a+b*2,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1,3,2,4
;

CREATE VIRTUAL VIEW V742 AS SELECT d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V743 AS SELECT d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE b>c
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V744 AS SELECT e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       c-d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
;

CREATE VIRTUAL VIEW V745 AS SELECT e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       c-d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
 ORDER BY 4,1,3,2,5
;

CREATE VIRTUAL VIEW V746 AS SELECT a,
       d-e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       b-c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V747 AS SELECT a,
       d-e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       b-c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 3,2,5,1
;

CREATE VIRTUAL VIEW V748 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       a-b,
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V749 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       a-b,
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,7
;

CREATE VIRTUAL VIEW V750 AS SELECT b,
       a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c>d
;

CREATE VIRTUAL VIEW V751 AS SELECT b,
       a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V752 AS SELECT b,
       a+b*2
  FROM t1
 WHERE c>d
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V753 AS SELECT b,
       a+b*2
  FROM t1
 WHERE c>d
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V754 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V755 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 3,1,4,2
;

CREATE VIRTUAL VIEW V756 AS SELECT b-c,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V757 AS SELECT b-c,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 5,3,4,1
;

CREATE VIRTUAL VIEW V758 AS SELECT b-c,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V759 AS SELECT b-c,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 6,4,1
;

CREATE VIRTUAL VIEW V760 AS SELECT a,
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR a>b
;

CREATE VIRTUAL VIEW V761 AS SELECT a,
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V762 AS SELECT a,
       b
  FROM t1
 WHERE a>b
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V763 AS SELECT a,
       b
  FROM t1
 WHERE a>b
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V764 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V765 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V766 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V767 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V768 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V769 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V770 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V771 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V772 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE a>b
   AND d>e
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V773 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE a>b
   AND d>e
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V774 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
   AND a>b
;

CREATE VIRTUAL VIEW V775 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
   AND a>b
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V776 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE d>e
   AND a>b
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V777 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE d>e
   AND a>b
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V778 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V779 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V780 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V781 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V782 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       e,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V783 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       e,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 4,1
;

CREATE VIRTUAL VIEW V784 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V785 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V786 AS SELECT abs(a),
       c,
       a+b*2+c*3,
       d,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V787 AS SELECT abs(a),
       c,
       a+b*2+c*3,
       d,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
 ORDER BY 6,2,7,3,5,1
;

CREATE VIRTUAL VIEW V788 AS SELECT c-d
  FROM t1
;

CREATE VIRTUAL VIEW V789 AS SELECT c-d
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V790 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       b,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V791 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       b,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 2,3,4,1
;

CREATE VIRTUAL VIEW V792 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
;

CREATE VIRTUAL VIEW V793 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V794 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V795 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V796 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V797 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V798 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
   AND b>c
;

CREATE VIRTUAL VIEW V799 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
   AND b>c
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V800 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b>c
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V801 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b>c
   AND (e>c OR e<d)
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V802 AS SELECT abs(b-c),
       d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>a AND e<b)
    OR (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V803 AS SELECT abs(b-c),
       d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>a AND e<b)
    OR (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 3,1,4,5
;

CREATE VIRTUAL VIEW V804 AS SELECT abs(b-c),
       d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V805 AS SELECT abs(b-c),
       d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
 ORDER BY 5,1,2,3
;

CREATE VIRTUAL VIEW V806 AS SELECT abs(b-c),
       d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V807 AS SELECT abs(b-c),
       d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
    OR (e>a AND e<b)
 ORDER BY 5,3,1
;

CREATE VIRTUAL VIEW V808 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       c-d
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V809 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       c-d
  FROM t1
 WHERE b>c
 ORDER BY 1,3,5,6,4
;

CREATE VIRTUAL VIEW V810 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       e,
       d-e,
       c-d,
       a
  FROM t1
 WHERE (e>a AND e<b)
   AND a>b
   AND d>e
;

CREATE VIRTUAL VIEW V811 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       e,
       d-e,
       c-d,
       a
  FROM t1
 WHERE (e>a AND e<b)
   AND a>b
   AND d>e
 ORDER BY 6,3
;

CREATE VIRTUAL VIEW V812 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       e,
       d-e,
       c-d,
       a
  FROM t1
 WHERE a>b
   AND d>e
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V813 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       e,
       d-e,
       c-d,
       a
  FROM t1
 WHERE a>b
   AND d>e
   AND (e>a AND e<b)
 ORDER BY 6,5
;

CREATE VIRTUAL VIEW V814 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       c,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
;

CREATE VIRTUAL VIEW V815 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       c,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
 ORDER BY 2,4
;

CREATE VIRTUAL VIEW V816 AS SELECT abs(a),
       a+b*2+c*3,
       a+b*2,
       e,
       b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V817 AS SELECT abs(a),
       a+b*2+c*3,
       a+b*2,
       e,
       b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 5,4,1,2,3
;

CREATE VIRTUAL VIEW V818 AS SELECT a-b,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V819 AS SELECT a-b,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 5,2,4
;

CREATE VIRTUAL VIEW V820 AS SELECT a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V821 AS SELECT a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V822 AS SELECT a+b*2,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V823 AS SELECT a+b*2,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,2,3,4
;

CREATE VIRTUAL VIEW V824 AS SELECT a+b*2,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b>c
;

CREATE VIRTUAL VIEW V825 AS SELECT a+b*2,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b>c
 ORDER BY 3,2,4
;

CREATE VIRTUAL VIEW V826 AS SELECT b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V827 AS SELECT b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V828 AS SELECT b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V829 AS SELECT b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V830 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
    OR c>d
    OR d>e
;

CREATE VIRTUAL VIEW V831 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
    OR c>d
    OR d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V832 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
    OR c>d
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V833 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
    OR c>d
    OR (e>c OR e<d)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V834 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
    OR (e>c OR e<d)
    OR c>d
;

CREATE VIRTUAL VIEW V835 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
    OR (e>c OR e<d)
    OR c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V836 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       abs(b-c),
       b
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V837 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       abs(b-c),
       b
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,1,5,2,3
;

CREATE VIRTUAL VIEW V838 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       abs(b-c),
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
;

CREATE VIRTUAL VIEW V839 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       abs(b-c),
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
 ORDER BY 5,4,3,1,2
;

CREATE VIRTUAL VIEW V840 AS SELECT a+b*2+c*3,
       d,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V841 AS SELECT a+b*2+c*3,
       d,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 4,3,1,2
;

CREATE VIRTUAL VIEW V842 AS SELECT b,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       abs(b-c),
       c-d
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V843 AS SELECT b,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       abs(b-c),
       c-d
  FROM t1
 WHERE a>b
 ORDER BY 3,4,7,5,2,1,6
;

CREATE VIRTUAL VIEW V844 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V845 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a>b
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V846 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       d-e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V847 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       d-e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
 ORDER BY 1,4
;

CREATE VIRTUAL VIEW V848 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V849 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1,5,4,2,3
;

CREATE VIRTUAL VIEW V850 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       c,
       abs(a),
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIRTUAL VIEW V851 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       c,
       abs(a),
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 3,2,5,4,1,6
;

CREATE VIRTUAL VIEW V852 AS SELECT e,
       a+b*2+c*3,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V853 AS SELECT e,
       a+b*2+c*3,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,4,3
;

CREATE VIRTUAL VIEW V854 AS SELECT e,
       a+b*2+c*3,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
;

CREATE VIRTUAL VIEW V855 AS SELECT e,
       a+b*2+c*3,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
 ORDER BY 4,2
;

CREATE VIRTUAL VIEW V856 AS SELECT e,
       a+b*2+c*3,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V857 AS SELECT e,
       a+b*2+c*3,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,1
;

CREATE VIRTUAL VIEW V858 AS SELECT e,
       a+b*2+c*3,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V859 AS SELECT e,
       a+b*2+c*3,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,4,1
;

CREATE VIRTUAL VIEW V860 AS SELECT e,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V861 AS SELECT e,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,1,4,2
;

CREATE VIRTUAL VIEW V862 AS SELECT e,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       b-c
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V863 AS SELECT e,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       b-c
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 5,4,3,1,2
;

CREATE VIRTUAL VIEW V864 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V865 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 4,1,5,3
;

CREATE VIRTUAL VIEW V866 AS SELECT d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V867 AS SELECT d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V868 AS SELECT d
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V869 AS SELECT d
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V870 AS SELECT c,
       (a+b+c+d+e)/5,
       e,
       d-e,
       a+b*2,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND c>d
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V871 AS SELECT c,
       (a+b+c+d+e)/5,
       e,
       d-e,
       a+b*2,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND c>d
   AND (e>a AND e<b)
 ORDER BY 3,4,6,7,1
;

CREATE VIRTUAL VIEW V872 AS SELECT c,
       (a+b+c+d+e)/5,
       e,
       d-e,
       a+b*2,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND c>d
;

CREATE VIRTUAL VIEW V873 AS SELECT c,
       (a+b+c+d+e)/5,
       e,
       d-e,
       a+b*2,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND c>d
 ORDER BY 6,3,4
;

CREATE VIRTUAL VIEW V874 AS SELECT c,
       (a+b+c+d+e)/5,
       e,
       d-e,
       a+b*2,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
   AND c>d
   AND d>e
;

CREATE VIRTUAL VIEW V875 AS SELECT c,
       (a+b+c+d+e)/5,
       e,
       d-e,
       a+b*2,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
   AND c>d
   AND d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V876 AS SELECT c,
       (a+b+c+d+e)/5,
       e,
       d-e,
       a+b*2,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND (e>a AND e<b)
   AND c>d
;

CREATE VIRTUAL VIEW V877 AS SELECT c,
       (a+b+c+d+e)/5,
       e,
       d-e,
       a+b*2,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND (e>a AND e<b)
   AND c>d
 ORDER BY 5,1,6,2,3
;

CREATE VIRTUAL VIEW V878 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V879 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V880 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
    OR c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V881 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
    OR c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V882 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V883 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V884 AS SELECT e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V885 AS SELECT e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V886 AS SELECT a,
       b-c,
       (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V887 AS SELECT a,
       b-c,
       (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 1,4,2
;

CREATE VIRTUAL VIEW V888 AS SELECT a,
       c-d,
       abs(b-c),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V889 AS SELECT a,
       c-d,
       abs(b-c),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
 ORDER BY 1,2,5
;

CREATE VIRTUAL VIEW V890 AS SELECT a,
       c-d,
       abs(b-c),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V891 AS SELECT a,
       c-d,
       abs(b-c),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V892 AS SELECT a,
       c-d,
       abs(b-c),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V893 AS SELECT a,
       c-d,
       abs(b-c),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V894 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       c-d,
       b,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V895 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       c-d,
       b,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 5,2
;

CREATE VIRTUAL VIEW V896 AS SELECT a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V897 AS SELECT a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V898 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       d,
       a-b
  FROM t1
;

CREATE VIRTUAL VIEW V899 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       d,
       a-b
  FROM t1
 ORDER BY 3,7,4,2,1
;

CREATE VIRTUAL VIEW V900 AS SELECT c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V901 AS SELECT c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3
  FROM t1
 WHERE a>b
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V902 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       a+b*2,
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V903 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       a+b*2,
       d-e
  FROM t1
 ORDER BY 1,2,3,4
;

CREATE VIRTUAL VIEW V904 AS SELECT c-d,
       d,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIRTUAL VIEW V905 AS SELECT c-d,
       d,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 5,1,4
;

CREATE VIRTUAL VIEW V906 AS SELECT d,
       (a+b+c+d+e)/5,
       d-e,
       b-c,
       b,
       a+b*2+c*3+d*4+e*5,
       a+b*2
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
;

CREATE VIRTUAL VIEW V907 AS SELECT d,
       (a+b+c+d+e)/5,
       d-e,
       b-c,
       b,
       a+b*2+c*3+d*4+e*5,
       a+b*2
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
 ORDER BY 1,5,2,3,4,6,7
;

CREATE VIRTUAL VIEW V908 AS SELECT d,
       (a+b+c+d+e)/5,
       d-e,
       b-c,
       b,
       a+b*2+c*3+d*4+e*5,
       a+b*2
  FROM t1
 WHERE c>d
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V909 AS SELECT d,
       (a+b+c+d+e)/5,
       d-e,
       b-c,
       b,
       a+b*2+c*3+d*4+e*5,
       a+b*2
  FROM t1
 WHERE c>d
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,7,5,1,4,6,3
;

CREATE VIRTUAL VIEW V910 AS SELECT a+b*2,
       b,
       abs(b-c),
       d-e,
       a,
       c-d
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V911 AS SELECT a+b*2,
       b,
       abs(b-c),
       d-e,
       a,
       c-d
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,3,5
;

CREATE VIRTUAL VIEW V912 AS SELECT a+b*2,
       b,
       abs(b-c),
       d-e,
       a,
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
;

CREATE VIRTUAL VIEW V913 AS SELECT a+b*2,
       b,
       abs(b-c),
       d-e,
       a,
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
 ORDER BY 2,6,5,1,3,4
;

CREATE VIRTUAL VIEW V914 AS SELECT d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V915 AS SELECT d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V916 AS SELECT d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V917 AS SELECT d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V918 AS SELECT d-e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V919 AS SELECT d-e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V920 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a),
       d,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c
  FROM t1
;

CREATE VIRTUAL VIEW V921 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a),
       d,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c
  FROM t1
 ORDER BY 5,1,4,3,6
;

CREATE VIRTUAL VIEW V922 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       a+b*2+c*3+d*4+e*5,
       a-b
  FROM t1
;

CREATE VIRTUAL VIEW V923 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       a+b*2+c*3+d*4+e*5,
       a-b
  FROM t1
 ORDER BY 3,5
;

CREATE VIRTUAL VIEW V924 AS SELECT abs(a),
       b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V925 AS SELECT abs(a),
       b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
    OR (e>a AND e<b)
 ORDER BY 7,2
;

CREATE VIRTUAL VIEW V926 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       a+b*2+c*3,
       b-c,
       (a+b+c+d+e)/5,
       abs(b-c),
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a>b
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V927 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       a+b*2+c*3,
       b-c,
       (a+b+c+d+e)/5,
       abs(b-c),
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a>b
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,5,6
;

CREATE VIRTUAL VIEW V928 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       a+b*2+c*3,
       b-c,
       (a+b+c+d+e)/5,
       abs(b-c),
       c
  FROM t1
 WHERE a>b
   AND (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V929 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       a+b*2+c*3,
       b-c,
       (a+b+c+d+e)/5,
       abs(b-c),
       c
  FROM t1
 WHERE a>b
   AND (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 6,4,7,5
;

CREATE VIRTUAL VIEW V930 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       a+b*2+c*3,
       b-c,
       (a+b+c+d+e)/5,
       abs(b-c),
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
   AND a>b
;

CREATE VIRTUAL VIEW V931 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       a+b*2+c*3,
       b-c,
       (a+b+c+d+e)/5,
       abs(b-c),
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
   AND a>b
 ORDER BY 1,3,4,5,6,2,7
;

CREATE VIRTUAL VIEW V932 AS SELECT b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V933 AS SELECT b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a)
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V934 AS SELECT b-c,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V935 AS SELECT b-c,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e
  FROM t1
 ORDER BY 2,7,3,4,1,5,6
;

CREATE VIRTUAL VIEW V936 AS SELECT a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       abs(a),
       b
  FROM t1
;

CREATE VIRTUAL VIEW V937 AS SELECT a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       abs(a),
       b
  FROM t1
 ORDER BY 4,1,3,2,5
;

CREATE VIRTUAL VIEW V938 AS SELECT b,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIRTUAL VIEW V939 AS SELECT b,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 2,5,4,1,3
;

CREATE VIRTUAL VIEW V940 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
   AND (a>b-2 AND a<b+2)
   AND d>e
;

CREATE VIRTUAL VIEW V941 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
   AND (a>b-2 AND a<b+2)
   AND d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V942 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND c>d
;

CREATE VIRTUAL VIEW V943 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V944 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
   AND d>e
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V945 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
   AND d>e
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V946 AS SELECT e,
       (a+b+c+d+e)/5,
       abs(a),
       c-d,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V947 AS SELECT e,
       (a+b+c+d+e)/5,
       abs(a),
       c-d,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 3,4,2,5,1
;

CREATE VIRTUAL VIEW V948 AS SELECT d,
       a+b*2+c*3,
       c,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIRTUAL VIEW V949 AS SELECT d,
       a+b*2+c*3,
       c,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 3,2,5,4
;

CREATE VIRTUAL VIEW V950 AS SELECT c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V951 AS SELECT c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V952 AS SELECT d,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       e,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V953 AS SELECT d,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       e,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 7,5,4,6,1
;

CREATE VIRTUAL VIEW V954 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
    OR b>c
;

CREATE VIRTUAL VIEW V955 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
    OR b>c
 ORDER BY 4,2,3,1
;

CREATE VIRTUAL VIEW V956 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V957 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V958 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
    OR b>c
;

CREATE VIRTUAL VIEW V959 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
    OR b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V960 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V961 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 4,3
;

CREATE VIRTUAL VIEW V962 AS SELECT e,
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
;

CREATE VIRTUAL VIEW V963 AS SELECT e,
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V964 AS SELECT e,
       a-b
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V965 AS SELECT e,
       a-b
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V966 AS SELECT c,
       d-e,
       abs(a),
       e
  FROM t1
;

CREATE VIRTUAL VIEW V967 AS SELECT c,
       d-e,
       abs(a),
       e
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V968 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V969 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
 ORDER BY 4,3
;

CREATE VIRTUAL VIEW V970 AS SELECT a-b,
       abs(a),
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V971 AS SELECT a-b,
       abs(a),
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 4,3,1,2,6
;

CREATE VIRTUAL VIEW V972 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V973 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V974 AS SELECT c-d,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V975 AS SELECT c-d,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 ORDER BY 4,2,1
;

CREATE VIRTUAL VIEW V976 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       b,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND (e>a AND e<b)
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V977 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       b,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND (e>a AND e<b)
   AND (e>c OR e<d)
 ORDER BY 5,1,4
;

CREATE VIRTUAL VIEW V978 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       b,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V979 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       b,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND (e>a AND e<b)
 ORDER BY 2,5,1,3
;

CREATE VIRTUAL VIEW V980 AS SELECT b,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V981 AS SELECT b,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       abs(a)
  FROM t1
 ORDER BY 1,2,4,3
;

CREATE VIRTUAL VIEW V982 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       d-e,
       a+b*2
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V983 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       d-e,
       a+b*2
  FROM t1
 WHERE c>d
 ORDER BY 4,5,6,3,2,1
;

CREATE VIRTUAL VIEW V984 AS SELECT a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIRTUAL VIEW V985 AS SELECT a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 4,2,3
;

CREATE VIRTUAL VIEW V986 AS SELECT a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       a+b*2+c*3
  FROM t1
;

CREATE VIRTUAL VIEW V987 AS SELECT a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       a+b*2+c*3
  FROM t1
 ORDER BY 6,1
;

CREATE VIRTUAL VIEW V988 AS SELECT a-b,
       a+b*2,
       c
  FROM t1
;

CREATE VIRTUAL VIEW V989 AS SELECT a-b,
       a+b*2,
       c
  FROM t1
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V990 AS SELECT d-e,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
;

CREATE VIRTUAL VIEW V991 AS SELECT d-e,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V992 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE b>c
   AND d>e
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V993 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE b>c
   AND d>e
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V994 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND d>e
   AND b>c
;

CREATE VIRTUAL VIEW V995 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND d>e
   AND b>c
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V996 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE b>c
   AND d NOT BETWEEN 110 AND 150
   AND d>e
;

CREATE VIRTUAL VIEW V997 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE b>c
   AND d NOT BETWEEN 110 AND 150
   AND d>e
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V998 AS SELECT a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V999 AS SELECT a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1000 AS SELECT a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1001 AS SELECT a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1002 AS SELECT a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1003 AS SELECT a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1004 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       abs(a),
       a-b,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
    OR b>c
;

CREATE VIRTUAL VIEW V1005 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       abs(a),
       a-b,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
    OR b>c
 ORDER BY 5,3,4,1
;

CREATE VIRTUAL VIEW V1006 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       abs(a),
       a-b,
       e
  FROM t1
 WHERE b>c
    OR e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1007 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       abs(a),
       a-b,
       e
  FROM t1
 WHERE b>c
    OR e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 2,6,5,1,3,4
;

CREATE VIRTUAL VIEW V1008 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       abs(a),
       a-b,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR b>c
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1009 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       abs(a),
       a-b,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR b>c
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 5,6,1
;

CREATE VIRTUAL VIEW V1010 AS SELECT (a+b+c+d+e)/5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c>d
;

CREATE VIRTUAL VIEW V1011 AS SELECT (a+b+c+d+e)/5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c>d
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V1012 AS SELECT (a+b+c+d+e)/5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 WHERE c>d
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1013 AS SELECT (a+b+c+d+e)/5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 WHERE c>d
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,4
;

CREATE VIRTUAL VIEW V1014 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1015 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND (e>a AND e<b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1016 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
   AND c>d
;

CREATE VIRTUAL VIEW V1017 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
   AND c>d
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1018 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
   AND c>d
;

CREATE VIRTUAL VIEW V1019 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
   AND c>d
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1020 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1021 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1022 AS SELECT abs(b-c),
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1023 AS SELECT abs(b-c),
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 5,3,2,4,1
;

CREATE VIRTUAL VIEW V1024 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND b>c
;

CREATE VIRTUAL VIEW V1025 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND b>c
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V1026 AS SELECT a+b*2+c*3+d*4,
       a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1027 AS SELECT a+b*2+c*3+d*4,
       a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1028 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
    OR c>d
;

CREATE VIRTUAL VIEW V1029 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
    OR c>d
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V1030 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
    OR (e>c OR e<d)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1031 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
    OR (e>c OR e<d)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V1032 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V1033 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1034 AS SELECT a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIRTUAL VIEW V1035 AS SELECT a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1036 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V1037 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
 ORDER BY 5,1,3
;

CREATE VIRTUAL VIEW V1038 AS SELECT d,
       a+b*2+c*3,
       a,
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR c>d
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1039 AS SELECT d,
       a+b*2+c*3,
       a,
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR c>d
    OR (e>a AND e<b)
 ORDER BY 4,2,3,1
;

CREATE VIRTUAL VIEW V1040 AS SELECT d,
       a+b*2+c*3,
       a,
       e
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1041 AS SELECT d,
       a+b*2+c*3,
       a,
       e
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
    OR c BETWEEN b-2 AND d+2
 ORDER BY 2,1,4,3
;

CREATE VIRTUAL VIEW V1042 AS SELECT d,
       a+b*2+c*3,
       a,
       e
  FROM t1
 WHERE c>d
    OR (e>a AND e<b)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1043 AS SELECT d,
       a+b*2+c*3,
       a,
       e
  FROM t1
 WHERE c>d
    OR (e>a AND e<b)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V1044 AS SELECT d,
       a+b*2+c*3,
       a,
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>a AND e<b)
    OR c>d
;

CREATE VIRTUAL VIEW V1045 AS SELECT d,
       a+b*2+c*3,
       a,
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>a AND e<b)
    OR c>d
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V1046 AS SELECT b-c,
       b,
       d-e,
       (a+b+c+d+e)/5,
       c
  FROM t1
;

CREATE VIRTUAL VIEW V1047 AS SELECT b-c,
       b,
       d-e,
       (a+b+c+d+e)/5,
       c
  FROM t1
 ORDER BY 5,1,2
;

CREATE VIRTUAL VIEW V1048 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V1049 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1050 AS SELECT a+b*2
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V1051 AS SELECT a+b*2
  FROM t1
 WHERE d>e
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1052 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1053 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,4,6,3,2,5
;

CREATE VIRTUAL VIEW V1054 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1055 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,3,6,4,2,5
;

CREATE VIRTUAL VIEW V1056 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1057 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
    OR c BETWEEN b-2 AND d+2
 ORDER BY 2,5,3
;

CREATE VIRTUAL VIEW V1058 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1059 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 6,5,2,3,4,1
;

CREATE VIRTUAL VIEW V1060 AS SELECT d-e,
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1061 AS SELECT d-e,
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1062 AS SELECT d-e,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1063 AS SELECT d-e,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1064 AS SELECT a+b*2+c*3+d*4+e*5,
       b
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1065 AS SELECT a+b*2+c*3+d*4+e*5,
       b
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1066 AS SELECT e,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIRTUAL VIEW V1067 AS SELECT e,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V1068 AS SELECT a-b
  FROM t1
;

CREATE VIRTUAL VIEW V1069 AS SELECT a-b
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1070 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1071 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1,5,3
;

CREATE VIRTUAL VIEW V1072 AS SELECT a,
       a+b*2+c*3+d*4,
       e,
       a-b,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1073 AS SELECT a,
       a+b*2+c*3+d*4,
       e,
       a-b,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 5,2
;

CREATE VIRTUAL VIEW V1074 AS SELECT c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
;

CREATE VIRTUAL VIEW V1075 AS SELECT c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1076 AS SELECT c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE b>c
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1077 AS SELECT c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE b>c
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1078 AS SELECT (a+b+c+d+e)/5,
       d,
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
    OR a>b
;

CREATE VIRTUAL VIEW V1079 AS SELECT (a+b+c+d+e)/5,
       d,
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
    OR a>b
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V1080 AS SELECT (a+b+c+d+e)/5,
       d,
       abs(b-c)
  FROM t1
 WHERE a>b
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1081 AS SELECT (a+b+c+d+e)/5,
       d,
       abs(b-c)
  FROM t1
 WHERE a>b
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V1082 AS SELECT (a+b+c+d+e)/5,
       d,
       abs(b-c)
  FROM t1
 WHERE a>b
    OR (e>c OR e<d)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1083 AS SELECT (a+b+c+d+e)/5,
       d,
       abs(b-c)
  FROM t1
 WHERE a>b
    OR (e>c OR e<d)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1084 AS SELECT abs(a),
       d,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
    OR b>c
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1085 AS SELECT abs(a),
       d,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
    OR b>c
    OR (a>b-2 AND a<b+2)
 ORDER BY 4,2,5,1,6,3
;

CREATE VIRTUAL VIEW V1086 AS SELECT abs(a),
       d,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
    OR a>b
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1087 AS SELECT abs(a),
       d,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
    OR a>b
    OR (a>b-2 AND a<b+2)
 ORDER BY 4,6,5,3,2
;

CREATE VIRTUAL VIEW V1088 AS SELECT abs(a),
       d,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
    OR b>c
;

CREATE VIRTUAL VIEW V1089 AS SELECT abs(a),
       d,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
    OR b>c
 ORDER BY 5,1,2,6,3
;

CREATE VIRTUAL VIEW V1090 AS SELECT abs(a),
       a+b*2+c*3
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V1091 AS SELECT abs(a),
       a+b*2+c*3
  FROM t1
 WHERE d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1092 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       a,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V1093 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       a,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
 ORDER BY 1,6,4
;

CREATE VIRTUAL VIEW V1094 AS SELECT b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1095 AS SELECT b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,5
;

CREATE VIRTUAL VIEW V1096 AS SELECT b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1097 AS SELECT b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,1,2,5,3
;

CREATE VIRTUAL VIEW V1098 AS SELECT b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1099 AS SELECT b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
 ORDER BY 4,1,3,5
;

CREATE VIRTUAL VIEW V1100 AS SELECT a+b*2,
       abs(b-c),
       abs(a),
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1101 AS SELECT a+b*2,
       abs(b-c),
       abs(a),
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 2,4,3
;

CREATE VIRTUAL VIEW V1102 AS SELECT d-e,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIRTUAL VIEW V1103 AS SELECT d-e,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 3,4,1,6
;

CREATE VIRTUAL VIEW V1104 AS SELECT b,
       c
  FROM t1
;

CREATE VIRTUAL VIEW V1105 AS SELECT b,
       c
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1106 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1107 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1108 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
   AND d>e
;

CREATE VIRTUAL VIEW V1109 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
   AND d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1110 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1111 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1112 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d>e
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1113 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d>e
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1114 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1115 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1116 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE b>c
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1117 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE b>c
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V1118 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1119 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
    OR (e>c OR e<d)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1120 AS SELECT c-d,
       d-e,
       d,
       a+b*2+c*3
  FROM t1
;

CREATE VIRTUAL VIEW V1121 AS SELECT c-d,
       d-e,
       d,
       a+b*2+c*3
  FROM t1
 ORDER BY 2,1,3,4
;

CREATE VIRTUAL VIEW V1122 AS SELECT abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1123 AS SELECT abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1124 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1125 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,4,3
;

CREATE VIRTUAL VIEW V1126 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d>e
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1127 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d>e
    OR (e>a AND e<b)
 ORDER BY 3,4,1
;

CREATE VIRTUAL VIEW V1128 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d-e
  FROM t1
 WHERE d>e
    OR (a>b-2 AND a<b+2)
    OR c>d
;

CREATE VIRTUAL VIEW V1129 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d-e
  FROM t1
 WHERE d>e
    OR (a>b-2 AND a<b+2)
    OR c>d
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V1130 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c>d
    OR d>e
;

CREATE VIRTUAL VIEW V1131 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c>d
    OR d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1132 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d-e
  FROM t1
 WHERE d>e
    OR c>d
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1133 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d-e
  FROM t1
 WHERE d>e
    OR c>d
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,4,1
;

CREATE VIRTUAL VIEW V1134 AS SELECT abs(a),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1135 AS SELECT abs(a),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
 ORDER BY 4,3,2,1
;

CREATE VIRTUAL VIEW V1136 AS SELECT abs(a),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1137 AS SELECT abs(a),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,1,2,3
;

CREATE VIRTUAL VIEW V1138 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1139 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1140 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1141 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1142 AS SELECT b-c
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V1143 AS SELECT b-c
  FROM t1
 WHERE c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1144 AS SELECT a+b*2+c*3+d*4,
       c
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V1145 AS SELECT a+b*2+c*3+d*4,
       c
  FROM t1
 WHERE b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1146 AS SELECT a+b*2+c*3+d*4,
       c-d,
       a+b*2+c*3,
       d,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c)
  FROM t1
;

CREATE VIRTUAL VIEW V1147 AS SELECT a+b*2+c*3+d*4,
       c-d,
       a+b*2+c*3,
       d,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c)
  FROM t1
 ORDER BY 5,4,7,6,1,2,3
;

CREATE VIRTUAL VIEW V1148 AS SELECT a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
    OR b>c
;

CREATE VIRTUAL VIEW V1149 AS SELECT a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
    OR b>c
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V1150 AS SELECT a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
    OR d>e
;

CREATE VIRTUAL VIEW V1151 AS SELECT a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
    OR d>e
 ORDER BY 1,4,2
;

CREATE VIRTUAL VIEW V1152 AS SELECT a+b*2+c*3,
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
;

CREATE VIRTUAL VIEW V1153 AS SELECT a+b*2+c*3,
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1154 AS SELECT a+b*2+c*3,
       c-d
  FROM t1
 WHERE b>c
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1155 AS SELECT a+b*2+c*3,
       c-d
  FROM t1
 WHERE b>c
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1156 AS SELECT c,
       a+b*2+c*3+d*4,
       b,
       abs(b-c),
       (a+b+c+d+e)/5,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V1157 AS SELECT c,
       a+b*2+c*3+d*4,
       b,
       abs(b-c),
       (a+b+c+d+e)/5,
       abs(a)
  FROM t1
 ORDER BY 3,4,5
;

CREATE VIRTUAL VIEW V1158 AS SELECT a,
       c-d
  FROM t1
;

CREATE VIRTUAL VIEW V1159 AS SELECT a,
       c-d
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1160 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       a+b*2+c*3+d*4+e*5,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
    OR d>e
;

CREATE VIRTUAL VIEW V1161 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       a+b*2+c*3+d*4+e*5,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
    OR d>e
 ORDER BY 3,4,6
;

CREATE VIRTUAL VIEW V1162 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       a+b*2+c*3+d*4+e*5,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1163 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       a+b*2+c*3+d*4+e*5,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
    OR (e>a AND e<b)
 ORDER BY 1,6,5
;

CREATE VIRTUAL VIEW V1164 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       a+b*2+c*3+d*4+e*5,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>a AND e<b)
    OR d>e
;

CREATE VIRTUAL VIEW V1165 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       a+b*2+c*3+d*4+e*5,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>a AND e<b)
    OR d>e
 ORDER BY 6,2,3,5,4,1
;

CREATE VIRTUAL VIEW V1166 AS SELECT b,
       a-b,
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1167 AS SELECT b,
       a-b,
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1168 AS SELECT b,
       a-b,
       a+b*2
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1169 AS SELECT b,
       a-b,
       a+b*2
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1170 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a-b,
       abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d NOT BETWEEN 110 AND 150
    OR a>b
;

CREATE VIRTUAL VIEW V1171 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a-b,
       abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d NOT BETWEEN 110 AND 150
    OR a>b
 ORDER BY 3,5,6,2,1,4
;

CREATE VIRTUAL VIEW V1172 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a-b,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (c<=d-2 OR c>=d+2)
    OR a>b
;

CREATE VIRTUAL VIEW V1173 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a-b,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (c<=d-2 OR c>=d+2)
    OR a>b
 ORDER BY 4,1,3
;

CREATE VIRTUAL VIEW V1174 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a-b,
       abs(b-c)
  FROM t1
 WHERE a>b
    OR d NOT BETWEEN 110 AND 150
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1175 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a-b,
       abs(b-c)
  FROM t1
 WHERE a>b
    OR d NOT BETWEEN 110 AND 150
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 5,6,2,3
;

CREATE VIRTUAL VIEW V1176 AS SELECT a+b*2+c*3,
       d-e,
       abs(a)
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1177 AS SELECT a+b*2+c*3,
       d-e,
       abs(a)
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V1178 AS SELECT a+b*2+c*3,
       d-e,
       abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
;

CREATE VIRTUAL VIEW V1179 AS SELECT a+b*2+c*3,
       d-e,
       abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V1180 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V1181 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE d>e
 ORDER BY 3,7,1,6,2,4,5
;

CREATE VIRTUAL VIEW V1182 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       a-b,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE a>b
    OR b>c
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1183 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       a-b,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE a>b
    OR b>c
    OR (e>c OR e<d)
 ORDER BY 2,4,7
;

CREATE VIRTUAL VIEW V1184 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       a-b,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR a>b
;

CREATE VIRTUAL VIEW V1185 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       a-b,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR a>b
 ORDER BY 4,5,3,7,6,1
;

CREATE VIRTUAL VIEW V1186 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       a-b,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
    OR a>b
    OR b>c
;

CREATE VIRTUAL VIEW V1187 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       a-b,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
    OR a>b
    OR b>c
 ORDER BY 4,7,1,5,6,2,3
;

CREATE VIRTUAL VIEW V1188 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1189 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V1190 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1191 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1,4,3,2
;

CREATE VIRTUAL VIEW V1192 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1193 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1,2,4,3
;

CREATE VIRTUAL VIEW V1194 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1195 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
    OR (e>a AND e<b)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V1196 AS SELECT abs(a),
       d-e,
       a,
       a+b*2+c*3
  FROM t1
;

CREATE VIRTUAL VIEW V1197 AS SELECT abs(a),
       d-e,
       a,
       a+b*2+c*3
  FROM t1
 ORDER BY 4,1
;

CREATE VIRTUAL VIEW V1198 AS SELECT a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1199 AS SELECT a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1200 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       b-c,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIRTUAL VIEW V1201 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       b-c,
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 4,1
;

CREATE VIRTUAL VIEW V1202 AS SELECT a+b*2,
       b-c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1203 AS SELECT a+b*2,
       b-c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,5,3,4,1
;

CREATE VIRTUAL VIEW V1204 AS SELECT c-d,
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND b>c
;

CREATE VIRTUAL VIEW V1205 AS SELECT c-d,
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1206 AS SELECT c-d,
       abs(a)
  FROM t1
 WHERE c>d
   AND b>c
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1207 AS SELECT c-d,
       abs(a)
  FROM t1
 WHERE c>d
   AND b>c
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1208 AS SELECT c-d,
       abs(a)
  FROM t1
 WHERE b>c
   AND c>d
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1209 AS SELECT c-d,
       abs(a)
  FROM t1
 WHERE b>c
   AND c>d
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1210 AS SELECT a+b*2+c*3,
       a+b*2,
       c,
       abs(b-c),
       e,
       b
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1211 AS SELECT a+b*2+c*3,
       a+b*2,
       c,
       abs(b-c),
       e,
       b
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
   AND c BETWEEN b-2 AND d+2
 ORDER BY 4,5,1,3
;

CREATE VIRTUAL VIEW V1212 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1213 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 5,2,4,3,1
;

CREATE VIRTUAL VIEW V1214 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1215 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
 ORDER BY 5,4,3
;

CREATE VIRTUAL VIEW V1216 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(b-c),
       e,
       c-d,
       a-b,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1217 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(b-c),
       e,
       c-d,
       a-b,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1218 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(b-c),
       e,
       c-d,
       a-b,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
   AND b>c
;

CREATE VIRTUAL VIEW V1219 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(b-c),
       e,
       c-d,
       a-b,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
   AND b>c
 ORDER BY 4,2,1,5
;

CREATE VIRTUAL VIEW V1220 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(b-c),
       e,
       c-d,
       a-b,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1221 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(b-c),
       e,
       c-d,
       a-b,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
   AND c BETWEEN b-2 AND d+2
 ORDER BY 4,6,3,5,2,1
;

CREATE VIRTUAL VIEW V1222 AS SELECT b-c,
       a+b*2+c*3,
       d,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1223 AS SELECT b-c,
       a+b*2+c*3,
       d,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1,2,5
;

CREATE VIRTUAL VIEW V1224 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1225 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1226 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR b>c
;

CREATE VIRTUAL VIEW V1227 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR b>c
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1228 AS SELECT abs(b-c),
       abs(a),
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
    OR a>b
;

CREATE VIRTUAL VIEW V1229 AS SELECT abs(b-c),
       abs(a),
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
    OR a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1230 AS SELECT abs(b-c),
       abs(a),
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
    OR c>d
;

CREATE VIRTUAL VIEW V1231 AS SELECT abs(b-c),
       abs(a),
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
    OR c>d
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V1232 AS SELECT b,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
;

CREATE VIRTUAL VIEW V1233 AS SELECT b,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1234 AS SELECT b,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1235 AS SELECT b,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1236 AS SELECT d-e,
       a,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1237 AS SELECT d-e,
       a,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V1238 AS SELECT d-e,
       a,
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1239 AS SELECT d-e,
       a,
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V1240 AS SELECT d-e,
       a,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1241 AS SELECT d-e,
       a,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V1242 AS SELECT a+b*2+c*3+d*4+e*5,
       d,
       a-b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
;

CREATE VIRTUAL VIEW V1243 AS SELECT a+b*2+c*3+d*4+e*5,
       d,
       a-b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
 ORDER BY 2,4,3
;

CREATE VIRTUAL VIEW V1244 AS SELECT a+b*2,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1245 AS SELECT a+b*2,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 3,4,2,5,1,6
;

CREATE VIRTUAL VIEW V1246 AS SELECT c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       b,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V1247 AS SELECT c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       b,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e
  FROM t1
 ORDER BY 4,5,2,7,1,3,6
;

CREATE VIRTUAL VIEW V1248 AS SELECT e,
       d-e,
       abs(b-c),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1249 AS SELECT e,
       d-e,
       abs(b-c),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1,4
;

CREATE VIRTUAL VIEW V1250 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       d,
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1251 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       d,
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,1,3,4
;

CREATE VIRTUAL VIEW V1252 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       d,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1253 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       d,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,2,3,1
;

CREATE VIRTUAL VIEW V1254 AS SELECT a+b*2+c*3,
       abs(b-c),
       a+b*2,
       abs(a),
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1255 AS SELECT a+b*2+c*3,
       abs(b-c),
       a+b*2,
       abs(a),
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,3,2,4
;

CREATE VIRTUAL VIEW V1256 AS SELECT e,
       a-b,
       c,
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V1257 AS SELECT e,
       a-b,
       c,
       d-e
  FROM t1
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V1258 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1259 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1260 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1261 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1262 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1263 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V1264 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1265 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,1,2,4
;

CREATE VIRTUAL VIEW V1266 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1267 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 3,4,2
;

CREATE VIRTUAL VIEW V1268 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       (a+b+c+d+e)/5,
       c-d,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1269 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       (a+b+c+d+e)/5,
       c-d,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 4,5,6
;

CREATE VIRTUAL VIEW V1270 AS SELECT c
  FROM t1
 WHERE d>e
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1271 AS SELECT c
  FROM t1
 WHERE d>e
    OR (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1272 AS SELECT c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d>e
;

CREATE VIRTUAL VIEW V1273 AS SELECT c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d>e
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1274 AS SELECT e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1275 AS SELECT e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1276 AS SELECT a+b*2+c*3,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1277 AS SELECT a+b*2+c*3,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1278 AS SELECT a+b*2+c*3,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1279 AS SELECT a+b*2+c*3,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>a AND e<b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1280 AS SELECT a,
       e,
       a+b*2+c*3,
       a+b*2
  FROM t1
;

CREATE VIRTUAL VIEW V1281 AS SELECT a,
       e,
       a+b*2+c*3,
       a+b*2
  FROM t1
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V1282 AS SELECT d,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c>d
;

CREATE VIRTUAL VIEW V1283 AS SELECT d,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c>d
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V1284 AS SELECT d,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1285 AS SELECT d,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V1286 AS SELECT (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V1287 AS SELECT (a+b+c+d+e)/5
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1288 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1289 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1290 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1291 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1292 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1293 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1294 AS SELECT a-b,
       a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1295 AS SELECT a-b,
       a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1296 AS SELECT a-b,
       a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1297 AS SELECT a-b,
       a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V1298 AS SELECT c,
       a,
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1299 AS SELECT c,
       a,
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V1300 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       c,
       b-c,
       d-e,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR a>b
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1301 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       c,
       b-c,
       d-e,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR a>b
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,5,1,7,4
;

CREATE VIRTUAL VIEW V1302 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       c,
       b-c,
       d-e,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
    OR (c<=d-2 OR c>=d+2)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1303 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       c,
       b-c,
       d-e,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
    OR (c<=d-2 OR c>=d+2)
    OR (a>b-2 AND a<b+2)
 ORDER BY 7,1,5,3,6
;

CREATE VIRTUAL VIEW V1304 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       c,
       b-c,
       d-e,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1305 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       c,
       b-c,
       d-e,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 3,1,4,5,2,7
;

CREATE VIRTUAL VIEW V1306 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       c,
       b-c,
       d-e,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
    OR a>b
;

CREATE VIRTUAL VIEW V1307 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       c,
       b-c,
       d-e,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
    OR a>b
 ORDER BY 7,1
;

CREATE VIRTUAL VIEW V1308 AS SELECT c,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       a+b*2,
       (a+b+c+d+e)/5,
       e
  FROM t1
 WHERE b>c
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1309 AS SELECT c,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       a+b*2,
       (a+b+c+d+e)/5,
       e
  FROM t1
 WHERE b>c
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,2,5,7,3,4,6
;

CREATE VIRTUAL VIEW V1310 AS SELECT c,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       a+b*2,
       (a+b+c+d+e)/5,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b>c
;

CREATE VIRTUAL VIEW V1311 AS SELECT c,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       a+b*2,
       (a+b+c+d+e)/5,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b>c
 ORDER BY 2,3,7,4,1
;

CREATE VIRTUAL VIEW V1312 AS SELECT abs(a),
       b
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V1313 AS SELECT abs(a),
       b
  FROM t1
 WHERE b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1314 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1315 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1316 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1317 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1318 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1319 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1320 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1321 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1322 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
    OR b>c
;

CREATE VIRTUAL VIEW V1323 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
    OR b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1324 AS SELECT c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1325 AS SELECT c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1326 AS SELECT c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1327 AS SELECT c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1328 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1329 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 6,3,1
;

CREATE VIRTUAL VIEW V1330 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       d-e
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1331 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       d-e
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,6,4,3,1,5
;

CREATE VIRTUAL VIEW V1332 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
    OR b>c
;

CREATE VIRTUAL VIEW V1333 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
    OR b>c
 ORDER BY 2,4,5,3,6
;

CREATE VIRTUAL VIEW V1334 AS SELECT a+b*2+c*3+d*4+e*5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a+b*2,
       a
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1335 AS SELECT a+b*2+c*3+d*4+e*5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a+b*2,
       a
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
 ORDER BY 3,4,6,5
;

CREATE VIRTUAL VIEW V1336 AS SELECT a+b*2,
       a+b*2+c*3+d*4+e*5,
       b
  FROM t1
;

CREATE VIRTUAL VIEW V1337 AS SELECT a+b*2,
       a+b*2+c*3+d*4+e*5,
       b
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1338 AS SELECT a+b*2+c*3+d*4,
       d-e,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1339 AS SELECT a+b*2+c*3+d*4,
       d-e,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,3,5
;

CREATE VIRTUAL VIEW V1340 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       a,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1341 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       a,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
   AND (a>b-2 AND a<b+2)
 ORDER BY 5,7,6,2,4,3
;

CREATE VIRTUAL VIEW V1342 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1343 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,4,3,1
;

CREATE VIRTUAL VIEW V1344 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIRTUAL VIEW V1345 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 2,3,4,6,1
;

CREATE VIRTUAL VIEW V1346 AS SELECT c,
       d-e,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       a,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1347 AS SELECT c,
       d-e,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       a,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,6,7,3
;

CREATE VIRTUAL VIEW V1348 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       a
  FROM t1
;

CREATE VIRTUAL VIEW V1349 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       a
  FROM t1
 ORDER BY 2,1,3,5
;

CREATE VIRTUAL VIEW V1350 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1351 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1352 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1353 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,5
;

CREATE VIRTUAL VIEW V1354 AS SELECT e,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1355 AS SELECT e,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,4,1
;

CREATE VIRTUAL VIEW V1356 AS SELECT e,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1357 AS SELECT e,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,3,4
;

CREATE VIRTUAL VIEW V1358 AS SELECT abs(b-c),
       b-c,
       c-d,
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V1359 AS SELECT abs(b-c),
       b-c,
       c-d,
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 1,4,2,5
;

CREATE VIRTUAL VIEW V1360 AS SELECT b-c,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1361 AS SELECT b-c,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V1362 AS SELECT b-c,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1363 AS SELECT b-c,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V1364 AS SELECT d,
       c,
       a+b*2,
       abs(b-c),
       abs(a),
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1365 AS SELECT d,
       c,
       a+b*2,
       abs(b-c),
       abs(a),
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 4,2
;

CREATE VIRTUAL VIEW V1366 AS SELECT d-e,
       a,
       b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1367 AS SELECT d-e,
       a,
       b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V1368 AS SELECT d-e,
       a,
       b
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1369 AS SELECT d-e,
       a,
       b
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V1370 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       d-e,
       d
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V1371 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       d-e,
       d
  FROM t1
 WHERE b>c
 ORDER BY 4,2,5
;

CREATE VIRTUAL VIEW V1372 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       b-c
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1373 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       b-c
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 5,7,4,3,1,6,2
;

CREATE VIRTUAL VIEW V1374 AS SELECT e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
;

CREATE VIRTUAL VIEW V1375 AS SELECT e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1376 AS SELECT e
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1377 AS SELECT e
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1378 AS SELECT c-d
  FROM t1
 WHERE a>b
    OR d>e
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1379 AS SELECT c-d
  FROM t1
 WHERE a>b
    OR d>e
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1380 AS SELECT c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d>e
    OR a>b
;

CREATE VIRTUAL VIEW V1381 AS SELECT c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d>e
    OR a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1382 AS SELECT c-d
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2 AND d+2
    OR d>e
;

CREATE VIRTUAL VIEW V1383 AS SELECT c-d
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2 AND d+2
    OR d>e
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1384 AS SELECT a+b*2+c*3+d*4
  FROM t1
;

CREATE VIRTUAL VIEW V1385 AS SELECT a+b*2+c*3+d*4
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1386 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1387 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 2,1,4,5
;

CREATE VIRTUAL VIEW V1388 AS SELECT abs(a),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V1389 AS SELECT abs(a),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d>e
 ORDER BY 2,4,5,1,3
;

CREATE VIRTUAL VIEW V1390 AS SELECT abs(b-c),
       b-c,
       a+b*2+c*3,
       a-b,
       e,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1391 AS SELECT abs(b-c),
       b-c,
       a+b*2+c*3,
       a-b,
       e,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
 ORDER BY 7,6,4,3,1,5
;

CREATE VIRTUAL VIEW V1392 AS SELECT abs(b-c),
       b-c,
       a+b*2+c*3,
       a-b,
       e,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1393 AS SELECT abs(b-c),
       b-c,
       a+b*2+c*3,
       a-b,
       e,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 7,5,6,1,4,3,2
;

CREATE VIRTUAL VIEW V1394 AS SELECT (a+b+c+d+e)/5,
       d,
       e,
       a+b*2
  FROM t1
;

CREATE VIRTUAL VIEW V1395 AS SELECT (a+b+c+d+e)/5,
       d,
       e,
       a+b*2
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1396 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1397 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
   AND (e>c OR e<d)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1398 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1399 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1400 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
   AND b>c
;

CREATE VIRTUAL VIEW V1401 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
   AND b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1402 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
;

CREATE VIRTUAL VIEW V1403 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1404 AS SELECT abs(a),
       b-c,
       a,
       d-e,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1405 AS SELECT abs(a),
       b-c,
       a,
       d-e,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 5,4,3,6,2,1
;

CREATE VIRTUAL VIEW V1406 AS SELECT e,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
;

CREATE VIRTUAL VIEW V1407 AS SELECT e,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1408 AS SELECT e,
       abs(b-c)
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1409 AS SELECT e,
       abs(b-c)
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1410 AS SELECT b-c,
       c,
       d-e,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V1411 AS SELECT b-c,
       c,
       d-e,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 1,2,4
;

CREATE VIRTUAL VIEW V1412 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE b>c
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1413 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE b>c
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1414 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR b>c
;

CREATE VIRTUAL VIEW V1415 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1416 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1417 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,6,1,7,4,5
;

CREATE VIRTUAL VIEW V1418 AS SELECT d,
       c
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V1419 AS SELECT d,
       c
  FROM t1
 WHERE a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1420 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c>d
    OR a>b
;

CREATE VIRTUAL VIEW V1421 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c>d
    OR a>b
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V1422 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
    OR c>d
;

CREATE VIRTUAL VIEW V1423 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
    OR c>d
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1424 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       d-e
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
    OR c>d
;

CREATE VIRTUAL VIEW V1425 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       d-e
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
    OR c>d
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V1426 AS SELECT e,
       abs(b-c)
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1427 AS SELECT e,
       abs(b-c)
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1428 AS SELECT b-c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1429 AS SELECT b-c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1430 AS SELECT c,
       a-b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1431 AS SELECT c,
       a-b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,2,4,1
;

CREATE VIRTUAL VIEW V1432 AS SELECT c,
       a-b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
   AND d>e
;

CREATE VIRTUAL VIEW V1433 AS SELECT c,
       a-b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
   AND d>e
 ORDER BY 4,2,3
;

CREATE VIRTUAL VIEW V1434 AS SELECT c,
       a-b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2 AND d+2
   AND d>e
;

CREATE VIRTUAL VIEW V1435 AS SELECT c,
       a-b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2 AND d+2
   AND d>e
 ORDER BY 3,2,1,4
;

CREATE VIRTUAL VIEW V1436 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1437 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,5,6,1,3,4
;

CREATE VIRTUAL VIEW V1438 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c>d
    OR d>e
;

CREATE VIRTUAL VIEW V1439 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c>d
    OR d>e
 ORDER BY 1,4,2,3
;

CREATE VIRTUAL VIEW V1440 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
    OR c>d
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1441 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
    OR c>d
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V1442 AS SELECT d,
       c-d,
       c,
       abs(a),
       a-b
  FROM t1
 WHERE b>c
   AND a>b
   AND c>d
;

CREATE VIRTUAL VIEW V1443 AS SELECT d,
       c-d,
       c,
       abs(a),
       a-b
  FROM t1
 WHERE b>c
   AND a>b
   AND c>d
 ORDER BY 1,4,2
;

CREATE VIRTUAL VIEW V1444 AS SELECT d,
       c-d,
       c,
       abs(a),
       a-b
  FROM t1
 WHERE b>c
   AND c>d
   AND a>b
;

CREATE VIRTUAL VIEW V1445 AS SELECT d,
       c-d,
       c,
       abs(a),
       a-b
  FROM t1
 WHERE b>c
   AND c>d
   AND a>b
 ORDER BY 2,1,5
;

CREATE VIRTUAL VIEW V1446 AS SELECT d,
       c-d,
       c,
       abs(a),
       a-b
  FROM t1
 WHERE c>d
   AND a>b
   AND b>c
;

CREATE VIRTUAL VIEW V1447 AS SELECT d,
       c-d,
       c,
       abs(a),
       a-b
  FROM t1
 WHERE c>d
   AND a>b
   AND b>c
 ORDER BY 4,5,1,2,3
;

CREATE VIRTUAL VIEW V1448 AS SELECT a-b,
       c
  FROM t1
;

CREATE VIRTUAL VIEW V1449 AS SELECT a-b,
       c
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1450 AS SELECT e
  FROM t1
 WHERE b>c
   AND d NOT BETWEEN 110 AND 150
   AND a>b
;

CREATE VIRTUAL VIEW V1451 AS SELECT e
  FROM t1
 WHERE b>c
   AND d NOT BETWEEN 110 AND 150
   AND a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1452 AS SELECT e
  FROM t1
 WHERE b>c
   AND a>b
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1453 AS SELECT e
  FROM t1
 WHERE b>c
   AND a>b
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1454 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
   AND a>b
;

CREATE VIRTUAL VIEW V1455 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
   AND a>b
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V1456 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a>b
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1457 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a>b
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V1458 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
   AND a>b
;

CREATE VIRTUAL VIEW V1459 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
   AND a>b
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V1460 AS SELECT abs(a),
       a+b*2,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
;

CREATE VIRTUAL VIEW V1461 AS SELECT abs(a),
       a+b*2,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
 ORDER BY 5,3,2,4,1
;

CREATE VIRTUAL VIEW V1462 AS SELECT abs(a),
       a+b*2,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1463 AS SELECT abs(a),
       a+b*2,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,3,4,5,2
;

CREATE VIRTUAL VIEW V1464 AS SELECT a+b*2,
       a-b,
       b,
       c-d,
       e,
       b-c
  FROM t1
 WHERE (e>a AND e<b)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1465 AS SELECT a+b*2,
       a-b,
       b,
       c-d,
       e,
       b-c
  FROM t1
 WHERE (e>a AND e<b)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2,6,4,5,3
;

CREATE VIRTUAL VIEW V1466 AS SELECT a+b*2,
       a-b,
       b,
       c-d,
       e,
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1467 AS SELECT a+b*2,
       a-b,
       b,
       c-d,
       e,
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>a AND e<b)
 ORDER BY 3,1,5,6,4
;

CREATE VIRTUAL VIEW V1468 AS SELECT c,
       a+b*2+c*3,
       d
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V1469 AS SELECT c,
       a+b*2+c*3,
       d
  FROM t1
 WHERE b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1470 AS SELECT a+b*2+c*3+d*4,
       e,
       c-d
  FROM t1
;

CREATE VIRTUAL VIEW V1471 AS SELECT a+b*2+c*3+d*4,
       e,
       c-d
  FROM t1
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V1472 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c)
  FROM t1
;

CREATE VIRTUAL VIEW V1473 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c)
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1474 AS SELECT d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1475 AS SELECT d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1476 AS SELECT d-e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1477 AS SELECT d-e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1478 AS SELECT a-b,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e
  FROM t1
 WHERE c>d
   AND a>b
   AND d>e
;

CREATE VIRTUAL VIEW V1479 AS SELECT a-b,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e
  FROM t1
 WHERE c>d
   AND a>b
   AND d>e
 ORDER BY 4,6,1
;

CREATE VIRTUAL VIEW V1480 AS SELECT a-b,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e
  FROM t1
 WHERE a>b
   AND d>e
   AND c>d
;

CREATE VIRTUAL VIEW V1481 AS SELECT a-b,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e
  FROM t1
 WHERE a>b
   AND d>e
   AND c>d
 ORDER BY 5,1,4,6,3,2
;

CREATE VIRTUAL VIEW V1482 AS SELECT a-b,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e
  FROM t1
 WHERE c>d
   AND d>e
   AND a>b
;

CREATE VIRTUAL VIEW V1483 AS SELECT a-b,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e
  FROM t1
 WHERE c>d
   AND d>e
   AND a>b
 ORDER BY 1,4,5
;

CREATE VIRTUAL VIEW V1484 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
;

CREATE VIRTUAL VIEW V1485 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1486 AS SELECT a-b,
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1487 AS SELECT a-b,
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1488 AS SELECT a-b,
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1489 AS SELECT a-b,
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1490 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a)
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V1491 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a)
  FROM t1
 WHERE d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1492 AS SELECT d
  FROM t1
;

CREATE VIRTUAL VIEW V1493 AS SELECT d
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1494 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1495 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1496 AS SELECT a,
       d-e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       c,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
   AND a>b
;

CREATE VIRTUAL VIEW V1497 AS SELECT a,
       d-e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       c,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
   AND a>b
 ORDER BY 3,5,4,7,6
;

CREATE VIRTUAL VIEW V1498 AS SELECT a,
       d-e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       c,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
   AND a>b
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1499 AS SELECT a,
       d-e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       c,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
   AND a>b
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 5,6,3,1,4,7,2
;

CREATE VIRTUAL VIEW V1500 AS SELECT a,
       d-e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       c,
       abs(b-c)
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1501 AS SELECT a,
       d-e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       c,
       abs(b-c)
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
 ORDER BY 6,4
;

CREATE VIRTUAL VIEW V1502 AS SELECT a,
       d-e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       c,
       abs(b-c)
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1503 AS SELECT a,
       d-e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       c,
       abs(b-c)
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,4,3,7,5
;

CREATE VIRTUAL VIEW V1504 AS SELECT abs(a)
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110 AND 150
    OR c>d
;

CREATE VIRTUAL VIEW V1505 AS SELECT abs(a)
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110 AND 150
    OR c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1506 AS SELECT abs(a)
  FROM t1
 WHERE d>e
    OR c>d
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1507 AS SELECT abs(a)
  FROM t1
 WHERE d>e
    OR c>d
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1508 AS SELECT abs(a)
  FROM t1
 WHERE c>d
    OR d>e
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1509 AS SELECT abs(a)
  FROM t1
 WHERE c>d
    OR d>e
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1510 AS SELECT a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1511 AS SELECT a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1512 AS SELECT a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1513 AS SELECT a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1514 AS SELECT a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1515 AS SELECT a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1516 AS SELECT d-e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1517 AS SELECT d-e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
 ORDER BY 5,4,3
;

CREATE VIRTUAL VIEW V1518 AS SELECT d-e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
   AND b>c
;

CREATE VIRTUAL VIEW V1519 AS SELECT d-e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
   AND b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1520 AS SELECT d-e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1521 AS SELECT d-e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,2,5
;

CREATE VIRTUAL VIEW V1522 AS SELECT d-e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1523 AS SELECT d-e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V1524 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c
  FROM t1
 WHERE a>b
   AND (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1525 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c
  FROM t1
 WHERE a>b
   AND (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V1526 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND a>b
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1527 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND a>b
   AND (e>c OR e<d)
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V1528 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c
  FROM t1
 WHERE (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
   AND a>b
;

CREATE VIRTUAL VIEW V1529 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c
  FROM t1
 WHERE (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
   AND a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1530 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c
  FROM t1
 WHERE (e>c OR e<d)
   AND a>b
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1531 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c
  FROM t1
 WHERE (e>c OR e<d)
   AND a>b
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1532 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       d-e,
       b-c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1533 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       d-e,
       b-c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
 ORDER BY 1,6,5
;

CREATE VIRTUAL VIEW V1534 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       d-e,
       b-c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1535 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       d-e,
       b-c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,6
;

CREATE VIRTUAL VIEW V1536 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       d-e,
       b-c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1537 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       d-e,
       b-c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,1,7,2,5
;

CREATE VIRTUAL VIEW V1538 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       c-d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1539 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       c-d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
 ORDER BY 2,6
;

CREATE VIRTUAL VIEW V1540 AS SELECT a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
;

CREATE VIRTUAL VIEW V1541 AS SELECT a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
 ORDER BY 4,2,3,1
;

CREATE VIRTUAL VIEW V1542 AS SELECT a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       a
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1543 AS SELECT a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       a
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 3,4,2,1
;

CREATE VIRTUAL VIEW V1544 AS SELECT a,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a-b
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1545 AS SELECT a,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a-b
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
 ORDER BY 2,6,1,4,5
;

CREATE VIRTUAL VIEW V1546 AS SELECT a,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a-b
  FROM t1
 WHERE (e>c OR e<d)
   AND c>d
;

CREATE VIRTUAL VIEW V1547 AS SELECT a,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a-b
  FROM t1
 WHERE (e>c OR e<d)
   AND c>d
 ORDER BY 6,1,2,5,3,4
;

CREATE VIRTUAL VIEW V1548 AS SELECT b,
       b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d>e
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1549 AS SELECT b,
       b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d>e
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1550 AS SELECT b,
       b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d>e
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1551 AS SELECT b,
       b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d>e
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1552 AS SELECT b,
       b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1553 AS SELECT b,
       b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V1554 AS SELECT abs(a),
       abs(b-c),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
   AND b>c
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1555 AS SELECT abs(a),
       abs(b-c),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
   AND b>c
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,4,2
;

CREATE VIRTUAL VIEW V1556 AS SELECT abs(a),
       abs(b-c),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c>d
   AND b>c
;

CREATE VIRTUAL VIEW V1557 AS SELECT abs(a),
       abs(b-c),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c>d
   AND b>c
 ORDER BY 3,5
;

CREATE VIRTUAL VIEW V1558 AS SELECT abs(a),
       abs(b-c),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
   AND c>d
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1559 AS SELECT abs(a),
       abs(b-c),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
   AND c>d
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,3,1,2
;

CREATE VIRTUAL VIEW V1560 AS SELECT a-b,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       b,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V1561 AS SELECT a-b,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       b,
       abs(a)
  FROM t1
 ORDER BY 3,2,4,1,5
;

CREATE VIRTUAL VIEW V1562 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1563 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V1564 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V1565 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 WHERE a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1566 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       abs(b-c),
       b-c,
       a+b*2+c*3+d*4+e*5,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1567 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       abs(b-c),
       b-c,
       a+b*2+c*3+d*4+e*5,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 3,7,6,1
;

CREATE VIRTUAL VIEW V1568 AS SELECT b-c,
       (a+b+c+d+e)/5,
       abs(a),
       abs(b-c),
       d,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V1569 AS SELECT b-c,
       (a+b+c+d+e)/5,
       abs(a),
       abs(b-c),
       d,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
 ORDER BY 1,4,5
;

CREATE VIRTUAL VIEW V1570 AS SELECT b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1571 AS SELECT b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1572 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1573 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 5,6,1,7,3,2
;

CREATE VIRTUAL VIEW V1574 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1575 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,4,7,3,1,6,5
;

CREATE VIRTUAL VIEW V1576 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       a,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1577 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       a,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 6,1,4,3
;

CREATE VIRTUAL VIEW V1578 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c
  FROM t1
;

CREATE VIRTUAL VIEW V1579 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c
  FROM t1
 ORDER BY 2,3,1,5
;

CREATE VIRTUAL VIEW V1580 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       a
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1581 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       a
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,6,4,1,5,3
;

CREATE VIRTUAL VIEW V1582 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND a>b
;

CREATE VIRTUAL VIEW V1583 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND a>b
 ORDER BY 1,2,5,3,6
;

CREATE VIRTUAL VIEW V1584 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1585 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1586 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       a
  FROM t1
 WHERE a>b
   AND e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1587 AS SELECT a+b*2,
       a+b*2+c*3+d*4,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       a
  FROM t1
 WHERE a>b
   AND e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V1588 AS SELECT a+b*2,
       a-b,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1589 AS SELECT a+b*2,
       a-b,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V1590 AS SELECT a+b*2,
       a-b,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1591 AS SELECT a+b*2,
       a-b,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 2,1,5
;

CREATE VIRTUAL VIEW V1592 AS SELECT a+b*2,
       a-b,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1593 AS SELECT a+b*2,
       a-b,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 6,1
;

CREATE VIRTUAL VIEW V1594 AS SELECT b-c,
       c-d,
       a+b*2
  FROM t1
 WHERE c>d
    OR d>e
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1595 AS SELECT b-c,
       c-d,
       a+b*2
  FROM t1
 WHERE c>d
    OR d>e
    OR (e>a AND e<b)
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V1596 AS SELECT b-c,
       c-d,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
    OR d>e
;

CREATE VIRTUAL VIEW V1597 AS SELECT b-c,
       c-d,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
    OR d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1598 AS SELECT b-c,
       c-d,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR c>d
;

CREATE VIRTUAL VIEW V1599 AS SELECT b-c,
       c-d,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1600 AS SELECT b-c,
       c-d,
       a+b*2
  FROM t1
 WHERE c>d
    OR (e>a AND e<b)
    OR d>e
;

CREATE VIRTUAL VIEW V1601 AS SELECT b-c,
       c-d,
       a+b*2
  FROM t1
 WHERE c>d
    OR (e>a AND e<b)
    OR d>e
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V1602 AS SELECT c,
       a+b*2+c*3,
       a,
       d,
       a+b*2,
       b
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1603 AS SELECT c,
       a+b*2+c*3,
       a,
       d,
       a+b*2,
       b
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,5,6,1,2
;

CREATE VIRTUAL VIEW V1604 AS SELECT d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       d,
       a
  FROM t1
;

CREATE VIRTUAL VIEW V1605 AS SELECT d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       d,
       a
  FROM t1
 ORDER BY 5,1
;

CREATE VIRTUAL VIEW V1606 AS SELECT abs(a),
       b-c,
       a-b,
       a,
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V1607 AS SELECT abs(a),
       b-c,
       a-b,
       a,
       d-e
  FROM t1
 ORDER BY 4,5,3
;

CREATE VIRTUAL VIEW V1608 AS SELECT b,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V1609 AS SELECT b,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a)
  FROM t1
 ORDER BY 6,4,2,7,5,1
;

CREATE VIRTUAL VIEW V1610 AS SELECT abs(b-c),
       d-e,
       b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V1611 AS SELECT abs(b-c),
       d-e,
       b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
 ORDER BY 6,4,5,1,7,2,3
;

CREATE VIRTUAL VIEW V1612 AS SELECT b-c,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1613 AS SELECT b-c,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 6,1,5
;

CREATE VIRTUAL VIEW V1614 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       c-d,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
    OR a>b
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1615 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       c-d,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
    OR a>b
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 5,6,4,3,1,7
;

CREATE VIRTUAL VIEW V1616 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       c-d,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
    OR a>b
;

CREATE VIRTUAL VIEW V1617 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       c-d,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
    OR a>b
 ORDER BY 5,6,1,2,7,3,4
;

CREATE VIRTUAL VIEW V1618 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1619 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
   AND (e>a AND e<b)
 ORDER BY 1,5
;

CREATE VIRTUAL VIEW V1620 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1621 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
 ORDER BY 5,4
;

CREATE VIRTUAL VIEW V1622 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1623 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND c BETWEEN b-2 AND d+2
 ORDER BY 4,3
;

CREATE VIRTUAL VIEW V1624 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
   AND d>e
;

CREATE VIRTUAL VIEW V1625 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
   AND d>e
 ORDER BY 5,2,3
;

CREATE VIRTUAL VIEW V1626 AS SELECT a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1627 AS SELECT a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1628 AS SELECT a-b,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2,
       b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1629 AS SELECT a-b,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2,
       b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 4,3,6,1
;

CREATE VIRTUAL VIEW V1630 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3,
       c,
       b
  FROM t1
;

CREATE VIRTUAL VIEW V1631 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3,
       c,
       b
  FROM t1
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V1632 AS SELECT d-e,
       abs(a),
       a,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
;

CREATE VIRTUAL VIEW V1633 AS SELECT d-e,
       abs(a),
       a,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
 ORDER BY 5,2
;

CREATE VIRTUAL VIEW V1634 AS SELECT abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1635 AS SELECT abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1636 AS SELECT abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1637 AS SELECT abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1638 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       a,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1639 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       a,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 5,7,1
;

CREATE VIRTUAL VIEW V1640 AS SELECT abs(a),
       e,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1641 AS SELECT abs(a),
       e,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1,5,6,4
;

CREATE VIRTUAL VIEW V1642 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
   AND a>b
;

CREATE VIRTUAL VIEW V1643 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
   AND a>b
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V1644 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1645 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
 ORDER BY 3,6
;

CREATE VIRTUAL VIEW V1646 AS SELECT abs(b-c),
       a+b*2,
       abs(a),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
    OR a>b
;

CREATE VIRTUAL VIEW V1647 AS SELECT abs(b-c),
       a+b*2,
       abs(a),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
    OR a>b
 ORDER BY 3,2,5,1
;

CREATE VIRTUAL VIEW V1648 AS SELECT abs(b-c),
       a+b*2,
       abs(a),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a>b
    OR (c<=d-2 OR c>=d+2)
    OR b>c
;

CREATE VIRTUAL VIEW V1649 AS SELECT abs(b-c),
       a+b*2,
       abs(a),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a>b
    OR (c<=d-2 OR c>=d+2)
    OR b>c
 ORDER BY 1,4
;

CREATE VIRTUAL VIEW V1650 AS SELECT abs(b-c),
       a+b*2,
       abs(a),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
    OR a>b
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1651 AS SELECT abs(b-c),
       a+b*2,
       abs(a),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
    OR a>b
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 3,4,1
;

CREATE VIRTUAL VIEW V1652 AS SELECT a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V1653 AS SELECT a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 3,1,4,2
;

CREATE VIRTUAL VIEW V1654 AS SELECT a,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       a-b,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V1655 AS SELECT a,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       a-b,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 3,2,6,1,5
;

CREATE VIRTUAL VIEW V1656 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1657 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1658 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND a>b
;

CREATE VIRTUAL VIEW V1659 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1660 AS SELECT a+b*2,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       b-c,
       b
  FROM t1
;

CREATE VIRTUAL VIEW V1661 AS SELECT a+b*2,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       b-c,
       b
  FROM t1
 ORDER BY 6,3,5,2,1
;

CREATE VIRTUAL VIEW V1662 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       c-d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d>e
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1663 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       c-d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d>e
   AND (e>c OR e<d)
 ORDER BY 6,3,2,1,5
;

CREATE VIRTUAL VIEW V1664 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
   AND d>e
;

CREATE VIRTUAL VIEW V1665 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
   AND d>e
 ORDER BY 4,1,2,6
;

CREATE VIRTUAL VIEW V1666 AS SELECT b-c,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V1667 AS SELECT b-c,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d>e
 ORDER BY 4,1
;

CREATE VIRTUAL VIEW V1668 AS SELECT abs(a),
       a+b*2,
       c-d,
       abs(b-c),
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V1669 AS SELECT abs(a),
       a+b*2,
       c-d,
       abs(b-c),
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE b>c
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V1670 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1671 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V1672 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1673 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>a AND e<b)
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V1674 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1675 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1676 AS SELECT a+b*2+c*3,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>a AND e<b)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1677 AS SELECT a+b*2+c*3,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>a AND e<b)
   AND (a>b-2 AND a<b+2)
 ORDER BY 4,1,6,3,5,2
;

CREATE VIRTUAL VIEW V1678 AS SELECT a+b*2+c*3,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1679 AS SELECT a+b*2+c*3,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
 ORDER BY 4,3,1,2
;

CREATE VIRTUAL VIEW V1680 AS SELECT a+b*2+c*3
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1681 AS SELECT a+b*2+c*3
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1682 AS SELECT a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
    OR b>c
;

CREATE VIRTUAL VIEW V1683 AS SELECT a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
    OR b>c
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1684 AS SELECT a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1685 AS SELECT a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1686 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIRTUAL VIEW V1687 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1688 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e,
       b
  FROM t1
 WHERE (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1689 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e,
       b
  FROM t1
 WHERE (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,1,3,4,5
;

CREATE VIRTUAL VIEW V1690 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e,
       b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1691 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e,
       b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
 ORDER BY 4,3,2,5,1
;

CREATE VIRTUAL VIEW V1692 AS SELECT c,
       (a+b+c+d+e)/5,
       c-d,
       a-b,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a
  FROM t1
;

CREATE VIRTUAL VIEW V1693 AS SELECT c,
       (a+b+c+d+e)/5,
       c-d,
       a-b,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a
  FROM t1
 ORDER BY 2,4,6,1
;

CREATE VIRTUAL VIEW V1694 AS SELECT a-b,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3
  FROM t1
;

CREATE VIRTUAL VIEW V1695 AS SELECT a-b,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3
  FROM t1
 ORDER BY 4,1,3
;

CREATE VIRTUAL VIEW V1696 AS SELECT (a+b+c+d+e)/5,
       c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1697 AS SELECT (a+b+c+d+e)/5,
       c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V1698 AS SELECT (a+b+c+d+e)/5,
       c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1699 AS SELECT (a+b+c+d+e)/5,
       c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
 ORDER BY 4,1
;

CREATE VIRTUAL VIEW V1700 AS SELECT (a+b+c+d+e)/5,
       c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1701 AS SELECT (a+b+c+d+e)/5,
       c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
 ORDER BY 3,5
;

CREATE VIRTUAL VIEW V1702 AS SELECT (a+b+c+d+e)/5,
       c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1703 AS SELECT (a+b+c+d+e)/5,
       c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,1,3
;

CREATE VIRTUAL VIEW V1704 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       c-d,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
   AND a>b
;

CREATE VIRTUAL VIEW V1705 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       c-d,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
   AND a>b
 ORDER BY 3,2,1,4
;

CREATE VIRTUAL VIEW V1706 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       c-d,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND a>b
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1707 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       c-d,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND a>b
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,4,3
;

CREATE VIRTUAL VIEW V1708 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       b,
       abs(a),
       d,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1709 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       b,
       abs(a),
       d,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,5,4,2
;

CREATE VIRTUAL VIEW V1710 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       a+b*2+c*3+d*4,
       abs(a),
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
;

CREATE VIRTUAL VIEW V1711 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       a+b*2+c*3+d*4,
       abs(a),
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
 ORDER BY 3,2,1,5,4
;

CREATE VIRTUAL VIEW V1712 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       a+b*2+c*3+d*4,
       abs(a),
       a-b
  FROM t1
 WHERE b>c
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1713 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       a+b*2+c*3+d*4,
       abs(a),
       a-b
  FROM t1
 WHERE b>c
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,5
;

CREATE VIRTUAL VIEW V1714 AS SELECT e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
    OR b>c
;

CREATE VIRTUAL VIEW V1715 AS SELECT e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
    OR b>c
 ORDER BY 5,4,3,6,2,1,7
;

CREATE VIRTUAL VIEW V1716 AS SELECT e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1717 AS SELECT e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR (e>a AND e<b)
 ORDER BY 1,4,6,2,3,5
;

CREATE VIRTUAL VIEW V1718 AS SELECT e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1719 AS SELECT e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR (e>a AND e<b)
 ORDER BY 4,3,6,5,7,1
;

CREATE VIRTUAL VIEW V1720 AS SELECT e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
    OR b>c
;

CREATE VIRTUAL VIEW V1721 AS SELECT e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
    OR b>c
 ORDER BY 5,3
;

CREATE VIRTUAL VIEW V1722 AS SELECT a+b*2+c*3+d*4,
       b-c,
       c-d,
       a
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1723 AS SELECT a+b*2+c*3+d*4,
       b-c,
       c-d,
       a
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 3,4,2,1
;

CREATE VIRTUAL VIEW V1724 AS SELECT a+b*2+c*3+d*4,
       b-c,
       c-d,
       a
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1725 AS SELECT a+b*2+c*3+d*4,
       b-c,
       c-d,
       a
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V1726 AS SELECT a+b*2+c*3+d*4,
       b-c,
       c-d,
       a
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1727 AS SELECT a+b*2+c*3+d*4,
       b-c,
       c-d,
       a
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V1728 AS SELECT a+b*2+c*3+d*4,
       b-c,
       c-d,
       a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR b>c
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1729 AS SELECT a+b*2+c*3+d*4,
       b-c,
       c-d,
       a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR b>c
    OR (e>c OR e<d)
 ORDER BY 4,1,3
;

CREATE VIRTUAL VIEW V1730 AS SELECT abs(a),
       a,
       b-c
  FROM t1
;

CREATE VIRTUAL VIEW V1731 AS SELECT abs(a),
       a,
       b-c
  FROM t1
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V1732 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2,
       c,
       d,
       e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND b>c
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1733 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2,
       c,
       d,
       e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND b>c
   AND c BETWEEN b-2 AND d+2
 ORDER BY 5,1,4,2
;

CREATE VIRTUAL VIEW V1734 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2,
       c,
       d,
       e
  FROM t1
 WHERE b>c
   AND (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1735 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2,
       c,
       d,
       e
  FROM t1
 WHERE b>c
   AND (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 5,1,3
;

CREATE VIRTUAL VIEW V1736 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2,
       c,
       d,
       e
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1737 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2,
       c,
       d,
       e
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V1738 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       e,
       d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c
  FROM t1
;

CREATE VIRTUAL VIEW V1739 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       e,
       d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c
  FROM t1
 ORDER BY 4,2,1,6
;

CREATE VIRTUAL VIEW V1740 AS SELECT b-c,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       e
  FROM t1
 WHERE d>e
    OR a>b
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1741 AS SELECT b-c,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       e
  FROM t1
 WHERE d>e
    OR a>b
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 5,3
;

CREATE VIRTUAL VIEW V1742 AS SELECT b-c,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
    OR d>e
;

CREATE VIRTUAL VIEW V1743 AS SELECT b-c,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
    OR d>e
 ORDER BY 5,4
;

CREATE VIRTUAL VIEW V1744 AS SELECT b-c,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       e
  FROM t1
 WHERE a>b
    OR d>e
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1745 AS SELECT b-c,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       e
  FROM t1
 WHERE a>b
    OR d>e
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 6,1,3,5,7,4
;

CREATE VIRTUAL VIEW V1746 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1747 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,4,1,3
;

CREATE VIRTUAL VIEW V1748 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1749 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 3,2,1,4
;

CREATE VIRTUAL VIEW V1750 AS SELECT e,
       b
  FROM t1
;

CREATE VIRTUAL VIEW V1751 AS SELECT e,
       b
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1752 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
;

CREATE VIRTUAL VIEW V1753 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
 ORDER BY 5,1,2,3
;

CREATE VIRTUAL VIEW V1754 AS SELECT c-d,
       c,
       d,
       a-b,
       a+b*2+c*3+d*4+e*5,
       b-c
  FROM t1
;

CREATE VIRTUAL VIEW V1755 AS SELECT c-d,
       c,
       d,
       a-b,
       a+b*2+c*3+d*4+e*5,
       b-c
  FROM t1
 ORDER BY 5,2,4,1
;

CREATE VIRTUAL VIEW V1756 AS SELECT a,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
    OR b>c
;

CREATE VIRTUAL VIEW V1757 AS SELECT a,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
    OR b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1758 AS SELECT a,
       b-c
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1759 AS SELECT a,
       b-c
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1760 AS SELECT a,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1761 AS SELECT a,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1762 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1763 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V1764 AS SELECT a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1765 AS SELECT a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V1766 AS SELECT c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       c-d,
       d,
       abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1767 AS SELECT c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       c-d,
       d,
       abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V1768 AS SELECT c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       c-d,
       d,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1769 AS SELECT c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       c-d,
       d,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,6,1
;

CREATE VIRTUAL VIEW V1770 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE (e>a AND e<b)
    OR d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1771 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE (e>a AND e<b)
    OR d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
 ORDER BY 2,4,3,1
;

CREATE VIRTUAL VIEW V1772 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1773 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V1774 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1775 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
    OR (e>a AND e<b)
 ORDER BY 2,3,4,1
;

CREATE VIRTUAL VIEW V1776 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1777 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 4,1
;

CREATE VIRTUAL VIEW V1778 AS SELECT b
  FROM t1
 WHERE d>e
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1779 AS SELECT b
  FROM t1
 WHERE d>e
    OR (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1780 AS SELECT b
  FROM t1
 WHERE (e>c OR e<d)
    OR d>e
;

CREATE VIRTUAL VIEW V1781 AS SELECT b
  FROM t1
 WHERE (e>c OR e<d)
    OR d>e
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1782 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V1783 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V1784 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       b-c,
       a
  FROM t1
 WHERE a>b
    OR c>d
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1785 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       b-c,
       a
  FROM t1
 WHERE a>b
    OR c>d
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,3
;

CREATE VIRTUAL VIEW V1786 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       b-c,
       a
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
    OR c>d
;

CREATE VIRTUAL VIEW V1787 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       b-c,
       a
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
    OR c>d
 ORDER BY 3,1,4
;

CREATE VIRTUAL VIEW V1788 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       b-c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1789 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       b-c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,4
;

CREATE VIRTUAL VIEW V1790 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       b-c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b>c
;

CREATE VIRTUAL VIEW V1791 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       b-c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b>c
 ORDER BY 2,1,4,3
;

CREATE VIRTUAL VIEW V1792 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1793 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1794 AS SELECT c-d,
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       b
  FROM t1
;

CREATE VIRTUAL VIEW V1795 AS SELECT c-d,
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       b
  FROM t1
 ORDER BY 3,5,4,2,1
;

CREATE VIRTUAL VIEW V1796 AS SELECT d-e,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1797 AS SELECT d-e,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1798 AS SELECT d-e,
       c-d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1799 AS SELECT d-e,
       c-d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1800 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       d-e,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1801 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       d-e,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
    OR (a>b-2 AND a<b+2)
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V1802 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       d-e,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d>e
;

CREATE VIRTUAL VIEW V1803 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       d-e,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d>e
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V1804 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
;

CREATE VIRTUAL VIEW V1805 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
 ORDER BY 5,6,3,4,1
;

CREATE VIRTUAL VIEW V1806 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1807 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,5,4,3
;

CREATE VIRTUAL VIEW V1808 AS SELECT e,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       abs(a),
       d,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1809 AS SELECT e,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       abs(a),
       d,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
 ORDER BY 5,1,7,6,4,3,2
;

CREATE VIRTUAL VIEW V1810 AS SELECT e,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       abs(a),
       d,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1811 AS SELECT e,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       abs(a),
       d,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,3,1,5,4,6,7
;

CREATE VIRTUAL VIEW V1812 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1813 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1,4,3
;

CREATE VIRTUAL VIEW V1814 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIRTUAL VIEW V1815 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V1816 AS SELECT b,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1817 AS SELECT b,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
   AND (e>c OR e<d)
 ORDER BY 2,4,3
;

CREATE VIRTUAL VIEW V1818 AS SELECT b,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
   AND a>b
;

CREATE VIRTUAL VIEW V1819 AS SELECT b,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
   AND a>b
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V1820 AS SELECT b,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a>b
   AND (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1821 AS SELECT b,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a>b
   AND (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,1,3,4
;

CREATE VIRTUAL VIEW V1822 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1823 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1824 AS SELECT c,
       c-d,
       a-b,
       a+b*2+c*3,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V1825 AS SELECT c,
       c-d,
       a-b,
       a+b*2+c*3,
       abs(a)
  FROM t1
 ORDER BY 5,3,2,4,1
;

CREATE VIRTUAL VIEW V1826 AS SELECT b,
       abs(a),
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       a,
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR d>e
;

CREATE VIRTUAL VIEW V1827 AS SELECT b,
       abs(a),
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       a,
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR d>e
 ORDER BY 5,2,1,7,3,4
;

CREATE VIRTUAL VIEW V1828 AS SELECT b,
       abs(a),
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       a,
       c
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1829 AS SELECT b,
       abs(a),
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       a,
       c
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 5,4
;

CREATE VIRTUAL VIEW V1830 AS SELECT c-d
  FROM t1
;

CREATE VIRTUAL VIEW V1831 AS SELECT c-d
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1832 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       a+b*2,
       a,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V1833 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       a+b*2,
       a,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
 ORDER BY 1,4,2,6,7,3,5
;

CREATE VIRTUAL VIEW V1834 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V1835 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e
  FROM t1
 WHERE d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1836 AS SELECT (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1837 AS SELECT (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1838 AS SELECT abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
;

CREATE VIRTUAL VIEW V1839 AS SELECT abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 ORDER BY 3,1,4
;

CREATE VIRTUAL VIEW V1840 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1841 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
 ORDER BY 4,2,1,3
;

CREATE VIRTUAL VIEW V1842 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b>c
;

CREATE VIRTUAL VIEW V1843 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b>c
 ORDER BY 4,1,2,3,5
;

CREATE VIRTUAL VIEW V1844 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
    OR c>d
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1845 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
    OR c>d
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,6,1
;

CREATE VIRTUAL VIEW V1846 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
    OR c>d
;

CREATE VIRTUAL VIEW V1847 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
    OR c>d
 ORDER BY 1,4,6,5,3,2
;

CREATE VIRTUAL VIEW V1848 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       d,
       a+b*2,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1849 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       d,
       a+b*2,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 6,4,1,5,3
;

CREATE VIRTUAL VIEW V1850 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1851 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V1852 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V1853 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1854 AS SELECT d-e
  FROM t1
;

CREATE VIRTUAL VIEW V1855 AS SELECT d-e
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1856 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       d,
       a+b*2+c*3+d*4,
       a+b*2
  FROM t1
;

CREATE VIRTUAL VIEW V1857 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       d,
       a+b*2+c*3+d*4,
       a+b*2
  FROM t1
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V1858 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIRTUAL VIEW V1859 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 ORDER BY 5,2,1,3,4
;

CREATE VIRTUAL VIEW V1860 AS SELECT b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       (a+b+c+d+e)/5,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
;

CREATE VIRTUAL VIEW V1861 AS SELECT b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       (a+b+c+d+e)/5,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
 ORDER BY 4,5,2
;

CREATE VIRTUAL VIEW V1862 AS SELECT a
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1863 AS SELECT a
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1864 AS SELECT a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1865 AS SELECT a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1866 AS SELECT a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1867 AS SELECT a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1868 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1869 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1870 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR a>b
;

CREATE VIRTUAL VIEW V1871 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1872 AS SELECT c-d,
       abs(a),
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
    OR (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1873 AS SELECT c-d,
       abs(a),
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
    OR (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V1874 AS SELECT c-d,
       abs(a),
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR d>e
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1875 AS SELECT c-d,
       abs(a),
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR d>e
    OR (e>c OR e<d)
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V1876 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       d,
       a+b*2+c*3,
       a-b,
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1877 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       d,
       a+b*2+c*3,
       a-b,
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
 ORDER BY 5,7,2,6,1
;

CREATE VIRTUAL VIEW V1878 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       d,
       a+b*2+c*3,
       a-b,
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1879 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       d,
       a+b*2+c*3,
       a-b,
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 6,2,1,7
;

CREATE VIRTUAL VIEW V1880 AS SELECT d,
       (a+b+c+d+e)/5,
       e,
       a+b*2+c*3
  FROM t1
 WHERE c>d
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1881 AS SELECT d,
       (a+b+c+d+e)/5,
       e,
       a+b*2+c*3
  FROM t1
 WHERE c>d
   AND (e>a AND e<b)
 ORDER BY 3,1,4
;

CREATE VIRTUAL VIEW V1882 AS SELECT e,
       c-d,
       (a+b+c+d+e)/5,
       abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIRTUAL VIEW V1883 AS SELECT e,
       c-d,
       (a+b+c+d+e)/5,
       abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 2,5,3,6,7,4,1
;

CREATE VIRTUAL VIEW V1884 AS SELECT c-d,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V1885 AS SELECT c-d,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       d-e
  FROM t1
 ORDER BY 5,3,2,4
;

CREATE VIRTUAL VIEW V1886 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       b-c
  FROM t1
;

CREATE VIRTUAL VIEW V1887 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       b-c
  FROM t1
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V1888 AS SELECT c-d,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1889 AS SELECT c-d,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,1,5,3
;

CREATE VIRTUAL VIEW V1890 AS SELECT c-d,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
;

CREATE VIRTUAL VIEW V1891 AS SELECT c-d,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
 ORDER BY 1,4,3,2
;

CREATE VIRTUAL VIEW V1892 AS SELECT c,
       abs(b-c),
       c-d
  FROM t1
;

CREATE VIRTUAL VIEW V1893 AS SELECT c,
       abs(b-c),
       c-d
  FROM t1
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V1894 AS SELECT abs(b-c),
       a+b*2+c*3+d*4,
       a+b*2,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V1895 AS SELECT abs(b-c),
       a+b*2+c*3+d*4,
       a+b*2,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c>d
 ORDER BY 2,1,4,3
;

CREATE VIRTUAL VIEW V1896 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V1897 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V1898 AS SELECT c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1899 AS SELECT c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1900 AS SELECT c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1901 AS SELECT c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1902 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1903 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 4,2,1
;

CREATE VIRTUAL VIEW V1904 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1905 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V1906 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1907 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 3,4,1
;

CREATE VIRTUAL VIEW V1908 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V1909 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 4,1,3,2,5
;

CREATE VIRTUAL VIEW V1910 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1911 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,5,4
;

CREATE VIRTUAL VIEW V1912 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e,
       b-c,
       a
  FROM t1
;

CREATE VIRTUAL VIEW V1913 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e,
       b-c,
       a
  FROM t1
 ORDER BY 1,2,4,3,5
;

CREATE VIRTUAL VIEW V1914 AS SELECT e,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V1915 AS SELECT e,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V1916 AS SELECT a+b*2+c*3+d*4+e*5,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1917 AS SELECT a+b*2+c*3+d*4+e*5,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 6,2,1
;

CREATE VIRTUAL VIEW V1918 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       a
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
    OR a>b
;

CREATE VIRTUAL VIEW V1919 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       a
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
    OR a>b
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V1920 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
    OR a>b
;

CREATE VIRTUAL VIEW V1921 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
    OR a>b
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V1922 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
    OR d>e
;

CREATE VIRTUAL VIEW V1923 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
    OR d>e
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V1924 AS SELECT a+b*2+c*3,
       b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1925 AS SELECT a+b*2+c*3,
       b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V1926 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2,
       b-c
  FROM t1
;

CREATE VIRTUAL VIEW V1927 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2,
       b-c
  FROM t1
 ORDER BY 3,1,4
;

CREATE VIRTUAL VIEW V1928 AS SELECT (a+b+c+d+e)/5,
       abs(b-c)
  FROM t1
 WHERE d>e
   AND b>c
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1929 AS SELECT (a+b+c+d+e)/5,
       abs(b-c)
  FROM t1
 WHERE d>e
   AND b>c
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1930 AS SELECT (a+b+c+d+e)/5,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
   AND d>e
;

CREATE VIRTUAL VIEW V1931 AS SELECT (a+b+c+d+e)/5,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
   AND d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1932 AS SELECT (a+b+c+d+e)/5,
       abs(b-c)
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND b>c
;

CREATE VIRTUAL VIEW V1933 AS SELECT (a+b+c+d+e)/5,
       abs(b-c)
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1934 AS SELECT abs(a),
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1935 AS SELECT abs(a),
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,4,3
;

CREATE VIRTUAL VIEW V1936 AS SELECT d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1937 AS SELECT d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
   AND (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1938 AS SELECT d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
   AND d>e
;

CREATE VIRTUAL VIEW V1939 AS SELECT d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
   AND d>e
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1940 AS SELECT d
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1941 AS SELECT d
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1942 AS SELECT d
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1943 AS SELECT d
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1944 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a-b,
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1945 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a-b,
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
 ORDER BY 1,4,2
;

CREATE VIRTUAL VIEW V1946 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a-b,
       b-c
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1947 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a-b,
       b-c
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V1948 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
   AND a>b
;

CREATE VIRTUAL VIEW V1949 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
   AND a>b
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V1950 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
   AND b>c
;

CREATE VIRTUAL VIEW V1951 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
   AND b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1952 AS SELECT d,
       abs(b-c)
  FROM t1
;

CREATE VIRTUAL VIEW V1953 AS SELECT d,
       abs(b-c)
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1954 AS SELECT abs(b-c),
       c-d,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       a-b,
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1955 AS SELECT abs(b-c),
       c-d,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       a-b,
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 7,6,5,3
;

CREATE VIRTUAL VIEW V1956 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       d-e,
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1957 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       d-e,
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 3,5,2,4
;

CREATE VIRTUAL VIEW V1958 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a>b
   AND c>d
;

CREATE VIRTUAL VIEW V1959 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a>b
   AND c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1960 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110 AND 150
   AND c>d
;

CREATE VIRTUAL VIEW V1961 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110 AND 150
   AND c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1962 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
   AND d NOT BETWEEN 110 AND 150
   AND a>b
;

CREATE VIRTUAL VIEW V1963 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
   AND d NOT BETWEEN 110 AND 150
   AND a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1964 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
    OR c>d
;

CREATE VIRTUAL VIEW V1965 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
    OR c>d
 ORDER BY 3,6,5,1
;

CREATE VIRTUAL VIEW V1966 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       b-c
  FROM t1
 WHERE c>d
    OR (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1967 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       b-c
  FROM t1
 WHERE c>d
    OR (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1,3,4,6,5,2
;

CREATE VIRTUAL VIEW V1968 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (a>b-2 AND a<b+2)
    OR c>d
;

CREATE VIRTUAL VIEW V1969 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (a>b-2 AND a<b+2)
    OR c>d
 ORDER BY 5,1
;

CREATE VIRTUAL VIEW V1970 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIRTUAL VIEW V1971 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 2,4,1,3
;

CREATE VIRTUAL VIEW V1972 AS SELECT b-c,
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V1973 AS SELECT b-c,
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V1974 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       abs(b-c),
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
;

CREATE VIRTUAL VIEW V1975 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       abs(b-c),
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
 ORDER BY 5,2,1,3
;

CREATE VIRTUAL VIEW V1976 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       abs(b-c),
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1977 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       abs(b-c),
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,4,3
;

CREATE VIRTUAL VIEW V1978 AS SELECT a,
       a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V1979 AS SELECT a,
       a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V1980 AS SELECT a+b*2+c*3+d*4,
       a,
       e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3
  FROM t1
 WHERE b>c
    OR d>e
;

CREATE VIRTUAL VIEW V1981 AS SELECT a+b*2+c*3+d*4,
       a,
       e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3
  FROM t1
 WHERE b>c
    OR d>e
 ORDER BY 2,1,3,5,6,4
;

CREATE VIRTUAL VIEW V1982 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V1983 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       abs(a)
  FROM t1
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V1984 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V1985 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V1986 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1987 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 5,2,3,6,4,1
;

CREATE VIRTUAL VIEW V1988 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V1989 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 4,1,5
;

CREATE VIRTUAL VIEW V1990 AS SELECT a+b*2+c*3+d*4,
       e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1991 AS SELECT a+b*2+c*3+d*4,
       e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 5,3,2,4,1
;

CREATE VIRTUAL VIEW V1992 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
;

CREATE VIRTUAL VIEW V1993 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
 ORDER BY 3,2,4,5,1
;

CREATE VIRTUAL VIEW V1994 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V1995 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,1,2,5
;

CREATE VIRTUAL VIEW V1996 AS SELECT a+b*2+c*3,
       abs(a),
       a+b*2,
       b,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V1997 AS SELECT a+b*2+c*3,
       abs(a),
       a+b*2,
       b,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,3,5
;

CREATE VIRTUAL VIEW V1998 AS SELECT c-d,
       a+b*2+c*3+d*4,
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V1999 AS SELECT c-d,
       a+b*2+c*3+d*4,
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V2000 AS SELECT c-d,
       a+b*2+c*3+d*4,
       b
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2001 AS SELECT c-d,
       a+b*2+c*3+d*4,
       b
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V2002 AS SELECT a-b,
       a+b*2,
       a
  FROM t1
 WHERE d>e
    OR b>c
;

CREATE VIRTUAL VIEW V2003 AS SELECT a-b,
       a+b*2,
       a
  FROM t1
 WHERE d>e
    OR b>c
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V2004 AS SELECT a-b,
       a+b*2,
       a
  FROM t1
 WHERE b>c
    OR d>e
;

CREATE VIRTUAL VIEW V2005 AS SELECT a-b,
       a+b*2,
       a
  FROM t1
 WHERE b>c
    OR d>e
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V2006 AS SELECT e,
       b,
       a+b*2+c*3,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
;

CREATE VIRTUAL VIEW V2007 AS SELECT e,
       b,
       a+b*2+c*3,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
 ORDER BY 5,4,3,6,2
;

CREATE VIRTUAL VIEW V2008 AS SELECT e,
       b,
       a+b*2+c*3,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c>d
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2009 AS SELECT e,
       b,
       a+b*2+c*3,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c>d
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2010 AS SELECT a
  FROM t1
;

CREATE VIRTUAL VIEW V2011 AS SELECT a
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2012 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2013 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2014 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
;

CREATE VIRTUAL VIEW V2015 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
 ORDER BY 4,2,3,1
;

CREATE VIRTUAL VIEW V2016 AS SELECT d-e,
       e,
       b,
       c,
       abs(b-c),
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
    OR a>b
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2017 AS SELECT d-e,
       e,
       b,
       c,
       abs(b-c),
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
    OR a>b
    OR (e>c OR e<d)
 ORDER BY 2,1,6,3
;

CREATE VIRTUAL VIEW V2018 AS SELECT d-e,
       e,
       b,
       c,
       abs(b-c),
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR a>b
;

CREATE VIRTUAL VIEW V2019 AS SELECT d-e,
       e,
       b,
       c,
       abs(b-c),
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR a>b
 ORDER BY 4,7,1,2,6
;

CREATE VIRTUAL VIEW V2020 AS SELECT d-e,
       e,
       b,
       c,
       abs(b-c),
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
    OR a>b
    OR b>c
;

CREATE VIRTUAL VIEW V2021 AS SELECT d-e,
       e,
       b,
       c,
       abs(b-c),
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
    OR a>b
    OR b>c
 ORDER BY 7,2,6,1,5,4,3
;

CREATE VIRTUAL VIEW V2022 AS SELECT c,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       d-e
  FROM t1
 WHERE c>d
   AND e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2023 AS SELECT c,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       d-e
  FROM t1
 WHERE c>d
   AND e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
 ORDER BY 4,5,6
;

CREATE VIRTUAL VIEW V2024 AS SELECT c,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
   AND c>d
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2025 AS SELECT c,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
   AND c>d
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,6,2,1,5,3
;

CREATE VIRTUAL VIEW V2026 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V2027 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
 ORDER BY 4,2,1
;

CREATE VIRTUAL VIEW V2028 AS SELECT b
  FROM t1
;

CREATE VIRTUAL VIEW V2029 AS SELECT b
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2030 AS SELECT d,
       a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND d>e
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2031 AS SELECT d,
       a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND d>e
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2032 AS SELECT d,
       a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c BETWEEN b-2 AND d+2
   AND d>e
;

CREATE VIRTUAL VIEW V2033 AS SELECT d,
       a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c BETWEEN b-2 AND d+2
   AND d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2034 AS SELECT d,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
   AND d>e
;

CREATE VIRTUAL VIEW V2035 AS SELECT d,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
   AND d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2036 AS SELECT a+b*2+c*3+d*4,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>a AND e<b)
    OR b>c
;

CREATE VIRTUAL VIEW V2037 AS SELECT a+b*2+c*3+d*4,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>a AND e<b)
    OR b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2038 AS SELECT a+b*2+c*3+d*4,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b>c
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2039 AS SELECT a+b*2+c*3+d*4,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b>c
    OR (e>a AND e<b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2040 AS SELECT a+b*2,
       abs(b-c)
  FROM t1
;

CREATE VIRTUAL VIEW V2041 AS SELECT a+b*2,
       abs(b-c)
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2042 AS SELECT a+b*2+c*3+d*4,
       e,
       abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V2043 AS SELECT a+b*2+c*3+d*4,
       e,
       abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d
  FROM t1
 WHERE c>d
 ORDER BY 1,2,3,5,4
;

CREATE VIRTUAL VIEW V2044 AS SELECT abs(b-c),
       d-e,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2045 AS SELECT abs(b-c),
       d-e,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,3,4,2
;

CREATE VIRTUAL VIEW V2046 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a-b,
       b-c,
       abs(b-c),
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2047 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a-b,
       b-c,
       abs(b-c),
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 6,1,5,4
;

CREATE VIRTUAL VIEW V2048 AS SELECT abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2049 AS SELECT abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2050 AS SELECT abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2051 AS SELECT abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>a AND e<b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2052 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2053 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2054 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2055 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1,5,3,4
;

CREATE VIRTUAL VIEW V2056 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR b>c
;

CREATE VIRTUAL VIEW V2057 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR b>c
 ORDER BY 4,2,5,3
;

CREATE VIRTUAL VIEW V2058 AS SELECT a+b*2+c*3+d*4,
       abs(b-c),
       (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND b>c
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2059 AS SELECT a+b*2+c*3+d*4,
       abs(b-c),
       (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND b>c
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2060 AS SELECT a+b*2+c*3+d*4,
       abs(b-c),
       (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
   AND b>c
;

CREATE VIRTUAL VIEW V2061 AS SELECT a+b*2+c*3+d*4,
       abs(b-c),
       (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
   AND b>c
 ORDER BY 4,3,2
;

CREATE VIRTUAL VIEW V2062 AS SELECT a+b*2+c*3+d*4,
       abs(b-c),
       (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2063 AS SELECT a+b*2+c*3+d*4,
       abs(b-c),
       (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 3,1,4
;

CREATE VIRTUAL VIEW V2064 AS SELECT e,
       d-e,
       abs(a),
       b-c,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V2065 AS SELECT e,
       d-e,
       abs(a),
       b-c,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 5,3,4
;

CREATE VIRTUAL VIEW V2066 AS SELECT a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2067 AS SELECT a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2068 AS SELECT a+b*2,
       d,
       e,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
    OR d>e
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2069 AS SELECT a+b*2,
       d,
       e,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
    OR d>e
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,4
;

CREATE VIRTUAL VIEW V2070 AS SELECT a+b*2,
       d,
       e,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR a>b
    OR d>e
;

CREATE VIRTUAL VIEW V2071 AS SELECT a+b*2,
       d,
       e,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR a>b
    OR d>e
 ORDER BY 1,3,2,5,4
;

CREATE VIRTUAL VIEW V2072 AS SELECT a+b*2,
       d,
       e,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
    OR (c<=d-2 OR c>=d+2)
    OR a>b
;

CREATE VIRTUAL VIEW V2073 AS SELECT a+b*2,
       d,
       e,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
    OR (c<=d-2 OR c>=d+2)
    OR a>b
 ORDER BY 1,2,5,4,3
;

CREATE VIRTUAL VIEW V2074 AS SELECT b,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       e
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2075 AS SELECT b,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       e
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V2076 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2077 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V2078 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2079 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,4,1,5
;

CREATE VIRTUAL VIEW V2080 AS SELECT c-d,
       c,
       abs(a),
       a+b*2+c*3
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2081 AS SELECT c-d,
       c,
       abs(a),
       a+b*2+c*3
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
 ORDER BY 2,4,3,1
;

CREATE VIRTUAL VIEW V2082 AS SELECT c-d,
       c,
       abs(a),
       a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2083 AS SELECT c-d,
       c,
       abs(a),
       a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V2084 AS SELECT a+b*2+c*3+d*4,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
;

CREATE VIRTUAL VIEW V2085 AS SELECT a+b*2+c*3+d*4,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
 ORDER BY 3,1,5,4
;

CREATE VIRTUAL VIEW V2086 AS SELECT b-c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2087 AS SELECT b-c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V2088 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4+e*5,
       a,
       b-c,
       c-d,
       abs(a)
  FROM t1
 WHERE d>e
    OR (a>b-2 AND a<b+2)
    OR c>d
;

CREATE VIRTUAL VIEW V2089 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4+e*5,
       a,
       b-c,
       c-d,
       abs(a)
  FROM t1
 WHERE d>e
    OR (a>b-2 AND a<b+2)
    OR c>d
 ORDER BY 7,6,2
;

CREATE VIRTUAL VIEW V2090 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4+e*5,
       a,
       b-c,
       c-d,
       abs(a)
  FROM t1
 WHERE d>e
    OR c>d
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2091 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4+e*5,
       a,
       b-c,
       c-d,
       abs(a)
  FROM t1
 WHERE d>e
    OR c>d
    OR (a>b-2 AND a<b+2)
 ORDER BY 4,3,5
;

CREATE VIRTUAL VIEW V2092 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4+e*5,
       a,
       b-c,
       c-d,
       abs(a)
  FROM t1
 WHERE c>d
    OR d>e
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2093 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4+e*5,
       a,
       b-c,
       c-d,
       abs(a)
  FROM t1
 WHERE c>d
    OR d>e
    OR (a>b-2 AND a<b+2)
 ORDER BY 7,1,3,2,6,5
;

CREATE VIRTUAL VIEW V2094 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V2095 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       abs(a)
  FROM t1
 ORDER BY 1,2,5,4,3
;

CREATE VIRTUAL VIEW V2096 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2097 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2098 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       b
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V2099 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       b
  FROM t1
 WHERE c>d
 ORDER BY 2,4,5,6
;

CREATE VIRTUAL VIEW V2100 AS SELECT a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2101 AS SELECT a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2102 AS SELECT a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2103 AS SELECT a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2104 AS SELECT a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2105 AS SELECT a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2106 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2107 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 7,4,3,5,2,1
;

CREATE VIRTUAL VIEW V2108 AS SELECT a+b*2+c*3+d*4,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND a>b
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2109 AS SELECT a+b*2+c*3+d*4,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND a>b
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2110 AS SELECT a+b*2+c*3+d*4,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2111 AS SELECT a+b*2+c*3+d*4,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,1,3,4
;

CREATE VIRTUAL VIEW V2112 AS SELECT a+b*2+c*3+d*4,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
   AND a>b
;

CREATE VIRTUAL VIEW V2113 AS SELECT a+b*2+c*3+d*4,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
   AND a>b
 ORDER BY 2,4,3,1
;

CREATE VIRTUAL VIEW V2114 AS SELECT a+b*2+c*3+d*4,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2115 AS SELECT a+b*2+c*3+d*4,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,1,4
;

CREATE VIRTUAL VIEW V2116 AS SELECT e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
;

CREATE VIRTUAL VIEW V2117 AS SELECT e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2118 AS SELECT e
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2119 AS SELECT e
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2120 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR e+d BETWEEN a+b-10 AND c+130
    OR b>c
;

CREATE VIRTUAL VIEW V2121 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR e+d BETWEEN a+b-10 AND c+130
    OR b>c
 ORDER BY 4,1
;

CREATE VIRTUAL VIEW V2122 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR b>c
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2123 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR b>c
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 5,2,1,4,3
;

CREATE VIRTUAL VIEW V2124 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2125 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,5,3,4,2
;

CREATE VIRTUAL VIEW V2126 AS SELECT d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
;

CREATE VIRTUAL VIEW V2127 AS SELECT d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2128 AS SELECT d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2129 AS SELECT d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2130 AS SELECT d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2131 AS SELECT d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
    OR (e>a AND e<b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2132 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR a>b
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2133 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR a>b
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V2134 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2135 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V2136 AS SELECT c,
       d,
       a+b*2+c*3+d*4+e*5,
       d-e,
       b-c,
       a+b*2
  FROM t1
;

CREATE VIRTUAL VIEW V2137 AS SELECT c,
       d,
       a+b*2+c*3+d*4+e*5,
       d-e,
       b-c,
       a+b*2
  FROM t1
 ORDER BY 5,4,3
;

CREATE VIRTUAL VIEW V2138 AS SELECT b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       a+b*2+c*3+d*4+e*5,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d
  FROM t1
;

CREATE VIRTUAL VIEW V2139 AS SELECT b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       a+b*2+c*3+d*4+e*5,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d
  FROM t1
 ORDER BY 1,6,5,4,7,2
;

CREATE VIRTUAL VIEW V2140 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       c,
       c-d
  FROM t1
 WHERE (e>a AND e<b)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2141 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       c,
       c-d
  FROM t1
 WHERE (e>a AND e<b)
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,4,6,5,3
;

CREATE VIRTUAL VIEW V2142 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2143 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V2144 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR a>b
;

CREATE VIRTUAL VIEW V2145 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR a>b
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V2146 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2147 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,6,4,3,5
;

CREATE VIRTUAL VIEW V2148 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2149 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 6,4,2,5,3
;

CREATE VIRTUAL VIEW V2150 AS SELECT (a+b+c+d+e)/5,
       abs(a),
       abs(b-c),
       a+b*2,
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2151 AS SELECT (a+b+c+d+e)/5,
       abs(a),
       abs(b-c),
       a+b*2,
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 3,2,1,4,5
;

CREATE VIRTUAL VIEW V2152 AS SELECT e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
;

CREATE VIRTUAL VIEW V2153 AS SELECT e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2154 AS SELECT e
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2155 AS SELECT e
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2156 AS SELECT a+b*2,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2157 AS SELECT a+b*2,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2158 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2159 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V2160 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2161 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2162 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       a+b*2+c*3+d*4,
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2163 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       a+b*2+c*3+d*4,
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 3,7
;

CREATE VIRTUAL VIEW V2164 AS SELECT a+b*2+c*3,
       d,
       a+b*2,
       c-d,
       e,
       b-c
  FROM t1
;

CREATE VIRTUAL VIEW V2165 AS SELECT a+b*2+c*3,
       d,
       a+b*2,
       c-d,
       e,
       b-c
  FROM t1
 ORDER BY 4,2,5
;

CREATE VIRTUAL VIEW V2166 AS SELECT a+b*2+c*3+d*4,
       abs(a),
       d-e
  FROM t1
 WHERE (e>a AND e<b)
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2167 AS SELECT a+b*2+c*3+d*4,
       abs(a),
       d-e
  FROM t1
 WHERE (e>a AND e<b)
   AND (e>c OR e<d)
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V2168 AS SELECT a+b*2+c*3+d*4,
       abs(a),
       d-e
  FROM t1
 WHERE (e>c OR e<d)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2169 AS SELECT a+b*2+c*3+d*4,
       abs(a),
       d-e
  FROM t1
 WHERE (e>c OR e<d)
   AND (e>a AND e<b)
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V2170 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       d-e,
       c
  FROM t1
;

CREATE VIRTUAL VIEW V2171 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       d-e,
       c
  FROM t1
 ORDER BY 3,2,1,4
;

CREATE VIRTUAL VIEW V2172 AS SELECT d-e
  FROM t1
;

CREATE VIRTUAL VIEW V2173 AS SELECT d-e
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2174 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
;

CREATE VIRTUAL VIEW V2175 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V2176 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND b>c
;

CREATE VIRTUAL VIEW V2177 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND b>c
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V2178 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2179 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V2180 AS SELECT c,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2181 AS SELECT c,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
 ORDER BY 3,1,5,2,4
;

CREATE VIRTUAL VIEW V2182 AS SELECT c,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2183 AS SELECT c,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
 ORDER BY 3,4,5,1
;

CREATE VIRTUAL VIEW V2184 AS SELECT d-e,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2185 AS SELECT d-e,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2186 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b>c
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2187 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b>c
   AND (e>a AND e<b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2188 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2189 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2190 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
   AND b>c
;

CREATE VIRTUAL VIEW V2191 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
   AND b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2192 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIRTUAL VIEW V2193 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2194 AS SELECT c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2195 AS SELECT c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2196 AS SELECT c-d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2197 AS SELECT c-d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2198 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
    OR c>d
;

CREATE VIRTUAL VIEW V2199 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
    OR c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2200 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 WHERE b>c
    OR c>d
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2201 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 WHERE b>c
    OR c>d
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2202 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 WHERE c>d
    OR b>c
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2203 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 WHERE c>d
    OR b>c
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2204 AS SELECT d-e,
       a,
       e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2205 AS SELECT d-e,
       a,
       e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V2206 AS SELECT a+b*2
  FROM t1
;

CREATE VIRTUAL VIEW V2207 AS SELECT a+b*2
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2208 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d>e
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2209 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d>e
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V2210 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       b-c
  FROM t1
 WHERE d>e
   AND (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2211 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       b-c
  FROM t1
 WHERE d>e
   AND (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2212 AS SELECT d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       a+b*2+c*3+d*4,
       a,
       a+b*2+c*3,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V2213 AS SELECT d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       a+b*2+c*3+d*4,
       a,
       a+b*2+c*3,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
 ORDER BY 5,6,2,4
;

CREATE VIRTUAL VIEW V2214 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       a+b*2+c*3+d*4,
       a
  FROM t1
;

CREATE VIRTUAL VIEW V2215 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       a+b*2+c*3+d*4,
       a
  FROM t1
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V2216 AS SELECT a+b*2+c*3,
       a-b,
       e,
       d-e
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V2217 AS SELECT a+b*2+c*3,
       a-b,
       e,
       d-e
  FROM t1
 WHERE b>c
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V2218 AS SELECT a+b*2+c*3,
       abs(b-c),
       e,
       (a+b+c+d+e)/5,
       b,
       d,
       c-d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
;

CREATE VIRTUAL VIEW V2219 AS SELECT a+b*2+c*3,
       abs(b-c),
       e,
       (a+b+c+d+e)/5,
       b,
       d,
       c-d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
 ORDER BY 2,6,3,1,5,4,7
;

CREATE VIRTUAL VIEW V2220 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       a+b*2+c*3+d*4,
       a,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2221 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       a+b*2+c*3+d*4,
       a,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,5,1,3,2
;

CREATE VIRTUAL VIEW V2222 AS SELECT (a+b+c+d+e)/5,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       c-d,
       a+b*2
  FROM t1
 WHERE d>e
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2223 AS SELECT (a+b+c+d+e)/5,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       c-d,
       a+b*2
  FROM t1
 WHERE d>e
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,6
;

CREATE VIRTUAL VIEW V2224 AS SELECT (a+b+c+d+e)/5,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       c-d,
       a+b*2
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
;

CREATE VIRTUAL VIEW V2225 AS SELECT (a+b+c+d+e)/5,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       c-d,
       a+b*2
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V2226 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V2227 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V2228 AS SELECT b-c,
       c-d,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIRTUAL VIEW V2229 AS SELECT b-c,
       c-d,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 ORDER BY 1,3,4
;

CREATE VIRTUAL VIEW V2230 AS SELECT a-b,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIRTUAL VIEW V2231 AS SELECT a-b,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 4,2
;

CREATE VIRTUAL VIEW V2232 AS SELECT d,
       b-c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2233 AS SELECT d,
       b-c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V2234 AS SELECT d,
       b-c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
   AND (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2235 AS SELECT d,
       b-c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
   AND (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V2236 AS SELECT d,
       b-c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
   AND d>e
;

CREATE VIRTUAL VIEW V2237 AS SELECT d,
       b-c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
   AND d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2238 AS SELECT a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2239 AS SELECT a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V2240 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2+c*3+d*4+e*5,
       abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
;

CREATE VIRTUAL VIEW V2241 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2+c*3+d*4+e*5,
       abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
 ORDER BY 1,5,3,6,2
;

CREATE VIRTUAL VIEW V2242 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2+c*3+d*4+e*5,
       abs(a)
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2243 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2+c*3+d*4+e*5,
       abs(a)
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2244 AS SELECT e
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2245 AS SELECT e
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2246 AS SELECT e
  FROM t1
 WHERE d>e
   AND d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2247 AS SELECT e
  FROM t1
 WHERE d>e
   AND d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2248 AS SELECT e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
   AND d>e
;

CREATE VIRTUAL VIEW V2249 AS SELECT e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
   AND d>e
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2250 AS SELECT e
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
   AND d>e
;

CREATE VIRTUAL VIEW V2251 AS SELECT e
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
   AND d>e
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2252 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2253 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>a AND e<b)
 ORDER BY 1,5,4,3,6,2
;

CREATE VIRTUAL VIEW V2254 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE (e>a AND e<b)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2255 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE (e>a AND e<b)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 6,1,5,2
;

CREATE VIRTUAL VIEW V2256 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2257 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2258 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       abs(b-c),
       b
  FROM t1
;

CREATE VIRTUAL VIEW V2259 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       abs(b-c),
       b
  FROM t1
 ORDER BY 2,4,1,3,5
;

CREATE VIRTUAL VIEW V2260 AS SELECT a+b*2,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V2261 AS SELECT a+b*2,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 2,3,4
;

CREATE VIRTUAL VIEW V2262 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2263 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2264 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
   AND a>b
;

CREATE VIRTUAL VIEW V2265 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
   AND a>b
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V2266 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2267 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V2268 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIRTUAL VIEW V2269 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 ORDER BY 2,3,1,4
;

CREATE VIRTUAL VIEW V2270 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       a+b*2+c*3+d*4+e*5,
       b
  FROM t1
;

CREATE VIRTUAL VIEW V2271 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       a+b*2+c*3+d*4+e*5,
       b
  FROM t1
 ORDER BY 3,5
;

CREATE VIRTUAL VIEW V2272 AS SELECT a+b*2+c*3+d*4+e*5,
       a-b,
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2273 AS SELECT a+b*2+c*3+d*4+e*5,
       a-b,
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2274 AS SELECT a,
       abs(a),
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIRTUAL VIEW V2275 AS SELECT a,
       abs(a),
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V2276 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       b-c,
       a,
       d-e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
    OR d>e
;

CREATE VIRTUAL VIEW V2277 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       b-c,
       a,
       d-e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
    OR d>e
 ORDER BY 3,5,4,2
;

CREATE VIRTUAL VIEW V2278 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       b-c,
       a,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
    OR d>e
;

CREATE VIRTUAL VIEW V2279 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       b-c,
       a,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
    OR d>e
 ORDER BY 3,2,5,1,4
;

CREATE VIRTUAL VIEW V2280 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       b-c,
       a,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d>e
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2281 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       b-c,
       a,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d>e
    OR c BETWEEN b-2 AND d+2
 ORDER BY 5,3
;

CREATE VIRTUAL VIEW V2282 AS SELECT a,
       (a+b+c+d+e)/5,
       b-c,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V2283 AS SELECT a,
       (a+b+c+d+e)/5,
       b-c,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a>b
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2284 AS SELECT a+b*2
  FROM t1
 WHERE b>c
    OR a>b
;

CREATE VIRTUAL VIEW V2285 AS SELECT a+b*2
  FROM t1
 WHERE b>c
    OR a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2286 AS SELECT a+b*2
  FROM t1
 WHERE a>b
    OR b>c
;

CREATE VIRTUAL VIEW V2287 AS SELECT a+b*2
  FROM t1
 WHERE a>b
    OR b>c
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2288 AS SELECT b-c,
       a+b*2,
       a+b*2+c*3+d*4,
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V2289 AS SELECT b-c,
       a+b*2,
       a+b*2+c*3+d*4,
       d-e
  FROM t1
 ORDER BY 4,3
;

CREATE VIRTUAL VIEW V2290 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V2291 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V2292 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
   AND d>e
;

CREATE VIRTUAL VIEW V2293 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
   AND d>e
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2294 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
   AND c>d
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2295 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
   AND c>d
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2296 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND d>e
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2297 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND d>e
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2298 AS SELECT b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V2299 AS SELECT b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2300 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIRTUAL VIEW V2301 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2302 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2303 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 5,4,2
;

CREATE VIRTUAL VIEW V2304 AS SELECT a-b,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V2305 AS SELECT a-b,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       abs(a)
  FROM t1
 ORDER BY 4,2
;

CREATE VIRTUAL VIEW V2306 AS SELECT abs(a),
       a+b*2+c*3+d*4,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       a-b,
       e
  FROM t1
 WHERE (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
   AND c>d
;

CREATE VIRTUAL VIEW V2307 AS SELECT abs(a),
       a+b*2+c*3+d*4,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       a-b,
       e
  FROM t1
 WHERE (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
   AND c>d
 ORDER BY 5,3,1,4,2,6
;

CREATE VIRTUAL VIEW V2308 AS SELECT abs(a),
       a+b*2+c*3+d*4,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       a-b,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
   AND c>d
;

CREATE VIRTUAL VIEW V2309 AS SELECT abs(a),
       a+b*2+c*3+d*4,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       a-b,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
   AND c>d
 ORDER BY 6,5,4,7,1,3
;

CREATE VIRTUAL VIEW V2310 AS SELECT abs(a),
       a+b*2+c*3+d*4,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       a-b,
       e
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2311 AS SELECT abs(a),
       a+b*2+c*3+d*4,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       a-b,
       e
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2,3,6,7,4,5
;

CREATE VIRTUAL VIEW V2312 AS SELECT a-b,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2313 AS SELECT a-b,
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2314 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2315 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2316 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2317 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2318 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2319 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2320 AS SELECT (a+b+c+d+e)/5,
       b,
       abs(b-c),
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2321 AS SELECT (a+b+c+d+e)/5,
       b,
       abs(b-c),
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,4,5,1,2
;

CREATE VIRTUAL VIEW V2322 AS SELECT (a+b+c+d+e)/5,
       b,
       abs(b-c),
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2323 AS SELECT (a+b+c+d+e)/5,
       b,
       abs(b-c),
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 5,4,3
;

CREATE VIRTUAL VIEW V2324 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       c
  FROM t1
 WHERE (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2325 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       c
  FROM t1
 WHERE (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 2,4,3,1
;

CREATE VIRTUAL VIEW V2326 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2327 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
 ORDER BY 1,4,2
;

CREATE VIRTUAL VIEW V2328 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
    OR a>b
;

CREATE VIRTUAL VIEW V2329 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
    OR a>b
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V2330 AS SELECT d,
       e,
       a+b*2+c*3+d*4+e*5,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2331 AS SELECT d,
       e,
       a+b*2+c*3+d*4+e*5,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 5,6,4
;

CREATE VIRTUAL VIEW V2332 AS SELECT (a+b+c+d+e)/5,
       d,
       c-d,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR c>d
;

CREATE VIRTUAL VIEW V2333 AS SELECT (a+b+c+d+e)/5,
       d,
       c-d,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR c>d
 ORDER BY 3,2,4,1
;

CREATE VIRTUAL VIEW V2334 AS SELECT (a+b+c+d+e)/5,
       d,
       c-d,
       abs(b-c)
  FROM t1
 WHERE c>d
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2335 AS SELECT (a+b+c+d+e)/5,
       d,
       c-d,
       abs(b-c)
  FROM t1
 WHERE c>d
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,4,2
;

CREATE VIRTUAL VIEW V2336 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2337 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 5,4
;

CREATE VIRTUAL VIEW V2338 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
   AND d>e
;

CREATE VIRTUAL VIEW V2339 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
   AND d>e
 ORDER BY 6,3,4
;

CREATE VIRTUAL VIEW V2340 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2341 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2342 AS SELECT abs(a),
       abs(b-c)
  FROM t1
;

CREATE VIRTUAL VIEW V2343 AS SELECT abs(a),
       abs(b-c)
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2344 AS SELECT abs(b-c),
       d,
       d-e,
       c-d,
       e
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V2345 AS SELECT abs(b-c),
       d,
       d-e,
       c-d,
       e
  FROM t1
 WHERE a>b
 ORDER BY 4,1,5,2
;

CREATE VIRTUAL VIEW V2346 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2347 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,1,3,2
;

CREATE VIRTUAL VIEW V2348 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2349 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 4,2,3
;

CREATE VIRTUAL VIEW V2350 AS SELECT a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIRTUAL VIEW V2351 AS SELECT a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V2352 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2353 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2354 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR b>c
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2355 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR b>c
    OR (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2356 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
    OR b>c
;

CREATE VIRTUAL VIEW V2357 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
    OR b>c
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2358 AS SELECT a,
       a+b*2,
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2359 AS SELECT a,
       a+b*2,
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2360 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       d,
       a,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
;

CREATE VIRTUAL VIEW V2361 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       d,
       a,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 ORDER BY 6,5,3,4,1,2
;

CREATE VIRTUAL VIEW V2362 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
;

CREATE VIRTUAL VIEW V2363 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
 ORDER BY 4,5,1,2
;

CREATE VIRTUAL VIEW V2364 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2365 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V2366 AS SELECT (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       abs(a)
  FROM t1
 WHERE c>d
    OR d>e
;

CREATE VIRTUAL VIEW V2367 AS SELECT (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       abs(a)
  FROM t1
 WHERE c>d
    OR d>e
 ORDER BY 1,3,4
;

CREATE VIRTUAL VIEW V2368 AS SELECT b-c,
       a+b*2,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2369 AS SELECT b-c,
       a+b*2,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,4,2
;

CREATE VIRTUAL VIEW V2370 AS SELECT b-c,
       a+b*2,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2371 AS SELECT b-c,
       a+b*2,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,1,3,4
;

CREATE VIRTUAL VIEW V2372 AS SELECT b-c,
       a+b*2,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2373 AS SELECT b-c,
       a+b*2,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 4,2,1,3
;

CREATE VIRTUAL VIEW V2374 AS SELECT b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2375 AS SELECT b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2376 AS SELECT a+b*2,
       e
  FROM t1
;

CREATE VIRTUAL VIEW V2377 AS SELECT a+b*2,
       e
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2378 AS SELECT (a+b+c+d+e)/5,
       a,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2379 AS SELECT (a+b+c+d+e)/5,
       a,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2380 AS SELECT (a+b+c+d+e)/5,
       a,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
   AND c>d
;

CREATE VIRTUAL VIEW V2381 AS SELECT (a+b+c+d+e)/5,
       a,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
   AND c>d
 ORDER BY 3,2,4
;

CREATE VIRTUAL VIEW V2382 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2383 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2384 AS SELECT a-b,
       (a+b+c+d+e)/5,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE b>c
   AND c>d
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2385 AS SELECT a-b,
       (a+b+c+d+e)/5,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE b>c
   AND c>d
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 5,2,7,3,4
;

CREATE VIRTUAL VIEW V2386 AS SELECT a-b,
       (a+b+c+d+e)/5,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE c>d
   AND b>c
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2387 AS SELECT a-b,
       (a+b+c+d+e)/5,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE c>d
   AND b>c
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 5,4
;

CREATE VIRTUAL VIEW V2388 AS SELECT a-b,
       (a+b+c+d+e)/5,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND b>c
   AND c>d
;

CREATE VIRTUAL VIEW V2389 AS SELECT a-b,
       (a+b+c+d+e)/5,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       abs(a)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND b>c
   AND c>d
 ORDER BY 4,6,3,1,7,2,5
;

CREATE VIRTUAL VIEW V2390 AS SELECT e,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V2391 AS SELECT e,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2392 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       d-e,
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       a+b*2+c*3
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V2393 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       d-e,
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       a+b*2+c*3
  FROM t1
 WHERE c>d
 ORDER BY 2,3,7,5,4,6
;

CREATE VIRTUAL VIEW V2394 AS SELECT e,
       c,
       c-d,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIRTUAL VIEW V2395 AS SELECT e,
       c,
       c-d,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2396 AS SELECT a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIRTUAL VIEW V2397 AS SELECT a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 1,4,5,6
;

CREATE VIRTUAL VIEW V2398 AS SELECT (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2399 AS SELECT (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2400 AS SELECT a-b
  FROM t1
;

CREATE VIRTUAL VIEW V2401 AS SELECT a-b
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2402 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2403 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V2404 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
   AND a>b
;

CREATE VIRTUAL VIEW V2405 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
   AND a>b
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V2406 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2407 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V2408 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a),
       b,
       e,
       a+b*2,
       b-c
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2409 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a),
       b,
       e,
       a+b*2,
       b-c
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 7,3,5,2,4,1
;

CREATE VIRTUAL VIEW V2410 AS SELECT e,
       d,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2411 AS SELECT e,
       d,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V2412 AS SELECT e,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
    OR d>e
;

CREATE VIRTUAL VIEW V2413 AS SELECT e,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
    OR d>e
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V2414 AS SELECT e,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
    OR d>e
;

CREATE VIRTUAL VIEW V2415 AS SELECT e,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
    OR d>e
 ORDER BY 3,2,4,5,1
;

CREATE VIRTUAL VIEW V2416 AS SELECT e,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE d>e
    OR a>b
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2417 AS SELECT e,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE d>e
    OR a>b
    OR (a>b-2 AND a<b+2)
 ORDER BY 4,2,3,1
;

CREATE VIRTUAL VIEW V2418 AS SELECT b-c,
       d,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE b>c
   AND d NOT BETWEEN 110 AND 150
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2419 AS SELECT b-c,
       d,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE b>c
   AND d NOT BETWEEN 110 AND 150
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 4,3
;

CREATE VIRTUAL VIEW V2420 AS SELECT b-c,
       d,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b>c
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2421 AS SELECT b-c,
       d,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b>c
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 4,1,2,7
;

CREATE VIRTUAL VIEW V2422 AS SELECT b-c,
       d,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
   AND b>c
;

CREATE VIRTUAL VIEW V2423 AS SELECT b-c,
       d,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
   AND b>c
 ORDER BY 4,1,5,6,2
;

CREATE VIRTUAL VIEW V2424 AS SELECT b-c,
       d,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE b>c
   AND (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2425 AS SELECT b-c,
       d,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE b>c
   AND (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,2,5,3,7,4,6
;

CREATE VIRTUAL VIEW V2426 AS SELECT c-d,
       b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2427 AS SELECT c-d,
       b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2428 AS SELECT a+b*2
  FROM t1
;

CREATE VIRTUAL VIEW V2429 AS SELECT a+b*2
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2430 AS SELECT e,
       b-c,
       a-b
  FROM t1
;

CREATE VIRTUAL VIEW V2431 AS SELECT e,
       b-c,
       a-b
  FROM t1
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2432 AS SELECT c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2433 AS SELECT c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,4,1,2
;

CREATE VIRTUAL VIEW V2434 AS SELECT c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
;

CREATE VIRTUAL VIEW V2435 AS SELECT c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
 ORDER BY 4,3,2,1
;

CREATE VIRTUAL VIEW V2436 AS SELECT c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d>e
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2437 AS SELECT c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d>e
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>a AND e<b)
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V2438 AS SELECT abs(a),
       d,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
   AND c>d
;

CREATE VIRTUAL VIEW V2439 AS SELECT abs(a),
       d,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
   AND c>d
 ORDER BY 3,2,1,4,5
;

CREATE VIRTUAL VIEW V2440 AS SELECT abs(a),
       d,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
   AND a>b
;

CREATE VIRTUAL VIEW V2441 AS SELECT abs(a),
       d,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
   AND a>b
 ORDER BY 3,5,1,2,4
;

CREATE VIRTUAL VIEW V2442 AS SELECT abs(a),
       d,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE c>d
   AND a>b
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2443 AS SELECT abs(a),
       d,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE c>d
   AND a>b
   AND c BETWEEN b-2 AND d+2
 ORDER BY 5,1,2,4,3
;

CREATE VIRTUAL VIEW V2444 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2445 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V2446 AS SELECT a+b*2+c*3+d*4,
       a,
       e,
       a+b*2+c*3+d*4+e*5,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V2447 AS SELECT a+b*2+c*3+d*4,
       a,
       e,
       a+b*2+c*3+d*4+e*5,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
 ORDER BY 4,3,6
;

CREATE VIRTUAL VIEW V2448 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
 WHERE a>b
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2449 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
 WHERE a>b
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2450 AS SELECT d,
       abs(b-c),
       a+b*2
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2451 AS SELECT d,
       abs(b-c),
       a+b*2
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V2452 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2453 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2454 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2455 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2456 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a
  FROM t1
;

CREATE VIRTUAL VIEW V2457 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a
  FROM t1
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V2458 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       (a+b+c+d+e)/5,
       e
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2459 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       (a+b+c+d+e)/5,
       e
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,4,3
;

CREATE VIRTUAL VIEW V2460 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       (a+b+c+d+e)/5,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2461 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       (a+b+c+d+e)/5,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
 ORDER BY 1,3,4
;

CREATE VIRTUAL VIEW V2462 AS SELECT b-c,
       abs(b-c),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V2463 AS SELECT b-c,
       abs(b-c),
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE a>b
 ORDER BY 3,2,1,4
;

CREATE VIRTUAL VIEW V2464 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2465 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2466 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2467 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2468 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d>e
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2469 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d>e
   AND (e>c OR e<d)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2470 AS SELECT a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2471 AS SELECT a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2472 AS SELECT (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
;

CREATE VIRTUAL VIEW V2473 AS SELECT (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2474 AS SELECT (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2475 AS SELECT (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2476 AS SELECT abs(a),
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIRTUAL VIEW V2477 AS SELECT abs(a),
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 4,2,3,5,1
;

CREATE VIRTUAL VIEW V2478 AS SELECT c-d,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIRTUAL VIEW V2479 AS SELECT c-d,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 4,2,3,5
;

CREATE VIRTUAL VIEW V2480 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2481 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2482 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
;

CREATE VIRTUAL VIEW V2483 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2484 AS SELECT a,
       c,
       c-d,
       (a+b+c+d+e)/5,
       e,
       d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2485 AS SELECT a,
       c,
       c-d,
       (a+b+c+d+e)/5,
       e,
       d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 3,6,1,5,2,4
;

CREATE VIRTUAL VIEW V2486 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       abs(a),
       b
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V2487 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       abs(a),
       b
  FROM t1
 WHERE d>e
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V2488 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       b-c,
       d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2489 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       b-c,
       d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,4,7,6,5,1,2
;

CREATE VIRTUAL VIEW V2490 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       b-c,
       d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2491 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       b-c,
       d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 7,6,4,3,2,5
;

CREATE VIRTUAL VIEW V2492 AS SELECT abs(a),
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2493 AS SELECT abs(a),
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2494 AS SELECT abs(a),
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2495 AS SELECT abs(a),
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,2,5
;

CREATE VIRTUAL VIEW V2496 AS SELECT b-c,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       a+b*2,
       d
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V2497 AS SELECT b-c,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       a+b*2,
       d
  FROM t1
 WHERE b>c
 ORDER BY 4,5,2
;

CREATE VIRTUAL VIEW V2498 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2499 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2500 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2501 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,5,2
;

CREATE VIRTUAL VIEW V2502 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2503 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
 ORDER BY 4,5
;

CREATE VIRTUAL VIEW V2504 AS SELECT a+b*2+c*3,
       a,
       a+b*2+c*3+d*4+e*5,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       b
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2505 AS SELECT a+b*2+c*3,
       a,
       a+b*2+c*3+d*4+e*5,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       b
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 7,5,1
;

CREATE VIRTUAL VIEW V2506 AS SELECT a+b*2,
       d,
       a+b*2+c*3+d*4+e*5,
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2507 AS SELECT a+b*2,
       d,
       a+b*2+c*3+d*4+e*5,
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2508 AS SELECT a+b*2+c*3+d*4,
       b-c,
       e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2509 AS SELECT a+b*2+c*3+d*4,
       b-c,
       e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,4,2
;

CREATE VIRTUAL VIEW V2510 AS SELECT a+b*2+c*3+d*4,
       b-c,
       e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2511 AS SELECT a+b*2+c*3+d*4,
       b-c,
       e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
 ORDER BY 5,1,2,4
;

CREATE VIRTUAL VIEW V2512 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       d-e,
       e,
       d
  FROM t1
;

CREATE VIRTUAL VIEW V2513 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       d-e,
       e,
       d
  FROM t1
 ORDER BY 3,2,4
;

CREATE VIRTUAL VIEW V2514 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2515 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
 ORDER BY 2,5,3,4,1
;

CREATE VIRTUAL VIEW V2516 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2517 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 5,4,3,1
;

CREATE VIRTUAL VIEW V2518 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2519 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 5,3,4,1,2
;

CREATE VIRTUAL VIEW V2520 AS SELECT c,
       d,
       a
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2521 AS SELECT c,
       d,
       a
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V2522 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE (e>a AND e<b)
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2523 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE (e>a AND e<b)
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V2524 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE (e>c OR e<d)
   AND (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2525 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE (e>c OR e<d)
   AND (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V2526 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2527 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
   AND (e>a AND e<b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2528 AS SELECT a+b*2+c*3+d*4+e*5,
       b,
       abs(b-c),
       abs(a),
       a+b*2+c*3+d*4,
       a+b*2
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V2529 AS SELECT a+b*2+c*3+d*4+e*5,
       b,
       abs(b-c),
       abs(a),
       a+b*2+c*3+d*4,
       a+b*2
  FROM t1
 WHERE b>c
 ORDER BY 4,5,6,3,1,2
;

CREATE VIRTUAL VIEW V2530 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2531 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2532 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2533 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2534 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2535 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2536 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2537 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V2538 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5,
       b,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V2539 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5,
       b,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a)
  FROM t1
 ORDER BY 5,4,3
;

CREATE VIRTUAL VIEW V2540 AS SELECT c
  FROM t1
;

CREATE VIRTUAL VIEW V2541 AS SELECT c
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2542 AS SELECT a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2543 AS SELECT a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2544 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
    OR b>c
;

CREATE VIRTUAL VIEW V2545 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
    OR b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2546 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
    OR d>e
;

CREATE VIRTUAL VIEW V2547 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
    OR d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2548 AS SELECT a+b*2+c*3,
       a,
       d,
       a+b*2,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V2549 AS SELECT a+b*2+c*3,
       a,
       d,
       a+b*2,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 1,5,7
;

CREATE VIRTUAL VIEW V2550 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2551 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V2552 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       abs(b-c),
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2
  FROM t1
;

CREATE VIRTUAL VIEW V2553 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       abs(b-c),
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2
  FROM t1
 ORDER BY 7,4,6,2,3,1,5
;

CREATE VIRTUAL VIEW V2554 AS SELECT abs(b-c)
  FROM t1
 WHERE c>d
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2555 AS SELECT abs(b-c)
  FROM t1
 WHERE c>d
    OR (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2556 AS SELECT abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
    OR c>d
;

CREATE VIRTUAL VIEW V2557 AS SELECT abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
    OR c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2558 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIRTUAL VIEW V2559 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2560 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       b-c,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2561 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       b-c,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 5,1,4,3,2
;

CREATE VIRTUAL VIEW V2562 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V2563 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2564 AS SELECT (a+b+c+d+e)/5,
       b,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2565 AS SELECT (a+b+c+d+e)/5,
       b,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V2566 AS SELECT (a+b+c+d+e)/5,
       b,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2567 AS SELECT (a+b+c+d+e)/5,
       b,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V2568 AS SELECT b,
       a+b*2+c*3+d*4+e*5,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2569 AS SELECT b,
       a+b*2+c*3+d*4+e*5,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,5,1
;

CREATE VIRTUAL VIEW V2570 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       c-d
  FROM t1
;

CREATE VIRTUAL VIEW V2571 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       c-d
  FROM t1
 ORDER BY 5,7,3,1
;

CREATE VIRTUAL VIEW V2572 AS SELECT d-e,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V2573 AS SELECT d-e,
       abs(a)
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2574 AS SELECT b-c,
       abs(b-c),
       d-e,
       d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
;

CREATE VIRTUAL VIEW V2575 AS SELECT b-c,
       abs(b-c),
       d-e,
       d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
 ORDER BY 2,3,4
;

CREATE VIRTUAL VIEW V2576 AS SELECT b-c,
       abs(b-c),
       d-e,
       d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2577 AS SELECT b-c,
       abs(b-c),
       d-e,
       d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,4
;

CREATE VIRTUAL VIEW V2578 AS SELECT b-c,
       a+b*2+c*3,
       a+b*2,
       c-d,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND d>e
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2579 AS SELECT b-c,
       a+b*2+c*3,
       a+b*2,
       c-d,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND d>e
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,1,5,3,6
;

CREATE VIRTUAL VIEW V2580 AS SELECT b-c,
       a+b*2+c*3,
       a+b*2,
       c-d,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
   AND d>e
;

CREATE VIRTUAL VIEW V2581 AS SELECT b-c,
       a+b*2+c*3,
       a+b*2,
       c-d,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
   AND d>e
 ORDER BY 1,4,3,5,6
;

CREATE VIRTUAL VIEW V2582 AS SELECT b-c,
       a+b*2+c*3,
       a+b*2,
       c-d,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE d>e
   AND e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2583 AS SELECT b-c,
       a+b*2+c*3,
       a+b*2,
       c-d,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE d>e
   AND e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 3,6,5,2,4
;

CREATE VIRTUAL VIEW V2584 AS SELECT b-c,
       a+b*2+c*3,
       a+b*2,
       c-d,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND d>e
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2585 AS SELECT b-c,
       a+b*2+c*3,
       a+b*2,
       c-d,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND d>e
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 6,4,5,2,3,1
;

CREATE VIRTUAL VIEW V2586 AS SELECT b,
       abs(a),
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIRTUAL VIEW V2587 AS SELECT b,
       abs(a),
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V2588 AS SELECT a+b*2+c*3+d*4+e*5,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a-b
  FROM t1
 WHERE c>d
   AND b>c
;

CREATE VIRTUAL VIEW V2589 AS SELECT a+b*2+c*3+d*4+e*5,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a-b
  FROM t1
 WHERE c>d
   AND b>c
 ORDER BY 1,4,3,2
;

CREATE VIRTUAL VIEW V2590 AS SELECT a+b*2+c*3+d*4+e*5,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a-b
  FROM t1
 WHERE b>c
   AND c>d
;

CREATE VIRTUAL VIEW V2591 AS SELECT a+b*2+c*3+d*4+e*5,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a-b
  FROM t1
 WHERE b>c
   AND c>d
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V2592 AS SELECT b,
       a+b*2
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR b>c
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2593 AS SELECT b,
       a+b*2
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR b>c
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2594 AS SELECT b,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
    OR b>c
;

CREATE VIRTUAL VIEW V2595 AS SELECT b,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
    OR b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2596 AS SELECT b,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b>c
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2597 AS SELECT b,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b>c
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2598 AS SELECT b,
       a+b*2
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
    OR b>c
;

CREATE VIRTUAL VIEW V2599 AS SELECT b,
       a+b*2
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
    OR b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2600 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       (a+b+c+d+e)/5,
       d
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2601 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       (a+b+c+d+e)/5,
       d
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 3,2,4,1
;

CREATE VIRTUAL VIEW V2602 AS SELECT a-b
  FROM t1
 WHERE (e>c OR e<d)
   AND a>b
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2603 AS SELECT a-b
  FROM t1
 WHERE (e>c OR e<d)
   AND a>b
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2604 AS SELECT a-b
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
   AND a>b
;

CREATE VIRTUAL VIEW V2605 AS SELECT a-b
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
   AND a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2606 AS SELECT a-b
  FROM t1
 WHERE a>b
   AND (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2607 AS SELECT a-b
  FROM t1
 WHERE a>b
   AND (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2608 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c,
       b,
       e,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2609 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c,
       b,
       e,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,4,3,5,2,6
;

CREATE VIRTUAL VIEW V2610 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c,
       b,
       e,
       a+b*2+c*3+d*4
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2611 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c,
       b,
       e,
       a+b*2+c*3+d*4
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,6
;

CREATE VIRTUAL VIEW V2612 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c,
       b,
       e,
       a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2613 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       c,
       b,
       e,
       a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,2,1
;

CREATE VIRTUAL VIEW V2614 AS SELECT d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
   AND c>d
;

CREATE VIRTUAL VIEW V2615 AS SELECT d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
   AND c>d
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2616 AS SELECT d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
   AND c>d
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2617 AS SELECT d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
   AND c>d
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2618 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIRTUAL VIEW V2619 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V2620 AS SELECT d-e,
       b
  FROM t1
;

CREATE VIRTUAL VIEW V2621 AS SELECT d-e,
       b
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2622 AS SELECT abs(b-c),
       abs(a),
       d-e,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE a>b
   AND c>d
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2623 AS SELECT abs(b-c),
       abs(a),
       d-e,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE a>b
   AND c>d
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,1,5,2
;

CREATE VIRTUAL VIEW V2624 AS SELECT abs(b-c),
       abs(a),
       d-e,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2 AND d+2
   AND c>d
;

CREATE VIRTUAL VIEW V2625 AS SELECT abs(b-c),
       abs(a),
       d-e,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2 AND d+2
   AND c>d
 ORDER BY 3,1,5,2
;

CREATE VIRTUAL VIEW V2626 AS SELECT abs(b-c),
       abs(a),
       d-e,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
   AND c>d
;

CREATE VIRTUAL VIEW V2627 AS SELECT abs(b-c),
       abs(a),
       d-e,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
   AND c>d
 ORDER BY 5,1,4
;

CREATE VIRTUAL VIEW V2628 AS SELECT abs(b-c),
       abs(a),
       d-e,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE c>d
   AND c BETWEEN b-2 AND d+2
   AND a>b
;

CREATE VIRTUAL VIEW V2629 AS SELECT abs(b-c),
       abs(a),
       d-e,
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE c>d
   AND c BETWEEN b-2 AND d+2
   AND a>b
 ORDER BY 4,1,3
;

CREATE VIRTUAL VIEW V2630 AS SELECT d-e
  FROM t1
;

CREATE VIRTUAL VIEW V2631 AS SELECT d-e
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2632 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       a+b*2+c*3+d*4,
       a,
       abs(b-c)
  FROM t1
;

CREATE VIRTUAL VIEW V2633 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       a+b*2+c*3+d*4,
       a,
       abs(b-c)
  FROM t1
 ORDER BY 2,4,1
;

CREATE VIRTUAL VIEW V2634 AS SELECT c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2635 AS SELECT c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
   AND (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2636 AS SELECT c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2637 AS SELECT c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2638 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR a>b
;

CREATE VIRTUAL VIEW V2639 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2640 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2641 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
    OR (e>a AND e<b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2642 AS SELECT abs(a),
       d-e,
       a+b*2+c*3,
       abs(b-c),
       b
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110 AND 150
    OR c>d
;

CREATE VIRTUAL VIEW V2643 AS SELECT abs(a),
       d-e,
       a+b*2+c*3,
       abs(b-c),
       b
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110 AND 150
    OR c>d
 ORDER BY 4,1,5
;

CREATE VIRTUAL VIEW V2644 AS SELECT abs(a),
       d-e,
       a+b*2+c*3,
       abs(b-c),
       b
  FROM t1
 WHERE d>e
    OR c>d
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2645 AS SELECT abs(a),
       d-e,
       a+b*2+c*3,
       abs(b-c),
       b
  FROM t1
 WHERE d>e
    OR c>d
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1,2,4
;

CREATE VIRTUAL VIEW V2646 AS SELECT abs(a),
       d-e,
       a+b*2+c*3,
       abs(b-c),
       b
  FROM t1
 WHERE c>d
    OR d NOT BETWEEN 110 AND 150
    OR d>e
;

CREATE VIRTUAL VIEW V2647 AS SELECT abs(a),
       d-e,
       a+b*2+c*3,
       abs(b-c),
       b
  FROM t1
 WHERE c>d
    OR d NOT BETWEEN 110 AND 150
    OR d>e
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V2648 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2649 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 4,1,5,2,6,3
;

CREATE VIRTUAL VIEW V2650 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2651 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2652 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2653 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 5,6,2,3,1,4
;

CREATE VIRTUAL VIEW V2654 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2655 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
 ORDER BY 4,6,5,1,3,2
;

CREATE VIRTUAL VIEW V2656 AS SELECT d,
       c-d,
       a+b*2+c*3,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIRTUAL VIEW V2657 AS SELECT d,
       c-d,
       a+b*2+c*3,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 2,5,6,3,1
;

CREATE VIRTUAL VIEW V2658 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       a,
       b,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c>d
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2659 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       a,
       b,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c>d
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,6
;

CREATE VIRTUAL VIEW V2660 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       a,
       b,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
;

CREATE VIRTUAL VIEW V2661 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       a,
       b,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
 ORDER BY 7,4,3,5,2,6,1
;

CREATE VIRTUAL VIEW V2662 AS SELECT a+b*2+c*3+d*4+e*5,
       b-c,
       abs(a),
       d,
       abs(b-c),
       c,
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V2663 AS SELECT a+b*2+c*3+d*4+e*5,
       b-c,
       abs(a),
       d,
       abs(b-c),
       c,
       d-e
  FROM t1
 ORDER BY 4,3,5,2,6,7
;

CREATE VIRTUAL VIEW V2664 AS SELECT a+b*2,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2665 AS SELECT a+b*2,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 4,5
;

CREATE VIRTUAL VIEW V2666 AS SELECT a+b*2,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       c-d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2667 AS SELECT a+b*2,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       c-d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 5,2
;

CREATE VIRTUAL VIEW V2668 AS SELECT a+b*2,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2669 AS SELECT a+b*2,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
 ORDER BY 1,3,5,4
;

CREATE VIRTUAL VIEW V2670 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       c-d,
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2671 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       c-d,
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 1,5,2,3,4
;

CREATE VIRTUAL VIEW V2672 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d>e
    OR b>c
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2673 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d>e
    OR b>c
    OR c BETWEEN b-2 AND d+2
 ORDER BY 3,2,4
;

CREATE VIRTUAL VIEW V2674 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b>c
    OR d>e
;

CREATE VIRTUAL VIEW V2675 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b>c
    OR d>e
 ORDER BY 1,4,2
;

CREATE VIRTUAL VIEW V2676 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d>e
    OR b>c
;

CREATE VIRTUAL VIEW V2677 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d>e
    OR b>c
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2678 AS SELECT b,
       a+b*2+c*3+d*4,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       a+b*2,
       a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2679 AS SELECT b,
       a+b*2+c*3+d*4,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       a+b*2,
       a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 5,6,1,3,7
;

CREATE VIRTUAL VIEW V2680 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2681 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 2,4
;

CREATE VIRTUAL VIEW V2682 AS SELECT abs(a),
       a+b*2,
       a+b*2+c*3,
       (a+b+c+d+e)/5,
       c,
       d,
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2683 AS SELECT abs(a),
       a+b*2,
       a+b*2+c*3,
       (a+b+c+d+e)/5,
       c,
       d,
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1,3,2,6,5,7,4
;

CREATE VIRTUAL VIEW V2684 AS SELECT a
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2685 AS SELECT a
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2686 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       b-c
  FROM t1
;

CREATE VIRTUAL VIEW V2687 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       b-c
  FROM t1
 ORDER BY 3,1,4,2
;

CREATE VIRTUAL VIEW V2688 AS SELECT abs(a),
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
   AND a>b
;

CREATE VIRTUAL VIEW V2689 AS SELECT abs(a),
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
   AND a>b
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2690 AS SELECT abs(a),
       a+b*2
  FROM t1
 WHERE a>b
   AND b>c
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2691 AS SELECT abs(a),
       a+b*2
  FROM t1
 WHERE a>b
   AND b>c
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2692 AS SELECT abs(a),
       a+b*2
  FROM t1
 WHERE b>c
   AND a>b
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2693 AS SELECT abs(a),
       a+b*2
  FROM t1
 WHERE b>c
   AND a>b
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2694 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
;

CREATE VIRTUAL VIEW V2695 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2696 AS SELECT abs(b-c),
       a+b*2+c*3+d*4+e*5,
       b,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d>e
;

CREATE VIRTUAL VIEW V2697 AS SELECT abs(b-c),
       a+b*2+c*3+d*4+e*5,
       b,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d>e
 ORDER BY 4,2
;

CREATE VIRTUAL VIEW V2698 AS SELECT abs(b-c),
       a+b*2+c*3+d*4+e*5,
       b,
       d-e
  FROM t1
 WHERE d>e
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2699 AS SELECT abs(b-c),
       a+b*2+c*3+d*4+e*5,
       b,
       d-e
  FROM t1
 WHERE d>e
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 4,1,3
;

CREATE VIRTUAL VIEW V2700 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V2701 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 3,5,1
;

CREATE VIRTUAL VIEW V2702 AS SELECT e,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       a
  FROM t1
;

CREATE VIRTUAL VIEW V2703 AS SELECT e,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       a
  FROM t1
 ORDER BY 4,2,3,5
;

CREATE VIRTUAL VIEW V2704 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2705 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V2706 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
;

CREATE VIRTUAL VIEW V2707 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2708 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       d-e,
       abs(b-c),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2709 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       d-e,
       abs(b-c),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
 ORDER BY 3,4,6
;

CREATE VIRTUAL VIEW V2710 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       d-e,
       abs(b-c),
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2711 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       d-e,
       abs(b-c),
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 6,4
;

CREATE VIRTUAL VIEW V2712 AS SELECT d-e,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       a+b*2+c*3+d*4,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V2713 AS SELECT d-e,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       a+b*2+c*3+d*4,
       abs(a)
  FROM t1
 ORDER BY 7,6,2,1,3,4
;

CREATE VIRTUAL VIEW V2714 AS SELECT c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       abs(a),
       d
  FROM t1
;

CREATE VIRTUAL VIEW V2715 AS SELECT c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       abs(a),
       d
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2716 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2717 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2718 AS SELECT a,
       d-e,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR b>c
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2719 AS SELECT a,
       d-e,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR b>c
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2720 AS SELECT a,
       d-e,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b>c
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2721 AS SELECT a,
       d-e,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b>c
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,4
;

CREATE VIRTUAL VIEW V2722 AS SELECT e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c)
  FROM t1
;

CREATE VIRTUAL VIEW V2723 AS SELECT e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c)
  FROM t1
 ORDER BY 1,3,5,6,4,2
;

CREATE VIRTUAL VIEW V2724 AS SELECT a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2725 AS SELECT a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2726 AS SELECT a+b*2+c*3
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2727 AS SELECT a+b*2+c*3
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2728 AS SELECT a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2729 AS SELECT a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2730 AS SELECT a+b*2+c*3,
       a+b*2,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2731 AS SELECT a+b*2+c*3,
       a+b*2,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V2732 AS SELECT d-e,
       d,
       a+b*2,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       e
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V2733 AS SELECT d-e,
       d,
       a+b*2,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       e
  FROM t1
 WHERE a>b
 ORDER BY 1,5,7,6,4,3
;

CREATE VIRTUAL VIEW V2734 AS SELECT a,
       d-e,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2735 AS SELECT a,
       d-e,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V2736 AS SELECT e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
;

CREATE VIRTUAL VIEW V2737 AS SELECT e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2738 AS SELECT e
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2739 AS SELECT e
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2740 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       a-b
  FROM t1
 WHERE d>e
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2741 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       a-b
  FROM t1
 WHERE d>e
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,4
;

CREATE VIRTUAL VIEW V2742 AS SELECT d,
       a+b*2,
       abs(a),
       abs(b-c),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2743 AS SELECT d,
       a+b*2,
       abs(a),
       abs(b-c),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,5,3,1,4,6
;

CREATE VIRTUAL VIEW V2744 AS SELECT d,
       a+b*2,
       abs(a),
       abs(b-c),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
    OR d>e
;

CREATE VIRTUAL VIEW V2745 AS SELECT d,
       a+b*2,
       abs(a),
       abs(b-c),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
    OR d>e
 ORDER BY 5,1,6,2
;

CREATE VIRTUAL VIEW V2746 AS SELECT d,
       a+b*2,
       abs(a),
       abs(b-c),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2747 AS SELECT d,
       a+b*2,
       abs(a),
       abs(b-c),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
    OR (e>a AND e<b)
 ORDER BY 2,3,4,1,5
;

CREATE VIRTUAL VIEW V2748 AS SELECT d,
       a+b*2,
       abs(a),
       abs(b-c),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2749 AS SELECT d,
       a+b*2,
       abs(a),
       abs(b-c),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
    OR (e>a AND e<b)
 ORDER BY 3,4,1,5
;

CREATE VIRTUAL VIEW V2750 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       abs(b-c),
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIRTUAL VIEW V2751 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       abs(b-c),
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 6,4,2,5
;

CREATE VIRTUAL VIEW V2752 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       a+b*2+c*3,
       abs(b-c),
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a>b
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2753 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       a+b*2+c*3,
       abs(b-c),
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a>b
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 4,6,5,3
;

CREATE VIRTUAL VIEW V2754 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5,
       d-e,
       a+b*2+c*3,
       a+b*2,
       e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2755 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5,
       d-e,
       a+b*2+c*3,
       a+b*2,
       e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
 ORDER BY 1,5,4,6
;

CREATE VIRTUAL VIEW V2756 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5,
       d-e,
       a+b*2+c*3,
       a+b*2,
       e
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2757 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5,
       d-e,
       a+b*2+c*3,
       a+b*2,
       e
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 6,1,2
;

CREATE VIRTUAL VIEW V2758 AS SELECT b-c,
       e,
       d,
       abs(a),
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V2759 AS SELECT b-c,
       e,
       d,
       abs(a),
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 1,6,5,2,3,7
;

CREATE VIRTUAL VIEW V2760 AS SELECT a,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2761 AS SELECT a,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,5,1,4,3
;

CREATE VIRTUAL VIEW V2762 AS SELECT b-c,
       b,
       a-b,
       c-d,
       d-e,
       e
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V2763 AS SELECT b-c,
       b,
       a-b,
       c-d,
       d-e,
       e
  FROM t1
 WHERE b>c
 ORDER BY 3,1,4,2,6,5
;

CREATE VIRTUAL VIEW V2764 AS SELECT abs(a),
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
;

CREATE VIRTUAL VIEW V2765 AS SELECT abs(a),
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2766 AS SELECT abs(a),
       d-e
  FROM t1
 WHERE b>c
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2767 AS SELECT abs(a),
       d-e
  FROM t1
 WHERE b>c
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2768 AS SELECT a,
       b-c
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2769 AS SELECT a,
       b-c
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2770 AS SELECT a+b*2+c*3+d*4,
       abs(a),
       abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIRTUAL VIEW V2771 AS SELECT a+b*2+c*3+d*4,
       abs(a),
       abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 2,1,6
;

CREATE VIRTUAL VIEW V2772 AS SELECT a+b*2+c*3+d*4,
       b-c
  FROM t1
;

CREATE VIRTUAL VIEW V2773 AS SELECT a+b*2+c*3+d*4,
       b-c
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2774 AS SELECT a,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2775 AS SELECT a,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2776 AS SELECT a,
       a+b*2+c*3+d*4+e*5,
       d-e,
       b-c,
       abs(a),
       a+b*2,
       b
  FROM t1
;

CREATE VIRTUAL VIEW V2777 AS SELECT a,
       a+b*2+c*3+d*4+e*5,
       d-e,
       b-c,
       abs(a),
       a+b*2,
       b
  FROM t1
 ORDER BY 4,2,3,6,1,5,7
;

CREATE VIRTUAL VIEW V2778 AS SELECT a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIRTUAL VIEW V2779 AS SELECT a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V2780 AS SELECT a-b,
       e,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2781 AS SELECT a-b,
       e,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V2782 AS SELECT a-b,
       e,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2783 AS SELECT a-b,
       e,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,1
;

CREATE VIRTUAL VIEW V2784 AS SELECT a-b,
       e,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2785 AS SELECT a-b,
       e,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 4,3,1,2
;

CREATE VIRTUAL VIEW V2786 AS SELECT d,
       a+b*2+c*3+d*4,
       e,
       (a+b+c+d+e)/5,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIRTUAL VIEW V2787 AS SELECT d,
       a+b*2+c*3+d*4,
       e,
       (a+b+c+d+e)/5,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 4,6,5,1,2,3
;

CREATE VIRTUAL VIEW V2788 AS SELECT abs(b-c),
       abs(a),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V2789 AS SELECT abs(b-c),
       abs(a),
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
 WHERE b>c
 ORDER BY 4,1
;

CREATE VIRTUAL VIEW V2790 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a),
       a-b,
       d,
       a+b*2+c*3
  FROM t1
;

CREATE VIRTUAL VIEW V2791 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a),
       a-b,
       d,
       a+b*2+c*3
  FROM t1
 ORDER BY 4,3,5,6,2,7,1
;

CREATE VIRTUAL VIEW V2792 AS SELECT b-c,
       d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
;

CREATE VIRTUAL VIEW V2793 AS SELECT b-c,
       d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
 ORDER BY 2,3,1,5
;

CREATE VIRTUAL VIEW V2794 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2795 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2796 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2797 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2798 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2799 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 6,2
;

CREATE VIRTUAL VIEW V2800 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
    OR d>e
;

CREATE VIRTUAL VIEW V2801 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
    OR d>e
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V2802 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2803 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V2804 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
    OR (c<=d-2 OR c>=d+2)
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2805 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
    OR (c<=d-2 OR c>=d+2)
    OR (e>a AND e<b)
 ORDER BY 3,4,1
;

CREATE VIRTUAL VIEW V2806 AS SELECT b,
       d,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2807 AS SELECT b,
       d,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 4,1,3,2,5
;

CREATE VIRTUAL VIEW V2808 AS SELECT b,
       d,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
    OR d>e
;

CREATE VIRTUAL VIEW V2809 AS SELECT b,
       d,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
    OR d>e
 ORDER BY 4,3
;

CREATE VIRTUAL VIEW V2810 AS SELECT b,
       d,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2811 AS SELECT b,
       d,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 4,3,1
;

CREATE VIRTUAL VIEW V2812 AS SELECT b,
       d,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR d>e
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2813 AS SELECT b,
       d,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR d>e
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,4,5,1
;

CREATE VIRTUAL VIEW V2814 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V2815 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c>d
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2816 AS SELECT d,
       b-c,
       e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
;

CREATE VIRTUAL VIEW V2817 AS SELECT d,
       b-c,
       e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
 ORDER BY 1,5
;

CREATE VIRTUAL VIEW V2818 AS SELECT d,
       b-c,
       e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
;

CREATE VIRTUAL VIEW V2819 AS SELECT d,
       b-c,
       e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
 ORDER BY 4,3,2,5
;

CREATE VIRTUAL VIEW V2820 AS SELECT d,
       b-c,
       e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
   AND d>e
;

CREATE VIRTUAL VIEW V2821 AS SELECT d,
       b-c,
       e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
   AND d>e
 ORDER BY 5,3,4,1
;

CREATE VIRTUAL VIEW V2822 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
    OR d>e
;

CREATE VIRTUAL VIEW V2823 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
    OR d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2824 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2825 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2826 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d>e
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2827 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d>e
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2828 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2829 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,4,3,5,2,7
;

CREATE VIRTUAL VIEW V2830 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2831 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2832 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2833 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 6,3,4
;

CREATE VIRTUAL VIEW V2834 AS SELECT b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2835 AS SELECT b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2836 AS SELECT abs(b-c),
       b-c,
       d,
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V2837 AS SELECT abs(b-c),
       b-c,
       d,
       d-e
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2838 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
   AND d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2839 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
   AND d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2840 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
   AND d>e
;

CREATE VIRTUAL VIEW V2841 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
   AND d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2842 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d>e
   AND b>c
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2843 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d>e
   AND b>c
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2844 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
;

CREATE VIRTUAL VIEW V2845 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2846 AS SELECT a-b
  FROM t1
;

CREATE VIRTUAL VIEW V2847 AS SELECT a-b
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2848 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e
  FROM t1
 WHERE c>d
    OR d>e
;

CREATE VIRTUAL VIEW V2849 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e
  FROM t1
 WHERE c>d
    OR d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2850 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e
  FROM t1
 WHERE d>e
    OR c>d
;

CREATE VIRTUAL VIEW V2851 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e
  FROM t1
 WHERE d>e
    OR c>d
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2852 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2853 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
    OR (e>a AND e<b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2854 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2855 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2856 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIRTUAL VIEW V2857 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2858 AS SELECT a-b
  FROM t1
;

CREATE VIRTUAL VIEW V2859 AS SELECT a-b
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2860 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2861 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 7,1,5
;

CREATE VIRTUAL VIEW V2862 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2863 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
 ORDER BY 3,4,2,7,1,6
;

CREATE VIRTUAL VIEW V2864 AS SELECT d-e
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V2865 AS SELECT d-e
  FROM t1
 WHERE b>c
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2866 AS SELECT abs(a),
       a+b*2+c*3+d*4+e*5,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b
  FROM t1
;

CREATE VIRTUAL VIEW V2867 AS SELECT abs(a),
       a+b*2+c*3+d*4+e*5,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b
  FROM t1
 ORDER BY 1,3,2,4
;

CREATE VIRTUAL VIEW V2868 AS SELECT c-d,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       d-e,
       b,
       e
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2869 AS SELECT c-d,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       d-e,
       b,
       e
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,6,3
;

CREATE VIRTUAL VIEW V2870 AS SELECT c-d,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       d-e,
       b,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2871 AS SELECT c-d,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       d-e,
       b,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
 ORDER BY 2,6,3,1
;

CREATE VIRTUAL VIEW V2872 AS SELECT c-d,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       d-e,
       b,
       e
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2873 AS SELECT c-d,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       d-e,
       b,
       e
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 7,6,4,1
;

CREATE VIRTUAL VIEW V2874 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE c>d
    OR d>e
;

CREATE VIRTUAL VIEW V2875 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE c>d
    OR d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2876 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE d>e
    OR c>d
;

CREATE VIRTUAL VIEW V2877 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE d>e
    OR c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2878 AS SELECT b-c,
       abs(b-c),
       a+b*2
  FROM t1
;

CREATE VIRTUAL VIEW V2879 AS SELECT b-c,
       abs(b-c),
       a+b*2
  FROM t1
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V2880 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2881 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2882 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2883 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2884 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       b
  FROM t1
 WHERE d>e
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2885 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       b
  FROM t1
 WHERE d>e
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V2886 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
;

CREATE VIRTUAL VIEW V2887 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2888 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
;

CREATE VIRTUAL VIEW V2889 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2890 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2891 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
    OR (e>a AND e<b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2892 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       abs(b-c),
       c-d,
       a+b*2
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2893 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       abs(b-c),
       c-d,
       a+b*2
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,4,2,6,5
;

CREATE VIRTUAL VIEW V2894 AS SELECT (a+b+c+d+e)/5,
       c-d,
       a+b*2,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2895 AS SELECT (a+b+c+d+e)/5,
       c-d,
       a+b*2,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND (e>a AND e<b)
 ORDER BY 2,3,7,5,6,4
;

CREATE VIRTUAL VIEW V2896 AS SELECT (a+b+c+d+e)/5,
       c-d,
       a+b*2,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       a-b
  FROM t1
 WHERE c>d
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2897 AS SELECT (a+b+c+d+e)/5,
       c-d,
       a+b*2,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       a-b
  FROM t1
 WHERE c>d
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 5,2
;

CREATE VIRTUAL VIEW V2898 AS SELECT (a+b+c+d+e)/5,
       c-d,
       a+b*2,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
   AND c>d
;

CREATE VIRTUAL VIEW V2899 AS SELECT (a+b+c+d+e)/5,
       c-d,
       a+b*2,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
   AND c>d
 ORDER BY 4,5,1
;

CREATE VIRTUAL VIEW V2900 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V2901 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 4,5
;

CREATE VIRTUAL VIEW V2902 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND d>e
;

CREATE VIRTUAL VIEW V2903 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND d>e
 ORDER BY 4,5,3,2
;

CREATE VIRTUAL VIEW V2904 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE d>e
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2905 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE d>e
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 5,2,4,1
;

CREATE VIRTUAL VIEW V2906 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIRTUAL VIEW V2907 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2908 AS SELECT abs(a),
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2909 AS SELECT abs(a),
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2910 AS SELECT abs(a),
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2911 AS SELECT abs(a),
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2912 AS SELECT e,
       a,
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2913 AS SELECT e,
       a,
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V2914 AS SELECT a-b,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2915 AS SELECT a-b,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2916 AS SELECT a-b,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2917 AS SELECT a-b,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2918 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V2919 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2920 AS SELECT a+b*2+c*3+d*4,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIRTUAL VIEW V2921 AS SELECT a+b*2+c*3+d*4,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 2,1,4
;

CREATE VIRTUAL VIEW V2922 AS SELECT e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2923 AS SELECT e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2924 AS SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       a
  FROM t1
;

CREATE VIRTUAL VIEW V2925 AS SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       a
  FROM t1
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V2926 AS SELECT d,
       a+b*2+c*3+d*4,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2927 AS SELECT d,
       a+b*2+c*3+d*4,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,4,2,3
;

CREATE VIRTUAL VIEW V2928 AS SELECT d,
       a+b*2+c*3+d*4,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2929 AS SELECT d,
       a+b*2+c*3+d*4,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V2930 AS SELECT d,
       a+b*2+c*3+d*4,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2931 AS SELECT d,
       a+b*2+c*3+d*4,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
 ORDER BY 4,2,3
;

CREATE VIRTUAL VIEW V2932 AS SELECT d,
       a+b*2+c*3+d*4,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2933 AS SELECT d,
       a+b*2+c*3+d*4,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
 ORDER BY 1,4,2,3
;

CREATE VIRTUAL VIEW V2934 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
    OR c>d
;

CREATE VIRTUAL VIEW V2935 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
    OR c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2936 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c>d
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2937 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c>d
    OR (e>c OR e<d)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2938 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       d
  FROM t1
 WHERE c>d
    OR (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2939 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       d
  FROM t1
 WHERE c>d
    OR (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V2940 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       d
  FROM t1
 WHERE (e>c OR e<d)
    OR c>d
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2941 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       d
  FROM t1
 WHERE (e>c OR e<d)
    OR c>d
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2942 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V2943 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2944 AS SELECT a,
       abs(b-c),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V2945 AS SELECT a,
       abs(b-c),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
 ORDER BY 4,3
;

CREATE VIRTUAL VIEW V2946 AS SELECT a,
       abs(b-c),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2947 AS SELECT a,
       abs(b-c),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,4,5
;

CREATE VIRTUAL VIEW V2948 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       a,
       a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2949 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       a,
       a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,3,4,5,2
;

CREATE VIRTUAL VIEW V2950 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V2951 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2952 AS SELECT a-b,
       b-c,
       d,
       abs(b-c),
       e
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2953 AS SELECT a-b,
       b-c,
       d,
       abs(b-c),
       e
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 5,1
;

CREATE VIRTUAL VIEW V2954 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       a+b*2+c*3
  FROM t1
;

CREATE VIRTUAL VIEW V2955 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       a+b*2+c*3
  FROM t1
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V2956 AS SELECT d,
       b-c,
       abs(a),
       c-d,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c
  FROM t1
;

CREATE VIRTUAL VIEW V2957 AS SELECT d,
       b-c,
       abs(a),
       c-d,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c
  FROM t1
 ORDER BY 2,7,5,1,4
;

CREATE VIRTUAL VIEW V2958 AS SELECT b-c,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V2959 AS SELECT b-c,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
 ORDER BY 2,7,4,3,6
;

CREATE VIRTUAL VIEW V2960 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
;

CREATE VIRTUAL VIEW V2961 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2962 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
   AND c>d
;

CREATE VIRTUAL VIEW V2963 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
   AND c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2964 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V2965 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2966 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V2967 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2968 AS SELECT abs(b-c),
       c,
       e,
       c-d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2969 AS SELECT abs(b-c),
       c,
       e,
       c-d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
 ORDER BY 3,4,1,2
;

CREATE VIRTUAL VIEW V2970 AS SELECT b-c,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c)
  FROM t1
;

CREATE VIRTUAL VIEW V2971 AS SELECT b-c,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c)
  FROM t1
 ORDER BY 2,4,1,3
;

CREATE VIRTUAL VIEW V2972 AS SELECT abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V2973 AS SELECT abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V2974 AS SELECT abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
   AND b>c
;

CREATE VIRTUAL VIEW V2975 AS SELECT abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
   AND b>c
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V2976 AS SELECT abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
   AND b>c
;

CREATE VIRTUAL VIEW V2977 AS SELECT abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
   AND b>c
 ORDER BY 2,4,1,3
;

CREATE VIRTUAL VIEW V2978 AS SELECT a+b*2+c*3+d*4+e*5,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2979 AS SELECT a+b*2+c*3+d*4+e*5,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 4,3,5,1,2
;

CREATE VIRTUAL VIEW V2980 AS SELECT d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2981 AS SELECT d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2982 AS SELECT d-e
  FROM t1
 WHERE (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2983 AS SELECT d-e
  FROM t1
 WHERE (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2984 AS SELECT a,
       abs(b-c),
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V2985 AS SELECT a,
       abs(b-c),
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V2986 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIRTUAL VIEW V2987 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2988 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V2989 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V2990 AS SELECT a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V2991 AS SELECT a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V2992 AS SELECT a+b*2+c*3+d*4
  FROM t1
;

CREATE VIRTUAL VIEW V2993 AS SELECT a+b*2+c*3+d*4
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V2994 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
    OR d NOT BETWEEN 110 AND 150
    OR a>b
;

CREATE VIRTUAL VIEW V2995 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
    OR d NOT BETWEEN 110 AND 150
    OR a>b
 ORDER BY 3,5,2
;

CREATE VIRTUAL VIEW V2996 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
    OR d NOT BETWEEN 110 AND 150
    OR c>d
;

CREATE VIRTUAL VIEW V2997 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
    OR d NOT BETWEEN 110 AND 150
    OR c>d
 ORDER BY 4,3,2,5,1
;

CREATE VIRTUAL VIEW V2998 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
    OR c>d
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V2999 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
    OR c>d
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 5,1
;

CREATE VIRTUAL VIEW V3000 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
    OR a>b
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V3001 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       d-e,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
    OR a>b
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 3,1,2,5
;

CREATE VIRTUAL VIEW V3002 AS SELECT b,
       b-c,
       a-b,
       e,
       c-d,
       a+b*2,
       abs(b-c)
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V3003 AS SELECT b,
       b-c,
       a-b,
       e,
       c-d,
       a+b*2,
       abs(b-c)
  FROM t1
 WHERE c>d
 ORDER BY 3,1,2,7,5,6
;

CREATE VIRTUAL VIEW V3004 AS SELECT b-c,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V3005 AS SELECT b-c,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V3006 AS SELECT b-c,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
   AND a>b
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V3007 AS SELECT b-c,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
   AND a>b
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V3008 AS SELECT b-c,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
   AND a>b
;

CREATE VIRTUAL VIEW V3009 AS SELECT b-c,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
   AND a>b
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V3010 AS SELECT b-c,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a>b
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V3011 AS SELECT b-c,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a>b
   AND (e>a AND e<b)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V3012 AS SELECT a-b,
       a+b*2+c*3+d*4,
       a+b*2,
       b,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V3013 AS SELECT a-b,
       a+b*2+c*3+d*4,
       a+b*2,
       b,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,4,2,3
;

CREATE VIRTUAL VIEW V3014 AS SELECT c,
       abs(b-c),
       b,
       (a+b+c+d+e)/5,
       b-c
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIRTUAL VIEW V3015 AS SELECT c,
       abs(b-c),
       b,
       (a+b+c+d+e)/5,
       b-c
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1,5
;

CREATE VIRTUAL VIEW V3016 AS SELECT a+b*2,
       abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
   AND c>d
;

CREATE VIRTUAL VIEW V3017 AS SELECT a+b*2,
       abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
   AND c>d
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3018 AS SELECT a+b*2,
       abs(b-c)
  FROM t1
 WHERE c>d
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V3019 AS SELECT a+b*2,
       abs(b-c)
  FROM t1
 WHERE c>d
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3020 AS SELECT a+b*2,
       abs(b-c)
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V3021 AS SELECT a+b*2,
       abs(b-c)
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3022 AS SELECT (a+b+c+d+e)/5
  FROM t1
;

CREATE VIRTUAL VIEW V3023 AS SELECT (a+b+c+d+e)/5
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3024 AS SELECT a+b*2+c*3+d*4,
       a-b,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V3025 AS SELECT a+b*2+c*3+d*4,
       a-b,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 6,7,1,3
;

CREATE VIRTUAL VIEW V3026 AS SELECT a+b*2+c*3
  FROM t1
;

CREATE VIRTUAL VIEW V3027 AS SELECT a+b*2+c*3
  FROM t1
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3028 AS SELECT a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR c>d
    OR d>e
;

CREATE VIRTUAL VIEW V3029 AS SELECT a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR c>d
    OR d>e
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V3030 AS SELECT a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
    OR c>d
;

CREATE VIRTUAL VIEW V3031 AS SELECT a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
    OR c>d
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3032 AS SELECT a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
    OR d>e
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V3033 AS SELECT a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
    OR d>e
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V3034 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       d-e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V3035 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       d-e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V3036 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       c-d
  FROM t1
 WHERE c>d
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V3037 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       c-d
  FROM t1
 WHERE c>d
   AND (a>b-2 AND a<b+2)
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V3038 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       c-d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c>d
;

CREATE VIRTUAL VIEW V3039 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       c-d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c>d
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V3040 AS SELECT b,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
   AND c>d
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V3041 AS SELECT b,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
   AND c>d
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 3,4,2
;

CREATE VIRTUAL VIEW V3042 AS SELECT b,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
   AND c>d
;

CREATE VIRTUAL VIEW V3043 AS SELECT b,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
   AND c>d
 ORDER BY 2,4,3
;

CREATE VIRTUAL VIEW V3044 AS SELECT b,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND a>b
   AND c>d
;

CREATE VIRTUAL VIEW V3045 AS SELECT b,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND a>b
   AND c>d
 ORDER BY 4,2,1,3
;

CREATE VIRTUAL VIEW V3046 AS SELECT b,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c>d
   AND a>b
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V3047 AS SELECT b,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c>d
   AND a>b
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,4,3,2
;

CREATE VIRTUAL VIEW V3048 AS SELECT a-b,
       c,
       a+b*2
  FROM t1
 WHERE b>c
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V3049 AS SELECT a-b,
       c,
       a+b*2
  FROM t1
 WHERE b>c
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V3050 AS SELECT a-b,
       c,
       a+b*2
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
;

CREATE VIRTUAL VIEW V3051 AS SELECT a-b,
       c,
       a+b*2
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V3052 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V3053 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 5,3
;

CREATE VIRTUAL VIEW V3054 AS SELECT a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       abs(b-c),
       abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V3055 AS SELECT a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       abs(b-c),
       abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 2,5,1,3,4
;

CREATE VIRTUAL VIEW V3056 AS SELECT (a+b+c+d+e)/5,
       e,
       c
  FROM t1
;

CREATE VIRTUAL VIEW V3057 AS SELECT (a+b+c+d+e)/5,
       e,
       c
  FROM t1
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V3058 AS SELECT d,
       abs(b-c),
       b,
       b-c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V3059 AS SELECT d,
       abs(b-c),
       b,
       b-c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 2,4
;

CREATE VIRTUAL VIEW V3060 AS SELECT b,
       a+b*2,
       a+b*2+c*3,
       e,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
;

CREATE VIRTUAL VIEW V3061 AS SELECT b,
       a+b*2,
       a+b*2+c*3,
       e,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
 ORDER BY 5,6,3,1,2
;

CREATE VIRTUAL VIEW V3062 AS SELECT b,
       a+b*2,
       a+b*2+c*3,
       e,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V3063 AS SELECT b,
       a+b*2,
       a+b*2+c*3,
       e,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,6,1,2,4,5
;

CREATE VIRTUAL VIEW V3064 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       d,
       abs(b-c),
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V3065 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       d,
       abs(b-c),
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,2,5,3,7,1,6
;

CREATE VIRTUAL VIEW V3066 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       d,
       abs(b-c),
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V3067 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       d,
       abs(b-c),
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,2,7,6
;

CREATE VIRTUAL VIEW V3068 AS SELECT abs(a),
       a+b*2,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (a>b-2 AND a<b+2)
   AND a>b
;

CREATE VIRTUAL VIEW V3069 AS SELECT abs(a),
       a+b*2,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (a>b-2 AND a<b+2)
   AND a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3070 AS SELECT abs(a),
       a+b*2,
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
;

CREATE VIRTUAL VIEW V3071 AS SELECT abs(a),
       a+b*2,
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3072 AS SELECT abs(a),
       a+b*2,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V3073 AS SELECT abs(a),
       a+b*2,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V3074 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2
  FROM t1
 WHERE c>d
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V3075 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2
  FROM t1
 WHERE c>d
    OR c BETWEEN b-2 AND d+2
 ORDER BY 4,1
;

CREATE VIRTUAL VIEW V3076 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR c>d
;

CREATE VIRTUAL VIEW V3077 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR c>d
 ORDER BY 4,2,3
;

CREATE VIRTUAL VIEW V3078 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       a,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V3079 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       a,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>a AND e<b)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 6,4,3
;

CREATE VIRTUAL VIEW V3080 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       a,
       a+b*2+c*3+d*4
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V3081 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       a,
       a+b*2+c*3+d*4
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V3082 AS SELECT b,
       d-e
  FROM t1
;

CREATE VIRTUAL VIEW V3083 AS SELECT b,
       d-e
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3084 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V3085 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 3,2,1
;

CREATE VIRTUAL VIEW V3086 AS SELECT (a+b+c+d+e)/5,
       e,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V3087 AS SELECT (a+b+c+d+e)/5,
       e,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 6,1,2
;

CREATE VIRTUAL VIEW V3088 AS SELECT (a+b+c+d+e)/5,
       e,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V3089 AS SELECT (a+b+c+d+e)/5,
       e,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND (e>c OR e<d)
 ORDER BY 6,4,3,5,7
;

CREATE VIRTUAL VIEW V3090 AS SELECT (a+b+c+d+e)/5,
       e,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
   AND c>d
;

CREATE VIRTUAL VIEW V3091 AS SELECT (a+b+c+d+e)/5,
       e,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
   AND c>d
 ORDER BY 4,5,3,1
;

CREATE VIRTUAL VIEW V3092 AS SELECT b-c,
       d-e,
       (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V3093 AS SELECT b-c,
       d-e,
       (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 3,5,6,4,2
;

CREATE VIRTUAL VIEW V3094 AS SELECT c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND a>b
;

CREATE VIRTUAL VIEW V3095 AS SELECT c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND a>b
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3096 AS SELECT c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
   AND c>d
;

CREATE VIRTUAL VIEW V3097 AS SELECT c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
   AND c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V3098 AS SELECT a+b*2+c*3+d*4+e*5,
       c,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V3099 AS SELECT a+b*2+c*3+d*4+e*5,
       c,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
 ORDER BY 4,2,1
;

CREATE VIRTUAL VIEW V3100 AS SELECT a+b*2+c*3+d*4+e*5,
       c,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
;

CREATE VIRTUAL VIEW V3101 AS SELECT a+b*2+c*3+d*4+e*5,
       c,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
 ORDER BY 4,3,1,2
;

CREATE VIRTUAL VIEW V3102 AS SELECT b-c
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V3103 AS SELECT b-c
  FROM t1
 WHERE a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3104 AS SELECT abs(a),
       b,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
 WHERE d>e
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V3105 AS SELECT abs(a),
       b,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
 WHERE d>e
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 3,6,4,5,2,7
;

CREATE VIRTUAL VIEW V3106 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       a,
       a+b*2,
       c-d
  FROM t1
 WHERE c>d
   AND b>c
;

CREATE VIRTUAL VIEW V3107 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       a,
       a+b*2,
       c-d
  FROM t1
 WHERE c>d
   AND b>c
 ORDER BY 1,4,5,3
;

CREATE VIRTUAL VIEW V3108 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       a,
       a+b*2,
       c-d
  FROM t1
 WHERE b>c
   AND c>d
;

CREATE VIRTUAL VIEW V3109 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       a,
       a+b*2,
       c-d
  FROM t1
 WHERE b>c
   AND c>d
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V3110 AS SELECT a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
   AND c>d
;

CREATE VIRTUAL VIEW V3111 AS SELECT a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
   AND c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3112 AS SELECT a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V3113 AS SELECT a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3114 AS SELECT a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c BETWEEN b-2 AND d+2
   AND c>d
;

CREATE VIRTUAL VIEW V3115 AS SELECT a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c BETWEEN b-2 AND d+2
   AND c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3116 AS SELECT a+b*2+c*3+d*4,
       a
  FROM t1
;

CREATE VIRTUAL VIEW V3117 AS SELECT a+b*2+c*3+d*4,
       a
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V3118 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
   AND (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V3119 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
   AND (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V3120 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND b>c
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V3121 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND b>c
   AND (e>c OR e<d)
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V3122 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
   AND (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V3123 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
   AND (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V3124 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
   AND b>c
;

CREATE VIRTUAL VIEW V3125 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
   AND b>c
 ORDER BY 4,3,1
;

CREATE VIRTUAL VIEW V3126 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V3127 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE b>c
 ORDER BY 3,2,4,5,1
;

CREATE VIRTUAL VIEW V3128 AS SELECT abs(a),
       a+b*2,
       b,
       d,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
;

CREATE VIRTUAL VIEW V3129 AS SELECT abs(a),
       a+b*2,
       b,
       d,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a>b
 ORDER BY 1,4,7
;

CREATE VIRTUAL VIEW V3130 AS SELECT a+b*2+c*3+d*4,
       a-b,
       e,
       abs(a),
       c
  FROM t1
 WHERE a>b
   AND c>d
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V3131 AS SELECT a+b*2+c*3+d*4,
       a-b,
       e,
       abs(a),
       c
  FROM t1
 WHERE a>b
   AND c>d
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V3132 AS SELECT a+b*2+c*3+d*4,
       a-b,
       e,
       abs(a),
       c
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110 AND 150
   AND c>d
;

CREATE VIRTUAL VIEW V3133 AS SELECT a+b*2+c*3+d*4,
       a-b,
       e,
       abs(a),
       c
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110 AND 150
   AND c>d
 ORDER BY 2,4,3
;

CREATE VIRTUAL VIEW V3134 AS SELECT a+b*2+c*3+d*4,
       a-b,
       e,
       abs(a),
       c
  FROM t1
 WHERE c>d
   AND d NOT BETWEEN 110 AND 150
   AND a>b
;

CREATE VIRTUAL VIEW V3135 AS SELECT a+b*2+c*3+d*4,
       a-b,
       e,
       abs(a),
       c
  FROM t1
 WHERE c>d
   AND d NOT BETWEEN 110 AND 150
   AND a>b
 ORDER BY 4,3
;

CREATE VIRTUAL VIEW V3136 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V3137 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,4
;

CREATE VIRTUAL VIEW V3138 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       a-b
  FROM t1
 WHERE b>c
    OR a>b
;

CREATE VIRTUAL VIEW V3139 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       a-b
  FROM t1
 WHERE b>c
    OR a>b
 ORDER BY 1,3,2
;

CREATE VIRTUAL VIEW V3140 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a,
       a-b
  FROM t1
;

CREATE VIRTUAL VIEW V3141 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a,
       a-b
  FROM t1
 ORDER BY 4,1,2,5,6
;

CREATE VIRTUAL VIEW V3142 AS SELECT a,
       d
  FROM t1
 WHERE d>e
    OR b>c
;

CREATE VIRTUAL VIEW V3143 AS SELECT a,
       d
  FROM t1
 WHERE d>e
    OR b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3144 AS SELECT a,
       d
  FROM t1
 WHERE b>c
    OR d>e
;

CREATE VIRTUAL VIEW V3145 AS SELECT a,
       d
  FROM t1
 WHERE b>c
    OR d>e
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3146 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V3147 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3148 AS SELECT b,
       a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
   AND c>d
;

CREATE VIRTUAL VIEW V3149 AS SELECT b,
       a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2 AND d+2
   AND c>d
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V3150 AS SELECT b,
       a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND b>c
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V3151 AS SELECT b,
       a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND b>c
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,3
;

CREATE VIRTUAL VIEW V3152 AS SELECT a-b,
       a,
       b-c,
       b,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c>d
;

CREATE VIRTUAL VIEW V3153 AS SELECT a-b,
       a,
       b-c,
       b,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c>d
 ORDER BY 2,1,5,4
;

CREATE VIRTUAL VIEW V3154 AS SELECT a-b,
       a,
       b-c,
       b,
       e
  FROM t1
 WHERE c>d
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V3155 AS SELECT a-b,
       a,
       b-c,
       b,
       e
  FROM t1
 WHERE c>d
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V3156 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V3157 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3158 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V3159 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3160 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       a+b*2+c*3,
       abs(a),
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V3161 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       a+b*2+c*3,
       abs(a),
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR (e>a AND e<b)
 ORDER BY 1,7,5,4,2,3
;

CREATE VIRTUAL VIEW V3162 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       a+b*2+c*3,
       abs(a),
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V3163 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       a+b*2+c*3,
       abs(a),
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,3,7,4,1,5
;

CREATE VIRTUAL VIEW V3164 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       a+b*2+c*3,
       abs(a),
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V3165 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       a+b*2+c*3,
       abs(a),
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 5,7,6
;

CREATE VIRTUAL VIEW V3166 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V3167 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 2,5,3,4
;

CREATE VIRTUAL VIEW V3168 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V3169 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V3170 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V3171 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
 ORDER BY 5,2,4
;

CREATE VIRTUAL VIEW V3172 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V3173 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,4,3,5
;

CREATE VIRTUAL VIEW V3174 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND a>b
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V3175 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND a>b
   AND (e>a AND e<b)
 ORDER BY 5,4
;

CREATE VIRTUAL VIEW V3176 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a>b
   AND (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V3177 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a>b
   AND (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
 ORDER BY 3,2
;

CREATE VIRTUAL VIEW V3178 AS SELECT abs(a),
       a-b,
       d-e,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
   AND c>d
;

CREATE VIRTUAL VIEW V3179 AS SELECT abs(a),
       a-b,
       d-e,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
   AND c>d
 ORDER BY 4,1,5
;

CREATE VIRTUAL VIEW V3180 AS SELECT abs(a),
       a-b,
       d-e,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V3181 AS SELECT abs(a),
       a-b,
       d-e,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
   AND (e>a AND e<b)
 ORDER BY 2,3,6,1,5,4
;

CREATE VIRTUAL VIEW V3182 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
   AND d>e
;

CREATE VIRTUAL VIEW V3183 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
   AND d>e
 ORDER BY 2,1,3,4,5
;

CREATE VIRTUAL VIEW V3184 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
   AND d>e
;

CREATE VIRTUAL VIEW V3185 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
   AND d>e
 ORDER BY 5,6
;

CREATE VIRTUAL VIEW V3186 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b,
       b-c
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V3187 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b,
       b-c
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 2,1,3,5
;

CREATE VIRTUAL VIEW V3188 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b,
       b-c
  FROM t1
 WHERE d>e
   AND (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V3189 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b,
       b-c
  FROM t1
 WHERE d>e
   AND (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
 ORDER BY 4,5,2
;

CREATE VIRTUAL VIEW V3190 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       a+b*2+c*3,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND a>b
   AND c>d
;

CREATE VIRTUAL VIEW V3191 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       a+b*2+c*3,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND a>b
   AND c>d
 ORDER BY 2,1,4
;

CREATE VIRTUAL VIEW V3192 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       a+b*2+c*3,
       abs(b-c)
  FROM t1
 WHERE a>b
   AND e+d BETWEEN a+b-10 AND c+130
   AND c>d
;

CREATE VIRTUAL VIEW V3193 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       a+b*2+c*3,
       abs(b-c)
  FROM t1
 WHERE a>b
   AND e+d BETWEEN a+b-10 AND c+130
   AND c>d
 ORDER BY 1,4,3,2
;

CREATE VIRTUAL VIEW V3194 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       d,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIRTUAL VIEW V3195 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       d,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 ORDER BY 5,1,2
;

CREATE VIRTUAL VIEW V3196 AS SELECT a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b,
       abs(a),
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
;

CREATE VIRTUAL VIEW V3197 AS SELECT a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b,
       abs(a),
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
 ORDER BY 4,2,3
;

CREATE VIRTUAL VIEW V3198 AS SELECT b,
       abs(b-c)
  FROM t1
;

CREATE VIRTUAL VIEW V3199 AS SELECT b,
       abs(b-c)
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3200 AS SELECT e,
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V3201 AS SELECT e,
       abs(a)
  FROM t1
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3202 AS SELECT c-d,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       a+b*2+c*3,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V3203 AS SELECT c-d,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       a+b*2+c*3,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
 ORDER BY 5,1,7,4,6,2,3
;

CREATE VIRTUAL VIEW V3204 AS SELECT c-d,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       a+b*2+c*3,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
    OR (e>a AND e<b)
    OR (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V3205 AS SELECT c-d,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       a+b*2+c*3,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
    OR (e>a AND e<b)
    OR (a>b-2 AND a<b+2)
 ORDER BY 6,5
;

CREATE VIRTUAL VIEW V3206 AS SELECT c-d,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       a+b*2+c*3,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
    OR b>c
;

CREATE VIRTUAL VIEW V3207 AS SELECT c-d,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       a+b*2+c*3,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
    OR b>c
 ORDER BY 5,3,7,2,4
;

CREATE VIRTUAL VIEW V3208 AS SELECT d,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V3209 AS SELECT d,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 7,1
;

CREATE VIRTUAL VIEW V3210 AS SELECT d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       a,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a)
  FROM t1
;

CREATE VIRTUAL VIEW V3211 AS SELECT d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       a,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a)
  FROM t1
 ORDER BY 2,7
;

CREATE VIRTUAL VIEW V3212 AS SELECT abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       b
  FROM t1
;

CREATE VIRTUAL VIEW V3213 AS SELECT abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       b
  FROM t1
 ORDER BY 4,1,2,3
;

CREATE VIRTUAL VIEW V3214 AS SELECT abs(b-c),
       c,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V3215 AS SELECT abs(b-c),
       c,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 4,1,2
;

CREATE VIRTUAL VIEW V3216 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIRTUAL VIEW V3217 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 ORDER BY 4,1
;

CREATE VIRTUAL VIEW V3218 AS SELECT a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V3219 AS SELECT a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,1,5
;

CREATE VIRTUAL VIEW V3220 AS SELECT abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c>d
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V3221 AS SELECT abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c>d
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3222 AS SELECT abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
    OR c>d
;

CREATE VIRTUAL VIEW V3223 AS SELECT abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
    OR c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3224 AS SELECT abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
    OR c>d
;

CREATE VIRTUAL VIEW V3225 AS SELECT abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
    OR c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3226 AS SELECT abs(b-c)
  FROM t1
 WHERE c>d
    OR (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V3227 AS SELECT abs(b-c)
  FROM t1
 WHERE c>d
    OR (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3228 AS SELECT c-d,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V3229 AS SELECT c-d,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,5,4
;

CREATE VIRTUAL VIEW V3230 AS SELECT c-d,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V3231 AS SELECT c-d,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 6,2,5,4
;

CREATE VIRTUAL VIEW V3232 AS SELECT a,
       a+b*2+c*3+d*4+e*5,
       c,
       a+b*2+c*3+d*4,
       c-d,
       a-b
  FROM t1
 WHERE a>b
;

CREATE VIRTUAL VIEW V3233 AS SELECT a,
       a+b*2+c*3+d*4+e*5,
       c,
       a+b*2+c*3+d*4,
       c-d,
       a-b
  FROM t1
 WHERE a>b
 ORDER BY 5,1,6,4,3
;

CREATE VIRTUAL VIEW V3234 AS SELECT abs(a),
       b-c,
       a+b*2+c*3,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIRTUAL VIEW V3235 AS SELECT abs(a),
       b-c,
       a+b*2+c*3,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V3236 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c,
       a+b*2+c*3
  FROM t1
 WHERE c>d
    OR d>e
    OR (e>a AND e<b)
;

CREATE VIRTUAL VIEW V3237 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c,
       a+b*2+c*3
  FROM t1
 WHERE c>d
    OR d>e
    OR (e>a AND e<b)
 ORDER BY 5,3,4,1,2
;

CREATE VIRTUAL VIEW V3238 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c,
       a+b*2+c*3
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
    OR d>e
;

CREATE VIRTUAL VIEW V3239 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c,
       a+b*2+c*3
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
    OR d>e
 ORDER BY 1,5,3
;

CREATE VIRTUAL VIEW V3240 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V3241 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V3242 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIRTUAL VIEW V3243 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 3,2,1,5
;

CREATE VIRTUAL VIEW V3244 AS SELECT a-b,
       (a+b+c+d+e)/5,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIRTUAL VIEW V3245 AS SELECT a-b,
       (a+b+c+d+e)/5,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V3246 AS SELECT a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIRTUAL VIEW V3247 AS SELECT a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 ORDER BY 1,2
;

CREATE VIRTUAL VIEW V3248 AS SELECT abs(a),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b
  FROM t1
 WHERE b>c
;

CREATE VIRTUAL VIEW V3249 AS SELECT abs(a),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b
  FROM t1
 WHERE b>c
 ORDER BY 5,2,1,4,3
;

CREATE VIRTUAL VIEW V3250 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       a+b*2+c*3+d*4,
       d,
       b-c,
       a-b,
       b
  FROM t1
 WHERE b>c
    OR c>d
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V3251 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       a+b*2+c*3+d*4,
       d,
       b-c,
       a-b,
       b
  FROM t1
 WHERE b>c
    OR c>d
    OR (e>c OR e<d)
 ORDER BY 2,1,5,6,3,4,7
;

CREATE VIRTUAL VIEW V3252 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       a+b*2+c*3+d*4,
       d,
       b-c,
       a-b,
       b
  FROM t1
 WHERE c>d
    OR b>c
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V3253 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       a+b*2+c*3+d*4,
       d,
       b-c,
       a-b,
       b
  FROM t1
 WHERE c>d
    OR b>c
    OR (e>c OR e<d)
 ORDER BY 7,1,4,5,3,6
;

CREATE VIRTUAL VIEW V3254 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       e
  FROM t1
 WHERE (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V3255 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       e
  FROM t1
 WHERE (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,3,5
;

CREATE VIRTUAL VIEW V3256 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V3257 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
 ORDER BY 5,3,2
;

CREATE VIRTUAL VIEW V3258 AS SELECT a-b,
       b-c,
       (a+b+c+d+e)/5,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIRTUAL VIEW V3259 AS SELECT a-b,
       b-c,
       (a+b+c+d+e)/5,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 3,4,5,1,2
;

CREATE VIRTUAL VIEW V3260 AS SELECT c-d,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V3261 AS SELECT c-d,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3262 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
;

CREATE VIRTUAL VIEW V3263 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 ORDER BY 2,4,5,3,1
;

CREATE VIRTUAL VIEW V3264 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V3265 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,4,1,3
;

CREATE VIRTUAL VIEW V3266 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V3267 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
 ORDER BY 4,2,1,3
;

CREATE VIRTUAL VIEW V3268 AS SELECT b,
       (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c
  FROM t1
;

CREATE VIRTUAL VIEW V3269 AS SELECT b,
       (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c
  FROM t1
 ORDER BY 4,3,2,1
;

CREATE VIRTUAL VIEW V3270 AS SELECT c,
       a+b*2,
       b-c
  FROM t1
;

CREATE VIRTUAL VIEW V3271 AS SELECT c,
       a+b*2,
       b-c
  FROM t1
 ORDER BY 3,1
;

CREATE VIRTUAL VIEW V3272 AS SELECT a+b*2+c*3+d*4,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V3273 AS SELECT a+b*2+c*3+d*4,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3274 AS SELECT c-d,
       b-c,
       a,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V3275 AS SELECT c-d,
       b-c,
       a,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,2
;

CREATE VIRTUAL VIEW V3276 AS SELECT c-d,
       b-c,
       a,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND c>d
;

CREATE VIRTUAL VIEW V3277 AS SELECT c-d,
       b-c,
       a,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
   AND c>d
 ORDER BY 4,3,1,2
;

CREATE VIRTUAL VIEW V3278 AS SELECT c-d,
       b-c,
       a,
       a+b*2+c*3
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V3279 AS SELECT c-d,
       b-c,
       a,
       a+b*2+c*3
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,4
;

CREATE VIRTUAL VIEW V3280 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c>d
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIRTUAL VIEW V3281 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c>d
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3282 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c>d
;

CREATE VIRTUAL VIEW V3283 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c>d
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3284 AS SELECT abs(a),
       abs(b-c),
       d-e,
       e
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR a>b
;

CREATE VIRTUAL VIEW V3285 AS SELECT abs(a),
       abs(b-c),
       d-e,
       e
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR a>b
 ORDER BY 2,4
;

CREATE VIRTUAL VIEW V3286 AS SELECT abs(a),
       abs(b-c),
       d-e,
       e
  FROM t1
 WHERE a>b
    OR (e>c OR e<d)
    OR b>c
;

CREATE VIRTUAL VIEW V3287 AS SELECT abs(a),
       abs(b-c),
       d-e,
       e
  FROM t1
 WHERE a>b
    OR (e>c OR e<d)
    OR b>c
 ORDER BY 2,3
;

CREATE VIRTUAL VIEW V3288 AS SELECT abs(a),
       abs(b-c),
       d-e,
       e
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR a>b
;

CREATE VIRTUAL VIEW V3289 AS SELECT abs(a),
       abs(b-c),
       d-e,
       e
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR a>b
 ORDER BY 2,3,1,4
;

CREATE VIRTUAL VIEW V3290 AS SELECT abs(a),
       abs(b-c),
       d-e,
       e
  FROM t1
 WHERE a>b
    OR b>c
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V3291 AS SELECT abs(a),
       abs(b-c),
       d-e,
       e
  FROM t1
 WHERE a>b
    OR b>c
    OR (e>c OR e<d)
 ORDER BY 2,1,4,3
;

CREATE VIRTUAL VIEW V3292 AS SELECT c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIRTUAL VIEW V3293 AS SELECT c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3294 AS SELECT c-d,
       a-b,
       b,
       d-e,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
;

CREATE VIRTUAL VIEW V3295 AS SELECT c-d,
       a-b,
       b,
       d-e,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
 ORDER BY 2,7,6
;

CREATE VIRTUAL VIEW V3296 AS SELECT b,
       abs(b-c),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
;

CREATE VIRTUAL VIEW V3297 AS SELECT b,
       abs(b-c),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V3298 AS SELECT b,
       abs(b-c),
       d
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V3299 AS SELECT b,
       abs(b-c),
       d
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,3,1
;

CREATE VIRTUAL VIEW V3300 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
   AND b>c
;

CREATE VIRTUAL VIEW V3301 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
   AND b>c
 ORDER BY 2,1
;

CREATE VIRTUAL VIEW V3302 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       e
  FROM t1
 WHERE b>c
   AND c>d
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V3303 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       e
  FROM t1
 WHERE b>c
   AND c>d
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,1,2
;

CREATE VIRTUAL VIEW V3304 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       e
  FROM t1
 WHERE c>d
   AND c BETWEEN b-2 AND d+2
   AND b>c
;

CREATE VIRTUAL VIEW V3305 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       e
  FROM t1
 WHERE c>d
   AND c BETWEEN b-2 AND d+2
   AND b>c
 ORDER BY 2,1,3
;

CREATE VIRTUAL VIEW V3306 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       e
  FROM t1
 WHERE c>d
   AND b>c
   AND c BETWEEN b-2 AND d+2
;

CREATE VIRTUAL VIEW V3307 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       e
  FROM t1
 WHERE c>d
   AND b>c
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1,2,3
;

CREATE VIRTUAL VIEW V3308 AS SELECT abs(a),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       a+b*2+c*3+d*4+e*5,
       c
  FROM t1
;

CREATE VIRTUAL VIEW V3309 AS SELECT abs(a),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       a+b*2+c*3+d*4+e*5,
       c
  FROM t1
 ORDER BY 5,3
;

CREATE VIRTUAL VIEW V3310 AS SELECT abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
    OR a>b
;

CREATE VIRTUAL VIEW V3311 AS SELECT abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
    OR a>b
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3312 AS SELECT abs(b-c)
  FROM t1
 WHERE a>b
    OR (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIRTUAL VIEW V3313 AS SELECT abs(b-c)
  FROM t1
 WHERE a>b
    OR (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3314 AS SELECT abs(b-c)
  FROM t1
 WHERE a>b
    OR d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
;

CREATE VIRTUAL VIEW V3315 AS SELECT abs(b-c)
  FROM t1
 WHERE a>b
    OR d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
 ORDER BY 1
;

CREATE VIRTUAL VIEW V3316 AS SELECT d,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIRTUAL VIEW V3317 AS SELECT d,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,1,3,5,2
;

CREATE VIRTUAL VIEW V3318 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
   AND (e>c OR e<d)
;

CREATE VIRTUAL VIEW V3319 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
   AND (e>c OR e<d)
 ORDER BY 2,1
;
