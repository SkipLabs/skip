SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1,2
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT c,
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
;

SELECT a+b*2.0+c*3.0+d*4.0,
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
;

SELECT a+b*2.0+c*3.0+d*4.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 4,2,1,3
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c>d
 ORDER BY 1
;

SELECT a,
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
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
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
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
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
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       a+b*2.0+c*3.0+d*4.0,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR c>d
 ORDER BY 3,5,4,1,2
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b,
       abs(b-c),
       c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 4,3,6,2,5,1
;

SELECT a+b*2.0,
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
;

SELECT a,
       b
  FROM t1
 ORDER BY 1,2
;

SELECT c,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,2,3
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
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
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
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
;

SELECT a,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       a+b*2.0
  FROM t1
 ORDER BY 6,2,4,5,3,1
;

SELECT d-e,
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
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
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
;

SELECT e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d,
       c
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,4,5,6,2,3
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND c>d
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0,
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
;

SELECT a+b*2.0,
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
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d,
       a-b
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,5,4,1,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND a>b
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
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
;

SELECT d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       c-d,
       (a+b+c+d+e)/5.0,
       a-b
  FROM t1
 ORDER BY 3,4,2,6,5,1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
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
;

SELECT d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       c,
       e
  FROM t1
 WHERE b>c
 ORDER BY 1,2,4,3,5
;

SELECT a-b,
       a,
       a+b*2.0+c*3.0,
       b,
       d,
       d-e
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,6,4,1,5,3
;

SELECT (a+b+c+d+e)/5.0,
       a+b*2.0,
       c-d,
       a,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
 ORDER BY 2,6,5,4,3,1
;

SELECT b,
       (a+b+c+d+e)/5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       b-c
  FROM t1
 WHERE a>b
 ORDER BY 2,5,3,4,1
;

SELECT abs(b-c),
       a,
       a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 1,4,3,2
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c,
       d-e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND c>d
 ORDER BY 2,1,3
;

SELECT a,
       e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b
  FROM t1
 ORDER BY 2,4,3,1
;

SELECT (a+b+c+d+e)/5.0,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,1,2
;

SELECT a-b,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
 ORDER BY 4,1,3,2
;

SELECT a+b*2.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR a>b
 ORDER BY 1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
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
;

SELECT a,
       c-d,
       d
  FROM t1
 WHERE c>d
   AND a>b
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2,3
;

SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c,
       (a+b+c+d+e)/5.0,
       b
  FROM t1
 ORDER BY 5,4,1,3,2
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d,
       abs(a),
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,5,3,2,4
;

SELECT c,
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
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d
  FROM t1
 WHERE d>e
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,2,4,1
;

SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
 ORDER BY 2,3,4,1
;

SELECT a+b*2.0+c*3.0
  FROM t1
 ORDER BY 1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0
  FROM t1
 WHERE d>e
 ORDER BY 3,4,1,2,5
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b
  FROM t1
 WHERE b>c
 ORDER BY 1,2
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0,
       b-c
  FROM t1
 WHERE d>e
 ORDER BY 4,1,5,3,2
;

SELECT a-b,
       a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1,2,3
;

SELECT d,
       a+b*2.0,
       a,
       b,
       b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 5,2,7,1,4,6,3
;

SELECT e
  FROM t1
 WHERE b>c
   AND d>e
 ORDER BY 1
;

SELECT b,
       e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,1
;

SELECT b-c,
       d-e,
       c-d,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 1,2,4,3
;

SELECT abs(b-c),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
;

SELECT e,
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,3,4,2
;

SELECT abs(a),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d
  FROM t1
 ORDER BY 3,2,1
;

SELECT abs(a),
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
;

SELECT (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>a AND e<b)
   AND c>d
 ORDER BY 2,5,6,4,1,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT a+b*2.0,
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
;

SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 3,2,4,1
;

SELECT e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
;

SELECT abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,4,5,1,2
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND d>e
 ORDER BY 1,2
;

SELECT b-c
  FROM t1
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       d-e,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,6,2,4,5,3
;

SELECT d,
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
;

SELECT b-c,
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
;

SELECT abs(a),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 4,3,2,1
;

SELECT b,
       c,
       a-b,
       d-e,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d>e
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,1,4,3,5
;

SELECT a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND b>c
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2
;

SELECT b,
       abs(a),
       a,
       c
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (e>c OR e<d)
    OR b>c
 ORDER BY 4,3,2,1
;

SELECT a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d,
       a+b*2.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
 ORDER BY 2,4,3,1
;

SELECT b,
       abs(b-c)
  FROM t1
 WHERE c>d
   AND a>b
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d-e,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       a,
       e
  FROM t1
 ORDER BY 4,5,1,3,7,6,2
;

SELECT d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d-e
  FROM t1
 ORDER BY 1,6,2,3,5,4
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 2,1,3
;

SELECT a+b*2.0+c*3.0+d*4.0,
       abs(b-c),
       c-d
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 2,3,1
;

SELECT a-b,
       abs(a),
       d
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>a AND e<b)
    OR (c<=d-2.0 OR c>=d+2.0)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,1
;

SELECT (a+b+c+d+e)/5.0,
       abs(a),
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1,3
;

SELECT a+b*2.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a-b,
       abs(b-c),
       c,
       b,
       e
  FROM t1
 WHERE d>e
 ORDER BY 4,5,3,6,2,1,7
;

SELECT a,
       d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (a>b-2.0 AND a<b+2.0)
    OR b>c
 ORDER BY 1,3,5,4,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT b-c,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE c>d
    OR (a>b-2.0 AND a<b+2.0)
    OR b>c
 ORDER BY 1,3,5,2,4
;

SELECT b-c,
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
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (c<=d-2.0 OR c>=d+2.0)
    OR c>d
 ORDER BY 1,3,2
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0+d*4.0,
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
;

SELECT abs(a),
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
;

SELECT (a+b+c+d+e)/5.0,
       a-b,
       b,
       a+b*2.0,
       a
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND (e>c OR e<d)
   AND d>e
 ORDER BY 4,2,5,3,1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
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
;

SELECT c-d,
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
;

SELECT c-d,
       d-e,
       abs(a),
       a,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE a>b
    OR c>d
 ORDER BY 1,5,3,2,4
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       abs(a),
       a-b,
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND b>c
 ORDER BY 4,6,3,1,5,2
;

SELECT a+b*2.0+c*3.0,
       a
  FROM t1
 WHERE (e>c OR e<d)
    OR a>b
 ORDER BY 1,2
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (a>b-2.0 AND a<b+2.0)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,3
;

SELECT a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       a+b*2.0+c*3.0
  FROM t1
 WHERE d>e
 ORDER BY 4,2,1,5,3
;

SELECT e
  FROM t1
 ORDER BY 1
;

SELECT c-d,
       b,
       d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c>d
 ORDER BY 4,3,5,6,2,1
;

SELECT abs(b-c),
       c-d,
       a,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
 ORDER BY 4,2,1,5,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0
  FROM t1
 WHERE c>d
   AND b>c
   AND e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,4,1,2
;

SELECT (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1
;

SELECT a+b*2.0,
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
 ORDER BY 6,5,4,1,3,2
;

SELECT a+b*2.0+c*3.0+d*4.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d,
       e
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,1,2,4
;

SELECT a+b*2.0+c*3.0,
       a+b*2.0,
       a-b,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE a>b
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
 ORDER BY 2,1,3,4
;

SELECT (a+b+c+d+e)/5.0,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
    OR b>c
 ORDER BY 2,1,3
;

SELECT abs(a),
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
;

SELECT c,
       d,
       a+b*2.0+c*3.0,
       a-b,
       e
  FROM t1
 ORDER BY 3,2,1,5,4
;

SELECT c-d,
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
;

SELECT (a+b+c+d+e)/5.0,
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
;

SELECT c-d,
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
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT b-c,
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
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,2
;

SELECT b,
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
    OR c BETWEEN b-2.0 AND d+2.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

SELECT a+b*2.0,
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
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>a AND e<b)
   AND (e>c OR e<d)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0,
       b,
       a-b
  FROM t1
 WHERE c>d
    OR d>e
    OR b>c
 ORDER BY 3,1,2
;

SELECT a-b
  FROM t1
 ORDER BY 1
;

SELECT e,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,2,4,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0
  FROM t1
 ORDER BY 2,4,1,5,3
;

SELECT b-c,
       c,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d NOT BETWEEN 110.0 AND 150.0
    OR b>c
 ORDER BY 3,5,4,2,1
;

SELECT b-c,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE b>c
   AND a>b
   AND (e>a AND e<b)
 ORDER BY 2,1
;

SELECT a+b*2.0,
       b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE b>c
   AND a>b
 ORDER BY 3,2,1
;

SELECT a+b*2.0+c*3.0,
       d,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND b>c
   AND c>d
 ORDER BY 3,5,1,4,2
;

SELECT d-e,
       (a+b+c+d+e)/5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 2,1,3,4
;

SELECT c-d,
       e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND c>d
 ORDER BY 2,1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
;

SELECT a-b,
       b-c
  FROM t1
 WHERE b>c
   AND d>e
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,1
;

SELECT b,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
 ORDER BY 1,2,3
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       a+b*2.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,3,2
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
 ORDER BY 1,2
;

SELECT e,
       a,
       a+b*2.0+c*3.0,
       b,
       d
  FROM t1
 WHERE c>d
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,5,1,3,2
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE a>b
 ORDER BY 3,1,2
;

SELECT abs(a),
       (a+b+c+d+e)/5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0,
       d-e
  FROM t1
 ORDER BY 3,1,2,5,4
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       (a+b+c+d+e)/5.0,
       a+b*2.0,
       c-d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 5,3,2,4,1
;

