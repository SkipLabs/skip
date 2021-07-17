CREATE VIEW V0 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIEW V1 AS SELECT e,
       abs(a),
       b,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
;

CREATE VIEW V2 AS SELECT abs(b-c),
       b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V3 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       d
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V4 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V5 AS SELECT a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR b IS NOT NULL
;

CREATE VIEW V6 AS SELECT abs(b-c)
  FROM t1
;

CREATE VIEW V7 AS SELECT a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b IS NOT NULL
   AND a>b
;

CREATE VIEW V8 AS SELECT c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND coalesce(a,b,c,d,e)<>0
   AND c>d
;

CREATE VIEW V9 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       b-c
  FROM t1
 WHERE b>c
   AND (e>c OR e<d)
;

CREATE VIEW V10 AS SELECT e,
       b,
       a,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b IS NOT NULL
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V11 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       a-b,
       d-e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c>d
   AND c BETWEEN b-2 AND d+2
;

CREATE VIEW V12 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
;

CREATE VIEW V13 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V14 AS SELECT d-e,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR b>c
    OR b IS NOT NULL
;

CREATE VIEW V15 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b
  FROM t1
;

CREATE VIEW V16 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR b>c
    OR a>b
;

CREATE VIEW V17 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b IS NOT NULL
;

CREATE VIEW V18 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       e,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c>d
;

CREATE VIEW V19 AS SELECT e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       d,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V20 AS SELECT e,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V21 AS SELECT a+b*2,
       abs(b-c),
       c,
       d-e,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
    OR a IS NULL
;

CREATE VIEW V22 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR c>d
;

CREATE VIEW V23 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a IS NULL
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V24 AS SELECT a,
       c-d,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b IS NOT NULL
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V25 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       b,
       abs(a),
       a
  FROM t1
 WHERE b>c
   AND coalesce(a,b,c,d,e)<>0
   AND (e>a AND e<b)
;

CREATE VIEW V26 AS SELECT abs(b-c),
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V27 AS SELECT a-b,
       b-c,
       abs(a),
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       d-e
  FROM t1
 WHERE b IS NOT NULL
   AND e+d BETWEEN a+b-10 AND c+130
   AND c BETWEEN b-2 AND d+2
;

CREATE VIEW V28 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V29 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V30 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       a,
       d-e,
       d
  FROM t1
 WHERE a IS NULL
   AND d>e
;

CREATE VIEW V31 AS SELECT (a+b+c+d+e)/5,
       c-d,
       e,
       a
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V32 AS SELECT (a+b+c+d+e)/5,
       d
  FROM t1
 WHERE b IS NOT NULL
;

CREATE VIEW V33 AS SELECT a+b*2+c*3,
       c-d
  FROM t1
 WHERE b IS NOT NULL
    OR coalesce(a,b,c,d,e)<>0
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V34 AS SELECT e,
       a+b*2,
       c,
       b-c
  FROM t1
 WHERE a>b
;

CREATE VIEW V35 AS SELECT c,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       a,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
;

CREATE VIEW V36 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       abs(a),
       d-e,
       b-c
  FROM t1
;

CREATE VIEW V37 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       a+b*2+c*3+d*4+e*5,
       a-b,
       a+b*2,
       c
  FROM t1
;

CREATE VIEW V38 AS SELECT c-d,
       b-c,
       a+b*2+c*3,
       abs(a),
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V39 AS SELECT d
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
;

CREATE VIEW V40 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE b>c
;

CREATE VIEW V41 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIEW V42 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V43 AS SELECT (a+b+c+d+e)/5,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
;

CREATE VIEW V44 AS SELECT b-c,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V45 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       c-d
  FROM t1
;

CREATE VIEW V46 AS SELECT a+b*2,
       d,
       abs(b-c),
       e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d>e
;

CREATE VIEW V47 AS SELECT c-d
  FROM t1
 WHERE c>d
;

CREATE VIEW V48 AS SELECT a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c>d
    OR (e>c OR e<d)
;

CREATE VIEW V49 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V50 AS SELECT a+b*2,
       d-e,
       a-b,
       abs(a),
       (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V51 AS SELECT a+b*2+c*3,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
;

CREATE VIEW V52 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V53 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
;

CREATE VIEW V54 AS SELECT b-c,
       c
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIEW V55 AS SELECT d-e,
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       a,
       b-c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V56 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       a+b*2+c*3,
       (a+b+c+d+e)/5,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
;

CREATE VIEW V57 AS SELECT c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V58 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d
  FROM t1
 WHERE d>e
    OR a>b
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V59 AS SELECT e
  FROM t1
;

CREATE VIEW V60 AS SELECT a+b*2
  FROM t1
 WHERE c>d
;

CREATE VIEW V61 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V62 AS SELECT c-d,
       a+b*2,
       d-e,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
   AND b IS NOT NULL
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V63 AS SELECT a-b,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE a>b
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
;

CREATE VIEW V64 AS SELECT d-e,
       abs(a)
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V65 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       b-c
  FROM t1
;

CREATE VIEW V66 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b
  FROM t1
 WHERE a>b
   AND b>c
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V67 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       a+b*2+c*3,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
;

CREATE VIEW V68 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
;

CREATE VIEW V69 AS SELECT a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       d-e
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V70 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V71 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(b-c),
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIEW V72 AS SELECT d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c)
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V73 AS SELECT d,
       c-d,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>a AND e<b)
    OR a IS NULL
;

CREATE VIEW V74 AS SELECT a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c
  FROM t1
;

