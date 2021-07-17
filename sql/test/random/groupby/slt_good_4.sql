CREATE TABLE tab0(col0 INTEGER, col1 INTEGER, col2 INTEGER)
;

CREATE TABLE tab1(col0 INTEGER, col1 INTEGER, col2 INTEGER)
;

CREATE TABLE tab2(col0 INTEGER, col1 INTEGER, col2 INTEGER)
;

INSERT INTO tab0 VALUES(83,0,38)
;

INSERT INTO tab0 VALUES(26,0,79)
;

INSERT INTO tab0 VALUES(43,81,24)
;

INSERT INTO tab1 VALUES(22,6,8)
;

INSERT INTO tab1 VALUES(28,57,45)
;

INSERT INTO tab1 VALUES(82,44,71)
;

INSERT INTO tab2 VALUES(15,61,87)
;

INSERT INTO tab2 VALUES(91,59,79)
;

INSERT INTO tab2 VALUES(92,41,58)
;

SELECT - 31 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT ALL - - ( - tab0.col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col2, cor0.col0

;

SELECT ALL - 3 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 67 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - tab0.col0 * + tab0.col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT - cor0.col0 * - cor0.col0 AS col1 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL - 31 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL cor0.col1 + col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + 41 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 50 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT + 42 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 38 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING ( NULL ) IS NOT NULL
;

SELECT ALL cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING ( NULL ) IS NULL
;

SELECT ALL - + tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 + - 89 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 26 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + 91 + ( - cor0.col2 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 4 FROM tab1 GROUP BY col1

;

SELECT DISTINCT + tab0.col2 * + tab0.col2 - + COALESCE ( + 64, col2 ) AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL col1 * - 98 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 44 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + - tab2.col0 * - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 18 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 86 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT NULLIF ( + 10, cor0.col2 ) AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL - 74 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor1.col1

;

SELECT ALL cor0.col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT + 6 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + cor0.col0 - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 59 * tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 81 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + - tab2.col0 * tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 75 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 44 * + 98 AS col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT 51 * col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 60 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT - tab0.col0 * 70 + tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + NULLIF ( - cor0.col2, - 0 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL + cor1.col0 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor1.col0

;

SELECT cor0.col2 + col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - 89 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1, cor1.col2

;

SELECT + 25 FROM tab0 GROUP BY tab0.col1

;

SELECT - 51 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 11 FROM tab2 GROUP BY col0

;

SELECT ALL cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + - 65 + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - - 15 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 1 * cor0.col1 - cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + 69 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 6 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - - 39 + - tab1.col1 FROM tab1 GROUP BY col1

;

SELECT + cor0.col2 - - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL ( tab1.col2 ) FROM tab1 GROUP BY col2

;

SELECT DISTINCT 92 - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 25 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 44 + + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 * 31 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - cor0.col2 + - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 90 - tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col0 AS col2 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT - 85 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + 13 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - ( - cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + col1 + col2 AS col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col1, cor0.col0

;

SELECT + 81 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col1 + col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, col2

;

SELECT + cor0.col1 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT - col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 92 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - cor0.col0 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL - 67 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - + 69 FROM tab1 GROUP BY tab1.col1

;

SELECT + 29 AS col2 FROM tab1 GROUP BY col0

;

SELECT ALL + 41 * 15 + + 1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT cor0.col1 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT - 22 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + cor0.col1 + col2 * - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 31 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 63 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 95 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + + 3 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT - + 92 * - tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 13 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 54 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 41 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 88 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT ALL - 21 AS col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - tab0.col0 * + 91 + + 85 * 67 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ( 32 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - ( + tab0.col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - col1 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - - 8 FROM tab1 GROUP BY col1

;

SELECT + 64 FROM tab1 GROUP BY tab1.col0

;

SELECT 61 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab1.col0 + 56 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - ( 41 ) FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL - + NULLIF ( tab2.col1, tab2.col1 ) + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 75 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0, cor1.col2

;

SELECT ALL cor0.col1 * 89 + + 94 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT + - 67 + - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 50 + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col0

;

SELECT - 55 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 24 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT + 35 + 33 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT ALL + tab1.col1 * 35 FROM tab1 GROUP BY tab1.col1

;

SELECT 2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + tab0.col1 * - 67 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + tab1.col0 + ( tab1.col0 + - col0 ) AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 30 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT col2 * + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 83 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + 32 FROM tab2 GROUP BY col1

;

SELECT 1 + cor0.col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + 52 * + cor0.col1 - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL - 67 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL ( - cor0.col2 ) AS col2 FROM tab2 cor0 GROUP BY col0, cor0.col2, col0

;

SELECT + cor0.col0 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 23 * - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + tab1.col1 - 96 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT 44 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT tab0.col2 * - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT tab0.col0 FROM tab0 GROUP BY tab0.col0 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT cor0.col2 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col2 + cor0.col2 * cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + col0 * col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - - 91 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + cor0.col0 * 33 + + 60 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 98 + col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT + + tab0.col0 + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT 76 + + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + - cor0.col0 FROM tab2, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 FROM tab1 cor0 GROUP BY cor0.col0, col2

;

SELECT + 51 * col2 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT ALL col2 * - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col0 + col0 * + 41 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT ALL + + tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT cor0.col0 + + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0 HAVING ( NULL ) IS NULL
;

SELECT + - 83 + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 83 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT col1 + - cor0.col1 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 + 13 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 11 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 12 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 75 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 40 FROM tab0 GROUP BY tab0.col1

;

SELECT tab2.col0 FROM tab2, tab0 AS cor0 GROUP BY tab2.col0

;

SELECT ALL + - 12 FROM tab1 GROUP BY tab1.col2

;

SELECT - 18 FROM tab0 GROUP BY tab0.col2

;

SELECT 72 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + - 12 * tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 44 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - 70 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - - ( - 50 ) AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 48 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col2, cor0.col1

;

SELECT + 10 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + ( col0 ) AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - tab2.col1 - 42 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + cor0.col0 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT + 63 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 5 * col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + tab0.col0 * + tab0.col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT 51 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + tab2.col1 * 96 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + col0 * - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - 43 FROM tab2 GROUP BY tab2.col1

;

SELECT - 78 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + ( - 9 ) AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col1 AS col1 FROM tab2 cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT cor0.col2 * - col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 26 * + tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - ( - 31 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 43 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT + ( tab2.col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 89 - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 36 + + 99 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + tab0.col2 * + ( 58 ) FROM tab0 GROUP BY col2

;

SELECT - 16 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + 1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col0 + cor0.col0 * - cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - cor0.col0 + + cor0.col0 * - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT ALL + + tab0.col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT ALL - + tab2.col2 + 39 FROM tab2 GROUP BY tab2.col2

;

SELECT - cor0.col2 * cor0.col2 - - 76 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT tab0.col1 - - 62 FROM tab0 GROUP BY tab0.col1

;

SELECT + col0 + 48 FROM tab2 GROUP BY tab2.col0

;

SELECT tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2 HAVING NOT ( NULL ) IS NULL
;

SELECT - tab0.col1 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NOT NULL
;

SELECT + 24 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT cor0.col1 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + cor1.col1 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT + 96 - - 57 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - 54 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - COALESCE ( - tab1.col0, + 65 ) AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 14 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 62 FROM tab2 GROUP BY tab2.col1

;

SELECT - 51 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - 46 * tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - cor0.col0 + + cor0.col0 AS col0 FROM tab1 cor0 GROUP BY col0

;

SELECT - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT 98 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT 58 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 61 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 67 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT col2 - + col2 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT + col0 AS col0 FROM tab2 GROUP BY tab2.col0 HAVING NULL IS NULL
;

SELECT - 90 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + 25 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + 28 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 50 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 87 + + tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 99 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT 47 + + ( + col0 ) * + col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 + + 79 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 46 AS col2 FROM tab1 GROUP BY col1

;

SELECT + 21 FROM tab2 GROUP BY tab2.col2

;

SELECT 80 FROM tab0 GROUP BY tab0.col1

;

SELECT + 78 FROM tab2 cor0 GROUP BY col1

;

SELECT 33 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 18 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 28 AS col0 FROM tab0 GROUP BY col1

;

SELECT + 35 FROM tab0 GROUP BY tab0.col1

;

SELECT + 4 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col1 * cor0.col1 + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT 61 * + 82 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col2 + - 81 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + 95 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + 29 FROM tab2, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ( 1 ) AS col0 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT + + col0 - + col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT 37 FROM tab1 GROUP BY col2

;

SELECT 10 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 93 FROM tab2 GROUP BY tab2.col0

;

SELECT - + 99 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - tab0.col1 + 96 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2 HAVING NOT NULL IS NOT NULL
;

SELECT - 77 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + - 93 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - + tab2.col0 * + 47 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col1 * 33 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT cor0.col2 * + 41 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor1.col0 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL - + 5 * col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT 70 * col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT tab2.col2 - col2 FROM tab2 GROUP BY tab2.col2

;

SELECT tab0.col0 + col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL NULLIF ( cor0.col1, cor0.col1 ) * - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT DISTINCT + cor0.col2 * 83 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT col0 * col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 73 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 67 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL + 7 * cor0.col1 AS col1 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL + + 19 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - 3 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - 71 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + 26 * + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - 86 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + cor0.col2 + + 27 AS col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT - 97 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 * + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 28 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 4 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 10 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 25 * 1 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 8 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT 9 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 88 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - tab0.col1 + + tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT 58 FROM tab1 cor0 GROUP BY col1

;

SELECT + - 30 + tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT - - 0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - - 0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 85 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 85 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT + 7 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 * - 55 + cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + 34 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL ( - cor0.col2 ) * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 86 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 93 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT tab2.col0 FROM tab2 WHERE NOT NULL NOT IN ( + col2 + tab2.col2 * tab2.col2 ) GROUP BY tab2.col0

;

SELECT + col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + col1 FROM tab2 GROUP BY col1 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT + tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1 HAVING ( NULL ) IS NULL
;

SELECT ALL cor0.col0 + - cor0.col0 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col0 + 55 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT 35 * 44 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col0 * - NULLIF ( - cor0.col0 * 31, cor0.col1 - - cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col0 - 3 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + 99 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT ( cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 24 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 29 + 33 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + + 84 * - tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 43 * col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 * 15 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL 36 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 10 FROM tab0 GROUP BY tab0.col2

;

SELECT 79 + + 1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, col0

;

SELECT cor0.col2 + + COALESCE ( cor0.col0, - cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - - col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - cor0.col1 + + 51 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT 10 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 31 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + col2 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 55 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - col0 * 15 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - + 74 - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - + tab1.col2 - col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + 94 + - cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL cor1.col0 AS col2 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL - + 44 * 69 + - 97 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + tab1.col0 + - ( 54 ) FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col1 + cor0.col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL + 6 FROM tab2 GROUP BY tab2.col2

;

SELECT 69 + + cor0.col0 FROM tab2 cor0 GROUP BY col0

;

SELECT - 7 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT col1 - - 80 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT tab0.col0 + + 33 AS col2 FROM tab0 GROUP BY col0

;

SELECT 36 AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 73 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL 94 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + tab1.col0 + - tab1.col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT + 62 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 45 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 76 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT COALESCE ( cor0.col1, cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 48 FROM tab1 GROUP BY tab1.col0

;

SELECT 1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT tab2.col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT + 28 * tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT + 75 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 86 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 4 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 19 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 * + cor0.col0 + ( + cor0.col0 ) * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - + tab2.col2 - + tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 77 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 39 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + tab1.col1 * tab1.col1 + 27 FROM tab1 GROUP BY tab1.col1

;

SELECT 32 + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col0, cor0.col2

;

SELECT tab2.col0 * + 2 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 63 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 76 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT - cor0.col2 * 0 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col2 FROM tab2 AS cor0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT 45 + + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - ( tab2.col0 ) AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - 64 + 34 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL + + ( - 62 ) FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + - 40 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + 22 FROM tab1 GROUP BY tab1.col2

;

SELECT - + 61 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 5 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + cor0.col2 * 95 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + tab0.col0 + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT NULLIF ( + 79, + cor0.col2 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT DISTINCT + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL + + 15 AS col0 FROM tab1 GROUP BY col1

;

SELECT ALL + - 73 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL ( + 84 ) FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 49 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + tab1.col1 + 98 FROM tab1 GROUP BY tab1.col1

;

SELECT - tab1.col1 * - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT tab2.col1 * col1 FROM tab2 GROUP BY col1

;

SELECT ALL - col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL + tab1.col1 FROM tab1 GROUP BY tab1.col1 HAVING NULL NOT IN ( + tab1.col1 * - col1 )
;

SELECT + tab2.col2 - tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col1 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT - tab2.col0 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - tab1.col0 * - 84 + tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + tab2.col0 * + tab2.col0 + 43 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 56 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - 94 FROM tab0 GROUP BY tab0.col0

;

SELECT + cor0.col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 95 + + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - cor0.col2 + + col2 AS col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT cor0.col1 FROM tab1 cor0 GROUP BY col1, col0

;

SELECT + 41 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor1.col2

;

SELECT ALL - cor0.col2 * + 65 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 97 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ( tab2.col1 ) FROM tab2 GROUP BY col1

;

SELECT - col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + + 72 - - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - tab0.col2 * - col2 FROM tab0 GROUP BY tab0.col2

;

SELECT tab0.col1 * - 61 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL cor0.col1 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - - 97 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT ALL 26 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - + 1 FROM tab1 GROUP BY col1

;

SELECT cor0.col1 * - 7 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - cor0.col0 - - 51 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + - col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT 92 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT 75 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - 44 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 24 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT cor0.col0 * 44 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col0 * + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 43 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + cor0.col1 * cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT + 83 + + 51 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 46 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 65 + 1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING NOT ( NULL ) IS NULL
;

SELECT DISTINCT + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col2, cor0.col0

;

SELECT DISTINCT - 67 * - cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 76 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - 23 FROM tab2 GROUP BY tab2.col0

;

SELECT + - 70 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 39 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 40 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + ( - tab2.col0 ) FROM tab2 GROUP BY tab2.col0

;

SELECT + col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col1 * + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT 56 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 46 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - - 64 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + + ( 19 ) FROM tab2 GROUP BY tab2.col1

;

SELECT 14 + - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY col0, cor0.col0

;

SELECT + NULLIF ( 89, tab1.col2 ) FROM tab1 GROUP BY col2

;

SELECT DISTINCT - tab2.col1 FROM tab2 WHERE NOT NULL NOT IN ( tab2.col2 ) GROUP BY tab2.col1

;

SELECT DISTINCT col2 AS col0 FROM tab2 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT ALL tab2.col1 * tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 74 + + tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - 94 FROM tab1 cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT 32 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 15 - 32 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 84 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - - 13 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 36 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 3 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT + cor0.col0 - - cor0.col0 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT ALL - 83 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + col2 * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - cor0.col2 * 54 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 10 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 71 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT - col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT tab0.col2 * 97 - col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 24 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT DISTINCT - tab2.col0 * - 38 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 68 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 91 + cor0.col2 * - NULLIF ( cor0.col2 + - cor0.col2, cor0.col2 ) AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 19 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 81 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col0 * - 18 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 3 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 82 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT - 14 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 21 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT - + ( col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT + + 58 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 53 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT + 19 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 34 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 62 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL cor0.col1 * + col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - + col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - + col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - tab2.col0 * + tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - ( tab1.col0 ) AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + + tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - NULLIF ( cor0.col2, col1 ) + + 24 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 16 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 51 + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT 26 * 71 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 16 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + 99 + 79 * cor0.col2 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT - - 48 AS col2 FROM tab2 GROUP BY col1

;

SELECT DISTINCT 7 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 19 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor1.col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1, cor1.col0

;

SELECT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY col2 HAVING NULL = ( NULL )
;

SELECT DISTINCT - col1 * + cor0.col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL 97 FROM tab2 GROUP BY tab2.col1

;

SELECT 91 FROM tab1 cor0 GROUP BY col1

;

SELECT tab1.col1 * 98 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col0 * + 1 + 0 * + 3 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - cor0.col0 * + cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL - 23 + - tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT + + 43 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 52 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT 13 + col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 99 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 91 FROM tab1 GROUP BY tab1.col0

;

SELECT 27 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT tab0.col0 + 55 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 3 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL 57 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT tab2.col0 * 30 - tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - tab1.col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT cor0.col2 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 GROUP BY cor0.col2 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT ALL cor0.col2 * cor0.col2 - + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL > NULL
;

SELECT DISTINCT + 2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL tab2.col2 * + col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + 2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - col2 + - col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 55 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 43 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - 67 * + cor0.col0 + 98 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 * + cor0.col2 + 49 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 85 AS col2 FROM tab2 GROUP BY col1

;

SELECT ALL - cor0.col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - - 13 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL ( + cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 87 FROM tab1 GROUP BY col1

;

SELECT DISTINCT + - 98 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 88 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT cor0.col2 * - 89 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 29 FROM tab1 GROUP BY tab1.col0

;

SELECT + 59 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + tab2.col1 + - col1 * tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 5 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT DISTINCT tab0.col2 AS col0 FROM tab0, tab0 AS cor0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col2 + + 97 * + 66 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 73 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT - - tab1.col0 - 54 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + ( cor0.col1 ) + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, col0

;

SELECT DISTINCT + + 5 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + 48 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 79 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 69 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 51 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + - COALESCE ( - 37, tab2.col0 + + 58, - tab2.col0 - + 74 ) FROM tab2 GROUP BY tab2.col0

;

SELECT 31 FROM tab2 GROUP BY tab2.col0

;

SELECT 81 + + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - - 1 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + + 96 * - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 83 + 88 FROM tab1 GROUP BY col0

;

SELECT ALL 61 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab0.col2 * tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2 HAVING NULL IS NULL
;

SELECT DISTINCT + col2 AS col2 FROM tab0 WHERE NOT NULL IN ( tab0.col0 * col0 + - tab0.col0 ) GROUP BY col2

;

SELECT DISTINCT - cor0.col0 * - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL 91 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + 53 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - + 78 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 92 AS col0 FROM tab2 GROUP BY col2

;

SELECT ALL + tab1.col2 * tab1.col2 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - 71 + - tab0.col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 32 + tab2.col0 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT - cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor0.col1, cor0.col2, cor1.col2

;

SELECT DISTINCT + cor0.col2 + cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT - 0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 49 + + col0 * col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - + col1 * - col1 + - col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL tab1.col1 + tab1.col1 * - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 12 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 61 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 98 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + - 6 * + 15 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + col1 - + 91 * col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 * col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT tab2.col1 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 65 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - 2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col2, cor1.col0

;

SELECT ALL - 99 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL ( 93 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 * - cor0.col1 + - 78 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 + - NULLIF ( cor0.col1 - 60, + cor0.col1 / 66 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + cor0.col1 * + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL tab2.col2 + + col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT cor0.col1 + - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT cor0.col0 + 79 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 81 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 67 FROM tab1 GROUP BY tab1.col0

;

SELECT + 46 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT + 42 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col0

;

SELECT cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 74 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + 80 - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 15 * - tab0.col0 + + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - 0 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 54 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 87 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 60 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT + tab1.col1 AS col1 FROM tab1 GROUP BY col1 HAVING NULL IS NULL
;

SELECT DISTINCT col0 * + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 * + 37 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col1 + - 17 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL tab0.col2 + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 68 FROM tab1 GROUP BY tab1.col0

;

SELECT - 32 * - tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - tab1.col2 * + tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT 42 + + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col0 + 3 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col0 * + col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 96 * cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + col0 * + 62 + - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL - - 18 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 62 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 * - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + 73 * - tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 14 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 * 91 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 91 + cor0.col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL + 49 + + 6 FROM tab1 GROUP BY tab1.col0

;

SELECT + 44 FROM tab2 GROUP BY col1

;

SELECT + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT tab0.col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT + - ( - 12 ) FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + + 73 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col0 - 98 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT NULLIF ( - col1, col1 ) FROM tab1 GROUP BY col1

;

SELECT ALL - cor0.col0 + + col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 47 AS col1 FROM tab0, tab1 cor0 GROUP BY tab0.col2

;

SELECT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT + 17 * cor0.col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT + + ( - 24 ) FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col1 + + 74 * col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - cor0.col2 + + col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - 71 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 41 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 0 * - 14 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + tab2.col2 * col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + - tab0.col2 + - 13 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + tab0.col1 * 3 FROM tab0 GROUP BY col1

;

SELECT - 19 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 92 FROM tab1 GROUP BY tab1.col1

;

SELECT - - tab0.col0 - + 56 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 2 * cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 70 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL tab1.col1 * col1 FROM tab1 GROUP BY col1

;

SELECT + tab0.col2 FROM tab0 GROUP BY tab0.col2 HAVING NULL IS NOT NULL
;

SELECT + col2 / col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING NULL IS NOT NULL
;

SELECT ALL + + tab2.col1 - - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 40 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT + tab1.col0 * 58 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + tab0.col2 * 70 AS col2 FROM tab0 GROUP BY col2

;

SELECT - 92 FROM tab0 GROUP BY tab0.col0

;

SELECT - 65 FROM tab1 GROUP BY tab1.col0

;

SELECT 23 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + 37 FROM tab1 GROUP BY tab1.col0

;

SELECT + 93 + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 73 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - 46 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + + 39 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + + 35 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + - 8 FROM tab1 GROUP BY col0

;

SELECT DISTINCT ( - col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT ALL col0 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT cor1.col1 * + cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT ALL + + 7 * 28 FROM tab2 GROUP BY tab2.col2

;

SELECT 35 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor1.col1, cor0.col0

;

SELECT DISTINCT - tab0.col0 * - 37 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 34 + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 30 + - 47 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 58 * + 31 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT - 95 FROM tab2 GROUP BY tab2.col1

;

SELECT - - 22 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + 89 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + 84 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 63 AS col2 FROM tab2 GROUP BY col0

;

SELECT - + 4 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 29 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - - 65 + col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + cor0.col2 * + 60 + 39 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + CASE tab2.col0 WHEN tab2.col0 THEN NULL WHEN - 25 THEN NULL ELSE + col0 END AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT 24 * tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 66 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT - 61 FROM tab1 GROUP BY tab1.col2

;

SELECT - 81 + tab0.col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT cor0.col0 - 23 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + + 55 * - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 77 + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor1.col1 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT + 26 * + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT tab1.col1 * + 82 FROM tab1 GROUP BY tab1.col1

;

SELECT + 72 AS col2 FROM tab1 GROUP BY col0

;

SELECT ALL cor0.col0 * 78 AS col0 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 23 + cor0.col2 * 71 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT cor0.col2 * - 15 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + 10 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + ( 85 ) + - tab1.col0 * + 65 FROM tab1 GROUP BY tab1.col0

;

SELECT + 95 AS col2 FROM tab0 GROUP BY col1

;

SELECT + 94 FROM tab2 cor0 GROUP BY cor0.col0, col0

;

SELECT ALL - 62 + - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT col0 AS col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col0, col2

;

SELECT ALL + 67 FROM tab2 GROUP BY tab2.col2

;

SELECT + 66 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT cor0.col1 * col2 AS col0 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT 48 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL + tab2.col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT + 51 - + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - 14 FROM tab1 GROUP BY tab1.col1

;

SELECT NULLIF ( cor0.col2, - 49 ) AS col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT - col0 * - 13 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL col2 * + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING NULL IS NOT NULL
;

SELECT ALL - 97 + - 36 AS col1 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT ALL cor0.col2 - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - + 4 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 48 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 23 AS col0 FROM tab1, tab0 cor0 GROUP BY tab1.col2

;

SELECT - 58 * 39 + cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - 87 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 46 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 19 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + tab2.col2 * tab2.col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT + - 84 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - 31 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - 66 * cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + cor0.col0 + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - ( + 15 ) FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT - tab1.col1 + + COALESCE ( 72 + tab1.col1, tab1.col1 ) * tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 55 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - + col0 FROM tab1 GROUP BY col0

;

SELECT + 30 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 20 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + NULLIF ( - 30, 30 ) AS col2 FROM tab0 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT + + 72 * + 60 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL tab0.col0 + 61 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - ( + cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col2 + - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col0 * - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + tab2.col0 + + tab2.col0 FROM tab2 GROUP BY tab2.col0 HAVING NOT ( NULL ) NOT BETWEEN - col0 / tab2.col0 AND ( NULL )
;

SELECT tab1.col1 * + tab1.col1 AS col1 FROM tab1 WHERE + tab1.col1 IS NULL GROUP BY tab1.col1 HAVING NULL IS NULL
;

SELECT ALL cor0.col2 * + 42 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT cor0.col1 - 58 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 98 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 64 * - 58 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 76 + col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - 56 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 6 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 13 FROM tab0 GROUP BY tab0.col1

;

SELECT + 41 + - 58 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 57 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 73 + + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 95 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT 29 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL - cor1.col0 - - cor1.col0 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col0

;

SELECT tab0.col1 + 41 * - 51 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT cor0.col1 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT - 3 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 79 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 89 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - ( - cor0.col1 ) AS col2 FROM tab2, tab2 cor0 GROUP BY cor0.col1

;

SELECT col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT DISTINCT 38 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + 46 * 77 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 36 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + 36 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 85 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - + 94 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 62 * 2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 89 + + tab1.col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT - - 93 FROM tab2 GROUP BY col1

;

SELECT ALL cor0.col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT + col0 + 83 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ( 63 ) AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col1 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT 70 * cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT + 52 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 25 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col0 + + cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 61 + tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 5 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 75 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor1.col1 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2, cor1.col1

;

SELECT - 25 + + cor0.col2 * - 62 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + 63 FROM tab2, tab1 AS cor0 GROUP BY tab2.col0

;

SELECT + + 59 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - - 44 AS col0 FROM tab0 GROUP BY col0

;

SELECT - col2 FROM tab0 GROUP BY tab0.col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - cor0.col1 + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NULL
;

SELECT cor0.col0 + col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 10 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 89 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + col0 + - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 31 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + tab1.col2 - - col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - + ( + tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT ALL ( + col2 ) FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col1 * + 61 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 19 FROM tab2 GROUP BY tab2.col1

;

SELECT + - tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT 67 FROM tab2 GROUP BY tab2.col1

;

SELECT - 86 * 22 AS col1 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT + 13 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 81 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL tab0.col2 + tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT + 61 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col0 + + 24 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0 HAVING NOT ( NULL ) IN ( - cor0.col0 )
;

SELECT cor0.col1 - cor0.col1 * + col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor1.col1 * - 25 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - - 95 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 40 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - + tab1.col1 * + 7 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - + 49 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + 46 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 + + ( 16 ) FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT + tab0.col2 * - 54 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 16 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT CASE - cor0.col0 WHEN + cor0.col0 THEN - cor0.col0 ELSE NULL END * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col1 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ( col0 ) * cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ( + cor0.col1 ) FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL - tab0.col0 AS col0 FROM tab0, tab2 AS cor0 GROUP BY tab0.col0

;

SELECT ALL 41 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 73 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL tab0.col0 + tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - cor0.col0 - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - + 24 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - ( - cor0.col1 ) * + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT ALL 24 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col0 - cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT NULLIF ( tab2.col0, tab2.col0 + + tab2.col0 ) * 6 - + col0 FROM tab2 GROUP BY col0

;

SELECT ALL - + 20 + tab2.col0 FROM tab2 GROUP BY col0

;

SELECT ALL - - ( tab2.col2 ) FROM tab2 GROUP BY tab2.col2

;

SELECT - + 46 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT 91 * + cor0.col0 - col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT cor0.col0 + cor0.col2 * - cor0.col0 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT + + ( - 74 ) AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col0 + + col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ( - 61 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - - col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT 83 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL - - tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT tab0.col2 + + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + tab0.col1 + + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col2, col0

;

SELECT - 37 + - col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 + ( 40 ) FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL cor0.col1 * - ( + cor0.col1 ) FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 47 * 68 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 28 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 78 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col1 + - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + 80 * - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + - 78 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 54 FROM tab0 GROUP BY tab0.col0

;

SELECT + + 99 FROM tab1 GROUP BY tab1.col0

;

SELECT + + col0 + - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - col2 + cor0.col2 * + cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1 HAVING NULL < ( NULL )
;

SELECT ALL cor0.col2 * - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL 74 + col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT tab2.col0 * 51 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT 34 + cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT + - 5 FROM tab0 GROUP BY tab0.col0

;

SELECT ( 45 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + + tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 70 FROM tab2 cor0 GROUP BY col1

;

SELECT 50 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - 2 - tab2.col1 * tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col0 + + cor0.col0 * 8 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + tab0.col0 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT DISTINCT 41 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - tab1.col2 * + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT cor0.col0 + cor0.col0 * + 60 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 16 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 11 * - cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + 68 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1, cor1.col2, cor0.col2

;

SELECT + 58 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + 23 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 32 * 30 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 12 FROM tab0 GROUP BY tab0.col1

;

SELECT - + col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 1 AS col1 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - cor0.col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + 18 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + - 0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT cor0.col1 * - cor0.col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT - 60 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + 24 * tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + + ( - tab0.col1 ) + + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 78 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 27 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 89 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - tab2.col2 * + tab2.col2 + 85 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 12 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 67 FROM tab1 GROUP BY col1

;

SELECT cor0.col0 + + 56 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - - 36 * 60 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT 58 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - 37 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 48 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * + 65 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT COALESCE ( cor0.col2, cor0.col2 * + 28 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 23 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 96 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT col2 + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - 88 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 19 FROM tab2 GROUP BY tab2.col1

;

SELECT CASE - col2 WHEN cor0.col2 THEN 37 * 7 ELSE NULL END AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + 37 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 56 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - - 4 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + cor0.col1 * + col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - - 84 + tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col1 * - cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 97 - col0 * 18 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 * 13 + + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 18 * tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT tab2.col2 + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 31 AS col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT ALL - 57 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 * + 96 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT cor0.col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT DISTINCT - 92 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 6 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT - + tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 6 AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - 29 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT DISTINCT - 58 FROM tab1 cor0 GROUP BY col2

;

SELECT ALL 74 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + + 41 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - tab1.col1 * - tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT tab0.col2 + - 22 * - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 83 + - 7 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + 74 * tab0.col0 - - 52 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 67 FROM tab0 GROUP BY tab0.col0

;

SELECT 84 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT 59 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 22 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT NULLIF ( tab2.col1, col1 ) AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT tab2.col0 * - 56 FROM tab2 GROUP BY tab2.col0

;

SELECT - col1 + + col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT cor1.col2 * cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1, cor1.col2

;

SELECT DISTINCT - - 46 FROM tab2 GROUP BY col0

;

SELECT ALL tab1.col2 * tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + - 44 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + tab2.col2 * + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 54 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - + 50 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + - 12 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - col0 * col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + 80 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 57 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 23 FROM tab0, tab0 cor0 GROUP BY cor0.col2

;

SELECT + ( + cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NULL NOT IN ( cor0.col1 )
;

SELECT DISTINCT 87 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 93 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - tab2.col0 + - tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - 82 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 1 + 56 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL 1 FROM tab0 GROUP BY tab0.col1

;

SELECT 99 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL 20 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + 56 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 72 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT + 85 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + 6 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 + col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - 5 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT 21 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 60 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + 59 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col2 AS col2 FROM tab1 cor0 GROUP BY col2, cor0.col0, cor0.col0

;

SELECT - tab0.col1 + - col1 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT tab0.col1 * + tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 27 FROM tab2 GROUP BY col2

;

SELECT ALL + - 11 + 22 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL tab0.col2 + + 50 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 11 AS col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - 26 + - cor0.col1 FROM tab2 cor0 GROUP BY col2, cor0.col1

;

SELECT - tab2.col2 * + 74 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 83 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - ( - 61 ) FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL 75 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - cor0.col0 + + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL cor0.col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT + COALESCE ( + tab0.col1, tab0.col1 ) FROM tab0 GROUP BY tab0.col1

;

SELECT 48 FROM tab1 GROUP BY tab1.col1

;

SELECT + 23 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - col1 * + cor0.col2 + CASE + 18 WHEN cor0.col1 THEN NULL ELSE + cor0.col1 END * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 34 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 69 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 61 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + + col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col0 + cor0.col0 * - 40 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + cor0.col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - ( 44 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 24 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL - 39 FROM tab0, tab1 AS cor0 GROUP BY tab0.col2

;

SELECT DISTINCT - cor0.col2 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL cor1.col1 * cor1.col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT + + tab0.col0 + - tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + - 9 AS col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - col1 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 27 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT tab2.col0 + 40 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 92 + - col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 44 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 93 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 98 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 81 FROM tab1 GROUP BY tab1.col1

;

SELECT - 7 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 5 FROM tab2 GROUP BY tab2.col0

;

SELECT + tab2.col0 AS col0 FROM tab2 GROUP BY col0 HAVING NULL IS NULL OR NOT ( NULL ) < NULL
;

SELECT DISTINCT - cor0.col0 + - col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ( - cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + col0 + - 64 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + - tab2.col0 + + ( 76 ) FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col0 AS col2 FROM tab1 cor0 GROUP BY col0

;

SELECT + 69 * + tab2.col1 + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 64 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor1.col1 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - NULLIF ( tab2.col1, + tab2.col1 + + col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT - 31 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 23 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 45 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - cor0.col1 * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 61 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 58 + + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - - 33 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - cor0.col2 + + 67 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col1 + + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - cor0.col0 * cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT ALL + 67 + 34 FROM tab1 GROUP BY col0

;

SELECT ALL 17 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - + col2 * - tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT cor0.col0 * + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL - col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - cor0.col2 * - ( 52 * - 36 ) - cor0.col2 * col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - COALESCE ( - tab1.col1, + 18 ) AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + + tab1.col2 + - 94 * - tab1.col2 FROM tab1 GROUP BY col2

;

SELECT + ( - 9 ) AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT + cor1.col1 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor1.col0

;

SELECT - ( 55 ) + col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - 74 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 80 + 70 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - + 82 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 5 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT 36 FROM tab0 GROUP BY tab0.col1

;

SELECT - col2 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING NOT - col2 IS NOT NULL
;

SELECT ALL - COALESCE ( - 6, + cor0.col2 ) * 11 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 25 AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT tab2.col2 - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + cor0.col0 * 34 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 42 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 28 - tab0.col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT ALL - 53 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 75 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - 49 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT tab1.col2 * - 90 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col0 AS col1 FROM tab1, tab2 cor0 GROUP BY cor0.col0

;

SELECT 68 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - 82 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 + - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL tab2.col2 + - tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + + 14 FROM tab2 GROUP BY tab2.col2

;

SELECT - col0 - - cor0.col0 * + cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - 5 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 71 + - 4 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - tab0.col2 * + 64 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col2 * + 52 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 87 FROM tab1 GROUP BY tab1.col1

;

SELECT - - col1 - - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 71 * + col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 35 FROM tab0 GROUP BY tab0.col1

;

SELECT 14 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - cor0.col0 - cor0.col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - 79 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + col1 * + tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ( 66 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 24 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 61 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 1 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 16 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 53 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + + 74 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - + 69 * + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 97 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col0 + - col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 AS col1 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col2, cor0.col1

;

SELECT tab0.col1 - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + tab0.col2 * + col2 + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col2 * NULLIF ( 92, cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT DISTINCT - cor0.col1 + + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 7 * cor0.col0 + + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - + 99 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + 41 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - + 15 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT ( COALESCE ( col1, + cor0.col1 ) ) * + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 14 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col0 * 57 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL 54 * + cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - 70 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + 62 * + col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - + tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 73 + + tab2.col0 * 73 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 18 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor0.col0

;

SELECT DISTINCT - 37 * - 12 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - + 53 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 96 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 * - 60 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT cor0.col0 + - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 95 + + 58 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 40 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 1 - - cor1.col1 * cor1.col1 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor1.col1

;

SELECT DISTINCT + - 40 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT cor0.col0 + 2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT 77 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 * 52 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor1.col2 FROM tab2 cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT col0 FROM tab2 cor0 GROUP BY col1, cor0.col0

;

SELECT + 94 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col0, col0

;

SELECT ALL ( + 8 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 57 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - 52 FROM tab1 GROUP BY tab1.col1

;

SELECT + + tab2.col2 * tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col1, cor0.col1

;

SELECT DISTINCT - 30 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 91 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - cor1.col0 * + cor0.col0 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2, cor0.col0, cor1.col0

;

SELECT - 3 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 * cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + - tab1.col2 FROM tab1, tab0 AS cor0 GROUP BY tab1.col2

;

SELECT + cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col0

;

SELECT ALL 59 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT COALESCE ( 23, + 58 ) * - col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + + 7 FROM tab2 GROUP BY tab2.col2

;

SELECT + NULLIF ( cor0.col1, col1 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col2 * 13 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + - tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT 22 * tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - + ( + tab1.col1 ) + tab1.col1 * ( - 93 ) FROM tab1, tab0 AS cor0 GROUP BY tab1.col1

;

SELECT cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL < NULL
;

SELECT ALL - - col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - tab1.col0 * - 26 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 67 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 65 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 97 FROM tab0 GROUP BY tab0.col0

;

SELECT - - col2 * tab2.col2 + + 39 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 74 * cor0.col1 - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT cor0.col1 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT DISTINCT - ( 52 ) AS col2 FROM tab2 GROUP BY col0

;

SELECT + ( col0 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + cor0.col0 * - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + 4 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - col2 + 3 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT col1 + - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col1 + cor0.col1 FROM tab2 cor0 GROUP BY col1

;

SELECT 57 FROM tab0 GROUP BY tab0.col0

;

SELECT 40 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + tab0.col0 - 53 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 39 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + 62 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab2 cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT 22 + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 13 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - - 35 + 50 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + + tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT 86 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + - CASE + 1 WHEN + col2 + + tab1.col2 THEN 65 END FROM tab1 GROUP BY tab1.col2

;

SELECT 98 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - - tab2.col0 FROM tab2, tab2 AS cor0 GROUP BY tab2.col0

;

SELECT ALL - ( 65 ) FROM tab2 GROUP BY tab2.col1

;

SELECT - 83 FROM tab1 GROUP BY tab1.col0

;

SELECT 76 * - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT cor0.col2 * ( + cor0.col2 ) FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 * 93 + + cor0.col1 FROM tab0 cor0 GROUP BY col2, col1

;

SELECT DISTINCT + cor0.col0 + - col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 5 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 3 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 85 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 88 * col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT col2 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 38 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 33 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - 30 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 96 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 39 AS col1 FROM tab2 cor0 GROUP BY col1

;

SELECT + 35 + tab0.col2 * col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 90 * 60 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT 96 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - - ( + tab0.col1 ) FROM tab0 GROUP BY tab0.col1

;

SELECT + ( tab1.col0 ) FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + tab0.col1 AS col1 FROM tab0 WHERE NOT NULL NOT IN ( - tab0.col2 ) GROUP BY col1

;

SELECT - cor0.col0 AS col2 FROM tab2 cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col1 * + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NOT ( NULL ) IS NULL
;

SELECT - cor0.col1 - + 74 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT DISTINCT - col0 - - col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - 98 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT - + 1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT + + 96 + 43 AS col2 FROM tab0 GROUP BY col0

;

SELECT - 50 AS col2 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 50 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL ( NULLIF ( - tab1.col0, tab1.col0 ) ) AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT tab0.col0 + - tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + col0 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + tab2.col1 AS col1 FROM tab2 WHERE ( NULL ) NOT IN ( - tab2.col1 + col2 ) GROUP BY tab2.col1

;

SELECT + 62 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL + 55 FROM tab2 GROUP BY tab2.col0

;

SELECT + 35 * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - 9 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab2.col1 * 72 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + - 95 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - tab2.col0 + + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + tab0.col0 + - tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + - 43 * col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 97 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 3 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT cor0.col2 - cor0.col1 * - col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT 49 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + 2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 77 * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 97 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT + + 22 - - tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - + 99 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - + 91 + - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - - 50 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 46 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT + - 96 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 93 FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col1 * + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 66 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL 71 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor1.col2, cor1.col1

;

SELECT - ( + cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 20 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 13 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 42 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - col0 + 87 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + col0 * + tab1.col0 + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col2 * - col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 80 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 67 * + 52 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + 97 FROM tab2 GROUP BY col0

;

SELECT 19 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT cor0.col1 + col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 82 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col1

;

SELECT ALL - 11 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - 68 * tab1.col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT - 40 + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT col0 + col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT tab2.col0 + 21 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - 22 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 * - cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT + 3 * tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - tab1.col1 + - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL ( 82 ) AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + + tab2.col1 + - 31 * 52 AS col0 FROM tab2 GROUP BY col1

;

SELECT ALL ( - 81 ) AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 11 AS col2 FROM tab0 GROUP BY col1

;

SELECT - ( 57 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 59 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING NOT ( NULL ) <= ( NULL )
;

SELECT + 69 FROM tab2 GROUP BY col0

;

SELECT + 10 * - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col0 + + 84 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT cor0.col0 + 49 * cor0.col0 AS col0 FROM tab2 cor0 GROUP BY col0

;

SELECT ( cor0.col1 ) FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 92 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + 44 AS col1 FROM tab2 GROUP BY col0

;

SELECT DISTINCT cor0.col2 + - col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 65 * - col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 78 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL - 58 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT col1 - col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - tab1.col0 + 97 FROM tab1 GROUP BY tab1.col0

;

SELECT - + 77 * - tab0.col0 + + tab0.col0 * + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT - 97 FROM tab1 GROUP BY tab1.col2

;

SELECT - - tab1.col0 - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + cor0.col1 * 52 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - ( 34 ) * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 47 * + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - col0 + 27 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - - 61 FROM tab2 GROUP BY col0

;

SELECT - col0 AS col2 FROM tab2 GROUP BY tab2.col0 HAVING NULL IS NOT NULL
;

SELECT ALL cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1 HAVING NOT ( NULL ) IS NULL
;

SELECT ALL + 9 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL + tab2.col1 + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 31 FROM tab0 GROUP BY tab0.col1

;

SELECT + 12 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 * cor0.col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1, cor0.col0

;

SELECT ALL cor0.col1 * - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL - tab1.col2 + - tab1.col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + cor0.col1 * 54 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 33 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 72 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 15 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 78 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - col2 + - col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 3 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT tab2.col1 * - tab2.col1 AS col0 FROM tab2 WHERE NOT + tab2.col1 + + tab2.col0 IN ( tab2.col0 ) GROUP BY tab2.col1 HAVING NOT col1 = NULL
;

SELECT ALL cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1, cor1.col0

;

SELECT - 16 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 48 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + ( - cor0.col0 ) + - cor0.col0 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - 60 FROM tab1 GROUP BY tab1.col0

;

SELECT 99 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + cor0.col0 * + col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 81 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL ( - cor0.col1 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT tab2.col2 + col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - cor0.col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 83 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL + + 31 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ( 58 ) FROM tab2 AS cor0 GROUP BY col1

;

SELECT - 13 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + 5 FROM tab1 GROUP BY tab1.col1

;

SELECT - 82 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT NULLIF ( cor0.col2, - cor0.col2 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 78 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + 79 + + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 62 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - + 69 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + 5 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col0 + cor0.col0 * 27 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 42 * cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 36 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 95 - + 99 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT ( COALESCE ( + tab2.col0, + tab2.col0 + tab2.col0 ) ) FROM tab2 GROUP BY tab2.col0

;

SELECT - 83 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 69 * cor1.col1 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT + tab0.col1 * 71 FROM tab0 GROUP BY tab0.col1

;

SELECT + + tab1.col1 * 84 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + - tab2.col2 * + 0 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT - tab1.col0 * + col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - + tab0.col1 + + col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT + - 96 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + tab1.col0 * - 33 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 4 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 53 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 47 - tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + - col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + ( + cor0.col1 ) * col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 + cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - 43 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 61 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, col1

;

SELECT ALL + + 23 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 3 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + 76 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 + cor0.col2 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT - 90 * 74 FROM tab1 GROUP BY tab1.col1

;

SELECT + 77 - 88 * + tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ( + 5 ) FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 66 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 97 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 45 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col2 * ( 25 ) + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 49 + cor0.col0 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL - 51 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT 23 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - col1 * tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 73 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 30 * 44 AS col1 FROM tab0 AS cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT 76 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - - tab0.col2 + col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col0 + + cor0.col1 * + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + cor0.col0 + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - - 57 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - + 26 * cor0.col2 AS col2 FROM tab0, tab1 cor0 GROUP BY cor0.col2

;

SELECT tab0.col1 * col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col1 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT - - col0 FROM tab2 GROUP BY col0

;

SELECT + 72 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 63 + col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 14 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT - tab2.col0 AS col1 FROM tab2 WHERE NOT NULL = NULL GROUP BY tab2.col0

;

SELECT ALL col2 AS col2 FROM tab1 WHERE ( + col0 + - col0 ) = NULL GROUP BY tab1.col2

;

SELECT col0 FROM tab0 GROUP BY tab0.col0 HAVING ( NULL ) NOT BETWEEN NULL AND NULL
;

SELECT ALL + tab2.col2 - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 22 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + 7 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + + tab2.col2 + + col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 42 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT 90 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 50 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col1 * + 60 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL cor0.col0 * 22 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 41 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - - 35 * 62 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + cor1.col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - 61 * - tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - col2 + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - cor0.col0 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0

;

SELECT 37 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 71 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + - 82 * 72 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - 46 * 71 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - + ( - 61 ) AS col1 FROM tab1 GROUP BY col0

;

SELECT + 56 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 68 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 39 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 38 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + cor0.col0 * cor0.col0 + - 58 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 45 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + ( 76 ) AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ( - 71 ) FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT + 49 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT + 45 + 26 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 98 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - NULLIF ( 44, tab2.col0 ) * + 52 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - tab2.col0 - - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 + - col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + tab1.col2 * + 37 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col1 * ( cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + - 11 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - cor0.col1 + NULLIF ( cor0.col1 + - cor0.col1, cor0.col1 * cor0.col1 ) * + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - tab2.col2 - + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - cor0.col2 + - cor0.col2 * 38 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT DISTINCT + - tab0.col1 * - tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 63 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1

;

SELECT + 34 * - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL - 2 FROM tab2 GROUP BY col1

;

SELECT ALL - 42 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT 18 * + col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - 25 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + col2 - - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 94 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + tab0.col2 * tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT - 38 - tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - 76 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + + 96 + + col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col2 + - cor0.col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + tab1.col0 * - 2 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + tab0.col2 + + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + + 64 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col1 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT 41 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 42 FROM tab0 AS cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT - 7 FROM tab0 GROUP BY tab0.col0

;

SELECT - 44 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + 47 + tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - tab0.col2 * + tab0.col2 + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + 51 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT DISTINCT + 74 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL - + 28 + + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 25 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - + tab1.col2 * 90 AS col2 FROM tab1 GROUP BY col2

;

SELECT ALL - tab1.col0 * col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - tab0.col0 FROM tab0 GROUP BY tab0.col0 HAVING NULL IS NULL
;

SELECT ALL + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT col1 * - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col2 + 40 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL 40 AS col0 FROM tab1, tab1 cor0 GROUP BY tab1.col1

;

SELECT DISTINCT - - ( + tab2.col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT + 13 AS col0 FROM tab1 GROUP BY col2

;

SELECT + 97 * - 87 - + tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + ( 19 ) * - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT 38 * + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + ( cor0.col2 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - + ( 80 ) AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT cor0.col1 * - 72 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT ALL + cor0.col1 + + cor0.col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 29 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 20 AS col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col1, cor0.col2

;

SELECT ALL 55 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT + 57 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 35 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - 50 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + 50 FROM tab1 GROUP BY tab1.col2

;

SELECT + 77 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - + 31 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + + ( + tab2.col2 ) FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 45 * - 23 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 26 * + cor1.col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT + col1 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 * - 54 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT tab0.col1 + tab0.col1 * tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1 HAVING NOT NULL <= - col1
;

SELECT DISTINCT + - col1 * tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 4 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 32 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - NULLIF ( - 30, tab0.col1 ) + + 42 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 92 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 46 * col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, col1

;

SELECT 57 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 66 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 40 + 55 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - + tab2.col2 + - 38 * col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + ( tab2.col2 ) FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + ( tab1.col0 ) * - 40 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 47 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 16 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT - 38 + col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - + tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT + + 87 FROM tab2 GROUP BY col0

;

SELECT ALL + 63 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col2 + - col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT ALL + + col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + 15 * + cor0.col1 + + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 15 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT DISTINCT - + 26 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col1 + - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 78 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 60 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + 49 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 51 * - tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 72 * + 22 FROM tab2 GROUP BY col2

;

SELECT + ( tab0.col0 ) AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT 17 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 93 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 84 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - tab2.col2 * tab2.col2 FROM tab2 WHERE - tab2.col2 * - tab2.col1 + + tab2.col1 IS NULL GROUP BY tab2.col2 HAVING NOT tab2.col2 IS NULL
;

SELECT DISTINCT tab1.col1 * + tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - tab1.col1 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + tab0.col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT + tab2.col1 + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col1 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 6 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + 40 * cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - - ( - tab0.col0 ) AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 24 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 95 AS col1 FROM tab2 GROUP BY col2

;

SELECT - cor0.col2 + + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 65 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 40 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT ALL - + col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 97 FROM tab2 GROUP BY tab2.col2

;

SELECT ( + 21 ) + - cor0.col2 * + ( + cor0.col2 * - cor0.col2 ) FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + cor1.col1 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1, cor1.col2

;

SELECT + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT ALL + 47 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 94 * - col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT ALL 84 * - 29 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + 83 + tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 18 * cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT tab0.col1 FROM tab0 WHERE NULL > NULL GROUP BY tab0.col1

;

SELECT + tab0.col1 * - 3 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + cor0.col0 + - 71 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col1 * + 44 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT cor0.col1 * + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 54 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 26 FROM tab2 GROUP BY tab2.col2

;

SELECT ( 86 ) * + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 90 + 70 * col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ( + cor0.col1 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT NULLIF ( cor0.col1, cor0.col1 ) * 54 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab2.col1 * - 98 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + tab2.col1 * tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + 20 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT cor1.col0 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - - 70 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 80 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - tab2.col0 * + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 8 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - - col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 30 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + - tab0.col0 - - tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 89 + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 56 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - CASE 9 WHEN - cor0.col1 THEN cor0.col1 WHEN - cor0.col0 THEN 43 * cor0.col0 WHEN + 67 THEN NULL END * + cor0.col0 - + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT DISTINCT 34 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 26 * cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col2

;

SELECT DISTINCT ( + 0 ) FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + tab2.col2 * + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - - 20 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + + 5 + 36 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 49 + col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - + 68 FROM tab0 GROUP BY tab0.col1

;

SELECT - + 24 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 82 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT - cor0.col1 * - 47 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT + + 74 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 17 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL cor0.col2 * + cor0.col0 + cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, col0

;

SELECT - cor0.col0 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT 2 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL cor0.col2 FROM tab0 cor0 GROUP BY col2

;

SELECT cor0.col0 + 76 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT 3 FROM tab2 GROUP BY tab2.col2

;

SELECT - 96 FROM tab0 GROUP BY col0

;

SELECT ALL - 61 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + 11 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col2 + col1 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT - 18 * - 37 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - col1 * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL 52 FROM tab0 AS cor0 GROUP BY col2, cor0.col1, cor0.col0

;

SELECT ALL tab0.col2 FROM tab0 GROUP BY tab0.col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT col1 FROM tab2 GROUP BY tab2.col1 HAVING NULL IS NOT NULL
;

SELECT col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT ALL - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING ( NULL ) IS NULL
;

SELECT ALL - col2 FROM tab2 GROUP BY tab2.col2 HAVING NULL <> NULL
;

SELECT DISTINCT + 80 * - col2 FROM tab2 GROUP BY col2

;

SELECT + 39 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 8 FROM tab2 GROUP BY col1

;

SELECT - 18 AS col0 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT 24 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 11 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT DISTINCT 26 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + + 50 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT ( 32 ) FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col0 * + col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL + 26 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 40 + cor0.col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL 90 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 74 + + cor0.col2 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT tab1.col1 - 93 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col1

;

SELECT 52 * - tab2.col1 + + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 22 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 80 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 16 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + + 46 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT 36 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + ( tab2.col0 ) AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT 27 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 64 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL col2 + 55 FROM tab0 AS cor0 GROUP BY cor0.col1, col1, cor0.col2

;

SELECT - col1 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 53 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 47 * + cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - - tab2.col1 * col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col2 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL tab2.col1 * - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col2 * cor0.col2 + 43 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 6 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 68 AS col1 FROM tab2 GROUP BY col0

;

SELECT ALL - 46 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 85 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 75 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab1.col0 * 28 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + + tab1.col1 + 62 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 57 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + col1 + - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + + tab0.col2 - 70 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - tab1.col2 + 18 AS col1 FROM tab1 GROUP BY col2

;

SELECT ALL cor0.col1 * - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL - tab1.col0 * + col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 29 AS col1 FROM tab2 GROUP BY col0

;

SELECT - tab1.col1 * + 80 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 63 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT DISTINCT - tab2.col0 + tab2.col0 * 84 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + - 20 + - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 4 FROM tab2 GROUP BY tab2.col0

;

SELECT + 79 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING NULL IS NOT NULL
;

SELECT - tab2.col2 AS col1 FROM tab2 WHERE NULL IS NULL GROUP BY tab2.col2 HAVING NOT NULL = NULL
;

SELECT - cor0.col1 + - ( cor0.col1 + cor0.col1 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 30 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 98 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT col1 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - 64 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col0 AS col1 FROM tab1 cor0 GROUP BY col0, cor0.col0

;

SELECT + ( - cor0.col0 ) * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT - 76 - tab2.col0 * + ( + tab2.col0 * + tab2.col0 ) FROM tab2 GROUP BY tab2.col0

;

SELECT + 50 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 * cor0.col2 - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT cor0.col0 * + cor0.col1 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL CASE tab2.col2 WHEN 44 THEN tab2.col2 * tab2.col2 WHEN - tab2.col2 * - 8 THEN NULL END AS col1 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + + 84 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - 71 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 22 FROM tab2 GROUP BY tab2.col2

;

SELECT 20 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - 72 + - tab0.col0 * + tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + - 95 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - + 14 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - cor0.col0 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT ALL - 3 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col0 - + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + + 63 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor1.col0 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0, cor0.col0

;

SELECT DISTINCT + 64 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 52 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 59 * + 67 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL + + 64 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 31 FROM tab2 GROUP BY col1

;

SELECT ALL + 42 FROM tab0 GROUP BY col1

;

SELECT + 0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 1 * col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 - col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - tab2.col2 * + 19 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT DISTINCT - col0 + cor0.col2 * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - cor0.col0 * + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 72 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - + tab0.col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL 44 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 88 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL ( tab1.col0 ) FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 83 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 48 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + + 1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + + 59 - - tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - tab1.col0 * 63 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col2 * col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + cor0.col2 + + cor0.col1 * + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 89 - + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 44 FROM tab0 AS cor0 GROUP BY col2

;

SELECT cor0.col1 * 42 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + - 36 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 86 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + tab2.col2 * - col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + 86 * col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 49 FROM tab2 GROUP BY col0

;

SELECT - + 44 + col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 52 + tab2.col2 * - ( - 78 ) AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 55 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - tab0.col2 + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 87 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + + col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + 86 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - 10 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0, cor0.col1

;

SELECT ALL 31 * - 23 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT col1 * - cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + cor0.col1 + cor0.col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT - 1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 37 * - 30 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT + + tab1.col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT + 68 FROM tab2 cor0 GROUP BY cor0.col1, col0

;

SELECT COALESCE ( + ( cor0.col1 ), - cor0.col2 + - cor0.col2 ) FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 97 * + 55 + - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT DISTINCT + + 98 * 41 FROM tab0 GROUP BY col1

;

SELECT - tab1.col0 * col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 87 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT 43 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 21 * - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT - + 49 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + + 76 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 8 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 + - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL 28 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 96 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - - 43 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 61 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - 83 * - 25 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 55 FROM tab2 GROUP BY tab2.col2

;

SELECT - 38 + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT col2 AS col0 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT 60 - + 72 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL tab2.col2 * - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - - tab2.col1 FROM tab2 GROUP BY col1

;

SELECT cor0.col0 + 9 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 59 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL 34 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 29 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 32 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 77 + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 3 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 51 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT - 88 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 68 AS col0 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT 35 * cor0.col1 - + 52 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1, cor0.col0, cor0.col2

;

SELECT tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1 HAVING NULL IS NOT NULL
;

SELECT cor0.col1 + col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0 HAVING NOT NULL IS NULL
;

SELECT DISTINCT tab1.col0 * + 89 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - cor0.col2 + + cor0.col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - - 96 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 46 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - + 51 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 93 - - cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING - col2 IS NULL
;

SELECT tab2.col2 * - tab2.col2 AS col1 FROM tab2 WHERE NULL = + tab2.col0 GROUP BY col2 HAVING NOT - col2 IS NULL
;

SELECT ALL + 57 FROM tab0 GROUP BY tab0.col2

;

SELECT tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING NOT NULL IS NULL
;

SELECT cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col2, cor0.col1

;

SELECT ALL + cor0.col1 + + cor0.col1 * + 55 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - 34 - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + - tab2.col2 * - 77 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 68 * cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + 99 * 51 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 80 + + col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 63 - - cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - col0 - tab1.col0 AS col0 FROM tab1 GROUP BY col0 HAVING ( NULL ) IS NULL
;

SELECT - tab1.col0 - + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + tab2.col2 AS col0 FROM tab2 WHERE NOT ( tab2.col0 / + tab2.col0 ) = NULL GROUP BY col2

;

SELECT ALL + col2 FROM tab0 GROUP BY tab0.col2 HAVING NULL BETWEEN NULL AND col2
;

SELECT tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2 HAVING NOT NULL IS NULL
;

SELECT - - 78 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 76 - - 9 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 21 * - cor0.col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + 43 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT 66 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab1.col1 FROM tab1 WHERE NOT ( NULL ) NOT BETWEEN ( - tab1.col1 / + tab1.col1 ) AND + tab1.col0 GROUP BY tab1.col1

;

SELECT - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NULL
;

SELECT + col2 + - 3 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING - tab2.col1 IS NULL
;

SELECT DISTINCT + 35 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + 74 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 70 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL tab1.col0 * + col0 + tab1.col0 AS col1 FROM tab1 WHERE NOT col2 + col1 BETWEEN ( NULL ) AND + tab1.col1 GROUP BY col0 HAVING NOT NULL IN ( + tab1.col0 )
;

SELECT 93 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - 76 - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + 80 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT ( cor0.col0 ) * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + ( - 55 ) * + col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - tab2.col2 - - tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING NULL IS NULL
;

SELECT DISTINCT 60 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 94 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 33 * cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 7 + - tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - - 85 * 51 FROM tab2 GROUP BY tab2.col1

;

SELECT 56 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - 41 - col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 27 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 40 FROM tab2 GROUP BY tab2.col2

;

SELECT tab1.col1 - - tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1 HAVING ( NULL ) IN ( tab1.col1 )
;

SELECT DISTINCT col1 - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 45 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT col0 AS col2 FROM tab0 GROUP BY col0 HAVING NULL IS NULL
;

SELECT 50 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT 33 FROM tab2 GROUP BY tab2.col2

;

SELECT + cor0.col0 + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col1 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NOT NULL
;

SELECT - + 52 + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + + col0 + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - 4 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL 75 + + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT cor0.col1 + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT tab1.col2 FROM tab1 WHERE NOT NULL IS NULL GROUP BY tab1.col2

;

SELECT DISTINCT 84 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - tab1.col0 FROM tab1 GROUP BY tab1.col0 HAVING ( NULL ) > NULL
;

SELECT DISTINCT + 0 * cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + 25 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 90 * 78 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 94 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 23 * 74 AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab2.col0 * - ( - 1 ) FROM tab2 GROUP BY tab2.col0

;

SELECT + 85 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 * - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2 HAVING ( NULL ) IS NULL
;

SELECT DISTINCT tab0.col0 FROM tab0 WHERE NULL IS NOT NULL GROUP BY tab0.col0

;

SELECT tab2.col1 - tab2.col1 FROM tab2 WHERE NOT NULL IS NOT NULL GROUP BY tab2.col1

;

SELECT - 28 * - cor0.col2 - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + tab0.col0 + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - 82 + - tab2.col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT ALL 29 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 AS col0 FROM tab0 AS cor0 WHERE col1 NOT IN ( + cor0.col2 ) GROUP BY col1

;

SELECT DISTINCT + cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2 HAVING ( NULL ) NOT IN ( cor0.col2 )
;

SELECT col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT ALL - 46 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - tab0.col0 AS col0 FROM tab0 WHERE tab0.col0 * + tab0.col2 IS NOT NULL AND NOT tab0.col1 NOT IN ( tab0.col2 ) GROUP BY tab0.col0

;

SELECT DISTINCT + tab0.col2 - - 60 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT 60 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT 12 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 * cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - ( ( col1 ) ) AS col2 FROM tab1 cor0 GROUP BY cor0.col1, col1

;

SELECT ALL 74 * + cor0.col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT - 9 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - col2 * tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - tab0.col0 FROM tab0 GROUP BY tab0.col0 HAVING NOT NULL > NULL
;

SELECT - 42 AS col0 FROM tab1 GROUP BY col2

;

SELECT - 6 * 7 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - col0 + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0 HAVING NULL <> NULL
;

SELECT ALL tab1.col2 * 86 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col1 + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 51 + + cor0.col1 * + col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - + tab1.col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1 HAVING NOT ( tab1.col1 ) IS NULL
;

SELECT DISTINCT 1 * - cor0.col0 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 23 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL 80 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + cor0.col1 FROM tab1 AS cor0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT + tab2.col0 AS col1 FROM tab2 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT tab1.col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT NULL IS NOT NULL
;

SELECT 72 AS col1 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - 49 * 38 FROM tab0, tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL - 8 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + tab0.col0 FROM tab0 WHERE col1 IS NULL GROUP BY col0 HAVING ( tab0.col0 ) IS NOT NULL
;

SELECT DISTINCT col2 FROM tab0 GROUP BY tab0.col2 HAVING NOT NULL IN ( tab0.col2 )
;

SELECT 88 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor1.col1 AS col1 FROM tab0 cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col1

;

SELECT ALL cor0.col0 * - 95 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 16 + + col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 42 + - tab0.col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - ( 27 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IN ( cor0.col2 )
;

SELECT + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT ( NULL ) IS NULL
;

SELECT tab2.col0 FROM tab2 GROUP BY tab2.col0 HAVING ( NULL ) NOT BETWEEN ( NULL ) AND NULL
;

SELECT DISTINCT + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0 HAVING ( NULL ) IS NULL
;

SELECT - - 96 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT - 14 + cor0.col0 * - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, col0

;

SELECT - 81 * - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 99 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 67 + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab0.col1 * tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1 HAVING NOT NULL IS NULL
;

SELECT - 86 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT 81 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 29 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 25 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col0 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - col1 AS col1 FROM tab1 GROUP BY tab1.col1 HAVING NULL IS NOT NULL
;

SELECT ALL NULLIF ( + cor0.col1, + cor0.col1 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL cor0.col2 + + 64 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL + cor0.col2 * 88 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 29 + - 99 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 9 + cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL 58 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + tab1.col0 FROM tab1 GROUP BY tab1.col0 HAVING NULL IS NOT NULL
;

SELECT 27 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + ( + tab2.col0 ) AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 22 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 + + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 + cor0.col2 * - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT cor0.col0 + + cor0.col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + tab0.col1 FROM tab0 WHERE NOT ( col2 ) IS NOT NULL GROUP BY tab0.col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT + cor0.col2 + - cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, col2, col0

;

SELECT + 34 FROM tab1 cor0 GROUP BY cor0.col0, col0

;

SELECT DISTINCT 60 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0

;

SELECT - - 56 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + + 3 + 73 FROM tab2 GROUP BY tab2.col0

;

SELECT - 40 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2, cor0.col0

;

SELECT ALL + 24 * - 86 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 7 + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NULL
;

SELECT - 70 * tab1.col0 + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 53 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + tab0.col2 - + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - - 30 AS col0 FROM tab1 GROUP BY col2

;

SELECT - 43 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 * - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2 HAVING col1 IS NULL AND NULL IN ( cor0.col2 )
;

SELECT ALL tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1 HAVING NULL IS NOT NULL
;

SELECT ALL - col0 + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT - col0 + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 43 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL + 27 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col1 FROM tab1 cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT - 4 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT 55 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT ALL cor0.col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NOT NULL
;

SELECT + - tab1.col0 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col1 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT + 20 FROM tab1 GROUP BY tab1.col1

;

SELECT - col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT tab2.col2 AS col1 FROM tab2 WHERE NOT + tab2.col2 < NULL GROUP BY tab2.col2

;

SELECT - tab2.col2 FROM tab2 WHERE NOT NULL IS NOT NULL GROUP BY tab2.col2

;

SELECT - tab1.col2 - + tab1.col2 FROM tab1 GROUP BY tab1.col2 HAVING ( NULL ) IS NOT NULL
;

SELECT DISTINCT 42 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 35 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 30 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col1 * tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING NOT NULL IS NOT NULL
;

SELECT ALL - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT - 23 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - + 6 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + cor0.col1 + cor0.col1 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 4 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING ( NULL ) IS NOT NULL
;

SELECT 87 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + ( cor0.col0 ) + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 12 FROM tab1 GROUP BY tab1.col0

;

SELECT 17 FROM tab1 cor0 GROUP BY col2

;

SELECT - 51 FROM tab2 GROUP BY col1

;

SELECT DISTINCT 41 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL cor1.col1 + cor1.col1 AS col0 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT + cor0.col1 * COALESCE ( 69, - cor0.col1 + + cor0.col1 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 51 FROM tab0 GROUP BY tab0.col0

;

SELECT - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 50 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 13 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 61 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 69 FROM tab0 GROUP BY tab0.col2

;

SELECT + tab1.col2 + - 98 * tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 64 * - tab2.col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT 95 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL NOT IN ( + cor0.col1 )
;

SELECT DISTINCT - tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING NOT + tab0.col1 = + tab0.col1
;

SELECT - - ( - tab1.col0 ) FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col0

;

SELECT 4 + - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 28 * + 52 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL + 9 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 63 + - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 34 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 48 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 20 AS col2 FROM tab1 GROUP BY col1

;

SELECT ALL cor0.col2 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT + 88 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 64 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 63 + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - tab0.col2 FROM tab0 WHERE NOT - tab0.col1 / tab0.col2 IS NOT NULL GROUP BY tab0.col2

;

SELECT DISTINCT - cor0.col2 * cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 95 * - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ( 95 ) * cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2 HAVING NULL IS NOT NULL
;

SELECT ALL cor0.col0 * + cor0.col0 + + col0 AS col0 FROM tab2 AS cor0 WHERE ( NULL ) IS NULL GROUP BY cor0.col0

;

SELECT ALL - 5 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + 38 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - tab0.col1 * tab0.col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + tab1.col2 FROM tab1 GROUP BY tab1.col2 HAVING ( NULL ) IS NOT NULL
;

SELECT - col2 FROM tab2 GROUP BY tab2.col2 HAVING ( NULL ) IS NOT NULL
;

SELECT DISTINCT - cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2, col1

;

SELECT cor0.col2 * - cor0.col2 + 93 * + col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 23 * cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL tab1.col1 AS col2 FROM tab1 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT ALL - 68 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col2 + col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NOT NULL
;

SELECT tab0.col1 FROM tab0 WHERE ( - tab0.col1 ) >= tab0.col0 + tab0.col2 GROUP BY tab0.col1

;

SELECT - 74 AS col1 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 76 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 3 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 80 - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - col0 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT tab0.col2 FROM tab0 GROUP BY tab0.col2 HAVING NULL NOT BETWEEN NULL AND ( NULL )
;

SELECT DISTINCT + cor0.col2 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - tab0.col2 FROM tab0 GROUP BY tab0.col2 HAVING NOT NULL IS NULL
;

SELECT - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT + 43 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 9 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 52 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT ALL cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT + - 94 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 46 + 32 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT col0 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - 84 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 75 FROM tab2 GROUP BY col2

;

SELECT - 5 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT 90 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - + cor0.col0 * 76 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 * - col0 + + 28 AS col1 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL + col2 + + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - tab1.col2 * - tab1.col2 + tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT + 90 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL cor0.col0 * cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - cor0.col2 * - col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - 41 - + 32 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL tab0.col2 * 74 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - cor0.col0 * col2 + + 77 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT - - tab0.col0 + tab0.col0 * + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 78 FROM tab0 cor0 GROUP BY col1

;

SELECT ALL cor0.col1 * 58 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - tab1.col0 FROM tab1 GROUP BY col0

;

SELECT tab1.col1 * + 82 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - 22 * + 52 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 * col0 + cor0.col0 * + 85 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 * + cor0.col0 + - 61 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL - 55 * + col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 * - cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2 HAVING NULL IS NULL
;

SELECT ALL tab1.col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL IS NULL
;

SELECT - 83 * tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - cor0.col0 * + cor0.col0 + - ( - 80 + + cor0.col0 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 15 + - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ( + 29 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col2, cor0.col1

;

SELECT - col1 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL ( - tab1.col2 ) AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 54 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 58 FROM tab2 GROUP BY tab2.col0

;

SELECT CASE 80 WHEN cor0.col0 THEN NULL WHEN + ( col0 ) THEN - cor0.col0 END + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - 76 + + cor0.col2 * 73 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT tab0.col1 * + tab0.col1 - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT cor0.col2 + + ( + cor0.col2 ) FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 70 - + 16 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 14 * tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + - tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + ( 59 ) AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 80 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - tab2.col1 * col1 + col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT tab0.col2 FROM tab0 WHERE NULL <> ( - col2 ) GROUP BY tab0.col2 HAVING + tab0.col2 + col2 NOT BETWEEN NULL AND NULL
;

SELECT + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col0

;

SELECT + cor0.col0 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col0

;

SELECT 84 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 28 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - - 71 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL ( COALESCE ( 45, + col0 ) ) * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col0

;

SELECT + 78 + - tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + col1 FROM tab0 GROUP BY col1 HAVING NOT NULL NOT IN ( + tab0.col1 * + tab0.col1 )
;

SELECT NULLIF ( - col2, + cor0.col2 ) * col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 56 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col0 - 8 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL - 64 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 97 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL + 22 + + cor0.col0 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 39 - 18 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT ALL col1 FROM tab1 AS cor0 GROUP BY col0, cor0.col2, cor0.col1

;

SELECT ALL - 14 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL - 85 * + tab2.col2 - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - - tab1.col1 - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - cor0.col0 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - + col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 22 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 52 + + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 63 * + 75 + - cor0.col1 * 85 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - - tab2.col2 + + col2 FROM tab2 GROUP BY col2

;

SELECT ALL 28 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - cor0.col0 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0 HAVING NULL IN ( col0 )
;

SELECT ALL 99 * cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 * + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 55 - tab1.col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT - 2 + 47 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ( col1 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 75 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 89 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 4 FROM tab1 GROUP BY tab1.col0

;

SELECT 53 FROM tab0 GROUP BY tab0.col2

;

SELECT col1 * 45 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - 15 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 33 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + 24 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 22 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING NULL IS NOT NULL
;

SELECT col2 + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING NULL IS NULL
;

SELECT 84 + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 * 32 + - cor0.col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 91 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - ( + tab0.col0 ) AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - cor0.col1 + cor0.col1 * - col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 40 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT + 35 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col0 * 7 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL - + 65 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL 25 + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + 60 - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 33 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col0 + + 82 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 67 + - cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - + col1 * 96 FROM tab0 GROUP BY col1

;

SELECT ALL - - 86 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 57 * + 5 + - tab2.col0 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 15 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 84 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT tab0.col2 * - tab0.col2 AS col0 FROM tab0 WHERE NULL > NULL GROUP BY tab0.col2 HAVING ( NULL ) NOT IN ( col2 )
;

SELECT 73 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 47 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT tab2.col1 * tab2.col1 AS col1 FROM tab2 GROUP BY col1 HAVING ( - tab2.col1 + tab2.col1 ) IS NOT NULL
;

SELECT ALL 37 * cor0.col2 AS col1 FROM tab1 cor0 GROUP BY col2, cor0.col1

;

SELECT 93 * cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT - - tab0.col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT - cor0.col2 * - 22 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - + ( + tab2.col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 28 * - col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + ( + col0 ) FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - NULLIF ( + 29, cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 5 + cor0.col0 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 45 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col2 * col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT DISTINCT 14 * 60 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 75 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 89 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor0.col1

;

SELECT DISTINCT - cor1.col1 * + cor1.col1 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL cor0.col1 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 97 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col0, cor0.col0

;

SELECT col2 + - cor0.col0 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT 84 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL cor0.col2 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + 99 FROM tab2 GROUP BY tab2.col1

;

SELECT + tab2.col1 + col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT 46 - 84 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT NULLIF ( 33, + cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1 HAVING NULL IS NULL
;

SELECT + col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING col1 IS NULL
;

SELECT DISTINCT 39 * cor0.col1 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT ALL + 27 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 2 + - 55 * cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 21 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab1.col1 - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col0 AS col1 FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 3 FROM tab0 GROUP BY col1

;

SELECT - - tab2.col1 + + 7 FROM tab2 GROUP BY col1

;

SELECT ALL + 0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL col2 * tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + 26 FROM tab0 GROUP BY tab0.col2

;

SELECT NULLIF ( 31, tab1.col1 + + tab1.col1 ) AS col2 FROM tab1 GROUP BY col1

;

SELECT - 58 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - 98 * + cor0.col1 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT DISTINCT - 53 + + 12 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - 61 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col2 FROM tab1 cor0 GROUP BY col2, cor0.col1, cor0.col2

;

SELECT DISTINCT - - tab0.col2 * tab0.col2 FROM tab0 GROUP BY col2

;

SELECT ALL + 5 + tab1.col1 * col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 93 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + + 56 FROM tab2 GROUP BY tab2.col0

;

SELECT + 32 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 32 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + 47 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - tab2.col2 * - tab2.col2 FROM tab2 GROUP BY col2

;

SELECT - - 3 FROM tab1 GROUP BY tab1.col2

;

SELECT NULLIF ( - cor0.col2, 30 * cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + col0 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT + 69 * 62 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 10 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1

;

SELECT - 56 + + tab2.col2 * tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + cor0.col0 * 27 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 71 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT + 42 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT 15 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 23 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL col2 * - col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 46 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT + cor0.col1 + - cor0.col1 * col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + + col1 + - tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 65 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - tab1.col2 FROM tab1 GROUP BY tab1.col2 HAVING col2 * + tab1.col2 IS NULL
;

SELECT 39 FROM tab0 GROUP BY tab0.col2

;

SELECT + 50 * - col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 97 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - tab0.col1 + - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 90 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col2

;

SELECT ALL 40 + tab2.col1 FROM tab2 GROUP BY col1

;

SELECT ALL + 95 FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT + 51 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 52 * 40 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL - cor0.col0 + - cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL 57 * tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL tab1.col0 + 93 AS col1 FROM tab1 GROUP BY col0

;

SELECT + tab1.col2 * 14 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col0, cor0.col2

;

SELECT - - cor0.col0 AS col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 + - 18 * - col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col2, col1

;

SELECT ALL + 50 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + col1 + - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col1, cor0.col1

;

SELECT + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2, cor0.col2

;

SELECT ALL cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT 37 - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col1 * cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 81 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 53 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - 48 * tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 19 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 77 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + cor0.col2 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 71 AS col1 FROM tab0 GROUP BY col2

;

SELECT ALL - - 3 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - tab1.col2 * tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + - 81 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col0 - col0 * col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - + 0 - cor0.col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 66 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 24 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 * - ( cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 16 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 69 + - 14 * + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 27 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT - 21 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 84 FROM tab0 cor0 GROUP BY col1, cor0.col1

;

SELECT DISTINCT - 1 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + 17 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT 67 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - 18 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 48 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + tab2.col1 * - col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col2 * + cor0.col2 - - ( + cor0.col2 ) AS col1 FROM tab1 cor0 GROUP BY col2

;

SELECT DISTINCT - + 83 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT + 23 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 56 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - + 22 FROM tab1 GROUP BY tab1.col1

;

SELECT - tab1.col2 * tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 7 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - 92 AS col1 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + 86 * - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL - 42 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + tab1.col0 * - 81 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col0 * 15 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ( + cor0.col0 ) AS col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - cor0.col0 AS col1 FROM tab1 cor0 GROUP BY col0

;

SELECT + 18 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 32 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 84 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 46 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col0, col1

;

SELECT - 91 AS col0 FROM tab0, tab0 AS cor0 GROUP BY tab0.col0

;

SELECT DISTINCT + 16 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 34 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor0.col1

;

SELECT ALL 98 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 65 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + 91 + + 89 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 33 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + + tab2.col0 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 8 * tab2.col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT - 58 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab1.col0 * - 83 + tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 88 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 98 FROM tab1 GROUP BY col1

;

SELECT - 87 + - 51 FROM tab1 GROUP BY col2

;

SELECT cor0.col0 * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NULL
;

SELECT 44 AS col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col2, col1

;

SELECT ALL - 32 FROM tab1 GROUP BY tab1.col2

;

SELECT tab2.col0 AS col1 FROM tab2 WHERE ( tab2.col2 ) >= - tab2.col2 GROUP BY tab2.col0

;

SELECT ALL cor0.col2 + cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col2

;

SELECT DISTINCT + 56 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col0 * - cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT cor1.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT ( 72 ) AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - 59 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 52 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - - 95 * + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT tab2.col2 FROM tab2 WHERE NULL = + tab2.col2 * - col2 GROUP BY col2

;

SELECT tab2.col1 + col1 FROM tab2 GROUP BY col1

;

SELECT - tab2.col0 + ( 17 ) FROM tab2 GROUP BY tab2.col0

;

SELECT ALL ( - cor0.col2 ) AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + tab1.col0 + - tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 82 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 64 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - ( + 40 ) AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT - 32 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 95 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + col0 * tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - + 64 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 62 FROM tab2 GROUP BY tab2.col2

;

SELECT 64 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 98 + - cor0.col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL ( + 36 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - - 21 FROM tab2 GROUP BY tab2.col0

;

SELECT + + tab0.col1 + tab0.col1 FROM tab0 GROUP BY col1

;

SELECT 0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 9 * - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 37 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 59 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 96 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 85 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + 36 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab0.col2 FROM tab0 GROUP BY tab0.col2 HAVING NOT NULL > ( NULL )
;

SELECT tab1.col0 * - tab1.col0 AS col2 FROM tab1 WHERE - tab1.col2 - tab1.col2 NOT IN ( tab1.col1 ) GROUP BY tab1.col0

;

SELECT col0 * cor0.col0 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT + cor0.col2 + 38 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - + tab2.col0 - col0 * - 37 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 25 AS col1 FROM tab2 cor0 GROUP BY col1

;

SELECT - 75 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 91 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT + 24 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col1, col2

;

SELECT cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT + 75 AS col2 FROM tab0 GROUP BY col0

;

SELECT DISTINCT - + 24 FROM tab1, tab2 cor0 GROUP BY cor0.col0

;

SELECT + 5 FROM tab1 GROUP BY tab1.col0

;

SELECT + 28 FROM tab2 GROUP BY tab2.col0

;

SELECT - tab2.col2 + 70 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL col0 * + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - 55 + + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - 50 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + tab1.col2 * tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col2 + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 48 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - col1 + tab0.col1 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 26 FROM tab0 GROUP BY tab0.col1

;

SELECT 38 * cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 62 * tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - cor0.col1 + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 75 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT col2 + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT col0 * + 91 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + cor0.col1 - + 56 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 96 + + tab2.col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - 94 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 37 * 13 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + + 97 FROM tab1 GROUP BY tab1.col0

;

SELECT - ( 52 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 28 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 32 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - + 13 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + - 63 AS col1 FROM tab0 GROUP BY col0

;

SELECT - 76 * - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + col1 AS col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT NULL IS NOT NULL
;

SELECT 69 + + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 43 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - ( 4 ) FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 23 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 37 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 89 * col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 1 * + col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT - 73 FROM tab1 GROUP BY col1

;

SELECT ALL - 1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 45 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT ALL cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 50 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + - 11 * + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col1 + - 52 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 50 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 23 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 42 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT 12 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + col1 * 24 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 76 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 6 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT ALL 45 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + + 92 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + 36 FROM tab0 GROUP BY col1

;

SELECT ALL - ( 90 ) AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + tab2.col2 * + tab2.col2 AS col0 FROM tab2 GROUP BY col2 HAVING NOT tab2.col2 <> NULL
;

SELECT ALL + col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - tab1.col1 * col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT tab1.col0 + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 55 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor1.col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor1.col1

;

SELECT - cor0.col1 + col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - + 79 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + col0 FROM tab0 GROUP BY tab0.col0 HAVING NOT NULL IS NULL
;

SELECT + CASE 98 WHEN cor0.col0 THEN col0 END FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL - + 18 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT col0 AS col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL 30 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 70 AS col1 FROM tab1 GROUP BY col2

;

SELECT cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1, col1

;

SELECT + 41 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 83 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + + tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 40 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL + 54 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT tab1.col1 * tab1.col1 - 57 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT 69 AS col1 FROM tab0 cor0 GROUP BY col2

;

SELECT - tab1.col1 - - col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col0 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 61 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 14 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 55 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 3 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - + tab0.col1 + col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 78 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 69 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 31 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 68 + - 52 * + tab1.col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT cor0.col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col1, col2

;

SELECT ALL 5 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab0.col2 * - 86 FROM tab0 GROUP BY tab0.col2

;

SELECT + 59 * 28 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 12 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT - - 40 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 69 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL ( cor0.col0 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - - 48 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 32 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 48 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT 29 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col0 * - 90 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT col0 - - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT 19 * 1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 + - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + 91 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 51 + + 81 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 84 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT - 29 + 30 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col0 * - col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + 14 * - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + ( tab0.col0 ) AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 62 FROM tab2 GROUP BY tab2.col0

;

SELECT - 7 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 98 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - + 7 FROM tab1 GROUP BY tab1.col1

;

SELECT - - tab0.col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - - 79 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + cor0.col2 AS col2 FROM tab2 cor0 GROUP BY col0, cor0.col2

;

SELECT tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0 HAVING NOT NULL IS NOT NULL
;

SELECT + cor0.col0 * 20 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 50 FROM tab1 GROUP BY tab1.col1

;

SELECT 40 + cor0.col2 * + 15 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 77 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col0

;

SELECT tab2.col1 FROM tab2 WHERE ( + tab2.col2 ) NOT IN ( - tab2.col1 ) GROUP BY tab2.col1

;

SELECT DISTINCT - 39 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 + 11 * 68 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + - 53 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + + 3 * ( 81 ) FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + tab0.col2 + ( 3 ) FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 33 FROM tab1 GROUP BY col0

;

SELECT ( - cor0.col0 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 95 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 93 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 * cor0.col0 + 31 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, col0

;

SELECT ALL 97 - - 95 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2 HAVING + col2 IS NOT NULL
;

SELECT DISTINCT - 82 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 17 * - cor0.col2 + 31 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NOT NULL
;

SELECT ALL cor0.col0 + 22 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 49 * tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 65 + - tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1, col1

;

SELECT - + 57 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 78 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + 24 * 90 + + cor0.col0 * + 0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 FROM tab0 cor0 GROUP BY col1, cor0.col0, cor0.col0

;

SELECT cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NOT NULL
;

SELECT - + tab2.col0 * - 11 FROM tab2 GROUP BY col0

;

SELECT ALL - cor0.col2 * - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT cor0.col2 FROM tab0 cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT + cor0.col0 * - 64 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 88 + + 7 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 9 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, col1

;

SELECT ALL - 68 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + cor0.col1 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 92 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT 52 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 * + cor0.col1 + col0 AS col1 FROM tab0 cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT - 58 - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + 57 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 0 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL 54 - + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + cor0.col0 * cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 29 FROM tab1 GROUP BY tab1.col1

;

SELECT + + col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT NULL IS NULL
;

SELECT ALL + 26 AS col1 FROM tab0 GROUP BY col2

;

SELECT col0 * cor0.col0 + + 14 * + 24 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 * 99 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING NOT NULL IS NULL
;

SELECT cor0.col0 * - col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + - 3 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + 6 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col2 + - 86 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 88 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + tab0.col2 * tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT 85 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - + col0 * 26 - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - tab2.col2 * - 65 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL col0 + + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col2, cor0.col2

;

SELECT ALL + cor0.col1 * + cor0.col0 + 35 AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT - cor0.col1 + col1 * - cor0.col1 AS col1 FROM tab2 cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT tab1.col2 + - tab1.col2 * - tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT DISTINCT cor0.col2 * + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT 58 + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT 78 + - cor1.col1 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT + 2 FROM tab2 GROUP BY col0

;

SELECT ALL ( 45 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 * - 30 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 11 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT + tab2.col0 - tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + tab1.col0 + + tab1.col0 * 56 FROM tab1 GROUP BY tab1.col0

;

SELECT - + 32 AS col2 FROM tab2, tab2 AS cor0 GROUP BY tab2.col0

;

SELECT + - 93 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL + cor0.col1 * col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 28 AS col2 FROM tab2 cor0 GROUP BY col2

;

SELECT - - 92 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col1 - 37 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 84 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + 72 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - cor0.col1 - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT tab0.col2 + tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 15 AS col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT 62 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT tab0.col2 * + 1 - 60 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - + 97 * + col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + col1 + - 47 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT tab1.col1 * - 34 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col1 * - 75 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL CASE - 27 WHEN + col2 THEN 80 + cor0.col2 END AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 6 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + - 17 + + 40 FROM tab2 GROUP BY col1

;

SELECT cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, col0

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - cor0.col2 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - col1 * + 58 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + + 68 + + 28 FROM tab2 GROUP BY col1

;

SELECT ALL + 42 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT NULLIF ( - cor0.col0, cor0.col0 / + COALESCE ( 79, col0, cor0.col0 * + 59 + cor0.col0 ) ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 19 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 18 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING col2 IS NOT NULL
;

SELECT + col2 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NOT NULL
;

SELECT ALL 61 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 10 + + cor0.col0 * cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + + col1 + + tab0.col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - 68 - + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 33 FROM tab0 GROUP BY tab0.col1

;

SELECT - - 4 * 13 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col0 * 79 + - 7 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 6 * 81 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 94 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT 46 * col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 92 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 38 + + 65 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT 33 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - tab2.col0 FROM tab2 GROUP BY tab2.col0 HAVING NULL BETWEEN NULL AND NULL
;

SELECT 85 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 71 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - 26 * 97 FROM tab2 GROUP BY tab2.col0

;

SELECT + COALESCE ( + 18, + tab0.col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT - 96 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT tab1.col1 FROM tab1 GROUP BY tab1.col1 HAVING NULL > NULL
;

SELECT ALL cor0.col2 + - 83 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 52 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT 89 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT 13 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT ALL - 10 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col0, col1

;

SELECT 7 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 61 FROM tab2 GROUP BY tab2.col1

;

SELECT + 30 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 44 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT 5 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT col2 * + col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + cor0.col0 * - col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - cor0.col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col2, col0

;

SELECT - cor0.col1 + + cor0.col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + 54 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT - tab0.col1 + + tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 97 * cor0.col0 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT 32 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - NULLIF ( - 35, - cor0.col1 + + 56 ) AS col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT - col1 * - tab1.col1 + - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 79 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL 20 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + - tab2.col0 * 94 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col0 * - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NULL IS NOT NULL
;

SELECT 25 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 68 * + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 59 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - 43 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 49 FROM tab2 AS cor0 GROUP BY col1, cor0.col1

;

SELECT - col2 FROM tab0 WHERE NOT tab0.col1 * tab0.col1 + - col1 IS NOT NULL GROUP BY tab0.col2

;

SELECT DISTINCT + + 75 FROM tab0 GROUP BY tab0.col1

;

SELECT + - tab1.col2 + - 72 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 86 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor1.col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT - 72 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - 52 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + cor0.col0 + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 95 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 7 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - cor0.col0 - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 + - 10 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + - 24 * + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT - 25 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + ( + cor0.col1 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 - - cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL + 31 * 70 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + tab2.col1 * + tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING NOT NULL IS NOT NULL
;

SELECT - col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL cor0.col2 * 77 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - 13 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + - 43 * + cor0.col2 FROM tab1 cor0 GROUP BY col1, cor0.col2

;

SELECT ALL - 38 * cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + ( + 41 ) AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL - 21 + 98 * col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 83 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL tab0.col0 FROM tab0 GROUP BY tab0.col0 HAVING NULL IS NOT NULL
;

SELECT DISTINCT cor0.col1 - cor0.col1 * - cor0.col1 AS col2 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT 79 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT NULLIF ( cor0.col2, - col2 ) + 40 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 31 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT 23 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + ( + 31 ) FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT cor0.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor1.col1

;

SELECT + cor0.col2 * + 46 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 6 AS col1 FROM tab1 cor0 GROUP BY col0

;

SELECT 35 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col0 * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + ( - 52 ) FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + ( - 3 ) FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + ( col0 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + cor0.col1 * 54 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 44 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL - tab0.col0 FROM tab0 GROUP BY tab0.col0 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - 49 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 + cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col1

;

SELECT ALL + 86 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 58 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - 14 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT cor0.col1 * + cor0.col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT + 66 + + cor0.col2 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor0.col2

;

SELECT - col0 AS col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT - cor0.col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - cor0.col1 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL tab1.col0 - - 43 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 36 - 63 * - 57 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT 75 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 66 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 38 FROM tab0 GROUP BY tab0.col0

;

SELECT + 46 + 73 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col2 * - 83 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col0 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL tab2.col0 * 66 AS col0 FROM tab2 GROUP BY col0

;

SELECT 39 FROM tab0 cor0 GROUP BY col1

;

SELECT - + 74 FROM tab2 GROUP BY tab2.col1

;

SELECT + tab1.col2 AS col0 FROM tab1 GROUP BY col2 HAVING NULL IN ( + tab1.col2 )
;

SELECT - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL + tab0.col2 + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL col2 FROM tab1 cor0 GROUP BY col2

;

SELECT + 91 * - 83 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - - 47 * + col1 FROM tab2 GROUP BY col1

;

SELECT + cor0.col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col1, cor0.col1

;

SELECT - 46 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT 23 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT 27 * + tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 19 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + 77 + + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + - 71 + - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + + 27 FROM tab1 GROUP BY tab1.col2

;

SELECT + 36 FROM tab1 GROUP BY tab1.col2

;

SELECT + 70 * - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - + 12 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ( - 96 ) FROM tab0 GROUP BY tab0.col1

;

SELECT + col1 + - col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 65 + col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 50 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 96 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 84 + tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - + col0 * tab2.col0 FROM tab2 GROUP BY col0

;

SELECT ALL cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col0

;

SELECT DISTINCT 5 + + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - 98 * col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 60 * + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + ( + 99 ) FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL 77 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT + 34 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - col0 * 24 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 42 * + cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 73 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( 9 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 80 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 82 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + - tab1.col2 + 16 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 58 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - - 4 * - 95 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col1, cor0.col0

;

SELECT ALL + + 41 * col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 75 + - 97 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT col2 * col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 70 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 86 * + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT col1 + 16 * 4 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 69 * - col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 5 * 82 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + tab1.col2 * 23 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + col1 * - cor0.col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ( - 41 ) + col2 FROM tab0 GROUP BY col2

;

SELECT + tab1.col1 FROM tab1 WHERE ( col1 ) IN ( tab1.col0 ) GROUP BY tab1.col1

;

SELECT DISTINCT + tab0.col0 * tab0.col0 + tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 31 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - tab0.col2 - 27 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + 2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - col1 + col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - ( + tab1.col1 ) FROM tab1 GROUP BY tab1.col1

;

SELECT + 94 * + 24 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 21 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 32 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 9 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - - 67 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col1 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT cor0.col2 - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 18 * 56 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT + 64 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + 42 * 47 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 24 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 25 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 46 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 31 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT + 75 + + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 38 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + - 50 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + - NULLIF ( 92, - tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 68 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col0 * - 37 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 63 - 4 * + cor0.col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col1, cor0.col0

;

SELECT ALL + 63 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 61 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + 27 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 55 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT tab1.col0 FROM tab1 GROUP BY tab1.col0 HAVING NOT NULL IS NULL
;

SELECT DISTINCT tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0 HAVING NOT + tab0.col0 IS NOT NULL
;

SELECT + ( - col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor1.col0 + + cor1.col0 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + 72 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 3 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 91 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT + 59 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT 60 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + 48 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 13 + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col0 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - 36 * - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + + 82 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 83 AS col2 FROM tab0 GROUP BY col0

;

SELECT ALL - col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 10 + col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 33 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 93 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 93 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col2 + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT 31 * col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT - - 75 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - 55 FROM tab0 GROUP BY tab0.col0

;

SELECT - - 79 FROM tab0 GROUP BY tab0.col1

;

SELECT 74 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 81 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + 4 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab2.col0 - - 29 AS col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT 91 * - 64 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 3 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 2 + - 3 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - ( - cor0.col2 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 54 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor1.col0

;

SELECT DISTINCT + cor0.col0 * cor0.col2 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + - 10 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 70 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 67 FROM tab2 GROUP BY tab2.col1

;

SELECT - - 14 FROM tab2 GROUP BY tab2.col2

;

SELECT - 2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 79 AS col1 FROM tab2 GROUP BY col2

;

SELECT ALL + 4 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 - 21 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - - 97 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 14 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING ( NULL ) IS NULL
;

SELECT - 34 FROM tab1 GROUP BY col1

;

SELECT + cor0.col1 + - 55 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 26 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 77 * - 77 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + 57 AS col2 FROM tab0, tab2 AS cor0 GROUP BY tab0.col0

;

SELECT DISTINCT - tab2.col1 * + tab2.col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - 46 + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT 83 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1 HAVING NOT NULL >= ( NULL )
;

SELECT DISTINCT + 80 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col0 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0, cor0.col1

;

SELECT DISTINCT 41 * - 6 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + cor0.col2 * - cor0.col1 FROM tab0 cor0 GROUP BY col2, cor0.col1, cor0.col0

;

SELECT ALL 14 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 16 FROM tab1 GROUP BY tab1.col0

;

SELECT ( + 75 ) + 0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT + cor0.col1 + 76 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 + col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - 62 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL tab1.col0 + tab1.col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT - 94 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT - 8 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + col2 + + 19 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 4 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 15 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor0.col1 * - 10 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - ( + 72 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - tab0.col0 * tab0.col0 FROM tab0 GROUP BY col0

;

SELECT ALL - - COALESCE ( - tab2.col1, - tab2.col1 ) * + 38 - - ( 68 ) AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT col2 * 8 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + - col0 - + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT + 45 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 3 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 41 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 93 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + 27 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NULL
;

SELECT DISTINCT + tab1.col2 * col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL IS NULL
;

SELECT ALL cor0.col1 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT col1 + - cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + + 27 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 51 + - tab0.col1 * - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 71 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 61 + + col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 22 * - 12 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 + + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 91 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ( - 93 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT ( cor0.col0 ) AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + 85 * + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, col0

;

SELECT cor0.col0 * + 22 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT COALESCE ( + cor0.col0, + ( - cor0.col0 ) ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 7 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + - 20 + 45 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 52 FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col0 * - cor0.col0 FROM tab1 cor0 GROUP BY col0

;

SELECT + 4 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL tab1.col1 * + tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 87 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + + 31 * + 98 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT COALESCE ( - cor0.col2, cor0.col2, + cor0.col2 ) - col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, col2

;

SELECT DISTINCT 60 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - - tab2.col0 + + col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col0 * + 77 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - - col2 + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 6 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL 41 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col1, cor0.col0

;

SELECT DISTINCT 15 AS col1 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + cor1.col0 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT 79 * - 67 FROM tab1 GROUP BY tab1.col0

;

SELECT + 91 * cor0.col2 - + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 95 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL tab0.col1 + 45 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 52 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - tab0.col1 * tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col0 + + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 40 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 86 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 38 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 14 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING NULL >= ( NULL )
;

SELECT - 44 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor1.col0

;

SELECT DISTINCT 98 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 81 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + col2 * - cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col2 * - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor1.col2 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2, cor0.col0

;

SELECT ALL 39 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + tab2.col1 FROM tab2 WHERE NOT col1 * tab2.col0 IS NULL GROUP BY tab2.col1

;

SELECT DISTINCT - + 60 FROM tab0 GROUP BY tab0.col1

;

SELECT - 71 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT + 8 AS col0 FROM tab2 GROUP BY col2

;

SELECT + tab1.col2 * + col2 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 64 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 76 * tab2.col2 - + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 66 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - ( - 70 ) AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL 58 + - 38 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 67 FROM tab0 GROUP BY tab0.col1

;

SELECT + - 54 + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + tab2.col1 + - tab2.col1 FROM tab2 GROUP BY col1

;

SELECT ALL 81 + 57 FROM tab1 GROUP BY tab1.col0

;

SELECT 31 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - + tab1.col1 + - tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - col2 FROM tab1 cor0 GROUP BY cor0.col2 HAVING NULL IN ( cor0.col2 + - cor0.col2 / cor0.col2 )
;

SELECT DISTINCT 17 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 67 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT - 70 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 69 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT - cor0.col1 + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 5 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT - 4 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + col1 FROM tab2 AS cor0 WHERE NOT ( NULL ) IN ( cor0.col2 ) GROUP BY cor0.col1

;

SELECT ALL - tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2 HAVING NULL IS NULL
;

SELECT - 35 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 75 * + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + - 47 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT 29 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL - cor0.col0 * + 68 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 84 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + + 95 + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + - 75 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - 88 + ( + col0 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 79 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 24 * cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 23 + + ( + cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - + ( - 28 ) AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 28 FROM tab0 GROUP BY col0

;

SELECT - tab2.col1 AS col2 FROM tab2 WHERE NOT NULL NOT IN ( + tab2.col0 ) GROUP BY tab2.col1

;

SELECT ALL col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 43 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT + + 49 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 59 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 50 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT 58 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab1.col1 + - 92 FROM tab1 GROUP BY tab1.col1

;

SELECT - + tab2.col0 FROM tab2 GROUP BY col0

;

SELECT ALL + 80 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 40 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col1 + - col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 + 91 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL - + 22 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + ( + cor0.col0 ) FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL - 89 - tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - tab0.col1 FROM tab0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - 19 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 56 FROM tab1 AS cor0 GROUP BY col1, cor0.col1

;

SELECT - 13 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 97 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 17 + 74 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col1 + 2 FROM tab2 cor0 GROUP BY cor0.col1, col1

;

SELECT 73 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL BETWEEN ( NULL ) AND ( NULL )
;

SELECT tab1.col0 + - col0 FROM tab1 GROUP BY col0 HAVING NOT ( tab1.col0 ) BETWEEN NULL AND ( NULL )
;

SELECT DISTINCT + 69 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + - 99 * tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT 3 FROM tab2 cor0 GROUP BY col0

;

SELECT + 29 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + tab2.col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT - + tab0.col2 + - 73 AS col1 FROM tab0 GROUP BY col2

;

SELECT 19 * - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col1 * 68 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 85 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 77 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + - ( 33 ) FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 92 FROM tab0 GROUP BY tab0.col0

;

SELECT + 84 + + tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT 16 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 19 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 37 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 39 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT tab1.col0 FROM tab1 WHERE NOT ( NULL ) BETWEEN NULL AND col1 GROUP BY tab1.col0

;

SELECT ALL tab2.col0 FROM tab2 GROUP BY tab2.col0 HAVING NOT tab2.col0 BETWEEN ( NULL ) AND NULL
;

SELECT ALL 63 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT ALL 79 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - CASE + cor0.col0 WHEN cor0.col2 + cor0.col0 THEN NULL WHEN cor0.col2 * 44 THEN cor0.col0 ELSE NULL END AS col0 FROM tab0 cor0 GROUP BY cor0.col0, col2, cor0.col2

;

SELECT DISTINCT + - 94 + + tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + 10 FROM tab1 GROUP BY tab1.col2

;

SELECT - 32 + + cor0.col1 * - col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + 26 FROM tab2 GROUP BY tab2.col1

;

SELECT - 51 FROM tab2 GROUP BY tab2.col2

;

SELECT + cor0.col0 * - 31 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 50 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - 12 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - - 54 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 72 * + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + + 45 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 80 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT 91 * 23 + - tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 37 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 7 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL col2 + + 36 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + 93 FROM tab2 GROUP BY col0

;

SELECT - + 16 * + 55 FROM tab1 GROUP BY tab1.col0

;

SELECT 21 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + tab2.col2 + col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - 0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL cor0.col1 - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + + 26 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 43 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT 6 - 59 FROM tab1 GROUP BY col1

;

SELECT 85 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + 55 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL cor0.col2 + + cor0.col2 * + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 41 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - col1 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL + + 26 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + tab1.col2 + - tab1.col2 FROM tab1 GROUP BY col2

;

SELECT ALL - 60 FROM tab1 GROUP BY col1

;

SELECT 98 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 97 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - tab2.col1 * + col1 + 0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - ( - 32 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + tab0.col2 * col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor1.col2 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col2

;

SELECT ALL 74 * 36 + - cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + - 46 * col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - - col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 33 * 70 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 52 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + tab1.col2 - + 96 * tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + tab1.col0 FROM tab1, tab2 AS cor0 GROUP BY tab1.col0

;

SELECT cor0.col1 * + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL >= NULL
;

SELECT DISTINCT + tab1.col2 FROM tab1 WHERE NULL IS NULL GROUP BY tab1.col2

;

SELECT - tab1.col0 * - 16 FROM tab1 GROUP BY tab1.col0

;

SELECT 92 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + - 25 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 79 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING NOT NULL IN ( tab2.col1 )
;

SELECT ALL tab2.col1 AS col0 FROM tab2 GROUP BY col1 HAVING NULL BETWEEN ( NULL ) AND col1
;

SELECT DISTINCT + + 19 FROM tab2 GROUP BY tab2.col1

;

SELECT - 58 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 74 * - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 21 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 67 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 56 FROM tab1 GROUP BY tab1.col0

;

SELECT 23 * + 71 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT tab1.col2 - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 43 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 43 AS col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col0

;

SELECT ALL cor0.col0 * + col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + - tab2.col1 - 95 FROM tab2 GROUP BY col1

;

SELECT - - tab2.col1 * 1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 9 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 78 * + 30 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 97 FROM tab2 GROUP BY tab2.col0

;

SELECT + ( 64 ) FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + - ( 87 ) AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 60 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - 13 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NOT NULL
;

SELECT 54 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 59 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1, cor0.col0

;

SELECT cor0.col1 AS col2 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT ALL - 11 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col0 * + col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 AS col0 FROM tab1 cor0 GROUP BY col2

;

SELECT + 10 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 26 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NULL
;

SELECT DISTINCT + 62 FROM tab0 AS cor0 GROUP BY col2

;

SELECT cor0.col0 * ( cor0.col1 ) + col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - cor0.col0 * 70 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 34 * - cor0.col0 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 96 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL - + 54 FROM tab2 GROUP BY tab2.col2

;

SELECT - 67 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 52 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 31 AS col0 FROM tab2 cor0 GROUP BY col2

;

SELECT 58 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 0 FROM tab0 GROUP BY tab0.col1

;

SELECT + 25 FROM tab1 GROUP BY col1

;

SELECT DISTINCT + 91 AS col0 FROM tab2, tab1 cor0 GROUP BY tab2.col1

;

SELECT 75 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - - 81 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 39 AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT 77 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL + + 88 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - - tab1.col2 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - col2 * - col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT tab0.col1 - tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col0 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NULL < NULL
;

SELECT 46 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 19 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor1.col2

;

SELECT ALL + 85 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - 66 * - tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 87 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 22 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - ( - 4 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 85 - - col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 87 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 35 + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 66 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 - cor0.col1 * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 91 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2, col1

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT 63 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col0, col2

;

SELECT DISTINCT + 72 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col0 + - cor0.col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT + + ( tab0.col2 ) AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT tab2.col2 * + 36 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col2 + col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 76 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + tab0.col0 * - 25 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL ( - cor0.col2 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + ( tab2.col1 ) * - tab2.col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT tab1.col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT - 50 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL 24 - 23 FROM tab2 GROUP BY tab2.col1

;

SELECT 27 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 8 * - cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col0

;

SELECT DISTINCT 6 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 26 - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + tab1.col0 * + col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT - 70 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - 43 FROM tab1 GROUP BY tab1.col2

;

SELECT - 54 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - - 25 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 67 AS col0 FROM tab1, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 33 * 36 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + 15 FROM tab1 GROUP BY tab1.col2

;

SELECT tab2.col2 + + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 26 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT + col0 + col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - col0 * cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL - 89 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 91 + + 54 * - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NULL
;

SELECT 57 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + - col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT ALL - COALESCE ( + 91, + 40, + tab1.col1 ) - 8 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 57 FROM tab0 GROUP BY tab0.col0

;

SELECT + 65 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL NULLIF ( 89, cor0.col1 / 61 ) + + 54 FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT - tab0.col1 + 52 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - tab2.col0 FROM tab2 WHERE NOT NULL <> - col2 GROUP BY tab2.col0

;

SELECT DISTINCT + tab0.col0 AS col0 FROM tab0 WHERE NULL IS NOT NULL GROUP BY tab0.col0

;

SELECT col1 * col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT CASE 13 WHEN 62 THEN NULL ELSE + cor0.col1 END AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 30 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT - - 39 FROM tab1 GROUP BY tab1.col1

;

SELECT - 34 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - 60 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + ( 15 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 54 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT + + tab1.col0 * tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col0 + + col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - ( 67 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 52 * tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 95 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT col0 FROM tab2 GROUP BY tab2.col0 HAVING NULL >= ( NULL )
;

SELECT - 49 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 63 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 54 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT 29 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - 12 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL 50 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - tab0.col1 * 30 FROM tab0 GROUP BY tab0.col1

;

SELECT - 7 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + cor0.col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL - cor0.col1 + cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 40 * - col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT tab1.col0 FROM tab1 GROUP BY tab1.col0 HAVING + tab1.col0 IS NULL
;

SELECT + col1 FROM tab0 WHERE NULL NOT IN ( tab0.col2 / - col0 ) GROUP BY tab0.col1

;

SELECT ALL - 94 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + cor0.col2 + + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 61 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 94 * + tab2.col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT ALL cor1.col1 + 88 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1

;

SELECT DISTINCT 64 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 + col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + ( - 30 ) AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - cor0.col2 + col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - tab0.col2 + 53 FROM tab0 GROUP BY col2

;

SELECT ALL + col1 AS col0 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT + - NULLIF ( - 34, + tab2.col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 37 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT - 97 * cor0.col1 + + 90 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 11 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 74 + + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 55 + + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 49 FROM tab1 cor0 GROUP BY col2

;

SELECT DISTINCT - 95 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab0.col2 * - 28 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - - 54 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT ( col2 ) FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + tab1.col0 * - tab1.col0 AS col1 FROM tab1 GROUP BY col0 HAVING tab1.col0 IS NOT NULL
;

SELECT ALL tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING NOT NULL = ( NULL )
;

SELECT DISTINCT tab0.col2 - 19 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 55 FROM tab0 GROUP BY col0

;

SELECT 3 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - col1 + - NULLIF ( + 40, cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 15 + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING NULL NOT IN ( tab0.col1 )
;

SELECT ALL + 6 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 * 97 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - 71 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 55 - tab1.col2 * 55 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - cor1.col0 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT + 34 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 * 33 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 59 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + 58 * 19 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 22 FROM tab0 GROUP BY tab0.col0

;

SELECT - + 73 * + tab1.col2 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 17 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 34 * - col1 + + tab2.col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT + 29 + - 36 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col0 + - cor0.col1 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT 8 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 13 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 * - 8 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 31 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - 90 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - cor0.col0 * cor0.col0 + - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - + 72 FROM tab0 GROUP BY col2

;

SELECT cor0.col1 - cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 85 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT tab0.col0 * + tab0.col0 AS col2 FROM tab0 WHERE NULL IS NOT NULL GROUP BY tab0.col0 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT + + 35 FROM tab2 GROUP BY tab2.col1

;

SELECT - 98 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + 78 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1 HAVING NULL IS NULL
;

SELECT tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2 HAVING tab1.col2 IS NOT NULL
;

SELECT DISTINCT + cor1.col0 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT ALL - 16 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col2

;

SELECT DISTINCT 30 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + - 67 - - tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ( 21 ) AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT + - 70 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 10 * col0 + + cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 14 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 26 FROM tab0 cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT - 71 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT + col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT + 10 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 48 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT 95 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL tab0.col0 + 31 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 68 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 66 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor1.col2 AS col0 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - tab2.col2 * - 45 FROM tab2 GROUP BY col2

;

SELECT DISTINCT ( + col1 ) FROM tab2 GROUP BY col1

;

SELECT + cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1 HAVING NULL IS NULL
;

SELECT DISTINCT - - tab2.col2 + - col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT ALL 10 AS col1 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + 77 FROM tab0 GROUP BY tab0.col2

;

SELECT tab2.col1 * + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - + 64 FROM tab1 GROUP BY tab1.col2

;

SELECT + + 35 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 82 FROM tab0 GROUP BY tab0.col2

;

SELECT + - 37 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - NULLIF ( - cor0.col1, - cor0.col0 - - 20 ) * - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col1, col0

;

SELECT ALL + 25 - - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 87 * - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + + 3 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 57 FROM tab0 GROUP BY tab0.col1

;

SELECT + + tab1.col2 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 71 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + 76 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 11 * 23 FROM tab0 GROUP BY col2

;

SELECT - + 43 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + cor0.col1 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 92 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 7 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - ( - 26 ) AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT 12 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL NULLIF ( 1, 88 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - COALESCE ( 89, + cor0.col1 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 7 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 68 + 63 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 71 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + + tab1.col1 - 16 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col0 * + 4 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + 30 + - 57 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 56 * + col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 14 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 43 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 57 * + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 14 * cor0.col1 - ( + 19 ) FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + 3 - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2 HAVING NOT + col2 > NULL AND NOT ( NULL ) IS NOT NULL
;

SELECT 54 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 50 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL cor0.col0 + cor0.col0 * cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 9 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 9 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 60 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 49 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 21 FROM tab1 GROUP BY tab1.col0

;

SELECT - 89 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 85 - 82 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 21 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 36 * col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 31 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + col0 * - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 59 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NULL
;

SELECT ALL - cor1.col1 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT - 45 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col0 - cor0.col0 * 32 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + 7 * 8 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 51 * tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col0 * - 93 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - + 54 + - 34 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 79 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - cor0.col2 - + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT 9 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 70 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - 45 + + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - tab1.col1 - - 33 * tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col2 + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + cor0.col1 + + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 92 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 * cor0.col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + tab2.col1 * ( + 37 ) AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - tab1.col1 + - tab1.col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT 17 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 67 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 * - ( 50 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - - 55 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL col1 * cor0.col1 + cor0.col1 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 80 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 27 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT NULLIF ( cor0.col0, + 79 ) * + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL - col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL tab2.col1 * tab2.col1 + + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - col1 + - col1 FROM tab2 GROUP BY col1

;

SELECT 31 FROM tab0 GROUP BY tab0.col2

;

SELECT ( 93 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + NULLIF ( - 64, cor0.col2 ) FROM tab0 cor0 GROUP BY cor0.col2, col0

;

SELECT ALL cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + cor0.col2 * cor0.col2 + + 11 AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - + col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT tab1.col0 * - 82 FROM tab1 GROUP BY col0

;

SELECT ALL - 47 * - col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT ( cor0.col0 ) * 31 + - cor0.col2 * 85 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 98 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 59 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL - 46 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0 HAVING ( NULL ) IN ( tab2.col0 )
;

SELECT col1 AS col0 FROM tab0 WHERE - col2 < NULL GROUP BY tab0.col1 HAVING NULL IS NULL
;

SELECT DISTINCT col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT - tab2.col1 * - tab2.col1 + + 4 * tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col0 + - 97 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 69 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 41 * tab2.col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT ALL - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + 36 FROM tab2, tab2 AS cor0 GROUP BY tab2.col1

;

SELECT DISTINCT + cor0.col1 * - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col2 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT + + tab0.col2 + tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT 82 FROM tab1 GROUP BY tab1.col0

;

SELECT + 28 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col1

;

SELECT DISTINCT - 65 - 52 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 46 + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 30 + - tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - - tab1.col2 + - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 5 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT tab0.col1 AS col0 FROM tab0 GROUP BY col1 HAVING NOT - tab0.col1 IS NULL
;

SELECT cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL - ( cor0.col1 ) FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 * - 6 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + 51 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 39 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT col0 + 54 FROM tab2 GROUP BY tab2.col0

;

SELECT ( + 10 ) FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col0 * 27 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 26 + - 32 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 22 * 86 AS col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT 28 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + + 43 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 73 FROM tab0 GROUP BY col1

;

SELECT - + 95 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 48 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 7 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 24 FROM tab0 GROUP BY tab0.col1

;

SELECT 96 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 36 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + cor0.col2 * cor0.col2 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 28 * - cor0.col2 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT - tab2.col1 - - 65 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 39 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - + 75 * - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - col1 * tab0.col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0 HAVING NOT NULL = ( NULL )
;

SELECT - 4 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 * 21 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 61 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 * + ( 35 ) AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT 97 * - cor0.col2 + - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT - 78 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col0 * - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 63 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 8 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 82 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 72 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col2 * 63 FROM tab1 cor0 GROUP BY col2

;

SELECT 56 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT 38 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT 43 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - 96 + 95 FROM tab2 GROUP BY col1

;

SELECT - 35 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + cor0.col2 * cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING ( NULL ) IS NOT NULL
;

SELECT DISTINCT - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 11 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL cor0.col2 + + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 43 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 31 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + 54 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + - 31 AS col0 FROM tab0 GROUP BY col1

;

SELECT ALL + 44 * 43 + cor0.col1 * + 80 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 0 * col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 - - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 * + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT col0 AS col2 FROM tab0 GROUP BY tab0.col0 HAVING NOT NULL IS NOT NULL
;

SELECT + 33 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 9 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - 8 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 49 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 13 + + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL NULLIF ( 79, cor0.col0 + + cor0.col0 ) FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL + tab1.col2 * 11 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + - 12 FROM tab2 GROUP BY tab2.col2

;

SELECT + 40 * + cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + 81 + 76 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 * 77 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - - 53 * - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 96 AS col1 FROM tab0 GROUP BY col2

;

SELECT ALL - 24 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 39 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT 86 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( + cor1.col2 ) * - cor1.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2, cor1.col0

;

SELECT - 47 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 77 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 21 + cor0.col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT - NULLIF ( + col0, cor0.col0 ) AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL - 17 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 19 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 10 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 88 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 13 FROM tab0 GROUP BY col2

;

SELECT ALL - tab1.col2 + + tab1.col2 * - tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT + 35 FROM tab2 GROUP BY tab2.col1

;

SELECT 55 - 85 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT tab1.col0 FROM tab1 GROUP BY tab1.col0 HAVING NULL IS NULL
;

SELECT ALL + 9 - - cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + 12 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - - ( 65 ) FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 22 * - cor0.col0 + + col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - NULLIF ( - cor0.col2, - col2 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - - 68 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 23 FROM tab1 GROUP BY col0

;

SELECT ALL - 35 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 36 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - - 26 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col1 + + 50 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - 46 + 70 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT + 47 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT 62 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + cor0.col1 * - cor0.col1 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING tab2.col1 IS NOT NULL
;

SELECT ALL - cor0.col1 - - cor0.col1 * + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 32 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 67 AS col1 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + 80 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - col1 * 2 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 79 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 55 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + cor0.col2 AS col1 FROM tab1 cor0 GROUP BY col2

;

SELECT ALL + cor0.col0 * - cor0.col0 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - + 51 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL col1 AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col0, cor0.col1

;

SELECT tab0.col1 FROM tab0 WHERE NULL IS NULL GROUP BY tab0.col1

;

SELECT + 18 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 77 * - cor0.col0 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT + 43 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 4 + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 31 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + 44 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT + 74 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - 63 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 36 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 2 - + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + - 65 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT + 42 * + 74 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 49 + - tab1.col0 * + 83 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 66 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + - tab2.col2 * - col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT 28 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 94 * 39 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + tab2.col1 FROM tab2 WHERE NULL IS NOT NULL GROUP BY col1

;

SELECT ALL + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT 38 * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - tab1.col0 AS col2 FROM tab1 WHERE + tab1.col0 IN ( - tab1.col0 - tab1.col2 ) AND - tab1.col0 * tab1.col0 IN ( + tab1.col1 ) GROUP BY col0

;

SELECT + cor1.col1 * - 11 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1, cor1.col0

;

SELECT DISTINCT + + 29 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + - 9 AS col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT cor0.col1 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + - 11 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 16 + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 + NULLIF ( cor0.col0, 22 ) * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + 3 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 46 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT 40 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 51 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + tab2.col1 * 0 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col2 * col2 FROM tab1 cor0 GROUP BY col2

;

SELECT ALL - 71 * - col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col0

;

SELECT DISTINCT - 27 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0, col0

;

SELECT cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1, col2

;

SELECT + + 71 + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 64 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor0.col1

;

SELECT 34 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 13 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL COALESCE ( cor0.col1, cor0.col1 ) FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 72 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 88 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT + + 37 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT 95 * 2 FROM tab1 GROUP BY tab1.col2

;

SELECT col1 * + 48 FROM tab1 GROUP BY tab1.col1

;

SELECT 83 + - 24 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 * 76 + - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 14 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 49 * - 40 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 47 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL 1 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL - + 83 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT cor0.col1 * 45 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + tab2.col0 + - 79 * 93 FROM tab2 GROUP BY col0

;

SELECT 38 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + 19 FROM tab0 GROUP BY tab0.col0

;

SELECT - cor0.col1 AS col1 FROM tab2 cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT + tab0.col1 + 50 * tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 31 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + + col2 FROM tab2 GROUP BY col2

;

SELECT ALL - - 37 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + cor0.col0 * 29 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL 38 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 64 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 + col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col2 / cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - col0 * - tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0 HAVING NOT NULL NOT IN ( + col0 )
;

SELECT DISTINCT tab1.col1 + tab1.col1 * + tab1.col1 AS col1 FROM tab1 WHERE tab1.col0 IN ( - tab1.col0 ) GROUP BY tab1.col1

;

SELECT ALL + 75 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 35 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 43 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 61 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + + tab1.col2 - col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + + 65 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT cor1.col0 + cor1.col0 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT - 18 - + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - cor0.col0 * + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NULL
;

SELECT ALL + 82 FROM tab2 GROUP BY tab2.col0

;

SELECT + 53 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - + 61 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - cor0.col1 + + cor0.col1 * cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 11 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + - 26 FROM tab0 GROUP BY tab0.col1

;

SELECT 73 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + tab2.col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT + - 30 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col0 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 97 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + col1 - + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + 22 FROM tab2 GROUP BY col0

;

SELECT ALL 26 + - 68 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab0.col0 FROM tab0 GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT ALL tab1.col0 * tab1.col0 FROM tab1 GROUP BY tab1.col0 HAVING NOT NULL IS NOT NULL
;

SELECT ALL + tab0.col2 FROM tab0, tab2 AS cor0 GROUP BY tab0.col2

;

SELECT ALL 60 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 29 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + tab0.col1 AS col0 FROM tab0 WHERE NOT + col1 IS NULL GROUP BY tab0.col1 HAVING tab0.col1 < NULL
;

SELECT ALL + tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING ( NULL ) IS NULL
;

SELECT - 21 FROM tab1 GROUP BY col0

;

SELECT tab2.col0 + + 91 FROM tab2 GROUP BY col0

;

SELECT DISTINCT NULLIF ( cor0.col0, cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT - - 7 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - 80 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT 41 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 10 * + 1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT ALL + 34 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 55 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT 27 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 83 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + + 1 * + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - - 82 AS col0 FROM tab2 GROUP BY col2

;

SELECT DISTINCT 46 * + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT - col1 * 30 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT CASE cor0.col0 WHEN col1 THEN + 30 + 23 END / cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT - 77 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 51 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT tab0.col2 FROM tab0 WHERE NOT NULL >= NULL GROUP BY tab0.col2

;

SELECT - 33 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col1 * - cor0.col1 + - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NOT NULL
;

SELECT ALL + cor0.col0 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT + 43 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT - 83 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + + tab1.col2 + 99 FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col1 AS col2 FROM tab1 cor0 GROUP BY cor0.col1 HAVING NOT + col1 IS NULL
;

SELECT DISTINCT 27 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 43 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 61 FROM tab0 GROUP BY tab0.col0

;

SELECT + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING NOT ( NULL ) >= NULL
;

SELECT ALL - cor0.col0 * + cor0.col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT ALL NULLIF ( cor0.col2, cor0.col2 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT col1 * - 23 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + - 43 FROM tab2 GROUP BY tab2.col0

;

SELECT - - 65 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - 94 + tab1.col0 * - tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - 83 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 21 FROM tab0 GROUP BY tab0.col2

;

SELECT 73 * 45 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 * - CASE - 52 WHEN cor0.col1 * cor0.col1 THEN - cor0.col2 ELSE NULL END AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT NULLIF ( - cor0.col2, cor0.col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + 89 + - col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + - 13 + + 84 FROM tab1 GROUP BY col1

;

SELECT - 24 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col0

;

SELECT ALL col1 + + 46 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - 66 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 59 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 69 + + tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 46 * - 51 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL cor0.col2 + + 26 FROM tab1 AS cor0 GROUP BY cor0.col2, col2

;

SELECT + + tab2.col2 - 75 AS col2 FROM tab2 GROUP BY col2

;

SELECT - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col1, cor0.col1

;

SELECT col2 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL 83 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 51 + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT ( NULL ) < NULL
;

SELECT DISTINCT - cor0.col0 * cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + 38 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - tab0.col1 * + tab0.col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 75 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT 41 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT ALL + + 83 AS col2 FROM tab1 GROUP BY col1

;

SELECT + + 1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + - tab1.col0 + - tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - 3 - tab1.col0 * + 15 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 56 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 37 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 92 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + + 15 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - + tab0.col1 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - tab2.col0 * tab2.col0 + tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT 99 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 75 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 82 FROM tab2 AS cor0 GROUP BY col0

;

SELECT 72 AS col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT - CASE + cor0.col1 WHEN - cor0.col1 * 83 THEN NULL WHEN cor0.col2 THEN NULL ELSE + col1 END FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 46 + col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING NOT NULL NOT BETWEEN ( NULL ) AND ( NULL )
;

SELECT tab0.col1 + tab0.col1 FROM tab0 GROUP BY col1 HAVING NOT NULL <= NULL
;

SELECT ALL tab0.col0 FROM tab0 GROUP BY col0 HAVING NULL IS NULL
;

SELECT 67 - + cor0.col2 AS col2 FROM tab2 cor0 GROUP BY col0, cor0.col2

;

SELECT 75 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - - tab0.col2 - tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 + cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col0

;

SELECT ALL cor0.col2 - cor0.col1 * cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col1, cor0.col2

;

SELECT tab2.col2 FROM tab2 WHERE NOT + col2 * tab2.col1 < ( NULL ) GROUP BY tab2.col2

;

SELECT DISTINCT - + col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT + - 64 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + - 42 + 52 FROM tab0 GROUP BY tab0.col2

;

SELECT - + 82 FROM tab0 GROUP BY tab0.col0

;

SELECT 67 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ( tab1.col0 ) AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + - 36 * + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - 46 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col1 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT ALL tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0 HAVING NOT NULL IS NOT NULL
;

SELECT tab1.col0 FROM tab1 WHERE NOT col1 IN ( tab1.col0 / tab1.col2 ) GROUP BY tab1.col0

;

SELECT DISTINCT - - col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - - 17 + + tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 49 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + ( tab0.col0 ) AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 49 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - 25 * - 86 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL 31 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 11 * col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - - tab0.col2 + tab0.col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT + 93 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab1.col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT + 4 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT 11 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL + 15 FROM tab2 GROUP BY tab2.col2

;

SELECT + - 18 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + + 47 FROM tab1 GROUP BY col2

;

SELECT + col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 43 AS col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 65 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - + tab2.col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT DISTINCT 9 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 10 * tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT 71 AS col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 46 + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 29 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 89 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - - 92 FROM tab0 GROUP BY tab0.col2

;

SELECT - 32 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT COALESCE ( cor0.col1, - cor0.col1 ) FROM tab1 AS cor0 GROUP BY col1

;

SELECT + col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT - tab2.col0 + + 45 AS col1 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - 68 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 19 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT 65 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 86 * + 44 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 8 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 99 * - 32 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - + 46 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 74 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 * 99 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + 79 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT 52 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + - 30 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor0.col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT cor0.col1 + - 30 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - 90 FROM tab0 GROUP BY tab0.col1

;

SELECT 62 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL 41 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT tab2.col2 - tab2.col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - 82 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - - tab2.col2 * - tab2.col2 + - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT tab1.col1 AS col0 FROM tab1 GROUP BY col1 HAVING NULL <= NULL
;

SELECT DISTINCT tab2.col2 FROM tab2 WHERE NULL = NULL GROUP BY tab2.col2 HAVING ( NULL ) IN ( - tab2.col2 )
;

SELECT DISTINCT - + 38 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 53 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 21 * + 21 + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT + 97 * tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 51 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 22 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + + 25 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 72 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL + tab0.col2 - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - - 36 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT 50 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 95 FROM tab0 GROUP BY tab0.col2

;

SELECT + 45 FROM tab0 GROUP BY col0

;

SELECT ALL - 93 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL col0 + - cor0.col1 * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 88 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - - 24 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + tab0.col1 - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL tab0.col1 + + tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col2 * - cor0.col2 + + NULLIF ( - cor0.col2, + col2 ) * 15 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - 52 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT tab2.col1 + + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - + tab2.col1 - - col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 59 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + 0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 47 FROM tab1, tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL 56 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - col1 AS col1 FROM tab2 WHERE - tab2.col2 * + tab2.col0 NOT BETWEEN NULL AND NULL GROUP BY tab2.col1

;

SELECT ALL 57 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col2 AS col1 FROM tab2 AS cor0 GROUP BY col2 HAVING - col2 IS NOT NULL
;

SELECT tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2 HAVING NULL IS NULL
;

SELECT ALL - cor0.col0 * 89 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL 69 * col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 66 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - 0 FROM tab0 GROUP BY tab0.col2

;

SELECT - - tab2.col0 + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 18 + 26 FROM tab2 GROUP BY col1

;

SELECT 82 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT tab0.col0 + + tab0.col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT ALL cor0.col2 AS col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2, cor1.col1

;

SELECT - + 32 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 1 * - cor0.col1 + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 12 * col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 28 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ( - col1 ) * cor0.col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + 19 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 79 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 33 + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - - 55 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL tab2.col1 + 64 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col2 + col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT tab1.col1 FROM tab1 WHERE NOT ( NULL ) <> NULL GROUP BY tab1.col1

;

SELECT DISTINCT tab0.col1 + col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 75 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col1 + + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 62 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT 55 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT 15 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT tab0.col1 FROM tab0 WHERE ( - tab0.col2 ) NOT BETWEEN tab0.col2 AND - tab0.col1 - tab0.col1 GROUP BY tab0.col1

;

SELECT 40 - - 10 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 78 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 22 * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 66 * - col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 54 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 66 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + NULLIF ( - 75, tab1.col0 ) AS col2 FROM tab1 GROUP BY col0

;

SELECT cor0.col2 + - cor0.col2 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + 96 * col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL 93 FROM tab2 GROUP BY tab2.col0

;

SELECT - - 41 + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + 58 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT ALL + tab0.col2 FROM tab0 WHERE NULL IN ( - tab0.col0 ) GROUP BY col2

;

SELECT - 68 + + 64 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - 14 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT ( + cor0.col2 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - + 26 * + 55 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING NULL < NULL
;

SELECT 11 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - - 53 + 19 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 52 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 88 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col2 FROM tab2 cor0 GROUP BY cor0.col2 HAVING NOT ( NULL ) = ( NULL )
;

SELECT DISTINCT + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + cor0.col1 + 4 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + tab1.col0 - + ( - tab1.col0 ) FROM tab1 GROUP BY tab1.col0

;

SELECT + 84 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 17 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 67 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 48 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 58 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col1 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING ( NULL ) IS NULL
;

SELECT + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col0 HAVING NULL <= NULL
;

SELECT tab0.col1 - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT + 73 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - - 76 FROM tab1 GROUP BY tab1.col2

;

SELECT + 0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + ( - cor0.col1 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - + 26 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + - 90 * tab2.col0 FROM tab2 GROUP BY col0

;

SELECT + 44 + - ( cor0.col2 - - cor0.col2 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT 11 + - 62 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - cor0.col0 - 44 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 88 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 53 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - - 35 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT tab0.col2 * ( col2 ) FROM tab0 GROUP BY tab0.col2

;

SELECT 95 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT tab1.col1 FROM tab1 WHERE NOT ( NULL ) NOT BETWEEN NULL AND NULL GROUP BY tab1.col1 HAVING ( NULL ) NOT BETWEEN ( + col1 * tab1.col1 ) AND NULL
;

SELECT DISTINCT 4 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT 17 * cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col2, col1, cor0.col2

;

SELECT 20 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 - - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL ( cor0.col2 ) * + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col0 * 24 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 9 + 5 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 12 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT ALL + 8 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col0 * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0 HAVING NULL IS NOT NULL
;

SELECT ALL 50 * + 88 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 43 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 17 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 44 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + 45 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col2 + + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 41 FROM tab2 GROUP BY tab2.col0

;

SELECT ( 28 ) AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - 60 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, col2, cor0.col0

;

SELECT ALL - COALESCE ( + 68, cor0.col0 ) FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - 88 + 47 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 4 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 1 AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 59 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 - cor0.col1 * + 37 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - + 95 * col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT - ( + 83 ) FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 22 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col1 * 6 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL + - 81 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - tab0.col2 - - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col0 + - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - + 24 AS col0 FROM tab1 GROUP BY col1

;

SELECT + cor0.col2 * + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 14 FROM tab1 cor0 GROUP BY col0, cor0.col1

;

SELECT + + 76 FROM tab2 GROUP BY col0

;

SELECT tab2.col2 AS col1 FROM tab2, tab0 AS cor0 GROUP BY tab2.col2

;

SELECT tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT ( NULL ) IS NULL
;

SELECT DISTINCT - 97 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - - ( + tab2.col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT 15 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL cor0.col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, col2

;

SELECT 85 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT ( + cor0.col1 ) AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 46 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - + tab0.col1 * - tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 30 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - tab1.col2 * + 46 FROM tab1 GROUP BY tab1.col2

;

SELECT + 74 FROM tab1 cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT - 42 + + cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT tab1.col1 + + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 64 + + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 + - 58 AS col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 30 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 * cor0.col2 + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 - 34 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 FROM tab1 cor0 GROUP BY col1

;

SELECT ALL cor0.col2 FROM tab0 AS cor0 GROUP BY col2 HAVING NOT ( NULL ) IS NULL
;

SELECT - 60 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT + col2 + + col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 12 FROM tab1 AS cor0 GROUP BY col1, cor0.col1, cor0.col2

;

SELECT cor0.col2 * 78 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL + cor0.col2 * 91 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + 92 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + + tab0.col0 * - tab0.col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT ALL + 34 * + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 99 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 41 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab0.col1 + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT NULLIF ( col1, cor0.col1 ) + + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT + 45 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 91 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + 60 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT 58 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + - 8 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - 50 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL + 8 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 19 * - 6 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 90 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + NULLIF ( + cor0.col0, cor0.col2 + col0 ) - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT ALL 14 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 20 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col0

;

SELECT ALL - 55 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL col1 - + tab2.col1 * - tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING NOT NULL >= ( NULL )
;

SELECT ALL - 16 + + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - tab2.col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT tab1.col0 + - 32 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 98 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 83 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col1 * - cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + 95 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 5 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + 3 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL 39 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT 1 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT cor0.col2 + + 4 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT tab1.col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT ( NULL ) IS NULL
;

SELECT cor0.col2 * - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 52 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 63 * 34 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + 76 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 29 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - col0 * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 60 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 36 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - 30 * + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT + 27 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + ( 44 ) AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 79 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col0 - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0 HAVING ( NULL ) IS NULL
;

SELECT ALL 86 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT ALL cor0.col1 + - 27 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - 44 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 21 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + ( + tab1.col1 ) AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT DISTINCT tab0.col2 AS col1 FROM tab0 WHERE NOT ( - tab0.col0 ) IN ( tab0.col2 * - tab0.col1 ) GROUP BY tab0.col2

;

SELECT tab1.col2 AS col2 FROM tab1 WHERE + tab1.col1 < col1 + tab1.col2 GROUP BY tab1.col2

;

SELECT DISTINCT + 91 - - cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 6 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 70 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 62 * - cor0.col0 - cor0.col2 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT + tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1 HAVING ( NULL ) IS NULL
;

SELECT tab2.col1 - - 19 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - - tab1.col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT ALL + col0 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT - 38 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 22 + + col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 26 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT 4 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - ( 39 ) AS col1 FROM tab0 GROUP BY col0

;

SELECT - 32 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 8 FROM tab1 GROUP BY tab1.col2

;

SELECT COALESCE ( tab0.col1, - tab0.col1 ) * 34 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + + tab2.col2 + 90 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 43 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + tab2.col0 + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 47 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - cor0.col2 * + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT col2 - - 96 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL 69 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT 24 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT ALL 71 FROM tab2 GROUP BY tab2.col1

;

SELECT + 89 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + cor0.col1 + + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - - 45 * + 98 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col0 + - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 98 * cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 49 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + tab1.col1 FROM tab1, tab2 AS cor0 GROUP BY tab1.col1

;

SELECT DISTINCT 67 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 - - col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - col2 * + tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT ( 16 ) AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT cor0.col1 + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT + 33 - tab0.col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + 58 * + 65 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 58 + + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + + 12 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + + 44 FROM tab0 GROUP BY tab0.col2

;

SELECT + + 38 * + col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + - 73 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 32 * + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL 82 + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + 54 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - 78 AS col2 FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT tab2.col2 * tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - 89 FROM tab0 GROUP BY col0

;

SELECT + 10 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT ALL + 46 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - tab2.col0 - - tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - - 58 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT - cor0.col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT - + col2 * - 8 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 29 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 + - ( 44 ) AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1, cor0.col2

;

SELECT tab0.col1 * - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col1 + + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0 HAVING NULL IS NULL
;

SELECT DISTINCT tab0.col2 FROM tab0 GROUP BY tab0.col2 HAVING NOT - col2 IS NULL
;

SELECT DISTINCT + - tab0.col0 * col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + tab1.col0 * tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor0.col2 * - col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 8 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 46 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + + 52 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 56 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 16 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 48 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 36 * + cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 + ( 88 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - + 39 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col1 * + 91 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 42 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL 78 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 46 + + 79 * cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT - 98 * + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + col1 FROM tab2 GROUP BY tab2.col1 HAVING ( NULL ) IS NULL
;

SELECT DISTINCT cor0.col1 + + col1 * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - col2 * tab1.col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT ALL - 65 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col1 * cor0.col1 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 * - col0 + 35 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL + cor0.col2 * cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NOT NULL
;

SELECT + 13 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 70 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 24 * cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT COALESCE ( - cor0.col2, cor0.col2 ) FROM tab2 AS cor0 GROUP BY col2

;

SELECT - 83 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + 82 AS col1 FROM tab2 GROUP BY col2

;

SELECT tab2.col1 + + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 94 * - 35 FROM tab0 cor0 GROUP BY col2

;

SELECT 88 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT tab0.col2 * - tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - ( 98 ) * 1 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - 12 FROM tab0 GROUP BY col0

;

SELECT ALL - + 8 * - tab2.col2 + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 55 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 81 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT + 79 * - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab1.col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT + 37 + + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 20 * + 9 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 27 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT DISTINCT 75 * 13 + + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT - tab2.col2 * tab2.col2 FROM tab2 GROUP BY col2

;

SELECT ALL tab1.col2 AS col0 FROM tab1 WHERE + col2 IS NOT NULL GROUP BY tab1.col2

;

SELECT ALL + 14 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 62 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + 3 + col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab0 cor0 GROUP BY col2

;

SELECT + 93 + 72 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - ( 15 ) AS col0 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor0.col0, cor1.col2

;

SELECT DISTINCT cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, col1

;

SELECT cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NULL
;

SELECT ALL cor0.col1 * 20 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 13 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - 45 AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 6 FROM tab1 GROUP BY col1

;

SELECT - cor0.col0 + 68 * 36 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 70 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col0 + - 82 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - tab1.col0 * - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 21 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 95 AS col1 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL tab1.col0 + - 95 * - tab1.col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT DISTINCT 96 + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + cor0.col2 * cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 11 FROM tab2 GROUP BY tab2.col0

;

SELECT 1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 64 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - tab2.col1 * + 34 FROM tab2 GROUP BY tab2.col1

;

SELECT - 55 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 * 12 + - cor0.col0 * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - cor0.col1 - cor0.col0 * cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + + col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + + 76 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 38 + cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 * cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL tab0.col1 + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 16 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 51 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT tab2.col1 - + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - - tab0.col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT ALL - 71 + col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + 43 + + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT ALL - tab2.col0 FROM tab2 GROUP BY tab2.col0 HAVING ( NULL ) IS NOT NULL OR NOT ( tab2.col0 ) IS NOT NULL
;

SELECT - 32 * cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT 72 + 65 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + tab1.col1 - + tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 50 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT - 23 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2 HAVING NOT NULL IN ( + tab0.col2 )
;

SELECT + tab0.col2 * - tab0.col2 FROM tab0 WHERE NOT NULL IS NULL GROUP BY tab0.col2

;

SELECT ALL - - 37 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 34 + + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT DISTINCT 7 + 43 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - tab0.col1 - + tab0.col1 FROM tab0 GROUP BY col1

;

SELECT 45 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - tab2.col1 * - tab2.col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT cor0.col0 + 46 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - 71 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col1 * 11 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col0 * cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT col2 + - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 11 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT - 56 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + - 2 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - col1 AS col2 FROM tab1 WHERE NOT NULL NOT IN ( - tab1.col2 ) GROUP BY tab1.col1

;

SELECT + col0 - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL + col2 * col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING NULL >= ( NULL )
;

SELECT ALL cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL BETWEEN NULL AND ( NULL )
;

SELECT ALL col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NULL
;

SELECT + col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, col1

;

SELECT cor0.col1 * + cor0.col0 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT - cor0.col0 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 92 * - 92 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 19 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL cor0.col1 + - col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col1, col0

;

SELECT + - 97 - + 36 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 47 - 16 AS col1 FROM tab0 GROUP BY col0

;

SELECT ALL - 71 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col2 + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + COALESCE ( + 92, tab0.col1 ) FROM tab0 GROUP BY tab0.col1

;

SELECT + tab0.col1 - 8 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col1 + + ( cor0.col2 ) * + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - tab1.col0 * + 83 FROM tab1 GROUP BY tab1.col0

;

SELECT - 38 FROM tab2 GROUP BY col1

;

SELECT - 26 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 89 + - 99 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 96 + - tab1.col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT ALL + col2 * + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 53 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - 46 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT + cor0.col1 + + 55 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT cor0.col2 - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + 38 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - 18 FROM tab0 GROUP BY tab0.col1

;

SELECT 15 FROM tab1 GROUP BY tab1.col1

;

SELECT + 39 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 83 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + tab1.col2 + + col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT 99 * tab2.col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT ALL - 96 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT tab2.col2 AS col2 FROM tab2 WHERE ( tab2.col0 - + tab2.col1 ) IN ( - tab2.col2 ) GROUP BY col2

;

SELECT ALL + tab2.col1 - - tab2.col1 FROM tab2 GROUP BY col1 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT tab0.col2 FROM tab0 WHERE col1 IS NOT NULL GROUP BY tab0.col2

;

SELECT DISTINCT 9 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, col0

;

SELECT ALL - cor0.col0 - - 90 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 79 + - tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NOT NULL
;

SELECT cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT + cor0.col1 * 76 + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 66 FROM tab1 GROUP BY tab1.col2

;

SELECT 82 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - ( col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT tab1.col1 * + tab1.col1 FROM tab1 GROUP BY col1

;

SELECT ALL - tab1.col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT + ( col1 ) - col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 80 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 80 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - tab2.col0 + - col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 33 - cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + - tab2.col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT 71 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT col1 AS col0 FROM tab1 AS cor0 GROUP BY col1 HAVING col1 NOT IN ( + cor0.col1 )
;

SELECT + 79 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT - 30 AS col0 FROM tab1 GROUP BY col1

;

SELECT + cor0.col0 * - cor0.col1 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 6 * cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor1.col0 * - cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0, cor0.col2

;

SELECT - 69 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT 54 * + tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + 72 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT - 0 FROM tab2 GROUP BY col2

;

SELECT - col1 - + tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + cor0.col0 * + ( 81 ) AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT cor0.col1 * + cor0.col1 + + 59 * + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0 HAVING NOT NULL IS NOT NULL
;

SELECT + 55 * - 1 FROM tab1 GROUP BY tab1.col0

;

SELECT 13 + - 48 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2 HAVING NULL >= NULL
;

SELECT 18 + 18 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + - tab1.col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT 65 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - 6 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 62 FROM tab1 cor0 GROUP BY col2

;

SELECT ALL 71 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + ( cor0.col1 ) FROM tab0 cor0 GROUP BY col1

;

SELECT 73 + + 68 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - col1 - tab1.col1 * + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + + 81 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 59 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 + 34 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - ( + 34 ) AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL ( 55 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 87 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor0.col1, cor1.col1

;

SELECT DISTINCT + 60 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + cor0.col2 * + 81 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 22 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 72 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 * - 53 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL 20 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT col1 * + col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 17 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col2 * cor0.col1 + COALESCE ( cor0.col0, + 54 * cor0.col2, cor0.col2 + 99 ) FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT DISTINCT 63 * cor0.col0 + col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 * - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 59 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + 23 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 68 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL - cor0.col1 + cor0.col2 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT 5 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 60 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + cor0.col2 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col0 * - 20 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 30 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 89 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + 9 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 77 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL IS NULL
;

SELECT - cor0.col2 + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + 60 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 40 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 36 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 28 - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 10 * + 54 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab2.col0 FROM tab2 GROUP BY col0 HAVING ( NULL ) IS NULL
;

SELECT DISTINCT - 73 AS col0 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL - col2 + 80 AS col2 FROM tab1 GROUP BY col2

;

SELECT ALL + - 32 * tab0.col2 + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - 15 FROM tab2 GROUP BY tab2.col0

;

SELECT 93 FROM tab1 GROUP BY col0

;

SELECT ALL + cor0.col2 * - col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ( 10 ) FROM tab0 AS cor0 GROUP BY col0

;

SELECT 66 FROM tab2 cor0 GROUP BY col0

;

SELECT ALL 82 FROM tab0 cor0 GROUP BY cor0.col0, col0

;

SELECT - 39 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col2 * col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 * + 91 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 82 - - 33 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 10 * + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 25 + + cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - 16 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 21 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 13 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 14 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + - 95 FROM tab2 GROUP BY col1

;

SELECT ALL + 46 * + 61 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT + 67 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 26 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - 4 + - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT 91 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + + 89 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT tab0.col1 + tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING NOT NULL IS NOT NULL
;

SELECT + COALESCE ( ( + tab1.col1 ), + tab1.col1 ) FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col2, cor0.col1

;

SELECT ALL cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - ( + cor0.col0 ) + + 13 * col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + cor0.col0 * 7 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL tab1.col1 - + col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 22 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 27 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 75 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + tab0.col2 * + tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + 80 * + col2 AS col2 FROM tab0 cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT 61 AS col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + col2 + ( + 7 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT DISTINCT - NULLIF ( - 85, 24 ) * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + ( + tab2.col0 ) FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT + col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + tab1.col2 + 77 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + tab1.col2 * col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor0.col0

;

SELECT DISTINCT + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT - + tab1.col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT 93 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 60 FROM tab2 GROUP BY tab2.col2

;

SELECT 29 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - col2 + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - 64 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 63 + - tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT 90 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT + tab1.col2 * + tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + cor0.col0 + - cor0.col0 * cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 98 FROM tab2 GROUP BY tab2.col0

;

SELECT tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING ( NULL ) IS NOT NULL
;

SELECT + tab1.col1 * tab1.col1 - - 95 * 39 FROM tab1 GROUP BY col1

;

SELECT DISTINCT ( 19 ) + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ( COALESCE ( cor0.col1, + 61 + - 25 ) ) + 18 * + col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 57 FROM tab2 GROUP BY tab2.col0

;

SELECT NULLIF ( - cor0.col0, - cor0.col0 + + cor0.col0 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - tab0.col0 AS col1 FROM tab0 WHERE tab0.col0 IS NOT NULL GROUP BY tab0.col0

;

SELECT DISTINCT tab1.col2 FROM tab1 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT ALL 63 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 81 * - 48 + 13 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 60 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT tab0.col0 * 93 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 64 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL cor0.col0 * + 57 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT + 25 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 41 * 47 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 63 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 + + 48 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 76 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 79 + - cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - tab0.col0 / - tab0.col0 FROM tab0 GROUP BY col0 HAVING NULL IN ( tab0.col0 )
;

SELECT DISTINCT + 80 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + 56 * + 47 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 46 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 14 + + tab2.col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - COALESCE ( tab0.col2, col2, 86 ) * col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT - 75 * - cor0.col2 + - cor0.col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT - cor0.col2 + cor0.col1 * + col1 AS col0 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT 79 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + + 49 FROM tab0 GROUP BY tab0.col2

;

SELECT - 92 + - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 14 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 88 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - 72 AS col1 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT 92 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 54 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 * + ( - 31 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab0.col2 + + 38 FROM tab0 GROUP BY tab0.col2

;

SELECT 51 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 26 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 67 * 58 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - 16 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + tab2.col1 * + 29 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + cor0.col0 * cor0.col0 AS col0 FROM tab0 cor0 GROUP BY col0, cor0.col0, cor0.col0

;

SELECT ALL + 47 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 11 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT + tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0 HAVING ( NULL ) IS NULL
;

SELECT + 93 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 37 - 72 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + + 18 FROM tab0 GROUP BY tab0.col0

;

SELECT + cor0.col2 * - ( - cor0.col2 ) AS col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + tab0.col2 AS col1 FROM tab0 WHERE NOT NULL > + col2 GROUP BY col2

;

SELECT DISTINCT 49 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT + cor0.col0 * cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + NULLIF ( 42, cor0.col2 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 59 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 96 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + - 72 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 46 + - cor0.col1 * cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 14 * + 35 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - - tab0.col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT DISTINCT col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ( - col0 ) FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - 53 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - + 57 FROM tab1 GROUP BY tab1.col1

;

SELECT - tab1.col1 * 91 FROM tab1 GROUP BY tab1.col1

;

SELECT - tab0.col0 * tab0.col0 FROM tab0 WHERE NOT ( + col2 ) IS NOT NULL GROUP BY tab0.col0

;

SELECT DISTINCT col2 AS col1 FROM tab2 GROUP BY tab2.col2 HAVING - tab2.col2 IS NOT NULL
;

SELECT ALL - ( + 10 ) * tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 57 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 + + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col0 + - cor0.col0 * 30 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 5 + 42 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0, col0

;

SELECT + 80 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT 6 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + + cor0.col1 * + 79 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * + 43 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 79 * + 23 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor1.col0 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 59 * - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - + 77 * 62 AS col2 FROM tab2 GROUP BY col0

;

SELECT + 29 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT tab2.col2 FROM tab2 WHERE NULL IS NULL GROUP BY tab2.col2 HAVING NOT NULL < NULL
;

SELECT 97 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 65 * 49 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col2

;

SELECT ALL - 53 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col0

;

SELECT ALL - 82 - tab2.col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT ALL 39 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 23 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 53 * + tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - 98 * + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col1 * - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 33 + + 45 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 97 FROM tab1 GROUP BY tab1.col1

;

SELECT - ( cor0.col0 ) * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 72 + + col2 FROM tab2 GROUP BY col2

;

SELECT ALL + col2 - + 85 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1, cor0.col1

;

SELECT ALL - ( - COALESCE ( + cor0.col0, + cor0.col0 + 59 ) ) FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 AS col0 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT 79 + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + tab2.col2 FROM tab2 WHERE NULL <= NULL GROUP BY tab2.col2

;

SELECT ALL cor0.col0 - - COALESCE ( - 23, cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 71 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT cor0.col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col1

;

SELECT DISTINCT tab0.col2 * - col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - col0 * + tab1.col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT 40 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + - 11 * 9 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL tab1.col0 * + tab1.col0 FROM tab1 GROUP BY tab1.col0 HAVING ( NULL ) IS NOT NULL
;

SELECT col1 AS col0 FROM tab2 GROUP BY tab2.col1 HAVING NOT tab2.col1 NOT IN ( - tab2.col1 )
;

SELECT DISTINCT - cor0.col2 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2, cor0.col2

;

SELECT ALL 44 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 22 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 33 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 11 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - 38 + - 92 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 16 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT col1 + + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 88 * - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 75 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING NULL IS NULL
;

SELECT DISTINCT + tab0.col1 AS col0 FROM tab0 GROUP BY col1 HAVING - col1 IS NULL
;

SELECT DISTINCT 4 + - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL + tab0.col1 FROM tab0, tab1 AS cor0 GROUP BY tab0.col1

;

SELECT 58 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - - tab0.col1 + - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - - tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 27 * 69 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 22 * - cor0.col0 + - col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab1.col1 - - 23 FROM tab1 GROUP BY col1

;

SELECT DISTINCT + col1 FROM tab0 GROUP BY tab0.col1 HAVING NULL IN ( + tab0.col1 * - col1 )
;

SELECT + 68 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 12 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, col1

;

SELECT ALL + tab2.col1 - 75 FROM tab2 GROUP BY tab2.col1

;

SELECT + col0 + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - - 6 FROM tab1 GROUP BY tab1.col0

;

SELECT + - 64 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + - 29 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 57 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 15 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 25 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT - 23 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - tab2.col1 * - col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT - - col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT ALL - tab1.col2 FROM tab1 GROUP BY col2 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT col2 FROM tab0 GROUP BY tab0.col2 HAVING NULL IS NULL
;

SELECT 73 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col2 - + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NULL
;

SELECT tab0.col2 * tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT - 77 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 75 + col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 63 - - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - - 76 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - - tab1.col2 + 19 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT tab0.col1 AS col2 FROM tab0 GROUP BY col1 HAVING NOT ( NULL ) <= NULL
;

SELECT - - tab1.col1 + col1 FROM tab1 GROUP BY col1

;

SELECT - cor0.col1 FROM tab2 cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT - 47 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col2 * + 69 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 78 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL tab2.col0 * col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + + 1 AS col0 FROM tab2 GROUP BY col1

;

SELECT + 88 * - 0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - col1 * cor0.col2 FROM tab2 AS cor0 GROUP BY col2, col1, cor0.col2, cor0.col0

;

SELECT DISTINCT 81 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL - + ( - col2 ) + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 23 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - 87 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * 22 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 1 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + - tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 72 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col1 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT DISTINCT - col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL tab0.col2 AS col1 FROM tab0 WHERE NOT tab0.col2 IS NOT NULL GROUP BY tab0.col2 HAVING NULL IS NOT NULL
;

SELECT ALL + ( 19 ) * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 29 * + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 74 FROM tab1 cor0 GROUP BY col1

;

SELECT + + 43 + - 16 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 43 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT NULLIF ( cor0.col0, + cor0.col2 ) AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + ( 89 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ( - 69 ) + - 22 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT - 52 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 23 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 AS col2 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT cor0.col1 * cor0.col1 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 * - 90 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 67 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 92 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 42 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 3 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + 57 + + tab1.col1 * col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 68 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + ( + cor0.col0 ) * - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col1 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - ( 29 ) * + 80 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT - 70 * + 46 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL ( - tab0.col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 20 FROM tab0 GROUP BY tab0.col1

;

SELECT - 85 + 49 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT col0 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 78 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col0 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT cor0.col2 * + 34 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - - tab1.col0 * - tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - ( - 80 ) * + col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT ALL + 43 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - tab0.col1 + - tab0.col1 FROM tab0 GROUP BY col1

;

SELECT ALL - col2 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT ALL + - 77 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + 29 FROM tab0 cor0 GROUP BY cor0.col2, col1, cor0.col2, cor0.col2

;

SELECT ALL - 1 * 13 FROM tab2 GROUP BY col2

;

SELECT ALL 21 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - tab0.col2 * tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 27 FROM tab1 AS cor0 GROUP BY col0, cor0.col2, cor0.col1

;

SELECT 60 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 58 * 18 + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - 27 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 64 FROM tab0 GROUP BY col1

;

SELECT - cor0.col1 + cor0.col1 * - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + tab1.col0 * 68 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col2 - + ( cor0.col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 24 FROM tab0 GROUP BY tab0.col1

;

SELECT - 46 FROM tab1 GROUP BY tab1.col1

;

SELECT 27 * cor0.col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT tab0.col0 * - tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 52 * 3 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 21 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - 42 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 33 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 31 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 58 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - + 93 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 18 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT - tab2.col2 - + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - 55 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 52 + col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT + + 78 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 54 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT + tab0.col2 * tab0.col2 FROM tab0 GROUP BY tab0.col2 HAVING NOT NULL NOT IN ( tab0.col2 )
;

SELECT cor0.col1 * col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 65 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + - tab2.col2 + + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - - 1 - - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + - 86 FROM tab0 GROUP BY col2

;

SELECT ALL - tab1.col1 * 48 FROM tab1 GROUP BY tab1.col1

;

SELECT + col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col2 * 25 + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 82 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 * 82 FROM tab1 cor0 GROUP BY col1, cor0.col1

;

SELECT - 17 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col2 * + 40 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 89 FROM tab1 GROUP BY tab1.col2

;

SELECT - - 71 * tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT + 40 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 51 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - tab2.col1 * 77 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - cor0.col1 + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL tab0.col1 * tab0.col1 + tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1 HAVING NOT ( tab0.col1 ) IN ( tab0.col1 )
;

SELECT - tab2.col2 * - 62 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 51 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 29 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ( 45 ) AS col1 FROM tab0 GROUP BY col2

;

SELECT 1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + - 55 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 0 * tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + 74 FROM tab1 GROUP BY tab1.col2

;

SELECT + - 40 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - + 66 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - tab1.col0 - + 72 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + cor0.col1 - - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + + cor0.col2 AS col1 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - + ( tab2.col2 ) AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - cor0.col0 + + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT 4 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 51 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 32 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + cor1.col2 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2

;

SELECT - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT 23 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 65 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL - - tab1.col2 * tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT - tab0.col0 AS col0 FROM tab0 WHERE ( + tab0.col0 ) IS NULL GROUP BY col0

;

SELECT ALL 70 - - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + col1 + 27 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT DISTINCT + tab2.col1 AS col1 FROM tab2 WHERE ( NULL ) NOT IN ( tab2.col1 / tab2.col2 ) GROUP BY tab2.col1

;

SELECT ALL + tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING tab2.col1 IN ( tab2.col1 )
;

SELECT ALL - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT cor0.col1 * 81 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL cor0.col2 AS col2 FROM tab1 cor0 GROUP BY col0, cor0.col2

;

SELECT - 43 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - + 61 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT - tab1.col0 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 44 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - COALESCE ( 68, + 45 - + tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 52 + + 43 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 87 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 23 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 99 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - 96 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT col0 * cor0.col0 FROM tab1 AS cor0 GROUP BY col0 HAVING + col0 IS NOT NULL
;

SELECT - tab0.col1 FROM tab0 WHERE NULL <= - tab0.col0 GROUP BY col1 HAVING NULL >= + tab0.col1
;

SELECT 67 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col2 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 98 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + cor0.col2 - 57 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT - cor0.col0 * - ( + col1 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT CASE cor0.col2 WHEN cor0.col2 THEN cor0.col2 ELSE NULL END * - 28 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 3 + + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT DISTINCT - 86 * - 90 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ( - 87 ) AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT NULLIF ( cor0.col1, - cor0.col1 ) FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT + 0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, col1

;

SELECT DISTINCT - tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1 HAVING NULL IS NULL
;

SELECT ALL + 81 + - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT col1 * cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + ( 27 ) + + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - cor0.col0 * - 81 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - 36 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + tab2.col2 - - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 34 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT tab2.col0 * 39 - col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + tab2.col0 * + tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + col0 FROM tab1 cor0 GROUP BY col0

;

SELECT - col0 - + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1 HAVING ( NULL ) IS NULL
;

SELECT ALL tab1.col1 * + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL cor0.col0 + - col1 AS col2 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col1 - cor0.col0 * + 58 FROM tab0 AS cor0 GROUP BY col2, cor0.col1, cor0.col0

;

SELECT - 49 * + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 22 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT 93 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 0 * 67 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - 14 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 34 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + + 38 + + col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 24 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - tab2.col0 AS col2 FROM tab2 WHERE + tab2.col2 + - tab2.col0 IS NOT NULL GROUP BY tab2.col0

;

SELECT - 55 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 58 * - 57 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 91 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 47 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 38 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - ( + 16 ) AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL col0 - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col0 * 52 + cor0.col0 * + 69 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 8 * + 5 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL cor0.col0 * 17 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 63 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 63 + - ( cor0.col0 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT 99 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col0 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT + - 69 FROM tab2 GROUP BY tab2.col0

;

SELECT - NULLIF ( 41, col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT - 46 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 9 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 73 AS col0 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT 53 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 40 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col0, col1

;

SELECT ALL + - 60 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col0 * 37 AS col2 FROM tab2 cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT - 15 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT + 72 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 34 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ( + col2 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col2, cor0.col2

;

SELECT DISTINCT + cor0.col0 - - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 29 * - tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 97 + - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 78 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 34 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 45 + + 3 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 54 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 42 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - - tab0.col1 + - 4 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - 3 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 13 FROM tab0, tab1 AS cor0 GROUP BY tab0.col0

;

SELECT ALL + cor0.col0 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 24 AS col1 FROM tab2 cor0 GROUP BY cor0.col1, col2

;

SELECT + 44 FROM tab0 GROUP BY tab0.col2

;

SELECT - 22 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - col0 + - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT 29 * tab1.col0 FROM tab1 GROUP BY col0

;

SELECT - 76 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - 50 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT tab1.col0 + - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - + tab2.col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT tab0.col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT + 99 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT tab2.col1 FROM tab1 AS cor0 CROSS JOIN tab2 GROUP BY tab2.col1 HAVING NULL IS NULL
;

SELECT DISTINCT cor0.col2 + cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT ( cor0.col0 ) * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col0, cor0.col1

;

SELECT - cor0.col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT - 90 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + tab1.col2 FROM tab1 WHERE + tab1.col2 IS NOT NULL GROUP BY tab1.col2

;

SELECT ALL - cor0.col1 * 4 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 7 * + 39 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col0

;

SELECT DISTINCT 59 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 52 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - + 11 FROM tab0 GROUP BY tab0.col0

;

SELECT + 2 * tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 45 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 * - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 5 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 85 * 95 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 12 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT cor0.col1 + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + tab1.col0 FROM tab1 WHERE NULL IN ( - tab1.col2 / tab1.col1 + tab1.col2 * - tab1.col1 ) GROUP BY tab1.col0

;

SELECT + tab0.col2 FROM tab0 WHERE col0 = ( NULL ) GROUP BY tab0.col2

;

SELECT ALL tab0.col2 * - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + + 62 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 19 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 14 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL tab1.col1 * - 14 FROM tab1 GROUP BY tab1.col1

;

SELECT cor1.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1, cor1.col1, cor1.col2

;

SELECT ( - cor0.col1 ) FROM tab2 cor0 GROUP BY col1, cor0.col0

;

SELECT + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 18 FROM tab1 GROUP BY tab1.col2

;

SELECT + tab1.col2 + tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - tab2.col1 + 53 * tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + 35 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT ( + 53 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 9 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - ( col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 95 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + + 33 FROM tab0 GROUP BY tab0.col1

;

SELECT - col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 51 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - + 60 FROM tab0 GROUP BY tab0.col0

;

SELECT - 89 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 78 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 43 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab1.col0 * + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT COALESCE ( col2, + cor0.col2 ) + col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + 56 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT col1 AS col1 FROM tab2 GROUP BY tab2.col1 HAVING NOT tab2.col1 IS NULL
;

SELECT + - 3 FROM tab1 GROUP BY col2

;

SELECT - cor0.col2 AS col2 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT + cor0.col0 + + col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 93 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + 56 + + col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 30 + 70 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - 94 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 90 + - 11 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT 82 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 83 AS col1 FROM tab2 cor0 GROUP BY col2

;

SELECT - 64 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT 87 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + NULLIF ( + cor0.col1, + cor0.col1 ) + - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 91 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT 94 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 71 * + 78 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 66 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + col2 FROM tab0 GROUP BY tab0.col2 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT DISTINCT + + 29 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 77 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT + - 72 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + cor1.col0 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0, cor0.col2, cor1.col2

;

SELECT DISTINCT + 49 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 94 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - 95 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 56 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 86 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + cor0.col2 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ( 85 ) AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL - + tab1.col1 * - 6 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - 60 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL col1 + + cor0.col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL 52 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 46 + - 43 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT cor0.col2 * - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 85 * - 92 AS col0 FROM tab0 GROUP BY col2

;

SELECT 25 * + tab1.col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT - cor0.col0 - cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT cor0.col0 - 68 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 30 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + tab2.col0 + 74 FROM tab2 GROUP BY tab2.col0

;

SELECT - tab2.col0 * + 24 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 * cor0.col2 + - 27 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 14 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 51 - 4 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - tab2.col1 * - 50 FROM tab2 GROUP BY col1

;

SELECT ALL col1 FROM tab2 WHERE NOT ( tab2.col0 / col0 ) IS NULL GROUP BY tab2.col1 HAVING NOT + tab2.col1 > NULL
;

SELECT ALL tab0.col0 FROM tab0 WHERE NOT ( NULL ) IS NOT NULL GROUP BY tab0.col0 HAVING + tab0.col0 < ( NULL )
;

SELECT DISTINCT - cor0.col2 * + 14 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - + tab2.col0 + + tab2.col0 * ( + 89 ) FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 14 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + + 77 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 81 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 44 - 75 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - tab1.col2 * 90 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - + 98 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - 90 FROM tab2 GROUP BY tab2.col1

;

SELECT + + 71 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col2 - cor0.col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 52 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT - cor0.col1 * cor0.col1 + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + tab1.col0 * 31 AS col1 FROM tab1 GROUP BY col0

;

SELECT 68 + - ( + cor0.col0 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + - 75 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT 60 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col1 * - cor0.col0 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 96 AS col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT 8 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + + 33 + + 18 * + tab2.col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT + 92 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + tab0.col0 * + col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT 20 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - COALESCE ( - 16, cor0.col2 ) + + cor0.col1 * 52 FROM tab1 AS cor0 GROUP BY col2, col1, cor0.col0

;

SELECT 90 FROM tab1 cor0 GROUP BY cor0.col2, col2

;

SELECT ALL - 34 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT 93 FROM tab1 GROUP BY tab1.col2

;

SELECT - 66 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + tab1.col1 - + tab1.col1 * + tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + 33 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 87 AS col0 FROM tab1 cor0 GROUP BY col1

;

SELECT - 12 * cor0.col0 + + col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + cor0.col0 * + 2 AS col2 FROM tab1 cor0 GROUP BY col1, cor0.col0

;

SELECT - cor0.col2 + col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 77 - - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 48 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - - tab2.col1 + - 39 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL tab0.col1 - - 79 FROM tab0 GROUP BY tab0.col1

;

SELECT + 40 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT cor0.col2 * - 17 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT DISTINCT + tab2.col2 * + 2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL ( 46 ) FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 17 * + col1 + tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 64 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 68 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab0.col2 - ( + 4 ) AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col1

;

SELECT DISTINCT - + 39 * - tab0.col2 + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - cor0.col2 - - cor0.col2 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 80 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 30 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 78 FROM tab1, tab2 cor0 GROUP BY tab1.col2

;

SELECT 1 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT 59 FROM tab1 AS cor0 GROUP BY col0

;

SELECT 43 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - 30 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL cor0.col2 * 46 - - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 17 * + tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + + tab0.col1 + col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 79 * tab0.col2 + 34 FROM tab0 GROUP BY tab0.col2

;

SELECT - 16 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 57 * cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 87 + - cor0.col0 * cor0.col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT tab2.col1 * + tab2.col1 FROM tab2 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT + cor0.col2 + - col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - ( cor0.col0 ) * cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - - 7 FROM tab2 GROUP BY tab2.col1

;

SELECT 51 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT col2 + + 13 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 56 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + ( + tab2.col2 ) FROM tab2 GROUP BY tab2.col2

;

SELECT 98 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT COALESCE ( 44, + tab2.col0 + + 14 ) FROM tab2 GROUP BY tab2.col0

;

SELECT 58 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + - 9 FROM tab0 GROUP BY col1

;

SELECT - 51 FROM tab0 cor0 GROUP BY cor0.col1, col1

;

SELECT + col1 * 28 FROM tab0 cor0 GROUP BY col1

;

SELECT - ( tab0.col2 ) FROM tab0 GROUP BY tab0.col2

;

SELECT col2 + - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 3 * + 92 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 70 * cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - 31 FROM tab1 GROUP BY tab1.col1

;

SELECT + + 94 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + - 7 FROM tab1 GROUP BY tab1.col2

;

SELECT - 31 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - cor0.col1 + + col0 * + col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL - 4 * 88 + - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT 66 * 69 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ( tab0.col2 ) FROM tab0, tab0 AS cor0 GROUP BY tab0.col2

;

SELECT tab0.col0 + + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT ALL + 72 + - 36 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col2 - + 79 FROM tab0 AS cor0 GROUP BY col1, col2, cor0.col0

;

SELECT DISTINCT - 84 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - ( + cor0.col2 ) AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - 48 * tab1.col2 FROM tab1 GROUP BY col2

;

SELECT + + col0 - - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - + tab1.col2 FROM tab1 GROUP BY col2

;

SELECT + 13 FROM tab0 GROUP BY col2

;

SELECT ALL - cor0.col0 - + 89 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT cor0.col2 AS col1 FROM tab2 cor0 GROUP BY col2, cor0.col2

;

SELECT ALL + 65 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 + 75 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL 65 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + 39 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 90 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0, col2

;

SELECT 74 + + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 47 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 94 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL ( + 37 ) AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + + 65 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + tab2.col0 * tab2.col0 + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + tab2.col0 * tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0 HAVING NULL IS NOT NULL
;

SELECT ALL cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT DISTINCT + 41 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL - NULLIF ( + 52, - 9 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ( - 63 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 37 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col1 * - cor0.col1 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT + 0 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + tab1.col2 - + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 49 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 18 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + - 60 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 84 + 5 * - cor0.col0 AS col0 FROM tab1 cor0 GROUP BY col0

;

SELECT - 12 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT + ( col0 ) + - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col2 + + cor0.col2 * cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + cor0.col1 * + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 30 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT + tab2.col2 AS col0 FROM tab2 WHERE NOT ( NULL ) IN ( - tab2.col0 + col1 ) GROUP BY tab2.col2

;

SELECT tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - ( - col0 ) FROM tab1 GROUP BY col0

;

SELECT DISTINCT 82 + + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + - 27 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - col2 + tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 29 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 16 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 88 FROM tab2 GROUP BY tab2.col0

;

SELECT + col0 * 67 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 16 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + + 60 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + - tab0.col2 + - tab0.col2 FROM tab0 GROUP BY col2

;

SELECT ( col1 ) * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - - 87 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - 76 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL cor0.col2 * - col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 77 AS col1 FROM tab2, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL - 23 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 * - 99 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL CASE cor0.col2 WHEN - cor0.col0 THEN - cor0.col2 ELSE NULL END / - cor0.col1 + cor0.col1 * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, col0

;

SELECT + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT ( 5 ) FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - 32 FROM tab1, tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col0 + 10 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 14 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT 26 AS col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor0.col1, cor0.col1

;

SELECT ALL cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col1

;

SELECT DISTINCT cor0.col1 + - 3 FROM tab0 AS cor0 GROUP BY col1

;

SELECT cor0.col0 * - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL cor0.col0 + NULLIF ( cor0.col0, cor0.col0 * 59 ) AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT ALL + - tab2.col2 + - col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 77 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col1 * 45 + cor0.col1 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 + + 80 * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - + ( - tab1.col1 ) FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col0 - + cor0.col0 * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col2 - + 10 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL tab0.col0 + tab0.col0 * + 65 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col0 * cor0.col0 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + + tab0.col1 - 91 * col1 FROM tab0 GROUP BY col1

;

SELECT - tab0.col2 + - tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT - tab2.col0 * - 54 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - tab0.col1 * - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + col2 + cor0.col0 * 39 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL tab2.col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT + tab1.col0 * + col0 + - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - 19 + + 93 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT DISTINCT 69 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL 89 FROM tab1 AS cor0 GROUP BY col1, cor0.col2, cor0.col0

;

SELECT cor0.col2 * - col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + + tab0.col0 + - tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT col0 + - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - + 15 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 6 FROM tab1 GROUP BY tab1.col1

;

SELECT + 94 AS col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 21 + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + - 18 FROM tab1 GROUP BY tab1.col1

;

SELECT - cor0.col0 + - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 67 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + 35 * 67 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + + tab0.col1 + + 42 FROM tab0 GROUP BY tab0.col1

;

SELECT 21 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 62 * + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + tab2.col1 * - tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col1 + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - tab1.col1 / tab1.col1 AS col1 FROM tab1 GROUP BY col1 HAVING NOT NULL < NULL
;

SELECT ALL 55 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 15 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + cor0.col1 * cor0.col0 + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2, col0

;

SELECT ALL - cor0.col0 FROM tab2 cor0 GROUP BY col0, col2

;

SELECT ALL 9 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + tab0.col1 * - col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 97 + 64 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 95 + + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - + 22 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - col2 + tab0.col2 FROM tab0 GROUP BY col2

;

SELECT 40 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 95 * 62 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - + 96 FROM tab0 GROUP BY tab0.col0

;

SELECT + 53 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col2 - - cor0.col2 * - col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col2 * + 17 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + - 83 * 17 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + 46 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT 51 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 97 + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 28 + cor0.col1 * + 34 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL + 27 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 9 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT + cor0.col2 * + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT 2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL ( 72 ) FROM tab0 GROUP BY tab0.col0

;

SELECT + 87 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT col2 * tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + tab0.col2 FROM tab0 WHERE + tab0.col2 / col1 IS NOT NULL GROUP BY tab0.col2 HAVING NULL IS NOT NULL
;

SELECT ALL - 54 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL col2 * 44 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + ( cor0.col0 ) + - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - tab0.col1 * col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - + tab2.col1 + 48 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT cor0.col1 * - 84 + col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + cor0.col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT + 87 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col1 * 56 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 49 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 + cor0.col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT - - 70 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT 20 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 - + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col0

;

SELECT ALL 80 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT tab1.col0 * tab1.col0 + + tab1.col0 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - col2 * + tab2.col2 - 31 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + 79 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 53 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 + col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 61 * + col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab1.col0 * 5 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col0 + + cor0.col0 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, col2

;

SELECT tab2.col2 + + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - cor0.col0 * cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col0 * + 65 - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 11 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + tab0.col1 + 15 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 85 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + ( 58 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - + NULLIF ( + 21, + col2 ) * - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 36 AS col2 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + 76 FROM tab0 GROUP BY tab0.col0

;

SELECT - - 61 - tab1.col2 * tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - - tab0.col0 * tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 70 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 18 + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + 84 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT ALL 24 FROM tab1 cor0 GROUP BY cor0.col0, col1

;

SELECT + 48 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT 43 FROM tab1 GROUP BY tab1.col0

;

SELECT 86 FROM tab0 GROUP BY tab0.col1

;

SELECT - 49 + + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 38 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 33 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 39 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + col2 * + cor0.col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT - 56 * tab0.col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT + tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2 HAVING NULL > NULL
;

SELECT DISTINCT cor0.col0 + cor0.col1 * + col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - + ( 56 ) AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + ( + 34 ) - cor0.col1 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - ( + cor0.col2 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 96 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL - - tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT - tab2.col2 + - 0 AS col1 FROM tab2 GROUP BY col2

;

SELECT - 63 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 33 * + tab1.col2 FROM tab1 GROUP BY col2

;

SELECT - 24 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor1.col0 AS col1 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT cor1.col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT - 88 * - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 * col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col0

;

SELECT - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT ALL - col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - tab0.col2 AS col2 FROM tab0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT - 50 AS col0 FROM tab1 GROUP BY col2

;

SELECT DISTINCT tab2.col1 + tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + 10 + + tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT CASE - cor0.col0 WHEN cor0.col1 * + cor0.col0 THEN NULL ELSE + col0 + + cor0.col1 END * cor0.col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT tab1.col0 - + 42 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + + 23 FROM tab0 GROUP BY tab0.col2

;

SELECT - 40 FROM tab1 GROUP BY col1

;

SELECT - tab0.col1 * tab0.col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT ALL 5 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT tab2.col1 * + 40 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col1 + 72 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 34 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT tab0.col0 * ( tab0.col0 * - tab0.col0 ) AS col2 FROM tab0 GROUP BY col0

;

SELECT - + 31 - 78 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 86 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 33 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT 55 + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 31 * + 25 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 84 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ( + 6 ) AS col0 FROM tab1 GROUP BY col2

;

SELECT + 2 FROM tab2 GROUP BY tab2.col0

;

SELECT 61 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 6 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + 16 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - 23 * tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + 94 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 28 * - 60 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 88 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 + 48 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 52 + - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 64 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 20 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col2 + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 24 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT cor0.col0 * cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT tab0.col0 * + 45 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 88 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - col0 FROM tab0 cor0 GROUP BY col0

;

SELECT - 86 * cor1.col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT - tab0.col1 + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + ( cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 42 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + 44 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 * 9 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + col0 + + 88 FROM tab0 GROUP BY tab0.col0

;

SELECT + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT tab2.col2 + - tab2.col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT ALL - cor0.col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + - 52 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - 88 AS col1 FROM tab1 AS cor0 GROUP BY col0, cor0.col0

;

SELECT - + col0 * tab0.col0 FROM tab0 GROUP BY col0

;

SELECT 93 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING ( NULL ) IS NULL
;

SELECT - tab0.col1 + tab0.col1 * + tab0.col1 FROM tab0 WHERE - col0 IS NULL GROUP BY tab0.col1

;

SELECT - cor0.col0 * 63 AS col2 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL tab1.col2 * - ( 16 + 63 * tab1.col2 ) AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT COALESCE ( cor0.col2, + cor0.col2 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 21 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + tab1.col2 + - tab1.col2 * - 77 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 88 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT tab1.col2 + + col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col1 * cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 38 * tab0.col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT ALL cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT tab0.col0 * 85 AS col1 FROM tab0 GROUP BY col0

;

SELECT + - col0 + 29 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + - tab0.col2 * - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - + tab2.col1 * 68 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + col1 * tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 28 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 14 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT + tab2.col2 - 1 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - cor0.col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT - 50 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + tab1.col0 + - 95 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 88 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - 48 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT + 86 * tab0.col0 + + tab0.col0 * + 24 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - cor0.col1 * cor0.col0 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT 8 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT + - COALESCE ( tab2.col1, tab2.col1 ) * - tab2.col1 FROM tab2 GROUP BY col1

;

SELECT - ( tab0.col2 ) AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col0 * 63 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 17 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 18 + - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + 5 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col1 FROM tab2, tab1 cor0 GROUP BY cor0.col1

;

SELECT - 56 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 59 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT 95 - - 93 * cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT 50 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT col2 + col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + + 45 AS col2 FROM tab0 GROUP BY col0

;

SELECT + cor0.col2 AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT ALL 99 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL 30 AS col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 68 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 58 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - ( + cor0.col1 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col2 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - 31 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 63 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 57 FROM tab2 GROUP BY tab2.col2

;

SELECT 23 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 55 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + tab1.col2 FROM tab1 WHERE + tab1.col0 NOT IN ( col2 ) GROUP BY tab1.col2

;

SELECT ALL - - 0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 92 FROM tab2 GROUP BY tab2.col2

;

SELECT + - col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + ( ( + cor0.col2 ) ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 73 * + cor0.col1 - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - tab1.col1 + - 52 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col2 * + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT col2 AS col1 FROM tab0 AS cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT - 15 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT + 50 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0 HAVING NULL <= NULL
;

SELECT + col2 - - cor0.col2 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT 24 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT 39 AS col0 FROM tab2 GROUP BY col2

;

SELECT DISTINCT 9 + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - 60 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 3 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 33 - cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + cor0.col1 + 36 * + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 24 FROM tab1 GROUP BY tab1.col0

;

SELECT 72 * cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 67 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT ( + col2 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - ( cor0.col2 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT tab2.col0 * - ( 30 ) + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - 86 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 39 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 30 * - 64 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + - 25 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + tab0.col1 * - tab0.col1 + 15 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + cor0.col2 * cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col1 * - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT DISTINCT + 35 * 92 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 62 + - 43 FROM tab2 GROUP BY col2

;

SELECT - 92 + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL + 15 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + 74 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 10 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - tab2.col0 * tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - + 46 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 18 + - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL - 82 * + col2 + - tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + 23 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + + 58 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT + col2 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT ALL - + 41 AS col1 FROM tab2 GROUP BY col2

;

SELECT ALL + 54 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 14 - + cor0.col2 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - col2 * cor0.col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + - 99 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 98 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - - 39 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 80 FROM tab2 GROUP BY col1

;

SELECT - - 29 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - ( tab2.col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT - ( tab1.col0 ) FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 34 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 97 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - 51 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT col1 * + cor0.col1 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT + 20 AS col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 66 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - cor0.col1 * + col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + + 1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + col0 * - 77 FROM tab2 GROUP BY tab2.col0

;

SELECT + tab1.col1 - - 39 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + - col2 * - 79 AS col2 FROM tab2 GROUP BY col2

;

SELECT ALL + 59 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL cor1.col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT col0 + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT 7 + col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - cor0.col2 * cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + tab2.col2 AS col1 FROM tab2 WHERE NOT NULL IS NULL GROUP BY tab2.col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT + cor0.col2 + + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 38 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 28 AS col0 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - cor0.col2 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col1 * col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - - tab1.col2 + - 19 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col1 - - cor0.col0 FROM tab2 cor0 GROUP BY col0, col1

;

SELECT + cor0.col1 FROM tab1 AS cor0 GROUP BY col0, col1, cor0.col1

;

SELECT DISTINCT + 28 + - cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - COALESCE ( - col2, cor0.col2 * + 55 ) + cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 49 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT 5 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 95 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 73 * cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 38 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - 61 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - 18 * 39 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - - 13 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + - tab1.col0 * tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - 1 + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT + + tab2.col0 + + tab2.col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + 6 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT 85 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 47 * 82 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL tab0.col1 + tab0.col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT ALL 78 * - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT - 32 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + cor0.col2 + cor0.col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT + tab2.col0 - - col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 74 + 7 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT 39 * cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT ( + col1 ) FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col2 * - col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL + 4 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + + tab0.col2 + + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + tab1.col2 * + 54 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 64 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 18 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2

;

SELECT ALL + 30 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + 89 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 25 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 17 + - 97 FROM tab2 GROUP BY tab2.col2

;

SELECT - ( + tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 90 + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + 28 * 6 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 1 * 22 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + 48 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 50 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - tab2.col1 * + 5 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - tab1.col1 + 94 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT 69 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL tab1.col2 - 2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col0 * ( - col0 ) FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 89 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, col0, cor0.col2

;

SELECT 88 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col1 * col1 + col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT - 53 FROM tab1 GROUP BY col1

;

SELECT ALL + 48 + 93 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - col2 * + 52 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT - tab0.col1 * + tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col0 + col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT tab0.col0 * + col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - cor0.col0 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT cor0.col0 * - 12 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT ( 96 ) FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT - 61 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT + 34 FROM tab0 GROUP BY col1

;

SELECT ALL 58 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL - tab2.col0 * + 94 FROM tab2 GROUP BY tab2.col0

;

SELECT 83 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 20 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT DISTINCT tab0.col2 * + tab0.col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT cor0.col0 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - col1 * 24 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - + 77 FROM tab1 GROUP BY col1

;

SELECT ALL + 52 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 44 * tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 91 FROM tab1 GROUP BY col0

;

SELECT ALL 32 + - 3 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT - 82 - + 14 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ( 69 ) AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + 36 FROM tab2 GROUP BY tab2.col0

;

SELECT + + tab0.col0 + + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + - 75 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 48 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col0 * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 55 * - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col1, cor0.col2

;

SELECT ALL - 22 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 23 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 9 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 54 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 84 FROM tab2 GROUP BY tab2.col0

;

SELECT + + tab0.col0 + tab0.col0 * tab0.col0 FROM tab0 GROUP BY col0

;

SELECT cor0.col1 * + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT tab1.col1 FROM tab1 GROUP BY tab1.col1 HAVING tab1.col1 - + col1 IS NULL
;

SELECT + + 59 + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 7 * 58 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 77 FROM tab2 GROUP BY tab2.col2

;

SELECT + 8 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - + 62 * + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 21 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT + 34 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT NULLIF ( 43, tab0.col2 / - tab0.col2 ) FROM tab0 GROUP BY col2

;

SELECT 64 FROM tab2 AS cor0 GROUP BY cor0.col0, col0

;

SELECT 17 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + tab2.col1 - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 68 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL ( - 76 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 90 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 36 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT cor0.col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT + 57 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + - col0 FROM tab2 GROUP BY col0

;

SELECT ALL cor0.col2 AS col2 FROM tab0 cor0 GROUP BY col2

;

SELECT ALL + 58 FROM tab2 GROUP BY col0

;

SELECT ALL - 30 + + cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col2

;

SELECT 9 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - cor0.col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 60 + + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 13 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 28 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + + 16 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL tab0.col2 + 48 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - tab2.col1 * - tab2.col1 FROM tab2 GROUP BY col1

;

SELECT + - ( - 45 ) FROM tab2 GROUP BY col2

;

SELECT ( 43 ) + + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 87 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1 HAVING NOT NULL IS NULL
;

SELECT ALL - tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING NOT + tab2.col1 IS NULL
;

SELECT + 52 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - 60 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL cor0.col2 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor1.col0

;

SELECT ( 67 ) + + cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL - cor0.col2 * 84 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 93 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 31 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT - - tab0.col2 * - tab0.col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT DISTINCT cor0.col0 + + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 88 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 54 + tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT tab1.col1 * tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 55 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + col2 + - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL tab2.col0 FROM tab2 GROUP BY tab2.col0 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - 16 + 41 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 10 + 13 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 51 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT + + 6 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT + tab2.col2 FROM tab2 WHERE NOT NULL BETWEEN NULL AND tab2.col0 GROUP BY tab2.col2

;

SELECT + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - col1 FROM tab0 GROUP BY tab0.col1 HAVING NOT ( + tab0.col1 ) IS NULL
;

SELECT 65 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 + 80 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 76 * + col1 + - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - cor0.col1 AS col2 FROM tab0 cor0 GROUP BY col0, cor0.col1

;

SELECT + 57 FROM tab2 GROUP BY col0

;

SELECT ALL + cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT ( cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 21 FROM tab1 GROUP BY tab1.col1

;

SELECT 79 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col1 * - 95 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - - 17 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 47 * - cor0.col0 + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 86 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 18 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + tab2.col2 + 11 * tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 63 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 94 - 39 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL cor0.col1 - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - tab1.col1 + + 31 FROM tab1 GROUP BY col1

;

SELECT - cor0.col2 * 0 FROM tab1 AS cor0 GROUP BY col2, cor0.col0, cor0.col1

;

SELECT DISTINCT + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + - 38 FROM tab2 GROUP BY tab2.col0

;

SELECT ( - col2 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 3 * - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 6 + + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab2.col2 + + 97 * tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL cor0.col1 * + col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + 67 AS col1 FROM tab2 cor0 GROUP BY cor0.col1, col0

;

SELECT - 83 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 16 - - tab1.col1 FROM tab1 GROUP BY col1

;

SELECT ALL + 19 + cor0.col1 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL tab2.col1 * 26 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - - 85 FROM tab2 GROUP BY tab2.col1

;

SELECT + - 50 + - 57 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + ( + 51 ) FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - tab2.col2 * col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - col0 + 65 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 25 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 19 + col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 48 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL - 61 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 77 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 79 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 88 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT - 87 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL cor0.col1 + - cor0.col1 FROM tab2 cor0 GROUP BY col1

;

SELECT - col2 + - tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - col1 * - cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT 76 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 91 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + + 65 * tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT col2 * + 16 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * cor0.col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 58 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 95 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT 40 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - col1 + + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - tab0.col2 FROM tab0 WHERE NULL IN ( - tab0.col1 ) GROUP BY tab0.col2

;

SELECT - ( 46 ) * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 77 * 66 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT ( - cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + + 47 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL <> NULL
;

SELECT - ( 13 ) * - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + ( - 1 ) AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ( tab0.col2 ) * tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + - tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT 51 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT - tab1.col1 - col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT 77 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, col2

;

SELECT ALL 87 FROM tab1 AS cor0 GROUP BY col1, cor0.col1

;

SELECT + 5 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 22 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + cor0.col2 AS col1 FROM tab2 cor0 GROUP BY col2

;

SELECT 40 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT + 33 - - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 93 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - col1 * 46 + - col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 18 AS col1 FROM tab1 GROUP BY col0

;

SELECT ALL - 88 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + - col1 * - 66 FROM tab0 GROUP BY tab0.col1

;

SELECT - 65 * cor0.col1 + + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + tab1.col1 * - 30 - tab1.col1 FROM tab1 GROUP BY col1

;

SELECT - 50 FROM tab0 GROUP BY tab0.col2

;

SELECT + col2 * 16 + 83 * + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - ( + 14 ) * - 13 FROM tab2 GROUP BY tab2.col0

;

SELECT + ( - 56 ) AS col1 FROM tab0 cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT + ( cor1.col1 ) FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - - 64 FROM tab0 GROUP BY tab0.col2

;

SELECT + - ( col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col0 * 92 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col1 * + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT tab1.col1 + + tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT 49 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 98 * tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - 34 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - tab0.col1 + 92 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 82 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col0 * - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col2 - - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 21 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col2

;

SELECT + + cor0.col1 AS col2 FROM tab1, tab2 cor0 GROUP BY cor0.col1

;

SELECT + 56 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 75 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + + col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - 25 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 31 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT 23 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + col0 * - 75 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 5 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 12 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - 25 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + 90 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - 8 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + tab1.col2 FROM tab1 GROUP BY tab1.col2 HAVING ( col2 ) IS NULL
;

SELECT tab0.col1 * - ( - tab0.col1 ) FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 20 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 * - ( - col2 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + + 72 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + 86 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 21 * cor0.col1 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + - col1 * + 80 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1, col1

;

SELECT ALL 5 + col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - - 63 * + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT tab0.col1 * 80 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT tab1.col0 * 60 - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + - 97 FROM tab1 GROUP BY tab1.col0

;

SELECT 43 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + + ( + 88 ) AS col1 FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + tab0.col1 * - tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1 HAVING NULL = NULL
;

SELECT ALL + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT - cor0.col1 - + col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 64 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT - col1 + + cor0.col1 * col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT + 91 - + 92 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL cor0.col1 * + ( - col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 11 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + 28 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 99 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - cor0.col0 * + 79 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 76 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 1 + - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 + + cor0.col1 * + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT 32 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 86 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL - cor0.col2 * cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 + cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1, col2

;

SELECT ALL - tab1.col0 + + 97 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + ( cor0.col1 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 23 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - cor0.col0 * + 77 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 98 * - 54 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 77 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 72 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 96 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT 53 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT ALL 21 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - + tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL tab1.col2 - 1 AS col1 FROM tab1 GROUP BY col2

;

SELECT - + 2 FROM tab1 GROUP BY tab1.col0

;

SELECT + 42 FROM tab2 GROUP BY tab2.col1

;

SELECT + - 58 * - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + cor0.col2 * cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT + cor0.col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT + cor0.col2 * + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - - tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + - tab0.col0 + + 61 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 96 * - col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 58 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 97 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0 HAVING ( NULL ) IS NOT NULL
;

SELECT 20 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL 14 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 94 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - col1 + tab0.col1 * + 56 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 33 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 19 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 28 FROM tab0 GROUP BY col2

;

SELECT - 58 * 37 - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 71 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 59 + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 62 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 18 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 20 * - col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - + tab2.col1 + - tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 35 AS col2 FROM tab0 GROUP BY col1

;

SELECT ALL cor1.col1 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT + col0 + tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 27 * + 98 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + ( 45 ) * - col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL + 71 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + + 60 * tab0.col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT + cor0.col1 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - - tab1.col0 * tab1.col0 + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - 3 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - cor0.col2 + + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 23 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 4 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT 81 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 26 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 19 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + tab2.col0 FROM tab2 GROUP BY tab2.col0 HAVING NOT ( NULL ) IS NULL
;

SELECT + 92 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 42 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - - tab0.col1 + - 87 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 67 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 56 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 26 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 27 + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 * + 76 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - tab0.col1 * 10 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - 18 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 26 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - 16 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 46 + + col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col0, cor0.col0

;

SELECT DISTINCT cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col0

;

SELECT DISTINCT - tab2.col0 - tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT tab0.col2 * - col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + tab0.col0 FROM tab0 GROUP BY tab0.col0 HAVING NULL <> ( NULL )
;

SELECT DISTINCT - tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING ( NULL ) IS NULL
;

SELECT col1 * + tab2.col1 FROM tab2 GROUP BY col1

;

SELECT 76 FROM tab2 GROUP BY col0

;

SELECT DISTINCT 91 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - 98 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 67 FROM tab2 GROUP BY tab2.col1

;

SELECT - 91 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - 34 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - + tab1.col1 + - tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 60 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL 86 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 63 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col2

;

SELECT - 32 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 95 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + 82 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + - 36 FROM tab1 GROUP BY col0

;

SELECT 4 * cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT 4 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT ALL cor0.col1 * col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - cor0.col0 * + cor0.col1 + + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + - ( col1 ) AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - - tab2.col0 * + col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL 42 * + 64 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + - 29 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL tab2.col1 - 56 * + 56 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - cor0.col2 + cor0.col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL - + tab0.col2 + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - + tab0.col0 + - 24 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 10 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - + 7 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 5 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + + ( - tab1.col0 ) + - tab1.col0 * + 52 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - + tab1.col0 * col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT col1 * tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 63 + - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - 22 + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 88 * cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT - + 60 * 81 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - + 39 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - cor0.col0 - + cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + cor0.col0 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + cor0.col0 + 86 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col2 - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT 44 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT tab2.col1 + 96 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT col2 * + cor0.col2 + + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - ( - 96 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 64 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 31 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col2 * cor0.col0 + cor0.col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col2 + cor0.col2 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL CASE cor1.col0 WHEN + 67 THEN + 51 END FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT - 56 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - - 88 FROM tab0 GROUP BY tab0.col0

;

SELECT - 66 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + + col0 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT cor0.col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT tab1.col0 * col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING + col0 IS NULL
;

SELECT + tab2.col1 FROM tab2 WHERE NOT ( tab2.col2 * tab2.col0 ) NOT IN ( - tab2.col0 ) GROUP BY tab2.col1

;

SELECT tab1.col1 * - tab1.col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT DISTINCT + tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING ( NULL ) IS NOT NULL
;

SELECT ALL col1 FROM tab0 GROUP BY col1 HAVING NOT ( + tab0.col1 ) IS NULL
;

SELECT ALL + tab1.col2 * - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - - 45 * 77 AS col1 FROM tab0, tab0 AS cor0 GROUP BY tab0.col0

;

SELECT ALL + 54 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT + + col2 * + 47 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT tab2.col0 + tab2.col0 * 92 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + cor0.col2 + + col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - 7 + col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col2 AS col2 FROM tab0 cor0 GROUP BY col2

;

SELECT ALL 85 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL col0 FROM tab1 cor0 GROUP BY cor0.col0, col0

;

SELECT - 72 FROM tab2 GROUP BY col0

;

SELECT COALESCE ( + cor0.col1, cor0.col1 * + cor0.col1 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 30 + 46 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - 1 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - cor0.col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ( cor0.col1 ) AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + 20 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 12 * tab0.col0 + 85 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT + 49 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col0 * + 71 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ( 36 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT tab1.col1 * - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 44 * tab1.col0 - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 99 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT 74 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0, cor0.col1

;

SELECT cor0.col0 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0, cor1.col2

;

SELECT - 16 + 86 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 15 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + ( 91 ) * col2 + col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + - 53 FROM tab0 GROUP BY tab0.col2

;

SELECT + 44 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT 10 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT - - tab1.col2 * - 8 FROM tab1 GROUP BY tab1.col2

;

SELECT + 83 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + tab0.col2 * tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 40 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 14 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT + - 89 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + 47 FROM tab0 GROUP BY col2

;

SELECT + 60 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL tab2.col0 + 43 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 54 + + 16 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + - 79 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + tab0.col2 * - 8 + col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 87 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 37 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - - 34 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT ( + 35 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 68 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + cor0.col0 AS col1 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL - cor0.col1 + cor0.col1 * + 18 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + tab1.col1 * + 35 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + cor0.col1 + + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 53 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - cor0.col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 * cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 + + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1, cor0.col2, col0

;

SELECT cor0.col1 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT + 57 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - tab1.col0 + + tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col1 * 34 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - col0 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0 HAVING NULL IS NULL
;

SELECT + 75 + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING NULL < NULL
;

SELECT DISTINCT + cor0.col1 - - cor0.col1 * - 13 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 42 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 45 + - 93 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT tab1.col1 * 29 + + tab1.col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT 62 FROM tab0 GROUP BY tab0.col1

;

SELECT - 40 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - + 27 AS col1 FROM tab0 GROUP BY col0

;

SELECT cor0.col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT + - 18 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 * + 24 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab0.col2 * + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - 10 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 7 * + 45 + + cor0.col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT 74 * 94 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 43 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + tab2.col1 - + tab2.col1 * tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + cor0.col2 - cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT 28 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + tab1.col0 + - tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - + 22 * 99 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 23 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT col2 * ( 17 ) FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 6 * 57 FROM tab1 GROUP BY tab1.col0

;

SELECT - 99 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + ( - 81 ) FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 41 * cor0.col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT tab1.col2 + 9 FROM tab1 GROUP BY tab1.col2

;

SELECT 24 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 0 + + 23 * - 98 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 83 - + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + cor0.col2 * - col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 42 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL 42 - cor0.col0 * cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT tab2.col1 + - 20 FROM tab2 GROUP BY col1

;

SELECT col1 - + 65 AS col1 FROM tab2 GROUP BY col1

;

SELECT ALL 91 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + 82 - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor1.col0 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1, cor1.col0

;

SELECT col0 - - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 1 AS col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT 39 FROM tab0 GROUP BY tab0.col0

;

SELECT 92 FROM tab1 GROUP BY tab1.col0

;

SELECT 55 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 84 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 70 + + 78 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 71 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + + 37 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 AS col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - 47 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - + 75 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - + tab1.col2 + 17 FROM tab1 GROUP BY tab1.col2

;

SELECT + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0 HAVING NOT ( NULL ) IS NULL
;

SELECT tab1.col1 AS col2 FROM tab1 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - cor0.col2 * 43 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL 95 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col1 + - 91 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - cor0.col2 * 76 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - ( 39 ) + - tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + + 46 AS col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - 90 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 88 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + cor0.col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL 97 + 16 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT ALL + 76 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT - cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT 57 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 58 * + tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - tab0.col0 FROM tab0 GROUP BY tab0.col0 HAVING ( NULL ) IS NOT NULL
;

SELECT - 10 * tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 40 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL + col2 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col2, col2

;

SELECT - + tab0.col0 + col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col2 + cor1.col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor0.col1, cor1.col2

;

SELECT ALL - cor1.col2 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor1.col1

;

SELECT ALL 13 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 51 * cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 9 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 43 AS col1 FROM tab1 GROUP BY col2

;

SELECT 63 + 78 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 55 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT - 87 FROM tab0 GROUP BY tab0.col1

;

SELECT col0 * col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 42 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 71 * 61 - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col1 * + 62 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 * + cor0.col1 + - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 51 * tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 46 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT + - 45 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 12 FROM tab0 GROUP BY tab0.col0

;

SELECT 74 AS col1 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + 78 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT tab1.col2 + 77 FROM tab1 GROUP BY col2

;

SELECT + 27 + + 43 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 89 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 40 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT col1 + + 24 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 12 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 44 + - col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - + 5 FROM tab0 GROUP BY tab0.col0

;

SELECT - 32 + 29 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - cor0.col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - tab2.col0 * - col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - 16 + cor0.col1 AS col0 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT 97 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + - 4 FROM tab2 GROUP BY tab2.col0

;

SELECT + 58 + - 66 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 87 * 93 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + cor0.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - - 77 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 43 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL ( - tab0.col1 ) AS col2 FROM tab0 GROUP BY col1

;

SELECT - 55 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - + tab0.col1 + 83 AS col1 FROM tab0 GROUP BY col1

;

SELECT - tab1.col1 * + 38 AS col1 FROM tab1 GROUP BY col1

;

SELECT ALL - 6 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 43 FROM tab1 GROUP BY col2

;

SELECT DISTINCT cor0.col2 * + ( + cor0.col2 * 71 ) FROM tab2 AS cor0 GROUP BY col2

;

SELECT - 29 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col0 * + 77 AS col1 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT - 22 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - tab1.col0 * - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - 13 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 4 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 73 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col1 * - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 48 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 88 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 24 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - 76 AS col0 FROM tab1 cor0 GROUP BY col2

;

SELECT cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT cor0.col0 + 37 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - 91 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - - tab1.col0 * - 74 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col0 * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT + + 13 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT col2 * 5 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 58 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 59 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 93 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL - cor0.col1 * - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - 76 FROM tab0 GROUP BY tab0.col2

;

SELECT 14 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + cor1.col0 + + cor1.col0 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT DISTINCT col0 * cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - tab0.col1 + - 38 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col2 + + cor0.col2 * cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + cor0.col1 * 1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL tab1.col0 + + tab1.col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT ALL + 89 FROM tab1 GROUP BY tab1.col2

;

SELECT - + tab2.col2 + - col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 44 FROM tab1 GROUP BY tab1.col2

;

SELECT 87 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + cor0.col1 + - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + 8 * + cor0.col2 + 84 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 35 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + + 88 + col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + + 42 + - tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - 61 * 68 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, col2

;

SELECT DISTINCT + 89 FROM tab0 GROUP BY tab0.col2

;

SELECT 61 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + 46 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 1 + - cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL ( 80 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 * 52 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 54 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 61 * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - 17 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT cor0.col0 - - 68 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 63 * - 75 FROM tab1 GROUP BY col1

;

SELECT + 54 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 2 + + col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT tab2.col1 + - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT + 57 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 58 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL tab0.col0 * tab0.col0 FROM tab0 GROUP BY tab0.col0 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT DISTINCT - + col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT col1 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT - + 56 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + 29 * 49 + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 13 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - 38 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - col2 + + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 68 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col1

;

SELECT DISTINCT 87 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL CASE - COALESCE ( + 56, col1 ) WHEN cor0.col1 + cor0.col0 THEN + cor0.col0 + 5 END AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - 50 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL + 64 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 67 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab2.col1 * - 25 + + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col0 * - cor0.col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col0, cor0.col2

;

SELECT DISTINCT - + col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 29 FROM tab1 GROUP BY tab1.col2

;

SELECT 28 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 93 FROM tab2 GROUP BY col0

;

SELECT ALL + col0 * + cor0.col0 + + col0 * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT tab1.col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL IS NULL
;

SELECT - 73 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT ALL - cor1.col2 * 78 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor1.col2

;

SELECT cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0, cor0.col1

;

SELECT DISTINCT - - 40 FROM tab1 GROUP BY tab1.col1

;

SELECT - 0 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + col0 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - - tab1.col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT + cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0, cor0.col2, cor1.col1

;

SELECT - 39 FROM tab0 GROUP BY col0

;

SELECT 43 * cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + ( 0 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 * - 63 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 48 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1, cor0.col0

;

SELECT ALL + + tab2.col2 * + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + tab2.col2 + - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL tab2.col2 + col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col2, cor0.col2

;

SELECT ALL - cor0.col0 * ( + cor0.col0 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 86 + 33 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL 62 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab0.col2 FROM tab1 AS cor0 CROSS JOIN tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 29 FROM tab1 GROUP BY tab1.col0

;

SELECT - 65 FROM tab0 GROUP BY col2

;

SELECT ALL tab0.col2 + col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 17 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + cor0.col2 * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - cor0.col1 + 11 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - cor0.col0 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - 27 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 3 * + 42 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + ( + 39 ) FROM tab1 cor0 GROUP BY cor0.col2, col2

;

SELECT DISTINCT + 34 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + cor0.col0 - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 89 - 95 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + + tab1.col2 * - col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 47 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - ( tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 75 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + 44 * - tab1.col2 FROM tab1 GROUP BY col2

;

SELECT ALL + tab2.col1 * - 28 FROM tab2 GROUP BY tab2.col1

;

SELECT 45 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col1 * cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + + 67 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 32 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - cor0.col2 + + 10 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + + 71 FROM tab1 GROUP BY tab1.col0

;

SELECT + 8 - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 84 * - 62 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 81 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - col2 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - cor0.col1 + 45 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 12 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT 14 + + col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 * 65 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 99 + col1 FROM tab0 GROUP BY tab0.col1

;

SELECT 75 FROM tab2 GROUP BY tab2.col1

;

SELECT + - 6 AS col0 FROM tab2 GROUP BY col1

;

SELECT ALL + + col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT tab2.col2 * - tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + + col2 * - tab2.col2 + 37 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - col0 * + 8 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor1.col1

;

SELECT col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 * 13 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 3 + 69 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + + 81 FROM tab2 GROUP BY tab2.col2

;

SELECT - cor0.col2 * + cor0.col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL 68 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2, cor1.col1

;

SELECT + tab1.col1 * 10 FROM tab1 GROUP BY col1

;

SELECT DISTINCT 1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + ( - tab0.col1 ) AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - tab0.col1 * + 34 FROM tab0 GROUP BY tab0.col1

;

SELECT - 40 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 19 * col1 + + cor0.col1 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT ( - 91 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 34 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ( cor1.col2 ) AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor1.col2

;

SELECT 4 AS col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT - - tab1.col2 * - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 48 + - tab1.col2 * - 78 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + - tab0.col2 + tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT - - 54 FROM tab2 GROUP BY tab2.col2

;

SELECT + - 0 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 99 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT - 37 AS col1 FROM tab2 cor0 GROUP BY col2

;

SELECT cor0.col0 + - 4 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, col0

;

SELECT DISTINCT - ( + cor0.col1 ) AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT 17 AS col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + tab1.col0 + 70 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT cor0.col2 * 33 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + + 27 FROM tab2 GROUP BY tab2.col2

;

SELECT ( - tab2.col2 ) AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - 98 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col1 * + cor0.col1 - - 19 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT cor0.col0 + ( - 22 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 36 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 75 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - - 35 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col1 + 57 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT ALL 93 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0, col2

;

SELECT ALL cor0.col1 - - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 38 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 98 FROM tab1 GROUP BY tab1.col0

;

SELECT - - 83 FROM tab2 GROUP BY col1

;

SELECT DISTINCT + 83 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + + col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + + 68 AS col0 FROM tab0 GROUP BY col0

;

SELECT - - ( 70 ) FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 89 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 48 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 40 * tab1.col0 + col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col2 * cor0.col2 + NULLIF ( 1 + - cor0.col2 * 41, - cor0.col2 ) FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + + col1 * - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + + col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT 1 + + 37 AS col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT - - 92 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - tab2.col1 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - cor0.col1 FROM tab1 AS cor0 WHERE NOT NULL IS NULL GROUP BY cor0.col1

;

SELECT - tab1.col2 AS col1 FROM tab1 WHERE - col1 IS NULL GROUP BY tab1.col2

;

SELECT DISTINCT + cor0.col2 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, col1

;

SELECT ALL 76 + + col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 96 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT COALESCE ( cor0.col0, - col0 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL - - tab0.col1 * + 60 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + - ( ( + tab0.col1 ) ) AS col1 FROM tab0 GROUP BY col1

;

SELECT ALL - col0 * tab2.col0 + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + tab0.col2 * 76 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + cor0.col0 + - 63 * - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 31 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 8 FROM tab1 GROUP BY tab1.col1

;

SELECT - cor0.col2 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 16 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL tab0.col2 - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 15 - tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 90 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + cor0.col2 * + 37 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - 81 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 36 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - 94 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL cor0.col0 * cor0.col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT 74 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 3 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 AS col0 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT + 34 * + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 19 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col2 - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 59 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 + 86 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 85 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL + tab0.col1 + + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + + tab1.col0 * - 0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT 8 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 57 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT - - 69 + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 19 FROM tab2 GROUP BY tab2.col0

;

SELECT - 59 FROM tab2, tab0 AS cor0 GROUP BY tab2.col2

;

SELECT DISTINCT 67 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - 36 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 99 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - cor0.col1 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL cor0.col1 * - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 34 FROM tab2 AS cor0 GROUP BY col0

;

SELECT cor0.col2 FROM tab1 cor0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT DISTINCT - - 89 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 43 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 5 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col0 + 50 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + 35 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + tab2.col0 * - 75 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + + 22 FROM tab2 GROUP BY tab2.col1

;

SELECT - - tab1.col0 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - - 73 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + cor0.col2 + + 54 AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + cor0.col0 + - 73 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 73 - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT 37 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + - 61 AS col2 FROM tab2, tab0 AS cor0 GROUP BY tab2.col2

;

SELECT - 83 * + col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 64 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + cor0.col2 * 33 AS col0 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT + cor0.col2 * - 77 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL tab1.col0 * 70 FROM tab1 GROUP BY col0

;

SELECT + 94 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - 59 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - ( 8 ) + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT - 4 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 63 + + col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 16 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab2.col2 * + 10 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL ( 1 ) FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 97 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - 88 AS col0 FROM tab0 GROUP BY col1

;

SELECT - 0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - - tab1.col2 * + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 35 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT tab0.col1 - - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 74 + + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 5 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 8 - + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - tab2.col2 - - 63 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - ( + cor0.col0 ) * cor0.col0 + 20 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab2.col1 + + 69 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - tab2.col1 + ( - 20 + - 56 ) FROM tab2 GROUP BY tab2.col1

;

SELECT + tab0.col1 + 98 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col1 * cor0.col1 AS col1 FROM tab0 cor0 GROUP BY col1

;

SELECT ALL cor0.col2 + + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 23 FROM tab1 GROUP BY col1

;

SELECT - 37 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ( + 88 ) FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + cor1.col1 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor1.col2

;

SELECT - tab0.col0 + - 40 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 16 + tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 47 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 64 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 94 * - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT + cor0.col0 * + cor0.col0 + - cor0.col0 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 10 * - tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT 57 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT COALESCE ( - cor0.col0, - 88 ) FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT + 9 AS col0 FROM tab1 GROUP BY col2

;

SELECT ( cor0.col0 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col1 * - cor0.col1 - + ( cor0.col2 + - cor0.col2 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 83 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 + + 25 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT tab2.col0 * + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 FROM tab1 cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - 35 * + col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - + 39 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col1 * + col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 10 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 68 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 89 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - + 29 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - + ( 96 ) + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT 13 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + 17 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 84 * 14 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 92 * tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - cor0.col2 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, col0

;

SELECT cor0.col0 * + cor0.col2 + cor0.col2 * cor0.col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT ALL 70 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL - 71 FROM tab2 GROUP BY tab2.col2

;

SELECT - - tab1.col2 * - col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 74 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + 62 * col1 + - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 40 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - - tab2.col1 * - tab2.col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT 44 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL ( 5 ) + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - tab0.col1 * 36 + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - 41 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 79 + 97 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col1 * 91 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - ( - tab2.col2 ) FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - tab0.col2 + tab0.col2 * + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT - - tab2.col2 * 16 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + tab1.col1 - tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col2 + col2 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING ( NULL ) NOT IN ( + cor0.col2 )
;

SELECT DISTINCT + - tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - - 35 * tab0.col0 + - tab0.col0 FROM tab0 GROUP BY col0

;

SELECT - cor0.col1 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 23 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL - col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + - 24 AS col0 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - cor0.col2 * 6 + 76 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + tab0.col0 + + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 36 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - - 43 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 44 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT col1 * tab0.col1 + - 40 FROM tab0 GROUP BY tab0.col1

;

SELECT col1 * tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + + tab1.col0 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 37 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL cor0.col0 + + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col1

;

SELECT ALL tab1.col1 + 63 FROM tab1 GROUP BY col1

;

SELECT DISTINCT + 46 * cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 28 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + - tab2.col1 + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 17 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 73 * cor0.col1 + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 32 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 6 * 14 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - - tab0.col0 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + cor0.col2 * - 81 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + 13 AS col1 FROM tab1 GROUP BY col2

;

SELECT 48 * - 41 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 85 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 42 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 3 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT 4 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - + 91 * - tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + + col1 + + col1 * tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 3 * + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col2

;

SELECT + 56 * 74 AS col0 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT - 55 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL - 92 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 46 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - 4 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 47 - + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT tab0.col2 * - tab0.col2 - 87 FROM tab0 GROUP BY tab0.col2

;

SELECT + 3 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 56 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT 98 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + cor0.col0 + - 96 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + 64 + - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + + NULLIF ( - 71, - tab2.col0 ) * + 3 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + - 39 FROM tab2 GROUP BY tab2.col0

;

SELECT + 46 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL - tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1 HAVING - tab0.col1 IS NULL
;

SELECT tab2.col0 AS col2 FROM tab2 WHERE NOT col2 + - col2 IS NULL GROUP BY tab2.col0 HAVING ( NULL ) IS NOT NULL
;

SELECT 62 FROM tab2, tab1 AS cor0 GROUP BY tab2.col2

;

SELECT + 16 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + cor0.col2 * cor0.col0 + col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 78 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL + tab2.col2 * 1 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + col1 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 3 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - tab0.col0 * 71 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT col1 + + 36 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col2 - cor0.col1 * - cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + ( 84 ) FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 AS col2 FROM tab1, tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL + 6 + - col2 * - col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - 19 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 15 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL 70 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 52 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT tab1.col1 - - tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + tab0.col2 + + 22 FROM tab0 GROUP BY tab0.col2

;

SELECT col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT ALL cor0.col1 * NULLIF ( cor0.col1, - cor0.col1 ) + - cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 99 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 57 FROM tab1 GROUP BY col0

;

SELECT ALL 72 + + tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 24 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT tab0.col1 * + 52 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 7 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + 77 FROM tab1 GROUP BY tab1.col2

;

SELECT + tab0.col2 * + 85 FROM tab0 GROUP BY tab0.col2

;

SELECT - 88 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL + + 78 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + cor0.col2 + - col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - 25 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 77 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 62 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 19 + + tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - - tab1.col2 * + col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - + tab1.col1 * 15 - 46 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - - tab2.col2 * 28 + + 46 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 17 FROM tab1 GROUP BY col2

;

SELECT - 71 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col0 * - 11 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + + tab2.col1 * - tab2.col1 + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + tab0.col1 AS col0 FROM tab0 WHERE NOT ( NULL ) NOT IN ( tab0.col1 ) GROUP BY tab0.col1

;

SELECT DISTINCT + - 53 + tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + - 32 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 27 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - ( + 45 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT cor0.col1 - cor0.col2 * - cor0.col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT DISTINCT - 75 + + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + - 39 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 36 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 56 FROM tab1 GROUP BY col2

;

SELECT ALL - + 17 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 65 - 93 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 18 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - tab0.col2 * 38 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 7 * 65 + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT - + 91 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 39 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + + 96 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + ( - tab2.col2 ) FROM tab2 GROUP BY tab2.col2

;

SELECT + 18 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 6 + tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 97 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 40 AS col2 FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT ( 83 ) FROM tab1 GROUP BY tab1.col1

;

SELECT + 96 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - 26 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - - 60 FROM tab2 GROUP BY tab2.col2

;

SELECT 78 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + - 6 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - + 94 AS col1 FROM tab0 GROUP BY col2

;

SELECT + 29 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - cor0.col0 * ( 27 ) FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT + 23 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 51 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 41 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 75 FROM tab2 GROUP BY tab2.col0

;

SELECT + 78 + 84 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col1

;

SELECT ALL cor0.col0 + - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 79 AS col2 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL 72 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col1 + NULLIF ( + cor0.col1, cor0.col1 * 36 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT - ( + tab1.col1 ) AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 13 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - - 25 + + tab1.col1 FROM tab1 GROUP BY col1

;

SELECT cor0.col2 + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT 62 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT ( 18 ) * cor0.col0 AS col0 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ( 62 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT + 46 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - tab2.col2 + - 66 FROM tab2 GROUP BY col2

;

SELECT + 4 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL + 92 FROM tab2 GROUP BY tab2.col0

;

SELECT + 43 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 34 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ( ( cor0.col1 ) ) FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT cor0.col0 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - tab0.col1 * 84 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 74 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NOT NULL
;

SELECT cor0.col1 + + cor0.col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL tab2.col1 + + 52 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - 10 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT cor1.col2 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor1.col2

;

SELECT ALL cor0.col2 + cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * 97 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - NULLIF ( tab1.col0, + ( 54 ) ) FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 89 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + + 33 * - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - col0 * col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT 50 FROM tab0 GROUP BY col2

;

SELECT + 40 * col1 + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL 3 FROM tab2 GROUP BY tab2.col0

;

SELECT 37 AS col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT cor0.col2 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col1

;

SELECT ALL + + 92 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - + 28 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + cor0.col1 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 64 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab2.col2 * tab2.col2 - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 43 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 * ( 15 ) AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + 68 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1, cor1.col1

;

SELECT + + 79 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 8 FROM tab0 GROUP BY tab0.col2

;

SELECT 97 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - tab0.col1 AS col2 FROM tab0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT 67 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT tab2.col2 - + 52 AS col2 FROM tab2 GROUP BY col2

;

SELECT + 52 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + - tab0.col0 * tab0.col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT ALL - 54 FROM tab1 GROUP BY tab1.col2

;

SELECT + ( cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 19 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT COALESCE ( + cor0.col1, - cor0.col2, - cor0.col1 ) * - 37 - - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, col2

;

SELECT + 11 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 * - 70 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + 11 + cor0.col0 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + ( + 63 ) AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - + 6 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 45 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col1 + 80 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col2 + 93 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 16 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col0 * cor0.col0 + - cor0.col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - + 98 * + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - 32 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + cor1.col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT + + tab2.col2 * - col2 FROM tab2 GROUP BY col2

;

SELECT - col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 78 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT + - 14 - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + + tab0.col1 + 66 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 35 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col0 * 60 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL + cor0.col2 * + 72 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + 75 FROM tab2 GROUP BY col2

;

SELECT - 61 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 80 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - cor0.col2 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT + + col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 19 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + tab2.col1 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - 51 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 50 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 19 AS col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - + col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 59 * NULLIF ( cor0.col1, cor0.col1 ) AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col1

;

SELECT ALL tab0.col1 - tab0.col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT ALL 8 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 54 + 74 FROM tab2 AS cor0 GROUP BY col0, cor0.col0

;

SELECT 83 FROM tab2 GROUP BY tab2.col0

;

SELECT + 84 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + + 8 + + 57 * col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT - 9 + tab1.col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - 3 FROM tab2 GROUP BY tab2.col2

;

SELECT + 88 AS col1 FROM tab1 GROUP BY col0

;

SELECT ALL + 99 + - tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 77 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT 38 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - tab2.col0 + - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + - tab2.col2 * 67 FROM tab2 GROUP BY col2

;

SELECT - + 62 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL - 56 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 76 FROM tab1 GROUP BY tab1.col1

;

SELECT - 94 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - - tab2.col2 * 23 FROM tab2 GROUP BY tab2.col2

;

SELECT - tab0.col0 - + 31 FROM tab0 GROUP BY tab0.col0

;

SELECT tab2.col0 + col0 FROM tab2 GROUP BY tab2.col0

;

SELECT col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT 64 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col1 + 69 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + + 24 - + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 27 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - 43 * - cor1.col1 AS col0 FROM tab2 cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col2, cor1.col1

;

SELECT cor0.col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 93 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 97 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 54 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 17 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + tab1.col0 + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + col1 - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + + 85 FROM tab2 GROUP BY tab2.col0

;

SELECT + 80 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT 53 * - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT col1 * + 69 AS col2 FROM tab0 GROUP BY col1

;

SELECT 27 + tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - - 62 FROM tab0 GROUP BY tab0.col2

;

SELECT - 85 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 46 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 26 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + + tab0.col0 + - 69 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + + 29 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + 8 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 32 - col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 FROM tab1 cor0 GROUP BY cor0.col2, col1

;

SELECT 9 + tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + - col1 * - tab0.col1 + 29 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 74 * cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL 73 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + 72 FROM tab1 GROUP BY tab1.col1

;

SELECT 37 FROM tab2 GROUP BY tab2.col0

;

SELECT - 68 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 19 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT + ( + tab1.col0 ) AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - + ( 66 ) FROM tab2 GROUP BY tab2.col0

;

SELECT + 8 FROM tab2 GROUP BY tab2.col0

;

SELECT 45 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 60 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col2 + col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - cor0.col0 * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 18 * - cor0.col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT 82 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + col1 * 14 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 97 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + COALESCE ( cor0.col0, cor0.col0 ) * - cor0.col0 AS col0 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT 2 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 48 FROM tab2 GROUP BY tab2.col2

;

SELECT + 9 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 90 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 32 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 * 92 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL 26 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col1 - + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + 72 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 50 + - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ( + 19 ) FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT tab1.col2 * + 25 - - tab1.col2 * tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 55 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col0 - + cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - - 76 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 40 - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ( + cor0.col1 ) AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1, cor0.col0

;

SELECT tab0.col1 + - tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 40 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 41 - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - + tab0.col1 * tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - - 56 FROM tab0 GROUP BY tab0.col0

;

SELECT + cor0.col2 - 2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + - col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 74 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT tab1.col0 + 81 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2 HAVING col2 <= NULL
;

SELECT + col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING ( - col0 ) IS NULL
;

SELECT col1 * tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL cor0.col1 * col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + cor0.col0 * 29 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 67 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 32 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + cor0.col0 * + cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL + - 49 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - col0 + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col0 + cor0.col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL + cor0.col0 * - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + tab2.col0 AS col2 FROM tab2 WHERE NOT NULL NOT IN ( + tab2.col0 ) GROUP BY tab2.col0 HAVING ( NULL ) IS NOT NULL
;

SELECT + tab1.col2 - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - col1 + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 58 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + 14 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 29 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT 7 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + - col1 FROM tab1 GROUP BY col1

;

SELECT ALL cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL - + 61 FROM tab0 GROUP BY tab0.col1

;

SELECT + 14 - cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL 25 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL 54 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - - 83 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + 62 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 98 FROM tab0 GROUP BY col1

;

SELECT ALL - + tab1.col2 + + 48 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 68 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 30 * + 12 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col2 * 28 + + 15 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT + 83 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT col0 + + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - - 57 FROM tab1 GROUP BY tab1.col1

;

SELECT - 7 FROM tab1 GROUP BY tab1.col1

;

SELECT 66 FROM tab0 GROUP BY tab0.col1

;

SELECT - col1 * + 24 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - 25 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + - tab2.col1 + + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 8 * + cor0.col1 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT - NULLIF ( cor0.col0, + col0 ) + - ( 32 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 12 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 * cor0.col2 + cor0.col0 * col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 93 * - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 26 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + - 22 FROM tab0 GROUP BY col1

;

SELECT col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + 68 FROM tab1 GROUP BY tab1.col0

;

SELECT col1 * + col1 FROM tab2 GROUP BY col1

;

SELECT 6 - + 23 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 14 FROM tab1 GROUP BY tab1.col0

;

SELECT - tab0.col0 * + tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - col2 * ( tab2.col2 ) AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT ALL - 12 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - ( 54 ) * cor0.col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + 35 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - col0 + 63 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 47 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT col1 - col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT cor0.col1 + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT - + cor0.col2 AS col2 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - tab2.col2 * - tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT + + tab0.col0 + - 32 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + tab2.col2 * 6 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + - tab1.col2 FROM tab1 GROUP BY col2

;

SELECT 86 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT 90 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + cor0.col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL tab2.col2 + - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + tab0.col2 * - tab0.col2 FROM tab0 GROUP BY tab0.col2 HAVING tab0.col2 IS NULL
;

SELECT NULLIF ( + cor0.col1, cor0.col1 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - tab1.col1 * tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - col0 * - 57 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - 63 + + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 35 FROM tab0 GROUP BY tab0.col2

;

SELECT + 29 + 47 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - cor0.col2 * - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 68 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 31 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 * + 0 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT + 15 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT tab0.col2 - tab0.col2 * - tab0.col2 FROM tab0 GROUP BY col2

;

SELECT ALL col2 + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col0 * - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL + 14 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + 49 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 92 + tab0.col1 * - 89 FROM tab0 GROUP BY tab0.col1

;

SELECT 29 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - - 4 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + - 95 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NULL IS NOT NULL
;

SELECT cor0.col0 + + cor1.col0 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0, cor1.col0

;

SELECT - 57 FROM tab1 GROUP BY tab1.col1

;

SELECT + 74 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - - tab0.col2 AS col1 FROM tab0, tab0 AS cor0 GROUP BY tab0.col2

;

SELECT tab0.col0 + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 38 FROM tab1 GROUP BY tab1.col1

;

SELECT col1 - 76 * 88 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT 67 * 13 FROM tab2 GROUP BY tab2.col1

;

SELECT 73 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col1 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 * - cor0.col2 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - - 69 + 5 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - tab2.col0 * - 46 AS col2 FROM tab2 GROUP BY col0

;

SELECT ( col2 ) AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + col1 - - cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + cor0.col2 * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 69 + + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col2

;

SELECT DISTINCT 70 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL + 14 AS col1 FROM tab1 GROUP BY col2

;

SELECT 9 FROM tab0 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT ( + 5 ) * tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 24 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 + + col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 24 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT 69 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - - 82 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT - + tab2.col2 * - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 68 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - 84 + tab2.col2 * - tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + 90 + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT 67 - tab2.col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - 70 FROM tab2, tab1 AS cor0 GROUP BY tab2.col0

;

SELECT + - tab0.col0 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 6 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + 22 FROM tab2 GROUP BY col2

;

SELECT DISTINCT cor0.col0 + + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - + 17 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 59 FROM tab2 GROUP BY col0

;

SELECT - 24 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - 30 FROM tab0 cor0 GROUP BY col0

;

SELECT cor0.col2 * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 10 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + 17 * tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - + tab2.col2 + + 6 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 80 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col0 * - 74 + - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT 18 * 47 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - ( cor0.col0 ) * cor0.col2 + + cor0.col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT ALL 26 FROM tab0 GROUP BY col1

;

SELECT ALL - 38 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + COALESCE ( - tab2.col1, - tab2.col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 81 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 45 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 - cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - 74 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 45 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT - + 24 + - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 82 AS col1 FROM tab0 GROUP BY col2

;

SELECT - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT col2 AS col2 FROM tab1 cor0 GROUP BY col2

;

SELECT DISTINCT 68 AS col1 FROM tab2 cor0 GROUP BY col0

;

SELECT ALL tab2.col2 + + 99 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 1 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + + 97 FROM tab2 GROUP BY tab2.col0

;

SELECT + 55 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - - 87 - 63 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - cor0.col2 + - cor0.col2 * + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col0 + + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 28 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL 47 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - ( tab1.col2 ) AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - + 68 FROM tab0 GROUP BY tab0.col0

;

SELECT - tab1.col0 * 20 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 67 AS col2 FROM tab1 GROUP BY col2

;

SELECT ALL - ( - 1 ) FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + + tab1.col0 * + tab1.col0 AS col1 FROM tab1, tab1 AS cor0 GROUP BY tab1.col0

;

SELECT ALL tab2.col1 + tab2.col1 * - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col2 FROM tab2 AS cor0 WHERE ( NULL ) < NULL GROUP BY col2

;

SELECT - tab1.col0 - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 5 AS col1 FROM tab1 GROUP BY col1

;

SELECT ALL 46 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 96 * tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - tab0.col0 * 83 FROM tab0 GROUP BY tab0.col0

;

SELECT + 16 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 7 + 33 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 76 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT + 39 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 48 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - - 66 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 48 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL 16 FROM tab0 GROUP BY tab0.col0

;

SELECT - + 52 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + 19 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + col2 * + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 5 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 87 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + + 23 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING NOT col2 IS NOT NULL
;

SELECT ALL - tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1 HAVING ( NULL ) IS NOT NULL
;

SELECT ALL - tab0.col0 * + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT + 85 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 31 + - tab2.col1 FROM tab2 GROUP BY col1

;

SELECT ALL + tab1.col1 * - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - - tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - - 59 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 56 * - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT 40 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 41 - tab1.col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + 48 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT 68 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - 64 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 78 + - 86 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT col0 * tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 96 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 46 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2, col1, cor0.col1

;

SELECT DISTINCT + 16 + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - 60 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT + 23 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - cor0.col2 * + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + tab2.col2 + tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT ALL ( + cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 46 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 13 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - col1 FROM tab0 GROUP BY col1

;

SELECT + tab1.col0 + + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 38 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 87 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 + + 89 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 70 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - - tab2.col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT cor0.col1 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT 74 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + 10 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT tab2.col0 + 36 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT 48 * - cor0.col1 + + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL - + 80 + - tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 44 - - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + 68 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 28 * cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - + 71 + + 82 FROM tab0 GROUP BY tab0.col2

;

SELECT - cor0.col1 * + 33 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 34 AS col0 FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT + 89 * - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 32 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 93 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + - tab1.col1 * tab1.col1 + - 74 AS col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT ( col1 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 39 + - tab2.col2 * tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 95 * 68 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col2 - + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT - 6 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 48 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + - 34 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 17 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ( 93 ) FROM tab1 GROUP BY tab1.col2

;

SELECT ALL ( 70 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 81 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ( + 20 ) FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT 97 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor1.col1

;

SELECT - 35 * - 64 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT + 24 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - col2 * - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - 30 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL tab1.col1 + - col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT col0 FROM tab0 GROUP BY tab0.col0 HAVING NOT ( NULL ) >= NULL
;

SELECT - 62 * cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - cor0.col1 - - 10 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 91 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 38 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + NULLIF ( + 72, 39 ) FROM tab1 GROUP BY tab1.col0

;

SELECT + 83 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + tab1.col2 * - 4 FROM tab1 GROUP BY tab1.col2

;

SELECT + col0 + + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + ( + 37 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 20 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL 19 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + + 48 FROM tab1 GROUP BY col2

;

SELECT + 85 FROM tab1 GROUP BY col2

;

SELECT ALL tab1.col1 * + tab1.col1 FROM tab1 GROUP BY tab1.col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - col1 * + tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 87 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 * 6 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab1.col2 * + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col0 + - cor0.col0 * + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 40 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - col1 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + ( tab2.col2 ) FROM tab2 GROUP BY col2

;

SELECT + 66 * tab2.col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT ALL - 16 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL col1 AS col1 FROM tab0 cor0 GROUP BY col1, cor0.col1

;

SELECT - cor0.col1 + - 11 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - - 80 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 44 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT 57 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT 98 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + 29 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - tab1.col1 + + tab1.col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT DISTINCT 37 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - + 26 FROM tab2 GROUP BY tab2.col0

;

SELECT + 60 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - cor0.col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 17 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 * + 92 + cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - 99 + - 44 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + 99 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL ( + tab0.col1 ) * 14 + + col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 58 FROM tab0 GROUP BY tab0.col1

;

SELECT - 47 + - 63 FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col0 + + cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - - tab0.col0 - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 68 * 63 FROM tab2 GROUP BY col0

;

SELECT 86 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 9 + - col0 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT + cor0.col2 + cor0.col2 * + col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL - cor0.col2 * + 51 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - NULLIF ( - tab2.col0, + 52 * 90 ) FROM tab2 GROUP BY tab2.col0

;

SELECT + - 2 - + 15 FROM tab1 GROUP BY tab1.col0

;

SELECT + 21 * tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col1 AS col1 FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT 17 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab0.col0 * 78 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 54 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 25 AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - NULLIF ( + 54, 18 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT col2 + - 3 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT tab2.col1 + tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING NOT ( NULL ) IS NULL
;

SELECT tab1.col2 * - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 27 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - 97 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT ( cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 52 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT - cor0.col0 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT col2 + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT tab2.col0 + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col1 + - 40 * + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1, col2

;

SELECT 81 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 * cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - 16 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 72 + - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 50 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col2 * 94 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + 64 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 94 * col0 FROM tab1 GROUP BY col0

;

SELECT ALL - tab1.col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - 92 + 5 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 * - 23 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 90 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 24 * 36 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 50 * + 24 FROM tab0 GROUP BY tab0.col1

;

SELECT + ( + cor0.col1 ) + - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT ALL - 8 - - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 * cor0.col2 + ( cor0.col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 + 30 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - 57 * - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 99 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 9 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col1 + + cor0.col0 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, col1

;

SELECT cor0.col0 + 55 * cor0.col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col0 * + cor0.col0 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT DISTINCT 93 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT col2 AS col1 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT + 1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 81 FROM tab1 cor0 GROUP BY cor0.col2, col1

;

SELECT 21 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - 12 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT DISTINCT ( 50 ) FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT - 57 * 47 AS col2 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT - 87 + - 18 AS col0 FROM tab1 GROUP BY col0

;

SELECT ALL cor0.col0 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT DISTINCT tab0.col2 * 4 + + col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col0 * - ( cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 + - 12 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT 17 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 19 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + 95 AS col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT cor0.col2 * - col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 67 - - 5 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - 91 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + cor0.col1 * - cor0.col1 + 15 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 94 + 13 FROM tab2 GROUP BY col1

;

SELECT DISTINCT + + 22 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + ( + col1 ) FROM tab0 GROUP BY col1

;

SELECT - 49 AS col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 68 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - 42 - - 50 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + 92 FROM tab2 GROUP BY col1

;

SELECT - col2 AS col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - + tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT ALL + 21 + - 44 FROM tab2 GROUP BY col2

;

SELECT + 57 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL - - col0 * tab2.col0 FROM tab2 GROUP BY col0

;

SELECT + tab2.col0 + tab2.col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT - + 41 FROM tab1 GROUP BY tab1.col1

;

SELECT col2 * - col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL ( - 33 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - NULLIF ( + cor0.col0, - cor0.col0 * cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 33 * tab2.col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT ALL - cor0.col0 + + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab0.col1 + - tab0.col1 FROM tab0 GROUP BY col1 HAVING NOT col1 IS NULL
;

SELECT tab2.col2 - col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - tab0.col1 FROM tab0 WHERE NOT - col2 NOT BETWEEN ( - col1 ) AND ( NULL ) GROUP BY tab0.col1

;

SELECT + - col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - 67 FROM tab0 AS cor0 GROUP BY col0, cor0.col0

;

SELECT DISTINCT cor0.col1 * - ( 82 ) FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL tab0.col2 * - tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 30 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT - - 18 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 15 * 17 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ( cor0.col2 ) + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + - tab0.col1 FROM tab0 GROUP BY col1

;

SELECT - cor0.col1 * - ( 49 * + 48 ) + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 75 FROM tab0 GROUP BY tab0.col2

;

SELECT + tab2.col1 + 71 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 26 + 72 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 88 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col0 + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 * 4 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - cor0.col0 * 44 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 93 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col1 AS col2 FROM tab1 cor0 GROUP BY cor0.col1, col0

;

SELECT cor0.col2 + col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - - col0 * 50 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col1 + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT ALL - 84 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT tab0.col1 AS col0 FROM tab0 GROUP BY col1 HAVING ( NULL ) IS NULL
;

SELECT - 66 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + 79 + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT + cor0.col1 * + 55 + col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT col0 + - col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 61 * + 75 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor1.col0 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT - + tab1.col1 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col0 * 21 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 30 * + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 94 FROM tab0 GROUP BY tab0.col2

;

SELECT 54 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL - ( + cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 59 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL ( - 45 ) FROM tab0 GROUP BY tab0.col1

;

SELECT 51 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL tab0.col0 * 88 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 25 FROM tab2 GROUP BY tab2.col0

;

SELECT + 91 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL cor0.col1 - - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - cor0.col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor0.col2

;

SELECT - tab1.col1 + ( - tab1.col1 ) AS col2 FROM tab1 GROUP BY col1

;

SELECT DISTINCT 58 FROM tab0 GROUP BY col1

;

SELECT 38 FROM tab1 GROUP BY col2

;

SELECT + - 0 FROM tab0 GROUP BY tab0.col0

;

SELECT + tab0.col0 + 28 * + 51 AS col2 FROM tab0 GROUP BY col0

;

SELECT ALL + 65 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - 18 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT 55 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL - tab1.col0 * 82 FROM tab1, tab0 AS cor0 GROUP BY tab1.col0

;

SELECT + cor0.col1 * + 36 + - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + col0 FROM tab0 GROUP BY col0

;

SELECT + tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING NOT NULL IS NOT NULL
;

SELECT 65 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT 48 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT ALL ( cor0.col1 ) + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 68 + 4 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 46 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 28 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + 47 + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 66 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 81 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 53 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL col2 + - cor0.col2 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 29 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - tab0.col0 + 77 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 73 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * 90 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 38 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 82 + 28 FROM tab1 GROUP BY tab1.col1

;

SELECT - - ( + 88 ) FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 67 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col2 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col2, cor1.col1

;

SELECT - 3 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 41 FROM tab1 cor0 GROUP BY cor0.col0, col1

;

SELECT + 62 * - tab0.col1 FROM tab0 GROUP BY col1

;

SELECT ALL - 81 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + col0 - - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor1.col2 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL - cor1.col2 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col2, cor0.col2

;

SELECT - - tab2.col2 - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 1 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - cor0.col1 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT tab0.col0 * + tab0.col0 - ( tab0.col0 ) * - col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - tab0.col0 - + 57 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 15 - 73 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - - tab1.col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT ALL - cor0.col0 * - 28 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + col0 - + 90 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT cor0.col0 + - cor0.col0 * col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL cor0.col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL 30 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + 5 FROM tab2 GROUP BY tab2.col0

;

SELECT - 10 FROM tab2 AS cor0 GROUP BY col0

;

SELECT cor0.col0 - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL cor0.col2 - + cor0.col1 * - 49 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 27 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 42 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - cor0.col1 * cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - ( - 73 ) + - 94 FROM tab1, tab2 cor0 GROUP BY tab1.col1

;

SELECT DISTINCT 73 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 19 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - 15 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 24 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 13 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 74 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 * ( - 54 * cor0.col2 ) FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + tab1.col0 * 36 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 89 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 28 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT + + 41 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 83 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 64 * + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 10 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT tab2.col2 AS col1 FROM tab2 WHERE NOT NULL IS NULL GROUP BY col2

;

SELECT ALL - + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 17 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - - 83 + - col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - ( 69 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 * - cor0.col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 * 97 - - 68 AS col2 FROM tab0 cor0 GROUP BY col1, cor0.col0, col2

;

SELECT - cor0.col1 * 79 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT + 5 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 24 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - 67 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + 78 FROM tab1 GROUP BY tab1.col2

;

SELECT - 81 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + + 97 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - 61 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + 22 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT 55 FROM tab1 cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col2

;

SELECT - 32 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT - - 52 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 38 AS col1 FROM tab1 GROUP BY col0

;

SELECT cor1.col2 AS col1 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor1.col2

;

SELECT DISTINCT - col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 91 FROM tab1 AS cor0 GROUP BY col2

;

SELECT tab0.col1 * 14 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT + 65 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT - 80 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 89 * - cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab2 cor0 GROUP BY col2

;

SELECT - 77 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 23 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT - tab0.col2 + 59 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col1 + 7 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + 32 FROM tab2 GROUP BY col0

;

SELECT ALL 93 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 5 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT + 85 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 81 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ( 80 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 22 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 7 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 53 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - + tab1.col2 * - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 44 * + 57 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - 85 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 69 + 51 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT cor0.col2 * 81 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 26 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING ( col2 ) IS NOT NULL
;

SELECT ALL + tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING NULL IS NULL
;

SELECT DISTINCT cor0.col0 + + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col2 * 7 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 68 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + - 77 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + 17 AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col1

;

SELECT DISTINCT + - 65 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - - tab1.col0 FROM tab1 GROUP BY col0

;

SELECT 73 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL cor0.col2 * - 33 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 40 * 21 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - + 44 - - tab1.col1 * - tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 7 * tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 41 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + - 37 FROM tab1 GROUP BY tab1.col1

;

SELECT + 33 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 83 * - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 81 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - 50 + + 86 * cor0.col2 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT - 0 - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + tab0.col0 + - ( - tab0.col0 ) AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT - cor0.col1 + 41 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 75 * col1 FROM tab0 GROUP BY col1

;

SELECT ALL + 99 AS col0 FROM tab1 GROUP BY col1

;

SELECT + col1 * + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 64 - 63 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 62 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + + COALESCE ( ( - 47 ), tab0.col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 71 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 44 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NULL
;

SELECT ALL + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING ( NULL ) IS NOT NULL
;

SELECT + cor0.col2 - + 88 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0, cor0.col2, cor1.col2

;

SELECT ALL 35 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL + 64 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - + tab2.col1 * tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + tab1.col1 * tab1.col1 + tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 49 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1, cor0.col2

;

SELECT ALL cor0.col2 * - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT ALL + tab0.col2 * + tab0.col2 FROM tab0 GROUP BY col2

;

SELECT + - tab2.col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT ALL - 86 FROM tab0 GROUP BY tab0.col0

;

SELECT ( 53 ) FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, col2

;

SELECT ALL - ( - 84 ) FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT 95 + + tab1.col1 FROM tab1 GROUP BY col1

;

SELECT ALL 92 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT - ( 94 ) AS col1 FROM tab1 AS cor0 GROUP BY col0, cor0.col0

;

SELECT 49 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - cor0.col2 * 3 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT - col1 * - cor0.col1 + - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - 75 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - + 86 FROM tab2 GROUP BY tab2.col0

;

SELECT - 2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor1.col0 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - cor0.col2 + 69 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 59 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 28 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + ( + tab1.col1 ) AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - cor0.col1 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT cor0.col1 * cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 10 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ( - 59 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 41 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor1.col1

;

SELECT ALL 80 + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT cor0.col0 * - cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - tab2.col2 * col2 FROM tab2 GROUP BY tab2.col2

;

SELECT tab0.col1 * tab0.col1 FROM tab0 GROUP BY col1

;

SELECT tab0.col1 + col1 * - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1 HAVING NULL >= NULL
;

SELECT 37 * - 51 FROM tab2 GROUP BY tab2.col1

;

SELECT + 14 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT - - 74 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 50 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 4 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT 86 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - ( cor0.col1 ) FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL + col1 - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL cor0.col2 + + col1 * + ( cor0.col2 + - col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 56 AS col2 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - tab1.col0 * - tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - - ( - ( col0 ) ) AS col0 FROM tab2 GROUP BY col0

;

SELECT - NULLIF ( tab2.col1, + tab2.col1 ) AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + tab1.col1 * tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + tab2.col0 AS col1 FROM tab2 WHERE NULL IS NULL GROUP BY tab2.col0

;

SELECT tab2.col0 * col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col0 * 36 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 55 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT cor0.col1 * - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - - ( + tab2.col2 ) FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 88 AS col0 FROM tab2 cor0 GROUP BY col0

;

SELECT 97 + 32 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - + 86 + - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - col2 * - 91 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col2 * + cor0.col0 + - 35 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - - 92 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT tab0.col1 + tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + + 99 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + tab0.col2 + - 58 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - - tab0.col2 * ( 18 ) FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + tab1.col0 * ( tab1.col0 ) FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col0 + - 14 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + + tab0.col2 + 25 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 94 * + CASE - tab2.col1 WHEN tab2.col1 - 29 THEN + 51 END FROM tab2 GROUP BY tab2.col1

;

SELECT col2 * 36 AS col1 FROM tab0 cor0 GROUP BY cor0.col2, col0

;

SELECT ALL - 80 FROM tab0 GROUP BY col1

;

SELECT ALL 3 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + 23 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL + + 94 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 97 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col1 * - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + tab2.col2 + + tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - 19 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + - 26 FROM tab0 GROUP BY tab0.col2

;

SELECT - - tab0.col2 * tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 56 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 65 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 13 FROM tab2 cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col1 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL col1 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL 17 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - col2 AS col2 FROM tab2 cor0 GROUP BY col1, cor0.col2

;

SELECT 55 AS col0 FROM tab1 GROUP BY col1

;

SELECT ALL - - tab2.col0 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + + 98 + + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 81 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 8 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT 91 * - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - col1 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT cor0.col0 * + col0 + + 46 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor0.col1

;

SELECT + 52 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT 28 * tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 35 AS col1 FROM tab0 cor0 GROUP BY col2

;

SELECT 20 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - tab1.col0 + 88 * - ( - 56 ) FROM tab1 GROUP BY col0

;

SELECT ALL + 68 FROM tab0 GROUP BY tab0.col2

;

SELECT col0 + 4 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT 85 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - col0 * - cor0.col0 - 44 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + tab0.col1 + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - cor0.col1 AS col2 FROM tab0 cor0 GROUP BY col1

;

SELECT ALL + col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT - 74 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + 96 * cor0.col2 AS col2 FROM tab2 cor0 GROUP BY col1, cor0.col2

;

SELECT ALL 80 * tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - - 64 + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + - 2 FROM tab2 GROUP BY tab2.col0

;

SELECT - 36 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, col2

;

SELECT ALL - ( - col1 ) FROM tab1 GROUP BY tab1.col1

;

SELECT - ( + 88 ) FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT tab2.col2 - 9 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - tab0.col2 - tab0.col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL + tab0.col2 + tab0.col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT ALL cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL > NULL
;

SELECT ALL + tab1.col0 AS col0 FROM tab1 WHERE NOT ( + tab1.col2 ) IS NULL GROUP BY tab1.col0 HAVING NULL IS NULL
;

SELECT DISTINCT + tab1.col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT - col1 IS NOT NULL
;

SELECT DISTINCT + 33 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL tab2.col1 * - 43 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT DISTINCT - 22 FROM tab2 GROUP BY tab2.col2

;

SELECT 7 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 40 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + NULLIF ( - cor0.col1, + 49 * 50 ) FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 89 + + cor0.col1 * + 62 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + cor0.col2 AS col2 FROM tab1 cor0 GROUP BY col2

;

SELECT 69 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT col2 + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 67 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col1

;

SELECT ALL 82 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 3 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + - tab1.col2 + - 1 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 43 + + 99 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - + tab0.col2 * tab0.col2 FROM tab0 GROUP BY col2

;

SELECT + 30 + + col0 * - ( - cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT - ( 22 ) FROM tab1 GROUP BY col2

;

SELECT + 71 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 79 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + - 89 FROM tab2 GROUP BY tab2.col1

;

SELECT - 42 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + cor0.col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 12 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - - tab1.col2 * tab1.col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - cor0.col0 - cor0.col0 * - 89 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor1.col1

;

SELECT - cor0.col1 * - cor0.col1 AS col0 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT col0 + col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + tab2.col0 * tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + cor0.col0 + col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 70 * - tab2.col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT cor0.col1 + - 57 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 4 FROM tab0 GROUP BY tab0.col0

;

SELECT + 74 - - 78 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT 17 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL 60 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + cor1.col0 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 59 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 35 * - cor0.col0 + - cor0.col0 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL + 83 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - col1 + cor0.col1 FROM tab0 AS cor0 GROUP BY col2, cor0.col1, cor0.col2

;

SELECT ALL + + 61 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + col1 + + 97 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 43 + + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 91 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - ( - 57 ) + + col0 * 4 AS col0 FROM tab1 GROUP BY col0

;

SELECT 88 + + cor0.col0 * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 65 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 90 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT tab2.col2 + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2 HAVING ( NULL ) IS NULL
;

SELECT cor0.col0 * - 43 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + cor0.col1 + + 15 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 42 FROM tab2 GROUP BY tab2.col1

;

SELECT 16 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 40 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL + 40 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0 HAVING NOT NULL NOT BETWEEN NULL AND ( NULL )
;

SELECT cor0.col1 * cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + 35 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 82 + col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 3 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 * - cor0.col0 + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + 29 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 42 AS col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT - 14 FROM tab1 GROUP BY tab1.col2

;

SELECT + col0 - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 23 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 28 + - 46 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 - + cor0.col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + - 49 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + tab1.col2 - ( + tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT 84 * cor0.col0 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT - cor0.col2 + - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + 18 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT + 86 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 38 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT DISTINCT - 64 FROM tab0 GROUP BY col2

;

SELECT ALL + 44 * + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 97 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 26 AS col2 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT + tab0.col1 FROM tab0, tab1 AS cor0 GROUP BY tab0.col1

;

SELECT ALL ( cor0.col1 ) FROM tab2 AS cor0 GROUP BY col1

;

SELECT - - 26 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col0 * cor0.col0 - 53 * - 63 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + 79 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + 65 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + + 96 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - 19 FROM tab0 GROUP BY tab0.col0

;

SELECT + 46 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + 32 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 34 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + COALESCE ( col0, cor0.col0 + cor0.col0 ) - 11 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + cor0.col2 + - cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col0 * 1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT ALL + 94 * 42 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 62 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 10 + + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col0, cor0.col0

;

SELECT DISTINCT + 29 - 19 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT - ( 12 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - 53 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + 17 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + ( tab0.col2 ) AS col2 FROM tab0 GROUP BY col2

;

SELECT + ( col1 ) FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 87 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 17 - + 62 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 3 FROM tab0 AS cor0 GROUP BY col1

;

SELECT cor0.col2 - - cor0.col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT - - 27 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + cor0.col1 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, col1

;

SELECT - COALESCE ( + cor0.col2, - 76 ) + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 21 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 21 * 19 + - tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + col1 AS col1 FROM tab2 cor0 GROUP BY col1, col0, col2

;

SELECT cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL + 47 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 49 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - 15 * - tab2.col0 FROM tab2 GROUP BY col0

;

SELECT - 35 FROM tab0 GROUP BY col1

;

SELECT ALL + 51 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL + - 10 FROM tab0 GROUP BY tab0.col1

;

SELECT + tab2.col0 - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT col0 + - 65 * + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - tab2.col2 + tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - tab1.col1 + - tab1.col1 * 64 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 56 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - tab0.col0 - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + cor0.col0 - 9 * 96 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT ALL + tab2.col0 + - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col1 - - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT - ( + 11 ) FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT ( ( cor0.col1 ) ) * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 AS col1 FROM tab0 cor0 GROUP BY col1

;

SELECT - 71 * - 70 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, col1

;

SELECT DISTINCT 27 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - tab2.col1 * 11 + tab2.col1 FROM tab2 GROUP BY col1

;

SELECT ALL + + 46 FROM tab2 GROUP BY col0

;

SELECT - 32 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 47 + + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 49 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + 63 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT cor0.col1 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 GROUP BY cor0.col1

;

SELECT ALL + col0 AS col0 FROM tab0 AS cor0 WHERE NOT ( NULL ) IN ( cor0.col2 * cor0.col1 ) GROUP BY cor0.col0

;

SELECT ALL cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NULL
;

SELECT tab0.col0 + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT cor0.col1 - 97 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 27 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL - cor0.col0 - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 53 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT ( + cor0.col2 ) + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col2, col0

;

SELECT ALL - cor0.col0 * + 18 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 92 - + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - ( 35 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + tab1.col0 * - tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + - 44 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col1 * - cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - - NULLIF ( tab2.col2, 85 ) AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + tab2.col2 + tab2.col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - tab1.col1 * - tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT 97 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col0 * + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT 56 FROM tab2 GROUP BY tab2.col1

;

SELECT + - 45 - - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 64 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT tab2.col2 * NULLIF ( 90, + 50 * tab2.col2 ) AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 36 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 * ( + cor0.col2 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 65 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 41 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + - tab2.col1 - + 8 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 9 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 63 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + 24 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 94 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 19 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 94 * - col2 + + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 * cor0.col2 + - cor0.col2 FROM tab2 cor0 GROUP BY col2, cor0.col0, cor0.col1

;

SELECT + tab1.col2 + 32 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL ( - ( cor0.col0 ) ) FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + cor0.col0 * - 77 - cor0.col0 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 64 + - col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT ALL cor0.col2 - + ( - cor0.col2 + cor0.col2 * - cor0.col0 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 99 + tab0.col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT ALL - 21 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT ALL 88 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - - 8 * + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + tab0.col0 * - tab0.col0 + + tab0.col0 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 34 * - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 91 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT DISTINCT - tab0.col2 + 56 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col1 FROM tab1 cor0 GROUP BY col1, cor0.col1

;

SELECT - 98 FROM tab1 GROUP BY tab1.col2

;

SELECT + 23 FROM tab2 GROUP BY tab2.col2

;

SELECT 23 * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 20 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1, cor0.col0

;

SELECT + 20 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - - 47 * - tab2.col1 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT DISTINCT - 72 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + + tab1.col1 + 85 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col0 * cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col1 * 78 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * - 95 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 AS col2 FROM tab1 cor0 GROUP BY col1, col2

;

SELECT - 31 FROM tab2 GROUP BY tab2.col0

;

SELECT 37 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 24 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - 17 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT tab2.col0 * tab2.col0 FROM tab2 GROUP BY col0

;

SELECT 68 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT col2 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - - col1 FROM tab0 GROUP BY col1

;

SELECT ALL cor0.col0 + - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 * - cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT + cor0.col0 * + 88 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 64 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 90 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT + 42 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT + 53 * + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 5 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + tab1.col0 + 4 AS col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + tab0.col2 + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 98 * + 16 FROM tab0 GROUP BY col1

;

SELECT DISTINCT CASE cor0.col1 WHEN + 78 THEN NULL WHEN cor0.col0 THEN NULL ELSE cor0.col1 END AS col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT - - tab1.col2 * - 90 - - 33 AS col0 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - 21 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 34 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 65 * 10 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 98 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL 46 + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 63 AS col0 FROM tab2 GROUP BY col2

;

SELECT + 97 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 42 FROM tab1 GROUP BY tab1.col2

;

SELECT + 23 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT ( 2 ) AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT 34 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 - 37 FROM tab2 AS cor0 GROUP BY col0, col1, cor0.col1

;

SELECT DISTINCT cor0.col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT - ( - 44 ) FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 36 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + - tab0.col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + cor0.col0 * + NULLIF ( - col0, - cor0.col0 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT cor0.col0 * + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + 75 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - tab2.col2 * tab2.col2 FROM tab2 GROUP BY col2 HAVING NULL IS NULL
;

SELECT DISTINCT - col0 + 65 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col2 + - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT col0 * + tab2.col0 - ( tab2.col0 ) FROM tab2 GROUP BY col0

;

SELECT ALL - 25 AS col1 FROM tab2 GROUP BY col0

;

SELECT + 3 FROM tab2 GROUP BY col2

;

SELECT 61 FROM tab0 GROUP BY col0

;

SELECT 83 FROM tab0 GROUP BY tab0.col0

;

SELECT - 87 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 75 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT + ( tab1.col0 ) FROM tab1 GROUP BY col0

;

SELECT ALL - 93 AS col0 FROM tab1 cor0 GROUP BY col0, col2

;

SELECT DISTINCT + + 26 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 53 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 36 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 38 * - tab2.col2 FROM tab2 GROUP BY col2

;

SELECT 71 + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 47 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2 HAVING NOT - col2 IS NULL
;

SELECT 14 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - tab2.col1 - + 34 AS col2 FROM tab2 GROUP BY col1

;

SELECT 94 + - 97 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 3 * + tab1.col0 - - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 59 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 76 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ( 41 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + tab0.col2 * - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT col2 + cor0.col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 50 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT - 79 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 34 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 76 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 41 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor0.col1

;

SELECT 41 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 51 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - 3 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 30 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - - 76 * tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT - ( + 39 ) FROM tab1 AS cor0 GROUP BY col2

;

SELECT + cor0.col0 * + 59 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT cor0.col0 + + col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 * - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col0, cor0.col2

;

SELECT 71 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT + tab2.col1 + - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 65 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT ( 54 ) FROM tab1 AS cor0 GROUP BY cor0.col0, col0, col2

;

SELECT + 88 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT 52 * - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT 28 FROM tab0 cor0 GROUP BY col1

;

SELECT 16 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - + ( tab2.col2 ) + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 98 AS col0 FROM tab1 GROUP BY col0

;

SELECT 15 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - cor0.col2 * 54 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL - cor0.col0 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT + 1 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT 78 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 AS col1 FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT col2 * - ( 80 + - tab2.col2 ) AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 63 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - NULLIF ( - 85, 72 ) FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + - 54 * 84 FROM tab1 GROUP BY col0

;

SELECT DISTINCT 68 FROM tab1 GROUP BY col0

;

SELECT - 72 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 12 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT 66 * - col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col0 * - 40 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab1 cor0 GROUP BY col2

;

SELECT ALL + cor0.col2 * - 1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 48 AS col2 FROM tab1 cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col0

;

SELECT - ( col1 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 70 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + + COALESCE ( + tab1.col2, + tab1.col2 ) - + tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 88 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - - tab1.col2 * - col2 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + - tab1.col0 - - 15 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - tab2.col0 * 27 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + cor0.col1 * cor0.col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT tab0.col1 - 59 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT + ( - 72 ) FROM tab1 GROUP BY tab1.col0

;

SELECT 62 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + ( cor0.col1 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 85 AS col0 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + 28 + - 10 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL - 43 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - - 72 * tab0.col0 + 33 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 30 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 42 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT 40 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT 1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - cor0.col0 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, col1

;

SELECT ALL ( + 47 ) * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 92 FROM tab1 GROUP BY col0

;

SELECT ALL cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT DISTINCT + col1 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, cor0.col2

;

SELECT tab1.col1 * - 76 AS col2 FROM tab1 GROUP BY col1

;

SELECT - tab2.col2 AS col1 FROM tab1 cor0 CROSS JOIN tab2 GROUP BY tab2.col2 HAVING NULL IS NULL
;

SELECT tab1.col2 FROM tab1 WHERE NULL IN ( tab1.col0 - tab1.col1 ) GROUP BY tab1.col2 HAVING col2 IS NOT NULL
;

SELECT ALL tab2.col0 AS col0 FROM tab2 WHERE NOT NULL IN ( - tab2.col2 * + tab2.col0 - - tab2.col0 ) GROUP BY tab2.col0 HAVING NOT ( NULL ) >= NULL
;

SELECT DISTINCT tab0.col0 - tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 46 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT + ( 77 ) AS col0 FROM tab0, tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + 53 FROM tab2 GROUP BY tab2.col1

;

SELECT + 53 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT 41 + + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT - - tab2.col0 * tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - 6 AS col2 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - col2 AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT - + 83 - 52 FROM tab0 GROUP BY col1

;

SELECT cor0.col0 * 17 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 72 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT col1 + 80 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 43 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 * 30 + + col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 29 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col2

;

SELECT + col1 - + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 24 FROM tab2 GROUP BY col1

;

SELECT ALL - 36 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 14 AS col0 FROM tab2 GROUP BY col0

;

SELECT ALL 62 FROM tab0 GROUP BY col0

;

SELECT - cor0.col2 * + 17 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + 26 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - 54 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT tab2.col1 - 42 * tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + 81 + 34 * + tab1.col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT cor0.col2 + + 29 * cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT tab1.col0 - tab1.col0 * 64 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + cor0.col2 * - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT col0 + - cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 7 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - - col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + col1 * - ( + 69 ) FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 16 - - 84 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT ALL tab2.col0 + tab2.col0 * tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT ( + col2 ) IS NULL
;

SELECT DISTINCT - + 58 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - - tab1.col1 * - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - col0 + 74 * 12 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + cor0.col0 * 1 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - 83 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 50 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + tab1.col0 * + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col2 + cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL - - 48 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col2 * 83 + + 46 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + + tab1.col2 * tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 18 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 25 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + - 81 AS col0 FROM tab2 GROUP BY col1

;

SELECT - 69 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 67 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 33 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 58 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab1.col1 * + tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - 22 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 35 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 85 + + 30 FROM tab1, tab0 AS cor0 GROUP BY tab1.col0

;

SELECT ALL + 97 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT 87 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT + cor0.col0 * col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 49 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + cor0.col2 * col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING NULL = ( NULL )
;

SELECT ALL - 2 + cor0.col2 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ( 81 ) FROM tab1 AS cor0 GROUP BY col2

;

SELECT + 73 FROM tab0 GROUP BY tab0.col1

;

SELECT 14 + + 83 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + 15 + - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 37 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col1

;

SELECT ALL + 44 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 24 + - ( - tab1.col1 ) AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - 53 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 82 - 0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 87 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT ALL + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT DISTINCT + ( 93 ) AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 21 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 73 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 39 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + - tab1.col1 * - tab1.col1 + tab1.col1 FROM tab1 GROUP BY col1

;

SELECT ALL - cor0.col0 - + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT 74 * + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 10 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT 60 + 62 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 32 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab1.col2 FROM tab1 GROUP BY tab1.col2 HAVING ( NULL ) IS NOT NULL
;

SELECT DISTINCT - tab0.col0 + - ( - tab0.col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT ALL col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - NULLIF ( cor0.col2, - cor0.col2 * cor0.col2 + cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT tab1.col2 + - 47 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - tab0.col0 * 69 + tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 19 * + cor0.col0 AS col0 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL 58 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + tab1.col0 * + 13 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL ( - 85 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 * 11 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + NULLIF ( - cor0.col0, col0 ) + - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + 54 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL 92 * - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT tab2.col1 + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT col2 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - col2 * + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT 39 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL - col1 + - tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 28 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - 79 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab2.col1 + ( tab2.col1 ) AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 76 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - 96 * tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT NULLIF ( + cor0.col0, cor0.col0 ) * - cor0.col0 FROM tab2 cor0 GROUP BY col0, cor0.col2, cor0.col2

;

SELECT 80 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT DISTINCT + + 41 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + - 82 * + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - - 43 FROM tab0 GROUP BY tab0.col1

;

SELECT 69 * + 98 + - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - 46 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL col0 FROM tab0 GROUP BY col0

;

SELECT + col1 + - cor0.col1 * - cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 64 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - tab0.col1 + ( 41 ) FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 84 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - 23 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 34 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + + 63 + + col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + - 45 FROM tab0 GROUP BY col0

;

SELECT ALL cor0.col1 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + 98 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 18 * cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT + col1 + - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT col2 + - col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + col1 + 11 FROM tab1 GROUP BY tab1.col1

;

SELECT 9 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL col1 + 44 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT DISTINCT - 67 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 48 * - 93 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