SELECT c,
       a+b*2.0,
       abs(b-c)
  FROM t1
 WHERE b>c
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       a+b*2.0+c*3.0+d*4.0,
       c,
       a+b*2.0
  FROM t1
 ORDER BY 7,3,2,6,4,5,1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a),
       a-b
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,3,2
;

SELECT d
  FROM t1
 WHERE (e>a AND e<b)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

SELECT (a+b+c+d+e)/5.0,
       abs(b-c),
       c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a),
       e
  FROM t1
 WHERE b>c
   AND d>e
 ORDER BY 4,5,6,3,2,1
;

SELECT a+b*2.0+c*3.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
;

SELECT abs(b-c),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       a
  FROM t1
 WHERE b>c
   AND d>e
 ORDER BY 4,1,3,2
;

SELECT a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       a,
       abs(a),
       c-d,
       c
  FROM t1
 ORDER BY 2,5,4,6,3,1
;

SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2
;

SELECT abs(b-c),
       b,
       e
  FROM t1
 WHERE a>b
 ORDER BY 1,3,2
;

SELECT abs(a),
       a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c),
       d-e
  FROM t1
 ORDER BY 3,1,4,5,2
;

SELECT abs(b-c),
       e
  FROM t1
 WHERE c>d
 ORDER BY 1,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 ORDER BY 1,2
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
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
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

SELECT b,
       e
  FROM t1
 WHERE d>e
    OR (a>b-2.0 AND a<b+2.0)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0,
       a+b*2.0
  FROM t1
 WHERE a>b
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,1
;

SELECT (a+b+c+d+e)/5.0,
       d,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 3,2,1
;

SELECT abs(b-c),
       c-d
  FROM t1
 ORDER BY 1,2
;

SELECT a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       a+b*2.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR a>b
    OR b>c
 ORDER BY 3,1,2,4
;

SELECT a,
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
;

SELECT c,
       b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 1,2,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d,
       d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,3,4,2
;

SELECT b
  FROM t1
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0
  FROM t1
 ORDER BY 1
;

SELECT abs(a),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND d NOT BETWEEN 110.0 AND 150.0
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
;

SELECT (a+b+c+d+e)/5.0,
       a+b*2.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       d-e
  FROM t1
 WHERE d>e
   AND (e>a AND e<b)
   AND b>c
 ORDER BY 1,5,3,4,2
;

SELECT a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
    OR a>b
    OR (e>a AND e<b)
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0,
       e,
       a-b
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND b>c
 ORDER BY 1,3,2
;

SELECT d-e,
       a,
       b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 3,1,2,4
;

SELECT b,
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
;

SELECT (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110.0 AND 150.0
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0,
       c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
    OR (c<=d-2.0 OR c>=d+2.0)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,2,4,3
;

SELECT (a+b+c+d+e)/5.0,
       abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a-b,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 3,5,1,2,7,4,6
;

SELECT a,
       abs(a),
       d,
       (a+b+c+d+e)/5.0,
       c-d
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
 ORDER BY 2,1,3,5,4
;

SELECT a+b*2.0+c*3.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,5,3,2,4
;

SELECT c,
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
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT e,
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
;

SELECT c,
       a+b*2.0,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,3
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
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
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0,
       c
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,3,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d
  FROM t1
 ORDER BY 2,3,1
;

SELECT d-e,
       abs(b-c),
       (a+b+c+d+e)/5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND (e>a AND e<b)
   AND a>b
 ORDER BY 3,4,1,2
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0,
       b-c,
       d-e
  FROM t1
 ORDER BY 1,2,3,4
;

SELECT d,
       a+b*2.0+c*3.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT abs(a),
       abs(b-c),
       c,
       a-b,
       c-d,
       a+b*2.0+c*3.0+d*4.0,
       b
  FROM t1
 ORDER BY 2,6,7,4,1,5,3
;

SELECT b,
       d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
    OR a>b
 ORDER BY 3,2,1
;

SELECT a-b,
       a+b*2.0+c*3.0+d*4.0,
       d,
       e
  FROM t1
 ORDER BY 2,4,1,3
;

SELECT a+b*2.0,
       c-d,
       d-e,
       abs(a),
       a-b,
       c,
       b
  FROM t1
 WHERE a>b
 ORDER BY 3,2,1,4,7,5,6
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT d,
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
;

SELECT d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
;

SELECT a+b*2.0,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,3,2,4
;

SELECT a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b,
       c,
       abs(a)
  FROM t1
 WHERE d>e
 ORDER BY 1,3,2,4,5
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d
  FROM t1
 ORDER BY 4,1,2,3,5
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2.0+c*3.0,
       c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR d>e
 ORDER BY 3,4,2,5,1
;

SELECT abs(a)
  FROM t1
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0,
       d,
       a-b,
       abs(a),
       c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 5,2,1,4,6,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT a+b*2.0+c*3.0+d*4.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
 ORDER BY 4,1,3,2
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
;

SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       b-c,
       a+b*2.0+c*3.0+d*4.0,
       c,
       abs(a)
  FROM t1
 WHERE d>e
 ORDER BY 2,1,4,5,6,3,7
;

SELECT b,
       a+b*2.0+c*3.0+d*4.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 5,4,2,1,3,6
;

SELECT d,
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
;

SELECT a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b
  FROM t1
 ORDER BY 1,3,2
;

SELECT b,
       a-b,
       c,
       abs(b-c),
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,6,4,5,2,7,3
;

SELECT c-d,
       a+b*2.0+c*3.0+d*4.0,
       a,
       abs(b-c),
       abs(a),
       (a+b+c+d+e)/5.0,
       c
  FROM t1
 ORDER BY 2,4,5,6,3,7,1
;

SELECT c,
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
;

SELECT a+b*2.0,
       b,
       d-e,
       a,
       abs(b-c),
       d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,5,4,3,6
;

SELECT d
  FROM t1
 WHERE (e>a AND e<b)
    OR (e>c OR e<d)
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d-e
  FROM t1
 WHERE b>c
   AND d>e
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,2
;

SELECT abs(a),
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
    OR (e>a AND e<b)
 ORDER BY 2,4,1,3
;

SELECT a+b*2.0+c*3.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND c BETWEEN b-2.0 AND d+2.0
   AND b>c
 ORDER BY 1
;

SELECT d,
       abs(b-c),
       a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0,
       e,
       b
  FROM t1
 ORDER BY 2,6,3,5,7,4,1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 1,2,3
;

SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       d-e,
       b,
       abs(b-c),
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 6,1,4,2,5,3,7
;

SELECT abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       e
  FROM t1
 WHERE c>d
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,3,4,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       a+b*2.0+c*3.0,
       abs(b-c),
       c-d,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 3,2,6,4,5,1
;

SELECT d-e,
       a+b*2.0+c*3.0+d*4.0,
       d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b,
       b
  FROM t1
 WHERE c>d
   AND a>b
 ORDER BY 2,4,3,6,1,5
;

SELECT abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND c>d
 ORDER BY 1
;

SELECT c,
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
;

SELECT a-b,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
    OR d>e
 ORDER BY 1,2
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0,
       c-d,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 2,3,4,5,1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE a>b
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
;

SELECT d-e
  FROM t1
 WHERE a>b
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR d NOT BETWEEN 110.0 AND 150.0
    OR b>c
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d>e
    OR (e>c OR e<d)
 ORDER BY 1,2
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,4,5,1,3
;

SELECT a,
       abs(a),
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 3,1,2,4
;

SELECT b-c,
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
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b,
       abs(b-c)
  FROM t1
 WHERE c>d
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,1,3
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2.0 AND d+2.0
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,3,2
;

SELECT (a+b+c+d+e)/5.0,
       a,
       b
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,2,1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a-b,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a
  FROM t1
 ORDER BY 2,4,5,1,3
;

SELECT c,
       a-b,
       a+b*2.0+c*3.0,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR d>e
    OR a>b
 ORDER BY 5,3,2,4,1
;

SELECT (a+b+c+d+e)/5.0,
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
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       a,
       abs(a),
       b,
       a+b*2.0
  FROM t1
 WHERE a>b
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,6,3,5,4,2
;

SELECT abs(b-c)
  FROM t1
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT a,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,4,5,6,1,3
;

SELECT (a+b+c+d+e)/5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (c<=d-2.0 OR c>=d+2.0)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

SELECT e
  FROM t1
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1,2
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 2,3,1
;

SELECT c
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
;

SELECT a+b*2.0,
       a,
       d,
       c,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 4,2,3,1,5
;

SELECT a-b,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0,
       d,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,5,3,2,1
;

SELECT d-e
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
;

SELECT abs(b-c),
       a+b*2.0+c*3.0,
       a+b*2.0
  FROM t1
 ORDER BY 1,3,2
;

SELECT d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a,
       d-e,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 4,3,5,1,2
;

SELECT abs(a),
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
;

SELECT a-b,
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
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
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
;

SELECT b,
       a-b,
       a,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,3,4
;

SELECT a+b*2.0+c*3.0,
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
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c,
       d-e
  FROM t1
 ORDER BY 2,3,1
;

SELECT a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (a>b-2.0 AND a<b+2.0)
   AND c>d
 ORDER BY 1,2,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0,
       a-b,
       abs(b-c),
       a+b*2.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,1,5,4,3
;

SELECT b-c,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR (a>b-2.0 AND a<b+2.0)
    OR d>e
 ORDER BY 1,3,2,4
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 1
;

SELECT (a+b+c+d+e)/5.0,
       c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,2
;

SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,2,1,6,4,5
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       a,
       d-e
  FROM t1
 ORDER BY 1,2,3,4,5
;

SELECT a-b,
       b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 2,1,3
;

SELECT e,
       a+b*2.0,
       abs(a),
       b
  FROM t1
 ORDER BY 4,2,1,3
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c,
       d-e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 5,3,2,1,4
;

SELECT abs(a),
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0,
       b-c
  FROM t1
 ORDER BY 6,1,3,5,4,2
;

SELECT d
  FROM t1
 ORDER BY 1
;

SELECT abs(b-c),
       a-b,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1,3
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       e,
       b-c
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND b>c
   AND c>d
 ORDER BY 2,1,3
;

SELECT c-d,
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       b-c
  FROM t1
 WHERE c>d
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
 ORDER BY 2,4,3,5,1
;

SELECT a+b*2.0+c*3.0+d*4.0,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
    OR (e>a AND e<b)
 ORDER BY 4,6,2,5,1,3
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 2,1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b
  FROM t1
 ORDER BY 1,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT (a+b+c+d+e)/5.0,
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
;

SELECT b,
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
;

SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 4,5,3,2,1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2.0 AND d+2.0
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
;

SELECT d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d>e
    OR a>b
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
;

SELECT a-b,
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
;

SELECT abs(a),
       a-b
  FROM t1
 ORDER BY 1,2
;

SELECT b-c,
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
;

SELECT c-d,
       a-b,
       b,
       b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c,
       a+b*2.0
  FROM t1
 ORDER BY 1,5,4,3,2,6,7
;

SELECT a+b*2.0+c*3.0,
       a,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(a)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR b>c
 ORDER BY 2,4,3,1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       abs(a),
       e,
       a+b*2.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,4,2,1,5
;

SELECT b,
       abs(b-c),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND (e>c OR e<d)
 ORDER BY 2,1,4,3
;

SELECT b-c,
       e,
       c-d,
       a-b
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2.0 AND d+2.0
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 4,1,2,3
;

SELECT a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       b
  FROM t1
 ORDER BY 1,2,3
;

SELECT c-d,
       (a+b+c+d+e)/5.0,
       abs(b-c),
       c,
       d
  FROM t1
 WHERE c>d
    OR a>b
 ORDER BY 4,2,3,1,5
;

SELECT a+b*2.0+c*3.0,
       d,
       abs(b-c)
  FROM t1
 ORDER BY 3,1,2
;

SELECT e,
       a+b*2.0+c*3.0,
       abs(b-c),
       d-e
  FROM t1
 ORDER BY 1,3,4,2
;

SELECT a,
       abs(a),
       d-e,
       e
  FROM t1
 ORDER BY 2,4,1,3
;

SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
 ORDER BY 1,2
;

SELECT b-c,
       a-b,
       a+b*2.0
  FROM t1
 ORDER BY 1,2,3
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c)
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND c>d
 ORDER BY 1,3,2
