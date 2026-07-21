CREATE TABLE t1(i INTEGER, t TEXT, v INTEGER);

INSERT INTO t1 VALUES (local_sequence_number(), id(), 1);
INSERT INTO t1 VALUES (local_sequence_number(), id(), 2);
INSERT INTO t1 VALUES (local_sequence_number(), id(), 3);
INSERT INTO t1 SELECT local_sequence_number(), id(), v FROM t1;
SELECT i FROM t1;
SELECT t FROM t1;