CREATE VIEW V75 AS SELECT b,
       d,
       abs(a),
       abs(b-c),
       d-e
  FROM t1
 WHERE (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
    OR b IS NOT NULL
;

CREATE VIEW V76 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       c
  FROM t1
 WHERE b>c
   AND a>b
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V77 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b
  FROM t1
;

CREATE VIEW V78 AS SELECT d-e,
       abs(b-c)
  FROM t1
 WHERE b IS NOT NULL
;

CREATE VIEW V79 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V80 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       d,
       b-c,
       b,
       a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
;

CREATE VIEW V81 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
;

CREATE VIEW V82 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V83 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
;

CREATE VIEW V84 AS SELECT b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIEW V85 AS SELECT abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       d,
       e,
       c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
   AND (c<=d-2 OR c>=d+2)
   AND a>b
;

CREATE VIEW V86 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       d-e,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b IS NOT NULL
   AND c>d
;

CREATE VIEW V87 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       d,
       c-d,
       a
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V88 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d>e
;

CREATE VIEW V89 AS SELECT d-e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND coalesce(a,b,c,d,e)<>0
   AND c BETWEEN b-2 AND d+2
;

CREATE VIEW V90 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       b-c,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       abs(b-c)
  FROM t1
;

CREATE VIEW V91 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
   AND a>b
;

CREATE VIEW V92 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d>e
;

CREATE VIEW V93 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       d-e,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V94 AS SELECT d,
       b-c,
       abs(b-c),
       b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V95 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V96 AS SELECT b-c
  FROM t1
 WHERE a IS NULL
   AND (e>c OR e<d)
;

CREATE VIEW V97 AS SELECT abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       c-d,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
;

CREATE VIEW V98 AS SELECT d
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V99 AS SELECT c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND e+d BETWEEN a+b-10 AND c+130
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V100 AS SELECT a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       d,
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR a>b
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V101 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       d,
       a-b,
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       abs(a)
  FROM t1
;

CREATE VIEW V102 AS SELECT a+b*2,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       a-b,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V103 AS SELECT abs(b-c),
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       c,
       e,
       d
  FROM t1
 WHERE a>b
    OR (e>c OR e<d)
    OR b IS NOT NULL
;

CREATE VIEW V104 AS SELECT a+b*2,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR b>c
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V105 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE b>c
;

CREATE VIEW V106 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       a+b*2,
       abs(a),
       c-d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND c BETWEEN b-2 AND d+2
;

CREATE VIEW V107 AS SELECT b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
   AND a>b
;

CREATE VIEW V108 AS SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V109 AS SELECT a
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V110 AS SELECT a+b*2+c*3,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a
  FROM t1
 WHERE b IS NOT NULL
;

CREATE VIEW V111 AS SELECT a+b*2+c*3,
       d-e,
       (a+b+c+d+e)/5
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V112 AS SELECT abs(a),
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V113 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR a>b
    OR b IS NOT NULL
;

CREATE VIEW V114 AS SELECT abs(b-c)
  FROM t1
 WHERE b IS NOT NULL
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V115 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2,
       d,
       a+b*2+c*3+d*4,
       a-b,
       b-c,
       a
  FROM t1
 WHERE b>c
    OR a IS NULL
;

CREATE VIEW V116 AS SELECT a+b*2+c*3
  FROM t1
 WHERE a>b
;

CREATE VIEW V117 AS SELECT a+b*2,
       a,
       b,
       c,
       abs(b-c),
       abs(a),
       d
  FROM t1
;

CREATE VIEW V118 AS SELECT b-c,
       abs(a)
  FROM t1
 WHERE b IS NOT NULL
    OR e+d BETWEEN a+b-10 AND c+130
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V119 AS SELECT c-d,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
   AND a>b
;

CREATE VIEW V120 AS SELECT a+b*2+c*3+d*4+e*5,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       abs(b-c),
       d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR a>b
;

CREATE VIEW V121 AS SELECT abs(a),
       d,
       e,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V122 AS SELECT d-e,
       abs(b-c),
       a+b*2+c*3,
       a+b*2,
       a-b
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V123 AS SELECT a+b*2+c*3+d*4,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
    OR c>d
;

CREATE VIEW V124 AS SELECT (a+b+c+d+e)/5,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       d-e
  FROM t1
 WHERE a>b
   AND (e>c OR e<d)
   AND a IS NULL
;

CREATE VIEW V125 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a IS NULL
   AND d>e
;

CREATE VIEW V126 AS SELECT d,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       c,
       a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIEW V127 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       b-c,
       e
  FROM t1
;

CREATE VIEW V128 AS SELECT a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR d>e
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V129 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       c-d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V130 AS SELECT a+b*2+c*3+d*4+e*5,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V131 AS SELECT c,
       b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V132 AS SELECT (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 WHERE c>d
;

CREATE VIEW V133 AS SELECT abs(b-c),
       (a+b+c+d+e)/5,
       d
  FROM t1
 WHERE (e>a AND e<b)
   AND a IS NULL
;

CREATE VIEW V134 AS SELECT b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V135 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       c-d,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V136 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V137 AS SELECT a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
;

CREATE VIEW V138 AS SELECT abs(a),
       (a+b+c+d+e)/5,
       a+b*2,
       c,
       b,
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V139 AS SELECT d-e,
       a
  FROM t1
 WHERE b>c
   AND (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V140 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND d>e
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V141 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V142 AS SELECT a+b*2+c*3+d*4,
       d,
       d-e,
       a-b
  FROM t1
;

CREATE VIEW V143 AS SELECT d-e,
       a-b
  FROM t1
;

CREATE VIEW V144 AS SELECT abs(a),
       a+b*2+c*3,
       c-d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND b IS NOT NULL
   AND c>d
;

CREATE VIEW V145 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e
  FROM t1
 WHERE a>b
;

CREATE VIEW V146 AS SELECT c-d,
       d-e,
       a-b,
       (a+b+c+d+e)/5,
       b,
       a,
       abs(b-c)
  FROM t1
 WHERE d>e
   AND b IS NOT NULL
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V147 AS SELECT a,
       d,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V148 AS SELECT d,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V149 AS SELECT b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
 WHERE a>b
;

CREATE VIEW V150 AS SELECT (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 WHERE a>b
;

CREATE VIEW V151 AS SELECT abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V152 AS SELECT a-b,
       b-c,
       abs(b-c)
  FROM t1
;

CREATE VIEW V153 AS SELECT c
  FROM t1
 WHERE (e>c OR e<d)
    OR a>b
;

CREATE VIEW V154 AS SELECT (a+b+c+d+e)/5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a,
       c
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V155 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d>e
   AND b>c
;

CREATE VIEW V156 AS SELECT a+b*2
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V157 AS SELECT a+b*2+c*3,
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2
  FROM t1
 WHERE d>e
;

CREATE VIEW V158 AS SELECT d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR b>c
    OR c>d
;

CREATE VIEW V159 AS SELECT c,
       e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a>b
;

CREATE VIEW V160 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR a>b
;

CREATE VIEW V161 AS SELECT b,
       d,
       a,
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       abs(a)
  FROM t1
 WHERE d>e
    OR a IS NULL
;

CREATE VIEW V162 AS SELECT a+b*2+c*3+d*4,
       c,
       c-d,
       b-c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR a>b
    OR b IS NOT NULL
;

CREATE VIEW V163 AS SELECT abs(b-c),
       b-c,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a)
  FROM t1
;

CREATE VIEW V164 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V165 AS SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V166 AS SELECT abs(b-c),
       b,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIEW V167 AS SELECT abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
   AND c>d
;

CREATE VIEW V168 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       c-d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V169 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
    OR coalesce(a,b,c,d,e)<>0
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V170 AS SELECT a-b,
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       a+b*2
  FROM t1
;

CREATE VIEW V171 AS SELECT a+b*2+c*3+d*4,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
    OR b IS NOT NULL
;

CREATE VIEW V172 AS SELECT c
  FROM t1
 WHERE b>c
    OR b IS NOT NULL
    OR (e>c OR e<d)
;

CREATE VIEW V173 AS SELECT d-e,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2
  FROM t1
;

CREATE VIEW V174 AS SELECT a+b*2+c*3+d*4+e*5,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V175 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIEW V176 AS SELECT d-e
  FROM t1
;

CREATE VIEW V177 AS SELECT b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       e,
       b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a IS NULL
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V178 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       a+b*2,
       a
  FROM t1
;

CREATE VIEW V179 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
;

CREATE VIEW V180 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V181 AS SELECT a+b*2+c*3
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND d>e
;

CREATE VIEW V182 AS SELECT d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c)
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V183 AS SELECT abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       (a+b+c+d+e)/5,
       b,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V184 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIEW V185 AS SELECT c-d,
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIEW V186 AS SELECT b,
       a+b*2+c*3+d*4,
       c-d,
       a,
       b-c,
       a+b*2,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
    OR b IS NOT NULL
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V187 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V188 AS SELECT abs(b-c),
       c-d,
       c,
       d-e,
       abs(a),
       b-c
  FROM t1
 WHERE b IS NOT NULL
    OR (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V189 AS SELECT a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V190 AS SELECT c-d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V191 AS SELECT a+b*2+c*3+d*4,
       b,
       a-b,
       e,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
    OR b IS NOT NULL
;

CREATE VIEW V192 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
    OR a>b
;

CREATE VIEW V193 AS SELECT d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE b>c
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V194 AS SELECT abs(b-c),
       e,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V195 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V196 AS SELECT c-d,
       d,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c>d
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>a AND e<b)
;

CREATE VIEW V197 AS SELECT a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V198 AS SELECT d,
       a-b,
       c-d,
       a+b*2+c*3,
       e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
    OR a IS NULL
;

CREATE VIEW V199 AS SELECT a
  FROM t1
;

CREATE VIEW V200 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       abs(a),
       a+b*2+c*3+d*4+e*5,
       d-e
  FROM t1
;

CREATE VIEW V201 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       abs(b-c),
       abs(a),
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V202 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       c-d
  FROM t1
;

CREATE VIEW V203 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       c-d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V204 AS SELECT c,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE b>c
    OR c>d
    OR a>b
;

CREATE VIEW V205 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       e,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a IS NULL
    OR (e>a AND e<b)
;

CREATE VIEW V206 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       b-c,
       abs(a),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V207 AS SELECT e,
       a+b*2+c*3+d*4+e*5,
       d
  FROM t1
;

CREATE VIEW V208 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       b-c,
       d-e,
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIEW V209 AS SELECT d,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a IS NULL
   AND a>b
;

CREATE VIEW V210 AS SELECT b-c,
       c-d,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIEW V211 AS SELECT a,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b
  FROM t1
 WHERE b IS NOT NULL
    OR d>e
;

CREATE VIEW V212 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND a IS NULL
;

CREATE VIEW V213 AS SELECT a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e
  FROM t1
;

CREATE VIEW V214 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       c,
       e,
       a+b*2+c*3
  FROM t1
;

CREATE VIEW V215 AS SELECT (a+b+c+d+e)/5,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V216 AS SELECT c-d,
       abs(b-c),
       b,
       abs(a),
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V217 AS SELECT a+b*2+c*3+d*4,
       e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       c-d,
       abs(a)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V218 AS SELECT (a+b+c+d+e)/5
  FROM t1
;

CREATE VIEW V219 AS SELECT a+b*2,
       c-d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V220 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V221 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V222 AS SELECT d,
       c-d
  FROM t1
;

CREATE VIEW V223 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a
  FROM t1
 WHERE b>c
   AND a>b
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V224 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       e,
       a+b*2,
       c-d,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIEW V225 AS SELECT e,
       d-e,
       a+b*2+c*3+d*4,
       c,
       d,
       a-b,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V226 AS SELECT abs(b-c),
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIEW V227 AS SELECT c-d,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e
  FROM t1
 WHERE c>d
    OR a IS NULL
    OR (e>c OR e<d)
;

CREATE VIEW V228 AS SELECT abs(b-c),
       (a+b+c+d+e)/5,
       b-c,
       a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V229 AS SELECT (a+b+c+d+e)/5,
       d,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3
  FROM t1
 WHERE b IS NOT NULL
;

CREATE VIEW V230 AS SELECT c,
       a+b*2+c*3,
       b-c,
       a-b
  FROM t1
;

CREATE VIEW V231 AS SELECT abs(a)
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
;

CREATE VIEW V232 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       a-b,
       c-d
  FROM t1
;

CREATE VIEW V233 AS SELECT a+b*2+c*3+d*4,
       abs(b-c),
       d-e,
       abs(a),
       a,
       e,
       c-d
  FROM t1
;

CREATE VIEW V234 AS SELECT c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
;

CREATE VIEW V235 AS SELECT a+b*2,
       (a+b+c+d+e)/5,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       e
  FROM t1
 WHERE a>b
    OR a IS NULL
    OR b IS NOT NULL
;

CREATE VIEW V236 AS SELECT a+b*2+c*3,
       d-e,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V237 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       abs(b-c),
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
;

CREATE VIEW V238 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V239 AS SELECT d-e
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIEW V240 AS SELECT b,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V241 AS SELECT d-e,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V242 AS SELECT d-e,
       abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
   AND d>e
;

CREATE VIEW V243 AS SELECT b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       a+b*2+c*3
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND (e>a AND e<b)
;

CREATE VIEW V244 AS SELECT d,
       d-e,
       a,
       b-c,
       e
  FROM t1
 WHERE (e>c OR e<d)
    OR a IS NULL
;

CREATE VIEW V245 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V246 AS SELECT d-e,
       d,
       c,
       b-c
  FROM t1
 WHERE a IS NULL
   AND b>c
;

CREATE VIEW V247 AS SELECT abs(a),
       a+b*2,
       a+b*2+c*3,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V248 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V249 AS SELECT c-d
  FROM t1
;

CREATE VIEW V250 AS SELECT abs(a),
       a+b*2+c*3,
       a+b*2,
       c,
       d,
       a-b,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE b IS NOT NULL
;

CREATE VIEW V251 AS SELECT a,
       a-b,
       a+b*2,
       a+b*2+c*3,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIEW V252 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V253 AS SELECT a,
       a+b*2+c*3,
       d-e
  FROM t1
 WHERE d>e
   AND b IS NOT NULL
;

CREATE VIEW V254 AS SELECT b,
       d-e,
       (a+b+c+d+e)/5,
       d,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V255 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e
  FROM t1
 WHERE a>b
    OR b>c
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V256 AS SELECT d,
       b-c,
       a+b*2+c*3,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V257 AS SELECT a+b*2
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V258 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V259 AS SELECT d,
       a-b,
       b-c,
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a>b
;

CREATE VIEW V260 AS SELECT a+b*2+c*3+d*4,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V261 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       abs(a),
       abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
;

CREATE VIEW V262 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
;

CREATE VIEW V263 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V264 AS SELECT a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE c>d
;

CREATE VIEW V265 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V266 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE b IS NOT NULL
    OR a>b
;

CREATE VIEW V267 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       a+b*2
  FROM t1
 WHERE c>d
   AND b>c
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V268 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE d>e
   AND a>b
   AND b>c
;

CREATE VIEW V269 AS SELECT abs(b-c)
  FROM t1
;

CREATE VIEW V270 AS SELECT abs(a),
       d-e,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
;

CREATE VIEW V271 AS SELECT b,
       a+b*2,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a)
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V272 AS SELECT e,
       b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
    OR b>c
;

CREATE VIEW V273 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
;

CREATE VIEW V274 AS SELECT d-e,
       a-b,
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       b-c,
       d
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V275 AS SELECT abs(a),
       abs(b-c),
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c>d
   AND (a>b-2 AND a<b+2)
   AND b>c
;

CREATE VIEW V276 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c>d
;

CREATE VIEW V277 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c
  FROM t1
;

CREATE VIEW V278 AS SELECT a,
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a IS NULL
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V279 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
;

CREATE VIEW V280 AS SELECT a+b*2+c*3+d*4+e*5,
       b-c,
       b,
       a,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIEW V281 AS SELECT abs(b-c),
       d,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V282 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V283 AS SELECT b-c,
       c-d,
       d-e,
       (a+b+c+d+e)/5,
       d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V284 AS SELECT b,
       e,
       a+b*2+c*3+d*4+e*5,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V285 AS SELECT a+b*2+c*3+d*4+e*5,
       c,
       c-d,
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND d>e
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V286 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       a+b*2,
       abs(b-c),
       abs(a),
       b-c,
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
;

CREATE VIEW V287 AS SELECT a
  FROM t1
 WHERE b IS NOT NULL
   AND d>e
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V288 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       b-c,
       a,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIEW V289 AS SELECT d-e,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b IS NOT NULL
    OR a>b
;

CREATE VIEW V290 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE d>e
    OR (e>c OR e<d)
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V291 AS SELECT a-b
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIEW V292 AS SELECT a-b,
       (a+b+c+d+e)/5,
       a,
       a+b*2,
       e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V293 AS SELECT c,
       c-d,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V294 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V295 AS SELECT e,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V296 AS SELECT (a+b+c+d+e)/5,
       a,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND (e>c OR e<d)
;

CREATE VIEW V297 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
   AND a>b
   AND a IS NULL
;

CREATE VIEW V298 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       d
  FROM t1
 WHERE (e>a AND e<b)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR a>b
;

CREATE VIEW V299 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       b-c,
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V300 AS SELECT abs(b-c),
       b-c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND coalesce(a,b,c,d,e)<>0
   AND (e>c OR e<d)
;

CREATE VIEW V301 AS SELECT b-c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V302 AS SELECT a-b,
       d-e,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V303 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       d,
       abs(b-c),
       e,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V304 AS SELECT a+b*2
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIEW V305 AS SELECT a+b*2+c*3,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2 AND d+2
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V306 AS SELECT a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c),
       c-d
  FROM t1
 WHERE a>b