;

SELECT c-d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR d>e
 ORDER BY 1
;

SELECT a-b,
       d,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5.0,
       b,
       d-e
  FROM t1
 ORDER BY 1,5,3,7,4,6,2
;

SELECT a+b*2.0+c*3.0+d*4.0,
       a,
       c-d,
       abs(b-c),
       b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 4,3,2,5,1,6
;

SELECT abs(b-c),
       (a+b+c+d+e)/5.0,
       d,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c
  FROM t1
 ORDER BY 4,6,2,1,5,3
;

SELECT a,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e,
       a-b
  FROM t1
 ORDER BY 1,4,5,3,6,2
;

SELECT abs(a)
  FROM t1
 WHERE a>b
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
;

SELECT e,
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
;

SELECT (a+b+c+d+e)/5.0,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b-c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,4,5,1,2
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       c,
       a-b,
       abs(a)
  FROM t1
 ORDER BY 6,1,3,5,2,4
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       a,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 2,3,1,4
;

SELECT abs(a)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND d>e
   AND (e>a AND e<b)
 ORDER BY 1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (a+b+c+d+e)/5.0,
       c-d
  FROM t1
 ORDER BY 2,4,5,1,3
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 4,3,2,1
;

SELECT d,
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 3,2,4,5,7,1,6
;

