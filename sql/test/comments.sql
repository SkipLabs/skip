CREATE TABLE t1(a INTEGER, b INTEGER, c INTEGER, d INTEGER, e INTEGER)
;

INSERT INTO t1(e,c,b,d,a) VALUES(103,102,100,101,104)
;

-- a ttest to see

/* INSERT INTO t1(a,c,d,e,b) VALUES(107,106,108,109,105)
; */

select * from t1 /*, t2 */;