;

CREATE VIEW V307 AS SELECT c-d,
       a+b*2+c*3,
       d-e,
       a+b*2+c*3+d*4,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b IS NOT NULL
    OR (e>a AND e<b)
    OR (e>c OR e<d)
;

CREATE VIEW V308 AS SELECT c-d,
       a,
       a+b*2+c*3,
       a-b
  FROM t1
;

CREATE VIEW V309 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a IS NULL
    OR c BETWEEN b-2 AND d+2
    OR a>b
;

CREATE VIEW V310 AS SELECT e
  FROM t1
 WHERE c>d
   AND coalesce(a,b,c,d,e)<>0
   AND a>b
;

CREATE VIEW V311 AS SELECT d-e,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       a+b*2+c*3,
       c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIEW V312 AS SELECT abs(a),
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V313 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR a>b
;

CREATE VIEW V314 AS SELECT a,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>a AND e<b)
;

CREATE VIEW V315 AS SELECT d-e,
       c,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V316 AS SELECT b,
       c-d,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V317 AS SELECT a,
       a+b*2,
       a-b
  FROM t1
;

CREATE VIEW V318 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
    OR e+d BETWEEN a+b-10 AND c+130
    OR d>e
;

CREATE VIEW V319 AS SELECT c-d,
       a-b,
       (a+b+c+d+e)/5,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V320 AS SELECT d-e,
       b-c,
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND a>b
   AND a IS NULL
;

CREATE VIEW V321 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V322 AS SELECT (a+b+c+d+e)/5,
       a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V323 AS SELECT (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND a IS NULL
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V324 AS SELECT b-c,
       e,
       c-d,
       a-b
  FROM t1
 WHERE b>c
    OR a IS NULL
    OR b IS NOT NULL
;

CREATE VIEW V325 AS SELECT (a+b+c+d+e)/5,
       abs(b-c),
       d
  FROM t1
 WHERE a>b
    OR a IS NULL
    OR b>c
;

CREATE VIEW V326 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       a-b,
       abs(b-c),
       (a+b+c+d+e)/5
  FROM t1
 WHERE b IS NOT NULL
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V327 AS SELECT d,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V328 AS SELECT a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       c,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       abs(b-c)
  FROM t1
;

CREATE VIEW V329 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c)
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V330 AS SELECT a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       a+b*2+c*3,
       b-c,
       a
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V331 AS SELECT abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       abs(b-c),
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V332 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE b>c
;

CREATE VIEW V333 AS SELECT c,
       b,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND coalesce(a,b,c,d,e)<>0
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V334 AS SELECT c-d,
       a-b,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       d,
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
   AND b IS NOT NULL
;

CREATE VIEW V335 AS SELECT a-b,
       b,
       a+b*2,
       a+b*2+c*3+d*4+e*5,
       d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
;

CREATE VIEW V336 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
;

CREATE VIEW V337 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d>e
    OR a>b
;

CREATE VIEW V338 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       d,
       a+b*2+c*3,
       c,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIEW V339 AS SELECT a+b*2+c*3+d*4,
       a+b*2,
       d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       a
  FROM t1
;

CREATE VIEW V340 AS SELECT a+b*2+c*3,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V341 AS SELECT a+b*2+c*3+d*4+e*5,
       a,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V342 AS SELECT abs(b-c),
       abs(a),
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V343 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       b-c,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b IS NOT NULL
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V344 AS SELECT a+b*2,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>a AND e<b)
    OR a IS NULL
;

CREATE VIEW V345 AS SELECT a,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
;

CREATE VIEW V346 AS SELECT d
  FROM t1
 WHERE c>d
    OR b>c
;

CREATE VIEW V347 AS SELECT d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       c,
       a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIEW V348 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2,
       d-e,
       abs(a),
       a+b*2+c*3
  FROM t1
 WHERE b>c
    OR a>b
;

CREATE VIEW V349 AS SELECT a+b*2+c*3,
       (a+b+c+d+e)/5,
       b-c,
       e,
       abs(b-c),
       c-d,
       b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
   AND b>c
;

CREATE VIEW V350 AS SELECT a+b*2+c*3+d*4+e*5,
       c,
       abs(a),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
;

CREATE VIEW V351 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V352 AS SELECT e,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d>e
    OR c BETWEEN b-2 AND d+2
    OR (e>a AND e<b)
;

CREATE VIEW V353 AS SELECT a+b*2+c*3,
       a-b,
       d-e
  FROM t1
 WHERE a IS NULL
    OR b>c
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V354 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V355 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V356 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       a-b
  FROM t1
;

CREATE VIEW V357 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       d-e,
       c,
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V358 AS SELECT a-b,
       a+b*2+c*3+d*4,
       c-d,
       b-c,
       abs(a),
       e
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V359 AS SELECT d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V360 AS SELECT b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2
  FROM t1
;

CREATE VIEW V361 AS SELECT b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a IS NULL
;

CREATE VIEW V362 AS SELECT c-d,
       abs(a),
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIEW V363 AS SELECT abs(b-c),
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       b-c
  FROM t1
;

CREATE VIEW V364 AS SELECT d,
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V365 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIEW V366 AS SELECT a+b*2+c*3,
       abs(b-c),
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V367 AS SELECT d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIEW V368 AS SELECT a+b*2+c*3+d*4,
       c-d,
       a+b*2+c*3
  FROM t1
;

CREATE VIEW V369 AS SELECT (a+b+c+d+e)/5,
       abs(b-c),
       a+b*2,
       d-e,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
;

CREATE VIEW V370 AS SELECT a-b,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIEW V371 AS SELECT (a+b+c+d+e)/5
  FROM t1
;

CREATE VIEW V372 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       a
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR d>e
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V373 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V374 AS SELECT a+b*2+c*3,
       abs(a),
       c,
       a+b*2+c*3+d*4,
       e,
       a,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE a IS NULL
   AND coalesce(a,b,c,d,e)<>0
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V375 AS SELECT c-d,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
   AND d>e
;

CREATE VIEW V376 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       a-b,
       a+b*2,
       b,
       c-d
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2 AND d+2
;

CREATE VIEW V377 AS SELECT c-d,
       e,
       a+b*2+c*3+d*4,
       c,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V378 AS SELECT d,
       d-e,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       b
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR b>c
    OR a>b
;

CREATE VIEW V379 AS SELECT d,
       c,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a),
       e
  FROM t1
;

CREATE VIEW V380 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>a AND e<b)
    OR b IS NOT NULL
;

CREATE VIEW V381 AS SELECT d,
       e,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       c-d
  FROM t1
;