SELECT b,
       abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c,
       a-b
  FROM t1
 ORDER BY 4,5,3,2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (e>a AND e<b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,2,1,4
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       d,
       e,
       a+b*2.0
  FROM t1
 ORDER BY 2,3,4,1,5
;

SELECT b,
       e,
       b-c
  FROM t1
 ORDER BY 2,1,3
;

SELECT a+b*2.0+c*3.0,
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
;

SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (e>c OR e<d)
   AND c>d
 ORDER BY 2,1
;

SELECT abs(b-c),
       a+b*2.0,
       d,
       b-c,
       a-b,
       d-e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND c>d
 ORDER BY 3,1,2,5,6,4
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b
  FROM t1
 ORDER BY 1,2
;

SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,2,1
;

SELECT abs(b-c),
       e
  FROM t1
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0,
       a-b,
       a+b*2.0
  FROM t1
 WHERE d>e
   AND c>d
   AND a>b
 ORDER BY 3,1,2,4
;

SELECT b,
       a+b*2.0+c*3.0,
       d-e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,1,2
;

SELECT a-b,
       a,
       d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,5,1,6,3,2
;

SELECT c-d,
       abs(a),
       a+b*2.0+c*3.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 4,2,5,1,3
;

SELECT a+b*2.0
  FROM t1
 WHERE a>b
    OR (e>c OR e<d)
 ORDER BY 1
;

SELECT c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR c BETWEEN b-2.0 AND d+2.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1,3
;

SELECT a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0,
       b,
       d
  FROM t1
 WHERE a>b
 ORDER BY 1,5,4,2,3
;

SELECT b,
       a+b*2.0
  FROM t1
 WHERE (e>a AND e<b)
    OR (a>b-2.0 AND a<b+2.0)
    OR (e>c OR e<d)
 ORDER BY 2,1
;

SELECT a+b*2.0,
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
;

SELECT e,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0,
       b,
       a+b*2.0+c*3.0
  FROM t1
 WHERE a>b
    OR (e>c OR e<d)
 ORDER BY 4,3,6,5,2,1
;

SELECT (a+b+c+d+e)/5.0,
       e,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 4,2,5,1,3
;

SELECT b-c,
       a,
       d-e
  FROM t1
 ORDER BY 1,3,2
;

SELECT a,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (e>a AND e<b)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 3,2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 1
;

SELECT a-b,
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
;

SELECT d,
       (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE b>c
 ORDER BY 1,3,2
;

SELECT abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       b-c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,1,2,4
;

SELECT a-b,
       c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 1,4,3,2,5
;

SELECT b-c,
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
;

SELECT a,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0,
       b
  FROM t1
 WHERE c>d
    OR d>e
 ORDER BY 2,5,1,3,4
;

SELECT a+b*2.0,
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
;

SELECT d,
       d-e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       e,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 6,5,1,7,2,3,4
;

SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 3,2,1,4
;

SELECT a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       abs(b-c)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,1,2
;

SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
;

SELECT a-b
  FROM t1
 WHERE c>d
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0,
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
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a,
       abs(a),
       c,
       d-e
  FROM t1
 ORDER BY 5,4,1,2,3
;

SELECT a+b*2.0+c*3.0+d*4.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a,
       d-e,
       e
  FROM t1
 ORDER BY 4,3,2,1,5,7,6
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
;

SELECT d,
       c
  FROM t1
 ORDER BY 2,1
;

SELECT d-e
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND a>b
 ORDER BY 1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
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
;

SELECT d-e,
       b-c,
       a-b,
       a+b*2.0+c*3.0+d*4.0,
       abs(a)
  FROM t1
 ORDER BY 1,5,3,4,2
;

SELECT d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,3,2
;

SELECT d,
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
;

SELECT b-c,
       a+b*2.0+c*3.0+d*4.0,
       c-d,
       a-b
  FROM t1
 ORDER BY 2,4,3,1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 4,3,2,1
;

SELECT (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR c BETWEEN b-2.0 AND d+2.0
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
;

SELECT b,
       b-c,
       a+b*2.0+c*3.0,
       abs(a),
       c-d,
       a,
       d-e
  FROM t1
 WHERE b>c
 ORDER BY 4,6,1,3,7,2,5
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR c>d
 ORDER BY 1
;

SELECT c
  FROM t1
 ORDER BY 1
;

SELECT a+b*2.0,
       a+b*2.0+c*3.0,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 4,1,2,3
;

SELECT (a+b+c+d+e)/5.0,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 6,4,5,1,2,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       a,
       abs(a)
  FROM t1
 ORDER BY 3,1,4,2
;

SELECT a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 3,2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND a>b
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 5,3,1,2,6,4
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
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
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2.0 AND d+2.0
   AND (e>c OR e<d)
 ORDER BY 1,2
;

SELECT a,
       b,
       abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR a>b
 ORDER BY 2,3,4,1
;

SELECT a+b*2.0+c*3.0,
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
;

SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 ORDER BY 3,2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0,
       a-b
  FROM t1
 WHERE a>b
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,1,2
;

SELECT b
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       a,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,5,3,1,4
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
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
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a-b,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 2,3,1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
 ORDER BY 2,3,1
;

SELECT d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 1,2
;

SELECT c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c,
       b
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,4,2,1
;

SELECT abs(b-c),
       c,
       b,
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE d>e
 ORDER BY 6,5,3,1,2,4
;

SELECT b-c
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (a+b+c+d+e)/5.0,
       abs(a),
       abs(b-c),
       c-d
  FROM t1
 ORDER BY 3,7,1,4,6,2,5
;

SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,1,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (e>c OR e<d)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND c>d
 ORDER BY 2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0,
       a,
       (a+b+c+d+e)/5.0,
       b
  FROM t1
 WHERE b>c
 ORDER BY 4,2,6,5,3,7,1
;

SELECT a+b*2.0,
       a-b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 1,3,4,2
;

SELECT e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (a+b+c+d+e)/5.0,
       d,
       d-e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
    OR (e>c OR e<d)
 ORDER BY 5,4,2,3,1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c,
       d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 4,5,2,1,3
;

SELECT c-d,
       abs(b-c),
       a+b*2.0
  FROM t1
 WHERE d>e
   AND a>b
 ORDER BY 1,2,3
;

SELECT e,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (e>a AND e<b)
    OR b>c
    OR (e>c OR e<d)
 ORDER BY 2,1
;

SELECT (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       b,
       a+b*2.0
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 5,1,2,3,4
;

SELECT e,
       a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 2,3,1
;

SELECT (a+b+c+d+e)/5.0,
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
;

SELECT c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 6,3,1,2,4,5
;

SELECT c-d,
       d-e,
       d,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 3,2,4,1
;

SELECT abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c
  FROM t1
 WHERE d>e
    OR a>b
 ORDER BY 4,3,2,1,5
;

SELECT (a+b+c+d+e)/5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(a),
       a+b*2.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,4,3,1
;

SELECT a,
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
;

SELECT abs(a),
       c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d-e
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,3,2,4
;

SELECT a+b*2.0+c*3.0,
       c-d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 1,6,5,3,4,2
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>c OR e<d)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
;

SELECT b,
       a,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 3,1,2
;

SELECT (a+b+c+d+e)/5.0,
       e,
       b
  FROM t1
 WHERE d>e
   AND (a>b-2.0 AND a<b+2.0)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,3,2
;

SELECT abs(a),
       a+b*2.0+c*3.0,
       (a+b+c+d+e)/5.0,
       b-c
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1,3,2,4
;

SELECT a-b
  FROM t1
 ORDER BY 1
;

SELECT a-b,
       d-e,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,3,1
;

SELECT c
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 2,4,3,1
;

SELECT abs(a)
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0
  FROM t1
 ORDER BY 1,3,4,2
;

SELECT c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       (a+b+c+d+e)/5.0,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
 ORDER BY 4,5,6,1,3,2
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c),
       c-d
  FROM t1
 ORDER BY 2,1,3,4,5
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
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
;

SELECT b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d
  FROM t1
 ORDER BY 3,2,1
;

SELECT c-d,
       a-b,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 3,2,4,5,1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c-d
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>a AND e<b)
 ORDER BY 2,1,3
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e
  FROM t1
 ORDER BY 3,1,2
;

SELECT c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c,
       a+b*2.0+c*3.0,
       d-e,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 3,4,6,5,1,2
;

SELECT a+b*2.0,
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
;

SELECT abs(b-c)
  FROM t1
 ORDER BY 1
;

SELECT b,
       c,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       e
  FROM t1
 ORDER BY 4,5,1,6,2,3
;

SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1,4,3,5,2
;

SELECT a,
       c
  FROM t1
 WHERE d>e
    OR b>c
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1,2
;

SELECT a+b*2.0+c*3.0+d*4.0,
       c-d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0,
       b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 5,2,4,1,6,3,7
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       b,
       abs(a),
       a+b*2.0,
       c-d
  FROM t1
 WHERE b>c
 ORDER BY 1,6,5,3,4,2
;

SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0,
       e,
       a+b*2.0,
       a+b*2.0+c*3.0,
       d,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 2,1,5,3,6,4,7
;

SELECT d-e,
       c-d,
       a
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND c>d
 ORDER BY 1,2,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       e,
       (a+b+c+d+e)/5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
    OR d>e
 ORDER BY 1,4,2,3
;

SELECT b,
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
;

SELECT (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0,
       a,
       a-b,
       d
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 6,1,2,3,5,4
;

SELECT c-d
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       abs(a),
       c-d
  FROM t1
 ORDER BY 2,3,4,1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       c
  FROM t1
 WHERE d>e
    OR (e>c OR e<d)
 ORDER BY 2,1
;

SELECT a,
       a+b*2.0+c*3.0+d*4.0,
       d
  FROM t1
 ORDER BY 1,3,2
;

SELECT b,
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
;

SELECT a-b,
       (a+b+c+d+e)/5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(a),
       d-e,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 6,4,5,3,1,2,7
;

SELECT d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       abs(a),
       a-b,
       b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE c>d
 ORDER BY 5,4,3,2,1,6
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE c>d
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
 ORDER BY 1
;

SELECT c-d,
       a+b*2.0+c*3.0,
       a
  FROM t1
 ORDER BY 1,2,3
;

SELECT (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c>d
   AND b>c
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
;

SELECT a,
       abs(a),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
    OR (e>c OR e<d)
 ORDER BY 2,1,3
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
;

SELECT abs(b-c)
  FROM t1
 WHERE c>d
   AND d NOT BETWEEN 110.0 AND 150.0
   AND a>b
 ORDER BY 1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a
  FROM t1
 ORDER BY 4,2,3,1
;

SELECT e,
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
;

SELECT abs(a),
       a-b,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,1,2
;

SELECT a-b,
       abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,2,4,1
;

SELECT b-c,
       c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE a>b
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,3
;

SELECT b,
       a+b*2.0+c*3.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,3,2,4
;

SELECT a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c>d
   AND b>c
 ORDER BY 2,1
;

SELECT c-d,
       b-c,
       abs(b-c),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1,3,4,2
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       a+b*2.0+c*3.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,4,2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d,
       c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,2,3,1,5,6
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
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
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(a),
       c,
       d
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,1,5,3,4
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c,
       e
  FROM t1
 WHERE d>e
 ORDER BY 2,5,1,4,3
;

SELECT e,
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
;

SELECT a+b*2.0+c*3.0+d*4.0,
       abs(b-c),
       a+b*2.0+c*3.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(a)
  FROM t1
 WHERE d>e
 ORDER BY 3,4,1,5,2
;

SELECT b-c,
       d-e,
       abs(a)
  FROM t1
 ORDER BY 1,3,2
;

SELECT e
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2.0 OR c>=d+2.0)
   AND (e>c OR e<d)
 ORDER BY 1
;

SELECT d
  FROM t1
 ORDER BY 1
;

SELECT a+b*2.0,
       abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0,
       c-d
  FROM t1
 ORDER BY 4,1,5,3,2
;

SELECT c-d,
       e,
       a+b*2.0,
       b,
       abs(a)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR (e>c OR e<d)
 ORDER BY 2,5,3,1,4
;

SELECT e,
       abs(a),
       c-d,
       a,
       c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,7,6,5,3,1,4
;

SELECT a+b*2.0+c*3.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
    OR (e>c OR e<d)
 ORDER BY 1
;

SELECT e,
       a-b,
       c,
       a
  FROM t1
 ORDER BY 1,4,2,3
;

SELECT a+b*2.0,
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
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0,
       a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 2,5,3,6,4,1
;

SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a-b
  FROM t1
 ORDER BY 1,3,4,2
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0,
       d-e
  FROM t1
 ORDER BY 3,1,2
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 4,3,2,1
;

SELECT abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,1,2
;

SELECT a-b,
       abs(a),
       a,
       e,
       b-c
  FROM t1
 ORDER BY 2,4,3,1,5
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR b>c
    OR d>e
 ORDER BY 3,2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b,
       d-e
  FROM t1
 ORDER BY 1,4,3,2
;

SELECT (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,2,1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 4,1,3,5,2
;

SELECT (a+b+c+d+e)/5.0,
       e,
       a-b
  FROM t1
 ORDER BY 3,1,2
;

SELECT b-c,
       c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR (e>c OR e<d)
 ORDER BY 1,2,3
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       d
  FROM t1
 WHERE b>c
 ORDER BY 6,2,5,4,3,1
;

SELECT d
  FROM t1
 ORDER BY 1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND (a>b-2.0 AND a<b+2.0)
   AND b>c
 ORDER BY 1,3,2
;

SELECT abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d,
       b-c,
       b,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE b>c
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 4,2,5,6,1,3
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT abs(b-c)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND c>d
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
;

SELECT a-b,
       d-e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT a+b*2.0+c*3.0,
       d-e,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,4,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND c>d
   AND d>e
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 4,2,1,3,5,6
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
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
;

SELECT a,
       c-d
  FROM t1
 ORDER BY 1,2
;

SELECT (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND a>b
 ORDER BY 1,2
;

SELECT abs(b-c)
  FROM t1
 WHERE b>c
 ORDER BY 1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a)
  FROM t1
 WHERE d>e
   AND b>c
 ORDER BY 2,1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
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
;

SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,3,2,4
;

SELECT a,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR c>d
 ORDER BY 1,2,3
;

SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
;

SELECT c-d,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0,
       d
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
 ORDER BY 3,1,4,5,2
;

SELECT c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (a>b-2.0 AND a<b+2.0)
   AND (e>c OR e<d)
 ORDER BY 4,1,3,2,5
;

SELECT c,
       a+b*2.0+c*3.0,
       c-d,
       abs(b-c),
       d-e
  FROM t1
 ORDER BY 3,4,1,2,5
;

SELECT (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 1,3,2
;

SELECT e,
       d-e
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR d>e
    OR (e>a AND e<b)
 ORDER BY 1,2
;

SELECT c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (a+b+c+d+e)/5.0,
       b-c,
       e,
       c-d
  FROM t1
 ORDER BY 5,4,6,2,1,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c,
       b
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR a>b
 ORDER BY 2,1,3
;

SELECT a+b*2.0+c*3.0,
       c,
       abs(a),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,4,2,5,1
;

SELECT a-b,
       c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c,
       e,
       c
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 3,5,1,4,6,2
;

SELECT c,
       a+b*2.0+c*3.0,
       c-d,
       abs(a),
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE d>e
    OR (c<=d-2.0 OR c>=d+2.0)
    OR (e>c OR e<d)
 ORDER BY 1,3,5,2,4
;

SELECT c,
       a+b*2.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c>d
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,2
;

SELECT a+b*2.0+c*3.0+d*4.0,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT c-d,
       a+b*2.0+c*3.0+d*4.0,
       d,
       a-b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 2,1,5,3,4
;

SELECT abs(b-c),
       a,
       a+b*2.0+c*3.0+d*4.0,
       c-d,
       c,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 6,3,1,4,5,2
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 1
;

SELECT b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e,
       a+b*2.0,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR c>d
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,5,3,2,4
;

SELECT abs(a),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b,
       b,
       a,
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,2,4,6,1,5
;

SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR a>b
 ORDER BY 2,1
;

SELECT a-b
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
;

SELECT abs(b-c)
  FROM t1
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0,
       c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a,
       (a+b+c+d+e)/5.0,
       a+b*2.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 3,2,5,7,1,6,4
;

SELECT d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b,
       c-d,
       (a+b+c+d+e)/5.0,
       b-c
  FROM t1
 ORDER BY 3,1,4,2,6,5
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       d
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,2,1,6,5,3
;

SELECT d,
       b,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1,3,2
;

SELECT a+b*2.0+c*3.0+d*4.0,
       d-e,
       c-d,
       abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>a AND e<b)
 ORDER BY 3,1,5,2,4
;

SELECT abs(a),
       c-d,
       abs(b-c),
       a+b*2.0+c*3.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,2,4,1
;

SELECT c,
       e,
       b,
       abs(a),
       d,
       a
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 5,3,2,1,4,6
;

SELECT a-b,
       a+b*2.0
  FROM t1
 WHERE b>c
    OR c>d
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c)
  FROM t1
 ORDER BY 2,1
;

SELECT d-e,
       a+b*2.0+c*3.0,
       a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,4,1,2
;

SELECT d,
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
;

SELECT abs(b-c),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 1,3,2
;

SELECT c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d,
       a,
       b
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR c>d
 ORDER BY 1,2,5,3,4
;

SELECT abs(b-c),
       c-d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND d>e
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,2,5,3,4
;

SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE d>e
    OR (a>b-2.0 AND a<b+2.0)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1,3
;

SELECT a-b,
       b-c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b
  FROM t1
 ORDER BY 3,1,2,5,4
;

SELECT a+b*2.0,
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
;

SELECT e,
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
;

SELECT a+b*2.0+c*3.0+d*4.0,
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
;

SELECT a+b*2.0+c*3.0,
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
;

SELECT a+b*2.0,
       abs(a),
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c
  FROM t1
 WHERE b>c
 ORDER BY 5,1,3,2,4
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
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
;

SELECT b-c,
       a+b*2.0,
       b
  FROM t1
 ORDER BY 2,3,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d
  FROM t1
 WHERE a>b
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,2
;

SELECT a
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1
;

SELECT abs(b-c),
       a+b*2.0+c*3.0+d*4.0,
       c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 4,1,3,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(b-c),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 1,2,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 1,2,3
;

SELECT d,
       a+b*2.0+c*3.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 2,1,3
;

SELECT e,
       abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 1,2,3
;

SELECT c
  FROM t1
 ORDER BY 1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d>e
   AND (c<=d-2.0 OR c>=d+2.0)
   AND (e>a AND e<b)
 ORDER BY 1
;

SELECT c,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE b>c
   AND (a>b-2.0 AND a<b+2.0)
   AND (e>a AND e<b)
 ORDER BY 2,1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(a)
  FROM t1
 WHERE c>d
   AND b>c
 ORDER BY 2,1
;

SELECT e,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       b-c,
       a+b*2.0+c*3.0+d*4.0,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,4,6,1,5,3
;

SELECT a
  FROM t1
 WHERE d>e
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE b>c
 ORDER BY 1
;

SELECT d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0,
       abs(b-c),
       e
  FROM t1
 ORDER BY 3,4,5,1,2
;

SELECT e,
       b-c,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c-d,
       abs(a)
  FROM t1
 WHERE b>c
 ORDER BY 3,6,2,1,5,4
;

SELECT b-c
  FROM t1
 ORDER BY 1
;

SELECT abs(b-c),
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a),
       c,
       a+b*2.0+c*3.0
  FROM t1
 WHERE a>b
 ORDER BY 3,4,6,1,2,5
;

SELECT d,
       abs(b-c)
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
 ORDER BY 2,1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE d>e
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,4,3,2
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a),
       b-c
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,3,2
;

