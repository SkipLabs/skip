CREATE VIRTUAL VIEW V0 AS SELECT a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V1 AS SELECT c,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
 ORDER BY 1,5,3,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V2 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       abs(a),
       e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d
  FROM t1
 WHERE b>c
   AND c>d
 ORDER BY 3,4,5,1,2,6
 LIMIT 5;

CREATE VIRTUAL VIEW V3 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V4 AS SELECT a+b*2,
       a,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       e,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE a>b
 ORDER BY 5,4,6,2,1,7,3
 LIMIT 5;

CREATE VIRTUAL VIEW V5 AS SELECT a,
       b
  FROM t1
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V6 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       b-c,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,5,4,2,6,3
 LIMIT 5;

CREATE VIRTUAL VIEW V7 AS SELECT d-e,
       abs(a),
       b,
       c-d,
       a+b*2+c*3,
       abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND c>d
 ORDER BY 1,3,7,5,2,6,4
 LIMIT 5;

CREATE VIRTUAL VIEW V8 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       b-c,
       c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 2,5,1,7,3,6,4
 LIMIT 5;

CREATE VIRTUAL VIEW V9 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       c-d,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 ORDER BY 3,4,2,6,5,1
 LIMIT 5;

CREATE VIRTUAL VIEW V10 AS SELECT a-b,
       a,
       a+b*2+c*3,
       b,
       d,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,6,4,1,5,3
 LIMIT 5;

CREATE VIRTUAL VIEW V11 AS SELECT b,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       b-c
  FROM t1
 WHERE a>b
 ORDER BY 2,5,3,4,1
 LIMIT 5;

CREATE VIRTUAL VIEW V12 AS SELECT abs(b-c),
       a,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 1,4,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V13 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c>d
 ORDER BY 2,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V14 AS SELECT a+b*2
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR a>b
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V15 AS SELECT a,
       c-d,
       d
  FROM t1
 WHERE c>d
   AND a>b
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V16 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       c,
       (a+b+c+d+e)/5,
       b
  FROM t1
 ORDER BY 5,4,1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V17 AS SELECT c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       (a+b+c+d+e)/5,
       a+b*2,
       d-e
  FROM t1
 WHERE b>c
   AND (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 4,5,3,1,2,6
 LIMIT 5;

CREATE VIRTUAL VIEW V18 AS SELECT a+b*2+c*3
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V19 AS SELECT a+b*2+c*3+d*4+e*5,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       b-c
  FROM t1
 WHERE d>e
 ORDER BY 4,1,5,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V20 AS SELECT d,
       a+b*2,
       a,
       b,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 5,2,7,1,4,6,3
 LIMIT 5;

CREATE VIRTUAL VIEW V21 AS SELECT e
  FROM t1
 WHERE b>c
   AND d>e
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V22 AS SELECT b,
       e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V23 AS SELECT b-c,
       d-e,
       c-d,
       a+b*2+c*3
  FROM t1
 ORDER BY 1,2,4,3
 LIMIT 5;

CREATE VIRTUAL VIEW V24 AS SELECT abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V25 AS SELECT abs(a),
       a+b*2+c*3+d*4+e*5,
       c-d
  FROM t1
 ORDER BY 3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V26 AS SELECT abs(a),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       d-e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 5,3,1,4,2
 LIMIT 5;

CREATE VIRTUAL VIEW V27 AS SELECT e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V28 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V29 AS SELECT b-c
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V30 AS SELECT b-c,
       (a+b+c+d+e)/5,
       c-d,
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d>e
   AND d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
 ORDER BY 1,3,2,5,4,6
 LIMIT 5;

CREATE VIRTUAL VIEW V31 AS SELECT abs(a),
       a+b*2+c*3+d*4+e*5,
       a,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 4,3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V32 AS SELECT b,
       c,
       a-b,
       d-e,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
    OR c BETWEEN b-2 AND d+2
 ORDER BY 2,1,4,3,5
 LIMIT 5;

CREATE VIRTUAL VIEW V33 AS SELECT a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V34 AS SELECT b,
       abs(a),
       a,
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
    OR b>c
 ORDER BY 4,3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V35 AS SELECT a+b*2+c*3+d*4,
       abs(b-c),
       c-d
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V36 AS SELECT a+b*2,
       a+b*2+c*3+d*4+e*5,
       a-b,
       abs(b-c),
       c,
       b,
       e
  FROM t1
 WHERE d>e
 ORDER BY 4,5,3,6,2,1,7
 LIMIT 5;

CREATE VIRTUAL VIEW V37 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3
  FROM t1
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V38 AS SELECT (a+b+c+d+e)/5,
       a-b,
       b,
       a+b*2,
       a
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
   AND d>e
 ORDER BY 4,2,5,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V39 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       abs(a),
       abs(b-c),
       a+b*2+c*3,
       e
  FROM t1
 WHERE d>e
   AND (e>a AND e<b)
 ORDER BY 7,2,6,1,3,4,5
 LIMIT 5;

CREATE VIRTUAL VIEW V40 AS SELECT c-d,
       d-e,
       abs(a),
       a,
       (a+b+c+d+e)/5
  FROM t1
 WHERE a>b
    OR c>d
 ORDER BY 1,5,3,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V41 AS SELECT a+b*2+c*3,
       a
  FROM t1
 WHERE (e>c OR e<d)
    OR a>b
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V42 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V43 AS SELECT e
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V44 AS SELECT (a+b+c+d+e)/5
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V45 AS SELECT a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       e
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,1,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V46 AS SELECT abs(a),
       d,
       e,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       a
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 3,2,7,6,4,1,5
 LIMIT 5;

CREATE VIRTUAL VIEW V47 AS SELECT c,
       d,
       a+b*2+c*3,
       a-b,
       e
  FROM t1
 ORDER BY 3,2,1,5,4
 LIMIT 5;

CREATE VIRTUAL VIEW V48 AS SELECT (a+b+c+d+e)/5,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       d-e
  FROM t1
 WHERE a>b
   AND c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,3,4,1,5
 LIMIT 5;

CREATE VIRTUAL VIEW V49 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>a AND e<b)
   AND (e>c OR e<d)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V50 AS SELECT a+b*2+c*3+d*4,
       b,
       a-b
  FROM t1
 WHERE c>d
    OR d>e
    OR b>c
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V51 AS SELECT a-b
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V52 AS SELECT e,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2 AND d+2
 ORDER BY 3,2,4,1
 LIMIT 5;

CREATE VIRTUAL VIEW V53 AS SELECT b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE b>c
   AND a>b
   AND (e>a AND e<b)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V54 AS SELECT a+b*2,
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE b>c
   AND a>b
 ORDER BY 3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V55 AS SELECT d-e,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 2,1,3,4
 LIMIT 5;

CREATE VIRTUAL VIEW V56 AS SELECT c-d,
       e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V57 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V58 AS SELECT a-b,
       b-c
  FROM t1
 WHERE b>c
   AND d>e
   AND c BETWEEN b-2 AND d+2
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V59 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
 WHERE b>c
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V60 AS SELECT abs(a),
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       d-e
  FROM t1
 ORDER BY 3,1,2,5,4
 LIMIT 5;