CREATE VIEW V382 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V383 AS SELECT e,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       a-b,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIEW V384 AS SELECT c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
    OR a IS NULL
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V385 AS SELECT e,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE b>c
   AND d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V386 AS SELECT d,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c)
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND c>d
;

CREATE VIEW V387 AS SELECT a+b*2+c*3
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V388 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       abs(a),
       d-e,
       b-c,
       a
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIEW V389 AS SELECT b-c,
       abs(b-c),
       a-b
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V390 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       c,
       b,
       a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
   AND d>e
;

CREATE VIEW V391 AS SELECT abs(b-c),
       a+b*2+c*3+d*4,
       e,
       b-c
  FROM t1
 WHERE a IS NULL
    OR coalesce(a,b,c,d,e)<>0
    OR b>c
;

CREATE VIEW V392 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V393 AS SELECT c-d,
       a-b
  FROM t1
 WHERE d>e
;

CREATE VIEW V394 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3,
       c-d,
       d-e,
       a+b*2
  FROM t1
 WHERE d>e
    OR (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V395 AS SELECT b,
       a+b*2+c*3+d*4,
       a+b*2,
       d-e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE c>d
    OR (c<=d-2 OR c>=d+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V396 AS SELECT b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       a
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
;

CREATE VIEW V397 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V398 AS SELECT e,
       c-d
  FROM t1
;

CREATE VIEW V399 AS SELECT d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR c>d
;

CREATE VIEW V400 AS SELECT abs(a)
  FROM t1
;

CREATE VIEW V401 AS SELECT a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
   AND d>e
;

CREATE VIEW V402 AS SELECT a,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V403 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       abs(a)
  FROM t1
;

CREATE VIEW V404 AS SELECT d-e,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V405 AS SELECT abs(a),
       b,
       abs(b-c),
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIEW V406 AS SELECT c-d,
       a+b*2+c*3+d*4,
       a,
       b-c
  FROM t1
;

CREATE VIEW V407 AS SELECT a+b*2,
       abs(a),
       b,
       c,
       d,
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
   AND b IS NOT NULL
;

CREATE VIEW V408 AS SELECT d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V409 AS SELECT e,
       a-b,
       b-c,
       b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE a>b
;

CREATE VIEW V410 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       c-d,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V411 AS SELECT a+b*2,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V412 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a)
  FROM t1
 WHERE a>b
;

CREATE VIEW V413 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       d-e,
       a,
       a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V414 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       a,
       d-e,
       e,
       c
  FROM t1
 WHERE c>d
;

CREATE VIEW V415 AS SELECT b,
       c,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
;

CREATE VIEW V416 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       abs(a),
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a IS NULL
   AND (e>c OR e<d)
;

CREATE VIEW V417 AS SELECT a,
       c-d,
       b,
       a+b*2,
       b-c,
       a-b
  FROM t1
 WHERE b IS NOT NULL
   AND b>c
;

CREATE VIEW V418 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       a,
       abs(b-c)
  FROM t1
;

CREATE VIEW V419 AS SELECT a+b*2,
       e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V420 AS SELECT abs(a),
       a+b*2+c*3+d*4,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V421 AS SELECT e,
       abs(b-c)
  FROM t1
;

CREATE VIEW V422 AS SELECT d-e,
       a+b*2,
       c-d,
       e
  FROM t1
;

CREATE VIEW V423 AS SELECT c-d,
       abs(b-c),
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
 WHERE b>c
    OR c>d
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V424 AS SELECT a+b*2+c*3,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V425 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V426 AS SELECT a+b*2,
       d-e,
       d,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V427 AS SELECT b-c,
       c,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       abs(a)
  FROM t1
;

CREATE VIEW V428 AS SELECT a+b*2+c*3+d*4+e*5,
       c-d,
       abs(b-c)
  FROM t1
;

CREATE VIEW V429 AS SELECT a,
       c-d,
       b,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
   AND b>c
;

CREATE VIEW V430 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       abs(a),
       abs(b-c),
       c-d
  FROM t1
;

CREATE VIEW V431 AS SELECT a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V432 AS SELECT b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND a>b
;

CREATE VIEW V433 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c
  FROM t1
;

CREATE VIEW V434 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
 WHERE d>e
    OR a IS NULL
;

CREATE VIEW V435 AS SELECT abs(b-c)
  FROM t1
 WHERE b IS NOT NULL
    OR (c<=d-2 OR c>=d+2)
    OR d>e
;

CREATE VIEW V436 AS SELECT a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V437 AS SELECT a+b*2+c*3+d*4+e*5,
       a
  FROM t1
;

CREATE VIEW V438 AS SELECT (a+b+c+d+e)/5,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
;

CREATE VIEW V439 AS SELECT d,
       c,
       a-b
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V440 AS SELECT a,
       c,
       d-e,
       d
  FROM t1
;

CREATE VIEW V441 AS SELECT b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a IS NULL
   AND (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V442 AS SELECT abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIEW V443 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND b IS NOT NULL
   AND (e>a AND e<b)
;

CREATE VIEW V444 AS SELECT b-c,
       a-b,
       d-e
  FROM t1
 WHERE b IS NOT NULL
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V445 AS SELECT a,
       b-c,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
   AND a>b
;

CREATE VIEW V446 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       a+b*2,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V447 AS SELECT abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
;

CREATE VIEW V448 AS SELECT a+b*2,
       c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE a>b
    OR b>c
;

CREATE VIEW V449 AS SELECT a-b,
       b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIEW V450 AS SELECT abs(b-c)
  FROM t1
 WHERE a IS NULL
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V451 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       b
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V452 AS SELECT abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       b-c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
   AND coalesce(a,b,c,d,e)<>0
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V453 AS SELECT e,
       a+b*2+c*3,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V454 AS SELECT b-c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR (e>c OR e<d)
    OR a IS NULL
;

CREATE VIEW V455 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
;

CREATE VIEW V456 AS SELECT a+b*2+c*3,
       b-c
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V457 AS SELECT e,
       a+b*2+c*3+d*4+e*5,
       d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
   AND d NOT BETWEEN 110 AND 150
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V458 AS SELECT a+b*2
  FROM t1
;

CREATE VIEW V459 AS SELECT d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V460 AS SELECT (a+b+c+d+e)/5
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND (e>a AND e<b)
   AND b IS NOT NULL
;

CREATE VIEW V461 AS SELECT abs(b-c),
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V462 AS SELECT a+b*2,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b IS NOT NULL
   AND c>d
   AND c BETWEEN b-2 AND d+2
;

CREATE VIEW V463 AS SELECT c,
       a+b*2+c*3+d*4,
       b,
       abs(b-c),
       (a+b+c+d+e)/5,
       abs(a)
  FROM t1
;

CREATE VIEW V464 AS SELECT c-d,
       abs(a)
  FROM t1
;

CREATE VIEW V465 AS SELECT a-b,
       a+b*2+c*3+d*4,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
;

CREATE VIEW V466 AS SELECT d-e,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V467 AS SELECT c,
       b-c,
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V468 AS SELECT b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V469 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V470 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE a IS NULL
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V471 AS SELECT a+b*2+c*3,
       e,
       c-d,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b IS NOT NULL
;

CREATE VIEW V472 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIEW V473 AS SELECT d-e
  FROM t1
;

CREATE VIEW V474 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b IS NOT NULL
    OR coalesce(a,b,c,d,e)<>0
    OR a IS NULL
;

CREATE VIEW V475 AS SELECT d-e,
       a+b*2+c*3+d*4+e*5,
       b-c,
       a,
       d,
       b
  FROM t1
 WHERE b IS NOT NULL
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V476 AS SELECT a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       d
  FROM t1
 WHERE b>c
;

CREATE VIEW V477 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V478 AS SELECT a+b*2,
       c,
       d-e,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V479 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR a IS NULL
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V480 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V481 AS SELECT a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e
  FROM t1
;

CREATE VIEW V482 AS SELECT e,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V483 AS SELECT c-d
  FROM t1
 WHERE a>b
;

CREATE VIEW V484 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       a,
       abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR e+d BETWEEN a+b-10 AND c+130
    OR d>e
;

CREATE VIEW V485 AS SELECT a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIEW V486 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V487 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       b-c,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V488 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V489 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c>d
    OR (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V490 AS SELECT c,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V491 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       a-b,
       b
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
    OR d>e
;

CREATE VIEW V492 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V493 AS SELECT d-e,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V494 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V495 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V496 AS SELECT a+b*2+c*3+d*4+e*5,
       e,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V497 AS SELECT a+b*2+c*3+d*4,
       c,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
   AND (e>c OR e<d)
;

CREATE VIEW V498 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
   AND (e>c OR e<d)
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V499 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       c-d,
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110 AND 150
   AND b>c
;

CREATE VIEW V500 AS SELECT e,
       a+b*2+c*3,
       a+b*2,
       a,
       abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b
  FROM t1
 WHERE b>c
;

CREATE VIEW V501 AS SELECT e
  FROM t1
 WHERE b>c
;

CREATE VIEW V502 AS SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V503 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a-b,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V504 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
;

CREATE VIEW V505 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a+b*2+c*3+d*4+e*5,
       a
  FROM t1
;

CREATE VIEW V506 AS SELECT a+b*2,
       c-d,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V507 AS SELECT b,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e,
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V508 AS SELECT c,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V509 AS SELECT a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
;

CREATE VIEW V510 AS SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
;

CREATE VIEW V511 AS SELECT a+b*2,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIEW V512 AS SELECT b,
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a>b
   AND d>e
;

CREATE VIEW V513 AS SELECT b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V514 AS SELECT abs(a),
       abs(b-c),
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V515 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V516 AS SELECT a+b*2,
       a-b,
       b,
       d
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110 AND 150
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V517 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V518 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       d,
       e,
       d-e
  FROM t1
;

CREATE VIEW V519 AS SELECT a+b*2,
       b-c,
       c,
       b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c>d
   AND b>c
;

CREATE VIEW V520 AS SELECT c-d,
       a,
       a+b*2,
       abs(a),
       (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE a IS NULL
    OR (c<=d-2 OR c>=d+2)
    OR b>c
;

CREATE VIEW V521 AS SELECT b-c,
       a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR a IS NULL
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V522 AS SELECT e
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
;

CREATE VIEW V523 AS SELECT a+b*2+c*3+d*4+e*5,
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V524 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b IS NOT NULL
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V525 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V526 AS SELECT a-b,
       c,
       (a+b+c+d+e)/5,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V527 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       c-d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE a>b
    OR d>e
;

CREATE VIEW V528 AS SELECT a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V529 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       a+b*2+c*3,
       c-d,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIEW V530 AS SELECT abs(a),
       c,
       abs(b-c),
       b-c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR c>d
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V531 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       abs(a)
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND c>d
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V532 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       b,
       a-b,
       a,
       a+b*2+c*3
  FROM t1
 WHERE a IS NULL
    OR b>c
;

CREATE VIEW V533 AS SELECT a+b*2+c*3+d*4,
       a-b,
       b-c,
       b,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIEW V534 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       a+b*2+c*3+d*4,
       abs(b-c),
       d-e
  FROM t1
;

CREATE VIEW V535 AS SELECT abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V536 AS SELECT d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V537 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIEW V538 AS SELECT c-d,
       abs(a)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIEW V539 AS SELECT abs(b-c),
       c-d
  FROM t1
 WHERE b IS NOT NULL
;

CREATE VIEW V540 AS SELECT b,
       c,
       e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V541 AS SELECT a-b,
       c,
       b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3
  FROM t1
;

CREATE VIEW V542 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       a+b*2+c*3+d*4+e*5,
       d
  FROM t1
;

CREATE VIEW V543 AS SELECT a-b,
       (a+b+c+d+e)/5,
       abs(a)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b IS NOT NULL
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V544 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V545 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b IS NOT NULL
;

CREATE VIEW V546 AS SELECT a+b*2,
       a-b
  FROM t1
 WHERE a>b
   AND d>e
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V547 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d
  FROM t1
 WHERE (e>a AND e<b)
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V548 AS SELECT d,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c>d
   AND b IS NOT NULL
   AND a>b
;

CREATE VIEW V549 AS SELECT a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       (a+b+c+d+e)/5,
       d-e
  FROM t1
;

CREATE VIEW V550 AS SELECT a,
       abs(a),
       a+b*2+c*3+d*4+e*5,
       a+b*2
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c>d
;

CREATE VIEW V551 AS SELECT c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIEW V552 AS SELECT b-c,
       a+b*2+c*3+d*4,
       b,
       c-d,
       a+b*2+c*3
  FROM t1
 WHERE d>e
   AND c>d
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V553 AS SELECT b,
       (a+b+c+d+e)/5,
       a-b,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e
  FROM t1
 WHERE d>e
;

CREATE VIEW V554 AS SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       a+b*2
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V555 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V556 AS SELECT a+b*2,
       b-c,
       c-d
  FROM t1
;

CREATE VIEW V557 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V558 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
;

CREATE VIEW V559 AS SELECT a,
       c-d,
       abs(a)
  FROM t1
 WHERE d>e
;

CREATE VIEW V560 AS SELECT abs(b-c),
       a-b,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c
  FROM t1
;

CREATE VIEW V561 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       d-e,
       a+b*2+c*3
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110 AND 150
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V562 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V563 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       c-d,
       d,
       a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
;

CREATE VIEW V564 AS SELECT a,
       d-e,
       e,
       a+b*2+c*3,
       abs(b-c),
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c>d
;

CREATE VIEW V565 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V566 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d-e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V567 AS SELECT a+b*2+c*3
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V568 AS SELECT (a+b+c+d+e)/5,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
;

CREATE VIEW V569 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V570 AS SELECT b,
       d-e,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a IS NULL
   AND d>e
;

CREATE VIEW V571 AS SELECT e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V572 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       e,
       c-d,
       b-c,
       d
  FROM t1
 WHERE d>e
   AND a>b
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V573 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V574 AS SELECT c,
       a-b
  FROM t1
 WHERE a>b
;

CREATE VIEW V575 AS SELECT (a+b+c+d+e)/5,
       abs(b-c),
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       b,
       abs(a)
  FROM t1
 WHERE c>d
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V576 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V577 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       a
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
;

CREATE VIEW V578 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       a+b*2+c*3,
       d-e,
       (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
    OR b IS NOT NULL
;

CREATE VIEW V579 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       c-d,
       a-b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR a>b
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V580 AS SELECT a-b,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V581 AS SELECT c-d,
       a+b*2,
       d-e
  FROM t1
 WHERE c>d
;

CREATE VIEW V582 AS SELECT (a+b+c+d+e)/5,
       abs(b-c),
       a+b*2+c*3,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V583 AS SELECT a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d>e
;

CREATE VIEW V584 AS SELECT a-b
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V585 AS SELECT d-e,
       c-d
  FROM t1
;

CREATE VIEW V586 AS SELECT c-d,
       d,
       abs(b-c),
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND (e>c OR e<d)
;

CREATE VIEW V587 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       b,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE b IS NOT NULL
    OR (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
;

CREATE VIEW V588 AS SELECT a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       e,
       d
  FROM t1
;

CREATE VIEW V589 AS SELECT c-d,
       abs(a),
       a+b*2,
       a+b*2+c*3+d*4,
       d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIEW V590 AS SELECT a,
       a+b*2+c*3+d*4,
       d
  FROM t1
 WHERE b IS NOT NULL
;

CREATE VIEW V591 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       abs(b-c)
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND d>e
;

CREATE VIEW V592 AS SELECT e,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V593 AS SELECT abs(b-c),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       c,
       a
  FROM t1
;

CREATE VIEW V594 AS SELECT abs(b-c),
       d-e,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       a,
       b,
       abs(a)
  FROM t1
 WHERE c>d
;

CREATE VIEW V595 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e,
       abs(b-c),
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIEW V596 AS SELECT a+b*2+c*3+d*4,
       d-e,
       c-d,
       abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V597 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
    OR b>c
;

CREATE VIEW V598 AS SELECT b,
       a+b*2,
       b-c,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIEW V599 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIEW V600 AS SELECT d-e,
       b-c,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V601 AS SELECT b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V602 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V603 AS SELECT a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIEW V604 AS SELECT d-e
  FROM t1
 WHERE c>d
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V605 AS SELECT (a+b+c+d+e)/5,
       c-d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V606 AS SELECT a-b
  FROM t1
 WHERE b IS NOT NULL
   AND c>d
;

CREATE VIEW V607 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
    OR c>d
;

CREATE VIEW V608 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       e,
       a+b*2+c*3,
       abs(b-c),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V609 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       d,
       c-d,
       a+b*2
  FROM t1
 WHERE a>b
    OR (c<=d-2 OR c>=d+2)
    OR a IS NULL
;

CREATE VIEW V610 AS SELECT b-c,
       a+b*2
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V611 AS SELECT (a+b+c+d+e)/5,
       a,
       b-c,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d
  FROM t1
 WHERE d>e
    OR c BETWEEN b-2 AND d+2
    OR (e>a AND e<b)
;

CREATE VIEW V612 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
    OR a>b
;

CREATE VIEW V613 AS SELECT b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       a-b,
       a+b*2,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V614 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIEW V615 AS SELECT c,
       a+b*2+c*3,
       (a+b+c+d+e)/5,
       a-b,
       d
  FROM t1
 WHERE (e>a AND e<b)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V616 AS SELECT abs(b-c),
       d-e,
       b,
       c
  FROM t1
;

CREATE VIEW V617 AS SELECT abs(b-c),
       c-d,
       d-e,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d>e
   AND b IS NOT NULL
;

CREATE VIEW V618 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND d NOT BETWEEN 110 AND 150
   AND b IS NOT NULL
;

CREATE VIEW V619 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       (a+b+c+d+e)/5
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V620 AS SELECT a+b*2+c*3+d*4+e*5,
       a-b,
       abs(a)
  FROM t1
;

CREATE VIEW V621 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V622 AS SELECT a-b,
       c,
       abs(a),
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V623 AS SELECT a+b*2+c*3+d*4,
       a+b*2,
       b,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V624 AS SELECT b-c,
       abs(b-c),
       a+b*2+c*3+d*4+e*5,
       d
  FROM t1
 WHERE d>e
;

CREATE VIEW V625 AS SELECT d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c)
  FROM t1
 WHERE b>c
   AND d>e
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V626 AS SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR a IS NULL
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V627 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V628 AS SELECT a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V629 AS SELECT d-e,
       e,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V630 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
    OR a IS NULL
;

CREATE VIEW V631 AS SELECT a+b*2+c*3,
       abs(b-c)
  FROM t1
;

CREATE VIEW V632 AS SELECT d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V633 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V634 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
;

CREATE VIEW V635 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c,
       a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V636 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3
  FROM t1
 WHERE a IS NULL
    OR (c<=d-2 OR c>=d+2)
    OR (e>a AND e<b)
;

CREATE VIEW V637 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2+c*3
  FROM t1
;

CREATE VIEW V638 AS SELECT b
  FROM t1
;

CREATE VIEW V639 AS SELECT a+b*2+c*3+d*4+e*5,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE a IS NULL
   AND c>d
   AND (e>a AND e<b)
;

CREATE VIEW V640 AS SELECT c-d
  FROM t1
 WHERE (e>c OR e<d)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V641 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c
  FROM t1
 WHERE a>b
    OR a IS NULL
;

CREATE VIEW V642 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
;

CREATE VIEW V643 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
;

CREATE VIEW V644 AS SELECT a-b,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2,
       b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V645 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2,
       b,
       d-e
  FROM t1
 WHERE b IS NOT NULL
;

CREATE VIEW V646 AS SELECT e,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       b-c,
       d-e
  FROM t1
;

CREATE VIEW V647 AS SELECT c,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       a+b*2
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c>d
    OR a IS NULL
;

CREATE VIEW V648 AS SELECT b-c,
       abs(a)
  FROM t1
;

CREATE VIEW V649 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b,
       a
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V650 AS SELECT a,
       c
  FROM t1
 WHERE d>e
   AND b>c
;

CREATE VIEW V651 AS SELECT b-c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V652 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V653 AS SELECT a+b*2+c*3+d*4,
       a-b,
       a+b*2+c*3,
       e
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V654 AS SELECT d-e,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
;

CREATE VIEW V655 AS SELECT (a+b+c+d+e)/5,
       d,
       c
  FROM t1
 WHERE b>c
;

CREATE VIEW V656 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2
  FROM t1
;

CREATE VIEW V657 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       d,
       e
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V658 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR a IS NULL
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V659 AS SELECT abs(a)
  FROM t1
 WHERE d>e
   AND a IS NULL
;

CREATE VIEW V660 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a)
  FROM t1
;

CREATE VIEW V661 AS SELECT b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V662 AS SELECT a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V663 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(a),
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       d
  FROM t1
 WHERE (e>a AND e<b)
    OR (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V664 AS SELECT d-e,
       (a+b+c+d+e)/5,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V665 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V666 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       a+b*2+c*3
  FROM t1
;

CREATE VIEW V667 AS SELECT c-d,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIEW V668 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
;

CREATE VIEW V669 AS SELECT a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR coalesce(a,b,c,d,e)<>0
    OR (e>c OR e<d)
;

CREATE VIEW V670 AS SELECT a+b*2,
       abs(b-c),
       a
  FROM t1
 WHERE a IS NULL
   AND (e>c OR e<d)
   AND c>d
;

CREATE VIEW V671 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       a+b*2+c*3,
       d,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIEW V672 AS SELECT d-e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
;

CREATE VIEW V673 AS SELECT abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c BETWEEN b-2 AND d+2
;

CREATE VIEW V674 AS SELECT a+b*2+c*3+d*4,
       a,
       b,
       abs(b-c)
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V675 AS SELECT a
  FROM t1
;

CREATE VIEW V676 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b IS NOT NULL
    OR c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
;

CREATE VIEW V677 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a+b*2
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND a>b
   AND b IS NOT NULL
;

CREATE VIEW V678 AS SELECT a-b,
       a+b*2+c*3,
       c-d,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c
  FROM t1
;

CREATE VIEW V679 AS SELECT c
  FROM t1
 WHERE a IS NULL
   AND (c<=d-2 OR c>=d+2)
   AND c>d
;

CREATE VIEW V680 AS SELECT e,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR e+d BETWEEN a+b-10 AND c+130
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V681 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       d
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2 AND d+2
;

CREATE VIEW V682 AS SELECT c-d,
       a+b*2+c*3+d*4+e*5,
       b,
       d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND b IS NOT NULL
;

CREATE VIEW V683 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V684 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
;

CREATE VIEW V685 AS SELECT a+b*2+c*3+d*4,
       a,
       abs(b-c),
       d-e,
       a+b*2
  FROM t1
 WHERE b IS NOT NULL
   AND a>b
   AND c BETWEEN b-2 AND d+2
;

CREATE VIEW V686 AS SELECT a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
;

CREATE VIEW V687 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       a+b*2,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V688 AS SELECT a+b*2
  FROM t1
 WHERE (e>a AND e<b)
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V689 AS SELECT a+b*2+c*3+d*4+e*5,
       e
  FROM t1
 WHERE (e>a AND e<b)
   AND (e>c OR e<d)
;

CREATE VIEW V690 AS SELECT d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c>d
    OR (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V691 AS SELECT (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
;

CREATE VIEW V692 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4
  FROM t1
 WHERE a IS NULL
   AND b IS NOT NULL
   AND c BETWEEN b-2 AND d+2
;

CREATE VIEW V693 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       c-d,
       a+b*2+c*3,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIEW V694 AS SELECT b-c,
       a+b*2,
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V695 AS SELECT c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
   AND b IS NOT NULL
   AND (e>a AND e<b)
;

CREATE VIEW V696 AS SELECT a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V697 AS SELECT d-e,
       b
  FROM t1
 WHERE a>b
;

CREATE VIEW V698 AS SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE a>b
    OR b>c
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V699 AS SELECT a-b
  FROM t1
;

CREATE VIEW V700 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       (a+b+c+d+e)/5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
   AND a IS NULL
;

CREATE VIEW V701 AS SELECT abs(b-c),
       c,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V702 AS SELECT abs(a),
       d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
   AND c>d
;

CREATE VIEW V703 AS SELECT d-e,
       c-d,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V704 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       b-c,
       e,
       a-b
  FROM t1
;

CREATE VIEW V705 AS SELECT c-d,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
;

CREATE VIEW V706 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a)
  FROM t1
 WHERE a>b
    OR (e>c OR e<d)
;

CREATE VIEW V707 AS SELECT d,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIEW V708 AS SELECT abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V709 AS SELECT d,
       b-c,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V710 AS SELECT a+b*2,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V711 AS SELECT abs(a),
       a+b*2+c*3,
       d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V712 AS SELECT a,
       a+b*2,
       a+b*2+c*3,
       b,
       abs(b-c),
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V713 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V714 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V715 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
    OR a>b
;

CREATE VIEW V716 AS SELECT abs(a),
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V717 AS SELECT c-d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V718 AS SELECT b,
       b-c,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b IS NOT NULL
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V719 AS SELECT e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR b IS NOT NULL
;

CREATE VIEW V720 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2+c*3,
       c-d,
       e,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V721 AS SELECT abs(a),
       a-b,
       a+b*2+c*3+d*4,
       a+b*2
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V722 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       a-b
  FROM t1
 WHERE a>b
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V723 AS SELECT abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
;

CREATE VIEW V724 AS SELECT d,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
    OR d>e
;

CREATE VIEW V725 AS SELECT e,
       b-c,
       abs(b-c),
       c,
       c-d
  FROM t1
 WHERE a>b
;

CREATE VIEW V726 AS SELECT b,
       a-b,
       d,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       a+b*2+c*3
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V727 AS SELECT d-e,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       abs(b-c),
       c-d
  FROM t1
 WHERE (e>a AND e<b)
    OR a IS NULL
    OR c>d
;

CREATE VIEW V728 AS SELECT a+b*2
  FROM t1
 WHERE c>d
    OR a>b
    OR d>e
;

CREATE VIEW V729 AS SELECT c-d,
       b-c,
       e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d>e
;

CREATE VIEW V730 AS SELECT e
  FROM t1
 WHERE a>b
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V731 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V732 AS SELECT c
  FROM t1
 WHERE c>d
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V733 AS SELECT e,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       b-c
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
;

CREATE VIEW V734 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
;

CREATE VIEW V735 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE a>b
    OR c>d
;

CREATE VIEW V736 AS SELECT c,
       b,
       abs(b-c),
       e,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V737 AS SELECT c-d,
       d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V738 AS SELECT a-b,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>c OR e<d)
    OR d NOT BETWEEN 110 AND 150
    OR (e>a AND e<b)
;

CREATE VIEW V739 AS SELECT (a+b+c+d+e)/5,
       c,
       a+b*2
  FROM t1
;

CREATE VIEW V740 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V741 AS SELECT a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b IS NOT NULL
;

CREATE VIEW V742 AS SELECT a,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V743 AS SELECT d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
    OR b>c
;

CREATE VIEW V744 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       d,
       b-c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
    OR b IS NOT NULL
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V745 AS SELECT a+b*2+c*3+d*4+e*5,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V746 AS SELECT (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       b
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR b IS NOT NULL
;

CREATE VIEW V747 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       b,
       a+b*2
  FROM t1
;

CREATE VIEW V748 AS SELECT b-c,
       b,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIEW V749 AS SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE a IS NULL
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V750 AS SELECT b,
       b-c,
       e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a
  FROM t1
 WHERE a IS NULL
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V751 AS SELECT a-b,
       d-e
  FROM t1
;

CREATE VIEW V752 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIEW V753 AS SELECT d-e,
       a,
       b-c,
       e,
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V754 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2
  FROM t1
 WHERE d>e
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V755 AS SELECT a-b,
       a+b*2+c*3,
       abs(b-c),
       d,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b IS NOT NULL
;

CREATE VIEW V756 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V757 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       abs(b-c),
       a+b*2
  FROM t1
 WHERE a>b
;

CREATE VIEW V758 AS SELECT abs(a)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND coalesce(a,b,c,d,e)<>0
   AND a IS NULL
;

CREATE VIEW V759 AS SELECT a+b*2+c*3+d*4,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       b
  FROM t1
 WHERE c>d
;

CREATE VIEW V760 AS SELECT a+b*2,
       a-b,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V761 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       a+b*2+c*3+d*4,
       d-e,
       a+b*2+c*3
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2 AND d+2
;

CREATE VIEW V762 AS SELECT a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       b
  FROM t1
;

CREATE VIEW V763 AS SELECT c-d,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a>b
;

CREATE VIEW V764 AS SELECT b,
       a
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIEW V765 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       a,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e
  FROM t1
 WHERE b>c
    OR (e>a AND e<b)
;

CREATE VIEW V766 AS SELECT (a+b+c+d+e)/5,
       abs(a),
       d-e,
       e,
       b
  FROM t1
;

CREATE VIEW V767 AS SELECT d,
       abs(a),
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND a>b
   AND (e>c OR e<d)
;

CREATE VIEW V768 AS SELECT d-e,
       a+b*2,
       b-c,
       abs(b-c),
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3
  FROM t1
 WHERE b>c
;

CREATE VIEW V769 AS SELECT a+b*2+c*3
  FROM t1
 WHERE b IS NOT NULL
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V770 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d
  FROM t1
;

CREATE VIEW V771 AS SELECT abs(a),
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       a-b,
       c,
       c-d
  FROM t1
 WHERE a>b
   AND (a>b-2 AND a<b+2)
   AND c>d
;

CREATE VIEW V772 AS SELECT (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
;

CREATE VIEW V773 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e,
       a
  FROM t1
;

CREATE VIEW V774 AS SELECT b-c,
       e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c>d
;

CREATE VIEW V775 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3,
       a+b*2,
       a,
       a-b,
       b,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V776 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4,
       a+b*2,
       d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b IS NOT NULL
;

CREATE VIEW V777 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       a+b*2+c*3,
       b
  FROM t1
 WHERE b>c
    OR c>d
;

CREATE VIEW V778 AS SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND b>c
   AND d>e
;

CREATE VIEW V779 AS SELECT a+b*2
  FROM t1
 WHERE a>b
   AND coalesce(a,b,c,d,e)<>0
   AND a IS NULL
;

CREATE VIEW V780 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       e,
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
;

CREATE VIEW V781 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR coalesce(a,b,c,d,e)<>0
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V782 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V783 AS SELECT c-d,
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
;

CREATE VIEW V784 AS SELECT b,
       a+b*2+c*3,
       (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       a+b*2,
       c
  FROM t1
 WHERE d>e
;

CREATE VIEW V785 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b IS NOT NULL
;

CREATE VIEW V786 AS SELECT b-c,
       abs(b-c),
       d-e,
       a+b*2,
       c-d
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
;

CREATE VIEW V787 AS SELECT c-d,
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR a IS NULL
;

CREATE VIEW V788 AS SELECT b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V789 AS SELECT abs(a)
  FROM t1
 WHERE b IS NOT NULL
    OR a>b
;

CREATE VIEW V790 AS SELECT c,
       b-c,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3,
       a,
       c-d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND b IS NOT NULL
;

CREATE VIEW V791 AS SELECT a+b*2+c*3+d*4,
       abs(b-c),
       b-c,
       d-e,
       a+b*2,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR b>c
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V792 AS SELECT c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       c,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V793 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V794 AS SELECT b,
       a+b*2+c*3+d*4,
       c,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V795 AS SELECT (a+b+c+d+e)/5
  FROM t1
 WHERE b IS NOT NULL
   AND b>c
;

CREATE VIEW V796 AS SELECT d-e
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIEW V797 AS SELECT a+b*2+c*3,
       c,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V798 AS SELECT e,
       c-d,
       (a+b+c+d+e)/5,
       a+b*2,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V799 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR a>b
;

CREATE VIEW V800 AS SELECT a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V801 AS SELECT c-d,
       a,
       b,
       d,
       b-c
  FROM t1
;

CREATE VIEW V802 AS SELECT a,
       c,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V803 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       (a+b+c+d+e)/5,
       abs(a)
  FROM t1
 WHERE b IS NOT NULL
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V804 AS SELECT a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V805 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V806 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       c,
       d,
       b
  FROM t1
 WHERE b IS NOT NULL
   AND c BETWEEN b-2 AND d+2
;

CREATE VIEW V807 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       d,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V808 AS SELECT a+b*2+c*3+d*4,
       a-b,
       (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V809 AS SELECT abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR a IS NULL
;

CREATE VIEW V810 AS SELECT abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c,
       e
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V811 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIEW V812 AS SELECT abs(a),
       (a+b+c+d+e)/5,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
   AND b>c
;

CREATE VIEW V813 AS SELECT b-c,
       a+b*2,
       d,
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V814 AS SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       a+b*2+c*3+d*4+e*5,
       b-c
  FROM t1
 WHERE b>c
;

CREATE VIEW V815 AS SELECT b-c
  FROM t1
 WHERE c>d
    OR d>e
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V816 AS SELECT c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V817 AS SELECT abs(b-c),
       d,
       a+b*2+c*3+d*4+e*5,
       b,
       a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
;

CREATE VIEW V818 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a IS NULL
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V819 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3
  FROM t1
;

CREATE VIEW V820 AS SELECT b,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       d-e
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
;

CREATE VIEW V821 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       e,
       abs(a),
       a+b*2+c*3,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
;

CREATE VIEW V822 AS SELECT d-e,
       a+b*2+c*3+d*4+e*5,
       a
  FROM t1
 WHERE (e>c OR e<d)
   AND a IS NULL
   AND a>b
;

CREATE VIEW V823 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2,
       c-d,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V824 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       d-e,
       abs(b-c)
  FROM t1
 WHERE b IS NOT NULL
;

CREATE VIEW V825 AS SELECT abs(b-c)
  FROM t1
;

CREATE VIEW V826 AS SELECT b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V827 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR c>d
;

CREATE VIEW V828 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       a,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
   AND a IS NULL
;

CREATE VIEW V829 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       b
  FROM t1
 WHERE c>d
;

CREATE VIEW V830 AS SELECT d-e,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
    OR b>c
;

CREATE VIEW V831 AS SELECT abs(b-c),
       a-b,
       d-e,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4,
       a
  FROM t1
 WHERE c>d
    OR b>c
;

CREATE VIEW V832 AS SELECT b,
       a-b,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       c,
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V833 AS SELECT a,
       a+b*2,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR a IS NULL
    OR d>e
;

CREATE VIEW V834 AS SELECT a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2+c*3+d*4,
       b,
       b-c,
       d-e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V835 AS SELECT abs(a),
       (a+b+c+d+e)/5,
       c,
       d-e,
       a+b*2,
       e,
       b
  FROM t1
 WHERE a>b
;

CREATE VIEW V836 AS SELECT a-b,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>a AND e<b)
    OR c>d
;

CREATE VIEW V837 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V838 AS SELECT a+b*2,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       c-d
  FROM t1
;

CREATE VIEW V839 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       b
  FROM t1
;

CREATE VIEW V840 AS SELECT d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V841 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V842 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       b
  FROM t1
;

CREATE VIEW V843 AS SELECT d
  FROM t1
;

CREATE VIEW V844 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       a,
       b-c,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V845 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE a>b
;

CREATE VIEW V846 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
;

CREATE VIEW V847 AS SELECT c,
       b-c,
       a+b*2+c*3
  FROM t1
 WHERE b>c
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V848 AS SELECT a
  FROM t1
 WHERE a IS NULL
    OR b IS NOT NULL
;

CREATE VIEW V849 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       b-c,
       c-d,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
   AND a>b
;

CREATE VIEW V850 AS SELECT b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE a>b
;

CREATE VIEW V851 AS SELECT (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V852 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       c
  FROM t1
;

CREATE VIEW V853 AS SELECT a-b
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
;

CREATE VIEW V854 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c-d,
       b,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b
  FROM t1
 WHERE d>e
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V855 AS SELECT a+b*2+c*3+d*4,
       e,
       a+b*2+c*3
  FROM t1
 WHERE a>b
;

CREATE VIEW V856 AS SELECT b,
       d,
       b-c
  FROM t1
 WHERE a IS NULL
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V857 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V858 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
;

CREATE VIEW V859 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       c,
       a,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>a AND e<b)
    OR b>c
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V860 AS SELECT d-e
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND e+d BETWEEN a+b-10 AND c+130
   AND a IS NULL
;

CREATE VIEW V861 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       a,
       (a+b+c+d+e)/5,
       e,
       d
  FROM t1
;

CREATE VIEW V862 AS SELECT a
  FROM t1
;

CREATE VIEW V863 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c>d
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V864 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR b IS NOT NULL
;

CREATE VIEW V865 AS SELECT d,
       c-d,
       a+b*2
  FROM t1
 WHERE (e>c OR e<d)
    OR d>e
    OR a>b
;

CREATE VIEW V866 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       abs(a),
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b
  FROM t1
;

CREATE VIEW V867 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       a-b,
       b-c,
       d
  FROM t1
 WHERE b>c
;

CREATE VIEW V868 AS SELECT a+b*2,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIEW V869 AS SELECT a,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V870 AS SELECT e,
       b-c,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE a>b
   AND e+d BETWEEN a+b-10 AND c+130
   AND d>e
;

CREATE VIEW V871 AS SELECT d,
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
;

CREATE VIEW V872 AS SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       a+b*2,
       d-e,
       a+b*2+c*3+d*4,
       c-d
  FROM t1
 WHERE a IS NULL
   AND c>d
;

CREATE VIEW V873 AS SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2
  FROM t1
;

CREATE VIEW V874 AS SELECT e,
       b-c,
       abs(b-c),
       abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>a AND e<b)
;

CREATE VIEW V875 AS SELECT d,
       c-d,
       abs(b-c),
       b-c,
       a+b*2+c*3
  FROM t1
 WHERE b>c
;

CREATE VIEW V876 AS SELECT a-b,
       a,
       a+b*2+c*3,
       abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c
  FROM t1
 WHERE b IS NOT NULL
   AND (e>c OR e<d)
   AND c>d
;

CREATE VIEW V877 AS SELECT abs(b-c),
       e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V878 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       e,
       c-d,
       a,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V879 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c),
       (a+b+c+d+e)/5
  FROM t1
;

CREATE VIEW V880 AS SELECT b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V881 AS SELECT abs(a),
       c,
       (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a IS NULL
;

CREATE VIEW V882 AS SELECT abs(b-c),
       d,
       a+b*2+c*3+d*4+e*5,
       a-b,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
;

CREATE VIEW V883 AS SELECT c,
       a-b,
       a+b*2+c*3+d*4+e*5,
       e,
       abs(a)
  FROM t1
;

CREATE VIEW V884 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       c,
       a+b*2
  FROM t1
;

CREATE VIEW V885 AS SELECT a-b,
       b-c,
       a+b*2,
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V886 AS SELECT a+b*2+c*3,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V887 AS SELECT (a+b+c+d+e)/5,
       c-d
  FROM t1
 WHERE d>e
   AND c>d
   AND a IS NULL
;

CREATE VIEW V888 AS SELECT b,
       a-b,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V889 AS SELECT a+b*2+c*3+d*4,
       b,
       a,
       e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR b>c
;

CREATE VIEW V890 AS SELECT b-c,
       a,
       (a+b+c+d+e)/5,
       c-d,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
;

CREATE VIEW V891 AS SELECT a-b,
       c-d,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d
  FROM t1
;

CREATE VIEW V892 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4
  FROM t1
;

CREATE VIEW V893 AS SELECT c
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
    OR a>b
;

CREATE VIEW V894 AS SELECT a+b*2+c*3+d*4,
       b,
       abs(a)
  FROM t1
;

CREATE VIEW V895 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE b>c
   AND c>d
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V896 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
;

CREATE VIEW V897 AS SELECT (a+b+c+d+e)/5,
       d-e,
       a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d>e
    OR b>c
;

CREATE VIEW V898 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       a+b*2
  FROM t1
 WHERE b>c
;

CREATE VIEW V899 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V900 AS SELECT d-e,
       a,
       d
  FROM t1
 WHERE (e>c OR e<d)
   AND a IS NULL
;

CREATE VIEW V901 AS SELECT a,
       (a+b+c+d+e)/5,
       b-c,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V902 AS SELECT abs(a),
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       e
  FROM t1
 WHERE b IS NOT NULL
;

CREATE VIEW V903 AS SELECT d-e,
       a-b,
       c,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIEW V904 AS SELECT abs(b-c),
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       abs(a),
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V905 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
;

CREATE VIEW V906 AS SELECT a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V907 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
;

CREATE VIEW V908 AS SELECT d-e,
       a,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND d NOT BETWEEN 110 AND 150
;

CREATE VIEW V909 AS SELECT CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c>d
;

CREATE VIEW V910 AS SELECT c-d,
       e
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V911 AS SELECT a+b*2+c*3+d*4,
       d-e,
       abs(a),
       a+b*2,
       c
  FROM t1
;

CREATE VIEW V912 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V913 AS SELECT a-b,
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       b-c
  FROM t1
;

CREATE VIEW V914 AS SELECT abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
   AND a IS NULL
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V915 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
;

CREATE VIEW V916 AS SELECT a+b*2+c*3,
       c-d,
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e
  FROM t1
;

CREATE VIEW V917 AS SELECT abs(a),
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>c OR e<d)
    OR c>d
;

CREATE VIEW V918 AS SELECT d,
       b-c,
       c-d,
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V919 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       abs(a),
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND b IS NOT NULL
;

CREATE VIEW V920 AS SELECT a+b*2,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a IS NULL
;

CREATE VIEW V921 AS SELECT c-d,
       abs(b-c),
       a-b,
       a
  FROM t1
;

CREATE VIEW V922 AS SELECT a,
       a+b*2+c*3+d*4+e*5,
       e,
       a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c)
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V923 AS SELECT abs(b-c),
       d,
       abs(a),
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE b>c
    OR c>d
;

CREATE VIEW V924 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
;

CREATE VIEW V925 AS SELECT a,
       a+b*2+c*3+d*4,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
   AND c>d
   AND b IS NOT NULL
;

CREATE VIEW V926 AS SELECT c
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIEW V927 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
   AND c>d
;

CREATE VIEW V928 AS SELECT b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND d NOT BETWEEN 110 AND 150
   AND a>b
;

CREATE VIEW V929 AS SELECT e,
       a-b,
       b-c,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a IS NULL
    OR (e>a AND e<b)
;

CREATE VIEW V930 AS SELECT a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
;

CREATE VIEW V931 AS SELECT d-e,
       a-b,
       b-c
  FROM t1
;

CREATE VIEW V932 AS SELECT c
  FROM t1
 WHERE b>c
    OR b IS NOT NULL
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V933 AS SELECT a+b*2+c*3+d*4+e*5,
       e,
       d-e,
       a-b,
       a+b*2+c*3,
       a
  FROM t1
 WHERE c>d
    OR d>e
;

CREATE VIEW V934 AS SELECT a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c>d
;

CREATE VIEW V935 AS SELECT c,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V936 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       abs(b-c),
       e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V937 AS SELECT (a+b+c+d+e)/5,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
    OR a>b
;

CREATE VIEW V938 AS SELECT a+b*2+c*3+d*4,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
;

CREATE VIEW V939 AS SELECT a+b*2+c*3,
       a+b*2,
       e,
       c,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
   AND c>d
;

CREATE VIEW V940 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V941 AS SELECT a+b*2+c*3+d*4,
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
    OR c>d
;

CREATE VIEW V942 AS SELECT (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
;

CREATE VIEW V943 AS SELECT a+b*2,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
;

CREATE VIEW V944 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       c,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE c>d
;

CREATE VIEW V945 AS SELECT a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       a+b*2+c*3+d*4+e*5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V946 AS SELECT a+b*2+c*3,
       b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5,
       a,
       d
  FROM t1
;

CREATE VIEW V947 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2 AND d+2
    OR e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V948 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
;

CREATE VIEW V949 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       d
  FROM t1
 WHERE b>c
   AND (c<=d-2 OR c>=d+2)
;

CREATE VIEW V950 AS SELECT a-b
  FROM t1
;

CREATE VIEW V951 AS SELECT c-d,
       abs(a),
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
    OR c>d
;

CREATE VIEW V952 AS SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2+c*3+d*4+e*5,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
;

CREATE VIEW V953 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       abs(b-c),
       e,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR a IS NULL
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V954 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>a AND e<b)
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V955 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a),
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
    OR b>c
;

CREATE VIEW V956 AS SELECT a-b,
       d-e,
       abs(b-c),
       e,
       a+b*2,
       b-c
  FROM t1
 WHERE a IS NULL
   AND b>c
   AND (a>b-2 AND a<b+2)
;

CREATE VIEW V957 AS SELECT b-c,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE b>c
    OR e+d BETWEEN a+b-10 AND c+130
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V958 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
;

CREATE VIEW V959 AS SELECT d,
       a,
       b
  FROM t1
;

CREATE VIEW V960 AS SELECT b,
       a,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
   AND (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
;

CREATE VIEW V961 AS SELECT a,
       a+b*2,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>a AND e<b)
;

CREATE VIEW V962 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       c-d,
       a+b*2+c*3,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE d>e
    OR a IS NULL
    OR d NOT BETWEEN 110 AND 150
;

CREATE VIEW V963 AS SELECT abs(a),
       d,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE a IS NULL
   AND c>d
   AND a>b
;

CREATE VIEW V964 AS SELECT abs(b-c),
       (a+b+c+d+e)/5,
       a-b,
       c,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a IS NULL
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V965 AS SELECT b-c,
       abs(a)
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR (e>a AND e<b)
;

CREATE VIEW V966 AS SELECT b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>a AND e<b)
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V967 AS SELECT a+b*2+c*3+d*4+e*5,
       a,
       a+b*2+c*3+d*4,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V968 AS SELECT a+b*2+c*3
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
   AND a IS NULL
   AND coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V969 AS SELECT e,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
;

CREATE VIEW V970 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       a+b*2,
       a-b,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       d-e
  FROM t1
;

CREATE VIEW V971 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c>d
;

CREATE VIEW V972 AS SELECT abs(a)
  FROM t1
 WHERE c>d
;

CREATE VIEW V973 AS SELECT e,
       a+b*2,
       c,
       d-e
  FROM t1
;

CREATE VIEW V974 AS SELECT d-e,
       d,
       a,
       a+b*2
  FROM t1
;

CREATE VIEW V975 AS SELECT a
  FROM t1
 WHERE c>d
;

CREATE VIEW V976 AS SELECT c-d,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       a,
       b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
;

CREATE VIEW V977 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       a+b*2+c*3
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V978 AS SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       b,
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
   AND a>b
;

CREATE VIEW V979 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
;

CREATE VIEW V980 AS SELECT d,
       abs(b-c),
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND a IS NULL
   AND c>d
;

CREATE VIEW V981 AS SELECT b,
       d-e,
       a+b*2,
       b-c
  FROM t1
;

CREATE VIEW V982 AS SELECT c,
       e,
       a+b*2,
       abs(b-c),
       b-c,
       a
  FROM t1
 WHERE a IS NULL
   AND (e>a AND e<b)
   AND b IS NOT NULL
;

CREATE VIEW V983 AS SELECT (a+b+c+d+e)/5,
       a+b*2,
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a-b,
       a
  FROM t1
 WHERE b>c
;

CREATE VIEW V984 AS SELECT e,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN c>(SELECT CAST(avg(c) AS INTEGER) FROM t1) THEN a*2 ELSE b*10 END,
       a-b,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR b>c
;

CREATE VIEW V985 AS SELECT a-b,
       c,
       b,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR (c<=d-2 OR c>=d+2)
;

CREATE VIEW V986 AS SELECT abs(b-c),
       d-e,
       c-d,
       a+b*2+c*3+d*4+e*5,
       d
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
    OR c>d
    OR d>e
;

CREATE VIEW V987 AS SELECT a-b,
       (a+b+c+d+e)/5,
       abs(b-c),
       c,
       abs(a),
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
    OR a IS NULL
;

CREATE VIEW V988 AS SELECT a+b*2,
       c,
       e,
       b
  FROM t1
 WHERE (e>a AND e<b)
    OR coalesce(a,b,c,d,e)<>0
;

CREATE VIEW V989 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       (a+b+c+d+e)/5,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
;

CREATE VIEW V990 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V991 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
;

CREATE VIEW V992 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
;

CREATE VIEW V993 AS SELECT a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a
  FROM t1
;

CREATE VIEW V994 AS SELECT abs(b-c)
  FROM t1
 WHERE coalesce(a,b,c,d,e)<>0
   AND b IS NOT NULL
;

CREATE VIEW V995 AS SELECT c-d,
       abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND e+d BETWEEN a+b-10 AND c+130
   AND b IS NOT NULL
;

CREATE VIEW V996 AS SELECT (a+b+c+d+e)/5,
       e,
       c-d,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR coalesce(a,b,c,d,e)<>0
    OR a IS NULL
;

CREATE VIEW V997 AS SELECT a-b,
       a
  FROM t1
 WHERE c>d
;

CREATE VIEW V998 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       d-e,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
   AND a>b
;

CREATE VIEW V999 AS SELECT a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR c>d
    OR a IS NULL
;