SELECT c
  FROM t1
 WHERE b>c
 ORDER BY 1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
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
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 3,4,7,5,2,6,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT a+b*2.0+c*3.0+d*4.0,
       a-b,
       a+b*2.0,
       abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 1,5,4,2,6,3
;

SELECT a+b*2.0+c*3.0+d*4.0,
       abs(b-c),
       b-c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d>e
 ORDER BY 3,1,2,4
;

SELECT abs(b-c),
       b-c
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2
;

SELECT a-b,
       c,
       a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       e,
       b-c,
       d-e
  FROM t1
 ORDER BY 7,2,5,4,1,3,6
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a),
       b-c,
       a-b,
       a,
       c-d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,6,1,2,4,5
;

SELECT abs(a),
       d
  FROM t1
 WHERE (e>a AND e<b)
   AND a>b
   AND c>d
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

SELECT e,
       abs(a)
  FROM t1
 ORDER BY 2,1
;

SELECT abs(a),
       b
  FROM t1
 WHERE b>c
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

SELECT d-e,
       b,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE d>e
    OR d NOT BETWEEN 110.0 AND 150.0
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,4,2,1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2.0 AND d+2.0
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d,
       c-d,
       a
  FROM t1
 ORDER BY 3,4,2,5,1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 ORDER BY 1
;

SELECT c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND a>b
   AND (e>a AND e<b)
 ORDER BY 2,1
;

SELECT abs(a),
       abs(b-c),
       d,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,3,4,1
;

SELECT abs(a),
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
;

SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110.0 AND 150.0
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,2,1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       e,
       d-e,
       b,
       c,
       b-c
  FROM t1
 ORDER BY 3,5,6,2,4,1
;

SELECT a+b*2.0,
       b
  FROM t1
 ORDER BY 1,2
;

SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       d
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 4,3,2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       a+b*2.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       c-d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 4,2,6,1,7,3,5
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
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
;

SELECT b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(b-c)
  FROM t1
 ORDER BY 2,1,3
;

SELECT (a+b+c+d+e)/5.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND d>e
 ORDER BY 1
;

SELECT c,
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
;

SELECT a,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0,
       abs(a)
  FROM t1
 WHERE (e>c OR e<d)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1,3,4
;

SELECT d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
    OR a>b
 ORDER BY 1,3,2
;

SELECT a+b*2.0+c*3.0+d*4.0,
       d-e,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (a+b+c+d+e)/5.0,
       abs(b-c)
  FROM t1
 ORDER BY 2,4,3,1,5,6
;

SELECT a+b*2.0+c*3.0+d*4.0,
       a+b*2.0,
       e,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND (e>c OR e<d)
 ORDER BY 2,4,3,1
;

SELECT b-c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d
  FROM t1
 WHERE a>b
   AND (a>b-2.0 AND a<b+2.0)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT abs(a),
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
 ORDER BY 4,1,5,2,3
;

SELECT (a+b+c+d+e)/5.0,
       b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       c,
       d-e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c>d
 ORDER BY 2,5,3,4,1
;

SELECT abs(b-c),
       c-d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2
;

SELECT c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND (e>a AND e<b)
 ORDER BY 1,3,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       b,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 1,3,2,4
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 3,1,2
;

SELECT c-d,
       a,
       abs(b-c)
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110.0 AND 150.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,1,2
;

SELECT a,
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c>d
   AND (c<=d-2.0 OR c>=d+2.0)
   AND (e>c OR e<d)
 ORDER BY 3,2,1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       c-d,
       a
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND (e>c OR e<d)
   AND c>d
 ORDER BY 3,4,2,1
;

SELECT (a+b+c+d+e)/5.0,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
    OR c>d
 ORDER BY 2,1,3
;

SELECT a+b*2.0,
       a
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (e>c OR e<d)
    OR (e>a AND e<b)
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (e>a AND e<b)
 ORDER BY 1,3,5,4,2
;

SELECT d-e,
       b,
       a+b*2.0+c*3.0+d*4.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c
  FROM t1
 WHERE (e>c OR e<d)
   AND b>c
 ORDER BY 2,3,1,4,5
;

SELECT d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c),
       (a+b+c+d+e)/5.0,
       c-d
  FROM t1
 WHERE a>b
 ORDER BY 1,3,2,4,5
;

SELECT b,
       a,
       abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(a),
       a+b*2.0
  FROM t1
 ORDER BY 4,1,2,7,5,3,6
;

SELECT e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 2,1
;

SELECT b,
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
;

SELECT a+b*2.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,4,3,1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c>d
 ORDER BY 2,1,3
;

SELECT a+b*2.0+c*3.0,
       d,
       a,
       a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,3,5,1,4
;

SELECT c-d,
       abs(b-c),
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND (e>a AND e<b)
 ORDER BY 3,4,1,2
;

SELECT c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0,
       c-d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR (e>c OR e<d)
    OR (e>a AND e<b)
 ORDER BY 3,1,2,4
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1
;

SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       b-c,
       c,
       abs(b-c)
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,3,2,5,4
;

SELECT d-e,
       c-d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0+d*4.0,
       a
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,2,5,3,4
;

SELECT abs(b-c),
       a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d
  FROM t1
 ORDER BY 6,2,1,3,4,7,5
;

SELECT (a+b+c+d+e)/5.0,
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
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       e,
       abs(a)
  FROM t1
 ORDER BY 3,1,2
;