CREATE VIRTUAL VIEW V61 AS SELECT c,
       a+b*2,
       abs(b-c)
  FROM t1
 WHERE b>c
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V62 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V63 AS SELECT (a+b+c+d+e)/5,
       abs(b-c),
       c,
       a+b*2+c*3+d*4+e*5,
       abs(a),
       e
  FROM t1
 WHERE b>c
   AND d>e
 ORDER BY 4,5,6,3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V64 AS SELECT a+b*2+c*3
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V65 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       a,
       abs(a),
       c-d,
       c
  FROM t1
 ORDER BY 2,5,4,6,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V66 AS SELECT abs(b-c),
       b,
       e
  FROM t1
 WHERE a>b
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V67 AS SELECT abs(b-c),
       e
  FROM t1
 WHERE c>d
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V68 AS SELECT b,
       e
  FROM t1
 WHERE d>e
    OR (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V69 AS SELECT a+b*2+c*3,
       a+b*2
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V70 AS SELECT abs(b-c),
       c-d
  FROM t1
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V71 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       a,
       a+b*2
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR a>b
    OR b>c
 ORDER BY 3,1,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V72 AS SELECT c,
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V73 AS SELECT b
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V74 AS SELECT a+b*2+c*3
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V75 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V76 AS SELECT (a+b+c+d+e)/5,
       a+b*2,
       a+b*2+c*3+d*4+e*5,
       a,
       d-e
  FROM t1
 WHERE d>e
   AND (e>a AND e<b)
   AND b>c
 ORDER BY 1,5,3,4,2
 LIMIT 5;

CREATE VIRTUAL VIEW V77 AS SELECT a+b*2+c*3
  FROM t1
 WHERE b>c
    OR a>b
    OR (e>a AND e<b)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V78 AS SELECT a+b*2+c*3,
       e,
       a-b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V79 AS SELECT d-e,
       a,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 ORDER BY 3,1,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V80 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V81 AS SELECT a,
       abs(a),
       d,
       (a+b+c+d+e)/5,
       c-d
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
 ORDER BY 2,1,3,5,4
 LIMIT 5;

CREATE VIRTUAL VIEW V82 AS SELECT c,
       a+b*2,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V83 AS SELECT d-e,
       abs(b-c),
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
   AND a>b
 ORDER BY 3,4,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V84 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       b-c,
       d-e
  FROM t1
 ORDER BY 1,2,3,4
 LIMIT 5;

CREATE VIRTUAL VIEW V85 AS SELECT d,
       a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V86 AS SELECT a+b*2+c*3+d*4+e*5,
       d,
       a+b*2+c*3+d*4,
       c,
       d-e,
       a+b*2
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 4,6,2,5,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V87 AS SELECT abs(a),
       abs(b-c),
       c,
       a-b,
       c-d,
       a+b*2+c*3+d*4,
       b
  FROM t1
 ORDER BY 2,6,7,4,1,5,3
 LIMIT 5;

CREATE VIRTUAL VIEW V88 AS SELECT b,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10 AND c+130
    OR a>b
 ORDER BY 3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V89 AS SELECT a-b,
       a+b*2+c*3+d*4,
       d,
       e
  FROM t1
 ORDER BY 2,4,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V90 AS SELECT a+b*2,
       c-d,
       d-e,
       abs(a),
       a-b,
       c,
       b
  FROM t1
 WHERE a>b
 ORDER BY 3,2,1,4,7,5,6
 LIMIT 5;

CREATE VIRTUAL VIEW V91 AS SELECT d,
       (a+b+c+d+e)/5,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       d-e,
       c
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
    OR (e>c OR e<d)
 ORDER BY 2,3,1,4,5,6
 LIMIT 5;

CREATE VIRTUAL VIEW V92 AS SELECT d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V93 AS SELECT abs(a)
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V94 AS SELECT a+b*2+c*3+d*4,
       d,
       a-b,
       abs(a),
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 5,2,1,4,6,3
 LIMIT 5;

CREATE VIRTUAL VIEW V95 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V96 AS SELECT b,
       a+b*2+c*3+d*4,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 5,4,2,1,3,6
 LIMIT 5;

CREATE VIRTUAL VIEW V97 AS SELECT d,
       a,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       (a+b+c+d+e)/5,
       e
  FROM t1
 WHERE (e>c OR e<d)
    OR (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 3,5,1,4,7,6,2
 LIMIT 5;

CREATE VIRTUAL VIEW V98 AS SELECT c-d,
       a+b*2+c*3+d*4,
       a,
       abs(b-c),
       abs(a),
       (a+b+c+d+e)/5,
       c
  FROM t1
 ORDER BY 2,4,5,6,3,7,1
 LIMIT 5;

CREATE VIRTUAL VIEW V99 AS SELECT a+b*2,
       b,
       d-e,
       a,
       abs(b-c),
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 1,2,5,4,3,6
 LIMIT 5;

CREATE VIRTUAL VIEW V100 AS SELECT d
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V101 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e
  FROM t1
 WHERE b>c
   AND d>e
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V102 AS SELECT a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c BETWEEN b-2 AND d+2
   AND b>c
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V103 AS SELECT d,
       abs(b-c),
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       e,
       b
  FROM t1
 ORDER BY 2,6,3,5,7,4,1
 LIMIT 5;

CREATE VIRTUAL VIEW V104 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V105 AS SELECT abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND c>d
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V106 AS SELECT a-b,
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
    OR d>e
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V107 AS SELECT d-e
  FROM t1
 WHERE a>b
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V108 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
    OR b>c
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V109 AS SELECT (a+b+c+d+e)/5,
       a,
       b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V110 AS SELECT c,
       a-b,
       a+b*2+c*3,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR d>e
    OR a>b
 ORDER BY 5,3,2,4,1
 LIMIT 5;

CREATE VIRTUAL VIEW V111 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(b-c),
       a,
       abs(a),
       b,
       a+b*2
  FROM t1
 WHERE a>b
    OR (a>b-2 AND a<b+2)
 ORDER BY 1,6,3,5,4,2
 LIMIT 5;

CREATE VIRTUAL VIEW V112 AS SELECT abs(b-c)
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V113 AS SELECT e
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V114 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V115 AS SELECT c
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V116 AS SELECT a+b*2,
       a,
       d,
       c,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 4,2,3,1,5
 LIMIT 5;

CREATE VIRTUAL VIEW V117 AS SELECT d-e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V118 AS SELECT abs(b-c),
       a+b*2+c*3,
       a+b*2
  FROM t1
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V119 AS SELECT a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b-c,
       a+b*2+c*3+d*4,
       b,
       abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
 ORDER BY 4,1,5,6,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V120 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       b-c,
       c,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND b>c
   AND (a>b-2 AND a<b+2)
 ORDER BY 3,5,2,1,6,4
 LIMIT 5;

CREATE VIRTUAL VIEW V121 AS SELECT b,
       a-b,
       a,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 1,2,3,4
 LIMIT 5;

CREATE VIRTUAL VIEW V122 AS SELECT a+b*2+c*3+d*4+e*5,
       b-c,
       d-e
  FROM t1
 ORDER BY 2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V123 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3,
       a-b,
       abs(b-c),
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 2,1,5,4,3
 LIMIT 5;

CREATE VIRTUAL VIEW V124 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V125 AS SELECT (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V126 AS SELECT a-b,
       b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 2,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V127 AS SELECT e,
       a+b*2,
       abs(a),
       b
  FROM t1
 ORDER BY 4,2,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V128 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5,
       b-c,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 5,3,2,1,4
 LIMIT 5;

CREATE VIRTUAL VIEW V129 AS SELECT d
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V130 AS SELECT abs(b-c),
       a-b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
 ORDER BY 2,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V131 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       b-c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND b>c
   AND c>d
 ORDER BY 2,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V132 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V133 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b
  FROM t1
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V134 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       b-c,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4,
       a-b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND b>c
 ORDER BY 6,5,7,4,3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V135 AS SELECT b,
       c,
       abs(a),
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
 ORDER BY 2,4,5,6,3,7,1
 LIMIT 5;

CREATE VIRTUAL VIEW V136 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2 AND d+2
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V137 AS SELECT d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d>e
    OR a>b
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V138 AS SELECT a+b*2+c*3+d*4+e*5,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V139 AS SELECT abs(a),
       a-b
  FROM t1
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V140 AS SELECT b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       b,
       c-d,
       a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
   AND d>e
 ORDER BY 4,7,5,2,1,6,3
 LIMIT 5;

CREATE VIRTUAL VIEW V141 AS SELECT a+b*2+c*3,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR b>c
 ORDER BY 2,4,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V142 AS SELECT b,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
 ORDER BY 2,1,4,3
 LIMIT 5;

CREATE VIRTUAL VIEW V143 AS SELECT b-c,
       e,
       c-d,
       a-b
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 4,1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V144 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       b
  FROM t1
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V145 AS SELECT c-d,
       (a+b+c+d+e)/5,
       abs(b-c),
       c,
       d
  FROM t1
 WHERE c>d
    OR a>b
 ORDER BY 4,2,3,1,5
 LIMIT 5;

CREATE VIRTUAL VIEW V146 AS SELECT a+b*2+c*3,
       d,
       abs(b-c)
  FROM t1
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V147 AS SELECT e,
       a+b*2+c*3,
       abs(b-c),
       d-e
  FROM t1
 ORDER BY 1,3,4,2
 LIMIT 5;

CREATE VIRTUAL VIEW V148 AS SELECT a,
       abs(a),
       d-e,
       e
  FROM t1
 ORDER BY 2,4,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V149 AS SELECT b-c,
       a-b,
       a+b*2
  FROM t1
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V150 AS SELECT c-d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR d>e
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V151 AS SELECT abs(a)
  FROM t1
 WHERE a>b
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V152 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V153 AS SELECT abs(a)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
   AND (e>a AND e<b)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V154 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       c-d
  FROM t1
 ORDER BY 2,4,5,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V155 AS SELECT b,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       a-b
  FROM t1
 ORDER BY 4,5,3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V156 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       d,
       e,
       a+b*2
  FROM t1
 ORDER BY 2,3,4,1,5
 LIMIT 5;

CREATE VIRTUAL VIEW V157 AS SELECT b,
       e,
       b-c
  FROM t1
 ORDER BY 2,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V158 AS SELECT abs(b-c),
       a+b*2,
       d,
       b-c,
       a-b,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c>d
 ORDER BY 3,1,2,5,6,4
 LIMIT 5;

CREATE VIRTUAL VIEW V159 AS SELECT abs(b-c),
       e
  FROM t1
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V160 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4,
       a-b,
       a+b*2
  FROM t1
 WHERE d>e
   AND c>d
   AND a>b
 ORDER BY 3,1,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V161 AS SELECT b,
       a+b*2+c*3,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V162 AS SELECT a-b,
       a,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,5,1,6,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V163 AS SELECT a+b*2
  FROM t1
 WHERE a>b
    OR (e>c OR e<d)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V164 AS SELECT b,
       a+b*2
  FROM t1
 WHERE (e>a AND e<b)
    OR (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V165 AS SELECT a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       d-e,
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND e+d BETWEEN a+b-10 AND c+130
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 3,2,5,4,1
 LIMIT 5;

CREATE VIRTUAL VIEW V166 AS SELECT b-c,
       a,
       d-e
  FROM t1
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V167 AS SELECT a,
       a+b*2+c*3+d*4+e*5,
       c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V168 AS SELECT a-b,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5,
       b,
       abs(b-c)
  FROM t1
 WHERE b>c
 ORDER BY 5,2,1,7,3,4,6
 LIMIT 5;

CREATE VIRTUAL VIEW V169 AS SELECT d,
       (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V170 AS SELECT a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       a-b,
       b-c,
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (c<=d-2 OR c>=d+2)
    OR (e>a AND e<b)
 ORDER BY 2,6,1,4,3,5
 LIMIT 5;

CREATE VIRTUAL VIEW V171 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5,
       abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V172 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V173 AS SELECT a-b
  FROM t1
 WHERE c>d
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V174 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       abs(a),
       c,
       d-e
  FROM t1
 ORDER BY 5,4,1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V175 AS SELECT d,
       c
  FROM t1
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V176 AS SELECT d-e,
       b-c,
       a-b,
       a+b*2+c*3+d*4,
       abs(a)
  FROM t1
 ORDER BY 1,5,3,4,2
 LIMIT 5;

CREATE VIRTUAL VIEW V177 AS SELECT b-c,
       a+b*2+c*3+d*4,
       c-d,
       a-b
  FROM t1
 ORDER BY 2,4,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V178 AS SELECT b,
       b-c,
       a+b*2+c*3,
       abs(a),
       c-d,
       a,
       d-e
  FROM t1
 WHERE b>c
 ORDER BY 4,6,1,3,7,2,5
 LIMIT 5;

CREATE VIRTUAL VIEW V179 AS SELECT c
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V180 AS SELECT a+b*2+c*3,
       d-e,
       a+b*2+c*3+d*4,
       d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a)
  FROM t1
 WHERE b>c
   AND (e>c OR e<d)
 ORDER BY 2,3,4,5,6,1
 LIMIT 5;

CREATE VIRTUAL VIEW V181 AS SELECT b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V182 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
 WHERE (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 5,3,2,1,4
 LIMIT 5;

CREATE VIRTUAL VIEW V183 AS SELECT a+b*2+c*3+d*4+e*5,
       a-b,
       a+b*2+c*3
  FROM t1
 ORDER BY 2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V184 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 3,4,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V185 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V186 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
   AND e+d BETWEEN a+b-10 AND c+130
   AND c>d
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V187 AS SELECT c-d,
       abs(b-c),
       a+b*2
  FROM t1
 WHERE d>e
   AND a>b
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V188 AS SELECT e,
       a+b*2+c*3
  FROM t1
 WHERE (e>a AND e<b)
    OR b>c
    OR (e>c OR e<d)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V189 AS SELECT (a+b+c+d+e)/5
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V190 AS SELECT a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       a,
       b,
       a+b*2
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 5,1,2,3,4
 LIMIT 5;

CREATE VIRTUAL VIEW V191 AS SELECT e,
       a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V192 AS SELECT c-d,
       d-e,
       d,
       a+b*2+c*3
  FROM t1
 ORDER BY 3,2,4,1
 LIMIT 5;

CREATE VIRTUAL VIEW V193 AS SELECT abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V194 AS SELECT abs(a),
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,3,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V195 AS SELECT b,
       a,
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V196 AS SELECT (a+b+c+d+e)/5,
       e,
       b
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V197 AS SELECT abs(a),
       a+b*2+c*3,
       (a+b+c+d+e)/5,
       b-c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,3,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V198 AS SELECT a-b
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V199 AS SELECT a-b,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V200 AS SELECT c
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V201 AS SELECT abs(a)
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V202 AS SELECT b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d
  FROM t1
 ORDER BY 3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V203 AS SELECT c-d,
       a-b,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 3,2,4,5,1
 LIMIT 5;

CREATE VIRTUAL VIEW V204 AS SELECT c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       a+b*2+c*3,
       d-e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 3,4,6,5,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V205 AS SELECT abs(b-c)
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V206 AS SELECT a,
       c
  FROM t1
 WHERE d>e
    OR b>c
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V207 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       b,
       abs(a),
       a+b*2,
       c-d
  FROM t1
 WHERE b>c
 ORDER BY 1,6,5,3,4,2
 LIMIT 5;

CREATE VIRTUAL VIEW V208 AS SELECT a+b*2+c*3+d*4
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V209 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       e,
       a+b*2,
       a+b*2+c*3,
       d,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 2,1,5,3,6,4,7
 LIMIT 5;

CREATE VIRTUAL VIEW V210 AS SELECT d-e,
       c-d,
       a
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND c>d
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V211 AS SELECT b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       a+b*2+c*3+d*4+e*5,
       b-c,
       a+b*2,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
 ORDER BY 3,4,1,5,6,2,7
 LIMIT 5;

CREATE VIRTUAL VIEW V212 AS SELECT c-d
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V213 AS SELECT a+b*2+c*3+d*4+e*5,
       d-e,
       abs(a),
       c-d
  FROM t1
 ORDER BY 2,3,4,1
 LIMIT 5;

CREATE VIRTUAL VIEW V214 AS SELECT a+b*2+c*3+d*4+e*5,
       c
  FROM t1
 WHERE d>e
    OR (e>c OR e<d)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V215 AS SELECT a,
       a+b*2+c*3+d*4,
       d
  FROM t1
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V216 AS SELECT a-b,
       (a+b+c+d+e)/5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a),
       d-e,
       abs(b-c),
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 6,4,5,3,1,2,7
 LIMIT 5;

CREATE VIRTUAL VIEW V217 AS SELECT d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V218 AS SELECT a+b*2+c*3+d*4+e*5,
       d-e,
       abs(a),
       a-b,
       b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c>d
 ORDER BY 5,4,3,2,1,6
 LIMIT 5;

CREATE VIRTUAL VIEW V219 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c>d
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V220 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V221 AS SELECT c-d,
       a+b*2+c*3,
       a
  FROM t1
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V222 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
   AND b>c
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V223 AS SELECT a,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
 ORDER BY 2,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V224 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V225 AS SELECT abs(b-c)
  FROM t1
 WHERE c>d
   AND d NOT BETWEEN 110 AND 150
   AND a>b
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V226 AS SELECT abs(a),
       a-b,
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V227 AS SELECT b-c,
       c-d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE a>b
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V228 AS SELECT a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE c>d
   AND b>c
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V229 AS SELECT a+b*2+c*3+d*4+e*5,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       e
  FROM t1
 WHERE d>e
 ORDER BY 2,5,1,4,3
 LIMIT 5;

CREATE VIRTUAL VIEW V230 AS SELECT a+b*2+c*3+d*4,
       abs(b-c),
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a)
  FROM t1
 WHERE d>e
 ORDER BY 3,4,1,5,2
 LIMIT 5;

CREATE VIRTUAL VIEW V231 AS SELECT b-c,
       d-e,
       abs(a)
  FROM t1
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V232 AS SELECT d
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V233 AS SELECT c-d,
       e,
       a+b*2,
       b,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
 ORDER BY 2,5,3,1,4
 LIMIT 5;

CREATE VIRTUAL VIEW V234 AS SELECT a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V235 AS SELECT e,
       a-b,
       c,
       a
  FROM t1
 ORDER BY 1,4,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V236 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(b-c),
       e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       a
  FROM t1
 WHERE d>e
   AND b>c
   AND c BETWEEN b-2 AND d+2
 ORDER BY 4,3,6,1,2,5
 LIMIT 5;

CREATE VIRTUAL VIEW V237 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       d-e
  FROM t1
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V238 AS SELECT a-b,
       abs(a),
       a,
       e,
       b-c
  FROM t1
 ORDER BY 2,4,3,1,5
 LIMIT 5;

CREATE VIRTUAL VIEW V239 AS SELECT (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V240 AS SELECT (a+b+c+d+e)/5,
       e,
       a-b
  FROM t1
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V241 AS SELECT b-c,
       c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR (e>c OR e<d)
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V242 AS SELECT d
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V243 AS SELECT abs(b-c)
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND c>d
   AND (a>b-2 AND a<b+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V244 AS SELECT a-b,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V245 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c>d
   AND d>e
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V246 AS SELECT a,
       c-d
  FROM t1
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V247 AS SELECT (a+b+c+d+e)/5
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V248 AS SELECT a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND a>b
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V249 AS SELECT abs(b-c)
  FROM t1
 WHERE b>c
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V250 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a)
  FROM t1
 WHERE d>e
   AND b>c
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V251 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       a,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
   AND c>d
 ORDER BY 1,5,2,6,3,4
 LIMIT 5;

CREATE VIRTUAL VIEW V252 AS SELECT a,
       a+b*2+c*3,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR c>d
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V253 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V254 AS SELECT c,
       a+b*2+c*3,
       c-d,
       abs(b-c),
       d-e
  FROM t1
 ORDER BY 3,4,1,2,5
 LIMIT 5;

CREATE VIRTUAL VIEW V255 AS SELECT e,
       d-e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR d>e
    OR (e>a AND e<b)
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V256 AS SELECT c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       b-c,
       e,
       c-d
  FROM t1
 ORDER BY 5,4,6,2,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V257 AS SELECT a-b,
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c,
       e,
       c
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 3,5,1,4,6,2
 LIMIT 5;

CREATE VIRTUAL VIEW V258 AS SELECT c,
       a+b*2+c*3,
       c-d,
       abs(a),
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE d>e
    OR (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
 ORDER BY 1,3,5,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V259 AS SELECT c,
       a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c>d
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V260 AS SELECT a+b*2+c*3+d*4,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V261 AS SELECT c-d,
       a+b*2+c*3+d*4,
       d,
       a-b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 ORDER BY 2,1,5,3,4
 LIMIT 5;

CREATE VIRTUAL VIEW V262 AS SELECT abs(b-c),
       a,
       a+b*2+c*3+d*4,
       c-d,
       c,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 6,3,1,4,5,2
 LIMIT 5;

CREATE VIRTUAL VIEW V263 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V264 AS SELECT abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       b,
       a,
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,2,4,6,1,5
 LIMIT 5;

CREATE VIRTUAL VIEW V265 AS SELECT abs(b-c)
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V266 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       c-d,
       (a+b+c+d+e)/5,
       b-c
  FROM t1
 ORDER BY 3,1,4,2,6,5
 LIMIT 5;

CREATE VIRTUAL VIEW V267 AS SELECT d,
       b,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V268 AS SELECT abs(a),
       c-d,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 3,2,4,1
 LIMIT 5;

CREATE VIRTUAL VIEW V269 AS SELECT c,
       e,
       b,
       abs(a),
       d,
       a
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 5,3,2,1,4,6
 LIMIT 5;

CREATE VIRTUAL VIEW V270 AS SELECT a-b,
       a+b*2
  FROM t1
 WHERE b>c
    OR c>d
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V271 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(b-c)
  FROM t1
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V272 AS SELECT d,
       d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       b,
       c,
       a+b*2+c*3
  FROM t1
 WHERE a>b
    OR b>c
 ORDER BY 3,1,5,6,4,2
 LIMIT 5;

CREATE VIRTUAL VIEW V273 AS SELECT abs(b-c),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V274 AS SELECT c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       a,
       b
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c>d
 ORDER BY 1,2,5,3,4
 LIMIT 5;

CREATE VIRTUAL VIEW V275 AS SELECT b-c,
       a+b*2,
       b
  FROM t1
 ORDER BY 2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V276 AS SELECT a
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V277 AS SELECT abs(b-c),
       a+b*2+c*3+d*4,
       c-d,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 4,1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V278 AS SELECT d,
       a+b*2+c*3,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 ORDER BY 2,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V279 AS SELECT c
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V280 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
   AND (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V281 AS SELECT c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
   AND (a>b-2 AND a<b+2)
   AND (e>a AND e<b)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V282 AS SELECT e,
       a+b*2+c*3+d*4+e*5,
       d-e,
       b-c,
       a+b*2+c*3+d*4,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,4,6,1,5,3
 LIMIT 5;

CREATE VIRTUAL VIEW V283 AS SELECT a
  FROM t1
 WHERE d>e
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V284 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V285 AS SELECT e,
       b-c,
       abs(b-c),
       a+b*2+c*3+d*4+e*5,
       c-d,
       abs(a)
  FROM t1
 WHERE b>c
 ORDER BY 3,6,2,1,5,4
 LIMIT 5;

CREATE VIRTUAL VIEW V286 AS SELECT b-c
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V287 AS SELECT d,
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V288 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4,
       a+b*2+c*3
  FROM t1
 WHERE d>e
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,4,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V289 AS SELECT a+b*2+c*3+d*4+e*5,
       abs(a),
       b-c
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V290 AS SELECT c
  FROM t1
 WHERE b>c
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V291 AS SELECT a+b*2+c*3+d*4,
       a-b,
       a+b*2,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3
  FROM t1
 ORDER BY 1,5,4,2,6,3
 LIMIT 5;

CREATE VIRTUAL VIEW V292 AS SELECT a+b*2+c*3+d*4,
       abs(b-c),
       b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d>e
 ORDER BY 3,1,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V293 AS SELECT abs(b-c),
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (a>b-2 AND a<b+2)
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V294 AS SELECT a-b,
       c,
       a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       e,
       b-c,
       d-e
  FROM t1
 ORDER BY 7,2,5,4,1,3,6
 LIMIT 5;

CREATE VIRTUAL VIEW V295 AS SELECT abs(a),
       d
  FROM t1
 WHERE (e>a AND e<b)
   AND a>b
   AND c>d
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V296 AS SELECT e,
       abs(a)
  FROM t1
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V297 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V298 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V299 AS SELECT abs(a),
       abs(b-c),
       d,
       a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,3,4,1
 LIMIT 5;

CREATE VIRTUAL VIEW V300 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       d-e,
       b,
       c,
       b-c
  FROM t1
 ORDER BY 3,5,6,2,4,1
 LIMIT 5;

CREATE VIRTUAL VIEW V301 AS SELECT a+b*2,
       b
  FROM t1
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V302 AS SELECT a+b*2+c*3+d*4
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V303 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 3,1,5,4,2
 LIMIT 5;

CREATE VIRTUAL VIEW V304 AS SELECT b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c)
  FROM t1
 ORDER BY 2,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V305 AS SELECT (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND d>e
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V306 AS SELECT a+b*2+c*3+d*4,
       d-e,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       (a+b+c+d+e)/5,
       abs(b-c)
  FROM t1
 ORDER BY 2,4,3,1,5,6
 LIMIT 5;

CREATE VIRTUAL VIEW V307 AS SELECT a+b*2+c*3+d*4,
       a+b*2,
       e,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>c OR e<d)
 ORDER BY 2,4,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V308 AS SELECT (a+b+c+d+e)/5,
       b,
       a+b*2+c*3+d*4+e*5,
       c,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c>d
 ORDER BY 2,5,3,4,1
 LIMIT 5;

CREATE VIRTUAL VIEW V309 AS SELECT abs(b-c),
       c-d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V310 AS SELECT c,
       a+b*2+c*3+d*4+e*5,
       abs(a)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND (e>a AND e<b)
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V311 AS SELECT a,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
   AND (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
 ORDER BY 3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V312 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       c-d,
       a
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND (e>c OR e<d)
   AND c>d
 ORDER BY 3,4,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V313 AS SELECT a+b*2,
       a
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
    OR (e>a AND e<b)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V314 AS SELECT d-e,
       b,
       a+b*2+c*3+d*4,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
 ORDER BY 2,3,1,4,5
 LIMIT 5;

CREATE VIRTUAL VIEW V315 AS SELECT b,
       a,
       abs(b-c),
       a+b*2+c*3+d*4+e*5,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(a),
       a+b*2
  FROM t1
 ORDER BY 4,1,2,7,5,3,6
 LIMIT 5;

CREATE VIRTUAL VIEW V316 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V317 AS SELECT d-e,
       c-d,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3+d*4,
       a
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 1,2,5,3,4
 LIMIT 5;

CREATE VIRTUAL VIEW V318 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       abs(a)
  FROM t1
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V319 AS SELECT e
  FROM t1
 WHERE c>d
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V320 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE a>b
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V321 AS SELECT (a+b+c+d+e)/5,
       a+b*2+c*3+d*4,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR a>b
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,4,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V322 AS SELECT b-c
  FROM t1
 WHERE d>e
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V323 AS SELECT b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR b>c
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V324 AS SELECT e,
       b,
       a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110 AND 150
    OR c BETWEEN b-2 AND d+2
 ORDER BY 2,5,3,1,7,6,4
 LIMIT 5;

CREATE VIRTUAL VIEW V325 AS SELECT a+b*2+c*3,
       d-e,
       a-b
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR (e>c OR e<d)
 ORDER BY 2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V326 AS SELECT a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       a-b
  FROM t1
 WHERE a>b
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 3,4,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V327 AS SELECT a-b
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V328 AS SELECT abs(a),
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR b>c
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V329 AS SELECT b,
       a,
       (a+b+c+d+e)/5,
       b-c,
       e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR a>b
 ORDER BY 3,1,2,5,4
 LIMIT 5;

CREATE VIRTUAL VIEW V330 AS SELECT b,
       d-e,
       (a+b+c+d+e)/5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,3,5,4,1
 LIMIT 5;

CREATE VIRTUAL VIEW V331 AS SELECT a+b*2+c*3
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V332 AS SELECT d-e,
       abs(a)
  FROM t1
 WHERE b>c
    OR a>b
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V333 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V334 AS SELECT a,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V335 AS SELECT c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND c>d
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V336 AS SELECT c,
       d-e,
       (a+b+c+d+e)/5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR d NOT BETWEEN 110 AND 150
    OR (e>c OR e<d)
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V337 AS SELECT abs(a),
       d-e
  FROM t1
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V338 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
   AND a>b
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V339 AS SELECT a+b*2+c*3,
       d,
       b-c,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2
  FROM t1
 ORDER BY 4,3,6,1,2,5
 LIMIT 5;

CREATE VIRTUAL VIEW V340 AS SELECT abs(a),
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V341 AS SELECT abs(a),
       c-d
  FROM t1
 WHERE d>e
    OR b>c
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V342 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2+c*3
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V343 AS SELECT b,
       a+b*2+c*3,
       abs(b-c),
       a-b
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,1,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V344 AS SELECT c-d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V345 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V346 AS SELECT a+b*2+c*3,
       a-b,
       c-d
  FROM t1
 WHERE a>b
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V347 AS SELECT d,
       a+b*2+c*3,
       a+b*2,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND d NOT BETWEEN 110 AND 150
 ORDER BY 1,2,3,5,4
 LIMIT 5;

CREATE VIRTUAL VIEW V348 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3,
       c,
       d-e,
       a+b*2+c*3+d*4+e*5,
       d,
       a-b
  FROM t1
 ORDER BY 3,1,7,6,4,2,5
 LIMIT 5;

CREATE VIRTUAL VIEW V349 AS SELECT c-d,
       e,
       (a+b+c+d+e)/5,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 4,1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V350 AS SELECT c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
   AND (c<=d-2 OR c>=d+2)
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V351 AS SELECT b-c,
       c
  FROM t1
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V352 AS SELECT d
  FROM t1
 WHERE d>e
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V353 AS SELECT a+b*2+c*3+d*4+e*5,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a-b
  FROM t1
 ORDER BY 4,3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V354 AS SELECT d,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a
  FROM t1
 WHERE a>b
 ORDER BY 1,3,4,2
 LIMIT 5;

CREATE VIRTUAL VIEW V355 AS SELECT abs(a),
       a+b*2+c*3,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V356 AS SELECT c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a+b*2+c*3,
       c,
       abs(a)
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>a AND e<b)
 ORDER BY 2,4,1,3,5,6
 LIMIT 5;

CREATE VIRTUAL VIEW V357 AS SELECT d,
       a+b*2
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V358 AS SELECT b
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
    OR (a>b-2 AND a<b+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V359 AS SELECT (a+b+c+d+e)/5,
       b-c,
       a
  FROM t1
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V360 AS SELECT a+b*2+c*3+d*4,
       d-e,
       a+b*2+c*3,
       abs(b-c),
       d,
       b-c,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,7,1,6,5,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V361 AS SELECT c-d,
       b-c,
       abs(b-c)
  FROM t1
 WHERE d>e
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V362 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V363 AS SELECT a+b*2+c*3+d*4+e*5,
       a,
       a+b*2
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 2,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V364 AS SELECT a+b*2+c*3,
       c-d,
       d,
       a
  FROM t1
 ORDER BY 3,2,1,4
 LIMIT 5;

CREATE VIRTUAL VIEW V365 AS SELECT b-c,
       a+b*2+c*3+d*4,
       c-d,
       a,
       d-e,
       c
  FROM t1
 WHERE d>e
 ORDER BY 3,4,1,5,6,2
 LIMIT 5;

CREATE VIRTUAL VIEW V366 AS SELECT c-d,
       c,
       abs(a),
       a+b*2+c*3
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>c OR e<d)
 ORDER BY 1,4,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V367 AS SELECT d-e,
       abs(b-c),
       (a+b+c+d+e)/5
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>a AND e<b)
 ORDER BY 2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V368 AS SELECT a,
       d-e,
       c,
       a+b*2,
       e
  FROM t1
 WHERE a>b
    OR c>d
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,3,5,4,1
 LIMIT 5;

CREATE VIRTUAL VIEW V369 AS SELECT b,
       a-b,
       a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       c,
       c-d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 5,3,4,6,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V370 AS SELECT a-b,
       b,
       a+b*2+c*3+d*4+e*5,
       d-e,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d
  FROM t1
 ORDER BY 5,2,1,4,3,6
 LIMIT 5;

CREATE VIRTUAL VIEW V371 AS SELECT a
  FROM t1
 WHERE d>e
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V372 AS SELECT a+b*2,
       b-c,
       a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V373 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       abs(b-c),
       e
  FROM t1
 ORDER BY 2,3,1,4
 LIMIT 5;

CREATE VIRTUAL VIEW V374 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V375 AS SELECT a+b*2+c*3+d*4+e*5,
       a-b,
       a+b*2+c*3+d*4
  FROM t1
 WHERE b>c
   AND a>b
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V376 AS SELECT b,
       d,
       b-c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V377 AS SELECT (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V378 AS SELECT d,
       a+b*2+c*3+d*4+e*5,
       a+b*2,
       abs(a),
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,5,4,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V379 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE a>b
   AND b>c
   AND (e>c OR e<d)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V380 AS SELECT c
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V381 AS SELECT a+b*2+c*3+d*4+e*5,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c>d
    OR e+d BETWEEN a+b-10 AND c+130
    OR (e>a AND e<b)
 ORDER BY 2,1,4,3,5,6,7
 LIMIT 5;

CREATE VIRTUAL VIEW V382 AS SELECT (a+b+c+d+e)/5
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V383 AS SELECT c-d
  FROM t1
 WHERE d>e
   AND e+d BETWEEN a+b-10 AND c+130
   AND a>b
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V384 AS SELECT a+b*2+c*3,
       d,
       e,
       a+b*2+c*3+d*4
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2 AND d+2
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,1,3,4
 LIMIT 5;

CREATE VIRTUAL VIEW V385 AS SELECT a+b*2,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       abs(a),
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
 ORDER BY 6,3,1,5,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V386 AS SELECT c
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V387 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
   AND (e>c OR e<d)
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V388 AS SELECT abs(a),
       (a+b+c+d+e)/5
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
   AND d>e
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V389 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       a+b*2
  FROM t1
 ORDER BY 2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V390 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b,
       b-c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1,4,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V391 AS SELECT (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V392 AS SELECT b-c,
       a,
       a+b*2+c*3+d*4,
       d
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND c>d
   AND d>e
 ORDER BY 4,2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V393 AS SELECT a+b*2+c*3+d*4+e*5,
       a+b*2+c*3,
       e,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b-c
  FROM t1
 ORDER BY 6,4,3,1,2,5
 LIMIT 5;

CREATE VIRTUAL VIEW V394 AS SELECT b-c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d,
       a+b*2+c*3+d*4+e*5,
       e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 3,5,1,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V395 AS SELECT e,
       d-e,
       a+b*2+c*3
  FROM t1
 ORDER BY 2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V396 AS SELECT a-b,
       e,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d,
       abs(a),
       a+b*2+c*3
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1,5,7,2,6,4,3
 LIMIT 5;

CREATE VIRTUAL VIEW V397 AS SELECT a+b*2+c*3,
       c-d,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR (e>a AND e<b)
 ORDER BY 2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V398 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2 AND a<b+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V399 AS SELECT (a+b+c+d+e)/5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
    OR (a>b-2 AND a<b+2)
    OR d>e
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V400 AS SELECT a+b*2+c*3+d*4,
       a,
       a+b*2,
       a-b,
       abs(a),
       a+b*2+c*3
  FROM t1
 ORDER BY 2,3,1,6,4,5
 LIMIT 5;

CREATE VIRTUAL VIEW V401 AS SELECT d-e,
       c,
       a+b*2+c*3,
       b,
       abs(a),
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND c>d
 ORDER BY 3,5,1,2,4,6,7
 LIMIT 5;

CREATE VIRTUAL VIEW V402 AS SELECT d-e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c,
       a+b*2+c*3,
       b,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE b>c
 ORDER BY 1,4,6,3,5,2
 LIMIT 5;

CREATE VIRTUAL VIEW V403 AS SELECT (a+b+c+d+e)/5,
       abs(b-c),
       a+b*2+c*3+d*4,
       d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       d-e,
       abs(a)
  FROM t1
 WHERE a>b
    OR b>c
    OR c>d
 ORDER BY 1,4,5,2,6,7,3
 LIMIT 5;

CREATE VIRTUAL VIEW V404 AS SELECT a-b,
       c-d,
       b
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V405 AS SELECT c-d,
       a-b,
       b
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V406 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE d>e
   AND (a>b-2 AND a<b+2)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V407 AS SELECT e,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(a),
       c-d,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       b,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 6,7,5,4,1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V408 AS SELECT d-e
  FROM t1
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V409 AS SELECT a+b*2,
       e
  FROM t1
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V410 AS SELECT a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
 ORDER BY 2,1,3,4
 LIMIT 5;

CREATE VIRTUAL VIEW V411 AS SELECT a+b*2,
       (a+b+c+d+e)/5
  FROM t1
 WHERE (a>b-2 AND a<b+2)
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V412 AS SELECT abs(b-c),
       a-b,
       a+b*2
  FROM t1
 WHERE (e>c OR e<d)
    OR d>e
 ORDER BY 3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V413 AS SELECT a+b*2+c*3+d*4,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c
  FROM t1
 WHERE c>d
 ORDER BY 1,3,4,2
 LIMIT 5;

CREATE VIRTUAL VIEW V414 AS SELECT b,
       abs(b-c),
       d,
       a-b,
       d-e,
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 2,5,1,4,6,3
 LIMIT 5;

CREATE VIRTUAL VIEW V415 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V416 AS SELECT a-b,
       a+b*2
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
    OR (c<=d-2 OR c>=d+2)
    OR a>b
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V417 AS SELECT a,
       b,
       abs(b-c),
       e,
       a+b*2,
       d-e,
       (a+b+c+d+e)/5
  FROM t1
 WHERE b>c
   AND c>d
 ORDER BY 6,1,7,2,5,4,3
 LIMIT 5;

CREATE VIRTUAL VIEW V418 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       c-d
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V419 AS SELECT d-e,
       b,
       abs(b-c),
       c,
       a+b*2+c*3,
       a+b*2+c*3+d*4,
       a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 4,6,7,2,5,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V420 AS SELECT a+b*2,
       c,
       abs(a),
       b,
       d-e
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR c>d
 ORDER BY 5,2,3,1,4
 LIMIT 5;

CREATE VIRTUAL VIEW V421 AS SELECT a+b*2
  FROM t1
 WHERE (a>b-2 AND a<b+2)
   AND b>c
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V422 AS SELECT abs(b-c),
       d-e,
       a+b*2,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d NOT BETWEEN 110 AND 150
    OR c>d
 ORDER BY 4,2,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V423 AS SELECT d-e,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 2,1,3
 LIMIT 5;

CREATE VIRTUAL VIEW V424 AS SELECT a+b*2+c*3,
       e,
       d-e
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND c BETWEEN b-2 AND d+2
   AND d>e
 ORDER BY 3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V425 AS SELECT a+b*2,
       d,
       abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE b>c
    OR (c<=d-2 OR c>=d+2)
    OR (e>c OR e<d)
 ORDER BY 2,3,1,4
 LIMIT 5;

CREATE VIRTUAL VIEW V426 AS SELECT a-b,
       c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 3,1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V427 AS SELECT d,
       c
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND d>e
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V428 AS SELECT a,
       c-d,
       c,
       (a+b+c+d+e)/5,
       abs(b-c),
       b
  FROM t1
 ORDER BY 1,2,5,4,6,3
 LIMIT 5;

CREATE VIRTUAL VIEW V429 AS SELECT a+b*2+c*3+d*4,
       d,
       abs(a),
       c-d,
       a
  FROM t1
 ORDER BY 1,3,4,2,5
 LIMIT 5;

CREATE VIRTUAL VIEW V430 AS SELECT c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       a,
       d-e,
       b-c,
       d
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
 ORDER BY 1,7,6,2,3,4,5
 LIMIT 5;

CREATE VIRTUAL VIEW V431 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d,
       b-c,
       c
  FROM t1
 ORDER BY 3,1,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V432 AS SELECT c
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V433 AS SELECT (a+b+c+d+e)/5,
       e,
       c-d,
       a+b*2+c*3,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a-b
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
    OR c BETWEEN b-2 AND d+2
 ORDER BY 5,4,3,1,2,6
 LIMIT 5;

CREATE VIRTUAL VIEW V434 AS SELECT b,
       c
  FROM t1
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V435 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a,
       d-e
  FROM t1
 ORDER BY 1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V436 AS SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       e,
       d,
       b-c,
       (a+b+c+d+e)/5,
       abs(b-c),
       a+b*2+c*3
  FROM t1
 ORDER BY 4,3,5,1,7,2,6
 LIMIT 5;

CREATE VIRTUAL VIEW V437 AS SELECT (a+b+c+d+e)/5,
       c-d,
       a+b*2+c*3+d*4,
       d-e,
       b-c,
       e,
       a+b*2+c*3+d*4+e*5
  FROM t1
 ORDER BY 7,1,2,4,6,5,3
 LIMIT 5;

CREATE VIRTUAL VIEW V438 AS SELECT c,
       b
  FROM t1
 WHERE a>b
    OR b>c
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V439 AS SELECT b-c,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       a,
       a+b*2,
       a+b*2+c*3,
       e
  FROM t1
 WHERE (e>c OR e<d)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,5,2,4,6,3
 LIMIT 5;

CREATE VIRTUAL VIEW V440 AS SELECT a+b*2+c*3
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V441 AS SELECT b,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       abs(b-c),
       a-b,
       abs(a),
       (a+b+c+d+e)/5
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110 AND 150
   AND c>d
 ORDER BY 5,4,2,3,1,6
 LIMIT 5;

CREATE VIRTUAL VIEW V442 AS SELECT e
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2 OR c>=d+2)
    OR (e>a AND e<b)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V443 AS SELECT abs(a)
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR d>e
    OR (e>c OR e<d)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V444 AS SELECT a+b*2+c*3+d*4+e*5,
       c,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       c-d,
       a-b,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 4,2,3,6,1,5
 LIMIT 5;

CREATE VIRTUAL VIEW V445 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d NOT BETWEEN 110 AND 150
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V446 AS SELECT d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       (a+b+c+d+e)/5,
       b,
       a,
       a+b*2,
       d-e
  FROM t1
 ORDER BY 5,1,6,7,2,3,4
 LIMIT 5;

CREATE VIRTUAL VIEW V447 AS SELECT c,
       a-b,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END
  FROM t1
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V448 AS SELECT abs(a),
       e,
       a-b,
       a,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
       d-e
  FROM t1
 WHERE a>b
    OR d NOT BETWEEN 110 AND 150
    OR b>c
 ORDER BY 4,6,1,2,3,5
 LIMIT 5;

CREATE VIRTUAL VIEW V449 AS SELECT b-c,
       a+b*2+c*3,
       a+b*2,
       c-d,
       (a+b+c+d+e)/5,
       a-b
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
   AND d NOT BETWEEN 110 AND 150
   AND d>e
 ORDER BY 6,1,5,3,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V450 AS SELECT a+b*2+c*3+d*4+e*5,
       b,
       a-b
  FROM t1
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V451 AS SELECT d,
       a+b*2+c*3+d*4
  FROM t1
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V452 AS SELECT abs(a),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a>b
    OR b>c
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V453 AS SELECT a-b
  FROM t1
 WHERE d NOT BETWEEN 110 AND 150
   AND (e>c OR e<d)
   AND a>b
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V454 AS SELECT a,
       (a+b+c+d+e)/5,
       c
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2 AND d+2
    OR (e>c OR e<d)
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V455 AS SELECT a+b*2+c*3+d*4+e*5,
       a-b,
       b,
       a+b*2+c*3+d*4,
       a+b*2+c*3,
       d-e,
       abs(b-c)
  FROM t1
 WHERE b>c
   AND a>b
   AND c>d
 ORDER BY 4,2,1,7,5,6,3
 LIMIT 5;

CREATE VIRTUAL VIEW V456 AS SELECT a+b*2
  FROM t1
 WHERE a>b
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V457 AS SELECT (a+b+c+d+e)/5,
       d-e
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V458 AS SELECT d
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>a AND e<b)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V459 AS SELECT d-e,
       c-d,
       b,
       b-c,
       abs(b-c),
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE (a>b-2 AND a<b+2)
    OR e+d BETWEEN a+b-10 AND c+130
 ORDER BY 5,3,4,2,6,1
 LIMIT 5;

CREATE VIRTUAL VIEW V460 AS SELECT a+b*2+c*3+d*4+e*5
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10 AND c+130
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V461 AS SELECT a+b*2,
       a+b*2+c*3
  FROM t1
 WHERE b>c
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V462 AS SELECT abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2 AND d+2
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V463 AS SELECT a+b*2+c*3,
       a+b*2+c*3+d*4+e*5,
       b,
       abs(a),
       (a+b+c+d+e)/5,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 6,5,4,1,3,2
 LIMIT 5;

CREATE VIRTUAL VIEW V464 AS SELECT a+b*2+c*3+d*4
  FROM t1
 WHERE (e>c OR e<d)
   AND c BETWEEN b-2 AND d+2
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V465 AS SELECT d-e,
       c,
       d
  FROM t1
 ORDER BY 3,2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V466 AS SELECT d-e,
       c
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V467 AS SELECT a+b*2
  FROM t1
 WHERE c>d
    OR e+d BETWEEN a+b-10 AND c+130
    OR (c<=d-2 OR c>=d+2)
 ORDER BY 1
 LIMIT 5;

CREATE VIRTUAL VIEW V468 AS SELECT a-b,
       d,
       d-e,
       a,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
  FROM t1
 WHERE a>b
 ORDER BY 3,5,4,2,1,6
 LIMIT 5;

CREATE VIRTUAL VIEW V469 AS SELECT c,
       a+b*2+c*3+d*4,
       a
  FROM t1
 WHERE (e>a AND e<b)
    OR c BETWEEN b-2 AND d+2
 ORDER BY 1,2,3
 LIMIT 5;

CREATE VIRTUAL VIEW V470 AS SELECT d-e,
       a+b*2+c*3
  FROM t1
 ORDER BY 2,1
 LIMIT 5;

CREATE VIRTUAL VIEW V471 AS SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a
  FROM t1
 ORDER BY 1,2
 LIMIT 5;

CREATE VIRTUAL VIEW V472 AS SELECT abs(b-c),
       a+b*2+c*3+d*4+e*5,
       b,
       d-e
  FROM t1
 WHERE (c<=d-2 OR c>=d+2)
    OR d>e
 ORDER BY 3,1,2,4
 LIMIT 5;

CREATE VIRTUAL VIEW V473 AS SELECT c-d,
       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
        WHEN a<b+3 THEN 333 ELSE 444 END,
       a+b*2,
       e,
       c,
       a+b*2+c*3+d*4
  FROM t1
 WHERE e+d BETWEEN a+b-10 AND c+130
    OR (e>c OR e<d)
 ORDER BY 2,4,6,5,3,1
 LIMIT 5;

CREATE VIRTUAL VIEW V474 AS SELECT a,
       a+b*2+c*3,
       (a+b+c+d+e)/5
  FROM t1
 ORDER BY 2,3,1
 LIMIT 5;