SELECT e
  FROM t1
 WHERE c>d
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0,
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
;

SELECT b-c,
       (a+b+c+d+e)/5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE b>c
 ORDER BY 1,2,3
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT e,
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
;

SELECT b-c,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2.0 OR c>=d+2.0)
   AND (e>c OR e<d)
 ORDER BY 3,4,2,1,5
;

SELECT a+b*2.0,
       abs(b-c),
       a+b*2.0+c*3.0,
       c,
       e,
       d
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
 ORDER BY 6,3,5,2,1,4
;

SELECT c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (a>b-2.0 AND a<b+2.0)
    OR c>d
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE a>b
 ORDER BY 1
;

SELECT (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0,
       d-e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR a>b
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,4,2,3
;

SELECT b-c
  FROM t1
 WHERE d>e
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       c
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1,2
;

SELECT b
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR b>c
 ORDER BY 1
;

SELECT e,
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
;

SELECT a+b*2.0+c*3.0,
       d-e,
       a-b
  FROM t1
 WHERE (e>a AND e<b)
    OR d>e
    OR (e>c OR e<d)
 ORDER BY 2,3,1
;

SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       (a+b+c+d+e)/5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 2,5,4,3,1
;

SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0
  FROM t1
 ORDER BY 1,2,3
;

SELECT a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0
  FROM t1
 WHERE b>c
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,3,1,4
;

SELECT abs(a),
       a-b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 4,2,1,3
;

SELECT c-d,
       b,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
 ORDER BY 4,3,2,1
;

SELECT d,
       c,
       a
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND d>e
   AND a>b
 ORDER BY 3,2,1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE b>c
 ORDER BY 1
;

SELECT c-d,
       b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 4,3,1,2
;

SELECT a+b*2.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0,
       a-b
  FROM t1
 WHERE a>b
   AND (a>b-2.0 AND a<b+2.0)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,4,1,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       b
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (e>a AND e<b)
 ORDER BY 6,3,1,5,4,2
;

SELECT a-b
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE c>d
    OR c BETWEEN b-2.0 AND d+2.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,3,1
;

SELECT d,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a-b,
       a+b*2.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 5,1,3,6,4,2
;

SELECT abs(a),
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR b>c
 ORDER BY 2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (e>c OR e<d)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND d>e
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR c>d
 ORDER BY 1,3,2,4
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c),
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0,
       d
  FROM t1
 ORDER BY 3,1,2,5,4,6
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       b,
       d-e,
       d,
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 6,3,2,1,4,5
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE a>b
    OR (e>a AND e<b)
 ORDER BY 1
;

SELECT d,
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
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1,3,6,2,5,4
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d,
       abs(b-c),
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND a>b
 ORDER BY 4,1,5,3,2
;

SELECT b,
       a,
       (a+b+c+d+e)/5.0,
       b-c,
       e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR a>b
 ORDER BY 3,1,2,5,4
;

SELECT b,
       d-e,
       (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,3,5,4,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       c,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,5,6,3,1,4
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       e,
       d,
       a-b
  FROM t1
 ORDER BY 2,3,4,5,6,1
;

SELECT a+b*2.0+c*3.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
;

SELECT b-c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
 ORDER BY 5,4,3,1,2
;

SELECT d-e,
       abs(a)
  FROM t1
 WHERE b>c
    OR a>b
 ORDER BY 1,2
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c>d
 ORDER BY 2,1,4,3
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 1
;

SELECT a,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1,2
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(a),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 5,3,1,2,4
;

SELECT c,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND c>d
 ORDER BY 1,2
;

SELECT a+b*2.0,
       a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110.0 AND 150.0
   AND d>e
 ORDER BY 3,1,2
;

SELECT c,
       d-e,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR d NOT BETWEEN 110.0 AND 150.0
    OR (e>c OR e<d)
 ORDER BY 3,1,2
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c)
  FROM t1
 WHERE d>e
 ORDER BY 2,3,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a,
       (a+b+c+d+e)/5.0,
       c,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,5,1,4,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,1
;

SELECT a+b*2.0,
       abs(b-c),
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 3,2,1,4
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0+d*4.0,
       e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a,
       (a+b+c+d+e)/5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 6,7,4,1,5,3,2
;

SELECT abs(a),
       d-e
  FROM t1
 ORDER BY 1,2
;

SELECT abs(b-c),
       b-c,
       a+b*2.0+c*3.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a
  FROM t1
 ORDER BY 3,4,2,1,5
;

SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE b>c
   AND a>b
 ORDER BY 1,2
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(b-c)
  FROM t1
 WHERE b>c
 ORDER BY 6,5,3,2,4,1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a-b
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR d>e
 ORDER BY 1,2
;

SELECT a-b
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0,
       d,
       b-c,
       a,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0
  FROM t1
 ORDER BY 4,3,6,1,2,5
;

SELECT a-b,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR b>c
 ORDER BY 1,4,2,5,6,3
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
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
;

SELECT c,
       abs(a),
       d,
       b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a
  FROM t1
 ORDER BY 1,4,3,5,6,7,2
;

SELECT d,
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
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,1,2
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e
  FROM t1
 WHERE b>c
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
 ORDER BY 1,2
;

SELECT abs(a),
       a-b
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND c BETWEEN b-2.0 AND d+2.0
   AND (e>a AND e<b)
 ORDER BY 1,2
;

SELECT abs(a),
       c-d
  FROM t1
 WHERE d>e
    OR b>c
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
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
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2.0 AND d+2.0
    OR (e>c OR e<d)
 ORDER BY 2,1
;

SELECT b,
       a+b*2.0+c*3.0,
       abs(b-c),
       a-b
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,1,2,4
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0,
       d,
       b
  FROM t1
 ORDER BY 2,1,3,4
;

SELECT c-d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2
;

SELECT a+b*2.0+c*3.0,
       a-b,
       c-d
  FROM t1
 WHERE a>b
 ORDER BY 1,3,2
;

SELECT d,
       a+b*2.0+c*3.0,
       a+b*2.0,
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (e>a AND e<b)
   AND d>e
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,3,5,4
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0,
       c,
       d-e,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d,
       a-b
  FROM t1
 ORDER BY 3,1,7,6,4,2,5
;

SELECT c-d,
       e,
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 4,1,3,2
;

SELECT a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a
  FROM t1
 ORDER BY 1,2,3
;

SELECT e,
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
;

SELECT c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND b>c
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,2
;

SELECT b-c,
       c
  FROM t1
 ORDER BY 1,2
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
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
;

SELECT d
  FROM t1
 WHERE d>e
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a-b
  FROM t1
 ORDER BY 4,3,2,1
;

SELECT abs(a),
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
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       b-c,
       abs(a)
  FROM t1
 ORDER BY 4,1,3,2
;

SELECT d,
       abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a
  FROM t1
 WHERE a>b
 ORDER BY 1,3,4,2
;

SELECT abs(a),
       a+b*2.0+c*3.0,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 3,1,2
;

SELECT c-d,
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
;

SELECT d,
       a+b*2.0
  FROM t1
 WHERE b>c
    OR c BETWEEN b-2.0 AND d+2.0
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2.0 AND d+2.0
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
;

SELECT b
  FROM t1
 WHERE d>e
    OR (e>a AND e<b)
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
;

SELECT (a+b+c+d+e)/5.0,
       b-c,
       a
  FROM t1
 ORDER BY 3,1,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a)
  FROM t1
 ORDER BY 1,2
;

SELECT abs(a),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (e>c OR e<d)
 ORDER BY 3,2,4,1
;

SELECT a+b*2.0+c*3.0+d*4.0,
       d-e,
       a+b*2.0+c*3.0,
       abs(b-c),
       d,
       b-c,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,7,1,6,5,2,4
;

SELECT c-d,
       b-c,
       abs(b-c)
  FROM t1
 WHERE d>e
 ORDER BY 1,2,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d
  FROM t1
 WHERE a>b
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 5,3,1,4,2
;

SELECT b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b
  FROM t1
 ORDER BY 2,6,3,1,4,5
;

SELECT e,
       a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE a>b
 ORDER BY 1,2,3
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       abs(b-c)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 2,1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a,
       a+b*2.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,1,3
;

SELECT b
  FROM t1
 WHERE a>b
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>c OR e<d)
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0,
       c-d,
       d,
       a
  FROM t1
 ORDER BY 3,2,1,4
;

SELECT b-c,
       a+b*2.0+c*3.0+d*4.0,
       c-d,
       a,
       d-e,
       c
  FROM t1
 WHERE d>e
 ORDER BY 3,4,1,5,6,2
;

SELECT c-d,
       c,
       abs(a),
       a+b*2.0+c*3.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (e>c OR e<d)
 ORDER BY 1,4,2,3
;

SELECT d-e,
       abs(b-c),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (e>a AND e<b)
 ORDER BY 2,3,1
;

SELECT b-c,
       d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,3,1,4
;

SELECT abs(a),
       a,
       c,
       d-e,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 1,6,3,5,4,2
;

SELECT a-b,
       c,
       a+b*2.0+c*3.0,
       b,
       d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d
  FROM t1
 ORDER BY 4,3,5,6,2,1,7
;

SELECT a,
       d-e,
       c,
       a+b*2.0,
       e
  FROM t1
 WHERE a>b
    OR c>d
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,3,5,4,1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
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
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 2,3,1,5,4
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 3,5,4,6,2,1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
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
;

SELECT b,
       a-b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       c,
       c-d
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 5,3,4,6,1,2
;

SELECT a-b,
       b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d
  FROM t1
 ORDER BY 5,2,1,4,3,6
;

SELECT abs(b-c),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (e>a AND e<b)
   AND d>e
 ORDER BY 2,1,4,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
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
;

SELECT d,
       (a+b+c+d+e)/5.0,
       d-e,
       a,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND (c<=d-2.0 OR c>=d+2.0)
   AND a>b
 ORDER BY 5,2,1,4,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e,
       c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND c>d
 ORDER BY 1,2,3,4
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0,
       b
  FROM t1
 ORDER BY 3,1,2
;

SELECT a
  FROM t1
 WHERE d>e
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 1,3,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a-b
  FROM t1
 ORDER BY 3,1,2
;

SELECT a+b*2.0,
       b-c,
       a+b*2.0+c*3.0
  FROM t1
 WHERE (e>c OR e<d)
 ORDER BY 2,3,1
;

SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0,
       abs(b-c),
       a+b*2.0,
       d-e
  FROM t1
 ORDER BY 4,3,1,7,2,5,6
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       abs(b-c),
       e
  FROM t1
 ORDER BY 2,3,1,4
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
;

SELECT a+b*2.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

SELECT (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 4,3,1,2
;

SELECT b,
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
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       e
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 4,3,2,1
;

SELECT a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND d>e
   AND b>c
 ORDER BY 2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (a+b+c+d+e)/5.0,
       c-d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d,
       a+b*2.0+c*3.0+d*4.0,
       abs(a)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,5,1,3,7,6,4
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a-b,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE b>c
   AND a>b
 ORDER BY 1,3,2
;

SELECT b,
       d,
       b-c
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 3,1,2
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
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
;

SELECT (a+b+c+d+e)/5.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
;

SELECT d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0,
       abs(a),
       d-e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,5,4,3,1
;

SELECT b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0,
       abs(b-c),
       a+b*2.0+c*3.0,
       c-d,
       a
  FROM t1
 ORDER BY 1,4,2,7,3,6,5
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE a>b
   AND b>c
   AND (e>c OR e<d)
 ORDER BY 2,1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d-e
  FROM t1
 ORDER BY 3,1,4,2
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 1,2,3
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE b>c
    OR d NOT BETWEEN 110.0 AND 150.0
    OR (e>a AND e<b)
 ORDER BY 4,3,1,2
;

SELECT c
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
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
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 1
;

SELECT c-d
  FROM t1
 WHERE d>e
   AND e+d BETWEEN a+b-10.0 AND c+130.0
   AND a>b
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0,
       d,
       e,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE d>e
   AND c BETWEEN b-2.0 AND d+2.0
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1,3,4
;

SELECT d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e,
       a+b*2.0+c*3.0+d*4.0,
       a,
       a+b*2.0+c*3.0,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE b>c
 ORDER BY 7,4,2,6,5,3,1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       a,
       (a+b+c+d+e)/5.0,
       c,
       a+b*2.0
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 6,1,4,2,5,3
;

SELECT a+b*2.0,
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
;

SELECT c
  FROM t1
 WHERE d>e
   AND (a>b-2.0 AND a<b+2.0)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c,
       a+b*2.0+c*3.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
;

SELECT a-b
  FROM t1
 WHERE (e>c OR e<d)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (e>a AND e<b)
 ORDER BY 1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
   AND (e>c OR e<d)
 ORDER BY 1,2
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
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
;

SELECT e,
       c-d
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR a>b
 ORDER BY 2,1
;

SELECT abs(b-c),
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
;

SELECT abs(a),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND c BETWEEN b-2.0 AND d+2.0
   AND d>e
 ORDER BY 2,1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2,3
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b,
       a+b*2.0
  FROM t1
 ORDER BY 2,3,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (e>c OR e<d)
    OR a>b
 ORDER BY 1
;

SELECT c-d,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,3,1,5,4
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a-b,
       b-c,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,4,3,2
;

SELECT d-e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0
  FROM t1
 ORDER BY 6,2,5,1,4,7,3
;

SELECT (a+b+c+d+e)/5.0
  FROM t1
 WHERE b>c
 ORDER BY 1
;

SELECT b-c,
       a,
       a+b*2.0+c*3.0+d*4.0,
       d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND c>d
   AND d>e
 ORDER BY 4,2,3,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d-e,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       a+b*2.0,
       abs(b-c),
       d
  FROM t1
 WHERE d>e
 ORDER BY 3,4,2,6,5,7,1
;

SELECT a,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (a+b+c+d+e)/5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,2,3,6,1,5
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       e,
       a,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       b-c
  FROM t1
 ORDER BY 6,4,3,1,2,5
;

SELECT c-d,
       d,
       e
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1,2,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0,
       c,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       d-e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR c>d
    OR b>c
 ORDER BY 4,2,3,5,1
;

SELECT b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 3,5,1,2,4
;

SELECT a,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       c-d,
       b
  FROM t1
 ORDER BY 4,3,2,1
;

SELECT d,
       e,
       a+b*2.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0,
       abs(a)
  FROM t1
 ORDER BY 1,2,7,6,4,3,5
;

SELECT b,
       e,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 2,3,1,4
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
 ORDER BY 3,1,2
;

SELECT a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR b>c
 ORDER BY 3,1,2,4
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       a+b*2.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND a>b
 ORDER BY 3,4,2,1
;

SELECT e,
       d-e,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 2,3,1
;

SELECT a-b,
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
;

SELECT a+b*2.0+c*3.0,
       c-d,
       d-e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR (e>a AND e<b)
 ORDER BY 2,3,1
;

SELECT (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0,
       e,
       d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 6,4,7,5,2,3,1
;

SELECT a+b*2.0+c*3.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 3,4,1,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE (e>c OR e<d)
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
;

SELECT (a+b+c+d+e)/5.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR (a>b-2.0 AND a<b+2.0)
    OR d>e
 ORDER BY 1
;

SELECT abs(b-c),
       a+b*2.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 ORDER BY 2,3,1,4,5
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE a>b
 ORDER BY 2,4,1,3
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       d,
       a-b,
       abs(b-c)
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,5,3,2,4
;

SELECT a+b*2.0+c*3.0+d*4.0,
       a,
       a+b*2.0,
       a-b,
       abs(a),
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 2,3,1,6,4,5
;

SELECT d-e,
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
;

SELECT d-e,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c,
       a+b*2.0+c*3.0,
       b,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE b>c
 ORDER BY 1,4,6,3,5,2
;

SELECT (a+b+c+d+e)/5.0,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d>e
 ORDER BY 1,6,2,5,4,3
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,4,3,1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE c>d
 ORDER BY 2,1
;

SELECT (a+b+c+d+e)/5.0,
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
;

SELECT abs(a),
       c,
       a+b*2.0,
       a+b*2.0+c*3.0+d*4.0,
       d,
       a
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 5,3,4,1,6,2
;

SELECT b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>a AND e<b)
   AND c BETWEEN b-2.0 AND d+2.0
   AND d>e
 ORDER BY 1,2
;

SELECT a-b,
       c-d,
       b
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 3,1,2
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
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
;

SELECT c-d,
       a-b,
       b
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,1,2
;

SELECT b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e,
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,4,2,5,1
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d-e
  FROM t1
 WHERE d>e
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,1
;

SELECT e,
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
;

SELECT d-e
  FROM t1
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (e>a AND e<b)
   AND (a>b-2.0 AND a<b+2.0)
 ORDER BY 1
;

SELECT a+b*2.0,
       e
  FROM t1
 ORDER BY 2,1
;

SELECT (a+b+c+d+e)/5.0,
       a,
       b-c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE c>d
   AND (e>c OR e<d)
 ORDER BY 3,1,2,5,4
;

SELECT a+b*2.0+c*3.0+d*4.0,
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
;

SELECT (a+b+c+d+e)/5.0,
       a+b*2.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b-c,
       d-e,
       b
  FROM t1
 ORDER BY 6,1,4,3,5,2
;

SELECT d,
       c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a,
       c-d,
       a-b
  FROM t1
 ORDER BY 6,4,3,2,5,1
;

SELECT a,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       abs(b-c),
       a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
 ORDER BY 2,1,3,4
;

SELECT a+b*2.0,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 1,2
;

SELECT abs(b-c),
       a-b,
       a+b*2.0
  FROM t1
 WHERE (e>c OR e<d)
    OR d>e
 ORDER BY 3,2,1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a+b*2.0+c*3.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 ORDER BY 3,5,1,4,2,6
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       abs(a)
  FROM t1
 ORDER BY 1,2
;

SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE d>e
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 4,5,3,1,2
;

SELECT a-b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE a>b
   AND (e>a AND e<b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1,2,3
;

SELECT e,
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
;

SELECT a+b*2.0+c*3.0+d*4.0,
       c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c
  FROM t1
 WHERE c>d
 ORDER BY 1,3,4,2
;

SELECT b,
       abs(b-c),
       d,
       a-b,
       d-e,
       c
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,5,1,4,6,3
;

SELECT b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a,
       d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
 ORDER BY 4,2,3,1
;

SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
;

SELECT a-b,
       a+b*2.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
    OR (c<=d-2.0 OR c>=d+2.0)
    OR a>b
 ORDER BY 1,2
;

SELECT a,
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
;

SELECT b,
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
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       c-d
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,1
;

SELECT abs(b-c),
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
;

SELECT c-d,
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
;

SELECT b,
       a-b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       d
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND c>d
 ORDER BY 1,2,3,5,4
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b,
       a+b*2.0+c*3.0,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 4,3,5,2,7,1,6
;

SELECT d-e,
       b,
       abs(b-c),
       c,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 4,6,7,2,5,3,1
;

SELECT a+b*2.0,
       c,
       abs(a),
       b,
       d-e
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR c>d
 ORDER BY 5,2,3,1,4
;

SELECT a+b*2.0
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND b>c
 ORDER BY 1
;

SELECT abs(b-c),
       d-e,
       a+b*2.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
    OR c>d
 ORDER BY 4,2,3,1
;

SELECT b-c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1,2,3,4
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,3,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 1,2
;

SELECT a+b*2.0+c*3.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d-e,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a
  FROM t1
 ORDER BY 6,4,5,3,2,1
;

SELECT d-e,
       a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 2,1,3
;

SELECT a+b*2.0+c*3.0,
       e,
       d-e
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND c BETWEEN b-2.0 AND d+2.0
   AND d>e
 ORDER BY 3,2,1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d,
       e
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 2,3,1
;

SELECT a+b*2.0+c*3.0,
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
   AND (e>c OR e<d)
 ORDER BY 2,1
;

SELECT a,
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
;

SELECT a-b,
       (a+b+c+d+e)/5.0,
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d-e,
       a,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 1,5,3,6,4,2
;

SELECT a+b*2.0,
       d,
       abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE b>c
    OR (c<=d-2.0 OR c>=d+2.0)
    OR (e>c OR e<d)
 ORDER BY 2,3,1,4
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       abs(b-c),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,3,2,1
;

SELECT a-b,
       c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 3,1,2
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c),
       abs(a)
  FROM t1
 WHERE (e>c OR e<d)
   AND d>e
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 3,1,2
;

SELECT c,
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
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 WHERE a>b
   AND c>d
   AND d>e
 ORDER BY 1
;

SELECT d,
       c
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND d>e
 ORDER BY 1,2
;

SELECT a,
       c-d,
       c,
       (a+b+c+d+e)/5.0,
       abs(b-c),
       b
  FROM t1
 ORDER BY 1,2,5,4,6,3
;

SELECT a+b*2.0+c*3.0+d*4.0,
       d,
       abs(a),
       c-d,
       a
  FROM t1
 ORDER BY 1,3,4,2,5
;

SELECT c,
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
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       d,
       b-c,
       c
  FROM t1
 ORDER BY 3,1,2,4
;

SELECT c
  FROM t1
 WHERE b>c
    OR (e>c OR e<d)
 ORDER BY 1
;

SELECT a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       e
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2.0 OR c>=d+2.0)
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 3,1,2
;

SELECT a+b*2.0+c*3.0,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d-e,
       c,
       abs(a)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 4,1,3,5,2
;

SELECT (a+b+c+d+e)/5.0,
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
;

SELECT b,
       c
  FROM t1
 ORDER BY 2,1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       a-b,
       b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       e
  FROM t1
 ORDER BY 1,5,4,3,2
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0,
       e,
       d,
       b-c,
       a
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (a>b-2.0 AND a<b+2.0)
 ORDER BY 2,4,5,6,1,3
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       d-e
  FROM t1
 ORDER BY 1,3,2
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       e,
       d,
       b-c,
       (a+b+c+d+e)/5.0,
       abs(b-c),
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 4,3,5,1,7,2,6
;

SELECT (a+b+c+d+e)/5.0,
       c-d,
       a+b*2.0+c*3.0+d*4.0,
       d-e,
       b-c,
       e,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 ORDER BY 7,1,2,4,6,5,3
;

SELECT c,
       b
  FROM t1
 WHERE a>b
    OR b>c
 ORDER BY 1,2
;

SELECT b-c,
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
;

SELECT a+b*2.0+c*3.0
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c),
       abs(a),
       b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND d>e
 ORDER BY 1,5,3,2,4
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       d-e,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1,3,4,2
;

SELECT CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       (a+b+c+d+e)/5.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
    OR d>e
    OR a>b
 ORDER BY 2,3,1,4
;

SELECT b,
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
;

SELECT e
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2.0 OR c>=d+2.0)
    OR (e>a AND e<b)
 ORDER BY 1
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
   AND (e>c OR e<d)
 ORDER BY 1
;

SELECT abs(a)
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR d>e
    OR (e>c OR e<d)
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       c,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       c-d,
       a-b,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 4,2,3,6,1,5
;

SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR d NOT BETWEEN 110.0 AND 150.0
 ORDER BY 1
;

SELECT (a+b+c+d+e)/5.0,
       d,
       a+b*2.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       c-d,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 6,7,2,4,1,5,3
;

SELECT d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       (a+b+c+d+e)/5.0,
       b,
       a,
       a+b*2.0,
       d-e
  FROM t1
 ORDER BY 5,1,6,7,2,3,4
;

SELECT c,
       a-b,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 ORDER BY 1,2,3
;

SELECT abs(a),
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
;

SELECT e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       b,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 4,2,1,6,5,3
;

SELECT b-c,
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
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(a),
       a+b*2.0,
       a,
       d-e
  FROM t1
 WHERE (e>c OR e<d)
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 4,2,3,5,1
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       a-b
  FROM t1
 ORDER BY 1,2,3
;

SELECT (a+b+c+d+e)/5.0,
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
;

SELECT d,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 ORDER BY 1,2
;

SELECT abs(a),
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
;

SELECT abs(a),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE a>b
    OR b>c
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,1
;

SELECT a-b
  FROM t1
 WHERE d NOT BETWEEN 110.0 AND 150.0
   AND (e>c OR e<d)
   AND a>b
 ORDER BY 1
;

SELECT a,
       (a+b+c+d+e)/5.0,
       c
  FROM t1
 WHERE a>b
    OR c BETWEEN b-2.0 AND d+2.0
    OR (e>c OR e<d)
 ORDER BY 1,2,3
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
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
;

SELECT a+b*2.0
  FROM t1
 WHERE a>b
 ORDER BY 1
;

SELECT (a+b+c+d+e)/5.0,
       d-e
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 2,1
;

SELECT d
  FROM t1
 WHERE e+d BETWEEN a+b-10.0 AND c+130.0
    OR (e>a AND e<b)
 ORDER BY 1
;

SELECT d-e,
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
;

SELECT a+b*2.0+c*3.0+d*4.0,
       d,
       c-d,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 6,3,7,2,1,5,4
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND (e>a AND e<b)
   AND e+d BETWEEN a+b-10.0 AND c+130.0
 ORDER BY 1
;

SELECT a+b*2.0,
       a+b*2.0+c*3.0
  FROM t1
 WHERE b>c
 ORDER BY 1,2
;

SELECT b-c,
       a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
   AND EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 2,1
;

SELECT e,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END
  FROM t1
 ORDER BY 2,3,4,1
;

SELECT abs(b-c)
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
;

SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       abs(a),
       (a+b+c+d+e)/5.0,
       abs(b-c)
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 6,5,4,1,3,2
;

SELECT c,
       a-b,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0,
       d
  FROM t1
 WHERE (a>b-2.0 AND a<b+2.0)
    OR a>b
 ORDER BY 1,3,4,5,2
;

SELECT d-e,
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
;

SELECT a+b*2.0+c*3.0+d*4.0
  FROM t1
 WHERE (e>c OR e<d)
   AND c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1
;

SELECT b,
       e,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       c-d,
       d-e
  FROM t1
 WHERE d>e
   AND (e>c OR e<d)
 ORDER BY 2,1,3,4,5
;

SELECT d-e,
       c,
       d
  FROM t1
 ORDER BY 3,2,1
;

SELECT d-e,
       c
  FROM t1
 WHERE (e>a AND e<b)
 ORDER BY 1,2
;

SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       b-c,
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       abs(b-c),
       CASE a+1.0 WHEN b THEN 111.0 WHEN c THEN 222.0
        WHEN d THEN 333.0  WHEN e THEN 444.0 ELSE 555.0 END
  FROM t1
 WHERE d>e
    OR EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1,3,2,5,4
;

SELECT a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
    OR c>d
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 2,3,1
;

SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0
  FROM t1
 WHERE (e>c OR e<d)
    OR (e>a AND e<b)
 ORDER BY 1,2
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
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
;

SELECT a+b*2.0
  FROM t1
 WHERE c>d
    OR e+d BETWEEN a+b-10.0 AND c+130.0
    OR (c<=d-2.0 OR c>=d+2.0)
 ORDER BY 1
;

SELECT c,
       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
  FROM t1
 WHERE b>c
   AND (e>a AND e<b)
   AND d>e
 ORDER BY 1,2
;

SELECT a-b,
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
;

SELECT a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       e
  FROM t1
 ORDER BY 2,3,4,1
;

SELECT c,
       a+b*2.0+c*3.0+d*4.0,
       a
  FROM t1
 WHERE (e>a AND e<b)
    OR c BETWEEN b-2.0 AND d+2.0
 ORDER BY 1,2,3
;

SELECT (a+b+c+d+e)/5.0,
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
;

SELECT d-e,
       a+b*2.0+c*3.0
  FROM t1
 ORDER BY 2,1
;

SELECT CASE WHEN a<b-3.0 THEN 111.0 WHEN a<=b THEN 222.0
        WHEN a<b+3.0 THEN 333.0 ELSE 444.0 END,
       a
  FROM t1
 ORDER BY 1,2
;

SELECT abs(b-c),
       a+b*2.0+c*3.0+d*4.0+e*5.0,
       b,
       d-e
  FROM t1
 WHERE (c<=d-2.0 OR c>=d+2.0)
    OR d>e
 ORDER BY 3,1,2,4
;

SELECT c-d,
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
;

SELECT b,
       a-b,
       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2.0 ELSE b*10.0 END,
       a+b*2.0+c*3.0,
       a+b*2.0+c*3.0+d*4.0+e*5.0
  FROM t1
 WHERE c BETWEEN b-2.0 AND d+2.0
 ORDER BY 5,2,4,1,3,6
;

SELECT a,
       a+b*2.0+c*3.0,
       (a+b+c+d+e)/5.0
  FROM t1
 ORDER BY 2,3,1
;

SELECT c
  FROM t1
 WHERE EXISTS(SELECT 1.0 FROM t1 AS x WHERE x.b<t1.b)
 ORDER BY 1
;

