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

SELECT - cor0.col2 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 76 AS col2 FROM tab1 GROUP BY col2

;

SELECT - - tab2.col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT tab2.col2 * - col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 7 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col0 * + 25 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + col1 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - + col2 * + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - cor0.col1 * - cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 27 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL cor0.col2 * - 22 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT DISTINCT + 15 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL - tab2.col2 + - 11 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - + 29 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 10 * + 70 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - 73 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 13 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + 49 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 0 FROM tab1 GROUP BY tab1.col2

;

SELECT 64 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 29 * 68 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + - 48 FROM tab2 GROUP BY tab2.col2

;

SELECT - 78 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - ( - 33 ) + + 59 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 75 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NOT + col1 <> ( NULL )
;

SELECT + col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 73 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + tab1.col2 + + col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING NULL IS NULL
;

SELECT - col0 * - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0, col2

;

SELECT cor0.col2 * 31 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 7 * tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - + 89 FROM tab1 GROUP BY tab1.col0

;

SELECT - NULLIF ( cor0.col0, + 26 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 90 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT col0 - + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - + 79 * tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 13 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL 32 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 49 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 51 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 60 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 81 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 63 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 + + 46 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT ALL + 43 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 32 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT + - 96 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - 4 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab2.col2 * tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING NOT NULL IS NULL
;

SELECT + col2 * - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 82 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - + 60 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - + 59 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 13 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 14 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - + tab1.col2 * tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + 30 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 82 + 96 * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 99 * tab1.col0 - + tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NULL
;

SELECT + 81 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT tab2.col2 + - tab2.col2 * + 84 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col0 * cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT cor0.col1 FROM tab0 AS cor0 WHERE NOT NULL > NULL GROUP BY cor0.col1

;

SELECT DISTINCT 54 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT + 81 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab0.col1 * + 21 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 63 - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, col1, cor0.col0

;

SELECT + cor0.col0 * - 18 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + 61 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 98 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + - 59 * 49 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - - 87 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 63 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT 42 * - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL + cor0.col0 * + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 + cor0.col0 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col1, cor0.col0

;

SELECT - + NULLIF ( + tab2.col1, - tab2.col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT - ( + cor0.col2 ) + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + tab1.col2 * col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT 7 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 + 37 * + 59 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT tab0.col1 - 74 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT + 28 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 48 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 43 FROM tab0 GROUP BY col1

;

SELECT ALL 45 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - 79 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col1 + 28 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, col0

;

SELECT ALL 93 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 24 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + 97 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col0

;

SELECT + col0 * - 55 + - 22 FROM tab2 GROUP BY col0

;

SELECT ALL - + 70 AS col1 FROM tab0 GROUP BY col2

;

SELECT ALL 35 + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - ( - tab2.col0 ) AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 77 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ( - 68 ) AS col1 FROM tab0, tab0 AS cor0 GROUP BY tab0.col0

;

SELECT DISTINCT 49 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0 HAVING ( NULL ) IS NOT NULL
;

SELECT cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NULL
;

SELECT - 5 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 69 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 31 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 67 - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 65 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 4 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 74 * 4 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 59 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 52 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 66 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - + 17 FROM tab1 GROUP BY tab1.col0

;

SELECT + 72 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - ( 74 ) + col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + tab0.col0 * 59 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 14 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + 74 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 * - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - tab1.col1 * - col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING NOT ( tab2.col2 ) IS NULL
;

SELECT ALL + tab1.col0 FROM tab1 GROUP BY col0 HAVING NULL IS NULL
;

SELECT DISTINCT + 80 * cor0.col0 - 97 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 34 AS col0 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT - 15 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col1, col2

;

SELECT - 49 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 43 + + col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 32 * - 8 FROM tab0 GROUP BY tab0.col1

;

SELECT + ( 84 ) + + cor0.col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + cor0.col2 + + 68 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 65 * cor0.col1 + + cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT + - 11 FROM tab2 GROUP BY tab2.col0

;

SELECT - col2 * + 45 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + 65 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT + 59 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 26 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT tab0.col2 * + tab0.col2 - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - + tab0.col0 - tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT 45 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + 47 * + col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT 29 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 39 FROM tab2 cor0 GROUP BY col2

;

SELECT tab0.col1 + col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 13 * 8 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 21 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 22 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + + 92 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + cor1.col0 * 2 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + col0 + 81 FROM tab2 GROUP BY tab2.col0

;

SELECT - tab0.col1 * - 11 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 80 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + - 78 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - ( 23 ) FROM tab0 GROUP BY tab0.col2

;

SELECT + tab2.col0 * COALESCE ( + 51, + tab2.col0 ) AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + + tab0.col2 * + tab0.col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT + tab1.col0 FROM tab1 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT ALL 75 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 37 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 + - col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - 96 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 89 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - - col1 * tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, col1

;

SELECT 70 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 84 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 60 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 58 AS col0 FROM tab1 cor0 GROUP BY col2

;

SELECT 88 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + 64 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 58 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT + tab2.col2 * - tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT - + 50 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + tab0.col1 + - tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT - col1 AS col1 FROM tab2 GROUP BY col1 HAVING ( - tab2.col1 ) IN ( tab2.col1 )
;

SELECT - tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0 HAVING NOT ( NULL ) IS NULL
;

SELECT - 1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 98 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT col1 * - cor0.col1 + 85 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col0 + - tab0.col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT - 28 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT 64 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + - 31 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT 66 * + 95 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL tab2.col1 + - col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + ( - 12 ) * + col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 50 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - - 39 + col0 * + col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 51 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NULL NOT BETWEEN NULL AND NULL
;

SELECT DISTINCT - 21 * 11 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - + 35 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 58 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 94 + 22 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL - 27 AS col1 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + 53 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - cor0.col2 * 85 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - tab2.col0 + 47 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col0 + - cor0.col0 * - 34 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + 79 + col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 - cor0.col0 AS col1 FROM tab2 cor0 GROUP BY col0

;

SELECT ALL - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col1 * 42 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col2 + + 5 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL - col0 * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col1 * cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 33 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL 6 AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 * 87 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 82 * + cor0.col2 + - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT DISTINCT - col2 + - 30 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + tab0.col2 + 47 FROM tab0 GROUP BY tab0.col2

;

SELECT + tab0.col2 * + col2 FROM tab0 GROUP BY col2 HAVING NOT NULL > col2
;

SELECT + 35 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + - col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT 85 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 62 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 6 FROM tab1 GROUP BY col2

;

SELECT ALL + 78 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab1.col1 + tab1.col1 * col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - - tab2.col1 + + col1 * 25 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + + 32 + - 90 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 65 * - 15 + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - cor0.col1 - + 48 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 44 + 42 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - col2 AS col2 FROM tab1 cor0 GROUP BY col2

;

SELECT DISTINCT + 77 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + + tab0.col2 + tab0.col2 FROM tab0 GROUP BY col2

;

SELECT ALL 2 + 22 FROM tab2 cor0 GROUP BY col1

;

SELECT + 8 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + 77 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 39 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 54 + cor0.col2 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT tab2.col2 AS col2 FROM tab2 WHERE tab2.col2 NOT IN ( tab2.col0 ) GROUP BY tab2.col2

;

SELECT DISTINCT + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NULL IS NOT NULL
;

SELECT DISTINCT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NOT + col0 IS NULL
;

SELECT DISTINCT cor0.col2 + cor0.col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 40 - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 81 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 3 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - + 21 * 41 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 44 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT 89 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - ( - 97 ) AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col0 * - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col2 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NULL
;

SELECT ALL + - 59 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + col0 * - NULLIF ( 33 + - col0, + 63 ) FROM tab1 GROUP BY tab1.col0

;

SELECT tab0.col0 / tab0.col0 AS col1 FROM tab0 GROUP BY col0 HAVING - tab0.col0 IS NULL
;

SELECT cor0.col0 + - 78 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + tab2.col1 + + 34 FROM tab2 GROUP BY tab2.col1

;

SELECT - - 61 * col0 FROM tab1 GROUP BY col0

;

SELECT cor0.col0 * 11 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 56 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + 92 - cor0.col2 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - col2 + 37 AS col0 FROM tab2 GROUP BY col2

;

SELECT DISTINCT 34 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col1 + 15 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + 32 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + + 73 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 13 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 37 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL - - 62 * + tab2.col1 FROM tab2 GROUP BY col1

;

SELECT ( 64 ) FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 19 * - 20 AS col1 FROM tab0 cor0 GROUP BY col2

;

SELECT tab0.col0 * - tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 47 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + 8 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT cor0.col2 * + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + 63 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ( 89 ) * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col0, cor0.col2

;

SELECT DISTINCT 37 + 53 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + 93 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL cor0.col2 * + col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 12 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT + col1 * + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + ( 74 ) FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 35 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT - - tab2.col2 + + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + col0 - - col0 AS col2 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL + - 0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - col0 * - 95 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 69 * - cor0.col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT 98 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab1.col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT DISTINCT + 51 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 33 * + tab2.col1 + - tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + tab1.col0 + + 10 * - tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - tab1.col0 * - 41 FROM tab1 GROUP BY tab1.col0

;

SELECT + 99 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 68 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + NULLIF ( cor0.col1, cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 8 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 61 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col2 + + 10 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT tab2.col0 + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - col2 * - col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 38 FROM tab0 GROUP BY tab0.col2

;

SELECT - + 65 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - 96 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + ( - 69 ) AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - 88 + 5 FROM tab2 GROUP BY tab2.col2

;

SELECT - 52 + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - 85 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - tab0.col0 + 30 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL col0 * + cor0.col0 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 79 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 82 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 53 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT + cor0.col1 * + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL tab1.col0 * col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 78 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT tab1.col0 * col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor0.col2 FROM tab1 cor0 GROUP BY col1, cor0.col2

;

SELECT 28 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL tab1.col0 FROM tab1 GROUP BY tab1.col0 HAVING ( NULL ) IS NOT NULL
;

SELECT - col1 + + tab2.col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - cor0.col2 AS col0 FROM tab0 cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 * cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT 7 * 92 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 84 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 93 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + ( 38 ) + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 82 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2, cor0.col2, cor1.col1

;

SELECT + 20 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 28 * + col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 3 * col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - 58 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 23 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - - 60 + 74 * tab0.col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + 80 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL col2 * - 95 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 60 + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, col0

;

SELECT tab1.col0 FROM tab1 GROUP BY tab1.col0 HAVING tab1.col0 >= ( NULL )
;

SELECT DISTINCT - 2 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT tab0.col0 * 67 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + 85 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 * 17 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col2 * cor0.col1 + + ( - cor0.col2 + + cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 56 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT tab2.col2 AS col1 FROM tab2, tab1 AS cor0 GROUP BY tab2.col2

;

SELECT 86 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + col1 * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - - 64 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col2 * - 89 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - - 21 FROM tab0 GROUP BY tab0.col1

;

SELECT - 38 * - col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 23 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT - col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT - 32 * + 89 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + 14 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - + 83 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + + tab2.col0 * tab2.col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT + ( cor0.col2 ) AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + 93 - cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT col1 * - tab1.col1 + - 48 FROM tab1 GROUP BY tab1.col1

;

SELECT - col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT 86 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT - tab2.col2 FROM tab2 WHERE NOT ( NULL ) IS NOT NULL GROUP BY tab2.col2 HAVING NULL IS NOT NULL
;

SELECT ALL col2 + + ( 90 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT - 29 * + col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - - 34 AS col0 FROM tab2 GROUP BY col1

;

SELECT ALL cor0.col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 76 + tab0.col2 FROM tab0 GROUP BY col2

;

SELECT + 81 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + ( 14 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 18 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 95 + - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 91 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT - - 87 * tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + col2 * cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - cor1.col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL - 89 * cor0.col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - 58 + + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 93 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 1 AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 48 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 83 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - - 28 - 38 * + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 77 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 21 * + col1 - + cor0.col2 * + 89 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 43 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - - col1 - 50 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 10 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 28 * - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT 34 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT + 56 FROM tab2 GROUP BY tab2.col2

;

SELECT + + 69 FROM tab2 GROUP BY col1

;

SELECT ALL ( 93 ) FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 40 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + COALESCE ( col1, + 12 ) AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - + col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 11 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL 7 + + 92 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - 41 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + tab0.col2 + 12 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 27 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 60 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 64 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL 84 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 41 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 16 FROM tab1 cor0 GROUP BY col0, cor0.col1

;

SELECT - tab2.col1 * - 46 AS col2 FROM tab2, tab2 AS cor0 GROUP BY tab2.col1

;

SELECT + tab2.col2 * - tab2.col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT ALL + 49 - - 34 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 * 1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor1.col2

;

SELECT + tab0.col0 + tab0.col0 * 80 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 50 FROM tab1 GROUP BY tab1.col0

;

SELECT tab2.col1 FROM tab2 WHERE NOT NULL > NULL GROUP BY tab2.col1

;

SELECT + + 20 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 47 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT col2 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 56 FROM tab0 GROUP BY col1

;

SELECT ALL 80 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col2

;

SELECT - 28 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT + 9 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + tab1.col2 * 2 + - 34 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + + tab0.col2 * 7 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 20 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL - - 77 AS col0 FROM tab2 GROUP BY col1

;

SELECT - cor0.col1 * - 93 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 48 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL + 47 FROM tab1 GROUP BY col0

;

SELECT DISTINCT - 62 * tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 37 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 25 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 98 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - 42 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + - 35 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 81 - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + + 20 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 6 * 14 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + ( + cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 33 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT + - 23 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL tab2.col1 - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - 9 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 38 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT - - col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 60 + - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 94 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 49 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT - 87 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col1

;

SELECT ALL + 9 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 39 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL 38 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT ALL + 4 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col1 - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + - 37 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 13 * + 17 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0, col0

;

SELECT + tab2.col0 + 24 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT - cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 24 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT NULLIF ( + cor0.col2, 92 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 30 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + cor0.col1 + NULLIF ( + 83, - cor0.col1 * 63 ) * - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT tab2.col1 - 36 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - cor0.col2 + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT cor0.col1 * 63 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 24 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT - 58 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + 84 * tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 22 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, col2

;

SELECT ALL + col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL IS NULL
;

SELECT ALL + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + cor0.col1 * ( cor0.col1 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( cor0.col2 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT tab0.col1 FROM tab0 GROUP BY col1 HAVING ( NULL ) NOT BETWEEN NULL AND ( tab0.col1 )
;

SELECT - 93 FROM tab1 GROUP BY tab1.col2

;

SELECT - - tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 49 * + cor0.col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT - - 42 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 28 FROM tab2, tab2 AS cor0 GROUP BY tab2.col0

;

SELECT ALL 17 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - 85 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - 41 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + + tab1.col0 - - tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - ( tab2.col1 ) + + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 25 * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 84 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 70 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col1 * 77 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + 52 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT - cor0.col2 * - col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, col1

;

SELECT DISTINCT + 96 + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 29 + + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT 74 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab2.col0 * + 23 FROM tab2 GROUP BY tab2.col0

;

SELECT + col2 + + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT + cor1.col0 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT - 86 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 73 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - 47 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + + 52 AS col2 FROM tab1 GROUP BY col1

;

SELECT 64 FROM tab1 GROUP BY tab1.col0

;

SELECT 47 FROM tab2 GROUP BY tab2.col2

;

SELECT + 83 AS col0 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 93 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor1.col2

;

SELECT - - 83 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 8 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 23 FROM tab0 GROUP BY col0

;

SELECT ALL + 36 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + 45 * tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + tab0.col1 * - 71 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + + col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - 5 * + 38 AS col2 FROM tab2 GROUP BY col0

;

SELECT ( + cor0.col1 ) FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT + + 52 FROM tab2 GROUP BY col1

;

SELECT - cor0.col1 * + 2 + + cor0.col1 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 28 + cor0.col2 * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 56 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 30 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + - 38 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 60 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col0 * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - 65 FROM tab2, tab1 AS cor0 GROUP BY tab2.col1

;

SELECT cor0.col2 + ( - 67 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT ( cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT 93 FROM tab1 cor0 GROUP BY col1

;

SELECT + 32 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + 45 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col0

;

SELECT ALL + NULLIF ( col2, tab2.col2 ) AS col0 FROM tab2 GROUP BY col2

;

SELECT 54 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + tab0.col2 AS col0 FROM tab0 WHERE NOT ( NULL ) IS NULL GROUP BY tab0.col2

;

SELECT + + 98 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 52 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 16 + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT 91 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 82 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + 8 FROM tab2 GROUP BY tab2.col1

;

SELECT - - col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT 9 * 61 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - 3 FROM tab0 GROUP BY tab0.col2

;

SELECT + 71 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - tab0.col0 * col0 FROM tab0 GROUP BY col0

;

SELECT - 59 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT tab2.col1 FROM tab2, tab1 AS cor0 GROUP BY tab2.col1

;

SELECT - tab0.col2 FROM tab0 GROUP BY tab0.col2 HAVING NOT ( NULL ) < NULL
;

SELECT ALL + + col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - + tab2.col0 + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + - tab2.col1 * tab2.col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT ALL 46 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 23 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - ( cor0.col2 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT + + ( 70 ) AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT - cor0.col1 - 68 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * + col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - NULLIF ( - col0, 91 ) AS col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + 34 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT 2 + cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + cor0.col2 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT - 48 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col2 * - col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + 4 AS col0 FROM tab0 GROUP BY col2

;

SELECT - 91 AS col0 FROM tab2 GROUP BY col2

;

SELECT ALL + tab2.col1 * 91 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - 36 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 31 + 91 * tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - 79 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 90 FROM tab1 GROUP BY col2

;

SELECT 5 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT + 84 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 79 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + 30 FROM tab1 GROUP BY tab1.col1

;

SELECT - - 9 * 82 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - 1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ( tab2.col0 ) AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + ( 70 ) FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 38 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 55 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col2 + + cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - 22 + tab2.col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT ALL 17 + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 83 * cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 0 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + + 45 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT 65 FROM tab0 GROUP BY col0

;

SELECT ALL - col0 * ( col0 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - - 67 FROM tab0 GROUP BY tab0.col0

;

SELECT 95 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - tab2.col2 - ( + NULLIF ( + tab2.col2, tab2.col2 * + col2 ) ) FROM tab2 GROUP BY col2

;

SELECT + - tab1.col2 * 25 FROM tab1 GROUP BY tab1.col2

;

SELECT + 55 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + 6 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 51 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - cor0.col2 * + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 26 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 48 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL - tab2.col1 + - tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 11 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 72 - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + cor0.col1 * cor0.col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - 85 * + col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + col2 FROM tab1 GROUP BY tab1.col2 HAVING NULL NOT BETWEEN - col2 AND ( tab1.col2 )
;

SELECT ALL cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NULL IS NOT NULL
;

SELECT + cor0.col0 * + col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + 46 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT 16 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 24 * cor0.col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + - 44 * 4 + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 94 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + - 41 FROM tab1 GROUP BY tab1.col1

;

SELECT 85 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 * - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT DISTINCT - 48 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 84 + col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 3 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 51 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - tab1.col0 * 31 FROM tab1 GROUP BY col0

;

SELECT - 80 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - NULLIF ( - tab2.col0, - tab2.col0 * 16 ) FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 85 * cor0.col0 + - 52 * + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, col0

;

SELECT DISTINCT + + 87 FROM tab0 GROUP BY col0

;

SELECT + col0 AS col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL + tab2.col0 * tab2.col0 + + 65 FROM tab2 GROUP BY col0

;

SELECT - 61 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + 66 AS col0 FROM tab2, tab2 AS cor0 GROUP BY tab2.col1

;

SELECT - 95 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL 57 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col0 * - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 38 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT col1 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + tab0.col0 * - 46 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 + 87 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 21 + - 54 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 97 * - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col2

;

SELECT 29 AS col0 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0, cor0.col2

;

SELECT DISTINCT + - 69 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 59 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 93 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col0 * 20 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col1

;

SELECT ALL + 51 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 99 + - 47 * + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + 9 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 9 FROM tab0 GROUP BY tab0.col0

;

SELECT ( + col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 51 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0, cor0.col1, cor0.col2

;

SELECT + + ( - 79 ) FROM tab0 GROUP BY tab0.col2

;

SELECT - 11 FROM tab0 GROUP BY tab0.col2

;

SELECT cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT col1 * + cor0.col2 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col2, cor0.col1

;

SELECT 93 * + cor0.col0 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 92 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 27 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - tab1.col2 * tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 69 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL 73 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 18 * + 66 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 74 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - col0 AS col0 FROM tab0 WHERE NOT col0 IS NULL GROUP BY tab0.col0

;

SELECT DISTINCT - tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0 HAVING NOT col0 IS NOT NULL
;

SELECT 59 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 65 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 22 + - col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + + 54 * 88 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + ( - tab1.col0 ) FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 28 * - 72 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL + 90 + 97 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 71 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT - col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT ALL + - 61 * - tab0.col2 FROM tab0 GROUP BY col2

;

SELECT + cor0.col2 + 41 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col2

;

SELECT + - tab1.col2 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT tab0.col2 + + 47 FROM tab0 GROUP BY tab0.col2

;

SELECT + 85 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 51 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 94 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 87 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + - 92 FROM tab1 GROUP BY tab1.col2

;

SELECT - 53 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT tab0.col2 * - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2 HAVING NULL < NULL
;

SELECT ALL - - tab0.col0 * - 3 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 91 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor1.col2

;

SELECT ALL - cor0.col2 + - cor0.col2 * 60 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT - 20 + - cor0.col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + 68 * - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - tab1.col0 - + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, col2

;

SELECT ALL - 81 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 + + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 1 + + cor0.col1 FROM tab0 cor0 GROUP BY col1

;

SELECT - cor0.col1 * cor0.col1 + - 59 * 68 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 30 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 9 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - 60 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT 50 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 46 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + 73 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + 17 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL - ( cor0.col2 ) * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - - 69 + 56 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 13 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL 10 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 30 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor1.col0

;

SELECT - 36 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 74 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + ( cor0.col0 ) + + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + + 46 AS col1 FROM tab1 GROUP BY col0

;

SELECT - 52 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + + 30 + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 73 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - cor0.col1 + - 47 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col2 AS col1 FROM tab1 cor0 GROUP BY col2, cor0.col0

;

SELECT 32 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 70 + 62 * col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 9 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL 86 + + col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 81 * + tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT + 82 + + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - ( - 96 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab2.col0 * tab2.col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT 93 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - cor0.col2 * - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - + 28 FROM tab1 GROUP BY tab1.col1

;

SELECT + 65 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + - 77 + 82 * tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + tab0.col1 + + 18 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col0 * 28 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 * cor0.col1 + 97 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col0 + - ( - cor0.col0 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 14 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col2 * 98 + - 88 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING tab0.col1 IS NULL
;

SELECT ALL 17 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 90 AS col1 FROM tab0, tab0 cor0 GROUP BY tab0.col0

;

SELECT - + cor0.col0 AS col2 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 37 * col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT 66 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col2 + - 98 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor1.col2

;

SELECT 38 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 81 FROM tab0 GROUP BY col2

;

SELECT - tab1.col0 + - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col0 * + 71 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT 98 FROM tab0 GROUP BY tab0.col1

;

SELECT - 77 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 95 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 42 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col1, cor1.col0

;

SELECT DISTINCT + 6 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 38 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - - 40 FROM tab2 GROUP BY col0

;

SELECT - 35 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 86 - 2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT col1 + 86 FROM tab2 GROUP BY col1

;

SELECT 70 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT - 30 - - 6 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - - 47 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 24 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 1 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - tab2.col0 + 37 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + - 33 + + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + 7 + tab2.col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT col2 * col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 92 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - ( - 99 ) FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col1 + - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1, col1

;

SELECT DISTINCT - ( - 63 ) - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 9 AS col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - + 10 AS col1 FROM tab2 GROUP BY col1

;

SELECT - 18 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 52 * cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT + 90 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + tab0.col0 * - col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - 58 FROM tab0, tab1 AS cor0 GROUP BY tab0.col0

;

SELECT + cor0.col0 * + cor0.col0 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 97 * + 57 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + ( 1 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + 64 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 15 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + 39 + - col0 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT + + 3 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 39 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + + 93 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + 5 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col2 * 62 AS col2 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + tab1.col1 * + 35 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + - tab2.col1 * + 25 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - col0 + - 15 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 39 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col1 * - cor0.col1 + + 43 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 68 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - 42 AS col0 FROM tab2, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + - 35 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + 94 * 64 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT + - 62 * + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col1 FROM tab1 cor0 GROUP BY cor0.col0, col1

;

SELECT 39 + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + ( - 43 ) FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 59 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 53 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT - 70 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + 54 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + tab0.col0 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - tab0.col1 + tab0.col1 FROM tab0 GROUP BY col1

;

SELECT - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, col1, cor0.col2

;

SELECT ALL - tab2.col1 + 59 FROM tab2 GROUP BY col1

;

SELECT DISTINCT + 21 * 28 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - col0 * ( - 65 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 49 * 5 FROM tab2 GROUP BY tab2.col2

;

SELECT + col1 * col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 39 * + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 13 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT + tab2.col1 * 83 FROM tab2 GROUP BY tab2.col1

;

SELECT - 35 FROM tab0 GROUP BY tab0.col1

;

SELECT + 7 + 99 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT + tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0 HAVING NOT NULL > NULL
;

SELECT col2 * 9 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 96 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - + tab0.col1 + tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 85 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL - cor0.col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT - col1 + - cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL + NULLIF ( tab2.col1, + tab2.col1 ) AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + col1 * 16 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 38 * + 40 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor0.col0 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col2 AS col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + tab1.col2 * - 9 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col1 FROM tab0 AS cor0 GROUP BY col1 HAVING ( NULL ) IS NOT NULL
;

SELECT ( - cor0.col1 ) * - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col2, col0, cor0.col1

;

SELECT ALL tab1.col2 * + tab1.col2 FROM tab1 GROUP BY col2

;

SELECT ALL - 71 FROM tab1 GROUP BY tab1.col1

;

SELECT - 1 + + 81 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 87 * + 19 + + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - + 38 FROM tab1 GROUP BY tab1.col2

;

SELECT 57 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 42 FROM tab0 GROUP BY tab0.col2

;

SELECT 4 * cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL 77 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor1.col0 * 91 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 75 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 30 * + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + col1 AS col0 FROM tab0 GROUP BY tab0.col1 HAVING NOT NULL NOT IN ( col1 )
;

SELECT ALL 68 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT - ( tab2.col1 ) AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + 50 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 67 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT + 42 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL + 60 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + + col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT + 6 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT 32 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 72 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col0

;

SELECT 45 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col1 + 80 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 + - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + tab1.col1 FROM tab1 WHERE NOT NULL NOT IN ( tab1.col2 * + tab1.col2 ) GROUP BY tab1.col1

;

SELECT ALL + col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + + 14 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 12 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 98 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - 85 FROM tab1 GROUP BY tab1.col0

;

SELECT - 95 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col0 AS col2 FROM tab1 WHERE NOT NULL IS NULL GROUP BY col0

;

SELECT DISTINCT 6 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 74 AS col1 FROM tab0 cor0 GROUP BY col2

;

SELECT + - 63 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 23 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - 54 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + - tab2.col1 + - 98 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - + 92 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - cor0.col0 * - cor0.col2 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT 99 + col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab1.col2 + - tab1.col2 * - 17 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col2 - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - - 84 FROM tab0 GROUP BY col1

;

SELECT - + col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT + 13 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 19 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 75 - + 87 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 23 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 14 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT + + tab0.col2 + 18 FROM tab0 GROUP BY tab0.col2

;

SELECT - - col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 24 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 89 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL 79 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + 21 FROM tab0 GROUP BY col2

;

SELECT - tab1.col1 * 46 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + tab0.col1 * - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + - 78 FROM tab2 GROUP BY col1

;

SELECT + 26 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor0.col1

;

SELECT cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NULL IS NULL
;

SELECT DISTINCT + col0 + cor0.col0 * cor0.col0 AS col2 FROM tab0 AS cor0 WHERE ( + col2 ) IS NOT NULL GROUP BY col0

;

SELECT ALL - tab0.col0 * tab0.col0 FROM tab0 WHERE ( - col1 * + tab0.col2 ) IN ( - col2 ) GROUP BY tab0.col0

;

SELECT ALL - - tab1.col1 + - col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + 26 + + 11 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - tab0.col0 + + 43 * - 73 AS col2 FROM tab0 GROUP BY col0

;

SELECT - tab1.col2 * - col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col0 + - col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + tab1.col1 + + col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT 60 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - 5 - col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + tab1.col1 * - 83 FROM tab1 GROUP BY tab1.col1

;

SELECT 78 * cor1.col0 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT col1 + + 35 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - 86 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - col0 * - 35 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 24 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT 9 + - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 70 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 10 + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT 37 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 95 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT cor0.col2 * ( col2 ) FROM tab1 AS cor0 GROUP BY col2

;

SELECT - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL + cor0.col0 * col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col0, cor0.col1

;

SELECT DISTINCT - cor0.col2 AS col1 FROM tab2 cor0 GROUP BY col2, cor0.col0, cor0.col0

;

SELECT tab0.col2 FROM tab0 GROUP BY tab0.col2 HAVING NULL IS NOT NULL
;

SELECT ALL 37 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 25 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 98 - 25 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 22 + - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT tab0.col2 * tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - + 16 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT + tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1 HAVING ( NULL ) IS NOT NULL
;

SELECT NULLIF ( + col2, cor0.col2 * cor0.col2 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 94 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + ( + 1 ) * - cor0.col1 + 78 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 99 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 95 - tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - 54 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col1 + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 32 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 21 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 64 FROM tab0 GROUP BY col1

;

SELECT - tab1.col2 AS col2 FROM tab1 WHERE col0 NOT IN ( tab1.col2 + tab1.col1 ) GROUP BY tab1.col2 HAVING NOT NULL IS NULL
;

SELECT 73 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 31 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 32 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL - col1 * + col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 31 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 71 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 47 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT NULLIF ( + col1, cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col1 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 + 82 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 + + 24 AS col2 FROM tab0 cor0 GROUP BY col2, cor0.col2, col2

;

SELECT 75 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT ALL + cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 4 * - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col0 + + 96 * + 15 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NULL
;

SELECT + col2 * col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT cor0.col2 + - 6 * col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + - ( - col1 ) FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 71 AS col0 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - 29 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT 63 + - 44 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 9 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 63 * col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT cor0.col0 - - 81 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 77 + 20 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - - tab1.col2 + 59 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 50 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col0 AS col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT + - tab0.col0 + ( 7 ) FROM tab0 GROUP BY tab0.col0

;

SELECT - col1 + 3 FROM tab1 AS cor0 GROUP BY col1

;

SELECT tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0 HAVING NOT NULL <= NULL
;

SELECT DISTINCT - col2 + - tab1.col2 AS col1 FROM tab1 GROUP BY col2 HAVING NULL < NULL
;

SELECT - 4 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 74 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT + tab2.col1 * + 65 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT 86 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 * 10 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT ALL + 96 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 80 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 71 * - 62 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 34 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 48 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 20 FROM tab0 cor0 GROUP BY col1

;

SELECT - tab0.col1 * - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col1 * 95 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - col0 * + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col2 AS col0 FROM tab0 AS cor0 WHERE ( NULL ) IS NULL GROUP BY col2

;

SELECT DISTINCT cor0.col1 * + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col0 + - 7 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 98 * + col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT 25 - col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 13 + col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 23 * - 94 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + + tab1.col2 * tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col2 * - cor0.col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT tab2.col0 + + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col0 * - cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 77 * - cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL 96 - col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - col1 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT - 40 AS col0 FROM tab0 GROUP BY col2

;

SELECT + cor0.col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + + ( - tab2.col0 ) AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT col1 * tab1.col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT 37 * tab1.col2 + + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 38 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - ( 66 ) FROM tab2 GROUP BY tab2.col2

;

SELECT - ( cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL + - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT 73 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - tab1.col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT 27 * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT tab1.col2 * - 28 FROM tab1 GROUP BY tab1.col2

;

SELECT - 61 FROM tab2 GROUP BY col2

;

SELECT - 83 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 62 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT 21 - + 54 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 92 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL cor0.col0 * 33 FROM tab1 AS cor0 GROUP BY cor0.col2, col0, cor0.col1

;

SELECT ALL cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col1, cor0.col0, cor1.col2

;

SELECT DISTINCT - 91 * - col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT cor0.col2 * - cor0.col2 + 24 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - ( CASE cor0.col0 WHEN + 31 THEN - cor0.col1 ELSE cor0.col1 * cor0.col0 END ) AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col1, cor0.col1

;

SELECT ALL NULLIF ( - cor0.col2, cor0.col2 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col1 HAVING NOT ( NULL IS NOT NULL ) AND NULL IS NULL
;

SELECT ALL + 89 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor0.col2

;

SELECT cor0.col0 + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col1 * 19 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col0 * cor0.col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL + 84 FROM tab1 GROUP BY tab1.col2

;

SELECT 1 * col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 26 AS col1 FROM tab2 GROUP BY col0

;

SELECT 11 + + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 18 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 63 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT ( + tab0.col0 ) AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 31 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - col0 * 43 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 50 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col2 + 22 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - 53 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 * 17 + 25 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL - + 10 FROM tab0 GROUP BY tab0.col0

;

SELECT col1 AS col0 FROM tab2 GROUP BY tab2.col1 HAVING NULL IS NOT NULL
;

SELECT ALL + 90 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col1 * tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 55 AS col0 FROM tab1, tab1 AS cor0 GROUP BY tab1.col1

;

SELECT 21 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1

;

SELECT - + 27 FROM tab0 GROUP BY tab0.col0

;

SELECT - - 83 FROM tab2 GROUP BY tab2.col1

;

SELECT - 32 * cor0.col1 + + cor0.col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 + 4 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 39 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL + - 17 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL ( + 31 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 * col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - 66 AS col2 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT + 17 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 15 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + tab2.col0 FROM tab2 GROUP BY col0 HAVING - col0 > NULL
;

SELECT cor0.col1 - - 59 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ( + cor0.col1 ) + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT 81 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + ( + 28 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 88 AS col1 FROM tab2 GROUP BY col2

;

SELECT 57 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + COALESCE ( + cor0.col2, 49 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 73 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 59 - + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + 41 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col2 * + 22 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 67 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 47 * + 69 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL - tab2.col0 - + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL col2 + tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 88 - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 26 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 59 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - - 82 FROM tab1 GROUP BY col2

;

SELECT tab2.col1 FROM tab2 WHERE - col1 IN ( tab2.col1 ) GROUP BY tab2.col1

;

SELECT ALL + tab2.col1 * 33 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT tab2.col0 + + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + + ( 78 ) FROM tab0 GROUP BY tab0.col0

;

SELECT 3 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT cor0.col0 + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT cor0.col2 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT 73 + col1 * cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 71 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + + tab2.col1 * 40 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - 49 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL tab1.col2 FROM tab1 WHERE NULL NOT IN ( tab1.col0 * tab1.col1 ) GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col2 + - 1 * cor0.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT 75 FROM tab0 GROUP BY tab0.col2

;

SELECT 10 * - 63 FROM tab2 GROUP BY col2

;

SELECT ALL - 65 AS col2 FROM tab1 GROUP BY col0

;

SELECT - 47 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 69 + 61 * - cor0.col2 AS col1 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT + col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT + 7 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + 43 FROM tab1 GROUP BY col1

;

SELECT 0 - 72 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 13 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - tab1.col1 - 2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 56 FROM tab2, tab0 AS cor0 GROUP BY tab2.col1

;

SELECT ALL + 82 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0, col2

;

SELECT cor0.col0 * col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 - cor0.col1 FROM tab0 cor0 GROUP BY col1, cor0.col0

;

SELECT + tab0.col2 + + col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT tab1.col2 FROM tab1 GROUP BY tab1.col2 HAVING ( NULL ) IS NOT NULL
;

SELECT - 91 AS col2 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT 52 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 79 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + - 88 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 67 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor1.col0 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT + 83 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - - col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col0 - cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 22 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 38 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 26 * col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT 32 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - 13 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - NULLIF ( cor0.col2, - cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 77 FROM tab0 GROUP BY col2

;

SELECT - 93 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 31 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL - tab1.col0 - + 18 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + tab2.col0 + + tab2.col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT ALL cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL cor0.col0 * cor0.col0 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 74 * + 34 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab1.col0 - col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 * 23 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + tab2.col1 * tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 67 + tab1.col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + ( 58 ) FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 71 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + tab1.col1 * tab1.col1 AS col2 FROM tab1 WHERE NOT NULL IS NULL GROUP BY tab1.col1

;

SELECT + cor0.col0 + cor0.col0 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT - - 9 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 7 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - 83 * - cor0.col2 + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 85 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 2 FROM tab1 cor0 GROUP BY cor0.col1, col0, cor0.col1

;

SELECT DISTINCT - 11 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL - 89 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col2

;

SELECT 82 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 * + 70 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 28 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0, col1

;

SELECT - - 4 * 29 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + + ( - tab2.col2 ) FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + cor0.col1 - cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - 75 * - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + cor0.col2 + - 16 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + tab1.col1 - tab1.col1 * + 33 FROM tab1 GROUP BY tab1.col1

;

SELECT - tab1.col1 FROM tab1 WHERE NULL IS NOT NULL GROUP BY col1

;

SELECT ALL - - 10 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - tab0.col2 * col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT + NULLIF ( tab0.col1, tab0.col1 ) AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col2 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - 46 * cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col2 * + 66 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 - 11 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 17 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 14 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 58 FROM tab2 AS cor0 GROUP BY cor0.col1, col1, col0

;

SELECT ALL + NULLIF ( + cor0.col2, - cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT tab0.col0 + 95 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT cor0.col2 + 26 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + tab0.col1 * tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING NOT ( NULL ) <> + tab0.col1
;

SELECT + tab0.col2 * 38 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 4 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + 4 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab2.col2 + + 96 AS col2 FROM tab2 GROUP BY col2

;

SELECT ALL col0 + + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT tab1.col0 * - tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0 HAVING NULL IS NOT NULL
;

SELECT + 54 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 34 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 6 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + tab0.col0 - + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - 11 * tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 64 FROM tab0 GROUP BY tab0.col1

;

SELECT - col1 * + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1, cor0.col1

;

SELECT + 78 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT NULLIF ( tab0.col0, 68 + - col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 16 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + cor0.col0 - + 63 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL 26 * - 18 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 - - cor0.col0 * 74 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 75 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + - 62 FROM tab0 GROUP BY tab0.col1

;

SELECT col0 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 25 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + tab2.col2 * - tab2.col2 + - 96 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - 31 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - 23 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - 44 FROM tab2 GROUP BY tab2.col2

;

SELECT + + 66 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + cor0.col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor0.col0

;

SELECT cor1.col0 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + 20 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT ( 44 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT NULLIF ( + cor0.col1, cor0.col1 + cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - - tab0.col0 * + 82 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING NOT NULL > NULL
;

SELECT DISTINCT + - 27 + + 46 * + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - 19 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 67 + tab1.col1 * + col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT 62 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL tab0.col0 + + tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL NOT BETWEEN NULL AND ( NULL )
;

SELECT ALL - tab0.col0 FROM tab0 GROUP BY tab0.col0 HAVING NOT NULL NOT BETWEEN NULL AND NULL
;

SELECT - tab1.col1 * + 6 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 96 FROM tab2 AS cor0 GROUP BY col2, cor0.col0, cor0.col2

;

SELECT cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0, col2

;

SELECT col0 + 65 * 98 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT 88 + cor0.col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT - - col2 FROM tab2 GROUP BY col2

;

SELECT - 23 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 8 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT + cor0.col2 - + 78 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 29 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + 79 FROM tab1 GROUP BY col0

;

SELECT ALL ( - 45 ) - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 87 FROM tab2 GROUP BY tab2.col0

;

SELECT + 91 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 64 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 51 FROM tab2 GROUP BY tab2.col1

;

SELECT + 79 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL IN ( - tab1.col2 )
;

SELECT ALL - tab1.col2 * - col2 AS col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL NOT IN ( + tab1.col2 )
;

SELECT ALL - + ( tab0.col1 ) FROM tab0 GROUP BY tab0.col1

;

SELECT col0 AS col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - + tab1.col2 + - 51 FROM tab1 GROUP BY tab1.col2

;

SELECT + col1 * 32 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + + tab1.col2 + - 23 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT 37 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 18 * col0 + ( - cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT + COALESCE ( 60, tab1.col2 ) AS col1 FROM tab1, tab1 cor0 GROUP BY tab1.col2

;

SELECT ALL - - 70 FROM tab1 GROUP BY tab1.col0

;

SELECT - + 17 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 97 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col2, cor0.col2

;

SELECT ( - 32 ) AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col0 FROM tab0 cor0 GROUP BY col1, cor0.col0

;

SELECT + + ( 74 ) AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col1 * - 45 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1, cor0.col2

;

SELECT ALL - 53 * + tab0.col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT - 4 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - 3 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 73 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + tab2.col0 + + col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + + tab1.col1 + + tab1.col1 * - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT tab2.col0 + + 65 * 18 AS col0 FROM tab2 GROUP BY col0

;

SELECT tab1.col1 + ( - 0 ) FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col2, cor0.col2

;

SELECT DISTINCT + 28 * - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor1.col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor1.col0

;

SELECT cor0.col2 + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - + 38 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 99 AS col2 FROM tab0 cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT 31 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT ( 38 ) AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + - 57 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + + 24 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1, cor1.col0

;

SELECT + 11 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + 4 + - 57 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 34 * - cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT 92 AS col1 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT 97 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - cor0.col2 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - cor0.col2 * + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL - tab2.col0 * 46 AS col1 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + COALESCE ( + col2, - 50 ) AS col2 FROM tab2 cor0 GROUP BY col2, cor0.col2

;

SELECT + - 54 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 11 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 26 FROM tab2 AS cor0 GROUP BY cor0.col1, col1

;

SELECT + tab0.col2 * - 53 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - + 60 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 57 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - cor0.col2 * cor0.col2 + ( + 81 ) FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - - 47 + - 91 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT tab1.col0 * 81 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + 96 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 24 * + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + - 36 * + tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - col2 * - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 58 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 2 + + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 71 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + cor0.col2 - + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col1 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT tab0.col0 + 88 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col1 * - 1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT ( + cor0.col0 ) - - cor0.col0 * cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT - tab2.col2 * tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 42 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 12 * tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col0 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col0

;

SELECT DISTINCT 65 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT - cor0.col2 * - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 84 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 39 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT - 51 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + 46 - 76 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 91 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT 89 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 99 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT ( ( + cor0.col2 ) ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 90 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT + 87 AS col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT + + col1 FROM tab2 GROUP BY col1

;

SELECT cor0.col2 * + 33 - 3 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + tab1.col0 * + NULLIF ( 55, - col0 ) AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + 32 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0 HAVING tab0.col0 IS NOT NULL
;

SELECT ALL col2 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 * - col1 + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT ( + 20 ) AS col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT - - 39 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL col2 + + tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + + 69 FROM tab1 GROUP BY tab1.col2

;

SELECT + 97 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 72 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - 89 * 9 FROM tab0 GROUP BY col2

;

SELECT - - 45 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT + 20 * - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 82 FROM tab0 GROUP BY col1

;

SELECT ALL + 29 * 93 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 47 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - ( + 88 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 15 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2 HAVING ( NULL ) IS NOT NULL
;

SELECT ALL 37 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - 72 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 29 - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + + 96 FROM tab0 GROUP BY tab0.col2

;

SELECT col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT tab0.col1 FROM tab0 WHERE ( NULL ) IS NULL GROUP BY tab0.col1

;

SELECT DISTINCT tab1.col2 + tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT 30 + - 50 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + + col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ( 63 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 4 + - 36 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 13 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 12 * + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col0, cor0.col1

;

SELECT - cor0.col2 + col1 AS col1 FROM tab1 cor0 GROUP BY col1, cor0.col2

;

SELECT ALL 13 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT 2 FROM tab0 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor1.col2

;

SELECT cor0.col1 * + cor0.col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, col1

;

SELECT 13 * + 87 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - - tab1.col0 + + col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col1 - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 93 AS col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT tab1.col2 AS col1 FROM tab1 GROUP BY col2 HAVING NOT NULL = ( NULL )
;

SELECT ALL - 73 * col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor1.col2 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col1, cor0.col0

;

SELECT 84 FROM tab2 GROUP BY col1

;

SELECT 85 + col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 22 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT + - 43 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - - 49 * col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT 88 - col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 9 + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 57 + 96 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT 88 AS col2 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT DISTINCT + 7 FROM tab1 AS cor0 GROUP BY cor0.col2, col1, cor0.col1

;

SELECT DISTINCT col0 * + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + 39 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + tab0.col1 + - ( tab0.col1 ) AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT + 22 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT 67 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + + col2 + 55 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - 57 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 91 * col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + - 45 FROM tab0 GROUP BY tab0.col0

;

SELECT - 11 + tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - - 34 + + tab2.col0 * - 20 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0 HAVING NOT ( NULL ) IS NULL
;

SELECT DISTINCT + - tab0.col0 * + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - tab1.col1 - + tab1.col1 * col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + 79 * cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ( tab1.col0 ) AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 34 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 50 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - - tab0.col1 + - tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - cor0.col2 - 74 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL - col0 + 38 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 47 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 23 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT col0 AS col2 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - 90 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 67 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - cor0.col1 * col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 54 AS col2 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor0.col0

;

SELECT ALL - tab2.col1 * col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 9 * - 24 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + ( tab1.col1 ) AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 65 AS col0 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT + - 70 FROM tab0 GROUP BY col0

;

SELECT ALL + 80 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 67 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2

;

SELECT tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0 HAVING NOT NULL IS NULL
;

SELECT + - tab1.col1 + - tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col1 * cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT + 59 FROM tab1 AS cor0 GROUP BY cor0.col2, col2

;

SELECT DISTINCT + 22 + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + + tab1.col1 * - tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - cor0.col1 * cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 42 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 - - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + 26 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 62 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * 15 + - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 48 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + tab1.col0 - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 52 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 15 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 20 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 43 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 64 + + cor0.col0 * - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 12 * + 70 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT 16 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 91 + - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - tab2.col2 * CASE + 31 WHEN tab2.col2 THEN NULL ELSE + tab2.col2 END FROM tab2 GROUP BY tab2.col2

;

SELECT + ( + 81 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 + - cor0.col2 * cor0.col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col2 * + col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 16 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT 67 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col1 AS col2 FROM tab1 GROUP BY tab1.col1 HAVING ( tab1.col1 ) IN ( - tab1.col1 )
;

SELECT DISTINCT col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT tab0.col0 + col0 * 28 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT + 45 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - - tab0.col2 - + tab0.col2 FROM tab0 GROUP BY col2

;

SELECT + col2 * + 23 + 66 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + + 42 FROM tab1, tab0 AS cor0 GROUP BY tab1.col0

;

SELECT 13 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 25 FROM tab1 GROUP BY col1

;

SELECT ALL + 93 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + - 48 * 17 + - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + tab0.col2 * tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT tab2.col0 * tab2.col0 + - 7 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT NULLIF ( 49, tab1.col0 ) FROM tab1 GROUP BY tab1.col0

;

SELECT + 10 * col0 - - 1 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - cor0.col1 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT + 88 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + - tab1.col2 + tab1.col2 * + 16 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + 35 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - - 23 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 63 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT tab1.col1 * + tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 87 AS col0 FROM tab1 GROUP BY col1

;

SELECT ALL 16 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL tab2.col2 AS col0 FROM tab2 WHERE NOT tab2.col1 IS NULL GROUP BY tab2.col2

;

SELECT DISTINCT - 51 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - + tab1.col2 * tab1.col2 + + 85 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + + tab0.col1 + + 64 FROM tab0 GROUP BY tab0.col1

;

SELECT + - 63 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - CASE cor0.col0 WHEN - cor0.col2 THEN - cor0.col2 END FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 7 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col0 FROM tab0 cor0 GROUP BY cor0.col1, col0

;

SELECT - 42 AS col0 FROM tab1, tab1 AS cor0 GROUP BY tab1.col0

;

SELECT 8 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 71 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 59 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col2 AS col0 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor1.col2

;

SELECT cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT + 18 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 36 * - 76 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - ( tab0.col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT col0 * 51 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT ALL + 3 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 73 + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + 51 * + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + cor0.col1 * + 19 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col0 - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 8 FROM tab0 GROUP BY col1

;

SELECT 18 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - ( 18 ) FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 93 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 53 + - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT 24 AS col0 FROM tab1 GROUP BY col0

;

SELECT - 54 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col1 + + cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - 13 + col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 + + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING NOT col0 <= NULL
;

SELECT cor0.col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - ( 68 ) FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 55 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor0.col2

;

SELECT 83 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + 85 * + 92 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + + col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 23 * 45 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + tab1.col2 + + 10 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + - 56 * tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 42 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + COALESCE ( + cor0.col1, col1, - 91 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT 87 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col2 * 33 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - col1 * col1 + - 9 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + tab2.col1 + 81 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT 23 FROM tab0 AS cor0 GROUP BY cor0.col1, col0, cor0.col0

;

SELECT cor0.col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - ( + 8 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + + 20 FROM tab1 GROUP BY tab1.col0

;

SELECT 52 * + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 74 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 31 * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 * - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT DISTINCT + 9 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 50 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ( 85 ) AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT cor0.col0 * + 22 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL 38 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - - tab0.col1 + + 87 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 7 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 35 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 48 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 * 45 + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + col1 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 82 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 64 * cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - 57 FROM tab0 GROUP BY tab0.col1

;

SELECT col2 * + cor0.col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col1 * col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 46 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - 76 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col0 + 43 FROM tab1 GROUP BY col0

;

SELECT ALL - 38 * - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL tab1.col0 * col0 + ( + ( + tab1.col0 ) + tab1.col0 ) FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 26 AS col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + tab2.col0 + - tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - 8 - 26 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - - 95 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 67 * col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + + 48 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - cor0.col1 - + cor0.col1 * + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 30 + - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 22 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - - 61 + 1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + - 95 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 75 * - tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + cor0.col0 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL 46 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT 77 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + + tab1.col0 * + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col0 AS col1 FROM tab2 cor0 GROUP BY col0

;

SELECT - 3 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - 63 AS col0 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL 23 - col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - 64 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - 42 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT 76 + tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - cor0.col0 - - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 97 - cor0.col2 * + 61 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 45 FROM tab0 GROUP BY col1

;

SELECT ALL 97 * + 62 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + 43 + 93 * - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 95 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT 39 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT tab1.col1 FROM tab1 WHERE NULL IS NOT NULL GROUP BY tab1.col1

;

SELECT - 74 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - tab0.col1 * + 29 FROM tab0 GROUP BY tab0.col1

;

SELECT + COALESCE ( + 83, tab0.col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 30 AS col2 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT - - col0 + tab1.col0 * + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 16 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT 35 * tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 80 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 17 * - col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 17 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT - ( + 91 ) FROM tab1, tab2 AS cor0 GROUP BY tab1.col0

;

SELECT - cor0.col0 * + 45 + 75 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 36 + + 44 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT cor0.col0 * 37 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 6 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 86 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT - - ( - 29 ) FROM tab1 GROUP BY tab1.col0

;

SELECT col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 49 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor1.col0 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col0

;

SELECT + + 70 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 9 AS col0 FROM tab0 GROUP BY col1

;

SELECT - tab1.col0 * 45 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 95 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT - cor0.col0 * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - 65 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor1.col2 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0, cor1.col2

;

SELECT DISTINCT + 34 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING ( NULL ) IN ( + col1 )
;

SELECT 33 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT 44 + tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL tab2.col0 * + 49 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - ( 15 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 62 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor0.col0

;

SELECT + cor0.col2 * col2 - 99 * - cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - 89 FROM tab2 cor0 GROUP BY col1

;

SELECT + cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT 71 * 27 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 + + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT tab0.col0 AS col0 FROM tab0 WHERE NOT col0 IS NULL GROUP BY tab0.col0 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT + cor0.col2 AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - col0 + - 3 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 98 - col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - - 42 FROM tab0 GROUP BY tab0.col2

;

SELECT - + 36 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - 0 * + cor0.col2 - cor0.col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 82 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 - + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + cor0.col2 * - 12 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - 93 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT cor0.col1 - cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - 85 + + col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - tab1.col2 * - tab1.col2 + + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 24 + + 44 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 26 FROM tab2 cor0 GROUP BY col2

;

SELECT + 91 FROM tab2, tab2 cor0 GROUP BY cor0.col0

;

SELECT + 65 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT - 91 FROM tab2 GROUP BY col2

;

SELECT ALL 53 FROM tab2 cor0 GROUP BY col2

;

SELECT + - ( - 66 ) + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + - tab2.col2 + - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 14 AS col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - ( + 68 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 72 FROM tab2 GROUP BY tab2.col2

;

SELECT 36 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - col1 * tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - 11 AS col2 FROM tab0 GROUP BY col1

;

SELECT + 45 + - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 * 68 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT + 55 * col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL tab0.col1 * tab0.col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 45 * + col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 86 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col0 - - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT 26 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - tab1.col0 FROM tab1, tab0 AS cor0 GROUP BY tab1.col0

;

SELECT tab2.col0 * - tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 92 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 80 * tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + ( - 83 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 53 + - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + ( 53 ) * + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT NULLIF ( tab1.col1, tab1.col1 * - ( 60 ) ) AS col2 FROM tab1 GROUP BY col1

;

SELECT - 62 * 20 AS col2 FROM tab0 GROUP BY col1

;

SELECT + - 16 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - - 61 FROM tab0 GROUP BY tab0.col2

;

SELECT + 60 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + - 69 * - col2 + col2 * + 17 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 97 * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 22 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT 37 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 65 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 51 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 71 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + 67 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - tab0.col0 * 68 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 91 * + 78 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col1 + + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 55 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 4 * 90 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 AS col0 FROM tab2 cor0 GROUP BY col1, cor0.col2

;

SELECT + cor0.col0 * - cor0.col0 + col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 + 98 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - tab0.col2 + + 14 AS col1 FROM tab0, tab2 AS cor0 GROUP BY tab0.col2

;

SELECT DISTINCT 40 + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 96 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 61 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + 83 + - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + 65 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + + 73 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 11 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + 47 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT - 46 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - 29 AS col1 FROM tab1 GROUP BY col0

;

SELECT DISTINCT 29 * - 8 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 1 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 94 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * 56 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - + 15 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 93 FROM tab0 GROUP BY tab0.col2

;

SELECT - - ( tab1.col0 ) AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT 26 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + col2 FROM tab0 cor0 GROUP BY col2

;

SELECT + 5 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 82 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT 13 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + 8 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + tab2.col2 + + 89 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING NULL NOT BETWEEN NULL AND NULL
;

SELECT DISTINCT 73 + 92 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL cor0.col1 * 25 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 95 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL tab2.col2 * + 12 + 98 AS col2 FROM tab2 GROUP BY col2

;

SELECT + 81 * tab0.col1 FROM tab0 GROUP BY col1

;

SELECT ALL + + 95 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - + 50 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 55 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 24 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 18 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 57 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + ( + 61 ) AS col0 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + 52 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 61 FROM tab0 GROUP BY tab0.col0

;

SELECT + 89 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT + 34 FROM tab1, tab2 AS cor0 GROUP BY tab1.col0

;

SELECT - cor0.col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col0, cor0.col1

;

SELECT 17 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 20 FROM tab1 GROUP BY col2

;

SELECT ALL + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + cor0.col0 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col2, cor0.col0

;

SELECT - col1 * - tab0.col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT ALL + cor0.col0 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 99 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + 23 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 49 AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL + ( + cor0.col1 ) - + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - tab1.col2 * - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + ( cor0.col2 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 67 + 40 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 47 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT + - ( - 77 ) FROM tab1 GROUP BY col2

;

SELECT ALL + 85 FROM tab1 GROUP BY col1

;

SELECT cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT 32 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 56 FROM tab1 cor0 GROUP BY col0

;

SELECT + cor0.col0 + + cor0.col0 * cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 7 AS col2 FROM tab0 cor0 GROUP BY col1, cor0.col0

;

SELECT + 22 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - - tab0.col1 * tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 59 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 13 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 52 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + ( + 61 ) FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 90 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - tab2.col0 * 60 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - 50 AS col1 FROM tab0 GROUP BY col2

;

SELECT - 41 * col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT ALL + ( 56 ) + 55 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 61 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 2 * - col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + - tab1.col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT ALL ( + tab0.col2 ) FROM tab0 GROUP BY tab0.col2

;

SELECT ALL NULLIF ( - cor0.col0, - cor0.col2 * cor0.col2 ) AS col0 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT + 70 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - 22 * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT cor0.col2 * col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT cor0.col0 * cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 51 * tab1.col1 FROM tab1 GROUP BY col1

;

SELECT 66 + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 48 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - ( - cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col1 * - 66 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT col0 + 17 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - + 0 * - tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 44 - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 22 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT - 85 + - tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 35 AS col0 FROM tab2 cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT - + 30 + - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 38 FROM tab1 GROUP BY tab1.col1

;

SELECT + 92 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT 89 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + 18 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + cor0.col1 * - col1 + cor0.col2 * cor0.col1 FROM tab2 cor0 GROUP BY col1, col2

;

SELECT DISTINCT - 23 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT tab0.col0 + - tab0.col0 * - col0 FROM tab0 GROUP BY col0

;

SELECT 40 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - 29 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - cor0.col0 + cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - tab0.col0 + col0 FROM tab0 WHERE - col0 IS NULL GROUP BY tab0.col0

;

SELECT ALL cor0.col0 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 58 * col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + - 91 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 90 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 + 15 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 78 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 5 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - + ( 97 ) FROM tab0 GROUP BY tab0.col0

;

SELECT - cor0.col1 * cor0.col1 FROM tab1 cor0 GROUP BY col1

;

SELECT - 23 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + 84 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 54 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - cor1.col0 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT + ( col1 ) FROM tab0 GROUP BY tab0.col1

;

SELECT 26 FROM tab2 GROUP BY tab2.col1

;

SELECT 43 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 76 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 77 * + cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT - tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING NOT NULL < NULL
;

SELECT + cor0.col0 * 9 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + + 52 + - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 86 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - cor0.col0 * - 39 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - + tab0.col2 + + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - cor0.col2 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col2

;

SELECT ALL - 1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + 22 FROM tab2 GROUP BY tab2.col2

;

SELECT - 49 FROM tab1 GROUP BY tab1.col0

;

SELECT 37 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL col0 * 51 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab2.col0 * - tab2.col0 + tab2.col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT ALL + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - - tab1.col0 * 87 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 54 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - ( - tab0.col2 ) FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 17 AS col2 FROM tab0 GROUP BY col1

;

SELECT ( + cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 44 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - cor0.col0 * + 77 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL + - 27 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + COALESCE ( + 66, tab1.col1 ) FROM tab1 GROUP BY tab1.col1

;

SELECT 55 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 84 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT + 38 FROM tab2 GROUP BY tab2.col2

;

SELECT - - 33 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT + tab2.col2 - + tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - col1 + + 87 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 0 AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT + 77 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 57 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - 26 + - tab1.col1 * + tab1.col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - 17 AS col0 FROM tab1 GROUP BY col2

;

SELECT + 59 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 20 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 27 FROM tab0 GROUP BY tab0.col2

;

SELECT + col2 * tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + tab0.col0 * col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + + 82 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 4 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 54 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + 66 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col0 AS col0 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT - col1 + - 64 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - - 46 + + 85 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - 83 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT - tab2.col1 * 79 FROM tab2 GROUP BY tab2.col1

;

SELECT + 70 FROM tab1, tab1 AS cor0 GROUP BY tab1.col0

;

SELECT COALESCE ( NULLIF ( cor0.col2, + 14 ), - 50 ) * cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 92 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 33 FROM tab2 GROUP BY tab2.col0

;

SELECT - - 9 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + tab1.col1 - 97 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + tab1.col1 * + tab1.col1 FROM tab1 GROUP BY col1

;

SELECT ALL col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL 8 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT - COALESCE ( + cor0.col2, col1 ) FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + 23 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col2

;

SELECT - 63 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 23 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL - cor0.col0 + col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT cor0.col0 * + cor0.col0 - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT 98 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - col0 - 53 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 59 + cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT ALL col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 18 FROM tab1 GROUP BY col2

;

SELECT ALL + tab1.col1 + - tab1.col1 FROM tab1 GROUP BY col1

;

SELECT ALL + - tab0.col2 * + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col0 * + cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT 61 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT - 62 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col0 * cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - + ( 16 ) FROM tab0 GROUP BY col1

;

SELECT - 13 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + NULLIF ( + tab1.col1, + tab1.col1 ) * col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + cor0.col0 - - 78 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT - + tab0.col0 * 97 + 53 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + 79 - tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 77 * cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL + - 15 * - 47 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - ( col1 ) AS col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 58 * 81 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - cor0.col0 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT cor0.col1 - + 66 * col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL - - cor0.col1 FROM tab1, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 50 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - + 95 FROM tab1 GROUP BY col2

;

SELECT cor0.col0 + 61 AS col0 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT - 0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + + 49 * - 51 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 15 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - NULLIF ( + cor0.col1, cor0.col1 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + - ( - tab2.col2 ) FROM tab2 GROUP BY col2

;

SELECT + 87 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 45 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 86 + cor0.col0 * 2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - 95 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 22 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 51 + + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT CASE + tab1.col1 WHEN 30 THEN - 42 END FROM tab1 GROUP BY tab1.col1

;

SELECT 1 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 21 * cor0.col2 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 4 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + + 37 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 3 * 24 AS col1 FROM tab2 GROUP BY col0

;

SELECT + 28 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col1 + - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 22 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 * - 73 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab0.col2 + + 76 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 30 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 54 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 57 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + - 51 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT ( - 45 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 61 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT cor0.col0 - cor0.col0 * cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT 22 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 75 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 52 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + - tab1.col1 - + 72 * tab1.col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT - 92 + - col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT DISTINCT tab1.col0 - 93 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 41 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - 78 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + cor0.col2 + 26 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 25 * cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 3 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL ( - col2 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL 41 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 29 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - ( + 35 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT + + 4 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 42 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL + COALESCE ( + 63, - tab0.col1 ) * + 8 FROM tab0 GROUP BY tab0.col1

;

SELECT + - 32 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL > ( NULL )
;

SELECT - 29 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT - 10 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL ( 14 ) AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + + col1 FROM tab0 GROUP BY col1

;

SELECT 8 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 19 + + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + cor0.col0 * cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 89 AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL + + 12 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 63 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 57 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 61 AS col1 FROM tab0 GROUP BY col0

;

SELECT + tab1.col0 * - 89 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - 7 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - tab0.col1 + 9 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 0 AS col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 54 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 79 - - cor0.col2 * - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 41 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - 18 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + col1 * tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL cor0.col2 * + 97 + - 16 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 64 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 16 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + cor0.col1 * 9 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 31 * - tab0.col1 FROM tab0 GROUP BY col1

;

SELECT + col1 + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 0 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT ( 15 ) * 11 AS col0 FROM tab1 GROUP BY col2

;

SELECT + 21 * 25 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 7 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT - 87 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 22 * 33 FROM tab0 GROUP BY col1

;

SELECT ALL - 34 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL NULLIF ( col1, - 56 * - cor0.col1 ) AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT 49 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT tab2.col2 + tab2.col2 FROM tab2 GROUP BY col2

;

SELECT ( 7 ) + col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 16 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + tab2.col2 * 34 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + 51 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT ALL + 85 AS col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + 29 FROM tab0 GROUP BY tab0.col0

;

SELECT + 94 * + 79 FROM tab2 GROUP BY tab2.col2

;

SELECT + 33 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 * + 64 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 * + 74 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + cor0.col1 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + tab1.col2 * + 34 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT ( 46 ) FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2

;

SELECT + cor0.col2 * - cor0.col2 + + 48 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL 3 AS col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 32 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + + 81 + + col2 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col1 * col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT ALL 9 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 71 + + 43 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 89 * col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - 10 + + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 27 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 35 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT + - tab2.col1 * tab2.col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 36 FROM tab1, tab1 AS cor0 GROUP BY tab1.col2

;

SELECT ALL + 95 * col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 99 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + 59 * tab1.col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - 66 * col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 76 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 2 * col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - col2 + - 70 FROM tab0 GROUP BY col2

;

SELECT 0 + - 69 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - - 96 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + + tab2.col2 + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 11 AS col0 FROM tab0 GROUP BY col1

;

SELECT ALL cor0.col0 FROM tab0 cor0 GROUP BY col1, cor0.col0

;

SELECT 25 + col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + cor0.col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 24 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 13 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT + 26 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ( ( cor0.col2 ) ) FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL + - 68 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + col2 + + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col0 * + 49 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col1 - + cor0.col2 FROM tab2 cor0 GROUP BY col2, cor0.col1

;

SELECT 72 * 93 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 71 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col2 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 62 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 84 FROM tab0 GROUP BY tab0.col2

;

SELECT 87 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + + 79 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 73 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT 41 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col1

;

SELECT DISTINCT + 51 * 17 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - - 90 * + 53 FROM tab1 GROUP BY tab1.col2

;

SELECT + 79 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 18 * + tab0.col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT cor0.col0 * col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 43 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 45 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 81 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 10 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + cor0.col0 * 53 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT + ( - cor0.col0 ) + col0 * + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + ( - tab1.col2 ) AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col2 + 86 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - 24 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + ( - cor0.col2 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - ( cor0.col1 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT - 47 FROM tab2 GROUP BY col2

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT + col1 + - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col1 + cor0.col1 * - col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - COALESCE ( 44, tab2.col0 * tab2.col0 ) FROM tab2 GROUP BY tab2.col0

;

SELECT tab1.col1 - tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT NULL IS NULL
;

SELECT + tab1.col2 AS col0 FROM tab1 WHERE NULL IS NULL GROUP BY tab1.col2

;

SELECT + 63 * + 79 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + cor0.col0 * 61 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 14 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL 67 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - - 4 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 82 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 8 - - tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + - col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col2 * 78 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 36 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + 96 AS col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL - 21 + - tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 14 * tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 97 FROM tab2 AS cor0 GROUP BY cor0.col1, col1

;

SELECT - + 19 FROM tab2 GROUP BY tab2.col2

;

SELECT - + 9 * + 13 + - tab0.col1 * + tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - - 21 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col1 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT 35 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 12 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + col0 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, col1, cor0.col2

;

SELECT ALL cor0.col0 * + 69 AS col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT 62 * - cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT tab1.col0 + + tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 54 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT 67 * cor0.col0 + - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 13 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 63 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT cor0.col0 * ( 55 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + - 88 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 34 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + ( 60 ) FROM tab2 GROUP BY tab2.col1

;

SELECT ( cor0.col1 ) AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * + cor0.col0 + 45 * - 46 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 17 - + 69 * + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 + - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 30 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 77 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col0 + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab1.col1 * - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 0 FROM tab1 GROUP BY col2

;

SELECT ALL - 38 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 60 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + 8 - - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 49 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT 20 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, col2

;

SELECT - cor0.col0 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 GROUP BY cor0.col0

;

SELECT - 85 + 52 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT tab1.col2 - 19 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col2 * 53 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - tab0.col0 * 37 + tab0.col0 * col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - ( tab0.col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - - 67 FROM tab1 GROUP BY col1

;

SELECT DISTINCT col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT tab2.col0 - tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col2 * - 57 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col2, cor0.col1

;

SELECT 48 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 15 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * 29 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 84 FROM tab2 AS cor0 GROUP BY col0

;

SELECT 89 * cor0.col0 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + 18 - - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + - 29 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col2 * - ( + cor0.col2 ) AS col2 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor0.col2

;

SELECT - 11 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 8 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT cor0.col0 + cor0.col0 * 85 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 20 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 10 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 44 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - + 16 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT + ( col1 ) * tab1.col1 + tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 85 * - tab0.col2 + tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 55 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + ( 85 ) + + 91 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT 4 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 18 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 36 + - cor0.col2 * - 88 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - - tab2.col0 + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - + tab1.col1 FROM tab1 GROUP BY col1

;

SELECT - - 37 + - 36 FROM tab1 GROUP BY tab1.col0

;

SELECT - 56 AS col2 FROM tab2 AS cor0 GROUP BY col0, cor0.col0, col2

;

SELECT - 98 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 + cor0.col2 * 64 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT DISTINCT + 89 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 9 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT ALL 65 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 60 * + 4 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + cor0.col0 + 65 AS col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT - + ( tab1.col1 ) FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + tab1.col0 * tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + tab0.col2 + 87 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + 48 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + + 71 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + ( cor0.col1 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 80 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT + 36 - cor0.col1 * 40 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + ( 74 ) FROM tab1 GROUP BY col0

;

SELECT ALL cor0.col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT 52 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - tab1.col2 + + tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + cor0.col0 * + 50 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 53 + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - - ( tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT tab0.col0 FROM tab0 GROUP BY tab0.col0 HAVING ( NULL ) NOT BETWEEN tab0.col0 AND NULL
;

SELECT ALL cor0.col1 FROM tab0 AS cor0 WHERE NOT ( NULL ) NOT BETWEEN col1 AND NULL GROUP BY cor0.col1

;

SELECT - 45 * + 72 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 82 * - cor0.col0 AS col2 FROM tab1, tab0 cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1, cor0.col1

;

SELECT - 2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + - 59 + - tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT 83 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ( 30 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + ( 35 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 76 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 45 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 8 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - col2 * tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + cor0.col0 FROM tab1 cor0 GROUP BY col0, col2

;

SELECT + 31 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 47 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 42 + - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT tab1.col0 + + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 61 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 29 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 73 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT col2 + - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT tab1.col1 - tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - - 7 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col2 + 89 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + tab1.col2 - col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - + 94 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 21 - 33 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT + + 11 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT - 13 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 97 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 96 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + 13 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 * + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 14 FROM tab2 GROUP BY tab2.col1

;

SELECT - 22 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 19 FROM tab0 GROUP BY tab0.col2

;

SELECT - 96 + tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 12 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + 70 FROM tab1 GROUP BY tab1.col0

;

SELECT - + col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 64 - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - + col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT tab1.col2 + tab1.col2 AS col1 FROM tab1 WHERE NOT NULL BETWEEN - tab1.col0 AND NULL GROUP BY tab1.col2

;

SELECT DISTINCT - tab2.col2 FROM tab2 WHERE NULL IS NOT NULL GROUP BY col2

;

SELECT tab0.col2 + tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL col2 + cor0.col2 AS col2 FROM tab0 cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT - 99 + + cor0.col1 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col1

;

SELECT + 30 * - 0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 23 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT - 23 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 4 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 20 * 21 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 52 * - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 4 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor1.col0

;

SELECT 85 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + 43 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col2

;

SELECT col2 + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + tab0.col2 * 89 FROM tab0 GROUP BY col2

;

SELECT ALL - cor0.col1 - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + tab0.col2 * - 37 AS col0 FROM tab0 GROUP BY col2

;

SELECT - - 62 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - ( - 17 ) FROM tab0 GROUP BY tab0.col1

;

SELECT - - ( 60 ) FROM tab1 GROUP BY tab1.col1

;

SELECT + - 31 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 6 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + 29 * tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 94 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col2 - cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT cor0.col0 + - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + 91 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col1 * + 52 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL - + ( - tab1.col2 ) AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 77 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT - NULLIF ( + 73, tab2.col1 ) * tab2.col1 + + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT tab0.col0 * col0 AS col1 FROM tab0 GROUP BY tab0.col0 HAVING NOT NULL >= - tab0.col0
;

SELECT col0 AS col1 FROM tab2 GROUP BY tab2.col0 HAVING NOT ( NULL ) IS NULL
;

SELECT ALL 7 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 29 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ( cor1.col0 ) AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col0

;

SELECT + col1 AS col0 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL - cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 27 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - 31 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor1.col0 + + cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2, cor1.col0

;

SELECT ALL col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - tab2.col0 + + tab2.col0 * tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 23 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 84 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + ( 35 ) FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL 52 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - 98 * 42 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 77 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, col2, cor0.col2

;

SELECT DISTINCT + 34 - + tab0.col2 * tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - tab2.col1 + 65 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT tab0.col2 + - tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - ( - 71 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - COALESCE ( + tab1.col2, tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT + 59 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + ( + tab2.col0 ) AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - col0 + - 67 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT col2 * - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT tab1.col1 + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 72 * - 59 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + tab2.col0 + + 66 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL ( ( + cor0.col1 ) ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 89 * cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 53 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL tab2.col0 + col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT tab2.col2 + - col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL tab1.col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT - tab1.col1 IS NOT NULL
;

SELECT ALL + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col1, cor0.col1

;

SELECT - 97 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL ( - cor0.col1 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 94 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 71 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 89 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - 57 AS col1 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - - 87 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + + 12 * 93 FROM tab0 GROUP BY tab0.col2

;

SELECT - tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1 HAVING ( NULL ) IS NULL
;

SELECT tab1.col0 * tab1.col0 FROM tab1 GROUP BY tab1.col0 HAVING NOT NULL IS NULL
;

SELECT + tab0.col0 * - tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 27 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + + 10 + - 13 FROM tab2 GROUP BY tab2.col0

;

SELECT - 8 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 16 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT - - tab1.col0 * tab1.col0 + + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 47 * tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 65 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + - tab2.col1 * - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + 5 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - - 40 FROM tab1 GROUP BY tab1.col0

;

SELECT 27 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - tab0.col2 + 29 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 67 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 83 AS col2 FROM tab2, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( - 36 ) + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - tab0.col0 + - tab0.col0 * - col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL tab1.col1 FROM tab1 WHERE NOT tab1.col1 <= ( tab1.col1 ) GROUP BY tab1.col1

;

SELECT - 93 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT - 55 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 26 + + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - ( + tab1.col0 ) AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT tab0.col1 + 98 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 77 FROM tab2 AS cor0 GROUP BY col1, cor0.col1

;

SELECT ALL - 51 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 20 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - tab0.col1 AS col0 FROM tab0 WHERE NULL IS NOT NULL GROUP BY tab0.col1

;

SELECT - cor0.col1 + - col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 37 + + 84 FROM tab0 GROUP BY tab0.col0

;

SELECT + 14 + col2 * cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL COALESCE ( + 93, cor0.col2 + + cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 39 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 7 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 83 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + col1 * + 71 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 36 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL tab2.col1 * ( + tab2.col1 - - tab2.col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT + tab0.col2 * tab0.col2 + + 58 FROM tab0 GROUP BY tab0.col2

;

SELECT - 9 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT + tab0.col1 * - 60 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT cor0.col2 * + 90 + + 21 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT 77 AS col0 FROM tab2 cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col0

;

SELECT tab1.col2 AS col0 FROM tab1 GROUP BY col2 HAVING - col2 NOT BETWEEN ( NULL ) AND col2
;

SELECT + - 54 FROM tab2 GROUP BY col2

;

SELECT ALL - 35 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT 29 - - cor0.col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL 42 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL - tab2.col0 - tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING + col1 IS NULL
;

SELECT DISTINCT cor0.col0 + - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT + cor0.col0 * + cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + 97 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 - + 95 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 98 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 28 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 94 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - + 9 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col1 + - 88 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - 22 + - 1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 61 * - tab1.col2 + - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + cor0.col0 + - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 31 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + cor0.col1 - cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + col0 + tab1.col0 * tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT 54 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT 19 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 71 + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 29 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 85 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col1 * + 19 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 9 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT tab1.col2 * - 2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - ( 6 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col0 * 92 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT ( - cor0.col2 ) * - cor0.col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + + 41 FROM tab0 GROUP BY col2

;

SELECT ALL - 69 * + 5 + - col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL 41 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL 56 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 22 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 + col0 * + cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + 26 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT CASE - col2 WHEN - cor0.col2 THEN cor0.col2 ELSE NULL END AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + 76 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 65 AS col2 FROM tab1 GROUP BY col1

;

SELECT + 77 * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - cor0.col2 + cor0.col2 * 25 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 20 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 57 * 25 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL NULLIF ( tab1.col0, 70 ) AS col2 FROM tab1, tab1 AS cor0 GROUP BY tab1.col0

;

SELECT + cor1.col2 AS col1 FROM tab0 cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col2

;

SELECT ALL tab2.col1 + tab2.col1 * 58 FROM tab2 GROUP BY tab2.col1

;

SELECT - tab1.col0 * - 10 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 82 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT cor0.col0 + - col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL + col0 * + tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + + 0 + + tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 32 AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 51 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT 11 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 54 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 - - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT col1 * 68 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 59 + cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, col2

;

SELECT - tab2.col0 * + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - 18 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL tab2.col1 - 48 AS col0 FROM tab2 GROUP BY col1

;

SELECT ALL + 92 * - col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT tab0.col1 * + tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 79 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 65 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ( + 49 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - 65 * - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT tab1.col0 + - col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 87 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 25 + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 0 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + cor0.col1 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL 2 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 * cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 29 * tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ( + 0 ) FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 44 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - ( - 9 ) AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + ( - 6 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 17 - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 11 + col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT tab1.col0 - tab1.col0 FROM tab1 GROUP BY col0

;

SELECT ALL 4 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL + tab0.col1 * + tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 * + 95 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 54 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 71 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 60 * + tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 76 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT 21 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + + tab1.col2 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col0 * col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + - tab2.col2 + 35 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 37 * + 99 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 84 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - ( + 23 ) - - 20 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab2.col2 * - 35 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 69 AS col2 FROM tab1 GROUP BY col1

;

SELECT DISTINCT col2 * cor0.col2 + - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + 10 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - cor0.col2 + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - 69 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - 42 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 64 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 20 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 76 FROM tab0 GROUP BY col2

;

SELECT ALL 94 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 80 * + 12 AS col0 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - tab0.col1 AS col1 FROM tab0 WHERE NOT NULL IS NOT NULL GROUP BY tab0.col1

;

SELECT ALL tab0.col0 * 33 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT 3 - 80 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT ( cor0.col0 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col1 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT 50 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 32 FROM tab0 GROUP BY tab0.col0

;

SELECT + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL tab2.col2 + 59 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 71 + cor0.col0 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT + cor1.col1 - cor0.col1 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor0.col1

;

SELECT - 85 * 82 + - cor0.col1 FROM tab1 cor0 GROUP BY col1

;

SELECT ALL + - 65 - tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - 77 FROM tab2 GROUP BY col0

;

SELECT ALL - 96 - - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 19 FROM tab1 GROUP BY tab1.col1

;

SELECT + + 77 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + - 11 * col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + - 95 * tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 17 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL 38 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - col1 + + 38 * - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + tab1.col1 + + col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + - tab1.col1 * 44 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + 18 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 89 + + 69 FROM tab2 cor0 GROUP BY col1, cor0.col0

;

SELECT ALL - 30 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 51 FROM tab2 GROUP BY tab2.col2

;

SELECT + + 39 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + 12 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 39 * + cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + - 12 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 64 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - cor0.col0 AS col1 FROM tab1 cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT 43 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 13 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 + + cor0.col1 * + 31 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 7 * col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT NULLIF ( + cor0.col1, col0 ) + 19 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT + + 8 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 65 FROM tab1 GROUP BY tab1.col2

;

SELECT + 71 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 26 + + ( 96 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 28 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + col2 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING NULL IS NULL
;

SELECT + cor0.col0 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 GROUP BY cor0.col0

;

SELECT - 21 * 63 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - + 8 FROM tab1 GROUP BY tab1.col1

;

SELECT - 60 * tab1.col0 FROM tab1 GROUP BY col0

;

SELECT ( cor0.col0 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 79 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 79 * 25 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - + 68 FROM tab2 GROUP BY tab2.col2

;

SELECT - CASE cor0.col2 WHEN - 5 - + cor0.col0 THEN + cor0.col2 ELSE NULL END + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT DISTINCT - 68 - - 95 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 82 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - 23 * 6 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL + ( cor0.col2 ) FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + + tab2.col2 * + col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col0 * cor0.col0 + col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 62 + 22 FROM tab2 GROUP BY col0

;

SELECT ALL cor0.col1 + 9 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 75 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL 38 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT + - 46 FROM tab1 GROUP BY tab1.col1

;

SELECT + - NULLIF ( tab0.col0, + 81 ) AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 48 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col2, col2

;

SELECT ALL 61 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 29 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 + 36 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL + + 97 FROM tab0 GROUP BY col0

;

SELECT DISTINCT 73 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT 47 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 14 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT ALL - ( 16 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 30 FROM tab2 GROUP BY tab2.col1

;

SELECT - 43 FROM tab1 GROUP BY col1

;

SELECT - 62 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT cor0.col1 + 20 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + + 15 FROM tab0 GROUP BY tab0.col0

;

SELECT - 80 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT ( - 65 ) * + col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - tab1.col2 + ( 94 ) AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT - - col0 + + tab1.col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT - 46 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 95 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT DISTINCT 33 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - + col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 46 FROM tab0 GROUP BY tab0.col0

;

SELECT 56 * - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT col0 * 22 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col2 * - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 36 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - 55 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col2 + + cor0.col1 * + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 56 + + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + 22 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 7 * + 31 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor1.col0 AS col2 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + + tab1.col0 - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 75 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT 4 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT - 24 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT + + 31 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + col2 * tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - tab1.col1 FROM tab1, tab0 AS cor0 GROUP BY tab1.col1

;

SELECT + 23 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + 30 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 61 + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 6 * + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - - COALESCE ( - 10, - 27 ) FROM tab1 GROUP BY tab1.col1

;

SELECT + 60 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 65 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL 18 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + col0 + cor0.col0 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL cor0.col1 * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + cor0.col2 + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT 23 * 67 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 49 * + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col1 + - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT 64 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT ALL ( cor0.col2 ) AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 53 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + 1 FROM tab2 cor0 GROUP BY col1

;

SELECT - 48 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - ( 62 ) AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT - 76 * 48 FROM tab2 GROUP BY tab2.col1

;

SELECT 62 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL NULLIF ( cor0.col0, - col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + CASE - 87 WHEN + cor0.col2 THEN cor0.col2 END FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT - + tab2.col0 + + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + tab1.col1 AS col1 FROM tab1, tab1 AS cor0 GROUP BY tab1.col1

;

SELECT - cor0.col2 * + 9 + + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, col0

;

SELECT ALL - - 30 FROM tab1 GROUP BY col1

;

SELECT DISTINCT ( - 97 ) + - cor0.col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col0

;

SELECT DISTINCT - cor0.col1 + - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 94 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 85 FROM tab2 GROUP BY col1

;

SELECT ALL - cor0.col1 - col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - + 5 AS col2 FROM tab2 GROUP BY col1

;

SELECT + 27 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT tab2.col1 + + tab2.col1 AS col2 FROM tab2 WHERE NOT ( NULL ) NOT BETWEEN ( NULL ) AND - tab2.col0 GROUP BY tab2.col1

;

SELECT ALL + cor0.col1 * 72 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 63 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + 43 * - 74 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 98 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL ( cor0.col1 ) * + cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - 24 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 2 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL + 58 FROM tab2 AS cor0 GROUP BY col1

;

SELECT cor0.col0 + + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - 63 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + col1 * - col1 + - tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 88 AS col2 FROM tab1 GROUP BY col1

;

SELECT DISTINCT 60 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 72 * + cor0.col2 + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL - 86 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col1 * cor0.col1 + - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL cor0.col2 AS col0 FROM tab1 cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT - 61 FROM tab0 GROUP BY tab0.col2

;

SELECT 8 * tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 47 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 29 * 22 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0, col0, cor0.col2

;

SELECT DISTINCT 81 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col1 + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 64 * tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 10 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 90 - + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - + 97 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 58 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - cor0.col0 * cor0.col0 + - 45 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab0.col1 + - tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 40 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - 56 + - 33 FROM tab0 GROUP BY tab0.col1

;

SELECT - 11 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 * 89 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT - - 96 FROM tab0 GROUP BY col0

;

SELECT - 13 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 21 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT cor0.col2 * + 82 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 32 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 76 FROM tab0 GROUP BY tab0.col1

;

SELECT + - 33 FROM tab1 GROUP BY tab1.col1

;

SELECT 8 * + 99 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col1 * cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col0 + + 85 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + - col0 FROM tab1 GROUP BY col0

;

SELECT - 91 AS col2 FROM tab2 GROUP BY col0

;

SELECT - 40 - + 34 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT - - 28 FROM tab0 GROUP BY tab0.col2

;

SELECT + 23 * - 4 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 32 + + 29 FROM tab1 GROUP BY tab1.col2

;

SELECT - tab0.col2 * + 97 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL col2 * - 98 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT 2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - tab1.col0 * 31 FROM tab1 GROUP BY tab1.col0

;

SELECT col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - cor0.col1 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 47 * - tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - tab2.col0 * - 11 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - 36 * - cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor0.col2

;

SELECT 44 AS col0 FROM tab2 GROUP BY col1

;

SELECT 24 AS col0 FROM tab0 GROUP BY col1

;

SELECT - + tab1.col2 - - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 91 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 27 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 25 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - cor0.col2 * - cor0.col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 * 98 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 38 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 60 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + + 39 * 0 AS col0 FROM tab2 GROUP BY col1

;

SELECT - NULLIF ( - cor0.col0, + cor0.col0 ) FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 AS col0 FROM tab2 cor0 CROSS JOIN tab1 GROUP BY cor0.col1

;

SELECT 49 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 93 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL - - col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT ALL - 35 * - cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL - 8 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + - 74 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 84 + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT + + ( tab1.col1 ) AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - col0 * 25 FROM tab0 GROUP BY col0

;

SELECT DISTINCT col1 - - cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - - 89 * 77 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 81 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT cor0.col0 - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT 33 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2, col0

;

SELECT DISTINCT - cor0.col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT + ( cor0.col0 ) * - cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 75 * NULLIF ( - col0, + 94 ) AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - cor1.col2 * - 80 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT - 56 FROM tab2 GROUP BY tab2.col2

;

SELECT + 47 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 11 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 8 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT 6 FROM tab2 GROUP BY col1

;

SELECT ALL - tab1.col1 + + col1 * - tab1.col1 FROM tab1 WHERE NOT ( tab1.col0 ) IS NOT NULL GROUP BY tab1.col1

;

SELECT + tab0.col2 * + tab0.col2 FROM tab0 GROUP BY col2

;

SELECT ALL col2 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 64 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col2 * + 74 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT + - 7 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 12 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + + col2 + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + cor0.col1 AS col0 FROM tab2, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 0 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + tab2.col0 AS col1 FROM tab2, tab0 AS cor0 GROUP BY tab2.col0

;

SELECT ALL col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col1 + cor0.col1 * + NULLIF ( + 96 + cor0.col1, cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + 50 AS col1 FROM tab2 GROUP BY col2

;

SELECT - + 70 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 83 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab1.col2 - 32 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + ( 11 ) FROM tab2 GROUP BY tab2.col1

;

SELECT - tab2.col0 + 50 AS col2 FROM tab2 GROUP BY col0

;

SELECT ALL cor0.col0 * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL 75 FROM tab1 cor0 GROUP BY col0

;

SELECT NULLIF ( cor0.col2, cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 85 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - NULLIF ( - 27, cor0.col1 * + cor0.col2 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - + 44 * - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 76 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + - 21 AS col0 FROM tab2 GROUP BY col1

;

SELECT 21 * cor0.col1 + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL - col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT 97 FROM tab1 GROUP BY col1

;

SELECT DISTINCT 66 FROM tab1 AS cor0 GROUP BY cor0.col2, col0, col0

;

SELECT DISTINCT 6 AS col1 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT - cor0.col2 + - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 76 + + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + 65 AS col0 FROM tab1 GROUP BY col1

;

SELECT cor0.col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 24 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 74 AS col2 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + 35 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT ( 71 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab2.col0 * 76 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT col0 * - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT col1 - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col1 - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + col1 * - tab0.col1 FROM tab0 WHERE NOT + col1 + + col2 IS NOT NULL GROUP BY tab0.col1

;

SELECT ALL col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 75 FROM tab0 GROUP BY tab0.col0

;

SELECT 58 FROM tab1 GROUP BY tab1.col0

;

SELECT 61 + + cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ( cor0.col2 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 90 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 33 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - 93 AS col0 FROM tab1 cor0 GROUP BY cor0.col1, col2

;

SELECT ALL 31 + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + tab2.col1 * - col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + cor0.col2 + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT DISTINCT - + 77 * - 36 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col0 * - 5 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - cor1.col2 + 1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor0.col1

;

SELECT 27 * + 55 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 79 - col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 23 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 42 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL + 42 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT cor0.col0 + - 46 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + tab2.col0 + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + + tab0.col2 * + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + cor0.col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col2 + + cor0.col2 AS col1 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT + 8 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 17 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT ALL - 96 * + tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 90 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ( - 72 ) FROM tab2 GROUP BY tab2.col0

;

SELECT - 3 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 98 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 66 FROM tab1 GROUP BY tab1.col0

;

SELECT 22 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 87 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 93 - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 59 - - 5 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + tab1.col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + 0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col2 * cor0.col2 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 92 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - - 72 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT 59 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT tab2.col0 FROM tab2, tab0 AS cor0 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - ( tab2.col0 ) AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + 32 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT cor0.col0 + + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - ( + 41 ) * - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 15 FROM tab1 GROUP BY col0

;

SELECT + cor0.col0 * - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 - - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - + 19 * tab2.col1 + - 39 FROM tab2 GROUP BY tab2.col1

;

SELECT + 40 * - cor0.col1 - - 89 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT cor0.col1 * cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 25 FROM tab2 GROUP BY col1

;

SELECT cor0.col1 + 76 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1 HAVING NULL IS NULL
;

SELECT DISTINCT - 67 AS col0 FROM tab2 GROUP BY col1

;

SELECT ALL - 96 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT 15 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col1 * - cor0.col1 + col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 + 19 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 32 * - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 25 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 36 FROM tab2 GROUP BY tab2.col0

;

SELECT + COALESCE ( tab0.col2, - tab0.col2 * tab0.col2 - + 9 ) AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT 17 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT 35 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 66 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT cor0.col2 + - cor0.col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 67 + 85 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 33 AS col0 FROM tab1 cor0 GROUP BY col2

;

SELECT - - tab0.col0 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 67 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 32 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 76 + - col0 * col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col0

;

SELECT DISTINCT + 75 + - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - + COALESCE ( 91, - tab2.col2 ) AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col0 + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col2 - - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + col0 - tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 32 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 83 FROM tab0 GROUP BY col1

;

SELECT ALL col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT cor0.col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - 17 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 95 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 68 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + col1 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT tab1.col1 + - col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ( 82 ) FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT + 86 + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 52 FROM tab0 GROUP BY tab0.col1

;

SELECT - 34 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT cor0.col0 AS col2 FROM tab1, tab0 cor0 GROUP BY cor0.col0

;

SELECT tab0.col0 FROM tab0, tab2 AS cor0 GROUP BY tab0.col0

;

SELECT ALL - cor0.col1 * col1 - cor0.col1 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT + 71 FROM tab2 AS cor0 GROUP BY col2

;

SELECT cor0.col0 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT ALL cor0.col0 * - 39 - + col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + 34 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - + tab0.col2 * col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 62 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 54 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - + tab0.col0 + 95 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - - col1 * + 76 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + NULLIF ( 16, + cor0.col2 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 - 24 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT tab1.col0 * 48 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 61 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 * - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT ALL 93 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 82 FROM tab1, tab2 AS cor0 GROUP BY tab1.col0

;

SELECT cor0.col0 * 63 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL cor1.col2 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2

;

SELECT + 35 - - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + cor0.col1 + + 13 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, col2

;

SELECT ALL cor0.col1 - - col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT cor0.col1 + - 27 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + tab0.col0 - 31 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col1 AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + ( tab1.col2 ) AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT 71 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + col1 * + 85 + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 72 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + cor0.col2 * 90 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + tab0.col2 * - 78 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING ( NULL ) IS NOT NULL
;

SELECT ALL ( 1 ) FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT tab2.col2 * 35 + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + - tab0.col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT ALL + - tab0.col2 - 2 * 70 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 8 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + 41 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 3 * + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT tab0.col1 + tab0.col1 * tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + 97 * 7 FROM tab2, tab1 AS cor0 GROUP BY tab2.col1

;

SELECT DISTINCT - 69 AS col2 FROM tab2 GROUP BY col0

;

SELECT - ( 62 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 30 + - col0 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 79 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - - 17 AS col0 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - + tab0.col2 * tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - ( tab2.col2 ) FROM tab2 GROUP BY col2

;

SELECT - 36 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT 24 FROM tab0 AS cor0 GROUP BY cor0.col1, col1, cor0.col1

;

SELECT + - 75 * + 86 FROM tab1 GROUP BY tab1.col2

;

SELECT + ( 83 ) AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - 71 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 48 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 85 FROM tab0 GROUP BY tab0.col2

;

SELECT - 4 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 29 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col0 + + cor0.col0 * + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT cor0.col1 * + cor0.col1 AS col1 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL - 75 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - COALESCE ( + CASE + cor0.col2 WHEN + cor0.col1 + + cor0.col1 THEN NULL WHEN col1 + col0 THEN + 48 ELSE + ( 40 ) END, cor0.col1 + 91 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2, cor0.col1

;

SELECT + ( 84 ) * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 67 FROM tab1, tab0 AS cor0 GROUP BY tab1.col2

;

SELECT + 64 FROM tab1 GROUP BY tab1.col1

;

SELECT tab0.col2 * 34 FROM tab0 GROUP BY col2

;

SELECT + 10 FROM tab0 GROUP BY col0

;

SELECT 69 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 17 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 24 - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 68 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL cor0.col1 + ( - 60 - - cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - - tab0.col2 * col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 50 + cor0.col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col0, cor0.col2

;

SELECT tab2.col0 + - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + tab2.col2 * tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + cor0.col1 * 22 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + - col1 * cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 44 AS col2 FROM tab0 GROUP BY col1

;

SELECT ALL - - 50 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - tab0.col2 + tab0.col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT 51 * - 3 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + 26 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col1 * 27 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + 32 + - 72 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + - 31 + tab0.col1 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 53 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + tab0.col2 + - tab0.col2 FROM tab0 GROUP BY tab0.col2 HAVING NOT NULL NOT BETWEEN NULL AND ( NULL )
;

SELECT - cor0.col0 * cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - - 86 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col1 + + 2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 80 * - cor0.col0 + - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 91 AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT + 74 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT - - 31 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + col0 * - 49 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 94 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT ( 87 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 * - 24 + - cor0.col0 * ( col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 11 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - cor0.col0 + 72 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT 38 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + 75 AS col2 FROM tab2 cor0 GROUP BY col0, cor0.col1

;

SELECT 63 * + col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 24 + - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 18 * - 90 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + 26 * cor0.col1 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - NULLIF ( - cor0.col2, cor0.col0 ) AS col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col0, cor0.col2

;

SELECT DISTINCT + col2 + - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + - 46 FROM tab1 GROUP BY tab1.col2

;

SELECT - tab2.col0 + + 49 FROM tab2 GROUP BY tab2.col0

;

SELECT + 19 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - - 52 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + + ( - col2 ) FROM tab0 GROUP BY tab0.col2

;

SELECT + - 88 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 31 + + cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col1

;

SELECT ALL + + 56 + 9 FROM tab1 GROUP BY col2

;

SELECT tab2.col1 * 94 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL cor1.col0 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT cor1.col1 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor1.col1

;

SELECT - tab1.col1 * + 90 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + tab2.col1 * tab2.col1 + col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 57 FROM tab2 AS cor0 GROUP BY col0, cor0.col1, cor0.col1

;

SELECT ALL ( + 73 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 + - 56 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT cor0.col1 * + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - - col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT - 68 AS col0 FROM tab2 GROUP BY col1

;

SELECT 76 - + 92 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 28 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 * cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 55 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 63 + col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT - 65 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - - tab0.col2 + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + + 69 - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 24 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + tab1.col2 * - col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - + ( - 11 ) AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col1 AS col2 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT + 51 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 21 FROM tab2 GROUP BY tab2.col2

;

SELECT + ( + tab2.col1 ) + + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - 3 AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab1.col2 * 99 FROM tab1 GROUP BY col2

;

SELECT + + 36 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - 20 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + tab2.col0 * + tab2.col0 FROM tab2 GROUP BY tab2.col0 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - cor0.col1 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 57 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT - 39 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + col0 + - tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 57 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 37 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 68 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + 33 * + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + - 22 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 95 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 + + col2 * + col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col2

;

SELECT ALL - 12 AS col2 FROM tab1 GROUP BY col1

;

SELECT + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col1, col0

;

SELECT - 90 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 20 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 70 + + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + - 5 FROM tab2 GROUP BY tab2.col2

;

SELECT + - tab1.col2 * - tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 22 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - + tab2.col0 + + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 84 * + 85 FROM tab2 GROUP BY col0

;

SELECT DISTINCT ( 7 ) AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT - + 20 + 6 FROM tab1 GROUP BY tab1.col1

;

SELECT + 94 * tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 61 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 8 AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 60 FROM tab0 GROUP BY tab0.col0

;

SELECT 51 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - cor1.col2 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT ALL - + tab1.col1 * - col1 + + 44 FROM tab1 GROUP BY col1

;

SELECT 89 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ( 29 ) AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col1

;

SELECT - tab1.col0 + 93 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT 34 FROM tab2 GROUP BY col1

;

SELECT - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT DISTINCT - 55 AS col0 FROM tab1 GROUP BY col0

;

SELECT - tab0.col0 + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT 5 * 55 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - - 18 + tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - 49 AS col2 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT + tab2.col0 - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + cor0.col1 + - cor0.col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, col0

;

SELECT ALL + cor0.col0 + ( + col0 ) AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + cor0.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 GROUP BY cor0.col2

;

SELECT + 25 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 67 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - cor1.col0 * 35 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT 17 FROM tab2 GROUP BY col0

;

SELECT 6 + + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2, cor0.col1

;

SELECT 27 * + cor0.col0 - 97 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 8 AS col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT ALL + 67 + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT DISTINCT + 74 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - 38 FROM tab2 GROUP BY tab2.col1

;

SELECT + - tab2.col2 * - 43 + - 10 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 41 + cor0.col2 FROM tab0 cor0 GROUP BY col1, cor0.col1, cor0.col2

;

SELECT - 73 FROM tab0 GROUP BY col1

;

SELECT 70 * + col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT + 83 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - 3 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - + ( 59 ) * + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT 79 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - ( - tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + cor0.col2 * - 51 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col2 * - 11 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT + 78 AS col1 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT + col1 + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + 92 FROM tab1 AS cor0 GROUP BY col0

;

SELECT tab2.col1 FROM tab2, tab0 AS cor0 GROUP BY tab2.col1

;

SELECT cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT - 43 + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 18 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 * 91 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + 97 FROM tab0 GROUP BY col1

;

SELECT - col0 + - 29 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 34 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT + - 99 FROM tab1 GROUP BY tab1.col2

;

SELECT - col2 * + 89 + 87 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT tab2.col0 * tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + + 98 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - 24 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 81 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col1 + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT - + 16 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 14 + tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT - ( 51 ) + 86 FROM tab1 GROUP BY tab1.col0

;

SELECT + 82 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT ( - tab0.col0 ) AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + tab1.col1 * tab1.col1 + + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 30 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - cor0.col0 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL - tab0.col1 * col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - + tab1.col0 * + 11 FROM tab1 GROUP BY col0

;

SELECT DISTINCT - 8 - + tab2.col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT - cor0.col1 * 70 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - col0 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - 0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 36 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT tab0.col2 + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - tab1.col2 AS col2 FROM tab1 WHERE NOT ( NULL ) NOT IN ( - tab1.col2 * - tab1.col0 ) GROUP BY tab1.col2

;

SELECT cor0.col0 * 2 + - cor0.col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col0, cor0.col0

;

SELECT ALL - COALESCE ( tab0.col0, - tab0.col0, 35 ) * + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 4 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 70 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col2 + col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col0 + 37 * - col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING NOT ( + col1 ) IS NULL
;

SELECT 44 * tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + ( 37 ) FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT tab1.col1 + - tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - tab2.col1 * - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - tab1.col2 * 78 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 81 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 56 - + cor0.col1 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT DISTINCT - ( - 65 ) + 21 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 3 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT + 38 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col1 + col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 48 * - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - + 9 FROM tab0 GROUP BY tab0.col2

;

SELECT - tab2.col2 * 54 + 27 * col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 82 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 - + 74 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - + tab2.col0 + tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col0 * ( cor0.col0 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 * - 86 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 85 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 65 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT col0 * 92 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 16 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - - 75 FROM tab1 GROUP BY tab1.col1

;

SELECT + 72 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 73 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col2 + - 88 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 86 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + + tab2.col2 + 95 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - tab2.col2 * 56 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 26 - + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 57 + 16 * tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 63 * - 71 FROM tab0 GROUP BY tab0.col2

;

SELECT + - 36 * - 87 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT NULLIF ( cor0.col0, 44 + cor0.col0 / - cor0.col1 ) + + cor0.col0 * col0 AS col2 FROM tab2 cor0 GROUP BY col1, cor0.col0

;

SELECT - 20 * + 40 AS col0 FROM tab1 cor0 GROUP BY col2

;

SELECT DISTINCT - tab0.col2 + - ( + tab0.col2 ) FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 51 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ( 99 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 52 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + NULLIF ( tab1.col0, tab1.col0 - 79 ) * - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + - col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 29 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + cor0.col1 * cor0.col1 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT ALL col1 * + 36 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col2 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - col2 * 87 FROM tab0 GROUP BY tab0.col2

;

SELECT - col1 + 52 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 * col0 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT + + col2 * - 1 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + 45 * col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 9 + cor0.col2 * - 48 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 FROM tab0 AS cor0 GROUP BY col2, cor0.col1, cor0.col0

;

SELECT cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT - 7 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab2.col2 - - 93 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 58 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor1.col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT + cor0.col1 + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col0, cor0.col2

;

SELECT - + col1 * tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 31 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT + - tab1.col1 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 88 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 36 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT col0 + col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 45 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT 64 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab1.col2 - - 37 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 7 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL tab1.col0 - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT tab2.col0 + + tab2.col0 FROM tab2 GROUP BY col0

;

SELECT ALL 69 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT - 92 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - + tab2.col2 + + 35 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 61 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + ( + cor0.col1 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 43 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT - tab0.col0 - 21 FROM tab0 GROUP BY tab0.col0

;

SELECT 1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + - 19 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col2 - + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col1 + + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL tab0.col0 + tab0.col0 * + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT col0 - cor0.col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT 41 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - col2 * tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 17 * + 65 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 86 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT tab2.col1 - - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 28 * 33 FROM tab0 GROUP BY tab0.col2

;

SELECT 55 FROM tab2 GROUP BY tab2.col2

;

SELECT - + 46 + tab0.col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + - tab1.col0 + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + + 56 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 33 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + cor0.col1 * + 47 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + - 5 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - col2 * tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - 94 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col2

;

SELECT ALL + 16 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 72 - - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - ( 57 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + + 92 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - + col1 FROM tab1 GROUP BY col1

;

SELECT cor1.col1 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT + + 45 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + cor1.col2 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1, cor1.col2

;

SELECT ALL + 8 + 57 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col2 + - 75 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - - 46 + tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + + tab0.col1 * tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor1.col2, cor1.col1

;

SELECT + 69 AS col1 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT 68 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT 72 + cor0.col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 60 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - - tab1.col2 * - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT 3 - + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col2, col0

;

SELECT + col1 * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 42 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 97 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col0 * cor0.col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT + 26 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + 83 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 89 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + - 34 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 39 AS col0 FROM tab0 GROUP BY col1

;

SELECT - + 25 FROM tab0 GROUP BY tab0.col1

;

SELECT + tab1.col1 + tab1.col1 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col0 - 75 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor1.col0 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0, cor0.col0

;

SELECT DISTINCT tab1.col2 + 74 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 91 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT tab2.col0 * - 73 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - NULLIF ( col1, cor0.col1 - 88 ) + + 75 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - ( + 66 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col0 AS col1 FROM tab0 cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT + tab1.col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL < NULL
;

SELECT cor0.col0 + cor0.col1 AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - ( col2 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT tab1.col0 * - 83 AS col2 FROM tab1 GROUP BY col0

;

SELECT col2 + col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - ( + 9 ) FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 51 + 16 * cor0.col0 FROM tab0 cor0 GROUP BY cor0.col2, col0

;

SELECT - 4 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + ( + col2 ) FROM tab0 GROUP BY col2

;

SELECT 6 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL 42 AS col1 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + col2 + tab2.col2 * + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT DISTINCT 5 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 62 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL - 13 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col1 - + col1 * - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - 63 * 73 FROM tab1 GROUP BY tab1.col1

;

SELECT + + NULLIF ( 25, tab0.col0 ) AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 96 * cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 38 * + 35 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col0 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + - 17 FROM tab0 GROUP BY tab0.col2

;

SELECT + 72 FROM tab2 GROUP BY tab2.col1

;

SELECT + 57 FROM tab0 GROUP BY tab0.col2

;

SELECT + cor0.col0 - col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 25 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 10 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - tab2.col1 * + col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + tab1.col2 + - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + - 92 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + tab2.col0 + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT tab0.col1 - tab0.col1 FROM tab0 WHERE NOT + tab0.col2 IS NOT NULL GROUP BY col1

;

SELECT 45 * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 31 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor0.col2

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab0 cor0 GROUP BY col2, col2

;

SELECT + 24 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT ( cor0.col2 ) FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL 55 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - + 41 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - 14 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT ( - cor0.col2 ) AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - - 31 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + cor0.col2 * - cor0.col1 + cor0.col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL cor0.col1 - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + tab2.col1 + tab2.col1 FROM tab2 WHERE NOT NULL IS NOT NULL GROUP BY tab2.col1

;

SELECT cor0.col2 * cor0.col0 + + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT ( + 12 ) + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 28 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL 9 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + cor0.col1 + + 93 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + - col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 52 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 5 - + 87 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT ( 98 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT cor0.col2 + - cor0.col2 * - 43 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL cor0.col1 AS col0 FROM tab0 cor0 GROUP BY cor0.col1 HAVING NULL IS NOT NULL
;

SELECT ALL + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT + ( + cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col0 * ( + col0 * col2 ) FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - tab1.col2 + ( tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 55 FROM tab2 GROUP BY tab2.col2

;

SELECT + 17 AS col0 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + 49 * - cor0.col2 + 67 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + tab1.col0 * + col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + + ( + tab2.col1 ) - tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 42 FROM tab0 cor0 GROUP BY col1

;

SELECT + 35 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT cor0.col2 * - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT col1 + 98 FROM tab0 GROUP BY col1

;

SELECT 93 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 53 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 70 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 75 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + - col2 * - tab1.col2 - - 67 FROM tab1 GROUP BY tab1.col2

;

SELECT + 9 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 50 FROM tab2 GROUP BY tab2.col1

;

SELECT - tab1.col0 - col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + 67 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 55 * 34 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 74 * 82 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 44 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT - 9 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + + 4 FROM tab0 GROUP BY col1

;

SELECT 42 + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT col1 + 8 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 79 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL - - 54 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 63 FROM tab1 GROUP BY col0

;

SELECT + + 85 * - 4 - tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 36 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 20 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 38 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT cor0.col0 * cor0.col1 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT ALL + 43 * tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + cor0.col1 * cor0.col1 + - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor1.col2 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + 79 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 37 + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT 96 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + - 96 FROM tab1 GROUP BY col1

;

SELECT + 19 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - 98 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT + 99 - + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 17 * - tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT 99 + + tab1.col2 * 33 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 18 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 6 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + ( + tab1.col0 ) * - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 88 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT 21 FROM tab0 GROUP BY tab0.col0

;

SELECT - + tab1.col0 + + tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 28 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 73 AS col1 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - 76 FROM tab1 GROUP BY tab1.col1

;

SELECT - + col0 + 4 FROM tab0 GROUP BY col0

;

SELECT - CASE - tab1.col1 WHEN + tab1.col1 THEN + 40 + 29 END FROM tab1 GROUP BY tab1.col1

;

SELECT + 71 + cor0.col1 * + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col1, cor0.col1

;

SELECT + 0 AS col2 FROM tab1, tab1 AS cor0 GROUP BY tab1.col2

;

SELECT 23 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 34 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 16 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 49 AS col1 FROM tab2 GROUP BY col2

;

SELECT DISTINCT 29 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 88 * tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 5 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 47 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + - tab1.col2 * 89 + col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + - tab0.col0 - - col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 19 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 67 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 31 FROM tab2 GROUP BY tab2.col1

;

SELECT + 39 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT + 36 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + + 99 * + col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 38 FROM tab1 GROUP BY col2

;

SELECT ALL tab2.col0 + col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT ALL - 27 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 - + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + 40 FROM tab1 GROUP BY col1

;

SELECT + cor0.col2 * 20 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT 23 - + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - - tab1.col2 - + tab1.col2 * - col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + - 57 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 83 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + NULLIF ( 46, tab2.col0 + tab2.col0 * 82 ) FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT 85 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + 82 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + - tab0.col2 * - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 23 + - tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT 36 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT cor0.col1 + - cor0.col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col2, cor0.col2

;

SELECT ALL - 24 * col0 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT 57 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + tab0.col0 - col0 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - cor0.col0 AS col2 FROM tab1 cor0 GROUP BY col1, cor0.col0

;

SELECT tab0.col1 + ( tab0.col1 - tab0.col1 ) FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + tab2.col1 * 32 FROM tab2 GROUP BY tab2.col1

;

SELECT 96 + - cor0.col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col2, cor0.col1

;

SELECT DISTINCT + cor0.col2 - 1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 34 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 78 - 53 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 * + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 36 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 33 FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col1 * + cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - 23 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 67 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 39 * cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT + 48 * 1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 43 FROM tab0 GROUP BY tab0.col2

;

SELECT + + 76 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ( tab2.col1 ) * tab2.col1 FROM tab2 GROUP BY col1

;

SELECT - 42 * - col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 26 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col1 * - 94 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - tab0.col2 + - 28 * - col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col0 * + 82 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT COALESCE ( 99, + tab2.col0, 84 ) * tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - 33 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 31 * + 31 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 26 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 33 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 77 * + 46 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 64 * tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 88 + 15 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT tab0.col2 * 52 AS col0 FROM tab0 GROUP BY col2

;

SELECT + + 11 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - 63 * + 29 FROM tab1, tab1 AS cor0 GROUP BY tab1.col0

;

SELECT cor0.col0 * 70 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 * - cor0.col2 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - 47 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col2 * + 67 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT DISTINCT - tab1.col2 FROM tab1 WHERE NOT NULL IS NULL GROUP BY tab1.col2

;

SELECT + 36 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + + 36 * tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 96 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 10 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, col1, cor0.col0

;

SELECT + 18 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT DISTINCT - - col1 FROM tab1 GROUP BY col1

;

SELECT ALL 49 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT tab2.col2 + + tab2.col2 * tab2.col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT DISTINCT cor0.col2 + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col2 * 38 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col0 + 81 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + - 71 * + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 5 + + col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT - cor0.col1 + + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 97 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 10 + + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT tab1.col1 + - tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - 93 * tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 43 AS col1 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT + 36 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL tab1.col0 + - tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - + 6 FROM tab1 GROUP BY tab1.col0

;

SELECT + 51 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 67 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - tab2.col0 * + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT 22 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 5 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 60 + 77 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 62 AS col0 FROM tab0 GROUP BY col0

;

SELECT ALL - 56 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - 70 * cor0.col1 - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 39 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT - 6 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + cor1.col0 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0, cor0.col1, cor0.col1

;

SELECT 13 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - 2 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + tab0.col0 - tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT col0 * 30 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ( 92 ) - 31 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + 91 FROM tab2 GROUP BY col0

;

SELECT DISTINCT 79 AS col1 FROM tab1 AS cor0 GROUP BY col0, cor0.col0

;

SELECT DISTINCT - tab0.col2 + + col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT + + 34 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + tab1.col0 * + col0 FROM tab1 GROUP BY tab1.col0 HAVING ( NULL ) IS NULL
;

SELECT + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1 HAVING NULL IS NULL
;

SELECT DISTINCT cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ( + tab0.col2 ) FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT 89 * + tab2.col1 + 16 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 83 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL + 9 FROM tab2 GROUP BY tab2.col0

;

SELECT 67 + 88 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT ALL 57 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 42 * + col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - tab0.col2 * tab0.col2 + - 65 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - 0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 0 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 48 - + tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - + ( tab1.col2 ) AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 25 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + col1 * ( + tab2.col1 ) + + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - - col2 + - 44 AS col1 FROM tab2 GROUP BY col2

;

SELECT cor0.col0 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT DISTINCT 89 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ( 50 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 33 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 48 FROM tab1, tab0 cor0 GROUP BY tab1.col2

;

SELECT ALL - 29 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - cor0.col0 - + 6 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 17 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col2 + - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col0 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT - - 19 FROM tab2 GROUP BY tab2.col0

;

SELECT 90 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 44 + col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 10 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - cor0.col2 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 46 + cor0.col1 * cor0.col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 26 + cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col1, col0

;

SELECT cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL + cor0.col0 * col1 - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col0 * 79 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 5 * 2 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - 4 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + + 65 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 50 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 51 * - col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 + + 86 * cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 19 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 FROM tab2 AS cor0 CROSS JOIN tab0 WHERE NOT - tab0.col2 * - tab0.col2 IS NOT NULL GROUP BY cor0.col1

;

SELECT ALL cor0.col0 + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, col2

;

SELECT ALL - 13 + - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT + cor0.col0 + 53 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 69 FROM tab0 GROUP BY col0

;

SELECT + tab2.col0 / - col0 FROM tab2 WHERE ( NULL ) > ( NULL ) GROUP BY col0

;

SELECT ALL + tab0.col0 + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 12 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - 63 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT 65 + cor0.col2 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 82 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT + NULLIF ( - tab0.col0, tab0.col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 19 FROM tab1 GROUP BY tab1.col0

;

SELECT - - ( tab0.col1 ) FROM tab0 GROUP BY col1

;

SELECT - 36 + 40 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - 30 AS col2 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + 72 * - 98 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 46 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + col0 * cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + 90 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 68 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT 44 + + 82 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - - 3 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col1 + + cor0.col2 * 33 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 6 - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 29 * col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 72 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 16 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 34 * + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 79 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT - 65 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - + 84 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT ( 57 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 0 * - 84 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col1 * cor0.col1 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + + 70 * tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT 59 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT col2 * NULLIF ( - cor0.col0, - cor0.col0 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col0 + - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 85 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col0

;

SELECT + 25 + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 67 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - + 42 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 68 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - ( + cor0.col0 ) + + cor0.col0 * - col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col2 FROM tab2 cor0 GROUP BY col2, cor0.col0

;

SELECT ALL 18 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1, cor0.col0

;

SELECT - col2 FROM tab1 WHERE NULL IS NOT NULL GROUP BY col2

;

SELECT DISTINCT 97 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab2.col1 + + col1 * 88 FROM tab2 GROUP BY col1

;

SELECT DISTINCT col2 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + + col2 + + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - + 0 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + - tab2.col0 + + tab2.col0 * - 59 FROM tab2 GROUP BY tab2.col0

;

SELECT - 88 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col2 * 15 + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - - 93 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 64 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT + cor0.col1 * - cor0.col1 FROM tab1 cor0 GROUP BY col1, cor0.col0

;

SELECT col2 * - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - + 82 FROM tab2 GROUP BY col0

;

SELECT - 39 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL tab0.col1 * tab0.col1 - + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col1 + COALESCE ( ( col1 ), - col0 ) * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + - 60 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 58 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col2 AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL col1 * - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT cor0.col0 - + 12 FROM tab0 AS cor0 GROUP BY col2, cor0.col0, cor0.col1

;

SELECT DISTINCT - 67 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 5 - + cor0.col0 * + 65 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL + 13 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - + 32 * - col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT 78 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 80 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - 28 AS col0 FROM tab1, tab2 AS cor0 GROUP BY tab1.col2

;

SELECT + 13 FROM tab1 GROUP BY col0

;

SELECT 74 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 69 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + + 12 AS col2 FROM tab1 GROUP BY col0

;

SELECT 79 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 79 FROM tab0 cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col2

;

SELECT - - 20 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - - CASE ( tab2.col0 ) WHEN tab2.col0 THEN tab2.col0 END * - 47 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 20 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - ( 51 ) AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 31 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL NULLIF ( + 18, + 42 ) * col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + - tab0.col2 * - 36 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT DISTINCT 3 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2 HAVING NOT NULL IS NULL
;

SELECT 57 + 21 FROM tab0 GROUP BY col2

;

SELECT - tab1.col2 + + tab1.col2 * tab1.col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + 67 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + 48 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - 54 + - tab2.col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT + + tab0.col2 * col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 29 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + cor0.col1 - - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - 79 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 62 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 84 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT - col2 + cor0.col2 * 22 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 42 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - - tab2.col2 - 43 FROM tab2 GROUP BY tab2.col2

;

SELECT 68 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 41 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 48 * 80 FROM tab2 GROUP BY tab2.col1

;

SELECT tab2.col0 * - 35 + - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT 42 + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL ( - cor0.col1 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT + tab0.col1 FROM tab0 WHERE tab0.col1 + - col2 IS NOT NULL GROUP BY col1

;

SELECT DISTINCT 24 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 89 * cor0.col1 FROM tab1 cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT - 37 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL + cor0.col1 + 53 * - 15 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT - - col2 * col2 + tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col0 + 12 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - cor0.col2 * + 90 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0 HAVING NULL <= NULL
;

SELECT ALL - tab1.col0 * - tab1.col0 + + tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col2 + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 54 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab1.col0 * + tab1.col0 + - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT - 51 AS col0 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - NULLIF ( - col0, 41 ) AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT + + 94 FROM tab1 GROUP BY tab1.col0

;

SELECT - tab2.col1 * 68 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT 39 * - 62 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, col0

;

SELECT cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT ( + cor0.col0 ) + + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 2 - cor0.col1 * col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT DISTINCT - - 75 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - cor0.col2 + - col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + cor0.col1 * + 22 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + 89 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL + 14 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 64 * 33 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - 2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 95 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ( cor0.col1 ) * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT 86 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 20 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col2 * - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT - + 16 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + cor0.col2 * col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 28 AS col0 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - 41 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 79 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 + 32 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 95 * col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 57 FROM tab0 GROUP BY col2

;

SELECT + 27 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + + 72 AS col1 FROM tab1 GROUP BY col0

;

SELECT + cor0.col2 - + cor0.col1 * + cor0.col1 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 26 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor1.col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT ALL + 43 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - - 16 FROM tab0 GROUP BY tab0.col0

;

SELECT col1 + - 16 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT tab2.col1 AS col0 FROM tab2 WHERE NOT tab2.col2 NOT IN ( + tab2.col2 ) GROUP BY tab2.col1

;

SELECT + + 95 AS col0 FROM tab2, tab1 AS cor0 GROUP BY tab2.col1

;

SELECT DISTINCT - - cor0.col1 + - 65 AS col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col1 + 98 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - - 16 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + col1 * col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 6 + col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 83 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL ( 35 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 75 FROM tab2 GROUP BY col2

;

SELECT ALL cor0.col0 * - 94 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT col0 * - 89 + col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - + 93 FROM tab1 GROUP BY col2

;

SELECT + + 77 + + 36 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 49 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 94 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - col0 * 86 FROM tab2 GROUP BY tab2.col0

;

SELECT tab1.col1 + - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 59 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT ( NULL ) > + col1
;

SELECT col0 FROM tab0 WHERE NOT NULL IS NULL GROUP BY col0

;

SELECT DISTINCT 8 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT 58 AS col1 FROM tab1 cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT col1 FROM tab0 cor0 GROUP BY col1

;

SELECT + 29 + + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT 34 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + - 79 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col1 * + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NULL
;

SELECT DISTINCT tab2.col2 + + tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 30 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 27 FROM tab0 GROUP BY col2

;

SELECT 88 + 75 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT 69 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT 76 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - col1 + - 10 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 56 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + NULLIF ( cor0.col0, + col2 ) * - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + 10 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 6 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 93 + 62 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT + cor0.col1 + - col1 * + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 21 + - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab1.col1 * + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - + tab1.col1 FROM tab1, tab2 AS cor0 GROUP BY tab1.col1

;

SELECT cor0.col1 * + 37 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL 79 + - cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT tab1.col2 * + col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 8 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - 83 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - + 72 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 42 - + 26 AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT ALL cor0.col0 AS col1 FROM tab1 cor0 GROUP BY col1, cor0.col0

;

SELECT ALL + tab2.col2 * 99 FROM tab2 GROUP BY col2

;

SELECT + tab2.col1 * 6 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0, col0

;

SELECT cor0.col1 AS col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - - tab1.col2 * - ( + 26 ) FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col2 + - cor0.col2 * cor0.col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + 51 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab0.col2 + 72 FROM tab0 GROUP BY col2

;

SELECT 2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT 75 + - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT + col1 * - col1 <> tab1.col1
;

SELECT + 86 * cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 56 * - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 28 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL cor0.col1 + + 36 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - 53 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col2 - 52 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 88 * col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 + 19 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 62 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL + ( cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL 32 * cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + + 53 FROM tab2 GROUP BY tab2.col0

;

SELECT 42 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - 31 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 38 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + tab1.col1 * tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - tab2.col0 + - col0 FROM tab2 GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT + tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING - col2 IS NOT NULL
;

SELECT ALL cor0.col1 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT col2 FROM tab1 cor0 GROUP BY col1, cor0.col2

;

SELECT ALL - 42 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + 78 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + 38 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 16 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 62 - + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 * 14 FROM tab2 AS cor0 GROUP BY col1

;

SELECT cor0.col1 * cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 93 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - 27 FROM tab1 GROUP BY tab1.col1

;

SELECT + + 28 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col1 + 98 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col2

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT ALL cor0.col1 * + col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 45 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 * 60 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 66 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col1 * cor0.col1 AS col1 FROM tab2 cor0 GROUP BY col1

;

SELECT + 61 * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + ( cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 76 - col0 AS col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT 64 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL - cor0.col2 * - 77 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col2, cor0.col1

;

SELECT DISTINCT + ( col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - - 74 + + cor0.col0 AS col2 FROM tab1, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col2 + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, col2

;

SELECT - - 68 FROM tab1 GROUP BY col0

;

SELECT col2 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT ALL cor0.col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT + 32 * 26 FROM tab1 GROUP BY col1

;

SELECT DISTINCT 14 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT 48 * 96 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT ALL tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1 HAVING ( NULL ) IS NULL OR NULL IS NULL
;

SELECT ALL ( + CASE + 28 WHEN - tab2.col1 * col1 THEN + tab2.col1 WHEN - tab2.col1 THEN NULL END ) FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 23 + + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 98 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - cor0.col1 - - 27 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 30 + + tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 73 * cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT 19 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + ( 12 ) FROM tab0 GROUP BY tab0.col1

;

SELECT + 99 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - 40 * 79 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + cor0.col1 * 34 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + tab2.col0 + + tab2.col0 * - col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + cor0.col0 * + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT COALESCE ( - 9, + col0 ) * ( + 73 ) AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL + tab1.col0 * + 10 FROM tab1 GROUP BY tab1.col0

;

SELECT - + tab1.col1 + - col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL ( + 44 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 38 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + cor0.col2 * + cor0.col2 - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT DISTINCT - col1 * cor0.col1 + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 76 + cor0.col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 69 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 6 FROM tab0 cor0 GROUP BY col1, cor0.col2

;

SELECT + cor0.col2 * - NULLIF ( cor0.col2, + 89 ) FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT + 35 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 * - col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 45 AS col2 FROM tab2 cor0 GROUP BY col1, cor0.col2

;

SELECT + 28 * + 92 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 80 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 + - cor0.col1 * 34 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + tab0.col1 + - 11 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - col2 * col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT ALL 2 + + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col0 * 6 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + - ( tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col0 * cor0.col0 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT COALESCE ( tab0.col0, + tab0.col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT - ( - 36 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT 86 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL cor0.col1 + + col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 90 FROM tab1 GROUP BY tab1.col2

;

SELECT + 85 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 10 FROM tab2 GROUP BY col1

;

SELECT ALL + - 64 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - - ( - tab2.col2 ) * + tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + 36 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 99 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 7 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL 25 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 99 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - ( 84 ) * + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 + - cor1.col2 AS col0 FROM tab0 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor0.col2, cor0.col0

;

SELECT DISTINCT - col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT cor0.col2 * ( - cor0.col1 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - ( + 39 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 + - col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 85 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT 91 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col1 * cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL COALESCE ( + cor0.col1, + col1 ) FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 1 + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT - 15 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - 34 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - 16 * + 30 FROM tab2 GROUP BY tab2.col2

;

SELECT - 80 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 46 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - 65 + col0 * - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col0 * 7 AS col1 FROM tab2 cor0 GROUP BY col1, cor0.col0

;

SELECT ALL - col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 * 14 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT - 20 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 43 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL 25 * tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - 16 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 4 FROM tab1 GROUP BY col2

;

SELECT ALL + 14 + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + tab0.col0 * 96 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 86 FROM tab0 GROUP BY col0

;

SELECT ALL - cor0.col1 * col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 85 + - 57 FROM tab2 GROUP BY tab2.col2

;

SELECT + tab0.col2 - + ( 33 ) AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT - 17 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 92 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 28 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 34 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + tab2.col0 / tab2.col0 AS col2 FROM tab2 GROUP BY col0 HAVING NOT ( NULL ) BETWEEN col0 AND NULL
;

SELECT + tab0.col2 FROM tab0 WHERE NULL = ( NULL ) GROUP BY tab0.col2

;

SELECT - 74 FROM tab1 GROUP BY tab1.col1

;

SELECT - 35 + col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL ( + 93 ) AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT + 69 + + 97 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 41 * - tab2.col0 + 61 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col0, cor0.col0

;

SELECT DISTINCT 88 FROM tab2 GROUP BY tab2.col1

;

SELECT - + 87 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 13 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + - 35 FROM tab2 GROUP BY col1

;

SELECT 63 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 46 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 * - cor0.col1 - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT + 11 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL + + 18 - tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT col2 + - 59 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - ( - 83 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT + 12 + col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 51 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 74 FROM tab1 GROUP BY col1

;

SELECT cor0.col2 - - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT col1 * + tab1.col1 FROM tab1 GROUP BY col1

;

SELECT - cor0.col2 - - 26 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 44 + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 31 + 38 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 78 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - 16 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 20 * + 78 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT + 94 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 89 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - - 0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 10 + 98 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 64 + 83 FROM tab1 GROUP BY tab1.col0

;

SELECT + 38 * + tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + + 91 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 75 FROM tab1 cor0 GROUP BY col1, cor0.col0, cor0.col1

;

SELECT - 23 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 43 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL 11 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - tab0.col1 * - tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT cor0.col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL >= - col0
;

SELECT - ( - 70 ) - - col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 42 + + cor0.col2 * + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + - col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + + 60 + + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - 16 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 35 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 43 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + 82 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 * - 9 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 45 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - cor0.col1 - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col1 + + col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + 13 * - tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 11 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT 84 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT + 8 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 68 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT 1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 43 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 + + cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + cor0.col2 + cor0.col0 * ( + cor0.col0 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col2 + + col2 * + 19 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 33 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor1.col1 * cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT - ( + 28 ) AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 29 AS col1 FROM tab2 GROUP BY col2

;

SELECT 27 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + 60 * - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 19 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col0 AS col1 FROM tab2 WHERE NULL IS NOT NULL GROUP BY tab2.col0 HAVING NOT NULL < + tab2.col0
;

SELECT DISTINCT + - tab2.col1 + - 54 FROM tab2 GROUP BY tab2.col1

;

SELECT - 21 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT tab0.col0 - - 22 FROM tab0 GROUP BY tab0.col0

;

SELECT - 36 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + cor0.col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT 75 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 36 + cor0.col1 * + 62 AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT ( 50 ) * tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + 59 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL cor0.col2 * - ( 27 * col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - - col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 62 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col2 * 8 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + cor0.col0 + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - col0 - - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 63 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col1

;

SELECT DISTINCT + - 69 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 1 * tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - + tab0.col1 * ( tab0.col1 ) AS col2 FROM tab0 GROUP BY col1

;

SELECT ALL 63 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - 9 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor1.col0 * 81 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT + cor0.col1 * - ( - cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + col0 + - 16 * - tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT tab0.col0 * 17 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - - tab2.col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT - col2 + + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1, col0

;

SELECT - 49 * 3 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 82 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 39 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT 18 + 43 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col1 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT ALL - - 53 * + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - + 86 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + tab2.col2 + + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 0 * 30 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + + 81 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 10 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + col0 FROM tab0 GROUP BY tab0.col0 HAVING ( NULL ) IS NULL
;

SELECT - 46 FROM tab2 GROUP BY tab2.col2

;

SELECT - 83 FROM tab2 GROUP BY col1

;

SELECT ALL 93 FROM tab2 GROUP BY col1

;

SELECT cor1.col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor0.col1, cor1.col0

;

SELECT DISTINCT + cor0.col0 * + 56 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - + 68 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 78 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col1 * 78 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + 7 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + cor0.col2 * 5 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - tab2.col2 * - tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 2 - - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 18 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 26 + 6 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + tab1.col2 + COALESCE ( + 26, - col2 ) FROM tab1 GROUP BY col2

;

SELECT - cor0.col2 + - 68 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT 56 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL 82 * - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 90 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col0 * cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - tab0.col0 * - tab0.col0 FROM tab0 GROUP BY col0

;

SELECT - 20 * cor1.col0 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT 8 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + - 82 + - col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - 62 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + - 51 * + 89 FROM tab0 GROUP BY tab0.col0

;

SELECT 30 + + 49 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - ( + 23 ) * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 90 * tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 47 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + ( col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT - 45 AS col2 FROM tab2, tab0 AS cor0 GROUP BY tab2.col2

;

SELECT DISTINCT 92 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 3 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 17 + + tab1.col2 * tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 18 - col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - + tab1.col1 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 25 * + cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT - ( - 10 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 23 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT ALL 45 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 50 FROM tab1 GROUP BY tab1.col1

;

SELECT - NULLIF ( - cor0.col2, cor0.col2 ) * - 71 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 74 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 69 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - + 93 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 38 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL cor0.col1 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 80 FROM tab1 GROUP BY tab1.col1

;

SELECT + 64 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 47 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT cor0.col0 - + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT + 31 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 73 + 19 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 75 + + 75 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - 54 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 6 + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + - 49 FROM tab2 GROUP BY tab2.col1

;

SELECT 91 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + - col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + cor0.col1 - + 96 * - 29 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, col0

;

SELECT - tab0.col1 * - tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT + tab2.col0 FROM tab2 WHERE NOT tab2.col1 IN ( col0 + tab2.col2 / - tab2.col0 ) GROUP BY tab2.col0

;

SELECT 42 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT NULLIF ( + cor0.col2, 35 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 61 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + 87 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 70 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 23 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - col0 + 49 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 2 + + cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col1, col0

;

SELECT - 38 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - 93 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 53 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 50 * + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 85 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 + - 25 * 68 AS col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL - 86 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 42 * cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + - 41 + + col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT + 98 * - cor0.col2 + + 68 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 60 * - tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + + ( - 43 ) * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 68 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT 52 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 83 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 35 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ( + tab0.col1 ) AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - 66 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT cor0.col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col1, cor0.col2

;

SELECT + + tab2.col1 * 48 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 17 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - + tab0.col2 + 14 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT + 90 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT cor1.col2 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor1.col2

;

SELECT DISTINCT - 40 * 66 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 40 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT NULLIF ( tab1.col2, - 31 + 73 * 5 ) FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 52 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - tab1.col1 * - tab1.col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - 41 + 98 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 15 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 68 AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT DISTINCT - cor0.col2 * 71 AS col0 FROM tab1 cor0 GROUP BY col2

;

SELECT DISTINCT ( + 29 ) * + 78 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + ( 22 ) FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 22 - + tab2.col0 * - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 42 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 39 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, col1

;

SELECT ALL + 51 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 0 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL NULLIF ( 59, 14 ) FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL 82 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab2.col1 + ( 53 ) AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL tab2.col0 * tab2.col0 + + 14 * - tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + - tab0.col1 * - 51 + - 43 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 2 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor0.col0, cor1.col0

;

SELECT DISTINCT - 16 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 34 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 99 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 22 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - 22 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - tab2.col1 * + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - 66 * - 76 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - - tab0.col2 * + 51 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + - tab2.col2 * 8 - 80 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - + 97 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + tab2.col0 + - 19 FROM tab2 GROUP BY tab2.col0

;

SELECT - - tab0.col2 * - tab0.col2 FROM tab0 GROUP BY col2

;

SELECT + 56 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 43 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 86 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - + tab2.col1 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 50 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT tab0.col0 FROM tab0 WHERE NULL NOT IN ( + tab0.col0 * - tab0.col2 ) GROUP BY tab0.col0 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - tab0.col2 AS col0 FROM tab0 GROUP BY col2 HAVING NULL > NULL
;

SELECT - - 57 + - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + 34 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT DISTINCT 68 * 62 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 24 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 17 - + col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - + col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - + 2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + - 95 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - ( 19 ) + - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT + col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT + col2 + - cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0, col2

;

SELECT - 43 + - tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL cor0.col0 - cor0.col2 * cor0.col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col2, cor0.col2

;

SELECT DISTINCT - 60 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor1.col2

;

SELECT DISTINCT - tab2.col1 + - 91 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 49 * col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 59 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 35 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - tab1.col1 * 9 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 88 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 89 * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT cor0.col2 - - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 61 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 90 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 67 AS col0 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT ALL + cor0.col1 + 15 * 78 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT ALL + 81 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 50 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + 24 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col0 * - 85 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + 30 FROM tab1 GROUP BY tab1.col2

;

SELECT + NULLIF ( tab1.col2, - tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT tab2.col0 AS col0 FROM tab2 WHERE ( col1 ) NOT IN ( tab2.col0 * + tab2.col1 - tab2.col2 ) GROUP BY tab2.col0 HAVING NULL IS NOT NULL
;

SELECT - - 30 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT col2 + - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 7 * + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 38 FROM tab1 GROUP BY tab1.col2

;

SELECT 88 - + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 58 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 + - 40 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 88 - + cor0.col2 * cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT tab1.col1 * tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + - tab1.col2 * 18 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + ( 89 ) AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 75 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + tab0.col2 * 59 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 76 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 68 - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 34 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - tab1.col2 FROM tab1, tab2 AS cor0 GROUP BY tab1.col2

;

SELECT - ( 15 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 74 - - 12 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT cor0.col2 - + 43 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 97 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 46 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT 88 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL 28 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 99 - + 27 * col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + 16 * tab1.col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT - col1 * 39 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - ( 92 ) FROM tab1 GROUP BY tab1.col0

;

SELECT cor1.col2 + - cor1.col2 * 36 AS col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT + 44 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT tab2.col1 + ( 31 ) * tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 23 * 80 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 98 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + tab1.col1 FROM tab1 WHERE NOT NULL NOT BETWEEN NULL AND NULL GROUP BY tab1.col1

;

SELECT 91 + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 39 + col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 98 * - col1 + 77 * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 48 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL - 20 + 49 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT COALESCE ( - tab1.col2, + tab1.col2 * + tab1.col2 ) AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT 26 + 96 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + 98 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 49 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT NULLIF ( 85, - cor0.col2 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, col0

;

SELECT + 93 FROM tab2 GROUP BY col1

;

SELECT cor1.col1 * cor1.col1 + 13 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 3 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + ( 99 ) * cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 87 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - tab0.col1 * - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT 93 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - tab1.col2 + tab1.col2 * + 13 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 52 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 37 AS col1 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT + col0 * + col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 35 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT ( cor0.col0 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL - 63 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + - 35 + tab0.col0 * + 61 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + tab0.col1 * - tab0.col1 + tab0.col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 23 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - - 4 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL cor0.col0 + + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 90 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 16 FROM tab1 GROUP BY tab1.col0

;

SELECT - 42 + + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 57 AS col1 FROM tab2 cor0 GROUP BY col1

;

SELECT + tab1.col2 + 86 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + 71 FROM tab0 GROUP BY tab0.col0

;

SELECT - tab1.col0 * col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - col1 + col0 * + 11 AS col2 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - cor0.col2 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT DISTINCT + 7 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 3 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 22 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 9 FROM tab0 GROUP BY col1

;

SELECT ALL 81 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - 45 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT ALL + 76 + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col1 * NULLIF ( + cor0.col1, - cor0.col2 * - cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT + col1 - ( cor0.col0 + cor0.col0 ) AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT DISTINCT tab0.col2 + + 98 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 81 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 10 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 95 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 44 - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + 32 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT + cor0.col0 * + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, col0

;

SELECT cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL 91 + 77 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + 31 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - + 60 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - cor0.col0 * + col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NULL IS NOT NULL
;

SELECT DISTINCT tab1.col0 * + 22 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - cor0.col0 * - 55 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 19 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT NULLIF ( cor0.col2, cor0.col2 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + 61 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + col1 FROM tab1 cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT cor0.col0 + col0 FROM tab0 cor0 GROUP BY col0, col2

;

SELECT tab2.col0 * tab2.col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT ALL + - col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 59 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + + 86 + - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL cor0.col1 * col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT ( - 5 ) + col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + + 13 * - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 89 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT + + tab1.col1 - 58 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL ( + cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - col0 + + 47 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + 13 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 32 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + tab2.col1 * - col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 49 FROM tab0 GROUP BY col1

;

SELECT ALL - 61 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + + 9 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col0  FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 47 AS col1  FROM tab2 GROUP BY tab2.col1

;

SELECT - ( 32 ) * col0  FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col1  FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col1

;

SELECT tab1.col2 - tab1.col2 AS col2  FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col1  FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT 93 AS col2  FROM tab1 GROUP BY tab1.col1

;

SELECT - 95 * + 27  FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 85 AS col2  FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 7 AS col1  FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col2 AS col1  FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 17  FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 92  FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col1 AS col2  FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 51  FROM tab0 GROUP BY tab0.col0

;

SELECT - cor0.col1 AS col2  FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0  FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - + col2  FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - cor0.col1 + 1 * - cor0.col1 AS col1  FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 63  FROM tab2 GROUP BY tab2.col2

;

SELECT - cor0.col0 * + 84  FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT + - 58 AS col2  FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - col0 AS col2  FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + col1  FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - tab1.col2  FROM tab1 GROUP BY tab1.col2

;

SELECT + tab1.col0  FROM tab1 GROUP BY tab1.col0

;

SELECT - + 86  FROM tab2 GROUP BY tab2.col0

;

SELECT + - 14  FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 22 AS col0  FROM tab2 GROUP BY tab2.col1

;

SELECT 18 AS col2  FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col2  FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT - col2  FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col0  FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - tab0.col2  FROM tab0 GROUP BY tab0.col2

;

SELECT 90  FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT tab1.col2  FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col2 AS col2  FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT tab0.col0 AS col1  FROM tab0 GROUP BY tab0.col0

;

SELECT - tab1.col0 + - tab1.col0  FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 19 AS col0  FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 76  FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + 32 AS col0  FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2  FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col2  FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col1  FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + tab0.col2  FROM tab0 GROUP BY tab0.col2

;

SELECT - cor0.col1  FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 66 AS col0  FROM tab0 GROUP BY tab0.col2

;

SELECT + + tab0.col0 + tab0.col0 AS col2  FROM tab0 GROUP BY col0

;

SELECT DISTINCT cor0.col2 AS col0  FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab1.col2  FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col2 * + 55 + cor0.col2  FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT cor0.col1  FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT tab1.col1  FROM tab1 GROUP BY tab1.col1

;

SELECT tab0.col2 + - 94  FROM tab0 GROUP BY col2

;

SELECT 71 AS col0  FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 AS col0  FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL cor0.col1 AS col1  FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - + 44  FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 57 AS col0  FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2  FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - 65 AS col2  FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 AS col1  FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - tab0.col1  FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col2  FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + + tab2.col0  FROM tab2 GROUP BY tab2.col0

;

SELECT + - 88 AS col1  FROM tab2 GROUP BY tab2.col2

;

SELECT + - tab2.col2 AS col0  FROM tab2 GROUP BY tab2.col2

;

SELECT ALL tab1.col0  FROM tab1 GROUP BY col0

;

SELECT tab0.col2 + 56  FROM tab0 GROUP BY tab0.col2

;

SELECT - 27  FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 AS col2  FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + + cor0.col1  FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL - cor0.col1  FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col1  FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL - col0  FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT tab1.col0  FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + cor0.col0 AS col2  FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - 21  FROM tab2 AS cor0 GROUP BY col0

;

SELECT 37  FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT tab0.col0 * + tab0.col0 AS col1  FROM tab0 GROUP BY tab0.col0

;

SELECT - 11 AS col0  FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 42  FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT tab1.col2 AS col0  FROM tab1 GROUP BY tab1.col2

;

SELECT - cor0.col2 * cor0.col2 + col2 * cor0.col0  FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT 94 AS col1  FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + 4  FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col0  FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 89  FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 69 + - cor0.col0  FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 41  FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - tab0.col0 AS col1  FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col0  FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT DISTINCT + 73 AS col1  FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - tab2.col0  FROM tab2 GROUP BY tab2.col0 HAVING + col0 < NULL
;

SELECT - + tab2.col0  FROM tab2 GROUP BY tab2.col0

;

SELECT ALL tab1.col0 * + tab1.col0  FROM tab1 GROUP BY tab1.col0

;

SELECT col1  FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + col2 + 87 AS col0  FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab2.col0  FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 41  FROM tab2 AS cor0 GROUP BY col2

;

SELECT + 17  FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 79  FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT col2 AS col1  FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + tab0.col2  FROM tab0 GROUP BY col2

;

SELECT DISTINCT - col0 + tab0.col0 AS col1  FROM tab0 GROUP BY tab0.col0

;

SELECT - cor0.col2 AS col2  FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 48  FROM tab1 GROUP BY tab1.col0

;

SELECT 80  FROM tab0 GROUP BY col1

;

SELECT + + 52  FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + cor0.col0  FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 2 - cor0.col2 AS col1  FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + tab2.col0 * tab2.col0 + 99 * tab2.col0 AS col0  FROM tab2 GROUP BY tab2.col0

;

SELECT tab2.col0 AS col0  FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 62  FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 74  FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + tab1.col1 AS col0  FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - cor0.col1  FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT - 97  FROM tab0 GROUP BY col0

;

SELECT - 98  FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - col0 AS col1  FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - tab2.col1 AS col0  FROM tab2 GROUP BY col1

;

SELECT ALL + cor0.col0 AS col1  FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - col0  FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + cor0.col1 AS col0  FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col1 AS col1  FROM tab0 GROUP BY col1

;

SELECT DISTINCT tab1.col2  FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col2 * cor0.col0 AS col2  FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col0  FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 AS col0  FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + + tab0.col2 * tab0.col2 AS col0  FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col2 + - cor0.col2 AS col2  FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0  FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 57 AS col1  FROM tab2 cor0 GROUP BY col2

;

SELECT ALL cor0.col0 * 25 AS col2  FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 87 AS col1  FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT col1 AS col1  FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - - tab1.col1 AS col2  FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 33 AS col1  FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + 83  FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 37  FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + col2  FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + 35 AS col0  FROM tab1 GROUP BY tab1.col0

;

SELECT - + tab0.col2 AS col2  FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + tab1.col0 AS col1  FROM tab1 GROUP BY tab1.col0

;

SELECT - 6 AS col0  FROM tab0 AS cor0 GROUP BY col1

;

SELECT cor0.col1 AS col2  FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 + 2  FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL col2  FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 10 AS col2  FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL - cor0.col2  FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - tab0.col0 AS col0  FROM tab0 GROUP BY tab0.col0

;

SELECT + 22 * + cor0.col0  FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col0

;

SELECT cor0.col1  FROM tab1 AS cor0 GROUP BY col1

;

SELECT cor0.col2 AS col0  FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT 19  FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 - cor0.col2 AS col0  FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT col0 + + cor0.col0  FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + col0  FROM tab2 GROUP BY tab2.col0

;

SELECT tab0.col2  FROM tab0 GROUP BY tab0.col2

;

SELECT tab2.col2  FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col1  FROM tab0 AS cor0 GROUP BY col1

;

SELECT + + 54 AS col2  FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 72 + cor0.col0  FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT tab2.col1  FROM tab2 GROUP BY tab2.col1

;

SELECT ALL tab2.col1 AS col2  FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + tab1.col2 AS col2  FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 43  FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - 17  FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 AS col2  FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 94  FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - - 87 AS col2  FROM tab1 GROUP BY tab1.col0

;

SELECT 78  FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL 28 - - tab0.col1  FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + cor0.col1 AS col1  FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 97  FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + + 95 AS col2  FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - tab0.col2  FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - cor0.col1 AS col2  FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT col0 * cor0.col0 + + cor0.col1  FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL 78  FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT col0  FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + tab2.col1 AS col2  FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col0 * cor0.col0  FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT cor0.col0  FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col0 + + cor0.col0 AS col0  FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + tab1.col1  FROM tab1 GROUP BY tab1.col1

;

SELECT - 46 AS col1  FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 * - col2  FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL col0 * + cor0.col0  FROM tab0 AS cor0 GROUP BY cor0.col0, col0

;

SELECT cor0.col0 AS col1  FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 59 * + tab0.col0 + tab0.col0 AS col0  FROM tab0 GROUP BY tab0.col0

;

SELECT 33  FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + col1  FROM tab0 GROUP BY col1

;

SELECT cor0.col2 AS col2  FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL col1 * - col1 AS col0  FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + cor0.col1 AS col1  FROM tab0 AS cor0 GROUP BY col1

;

SELECT + + 86  FROM tab2 GROUP BY col1

;

SELECT + cor0.col1 * cor0.col1 AS col1  FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 25 AS col0  FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col2 AS col0  FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 88  FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + tab1.col1 * tab1.col1  FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col1 AS col2  FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1  FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + tab1.col2  FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 74  FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1

;

SELECT DISTINCT + cor0.col2  FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 AS col2  FROM tab0 AS cor0 GROUP BY col1, cor0.col0, col1

;

SELECT DISTINCT - cor0.col2 AS col1  FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT tab0.col1 + tab0.col1  FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col2  FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 + - cor0.col0 AS col0  FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT ALL tab2.col1 * - 72 - + tab2.col1  FROM tab2 GROUP BY col1

;

SELECT ALL + tab2.col1 * col1  FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col1 AS col1  FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT - cor0.col0 * col0 AS col1  FROM tab1 cor0 GROUP BY col0

;

SELECT ALL cor0.col0  FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - + 37  FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 40 + - cor0.col2  FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 AS col2  FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + cor0.col0 - + cor0.col0  FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 + - cor0.col0 AS col2  FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - tab1.col1  FROM tab1 GROUP BY col1

;

SELECT DISTINCT 93  FROM tab0 GROUP BY col1

;

SELECT 96 AS col0  FROM tab2 GROUP BY tab2.col1

;

SELECT + - tab2.col0  FROM tab2 GROUP BY tab2.col0

;

SELECT - 66 AS col2  FROM tab2 GROUP BY col1

;

SELECT tab0.col0  FROM tab0 GROUP BY tab0.col0

;

SELECT + tab1.col2 * 38  FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + cor0.col1 * - 84  FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2  FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT col1  FROM tab0 AS cor0 GROUP BY col2, cor0.col2, col1

;

SELECT cor0.col1  FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL cor0.col2 AS col1  FROM tab2 cor0 GROUP BY col2

;

SELECT - cor0.col0  FROM tab0 AS cor0 GROUP BY col0

;

SELECT col1 AS col1  FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col2  FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 76 * cor0.col1  FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 AS col1  FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col2  FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 90  FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col0  FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 27  FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col0 AS col1  FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT + 61 AS col2  FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 23 * + cor0.col0 + cor0.col0 AS col0  FROM tab2 AS cor0 GROUP BY col0

;

SELECT col2 + - 67 * cor0.col1  FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 49 AS col1  FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 33  FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 * - cor0.col2 AS col2  FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL + tab2.col0  FROM tab2 GROUP BY tab2.col0

;

SELECT tab0.col1  FROM tab0 GROUP BY tab0.col1

;

SELECT - 3  FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 * - cor0.col1 AS col2  FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 32  FROM tab2 GROUP BY col1

;

SELECT cor0.col0  FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT cor0.col0 AS col2  FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - - tab2.col2 AS col2  FROM tab2 GROUP BY tab2.col2

;

SELECT + tab0.col2 AS col0  FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + col0 AS col2  FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 * - 15 AS col0  FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor0.col0

;

SELECT ALL + cor0.col0 + + 50  FROM tab0 AS cor0 GROUP BY col0

;

SELECT col2  FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + tab2.col0  FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + cor0.col2  FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor1.col1 + cor1.col1 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor1.col2, cor0.col0

;

SELECT ALL - cor0.col1 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col1

;

SELECT - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col0 FROM tab1 cor0 GROUP BY col2, cor0.col0, cor0.col0

;

SELECT ALL - cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1

;

SELECT DISTINCT cor0.col0 AS col2, cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab1.col1 - - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - col2 * + tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - tab2.col0 * - + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - cor0.col2 * + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - col2 + - cor0.col0 + + - col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT DISTINCT - col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL cor0.col0 FROM tab0 cor0 GROUP BY col0, col2

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT - cor0.col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT cor0.col2 - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2, cor1.col1

;

SELECT col0 + + + cor0.col0 + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - cor0.col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 + - + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - tab0.col1 FROM tab0 WHERE NOT NULL IS NOT NULL GROUP BY tab0.col1

;

SELECT DISTINCT + tab1.col0 FROM tab1 GROUP BY tab1.col0 HAVING NULL IS NULL
;

SELECT + col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + + col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col0, cor0.col2

;

SELECT ALL + SUM ( + cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL <= NULL
;

SELECT ALL col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL + col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - + tab2.col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT + cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col1, cor0.col0

;

SELECT ALL col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + col1 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT + cor0.col1 - + + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col1 + - - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - - tab1.col1 + - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + cor0.col0 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT - - SUM ( + tab0.col1 ) FROM tab0 GROUP BY tab0.col1 HAVING NULL IS NOT NULL
;

SELECT ALL + cor0.col0 - col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab0 cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT tab0.col0 FROM tab0 GROUP BY tab0.col0 HAVING NOT NULL IS NOT NULL
;

SELECT - tab1.col1 FROM tab1 WHERE NOT NULL IS NULL GROUP BY tab1.col1

;

SELECT - cor0.col2 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT + cor0.col0 * - - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL tab0.col2 * - tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2 HAVING NOT NULL IS NOT NULL
;

SELECT - - tab1.col1 FROM tab1 GROUP BY col1

;

SELECT cor0.col2 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - col1 * + + cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + cor0.col2 + + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT ALL - cor0.col0 AS col0 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL - cor0.col2 AS col0 FROM tab1 cor0 GROUP BY col2

;

SELECT cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT DISTINCT - tab1.col1 AS col2 FROM tab1, tab0 cor0 GROUP BY tab1.col1

;

SELECT DISTINCT + col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - tab2.col1 - + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL cor0.col0 * + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT cor0.col0 + SUM ( DISTINCT cor1.col2 ) AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - tab1.col0 FROM tab1 WHERE NOT NULL IS NULL GROUP BY tab1.col0

;

SELECT + tab2.col2 + - + col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL cor0.col1 FROM tab0 cor0 GROUP BY col2, cor0.col1

;

SELECT ALL - tab2.col0 * + tab2.col0 * - + tab2.col0 + - tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT SUM ( DISTINCT tab1.col1 ) - - + tab1.col2 + col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT ( NULL ) IS NULL
;

SELECT ALL + cor0.col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 + cor0.col2 * - cor0.col2 FROM tab1 cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT + col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, col0

;

SELECT - tab0.col1 + tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT - + tab2.col1 AS col0 FROM tab2, tab0 AS cor0 GROUP BY tab2.col1

;

SELECT - - tab0.col2 AS col0 FROM tab0, tab2 cor0 GROUP BY tab0.col2

;

SELECT ALL col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - col2 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL <= NULL
;

SELECT ALL cor0.col1 AS col2, - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col0

;

SELECT - cor0.col1 AS col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col0 * - cor0.col0 - - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT cor0.col1 - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor1.col0 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor1.col0

;

SELECT cor0.col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + tab2.col1 + - - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - cor0.col2 FROM tab1, tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * - cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - + tab0.col0, - tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + cor0.col2, - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 FROM tab0 AS cor0 WHERE ( NULL ) IS NOT NULL GROUP BY col2

;

SELECT ALL - - tab0.col1 AS col2 FROM tab0, tab2 AS cor0 GROUP BY tab0.col1

;

SELECT DISTINCT col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT DISTINCT - - col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + cor0.col2 * + - cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT tab2.col1 + + - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT cor0.col2, + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING NULL IS NOT NULL
;

SELECT cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT cor0.col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT + cor0.col0 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + col1 + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col0, col0

;

SELECT - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + + col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT cor0.col0 * + + col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + + col1 + + tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - col0 + + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col0 AS col0, + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - col2 AS col0, tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - cor0.col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col1, cor0.col0

;

SELECT - cor0.col1 + + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT - col2 AS col2 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT - cor0.col0 * + col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT cor0.col2 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col1 * - - cor0.col1 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - cor0.col0 AS col0 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL + cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT - col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT + cor0.col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY col1 HAVING NULL IS NULL
;

SELECT col0 + - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL tab2.col0 * + tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - + tab0.col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 + - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT ALL cor0.col1 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NULL
;

SELECT ALL + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col1, cor0.col2

;

SELECT DISTINCT + SUM ( ALL + tab1.col1 ) FROM tab1 GROUP BY tab1.col0 HAVING NOT NULL IS NULL
;

SELECT - col1 AS col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT NULL IS NOT NULL
;

SELECT ALL + cor0.col0 * + - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + col2 FROM tab1 GROUP BY col2 HAVING NOT NULL < ( NULL )
;

SELECT cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT DISTINCT tab1.col2 + - tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col2

;

SELECT cor0.col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, col2

;

SELECT ALL - cor0.col1 + + cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + col1 - + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + tab0.col0 FROM tab0 GROUP BY tab0.col0 HAVING NOT NULL IS NULL
;

SELECT - cor0.col1 FROM tab0 cor0 GROUP BY cor0.col0, col1

;

SELECT tab2.col2 FROM tab2 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0 HAVING NOT ( NULL ) < NULL
;

SELECT + cor0.col2 * + - col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + cor1.col1 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col1, cor1.col1

;

SELECT - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT DISTINCT - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - cor1.col1 AS col2 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT + - col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - col0 AS col0 FROM tab0 cor0 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT + SUM ( cor1.col2 ) FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0 HAVING NOT NULL IS NULL
;

SELECT cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, col2

;

SELECT + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT col1 * + col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT + col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + - col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL - tab2.col1 AS col1, tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - cor0.col0 * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + cor1.col2 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NOT NULL
;

SELECT + col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT col2 AS col0 FROM tab0 cor0 GROUP BY col2

;

SELECT ALL - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT + - tab0.col2 * + + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col2 * - - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT - col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col1 AS col1, cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col1 FROM tab2 cor0 GROUP BY col1, cor0.col2

;

SELECT + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2 HAVING NULL < NULL
;

SELECT ALL - col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - tab2.col0 - tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - cor0.col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col0

;

SELECT DISTINCT - cor0.col2 * - - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - tab2.col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT ALL cor0.col2 - + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - tab0.col0 AS col2 FROM tab0 GROUP BY col0 HAVING NOT ( NULL ) IS NULL
;

SELECT - cor0.col0 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT - - col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, col2

;

SELECT ALL - - tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + + tab2.col2 + + + tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT + tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING NOT NULL IS NOT NULL
;

SELECT + cor0.col1 * - - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor1.col1 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor1.col0

;

SELECT ALL - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + + tab2.col2 * + + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - tab2.col1, - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT tab2.col0 + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + + tab2.col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT + col0 AS col0 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT ALL + cor0.col2, - col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + tab0.col0 AS col0 FROM tab0 WHERE ( NULL ) NOT IN ( + tab0.col1 ) GROUP BY tab0.col0

;

SELECT cor0.col0 AS col1 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col0, cor0.col0

;

SELECT DISTINCT - cor0.col0, col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col2 * - col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 + + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT ALL - cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT + + col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT tab1.col2 * - tab1.col2 * + - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT col2 * - col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT + col1 AS col2 FROM tab0 GROUP BY tab0.col1 HAVING NOT col1 NOT IN ( - SUM ( DISTINCT col2 ) )
;

SELECT DISTINCT col0, + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT SUM ( ALL col2 ) AS col2 FROM tab1 GROUP BY tab1.col0 HAVING NULL = NULL
;

SELECT + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT + col0 * + col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 AS col1 FROM tab1 cor0 GROUP BY col0, col2

;

SELECT + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT - cor0.col1 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT - + tab1.col1 * - tab1.col1 * - tab1.col1 + + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT cor0.col0 * cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NOT NULL
;

SELECT ALL cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT + tab2.col1 + - - tab2.col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT ALL - cor0.col2 * + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 - + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL + cor0.col1 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col1, cor1.col0

;

SELECT - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NULL
;

SELECT + - tab0.col0 + + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 FROM tab2 cor0 GROUP BY col1, col2

;

SELECT DISTINCT col2 * - - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + + tab1.col0, + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT tab1.col2 + - col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - col2 + - - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - + cor0.col0 FROM tab1, tab1 cor0 GROUP BY cor0.col0

;

SELECT + col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - - tab0.col0 - tab0.col0 FROM tab0 GROUP BY col0

;

SELECT cor1.col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor1.col1

;

SELECT col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL - cor1.col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor1.col0

;

SELECT + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col1

;

SELECT ALL + col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - col0 AS col0 FROM tab0 WHERE NULL IS NULL GROUP BY tab0.col0

;

SELECT ALL col1 + - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - - tab2.col1, + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL col2 FROM tab0 cor0 GROUP BY col2, cor0.col2

;

SELECT col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL - - col2 FROM tab0 GROUP BY tab0.col2 HAVING NOT SUM ( DISTINCT col0 ) IS NULL
;

SELECT DISTINCT - - tab0.col2 + - - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT - cor0.col2 AS col2 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT + - col1 FROM tab1 GROUP BY col1

;

SELECT ALL col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT - col0 + + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 FROM tab0 cor0 GROUP BY cor0.col2, col1

;

SELECT + cor0.col2 * + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - col0, - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT - tab1.col0 AS col0, tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT - cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT col0 * - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col2 FROM tab1 cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT + cor0.col2 * + - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT DISTINCT - cor1.col2 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT + tab2.col2 * tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - tab1.col2 - + col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col2 + + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT + tab0.col2 * + tab0.col2 + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + cor0.col2 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL SUM ( ALL tab2.col1 ) FROM tab2 GROUP BY tab2.col1 HAVING NOT + col1 >= NULL
;

SELECT ALL - tab2.col2 * + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT - - tab0.col1 + - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT cor0.col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col1, cor0.col0

;

SELECT DISTINCT - col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2, cor0.col1

;

SELECT DISTINCT - col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL cor0.col2 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - cor0.col1, + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL col1 AS col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT ( NULL ) IS NULL
;

SELECT ALL + tab0.col0 FROM tab0 GROUP BY tab0.col0 HAVING NOT ( NULL ) > NULL
;

SELECT + tab2.col2 AS col2 FROM tab2, tab2 AS cor0 GROUP BY tab2.col2

;

SELECT ALL + col2 AS col0 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT + col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, col1

;

SELECT ALL - + tab2.col2 + - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - col0 AS col0, cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col0, cor0.col2

;

SELECT ALL - cor0.col2 * cor0.col1 AS col1, cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - col0 + - - col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL col2 * - + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + - tab0.col1 - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT DISTINCT - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col1

;

SELECT ALL cor0.col1 / + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL cor1.col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - col1 AS col1 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL + cor0.col1 * + cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT DISTINCT - col2 * + - cor0.col2 + + cor0.col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT - tab0.col2 * - tab0.col2 FROM tab0 GROUP BY col2

;

SELECT cor1.col1 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1, cor1.col1

;

SELECT ALL + col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT tab0.col0 + tab0.col0 * col0 FROM tab0 GROUP BY col0

;

SELECT - cor0.col2 + - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 + - - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor1.col2 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL - tab0.col1 + + + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - cor0.col2 + + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT cor0.col1 * cor0.col2 * + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT DISTINCT + + tab1.col2, + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - + col0 AS col2 FROM tab0 GROUP BY col0 HAVING ( NULL ) IS NULL
;

SELECT ALL + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT + cor0.col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT col1 + - + cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - + col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, col2

;

SELECT DISTINCT cor0.col0 + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT cor0.col1 * - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL - tab2.col2 * tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT - col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL cor0.col2 * + col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT ALL + - col2 - tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1 HAVING ( NULL ) <> ( NULL )
;

SELECT DISTINCT + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT + tab1.col1, + tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + col0 * + + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 FROM tab0 AS cor0 GROUP BY col0, cor0.col1 HAVING NOT col1 IS NOT NULL
;

SELECT DISTINCT + cor0.col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT + + tab1.col0, - tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - cor0.col1 * - cor0.col1 - + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor1.col0 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT + col0 + + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT + col0, - cor0.col1 FROM tab0 cor0 GROUP BY col1, cor0.col0

;

SELECT + cor0.col0 + + + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT ALL + col0 + + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + cor0.col2 FROM tab2 cor0 GROUP BY col0, cor0.col2

;

SELECT col2 + - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + + SUM ( DISTINCT + - tab0.col0 ) AS col0 FROM tab0 GROUP BY tab0.col1 HAVING NOT ( NULL ) <> NULL
;

SELECT ALL cor0.col0 AS col2, cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT tab2.col1 * tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT col0 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NULL <> NULL
;

SELECT col1 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NULL
;

SELECT col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT ALL - cor0.col0 * - col1 * + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col0 * + cor0.col0, - col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING NULL > ( NULL )
;

SELECT ALL cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL - cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - - col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col0 * - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1, cor0.col2

;

SELECT ALL cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, col2

;

SELECT tab2.col1 * + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + cor0.col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor0.col1

;

SELECT - cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT tab1.col1 * - col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col2 AS col0 FROM tab2 cor0 GROUP BY col1, cor0.col1, col2, cor0.col1

;

SELECT - cor0.col2 - - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + - col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT ALL + - tab2.col1 AS col2, tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col2, cor0.col0

;

SELECT - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT cor0.col0 * - - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 FROM tab0 AS cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT cor0.col0 + + - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + cor0.col2 * - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT + + tab2.col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT - - tab0.col0 + + tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL col1 FROM tab1 GROUP BY tab1.col1 HAVING NULL IS NULL
;

SELECT ALL - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT - cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col0

;

SELECT + cor0.col1 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT cor0.col1 + + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT cor0.col1 * + cor0.col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL - cor0.col2 * + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL tab0.col2 FROM tab0 GROUP BY tab0.col2 HAVING NOT ( NULL ) BETWEEN NULL AND NULL
;

SELECT DISTINCT tab2.col2 FROM tab2, tab2 AS cor0 GROUP BY tab2.col2

;

SELECT ALL - cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT + col0 + - cor0.col1 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col0, col1

;

SELECT DISTINCT + tab0.col1 * + tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT tab2.col1 - - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT - col1 AS col2 FROM tab1 cor0 GROUP BY col1

;

SELECT cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, col1, cor0.col0

;

SELECT DISTINCT col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT ALL - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT col0, - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col0, cor0.col1

;

SELECT cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col1

;

SELECT ALL - cor0.col0 - + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + col1 * - cor0.col2 AS col1, cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - col2 * - - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + tab0.col2, tab0.col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, col0

;

SELECT ALL - + col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT ALL - col0 FROM tab0 cor0 GROUP BY col0

;

SELECT cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NULL IS NULL
;

SELECT ALL - col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT + cor0.col2 + - + cor0.col1 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1, cor0.col2

;

SELECT - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT - + col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT + tab1.col1 * - col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - + col1 * + - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - + tab2.col1 + - tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT SUM ( DISTINCT cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING ( NULL ) IS NOT NULL
;

SELECT col1 FROM tab0 GROUP BY tab0.col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - col2 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col1 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col1

;

SELECT cor0.col2 + - + col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 + cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + col0 * - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 AS col2, - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - cor0.col2 * cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL SUM ( + cor0.col1 ) AS col0, - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col1 - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, col2

;

SELECT ALL tab0.col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT - cor0.col0 + + - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + SUM ( DISTINCT - cor0.col0 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL <= NULL
;

SELECT DISTINCT + cor0.col0 - col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 + + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 + cor0.col2 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + cor0.col1 * - cor0.col1 + - col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - cor0.col0 + + - col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT DISTINCT + tab0.col2 + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor1.col1 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL + - tab2.col2 FROM tab2 GROUP BY col2

;

SELECT + col1 AS col0 FROM tab1 cor0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - - tab2.col2 + - tab2.col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT DISTINCT col0 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT - - col1 + SUM ( DISTINCT + col1 ) AS col0 FROM tab0 cor0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT ALL col1 FROM tab2 AS cor0 GROUP BY col0, col1, col2

;

SELECT col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT + col2 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT ALL + col0 AS col2 FROM tab2 GROUP BY col1, col0

;

SELECT ALL col2 AS col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT ALL col2, col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - col1 AS col0 FROM tab1 GROUP BY col1, col1

;

SELECT ALL - + col2 + + col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT col1 AS col1 FROM tab0 cor0 GROUP BY col1

;

SELECT col2 AS col1 FROM tab1 AS cor0 WHERE NOT col1 IS NOT NULL GROUP BY col2

;

SELECT col2 AS col0 FROM tab2 GROUP BY col2, col1 HAVING NOT NULL IS NULL
;

SELECT col2 AS col2 FROM tab0 GROUP BY col2, col0 HAVING NOT NULL IS NOT NULL
;

SELECT ALL - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, col2, col2

;

SELECT - - col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT + col0 AS col0 FROM tab0 GROUP BY col0, col2

;

SELECT ALL + col0 - - col0 AS col0 FROM tab2 GROUP BY col0, col0

;

SELECT DISTINCT col2 FROM tab2 GROUP BY col0, col2

;

SELECT col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT - col0 FROM tab1 GROUP BY col1, col2, col0

;

SELECT col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT ALL + col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + col0 FROM tab0 GROUP BY col0, col2

;

SELECT + + col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT + col2 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT ALL - - col0 AS col1 FROM tab0 cor0 GROUP BY col0, col0

;

SELECT ALL + col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT ALL col2 * - col2 AS col2 FROM tab1 WHERE NULL >= col1 GROUP BY col0, col2

;

SELECT + col1 FROM tab2 AS cor0 GROUP BY col1, col1 HAVING NOT ( NULL ) IS NULL
;

SELECT - col2 FROM tab0 GROUP BY col2, col1 HAVING NOT NULL < NULL
;

SELECT ALL col0 + col2 + + col2 AS col0 FROM tab0 GROUP BY col0, col2

;

SELECT DISTINCT - col0 * - col2 FROM tab1 AS cor0 GROUP BY col0, col1, col2

;

SELECT + col2 - col2 + - col2 FROM tab1 AS cor0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT + + col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT col1 * - col1 FROM tab0 GROUP BY col1, col2

;

SELECT - col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2 HAVING NULL = NULL
;

SELECT col2 + + col2 * - col2 FROM tab0 GROUP BY col2 HAVING NOT NULL <> NULL
;

SELECT DISTINCT + col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + col2 * - col0 AS col2 FROM tab0 GROUP BY col0, col2

;

SELECT DISTINCT + + col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT + + col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT col0 FROM tab2 GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT ALL col2 FROM tab1 AS cor0 GROUP BY col2 HAVING ( NOT NULL IS NULL )
;

SELECT col2 * - SUM ( + - col2 ) FROM tab2 AS cor0 WHERE ( NULL ) IS NOT NULL GROUP BY col2 HAVING NULL < NULL
;

SELECT + + col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - - col0 AS col2 FROM tab2 AS cor0 GROUP BY col1, col0, col2

;

SELECT ALL - col2 FROM tab2 cor0 GROUP BY col2, col2

;

SELECT + col0 * - + col0 AS col0 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT col2 AS col0 FROM tab1 AS cor0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT + col1 FROM tab0 AS cor0 GROUP BY col0, col1 HAVING NOT NULL BETWEEN - - col0 AND NULL
;

SELECT ALL col0 * + col0 + + col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT ALL - col1 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + col1 FROM tab0 GROUP BY col1, col0

;

SELECT - col1 AS col1 FROM tab2 GROUP BY col1, col2

;

SELECT - col0 AS col2 FROM tab2 AS cor0 GROUP BY col0 HAVING + col0 = NULL
;

SELECT - col1 * col2 AS col1 FROM tab2 GROUP BY col1, col2

;

SELECT ALL + col0 FROM tab0 GROUP BY col0, col0

;

SELECT + col2, col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - col0 AS col1 FROM tab1 GROUP BY col2, col0, col0

;

SELECT DISTINCT + col0 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT + - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, col2, col0

;

SELECT ALL - + col2, + col2 + - col2 AS col1 FROM tab2 AS cor0 WHERE NOT NULL <= col0 GROUP BY col2, col2 HAVING NOT NULL IS NOT NULL
;

SELECT ALL + col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT ALL + col0 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT - - col1, col2 FROM tab0 AS cor0 GROUP BY col1, col2 HAVING NOT NULL IS NULL
;

SELECT + + col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - col2 FROM tab0 WHERE + - col1 + col1 IS NOT NULL GROUP BY col1, col2

;

SELECT DISTINCT - - col1 + col1 FROM tab0 AS cor0 GROUP BY col1, col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - col1 - col1 FROM tab2 AS cor0 GROUP BY col1 HAVING NOT NULL <= NULL
;

SELECT + col2 - + col2 + col2 FROM tab1 GROUP BY col2

;

SELECT ALL + col2 AS col1 FROM tab0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT col1 + col1 FROM tab1 GROUP BY col1

;

SELECT + col1 * + col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + + col1 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT - col2 FROM tab2 AS cor0 GROUP BY col2, col2, col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - col0 AS col0 FROM tab2 GROUP BY col0, col0

;

SELECT + + col1 * + col0 FROM tab2 AS cor0 WHERE NOT NULL <> ( NULL ) GROUP BY col1, col0

;

SELECT DISTINCT col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + col1 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT + - col0 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT + col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT + - col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT col0 FROM tab1 GROUP BY col0, col0

;

SELECT ALL col1 AS col2 FROM tab2 GROUP BY col1, col0

;

SELECT DISTINCT + col1 AS col0 FROM tab2 AS cor0 GROUP BY col0, col2, col1 HAVING NOT NULL IS NOT NULL
;

SELECT - col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT ALL + - col0 + col2 AS col2 FROM tab0 AS cor0 GROUP BY col0, col2, col2

;

SELECT - col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, col0 HAVING NOT - SUM ( DISTINCT + + col2 ) IS NULL
;

SELECT DISTINCT - col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT + col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT + + col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT ALL - col1 AS col2 FROM tab2 GROUP BY col1, col2

;

SELECT + col0 AS col1 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT ALL + col1 AS col0, col1 FROM tab1 AS cor0 GROUP BY col1, col0, col0

;

SELECT DISTINCT + col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT - col2, - col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT ALL - col1 AS col2 FROM tab2 GROUP BY col2, col1

;

SELECT + - col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT - col1 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT ALL + col1 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT col0 AS col2 FROM tab2 GROUP BY col0 HAVING NULL IS NULL
;

SELECT ALL + col0 + col0 AS col0 FROM tab2 GROUP BY col0, col0

;

SELECT DISTINCT - col2 * col2 + col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT + + col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - col1 * + + col1 FROM tab2 AS cor0 GROUP BY col1, col1 HAVING NULL >= NULL
;

SELECT ALL col2 AS col0 FROM tab1 GROUP BY col2, col2 HAVING NOT ( NULL ) IS NULL
;

SELECT ALL col0 * col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT - col0 AS col0 FROM tab1 GROUP BY col0 HAVING NOT NULL BETWEEN NULL AND - + col0
;

SELECT DISTINCT col2 * + - col2 FROM tab0 GROUP BY col2

;

SELECT ALL col2 FROM tab0 WHERE NOT NULL IS NULL GROUP BY col2

;

SELECT + col0 * - col0 * - col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT + - col0 AS col0, col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT - col0 * + col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT ALL - col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT col1 - + col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT col1 FROM tab2 AS cor0 GROUP BY col1 HAVING NULL IS NULL
;

SELECT ALL - col0 FROM tab1 cor0 GROUP BY col0

;

SELECT col1 * - col1 FROM tab0 AS cor0 GROUP BY col1, col1, col2

;

SELECT ALL - col0 FROM tab1 GROUP BY col0, col0

;

SELECT ALL - col2 AS col2 FROM tab0 WHERE NOT NULL IS NULL GROUP BY col2

;

SELECT DISTINCT + col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT + col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT - col2 AS col0 FROM tab1 AS cor0 GROUP BY col2, col2, col1

;

SELECT + col2 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT + col0 FROM tab2 GROUP BY col0, col2

;

SELECT col0 FROM tab2 GROUP BY col1, col2, col0

;

SELECT DISTINCT + col1 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT ALL + - col0 FROM tab1 AS cor0 GROUP BY col0, col0 HAVING NOT NULL IS NOT NULL
;

SELECT ALL col1 FROM tab2 GROUP BY col1, col1

;

SELECT DISTINCT col2 FROM tab0 GROUP BY col2, col2

;

SELECT col0 FROM tab0 GROUP BY col0, col1

;

SELECT + - col0 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT - col2 - - col2 AS col1 FROM tab1 cor0 GROUP BY col2, col0

;

SELECT DISTINCT col1 AS col1 FROM tab0 GROUP BY col2, col1 HAVING NULL IS NOT NULL
;

SELECT + + col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT - col0 * + + col2 * + - col2 AS col0 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT col0 AS col1 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT - col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT + col0 AS col0 FROM tab1 GROUP BY col0, col0, col2 HAVING NOT NULL IS NULL
;

SELECT + col1 FROM tab0 GROUP BY col2, col1

;

SELECT DISTINCT col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT - - col0 FROM tab1 AS cor0 GROUP BY col0, col0, col0 HAVING NOT NULL IS NOT NULL
;

SELECT col1 AS col2 FROM tab0 AS cor0 GROUP BY col0, col1, col1

;

SELECT + + col1 AS col0 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT ALL + col2 AS col0 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT col2 AS col2 FROM tab1 GROUP BY col2, col0

;

SELECT - col2 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT - - col2 FROM tab2 AS cor0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT + col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - col0 / + - SUM ( col0 ) FROM tab2 GROUP BY col0 HAVING NOT - col0 <> + col0
;

SELECT ALL - col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT col2 AS col0 FROM tab2 AS cor0 GROUP BY col2 HAVING NOT NULL < NULL
;

SELECT DISTINCT + col0 + - col0 * - + col0 FROM tab0 GROUP BY col0

;

SELECT - col2 * + col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT + col2 FROM tab2 GROUP BY col2, col1

;

SELECT + col2 FROM tab2 GROUP BY col2, col2

;

SELECT DISTINCT + col2 FROM tab0 cor0 GROUP BY col2, col1

;

SELECT ALL + col0 AS col1 FROM tab1 GROUP BY col2, col0

;

SELECT DISTINCT - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT - - col1 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT - col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT - col1 AS col1 FROM tab2 GROUP BY col2, col1

;

SELECT DISTINCT - - col0 AS col1 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL - col0 AS col0 FROM tab2 GROUP BY col0 HAVING NULL IS NULL
;

SELECT DISTINCT - - col0 AS col2 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT - col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT col1 AS col2 FROM tab0 GROUP BY col1, col1

;

SELECT ALL + - col2 AS col1 FROM tab1 AS cor0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT DISTINCT - + col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT - + col1 * col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT ALL col1 AS col2 FROM tab1 cor0 GROUP BY col1, col1

;

SELECT col0 FROM tab2 GROUP BY col0, col2

;

SELECT DISTINCT + col1 AS col1, col2 FROM tab1 GROUP BY col1, col2

;

SELECT ALL + col2 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL - - col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT + - col2 AS col1 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT + col2 AS col2 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT - + col1 AS col2, - col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL + - SUM ( DISTINCT - col2 ) AS col0 FROM tab1 AS cor0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT - + col0 AS col2 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT + col0 FROM tab0 GROUP BY col1, col0, col0

;

SELECT col2 AS col2 FROM tab2 GROUP BY col0, col0, col2

;

SELECT - col0 AS col0 FROM tab2 GROUP BY col0, col2, col1, col1

;

SELECT DISTINCT col0 AS col0 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT + col2 AS col2 FROM tab1 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT col1 AS col1 FROM tab2 GROUP BY col2, col1

;

SELECT col2 AS col2 FROM tab0 GROUP BY col2, col2

;

SELECT + col1 FROM tab0 GROUP BY col1, col1, col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT col0 FROM tab1 GROUP BY col2, col0

;

SELECT DISTINCT - col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT ALL + - col1 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT + col1 FROM tab2 GROUP BY col1, col1

;

SELECT ALL + col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col0, col0

;

SELECT ALL + - col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - - col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT col2 + + col2 * + - col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT col1, + col1 AS col1 FROM tab2 GROUP BY col1, col2

;

SELECT col1 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT ALL col0, col0 FROM tab1 GROUP BY col0, col2

;

SELECT ALL - col1 FROM tab2 AS cor0 GROUP BY col1 HAVING NULL IS NULL
;

SELECT + col1 FROM tab1 GROUP BY col1 HAVING NULL IS NULL
;

SELECT - col2, col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT col0 FROM tab2 AS cor0 WHERE NOT ( NULL ) <> NULL GROUP BY col0

;

SELECT ALL + col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL - col1 AS col0 FROM tab1 GROUP BY col2, col1, col1

;

SELECT + col0 AS col1 FROM tab0 GROUP BY col2, col1, col0 HAVING NULL IS NULL
;

SELECT + col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + col0 FROM tab0 GROUP BY col0, col0

;

SELECT ALL col0 FROM tab1 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT ALL col2 + + col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT col2 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT col1 FROM tab0 WHERE NOT ( NULL ) >= col1 GROUP BY col2, col1

;

SELECT - - col0 FROM tab2 cor0 GROUP BY col0

;

SELECT - col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL - + col1 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT + col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT DISTINCT - + col1 AS col0 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT ALL col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT - col1 * + col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col2 * - col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - + col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - col0 AS col2 FROM tab0 AS cor0 GROUP BY col0 HAVING NOT NULL <= NULL
;

SELECT col0 FROM tab2 GROUP BY col0, col1

;

SELECT ALL col1 AS col1 FROM tab1 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT - col1 FROM tab1 GROUP BY col1, col1

;

SELECT ALL + col1 FROM tab2 GROUP BY col0, col1

;

SELECT ALL - col0 * col0 AS col2 FROM tab1 GROUP BY col0, col2

;

SELECT - col2 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT + col0 - col0 + - col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + col1 AS col2, - col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT col2 AS col2 FROM tab0 GROUP BY col2, col1

;

SELECT col2 AS col0 FROM tab2 GROUP BY col0, col2, col0

;

SELECT DISTINCT - col1 AS col0, col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + col1 - - + col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT - col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT ALL - col2 * - + col2 FROM tab1 cor0 GROUP BY col2, col2

;

SELECT ALL + - col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT - col2, col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT ALL + col2 + - col2 * - + col2 AS col2 FROM tab0 GROUP BY col2 HAVING NULL < NULL
;

SELECT - + col2 + - col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT col1 + + col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT DISTINCT col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT ALL + col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT + col0 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT - col0 AS col2 FROM tab2 GROUP BY col0, col1

;

SELECT ALL col1 AS col1, - col1 FROM tab0 GROUP BY col1, col1 HAVING NOT NULL <> NULL
;

SELECT col1 AS col1 FROM tab0 GROUP BY col1 HAVING NOT ( NULL ) NOT IN ( + col1 )
;

SELECT DISTINCT - col0 FROM tab0 AS cor0 GROUP BY col0, col0 HAVING NULL IS NULL
;

SELECT ALL - - col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, col0 HAVING ( NULL ) <= NULL
;

SELECT ALL col2 FROM tab0 GROUP BY col2, col0

;

SELECT ALL col0 * - - col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col0 HAVING col0 IS NOT NULL
;

SELECT ALL - col0 FROM tab0 AS cor0 WHERE NULL IS NULL GROUP BY col0

;

SELECT ALL + col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + col2 * + col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + col0 * + + col0 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT col0 FROM tab2 GROUP BY col0, col0

;

SELECT DISTINCT - col0 AS col2 FROM tab2 cor0 GROUP BY col0

;

SELECT col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT - col0 FROM tab2 GROUP BY col1, col0

;

SELECT + col0 AS col0 FROM tab1 AS cor0 GROUP BY col0 HAVING NULL IS NULL
;

SELECT ALL - col0 AS col2 FROM tab2 AS cor0 GROUP BY col0 HAVING NULL = NULL
;

SELECT - col1, col1 FROM tab1 GROUP BY col1 HAVING NULL IS NULL
;

SELECT - + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - col0 AS col2 FROM tab0 GROUP BY col0, col2

;

SELECT col0 FROM tab2 AS cor0 GROUP BY col0 HAVING NULL IS NULL
;

SELECT - col0 AS col2 FROM tab0 GROUP BY col1, col0

;

SELECT ALL + col0 AS col2 FROM tab2 GROUP BY col0 HAVING + col0 IS NOT NULL
;

SELECT + col1 AS col0 FROM tab1 cor0 GROUP BY col1, col1

;

SELECT ALL col2 * col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT + col0 AS col0 FROM tab0 GROUP BY col0, col0

;

SELECT + col0 FROM tab2 GROUP BY col0, col1

;

SELECT ALL col2 * col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT - - col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - + col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, col1, col0

;

SELECT + col1 AS col1 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT + col2 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT ALL col0 FROM tab0 GROUP BY col0, col0

;

SELECT - col0 * + - col0 FROM tab0 GROUP BY col0, col0

;

SELECT col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT col2 FROM tab1 GROUP BY col1, col2

;

SELECT DISTINCT col2 FROM tab2 GROUP BY col2, col0 HAVING NOT NULL IS NULL
;

SELECT - col0 AS col0 FROM tab2 GROUP BY col1, col0

;

SELECT DISTINCT + col0 - - + col0 + - col2 AS col0 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT col1 * + col1 FROM tab0 AS cor0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT col2 FROM tab0 GROUP BY col2 HAVING col2 < - SUM ( DISTINCT - col0 )
;

SELECT DISTINCT + col1 FROM tab1 GROUP BY col1, col1

;

SELECT - col0 FROM tab0 cor0 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT + col2 FROM tab1 GROUP BY col0, col2

;

SELECT ALL - col0 AS col1 FROM tab1 GROUP BY col0, col1

;

SELECT col2 FROM tab2 GROUP BY col0, col2, col2

;

SELECT DISTINCT col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT + col1 FROM tab0 GROUP BY col1, col2

;

SELECT DISTINCT col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT DISTINCT col1 FROM tab0 GROUP BY col1, col0

;

SELECT DISTINCT + col0 AS col1 FROM tab0 GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT ALL - col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - col1 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT ALL - col1 AS col0 FROM tab1 GROUP BY col1, col1

;

SELECT DISTINCT + + col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + col1 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT ALL - - col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + col2 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT ALL + col1 FROM tab2 GROUP BY col1, col2

;

SELECT + + col0 * col2 AS col2 FROM tab1 AS cor0 GROUP BY col0, col2 HAVING NOT NULL IS NULL
;

SELECT + col2 AS col0 FROM tab2 GROUP BY col1, col2, col0

;

SELECT ALL - col0 * + col0 + + col0 FROM tab1 GROUP BY col0

;

SELECT + col2 AS col2 FROM tab0 GROUP BY col2, col1

;

SELECT DISTINCT - col2 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT - col2 * - - col2 FROM tab0 GROUP BY col2

;

SELECT - col1 AS col0 FROM tab1 GROUP BY col1, col1, col1 HAVING NOT NULL IS NULL
;

SELECT - col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + col1 AS col1 FROM tab2 GROUP BY col0, col1

;

SELECT col1 FROM tab2 GROUP BY col1, col1

;

SELECT DISTINCT col0 FROM tab2 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT - + col0 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT - col1 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT col1 * - col1 * + col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - + col2 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT - col0 * + + col1 AS col2 FROM tab2 GROUP BY col0, col1

;

SELECT col0 * + - col0 AS col0 FROM tab0 GROUP BY col0, col0 HAVING NOT NULL IS NOT NULL
;

SELECT + col1 AS col0 FROM tab0 GROUP BY col2, col1 HAVING - col1 IS NULL
;

SELECT DISTINCT - col2 * - col2 + - col2 AS col2 FROM tab1 GROUP BY col2, col2

;

SELECT col1, col1 FROM tab2 GROUP BY col1, col1

;

SELECT + - col1 * - col1 FROM tab0 cor0 GROUP BY col1

;

SELECT ALL + + col1 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - + col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT col0 * - col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT - col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + - col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT - SUM ( - col0 ) FROM tab0 GROUP BY col0 HAVING NULL < NULL
;

SELECT ALL + + col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, col2, col1

;

SELECT ALL + + col1 FROM tab1 cor0 GROUP BY col1, col1

;

SELECT + col2, col2 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + - col2 FROM tab1 AS cor0 GROUP BY col1, col1, col2

;

SELECT ALL - col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT ALL - + col2 FROM tab2 cor0 GROUP BY col2, col2

;

SELECT ALL - col1 AS col1 FROM tab1 GROUP BY col1, col2

;

SELECT DISTINCT col0, col1 FROM tab1 GROUP BY col1, col0

;

SELECT DISTINCT col0 + col2 FROM tab2 GROUP BY col0, col2

;

SELECT ALL + col1 AS col1 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT ALL + col2 FROM tab2 cor0 GROUP BY col1, col2

;

SELECT ALL col1 FROM tab0 AS cor0 GROUP BY col2, col0, col1

;

SELECT - col2 * - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + col0 AS col1 FROM tab0 GROUP BY col0, col0

;

SELECT DISTINCT - col1 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT ALL - + col1 AS col1 FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT - col1 AS col2 FROM tab1 GROUP BY col1, col0

;

SELECT ALL - col2 AS col2 FROM tab0 GROUP BY col2, col1 HAVING NULL IS NULL
;

SELECT - - col2 FROM tab0 cor0 GROUP BY col0, col2

;

SELECT col1 FROM tab0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT col1 AS col1 FROM tab1 GROUP BY col0, col1

;

SELECT + col1 * + col1 AS col0, col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col2 FROM tab1 GROUP BY col1, col2

;

SELECT ALL col2 FROM tab0 AS cor0 GROUP BY col2 HAVING NOT - col2 < NULL
;

SELECT ALL + col0 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL + col1 FROM tab0 GROUP BY col1, col0 HAVING NOT NULL IS NULL
;

SELECT ALL col1 + + col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT ALL + col0 FROM tab2 GROUP BY col0, col1

;

SELECT + col0 FROM tab1 AS cor0 GROUP BY col2, col2, col0

;

SELECT col2 + col1 FROM tab2 GROUP BY col1, col0, col2

;

SELECT DISTINCT + col2 AS col0 FROM tab2 AS cor0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT ALL col2 FROM tab0 AS cor0 GROUP BY col1, col2 HAVING NULL IS NULL
;

SELECT DISTINCT - col0 AS col2 FROM tab0 cor0 GROUP BY col1, col0, col1

;

SELECT ALL col0 FROM tab0 GROUP BY col0, col2 HAVING NOT NULL IS NOT NULL
;

SELECT ALL + col1 + col1 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT ALL col2 FROM tab1 GROUP BY col2, col0

;

SELECT col2 FROM tab1 GROUP BY col2, col1

;

SELECT ALL + col2 - + col2 AS col1 FROM tab2 GROUP BY col1, col2

;

SELECT DISTINCT + col0 + + col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col2 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT - col0 * - col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + + col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + - col0 + - + col0 AS col1, - col0 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT - + col2 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT col2 AS col2 FROM tab2 GROUP BY col2, col0 HAVING NULL IS NULL
;

SELECT ALL col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT col0 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT - col1 FROM tab2 AS cor0 GROUP BY col1, col1, col2

;

SELECT DISTINCT + + col0 FROM tab1 WHERE NOT NULL IS NOT NULL GROUP BY col0

;

SELECT DISTINCT - + col1 AS col0 FROM tab1 WHERE - + col1 IS NOT NULL GROUP BY col1, col0

;

SELECT + col1 AS col1 FROM tab2 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT + col0 AS col1 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT col0 AS col1 FROM tab1 GROUP BY col0 HAVING NOT col0 IS NULL
;

SELECT - col1 AS col0 FROM tab0 AS cor0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT - col0 FROM tab1 GROUP BY col0, col2

;

SELECT - + col2 FROM tab0 AS cor0 GROUP BY col2, col0 HAVING NULL > + - SUM ( col1 )
;

SELECT DISTINCT col0 FROM tab2 cor0 GROUP BY col0 HAVING NULL IS NULL
;

SELECT col1 * + + col1 * - - col1 FROM tab2 GROUP BY col1, col1

;

SELECT - - col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT col2 AS col2 FROM tab0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - + col2 AS col1 FROM tab2 AS cor0 GROUP BY col2 HAVING ( NULL ) IS NOT NULL
;

SELECT col0, col0 FROM tab1 GROUP BY col0

;

SELECT - col2 + - col2 FROM tab0 AS cor0 GROUP BY col2 HAVING ( col2 ) <> NULL
;

SELECT DISTINCT col0 - - col0 AS col1 FROM tab2 cor0 GROUP BY col0

;

SELECT ALL col0 * - + col0 * + - col0 FROM tab1 GROUP BY col0

;

SELECT col2 AS col2 FROM tab0 GROUP BY col0, col2

;

SELECT DISTINCT - col2 AS col2 FROM tab0 cor0 GROUP BY col2, col2 HAVING NULL IS NOT NULL
;

SELECT - col2 FROM tab2 AS cor0 GROUP BY col2, col1, col2 HAVING ( NULL ) IS NULL
;

SELECT + - col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - col0 AS col2 FROM tab2 AS cor0 GROUP BY col1, col0, col0

;

SELECT ALL + col0 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT + col1 AS col0, col2 AS col0 FROM tab0 AS cor0 WHERE NOT ( NULL ) IS NULL GROUP BY col2, col1

;

SELECT col2 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT col2 AS col1 FROM tab1 GROUP BY col1, col2 HAVING NULL IS NULL
;

SELECT + col1 AS col2 FROM tab2 cor0 WHERE NOT NULL IS NOT NULL GROUP BY col1

;

SELECT DISTINCT - col0 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT col0 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT col0 FROM tab0 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT + + col1 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT ALL col2 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT + SUM ( + col0 ) * - col0 FROM tab0 AS cor0 GROUP BY col0, col0 HAVING NULL > + col0
;

SELECT DISTINCT col2 + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + col2 FROM tab1 GROUP BY col2, col2

;

SELECT + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col1, col1

;

SELECT DISTINCT - col2 AS col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT - col0 AS col1 FROM tab0 GROUP BY col0, col1

;

SELECT ALL + col2 + - - col2 FROM tab1 AS cor0 GROUP BY col2, col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT + - col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - - col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - col2 FROM tab2 GROUP BY col1, col2

;

SELECT DISTINCT col0 FROM tab0 cor0 GROUP BY col0, col2

;

SELECT + col1 FROM tab2 cor0 GROUP BY col0, col1, col1

;

SELECT - col2 AS col2 FROM tab0 cor0 GROUP BY col2, col1

;

SELECT ALL + - col2 + + - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, col2 HAVING NOT NULL IS NOT NULL
;

SELECT + col2 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT ALL + col0 AS col1 FROM tab1 GROUP BY col0, col0

;

SELECT ALL - col0 AS col1 FROM tab1 cor0 GROUP BY col0, col2

;

SELECT DISTINCT col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT ALL + col1 * - col1 * + - col1 FROM tab0 GROUP BY col1

;

SELECT ALL + col1 * + col1 FROM tab1 AS cor0 GROUP BY col1, col0, col1

;

SELECT ALL + - col1 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT col2 - col2 * col2 FROM tab1 cor0 GROUP BY col2

;

SELECT DISTINCT + col2 + col1 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT - + col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT + col0 FROM tab0 GROUP BY col2, col0

;

SELECT - col0 FROM tab2 GROUP BY col0, col0

;

SELECT - col0 FROM tab1 GROUP BY col2, col0

;

SELECT DISTINCT col1 + col1 FROM tab0 GROUP BY col1 HAVING ( NULL ) IS NOT NULL
;

SELECT DISTINCT - col1 + col1 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - - col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + col2, col2 AS col1 FROM tab0 AS cor0 GROUP BY col2 HAVING NULL = NULL
;

SELECT ALL + col1 AS col1 FROM tab1 cor0 GROUP BY col0, col1

;

SELECT DISTINCT - col1 AS col0 FROM tab1 AS cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT col0 FROM tab0 GROUP BY col0 HAVING NOT ( NOT NULL IS NULL )
;

SELECT col2 FROM tab1 AS cor0 WHERE NOT col2 = col1 + col1 GROUP BY col1, col2

;

SELECT - + col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT col0, - col0 FROM tab0 cor0 WHERE ( NULL ) IN ( + col0 ) GROUP BY col0

;

SELECT col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - col0 FROM tab2 cor0 GROUP BY col0

;

SELECT col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT ALL col2 AS col2 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT + col1 AS col1 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT ALL + col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT ALL col2 * col1 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT ALL + + col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT ALL + + col0 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT + col1 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT col1 FROM tab0 GROUP BY col2, col1

;

SELECT + col0 FROM tab1 GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT col1 FROM tab1 GROUP BY col0, col1

;

SELECT - col0 * col0 FROM tab2 GROUP BY col0

;

SELECT ALL - col1 AS col1 FROM tab1 GROUP BY col2, col1

;

SELECT DISTINCT + col0 FROM tab0 AS cor0 GROUP BY col0 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT DISTINCT col0 FROM tab0 GROUP BY col2, col0

;

SELECT - col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT ALL + col1 FROM tab1 WHERE NOT NULL IS NOT NULL GROUP BY col2, col1

;

SELECT + col1 FROM tab2 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT col1 * + + col1 FROM tab0 GROUP BY col1

;

SELECT ALL + col0 FROM tab1 GROUP BY col2, col0

;

SELECT col0 + - col0 FROM tab2 GROUP BY col0

;

SELECT ALL col0 + + col0 FROM tab2 cor0 GROUP BY col0

;

SELECT ALL col2 FROM tab0 GROUP BY col2, col2

;

SELECT - col2 FROM tab1 GROUP BY col1, col2

;

SELECT DISTINCT + - col0 FROM tab0 WHERE NOT NULL < NULL GROUP BY col0

;

SELECT - - col2 + - col2 AS col0 FROM tab2 AS cor0 WHERE NOT NULL BETWEEN col0 AND NULL GROUP BY col2

;

SELECT ALL - col2 * - col2 + + col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL - col1 FROM tab0 WHERE NOT NULL NOT BETWEEN - col2 AND + - col2 GROUP BY col1

;

SELECT DISTINCT + col0 - - + col0 FROM tab0 GROUP BY col0, col2

;

SELECT ALL + col0 FROM tab0 GROUP BY col0, col0, col1

;

SELECT DISTINCT col0 FROM tab2 GROUP BY col2, col0

;

SELECT - col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT + + col1 FROM tab0 cor0 GROUP BY col2, col1, col1

;

SELECT + col2 FROM tab0 GROUP BY col2, col0

;

SELECT + col1 + + col2 AS col1 FROM tab0 GROUP BY col1, col2

;

SELECT ALL col2 FROM tab2 GROUP BY col2, col2

;

SELECT - col0 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT ALL col1 FROM tab2 GROUP BY col1, col0, col1

;

SELECT - col1 FROM tab2 GROUP BY col0, col0, col1

;

SELECT ALL col0 * + col0 FROM tab0 GROUP BY col0, col1

;

SELECT ALL - col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT - - col2, col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - + col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT col0 FROM tab1 GROUP BY col0, col2, col1

;

SELECT ALL col0 AS col1 FROM tab0 GROUP BY col0 HAVING NULL IS NULL
;

SELECT DISTINCT - col1 * - - col1 AS col1 FROM tab0 AS cor0 WHERE ( NULL ) IS NOT NULL GROUP BY col1

;

SELECT DISTINCT col0 AS col1 FROM tab1 GROUP BY col2, col0

;

SELECT ALL - col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT + col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT - - col2 AS col0 FROM tab0 cor0 GROUP BY col2

;

SELECT ALL - - col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT col1 FROM tab2 GROUP BY col1 HAVING ( NULL ) > NULL
;

SELECT DISTINCT SUM ( + col2 ) AS col1 FROM tab2 GROUP BY col2 HAVING NULL <> - col2
;

SELECT ALL - col2 AS col1 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL + col0, col0 FROM tab1 GROUP BY col0

;

SELECT ALL + col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL - + col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT col2 AS col2 FROM tab1 WHERE NULL IS NULL GROUP BY col2

;

SELECT col0 FROM tab2 GROUP BY col1, col0, col1

;

SELECT + col2 * col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT col1 FROM tab2 GROUP BY col1 HAVING ( NULL ) <= NULL
;

SELECT + - col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + col1 FROM tab2 GROUP BY col0, col1

;

SELECT DISTINCT col2 AS col2 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT ALL + + col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + col2, + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col1 AS col1 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT col0 AS col0 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT - col1 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT - - col1 FROM tab0 AS cor0 GROUP BY col0, col1, col1 HAVING NOT - - col1 IS NOT NULL
;

SELECT col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT ALL - + col0 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL col1 AS col1 FROM tab2 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT col1 * - col1 AS col0 FROM tab0 GROUP BY col0, col1, col2

;

SELECT col2 AS col0 FROM tab2 GROUP BY col2, col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT col1 AS col1 FROM tab0 GROUP BY col2, col0, col1

;

SELECT - + col0 * + + col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL col2 * + col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT + - col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col1 HAVING NOT NULL IS NOT NULL
;

SELECT ALL - col1 FROM tab2 GROUP BY col1, col1

;

SELECT + col1 FROM tab2 GROUP BY col1, col2

;

SELECT col0 AS col2 FROM tab1 GROUP BY col2, col0

;

SELECT ALL col2 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT + col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT - col0 + + col1 FROM tab2 AS cor0 GROUP BY col0, col1 HAVING NULL IS NULL
;

SELECT ALL col2 FROM tab0 GROUP BY col1, col2

;

SELECT col1 * + col1 * + col1 + - col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL + col1 * + col1 + - col1 FROM tab1 AS cor0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT + col1 AS col2 FROM tab0 GROUP BY col2, col1, col2

;

SELECT + col2 + col2 - - col2 FROM tab1 AS cor0 WHERE NOT col2 IS NOT NULL GROUP BY col2, col2, col2

;

SELECT ALL + + col1 FROM tab1 cor0 WHERE col0 IS NULL GROUP BY col1

;

SELECT DISTINCT col0 FROM tab2 GROUP BY col0, col2

;

SELECT - - col0 FROM tab1 AS cor0 WHERE NOT NULL > col1 GROUP BY col0

;

SELECT + col2 * + col2 + - col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT col2 FROM tab0 GROUP BY col2, col1

;

SELECT - col2 AS col1 FROM tab1 GROUP BY col2 HAVING NULL = col2
;

SELECT + - col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + + col0 FROM tab2 AS cor0 WHERE NOT col1 IS NOT NULL GROUP BY col0, col0

;

SELECT + col1 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT + col1 - - + col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT + col2 AS col2 FROM tab2 cor0 GROUP BY col2, col2

;

SELECT ALL col1 AS col1 FROM tab0 cor0 GROUP BY col1

;

SELECT + col2 AS col2 FROM tab2 GROUP BY col2, col1, col2

;

SELECT DISTINCT + col0 FROM tab0 GROUP BY col2, col0 HAVING NOT NULL IS NULL
;

SELECT + - col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT col0 + col0 - - col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT + col2 * - col2 FROM tab1 GROUP BY col2

;

SELECT ALL + col1 + + col1 FROM tab2 GROUP BY col1, col1

;

SELECT + + col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - col0 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT col1 FROM tab1 WHERE col0 IS NULL GROUP BY col0, col1

;

SELECT - + col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col1 AS col1 FROM tab1 cor0 GROUP BY col1

;

SELECT ALL - col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + col2 / + col2 / - - col1 / - col1 + - col1 FROM tab1 GROUP BY col2, col1 HAVING NULL <> - col2
;

SELECT ALL col2 AS col0 FROM tab2 GROUP BY col2, col0, col0

;

SELECT + + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL - col2 AS col0 FROM tab0 GROUP BY col2, col2

;

SELECT DISTINCT col0 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT col1 FROM tab1 AS cor0 WHERE NULL IS NULL GROUP BY col1, col0

;

SELECT col1, col1 AS col1 FROM tab2 GROUP BY col1 HAVING ( NULL ) IS NOT NULL
;

SELECT + - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT + col1 + + col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT - col0 AS col2 FROM tab1 cor0 GROUP BY col0

;

SELECT col1 FROM tab2 GROUP BY col1, col0

;

SELECT ALL - col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + col2 AS col1, col2 FROM tab2 cor0 GROUP BY col2, col2

;

SELECT ALL col1 * + + col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT ALL + - col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL col1 FROM tab0 GROUP BY col1, col1, col2

;

SELECT col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT - col2 AS col2 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT + col1 FROM tab0 AS cor0 WHERE ( NULL ) IS NULL GROUP BY col1

;

SELECT + col0 FROM tab1 GROUP BY col0, col0

;

SELECT ALL col0 FROM tab1 GROUP BY col0, col1

;

SELECT - - col2 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT ALL + col2 AS col1 FROM tab2 GROUP BY col0, col2, col2

;

SELECT DISTINCT + - col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT - col1 FROM tab1 cor0 GROUP BY col1

;

SELECT col1 * + col1 FROM tab1 AS cor0 WHERE NULL IS NULL GROUP BY col1

;

SELECT ALL col1 FROM tab2 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT col1 AS col2, col1 + - col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT - col0 AS col0 FROM tab2 cor0 GROUP BY col0

;

SELECT + col0 AS col0 FROM tab2 GROUP BY col0, col0

;

SELECT DISTINCT - col1 AS col2 FROM tab1 GROUP BY col1, col0 HAVING NULL IS NOT NULL
;

SELECT DISTINCT col0 AS col0, + col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT + col0 FROM tab1 GROUP BY col1, col0

;

SELECT DISTINCT - col2 FROM tab2 cor0 GROUP BY col2

;

SELECT - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col2 AS col2 FROM tab0 cor0 GROUP BY col2

;

SELECT ALL - col2 AS col1 FROM tab0 GROUP BY col2, col0 HAVING col0 BETWEEN - col2 AND ( NULL )
;

SELECT - col1 AS col1 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT + - col0 + + col0 FROM tab0 AS cor0 GROUP BY col0 HAVING NULL IS NULL
;

SELECT + col1 AS col1 FROM tab0 GROUP BY col1, col2

;

SELECT DISTINCT + - col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + - col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT col2 AS col2 FROM tab2 GROUP BY col2, col1

;

SELECT DISTINCT col2 FROM tab2 GROUP BY col1, col2

;

SELECT col0 * col0 FROM tab1 GROUP BY col0, col0, col1

;

SELECT DISTINCT + - col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL - col1 * + col0 FROM tab2 GROUP BY col0, col1

;

SELECT - col0 * + col0 + + col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT - col0 AS col0 FROM tab2 AS cor0 WHERE + col1 IS NOT NULL GROUP BY col1, col0

;

SELECT - - col2 AS col2 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT col1 FROM tab1 WHERE NOT NULL <> NULL GROUP BY col1

;

SELECT ALL - col0 * + - col0 * + col0 FROM tab1 GROUP BY col0

;

SELECT ALL col1 FROM tab2 GROUP BY col2, col1

;

SELECT col1 AS col1, col1 * + - col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT - col2 AS col0 FROM tab2 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT - col1, col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - col0 * + + col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT + - col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + - SUM ( ALL - col1 ) + + - col1 AS col2 FROM tab0 cor0 GROUP BY col1, col1 HAVING NOT NULL IS NULL
;

SELECT ALL - + col1 AS col2 FROM tab2 AS cor0 GROUP BY col1, col2, col0

;

SELECT ALL + col0 AS col0 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT + + col0 + col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL + + col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT col0 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT - col2 + + col2 FROM tab0 GROUP BY col0, col1, col2 HAVING NOT col2 IS NOT NULL
;

SELECT DISTINCT col0 AS col2 FROM tab2 AS cor0 GROUP BY col2, col0, col0

;

SELECT ALL - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT - col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT ALL + + col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT SUM ( col2 ) * col2 FROM tab2 GROUP BY col2, col2, col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - col2 AS col0 FROM tab2 GROUP BY col2, col2

;

SELECT - col2 - + + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT col1 + + - col1 FROM tab2 GROUP BY col1

;

SELECT + col0 FROM tab2 cor0 GROUP BY col0

;

SELECT ALL col0 AS col1 FROM tab0 GROUP BY col2, col0

;

SELECT - col0 FROM tab2 GROUP BY col0, col0 HAVING NOT NULL IS NOT NULL
;

SELECT + col1 FROM tab0 AS cor0 GROUP BY col1 HAVING NULL <= NULL
;

SELECT + col1 AS col0 FROM tab2 GROUP BY col0, col1

;

SELECT - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT ALL - col1 FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT col1 AS col2 FROM tab1 GROUP BY col1, col0

;

SELECT + - col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col1 AS col0 FROM tab2 GROUP BY col1, col1

;

SELECT DISTINCT col2 AS col1 FROM tab0 WHERE NOT col2 <> col0 GROUP BY col2, col2, col2

;

SELECT ALL + + col0 FROM tab0 cor0 GROUP BY col0

;

SELECT + col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, col1 HAVING NULL IS NOT NULL
;

SELECT ALL - col0 AS col1 FROM tab2 GROUP BY col0, col2, col0

;

SELECT ALL + + col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL col0 + col0 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - col2 + - col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT - - col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col0 HAVING - col0 * col0 BETWEEN NULL AND ( col0 )
;

SELECT ALL - col1 FROM tab2 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT col2 FROM tab1 GROUP BY col0, col2

;

SELECT DISTINCT - col0 FROM tab0 GROUP BY col0, col2

;

SELECT ALL - - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + col2, + col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT + col1 AS col1 FROM tab1 cor0 GROUP BY col1, col2

;

SELECT ALL + col0 + + col0 + + - col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL + + col1 FROM tab2 AS cor0 GROUP BY col1, col0, col1

;

SELECT DISTINCT col2 FROM tab0 GROUP BY col0, col2

;

SELECT ALL + + col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL col2 FROM tab0 GROUP BY col2, col1

;

SELECT col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT ALL col0 FROM tab2 GROUP BY col0

;

SELECT ALL - col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT + col2 AS col2 FROM tab1 AS cor0 GROUP BY col0, col2, col2 HAVING NULL IS NOT NULL
;

SELECT ALL col2 AS col2 FROM tab0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT - col0 + col0 FROM tab2 cor0 GROUP BY col0

;

SELECT + col2 FROM tab0 GROUP BY col2, col2 HAVING NOT NULL > NULL
;

SELECT ALL + + col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + col1 AS col0 FROM tab1 GROUP BY col1, col0

;

SELECT + col0 AS col0 FROM tab0 GROUP BY col2, col0, col0 HAVING - col0 < NULL
;

SELECT DISTINCT + + col2 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL col2 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT - col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT + col1 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + col2 + col2 AS col0 FROM tab0 AS cor0 WHERE NOT - col2 IS NULL GROUP BY col2

;

SELECT - col2 AS col1 FROM tab0 AS cor0 WHERE NOT ( NULL ) IS NULL GROUP BY col2

;

SELECT col1 + - - col1 FROM tab1 GROUP BY col1

;

SELECT ALL + col2 * col2 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT - col1 FROM tab1 cor0 GROUP BY col0, col0, col1

;

SELECT col2 * + col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT ALL - col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT col2 AS col1 FROM tab1 cor0 GROUP BY col2

;

SELECT + col2 * - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT col1 FROM tab2 AS cor0 WHERE NOT NULL IS NULL GROUP BY col1

;

SELECT ALL col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col1, col0

;

SELECT col2 * + + col2 AS col0 FROM tab1 GROUP BY col0, col2, col1

;

SELECT col0 + col0 * + + col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT col0 FROM tab2 cor0 GROUP BY col0, col1

;

SELECT ALL - col1 FROM tab1 GROUP BY col2, col2, col1

;

SELECT DISTINCT - col2 - col2 FROM tab0 GROUP BY col2

;

SELECT + col0 AS col1 FROM tab2 GROUP BY col0, col0

;

SELECT ALL - + col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col0 HAVING NOT NULL > ( NULL )
;

SELECT ALL + col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT col1 FROM tab0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT col1 AS col0 FROM tab1 GROUP BY col1 HAVING - col1 <= NULL
;

SELECT ALL col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT col1 * + col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - + col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT + col0 AS col0 FROM tab2 GROUP BY col0 HAVING NULL IS NULL
;

SELECT ALL - col2 AS col0 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT ALL + col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT + col1 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT col1 FROM tab2 GROUP BY col1 HAVING NULL IS NULL
;

SELECT - col1 AS col2 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT col1 AS col1 FROM tab0 GROUP BY col1, col1

;

SELECT col2 FROM tab1 GROUP BY col0, col2 HAVING NOT NULL <> - col2
;

SELECT ALL col2 AS col0 FROM tab0 AS cor0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT ALL + - col0 FROM tab2 AS cor0 WHERE NOT - col0 IS NOT NULL GROUP BY col1, col0

;

SELECT DISTINCT + col1 FROM tab0 GROUP BY col1, col1

;

SELECT DISTINCT col1 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT - + col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, col1 HAVING NOT - - col1 IS NULL
;

SELECT ALL col0 AS col2 FROM tab0 GROUP BY col2, col0, col0

;

SELECT col0 * + col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + col1 * col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL col0 FROM tab1 GROUP BY col2, col0

;

SELECT + col2 * col2 FROM tab2 GROUP BY col2

;

SELECT + col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - col1 AS col0 FROM tab1 GROUP BY col2, col1

;

SELECT DISTINCT - - SUM ( ALL + col2 ) FROM tab2 AS cor0 WHERE - col1 IS NULL GROUP BY col2

;

SELECT ALL + col0 FROM tab2 cor0 GROUP BY col2, col0

;

SELECT DISTINCT col1 AS col1 FROM tab1 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT col1 + - col2 FROM tab0 GROUP BY col2, col1

;

SELECT DISTINCT col1 - + col1 FROM tab2 cor0 WHERE NOT NULL IS NOT NULL GROUP BY col1

;

SELECT col1 + col1 * - col1 + - col1 FROM tab1 GROUP BY col1

;

SELECT - col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT col2 FROM tab1 AS cor0 GROUP BY col2 HAVING NOT col2 < NULL
;

SELECT col0 FROM tab2 GROUP BY col0 HAVING NOT - - col0 <> NULL
;

SELECT ALL - col1 * col1 AS col0 FROM tab0 AS cor0 GROUP BY col1 HAVING NOT NULL <= NULL
;

SELECT DISTINCT - col1 FROM tab2 GROUP BY col1, col1

;

SELECT ALL col1 FROM tab1 GROUP BY col1, col1

;

SELECT DISTINCT col2 + - col0 * - col2 AS col1 FROM tab2 GROUP BY col2, col0

;

SELECT DISTINCT col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT ALL + col0 AS col2 FROM tab1 GROUP BY col0, col0

;

SELECT ALL + col1, + col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT - col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL col2 FROM tab0 GROUP BY col0, col2

;

SELECT col0 FROM tab0 cor0 GROUP BY col0, col1

;

SELECT ALL col0 FROM tab1 GROUP BY col1, col0

;

SELECT DISTINCT - col0 AS col0 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT + - col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT + + col1 FROM tab1 AS cor0 GROUP BY col2, col1 HAVING - col1 IS NOT NULL
;

SELECT - col2 AS col0 FROM tab0 GROUP BY col2, col2

;

SELECT DISTINCT + col2 * - col1 FROM tab0 GROUP BY col1, col2, col0 HAVING NULL IS NOT NULL
;

SELECT - - col1 AS col2 FROM tab0 AS cor0 GROUP BY col1 HAVING NULL IS NULL
;

SELECT DISTINCT + col1 * - col1 - + col1 + + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT - col1 FROM tab2 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT col1 / + - col1 AS col2 FROM tab0 AS cor0 GROUP BY col1 HAVING NULL BETWEEN NULL AND NULL
;

SELECT - - col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - + col2 AS col2 FROM tab2 AS cor0 WHERE NOT - col2 > NULL GROUP BY col2, col2, col0

;

SELECT col2 FROM tab1 WHERE + + col1 IS NOT NULL GROUP BY col2, col2

;

SELECT ALL + col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT DISTINCT col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT + col2 FROM tab2 AS cor0 WHERE ( NULL ) IS NULL GROUP BY col2

;

SELECT DISTINCT col0 AS col0 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT col2 FROM tab1 GROUP BY col2, col2

;

SELECT + col1 FROM tab2 AS cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - col2 FROM tab1 AS cor0 GROUP BY col1, col2 HAVING + col2 NOT BETWEEN - col2 AND NULL
;

SELECT - col0 * + - col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT col0 AS col1 FROM tab2 GROUP BY col1, col0

;

SELECT DISTINCT col0 AS col0 FROM tab0 cor0 GROUP BY col0

;

SELECT + col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT col1 AS col0 FROM tab1 GROUP BY col1 HAVING NOT NULL >= NULL
;

SELECT col2 AS col1 FROM tab0 WHERE NOT NULL NOT BETWEEN NULL AND NULL GROUP BY col2

;

SELECT + + col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + col1 + - + col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT col0 AS col2 FROM tab2 GROUP BY col0, col0, col1

;

SELECT - + col2 FROM tab2 AS cor0 WHERE col2 IS NULL GROUP BY col2, col2, col1

;

SELECT DISTINCT - col2 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT ALL col1 AS col1 FROM tab0 GROUP BY col0, col1

;

SELECT col2 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT + col2 * col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT col0 AS col2 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT - col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT col2 AS col1, + col2 FROM tab2 AS cor0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT ALL + col0 AS col2 FROM tab2 GROUP BY col0, col2

;

SELECT col2 AS col0 FROM tab1 GROUP BY col0, col2

;

SELECT DISTINCT col1 AS col0 FROM tab1 GROUP BY col2, col1

;

SELECT col0 AS col1 FROM tab1 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT + col1 FROM tab1 GROUP BY col1

;

SELECT ALL - SUM ( DISTINCT + col1 ) + - SUM ( + col1 ) FROM tab0 GROUP BY col0, col1, col1 HAVING NOT NULL BETWEEN NULL AND NULL
;

SELECT DISTINCT col1 + - col1 FROM tab2 GROUP BY col1

;

SELECT col1 + col0 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT + - col1 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - - col2 AS col0 FROM tab1 AS cor0 GROUP BY col2 HAVING ( NULL ) <> NULL
;

SELECT ALL + col2 FROM tab0 AS cor0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT - col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col1 HAVING NULL IS NULL
;

SELECT DISTINCT - - col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + col0 + + col1 + + col1 FROM tab1 GROUP BY col1, col0

;

SELECT col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT ALL + col2 - - - col2 FROM tab1 GROUP BY col2, col2

;

SELECT DISTINCT - col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - col0 AS col0, col2 FROM tab2 AS cor0 GROUP BY col0, col1, col2

;

SELECT DISTINCT col0 - - + col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col2 AS col2, + col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + col1 FROM tab0 GROUP BY col1, col1 HAVING col1 IS NOT NULL
;

SELECT DISTINCT - - col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT col1 AS col2 FROM tab1 WHERE NULL >= NULL GROUP BY col1

;

SELECT ALL + col1 FROM tab1 WHERE NULL IS NOT NULL GROUP BY col1

;

SELECT - - col0 + - col0 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT - - col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + col1 FROM tab0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT + + col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - - col2 AS col1 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT + + col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT ALL col1 FROM tab2 GROUP BY col0, col1

;

SELECT - col2 - - col2 FROM tab0 AS cor0 GROUP BY col2, col2 HAVING NULL IS NULL
;

SELECT + col0 FROM tab1 GROUP BY col0, col2

;

SELECT ALL - col1 + - + col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT ALL - col2 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL - col2 FROM tab1 AS cor0 WHERE NOT ( NULL ) IS NOT NULL GROUP BY col2, col1 HAVING + col1 * + + col2 + + - col2 IS NOT NULL
;

SELECT col1 FROM tab1 GROUP BY col1, col0, col0

;

SELECT + col0 FROM tab2 GROUP BY col0, col0

;

SELECT DISTINCT + col1 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT - + col1, + col1 AS col0 FROM tab1 AS cor0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT - col0 AS col1, col0 FROM tab2 cor0 GROUP BY col0

;

SELECT - + col0 AS col2, - col0 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT + + col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT ALL - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT col0, - col0 * + - col0 FROM tab1 GROUP BY col0

;

SELECT ALL col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT - col1 AS col0 FROM tab1 AS cor0 GROUP BY col1 HAVING + + col1 IS NULL
;

SELECT ALL + col2 FROM tab0 GROUP BY col2, col2, col0 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT col0 FROM tab0 AS cor0 WHERE NULL >= NULL GROUP BY col0

;

SELECT col0 FROM tab1 GROUP BY col2, col0

;

SELECT - col2 * col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - col1 + + col1 FROM tab2 GROUP BY col1, col1 HAVING NULL IS NULL
;

SELECT + - col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT col1 AS col0 FROM tab0 GROUP BY col1, col1 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT ALL col1 FROM tab1 GROUP BY col0, col1

;

SELECT DISTINCT col0 FROM tab2 cor0 GROUP BY col0

;

SELECT DISTINCT col1 AS col0 FROM tab1 GROUP BY col1, col1

;

SELECT + - col2 AS col2 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT - col2 - - - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT col1 AS col0 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT - col2 FROM tab0 GROUP BY col2, col1

;

SELECT + col0 AS col0 FROM tab1 GROUP BY col0, col0

;

SELECT col1 FROM tab0 AS cor0 GROUP BY col1, col1 HAVING + - col1 IS NOT NULL
;

SELECT + col2 FROM tab1 cor0 GROUP BY col2

;

SELECT + col0 FROM tab2 GROUP BY col0, col0, col0

;

SELECT ALL + col2 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT col2 AS col1 FROM tab1 GROUP BY col2, col2

;

SELECT col0, - col0 FROM tab1 GROUP BY col0, col0

;

SELECT - col1 AS col0 FROM tab2 GROUP BY col0, col1 HAVING col0 IS NOT NULL
;

SELECT ALL + - col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL + - col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT ALL col2 * - - col2 AS col2 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT col1 AS col2 FROM tab1 GROUP BY col1, col0

;

SELECT ALL - col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT ALL + col2 FROM tab2 GROUP BY col2, col2

;

SELECT + col1 FROM tab0 GROUP BY col1, col1

;

SELECT ALL col0 * - + col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - col2 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT + + col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT + col1 * - col1 FROM tab1 AS cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT + + col2 * - col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT col2 AS col0 FROM tab2 GROUP BY col0, col2

;

SELECT DISTINCT + col0 + col1 FROM tab0 GROUP BY col1, col0

;

SELECT + col0 AS col1 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT col2 * col2 * col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT col1 * col1 FROM tab1 AS cor0 GROUP BY col1 HAVING NULL NOT BETWEEN NULL AND NULL
;

SELECT SUM ( + col1 ) FROM tab0 AS cor0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT col2 AS col2 FROM tab2 GROUP BY col2, col2

;

SELECT ALL - col1 AS col1 FROM tab2 GROUP BY col1, col2

;

SELECT - col2 / + col2 FROM tab1 WHERE ( NULL ) IS NOT NULL GROUP BY col2

;

SELECT + col0 + + col0 + col0 AS col2 FROM tab1 GROUP BY col0, col0

;

SELECT + col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL col1 FROM tab2 GROUP BY col0, col1 HAVING - - col1 IS NULL
;

SELECT + col1 AS col2 FROM tab1 cor0 GROUP BY col1

;

SELECT ALL + col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + col0 FROM tab0 GROUP BY col0, col0

;

SELECT + col2 + - col2 AS col1, + col2 FROM tab2 GROUP BY col2, col0

;

SELECT DISTINCT - col1 AS col1 FROM tab1 GROUP BY col2, col2, col1

;

SELECT ALL - + col1 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + col2 FROM tab1 cor0 GROUP BY col2, col2

;

SELECT col0 - + col1 AS col0 FROM tab1 GROUP BY col1, col0, col1, col0 HAVING NOT NULL IS NULL
;

SELECT + col2 AS col2 FROM tab2 AS cor0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT col2 * + col2 FROM tab2 AS cor0 WHERE ( col1 + + - col0 ) IS NULL GROUP BY col2 HAVING ( NULL ) NOT BETWEEN ( SUM ( col0 ) ) AND ( NULL )
;

SELECT col2 FROM tab2 AS cor0 WHERE NULL < NULL GROUP BY col2

;

SELECT DISTINCT col0 AS col1 FROM tab0 AS cor0 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT ALL - + col0 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT ALL + col0 AS col0 FROM tab0 GROUP BY col0, col0, col2

;

SELECT - col2 AS col0 FROM tab1 GROUP BY col2, col2

;

SELECT ALL - + col1 + col1 FROM tab1 AS cor0 GROUP BY col1, col0, col1

;

SELECT ALL col2 AS col2 FROM tab1 GROUP BY col2, col2

;

SELECT + + col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT col0, col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT ALL + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT col2 AS col1 FROM tab1 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT ALL col2 + + col2 AS col1 FROM tab0 GROUP BY col2, col0

;

SELECT ALL col2 AS col0 FROM tab1 GROUP BY col1, col2

;

SELECT DISTINCT - col0 * - + col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + col1 FROM tab1 cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT ALL - col0 FROM tab2 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT DISTINCT + + col0 * - col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT col1 AS col2 FROM tab0 GROUP BY col1, col1

;

SELECT ALL + - col1 FROM tab1 AS cor0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT col0 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + col1 FROM tab0 GROUP BY col1, col1, col1 HAVING NOT col1 NOT BETWEEN NULL AND ( NULL )
;

SELECT DISTINCT - col2 * - col2 AS col0 FROM tab0 GROUP BY col2, col1

;

SELECT ALL col1 AS col0 FROM tab1 GROUP BY col1, col2 HAVING NOT + col1 IS NOT NULL
;

SELECT ALL - col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - col2 - + col2 * + col2 FROM tab1 GROUP BY col2

;

SELECT + + col1 + - col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT col0 * col2 AS col0, col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT + col0 AS col0 FROM tab2 GROUP BY col1, col0

;

SELECT + col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT ALL col0 AS col1 FROM tab1 GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT - col1 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT + col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, col2 HAVING + - SUM ( col0 ) IS NOT NULL
;

SELECT - col2 - - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT col0 FROM tab0 GROUP BY col2, col0

;

SELECT col1 AS col1 FROM tab0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT + + col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT col0 AS col0 FROM tab1 GROUP BY col2, col0

;

SELECT ALL col0 AS col0 FROM tab1 AS cor0 GROUP BY col1, col0, col2

;

SELECT - col2 AS col2 FROM tab2 AS cor0 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT + col2 AS col1 FROM tab2 GROUP BY col1, col2

;

SELECT ALL + col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT - col2 + + col1 FROM tab2 cor0 GROUP BY col1, col2

;

SELECT ALL + col1 FROM tab0 GROUP BY col1, col2

;

SELECT ALL + col1 FROM tab2 GROUP BY col1, col1

;

SELECT DISTINCT col1 + + col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT ALL col0 FROM tab0 GROUP BY col1, col0

;

SELECT col2 FROM tab1 cor0 GROUP BY col2

;

SELECT col1 AS col1 FROM tab0 GROUP BY col1, col2

;

SELECT ALL + col2 * + col2 * - col2 * - - col2 FROM tab1 GROUP BY col2

;

SELECT col0, - col0 + - col0 AS col1 FROM tab0 cor0 GROUP BY col0, col0

;

SELECT ALL + col1 AS col2 FROM tab0 AS cor0 GROUP BY col1 HAVING NULL IS NULL
;

SELECT col0 FROM tab0 GROUP BY col1, col0

;

SELECT col2 - col2 FROM tab1 GROUP BY col1, col2, col2

;

SELECT + col2 FROM tab0 cor0 GROUP BY col2, col1

;

SELECT - + col0 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT col2 FROM tab0 GROUP BY col2, col0

;

SELECT DISTINCT col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT + col0 * col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT col0 AS col2 FROM tab1 GROUP BY col0 HAVING NULL <> NULL
;

SELECT col0 + + + col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT col0 FROM tab1 GROUP BY col0, col1

;

SELECT - col1 * - - col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT ALL - col0 FROM tab0 AS cor0 GROUP BY col0, col0 HAVING col0 IS NULL
;

SELECT - + col1 FROM tab0 AS cor0 GROUP BY col1, col1, col1

;

SELECT DISTINCT - col2 AS col2 FROM tab0 GROUP BY col2, col2

;

SELECT - + col0 AS col1 FROM tab0 AS cor0 GROUP BY col0 HAVING NULL < NULL
;

SELECT col0 + col0 AS col2 FROM tab0 GROUP BY col0, col0

;

SELECT ALL - col2 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT ALL + col1 FROM tab2 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT - col0 AS col2 FROM tab1 GROUP BY col0, col0

;

SELECT ALL + col0 * - - col2 FROM tab1 GROUP BY col0, col2

;

SELECT DISTINCT col0 AS col1, col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + col1 FROM tab2 AS cor0 GROUP BY col2, col1 HAVING NOT NULL <= NULL
;

SELECT - col2 FROM tab2 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT - col0 AS col1 FROM tab0 GROUP BY col0 HAVING NULL > + col0
;

SELECT ALL - col1 AS col1, col1 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL col2 AS col2 FROM tab2 GROUP BY col2, col2

;

SELECT - col0 FROM tab1 GROUP BY col0 HAVING NOT col0 <= NULL
;

SELECT ALL - col1 AS col0 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT col2 AS col2 FROM tab1 GROUP BY col2 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT DISTINCT - col1 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT ALL col2 FROM tab2 GROUP BY col0, col2

;

SELECT - col2 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT col2 FROM tab2 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT + - col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT col1 * col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT col2 AS col1 FROM tab1 GROUP BY col2, col0

;

SELECT ALL col1 FROM tab0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT + col0, col0 AS col2 FROM tab0 GROUP BY col0, col0, col1

;

SELECT + col1 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT col1 AS col0, - col1 - - col1 + - col1 FROM tab2 GROUP BY col1, col1

;

SELECT DISTINCT + col1 AS col1 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT col2 * - - col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT ALL col1 AS col2 FROM tab2 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT + col1 FROM tab2 AS cor0 GROUP BY col0, col1, col1

;

SELECT DISTINCT col1 + - + col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT col1 FROM tab2 AS cor0 WHERE - col1 IS NULL GROUP BY col1

;

SELECT DISTINCT - col1 FROM tab0 cor0 GROUP BY col1

;

SELECT - col2 FROM tab1 GROUP BY col2, col2 HAVING NOT NULL >= NULL
;

SELECT ALL + col0 FROM tab2 AS cor0 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT - col2 AS col1 FROM tab1 GROUP BY col2, col2

;

SELECT ALL + col0 FROM tab2 WHERE NULL <> NULL GROUP BY col0

;

SELECT col2 AS col1 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT + - col2 FROM tab1 cor0 GROUP BY col2

;

SELECT - col2, + col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - col0 AS col1 FROM tab0 GROUP BY col1, col0

;

SELECT DISTINCT + col2 AS col0 FROM tab2 GROUP BY col0, col0, col2

;

SELECT DISTINCT col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT ALL col2 AS col1 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL + - col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT + col2, + col2 FROM tab2 GROUP BY col1, col2

;

SELECT - col0 * + + col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT - col1 AS col2 FROM tab1 AS cor0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT col1 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT + + SUM ( + col0 ), col0 AS col1 FROM tab2 AS cor0 GROUP BY col2, col0 HAVING NULL IS NOT NULL
;

SELECT DISTINCT col2 AS col2 FROM tab0 GROUP BY col2, col2

;

SELECT DISTINCT col2 FROM tab0 GROUP BY col2, col0

;

SELECT ALL - col2 FROM tab2 GROUP BY col2, col1

;

SELECT col1 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT ALL - col2 AS col2 FROM tab0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT col0 FROM tab2 AS cor0 WHERE + col2 IS NULL GROUP BY col2, col0, col0

;

SELECT ALL + col1, col1 * + col1 AS col2 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT + + col0 AS col1 FROM tab1 AS cor0 WHERE col0 + - col0 - col2 * - - col1 IS NOT NULL GROUP BY col0

;

SELECT ALL col2 AS col2 FROM tab1 GROUP BY col2, col1

;

SELECT col0 AS col2 FROM tab2 cor0 GROUP BY col0, col1

;

SELECT col0 * + col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT ALL - + col2 AS col1, col2 AS col0 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT + + col1 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT + col1 * + col1 + col1 FROM tab1 GROUP BY col1

;

SELECT col0 FROM tab2 GROUP BY col2, col0

;

SELECT DISTINCT + col0 FROM tab2 cor0 GROUP BY col0, col0

;

SELECT + + col0, - col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT + col2, - col2 * + col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + + col0 AS col2 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT ALL col2 * + col2 FROM tab2 GROUP BY col2, col2, col1

;

SELECT DISTINCT col2 - col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT col1 * + col1 AS col0, - col1 FROM tab2 WHERE NULL IS NULL GROUP BY col1, col1

;

SELECT - col2 FROM tab1 GROUP BY col2, col0

;

SELECT col2 FROM tab0 GROUP BY col2, col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - col1 FROM tab1 GROUP BY col0, col1

;

SELECT col1 * col1 FROM tab0 GROUP BY col0, col1, col1

;

SELECT ALL + col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT ALL - col2 AS col1 FROM tab1 GROUP BY col0, col2

;

SELECT ALL - col1 FROM tab2 cor0 GROUP BY col1

;

SELECT + col2 FROM tab1 AS cor0 GROUP BY col2, col2 HAVING NOT NULL IS NOT NULL
;

SELECT - col1 AS col0 FROM tab1 GROUP BY col1, col1

;

SELECT col2 AS col0 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT + - col0 * + + col0 * + - col0 FROM tab0 cor0 GROUP BY col0

;

SELECT + col0 * - col0 AS col1 FROM tab1 GROUP BY col1, col0

;

SELECT ALL - col2 + - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL - col2 * - col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT ALL col0 + + col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT + - SUM ( col1 ) FROM tab0 WHERE NOT + col0 IS NULL GROUP BY col0, col1 HAVING NULL IS NOT NULL
;

SELECT + col0 FROM tab0 GROUP BY col0 HAVING NOT - col0 = SUM ( + col2 )
;

SELECT DISTINCT + col0 * col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT ALL col2 + - col2 FROM tab1 GROUP BY col2

;

SELECT ALL + col0 AS col1, - col0 * - col0 AS col2 FROM tab2 AS cor0 GROUP BY col0 HAVING ( NULL ) > NULL
;

SELECT DISTINCT + col0 FROM tab2 GROUP BY col1, col0

;

SELECT DISTINCT + col1 * - col1 FROM tab2 GROUP BY col1

;

SELECT - col0 FROM tab0 GROUP BY col0, col1

;

SELECT DISTINCT - col0 FROM tab2 cor0 GROUP BY col0, col0

;

SELECT + - col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + col0 * + + col1 FROM tab0 GROUP BY col1, col0 HAVING NULL IS NULL
;

SELECT ALL + + col2 * + col2 - col2 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT + + col0 FROM tab2 AS cor0 GROUP BY col0, col0 HAVING ( NULL ) IS NOT NULL
;

SELECT ALL - + col2 FROM tab2 AS cor0 GROUP BY col2, col2, col1

;

SELECT - col2 FROM tab2 AS cor0 GROUP BY col2 HAVING NOT NULL <> NULL
;

SELECT ALL col1 + + col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - col2 AS col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT + col2 FROM tab1 GROUP BY col2, col2

;

SELECT - col1 AS col1 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT ALL col0 AS col2 FROM tab1 AS cor0 GROUP BY col1, col0 HAVING ( NULL ) IS NOT NULL
;

SELECT + col2 AS col1 FROM tab0 GROUP BY col2, col2

;

SELECT - col0 FROM tab1 GROUP BY col0, col0

;

SELECT DISTINCT col0 + - + col0 AS col1 FROM tab2 GROUP BY col2, col0

;

SELECT + col1 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT col2 FROM tab1 AS cor0 WHERE - col0 IS NULL GROUP BY col2

;

SELECT DISTINCT - col0 * col0 FROM tab2 GROUP BY col0, col0

;

SELECT ALL col2 FROM tab0 AS cor0 GROUP BY col2, col2, col1 HAVING - - col2 <> NULL
;

SELECT ALL - - col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + col0 + + col0 FROM tab2 GROUP BY col0

;

SELECT ALL col2 AS col2 FROM tab1 WHERE NULL <= NULL GROUP BY col0, col2 HAVING NOT NULL IS NOT NULL
;

SELECT col1 FROM tab2 cor0 GROUP BY col2, col1

;

SELECT DISTINCT - col0 * + col0 FROM tab0 cor0 GROUP BY col2, col0

;

SELECT DISTINCT - col1 FROM tab2 AS cor0 GROUP BY col2, col0, col1

;

SELECT ALL col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT col2 AS col0 FROM tab2 AS cor0 WHERE NOT NULL IS NULL GROUP BY col2, col2

;

SELECT DISTINCT + - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - col0 + + col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT - col1 AS col2 FROM tab1 GROUP BY col1 HAVING NOT ( NULL ) IS NULL
;

SELECT col1 AS col1 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL col1 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT ALL - col0 FROM tab2 GROUP BY col0, col1

;

SELECT col2 AS col1 FROM tab2 AS cor0 GROUP BY col0, col1, col2

;

SELECT DISTINCT col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT + col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + + col2 * - col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, col2 HAVING NOT + SUM ( ALL + col1 ) NOT BETWEEN NULL AND ( NULL )
;

SELECT + col0 * col0 * col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + + col1 * + col1 + col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT col0 * - col0 FROM tab1 GROUP BY col0, col2

;

SELECT + col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT ALL col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - + col1 * col2 FROM tab2 WHERE NOT NULL IS NULL GROUP BY col1, col2

;

SELECT DISTINCT - col0 AS col2 FROM tab0 GROUP BY col0, col1

;

SELECT col2 FROM tab1 AS cor0 GROUP BY col2, col1 HAVING NOT NULL IS NOT NULL
;

SELECT ALL col2 AS col0 FROM tab2 GROUP BY col2, col0 HAVING NULL <> NULL
;

SELECT col1 AS col0 FROM tab2 GROUP BY col0, col1

;

SELECT DISTINCT + col2 * - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - col1 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT - col2 AS col1 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT - - col2 + - col1 FROM tab2 cor0 GROUP BY col2, col1, col2

;

SELECT + - col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - col0 AS col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT ALL - col2 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT ALL col2 FROM tab1 GROUP BY col0, col2

;

SELECT col1 * + + col2 + - col2 AS col0 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT col2 / - col2 FROM tab1 WHERE NULL IS NOT NULL GROUP BY col2

;

SELECT ALL col2 AS col1 FROM tab2 GROUP BY col2, col2

;

SELECT ALL col1 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col2, col2

;

SELECT DISTINCT + + col0 AS col1 FROM tab2 cor0 GROUP BY col2, col0

;

SELECT ALL - col2 * - col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col2 AS col2 FROM tab2 GROUP BY col2, col1

;

SELECT + + col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - col0 AS col2 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT col0 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT - - col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL + col0 AS col0 FROM tab2 GROUP BY col0, col0

;

SELECT ALL - - col1 - - col1 * col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT ALL - col2 AS col0 FROM tab1 GROUP BY col0, col0, col2

;

SELECT - col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT col1 AS col1 FROM tab1 GROUP BY col1, col1

;

SELECT ALL - - col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + col0 * - col0 FROM tab1 AS cor0 GROUP BY col2, col0 HAVING NOT NULL IS NULL
;

SELECT DISTINCT col1 AS col0 FROM tab2 GROUP BY col1 HAVING NOT - col1 IS NULL
;

SELECT ALL + col2 AS col1 FROM tab1 GROUP BY col2, col2

;

SELECT - - col0 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT + col0 + - col0 AS col0 FROM tab0 GROUP BY col1, col1, col0

;

SELECT + col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT ALL col0 AS col1 FROM tab0 GROUP BY col0, col1

;

SELECT DISTINCT + + col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col0 AS col2 FROM tab0 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT DISTINCT col2 FROM tab0 cor0 GROUP BY col2

;

SELECT col0 + - col0 FROM tab1 GROUP BY col0

;

SELECT + + col1 AS col0 FROM tab1 cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col1, col0 HAVING NOT NULL < ( NULL )
;

SELECT col0 AS col1, + col0 FROM tab0 GROUP BY col0

;

SELECT ALL - col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT col1 * - - col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - - col2 AS col2 FROM tab1 AS cor0 GROUP BY col2, col2, col1

;

SELECT col1 * + - col1 FROM tab2 GROUP BY col1

;

SELECT ALL col2 FROM tab2 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT col2 FROM tab1 cor0 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT + col0 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT ALL col2 AS col0 FROM tab0 cor0 GROUP BY col2

;

SELECT - col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col2, col2

;

SELECT DISTINCT col0 FROM tab1 GROUP BY col0 HAVING NULL IS NULL
;

SELECT ALL + col1 AS col0 FROM tab1 GROUP BY col2, col1

;

SELECT + + col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT DISTINCT col1 FROM tab1 GROUP BY col0, col1, col2

;

SELECT ALL + col0 + - col0 FROM tab1 GROUP BY col1, col0

;

SELECT DISTINCT + + col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT + col2 AS col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT + - col2 * + + col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col1 FROM tab2 GROUP BY col2, col1

;

SELECT - col1 / + - col0 AS col2 FROM tab1 GROUP BY col1, col0 HAVING NULL IS NOT NULL
;

SELECT ALL col1 FROM tab2 WHERE NOT ( - col2 ) IS NULL GROUP BY col1

;

SELECT - col0 FROM tab2 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT DISTINCT col2 AS col1 FROM tab2 GROUP BY col2, col1 HAVING NOT col2 IS NULL
;

SELECT - col2 FROM tab2 GROUP BY col2, col2

;

SELECT DISTINCT + col2 FROM tab1 GROUP BY col2, col1

;

SELECT - col0 AS col0 FROM tab2 AS cor0 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT - - col0 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT + + col0 - + col0 FROM tab2 AS cor0 GROUP BY col2, col0, col0

;

SELECT col2 FROM tab1 WHERE NOT NULL IS NOT NULL GROUP BY col2

;

SELECT ALL + col2 + col2 + col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col2 AS col1 FROM tab0 cor0 GROUP BY col2, col1

;

SELECT - + col2 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT ALL col1 FROM tab1 AS cor0 WHERE NOT NULL NOT BETWEEN ( - col1 ) AND col0 * - col2 GROUP BY col1

;

SELECT + col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT - col1 * + col0 AS col0 FROM tab2 GROUP BY col1, col0 HAVING NULL IS NOT NULL
;

SELECT ALL - col1 AS col1 FROM tab1 AS cor0 GROUP BY col1 HAVING NULL <= NULL
;

SELECT - + col0 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT col2 * col2 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT col2 FROM tab1 GROUP BY col1, col2

;

SELECT ALL + + col2 AS col1, + col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + - col0 * col0 AS col2 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT + col2 FROM tab1 GROUP BY col0, col1, col2

;

SELECT DISTINCT - - col2 * + - col2 AS col1 FROM tab0 WHERE NOT NULL <= NULL GROUP BY col2, col1

;

SELECT ALL + col0 AS col1 FROM tab1 cor0 GROUP BY col1, col0

;

SELECT col1 FROM tab1 GROUP BY col1, col1

;

SELECT ALL col1 FROM tab0 AS cor0 GROUP BY col2, col1 HAVING NULL IS NULL
;

SELECT ALL col2 AS col2 FROM tab2 GROUP BY col2, col1

;

SELECT DISTINCT col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, col2, col2

;

SELECT DISTINCT + col0 + + + col0 * col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL col1 * + col1 - + - col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT - - col1 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL - col2 * - col2 FROM tab2 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT ALL + + col0 * + col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - col1 * + col1 FROM tab1 GROUP BY col1

;

SELECT - col2 AS col0 FROM tab1 cor0 GROUP BY col0, col2

;

SELECT ALL col2 * - col2 FROM tab2 GROUP BY col2, col2

;

SELECT - col1 + + col1 AS col2 FROM tab1 GROUP BY col0, col1

;

SELECT DISTINCT + - col2, col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT col2 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT - col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + col2 AS col2 FROM tab2 cor0 GROUP BY col2

;

SELECT + col2 AS col2 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT ALL - col0 * + col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL + col1 * + col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - col2 FROM tab2 GROUP BY col0, col2

;

SELECT - - col2 FROM tab1 cor0 GROUP BY col2

;

SELECT DISTINCT - col2 AS col1 FROM tab1 cor0 GROUP BY col2, col2

;

SELECT + + col2 AS col1 FROM tab1 cor0 GROUP BY col2

;

SELECT + col2 * + col2 * - col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col0 * - + col2 - + col2 AS col0 FROM tab0 cor0 GROUP BY col0, col2

;

SELECT - col0 AS col0 FROM tab2 cor0 GROUP BY col0, col2

;

SELECT + col0 + - col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + col1 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL col0 AS col1 FROM tab2 cor0 GROUP BY col0 HAVING ( NULL ) IS NOT NULL
;

SELECT + col2 AS col2 FROM tab1 GROUP BY col0, col2 HAVING ( NULL ) <> - col0
;

SELECT col2 AS col2 FROM tab1 GROUP BY col0, col0, col2

;

SELECT ALL - col2 * - + col2 * - col2 FROM tab1 GROUP BY col2

;

SELECT + col1 * col1 FROM tab1 AS cor0 GROUP BY col0, col1, col1

;

SELECT ALL - col1 * + col1 AS col1 FROM tab0 GROUP BY col1, col0

;

SELECT - col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT - col2 AS col1 FROM tab0 GROUP BY col2, col1

;

SELECT ALL + - col0 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT - col2 FROM tab0 GROUP BY col2, col1, col2

;

SELECT DISTINCT - - col0, + col0 AS col2 FROM tab2 cor0 GROUP BY col0

;

SELECT DISTINCT + col0 AS col2 FROM tab2 AS cor0 GROUP BY col0 HAVING NULL <> NULL
;

SELECT col2 + col2 * - col2 FROM tab1 GROUP BY col2

;

SELECT col1 FROM tab1 AS cor0 WHERE - col0 <= NULL GROUP BY col1, col0

;

SELECT + col2 AS col0 FROM tab2 GROUP BY col2, col1

;

SELECT DISTINCT col0 FROM tab0 AS cor0 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT ALL - + col1 FROM tab1 AS cor0 GROUP BY col2, col2, col1

;

SELECT + col0 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT col1 FROM tab1 AS cor0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT col0 AS col2 FROM tab2 GROUP BY col0, col0

;

SELECT ALL col1 FROM tab2 GROUP BY col0, col1, col2

;

SELECT DISTINCT + + col0 + + - col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT + + col0 + - col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + col0 AS col1, - col1 FROM tab0 AS cor0 GROUP BY col0, col2, col1

;

SELECT col1 FROM tab1 AS cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT + col1 + - - col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + col1 * - col1 * + col1 FROM tab1 GROUP BY col1, col1, col0, col1

;

SELECT col0 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL - col1 FROM tab1 GROUP BY col0, col1

;

SELECT ALL + col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT + + col1 FROM tab0 AS cor0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT ALL + col2 FROM tab0 GROUP BY col1, col2

;

SELECT col0, col0 * + - col0 AS col1 FROM tab2 GROUP BY col0, col0

;

SELECT ALL col2 AS col1 FROM tab2 AS cor0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT ALL col1 FROM tab0 GROUP BY col1, col2

;

SELECT + col1 AS col2 FROM tab0 cor0 GROUP BY col1, col1, col1

;

SELECT ALL col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT col0 AS col0 FROM tab1 GROUP BY col0, col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - col0 AS col0, - col0 + + - col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - col0 + + col0 AS col2 FROM tab1 cor0 GROUP BY col0

;

SELECT + col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT col2 AS col2 FROM tab1 GROUP BY col2, col0

;

SELECT ALL + col1 FROM tab0 GROUP BY col2, col1

;

SELECT + col0 AS col0 FROM tab2 GROUP BY col0, col0 HAVING NULL IS NULL
;

SELECT DISTINCT + + col1 FROM tab2 AS cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT col1 FROM tab0 cor0 GROUP BY col0, col1

;

SELECT - - col0 - + + col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT col1 * + - col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - col1 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT - + col2 * - - col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - col2 FROM tab0 GROUP BY col1, col2

;

SELECT + col2 * col1 AS col2 FROM tab0 GROUP BY col2, col1, col0

;

SELECT ALL - col1 AS col2 FROM tab0 GROUP BY col1, col1

;

SELECT - + col2 * col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - - col1 FROM tab2 WHERE NOT col2 IS NOT NULL GROUP BY col1, col1

;

SELECT + - col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT col1 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT ALL + col2 FROM tab1 GROUP BY col0, col2, col2

;

SELECT ALL - col0 FROM tab0 AS cor0 GROUP BY col0, col0 HAVING NULL IS NOT NULL
;

SELECT + + col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT DISTINCT col2 AS col2 FROM tab1 AS cor0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT - - col2 FROM tab2 cor0 GROUP BY col2

;

SELECT + col0 FROM tab1 WHERE - col0 IS NOT NULL GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT ALL - + col2 FROM tab1 cor0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT - col0 AS col2 FROM tab1 AS cor0 GROUP BY col0, col0 HAVING NULL < NULL
;

SELECT ALL + col0 FROM tab1 GROUP BY col0, col1

;

SELECT DISTINCT col0 AS col0, col0 * col0 FROM tab0 AS cor0 GROUP BY col0, col0, col0

;

SELECT ALL - col2 FROM tab1 cor0 GROUP BY col0, col2

;

SELECT col1 AS col2 FROM tab1 GROUP BY col0, col1

;

SELECT DISTINCT + col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + - col0 AS col2 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT ALL - + col2 - + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col0, col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - col2 AS col1 FROM tab0 AS cor0 GROUP BY col2 HAVING col2 >= NULL
;

SELECT - col2 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT - col2 * col2 FROM tab2 GROUP BY col2, col2, col0

;

SELECT col0 AS col2 FROM tab1 cor0 GROUP BY col0, col1 HAVING NULL >= NULL
;

SELECT DISTINCT - col2 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT + col2 * - col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT col2 - - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT ALL col2 * - col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col2, col2 HAVING - col0 > NULL
;

SELECT + col2 AS col1 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT col1 AS col1 FROM tab0 GROUP BY col1, col0

;

SELECT DISTINCT col0 + col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL col1 FROM tab1 GROUP BY col2, col1

;

SELECT col0 FROM tab1 cor0 WHERE ( NULL ) IS NOT NULL GROUP BY col0

;

SELECT ALL - col2 * - col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT + col0 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT ALL + col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT - col2 + - - col2 FROM tab0 GROUP BY col2

;

SELECT ALL - col0 FROM tab0 AS cor0 GROUP BY col0, col1, col0 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - col0 FROM tab2 cor0 GROUP BY col2, col0

;

SELECT DISTINCT + col2 + - + col2 / SUM ( + + col2 ) FROM tab0 WHERE NULL IS NOT NULL GROUP BY col2

;

SELECT col2 FROM tab1 AS cor0 WHERE ( NOT + col2 > NULL ) GROUP BY col1, col2 HAVING NOT NULL < NULL
;

SELECT ALL col2 FROM tab0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT + + col1 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT col0 FROM tab0 AS cor0 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT - col1 AS col1 FROM tab2 GROUP BY col1, col0, col2 HAVING NOT NULL <> NULL
;

SELECT - col2 FROM tab1 GROUP BY col2, col2

;

SELECT ALL - + col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + col1 AS col1 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT col2 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT ALL - col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + col1 FROM tab1 AS cor0 WHERE ( NULL ) <= ( NULL ) GROUP BY col1

;

SELECT - col2 AS col1, + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - + col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + col2 AS col0 FROM tab1 cor0 GROUP BY col0, col2

;

SELECT col1 FROM tab2 AS cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT col2 * + col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT - col2 FROM tab0 WHERE NOT NULL IS NULL GROUP BY col2, col2

;

SELECT ALL col0 AS col2 FROM tab0 GROUP BY col0 HAVING NULL IS NULL
;

SELECT - col0 AS col0 FROM tab1 GROUP BY col0, col0

;

SELECT + col2 AS col1 FROM tab1 AS cor0 GROUP BY col1, col2, col2

;

SELECT + col0 + + col1 AS col1 FROM tab1 GROUP BY col1, col0

;

SELECT + col0 * + - col0 FROM tab1 cor0 GROUP BY col0, col2

;

SELECT col0 * - col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - col0 AS col0 FROM tab0 GROUP BY col0, col2, col0 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - col2 + + col1 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT col0 FROM tab2 GROUP BY col0, col2 HAVING NOT NULL IS NULL
;

SELECT col1 FROM tab0 GROUP BY col1, col1

;

SELECT DISTINCT - col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT - + col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + - col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col0 FROM tab0 GROUP BY col1, col0, col2

;

SELECT + col0 + + col0 FROM tab2 GROUP BY col2, col0

;

SELECT col1 AS col1 FROM tab2 GROUP BY col1, col1 HAVING NOT SUM ( col1 ) < NULL
;

SELECT ALL col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, col1, col2

;

SELECT + col2 AS col0 FROM tab2 GROUP BY col2, col0

;

SELECT DISTINCT - - col2 FROM tab0 cor0 GROUP BY col2

;

SELECT ALL col0 AS col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT - + col2 * - col0 AS col0 FROM tab1 cor0 GROUP BY col0, col2

;

SELECT SUM ( DISTINCT + col1 ) FROM tab2 GROUP BY col2, col1 HAVING NOT col2 <> NULL
;

SELECT ALL - - col2 FROM tab0 cor0 GROUP BY col2, col2

;

SELECT DISTINCT col2 AS col2 FROM tab2 GROUP BY col0, col2

;

SELECT - col2 * col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + col1 AS col1 FROM tab1 AS cor0 GROUP BY col0, col1 HAVING NOT NULL IS NULL
;

SELECT - col2 FROM tab1 AS cor0 GROUP BY col2 HAVING + + col2 IS NOT NULL
;

SELECT - - col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT col2 FROM tab0 WHERE NOT NULL IS NOT NULL GROUP BY col2, col0

;

SELECT ALL col0 AS col1 FROM tab1 AS cor0 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT + - col0 + - col0 AS col2 FROM tab0 AS cor0 GROUP BY col0 HAVING NOT ( NULL ) IS NULL
;

SELECT DISTINCT col2 - + col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, col2, col2

;

SELECT + col0 FROM tab2 GROUP BY col0 HAVING NOT ( NULL ) IS NULL
;

SELECT ALL - col2 FROM tab1 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT + col2 FROM tab0 AS cor0 GROUP BY col2, col0 HAVING NOT NULL IS NOT NULL
;

SELECT col0 AS col2, col0 FROM tab0 GROUP BY col0, col0

;

SELECT - col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT ALL col2 AS col0 FROM tab2 GROUP BY col2, col2

;

SELECT - col0 FROM tab2 GROUP BY col0, col2, col1

;

SELECT col0 AS col2 FROM tab2 GROUP BY col1, col0

;

SELECT - - col2 + col2 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + - col1 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT ALL + - col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT col0 AS col2 FROM tab1 AS cor0 WHERE ( col2 ) > + col0 + + col2 GROUP BY col0

;

SELECT + col1 FROM tab1 GROUP BY col1, col1, col2, col2

;

SELECT DISTINCT - col0 FROM tab1 GROUP BY col0, col2 HAVING NOT NULL IS NOT NULL
;

SELECT + col1 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT ALL col2 FROM tab0 AS cor0 GROUP BY col2 HAVING NULL = NULL
;

SELECT ALL + col2 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col2 FROM tab2 GROUP BY col2

;

SELECT - col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT ALL - - col2 + + - col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + col2 * + col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT + col1 AS col1 FROM tab0 GROUP BY col1 HAVING NOT NULL >= NULL
;

SELECT ALL col2 AS col2 FROM tab1 GROUP BY col2, col0, col2

;

SELECT DISTINCT + - col2 * - col2 - col2 * col2 AS col2 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT ALL + col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT col1 AS col1 FROM tab1 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT ALL col1 AS col1 FROM tab2 GROUP BY col1, col1

;

SELECT DISTINCT col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT ALL + - col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - col0 FROM tab0 GROUP BY col0, col2

;

SELECT col2 FROM tab1 GROUP BY col2, col0

;

SELECT - col0 AS col1 FROM tab2 GROUP BY col0, col2, col2

;

SELECT - col2 FROM tab0 cor0 GROUP BY col2, col2

;

SELECT DISTINCT - col2 FROM tab2 GROUP BY col2, col2, col1

;

SELECT ALL col0 * + col0 AS col1 FROM tab0 cor0 GROUP BY col1, col0

;

SELECT - col2 * - col2 AS col0 FROM tab1 GROUP BY col2, col1

;

SELECT DISTINCT col2 AS col0 FROM tab1 GROUP BY col2, col1

;

SELECT + col0 FROM tab1 GROUP BY col2, col0 HAVING NULL IS NULL
;

SELECT ALL col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT col0 AS col1 FROM tab0 GROUP BY col0 HAVING NOT - - col0 IS NOT NULL
;

SELECT ALL col1 FROM tab0 AS cor0 GROUP BY col1, col2, col1

;

SELECT DISTINCT - col0 * + col0 - + + col0 AS col2, col0 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL + col0 + col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + col0 + + - col0 + - col0 FROM tab1 AS cor0 GROUP BY col0 HAVING NOT NULL <> NULL
;

SELECT - col0 FROM tab0 WHERE NULL BETWEEN + col1 AND NULL GROUP BY col0, col0

;

SELECT ALL - col1 FROM tab2 GROUP BY col1, col2 HAVING NULL = NULL
;

SELECT ALL col1 FROM tab0 GROUP BY col1, col1, col1

;

SELECT DISTINCT col1, col2 FROM tab0 AS cor0 GROUP BY col2, col1, col1

;

SELECT DISTINCT + col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + col0 * + col2 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT col2 AS col2 FROM tab1 GROUP BY col2, col2

;

SELECT col1 FROM tab2 GROUP BY col0, col1

;

SELECT DISTINCT + col1 * col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - col0 - col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT - - col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT col1 AS col1 FROM tab1 cor0 GROUP BY col1

;

SELECT - col0 AS col2 FROM tab1 GROUP BY col0, col2

;

SELECT ALL col1 AS col0 FROM tab1 GROUP BY col0, col1

;

SELECT ALL col0 AS col1 FROM tab1 GROUP BY col0, col0

;

SELECT ALL col0 AS col1 FROM tab2 GROUP BY col0, col0

;

SELECT + col0 AS col2 FROM tab1 AS cor0 GROUP BY col0, col0, col1

;

SELECT ALL + col2 FROM tab1 cor0 GROUP BY col2, col2 HAVING NULL IS NULL
;

SELECT DISTINCT - col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT + col0 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT col2 FROM tab0 cor0 GROUP BY col1, col2

;

SELECT DISTINCT - col1 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT col2 FROM tab2 GROUP BY col2, col0

;

SELECT + col1 FROM tab2 AS cor0 WHERE col1 IS NOT NULL GROUP BY col1

;

SELECT - - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT col0 + - - col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col1 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT ALL + col2 FROM tab0 cor0 GROUP BY col2

;

SELECT + + col0 + col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - col1 FROM tab2 GROUP BY col1, col2

;

SELECT + col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col0 + col0 AS col2 FROM tab0 GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT - col1 AS col2 FROM tab1 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT SUM ( DISTINCT - col2 ) FROM tab1 AS cor0 GROUP BY col1, col2 HAVING NOT NULL IS NULL
;

SELECT - col1 FROM tab1 GROUP BY col0, col2, col1

;

SELECT DISTINCT + col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT ALL + col2 FROM tab2 AS cor0 GROUP BY col2 HAVING NOT - - col2 <= NULL
;

SELECT DISTINCT - - col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL - - col2 * - + col2 FROM tab0 AS cor0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT ALL - col1, + col1 FROM tab0 GROUP BY col1

;

SELECT + col2 FROM tab2 cor0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT ALL - col0 AS col2 FROM tab2 GROUP BY col0, col2

;

SELECT col0 AS col0 FROM tab2 GROUP BY col0, col0

;

SELECT col1 AS col0 FROM tab0 cor0 WHERE NOT NULL IS NOT NULL GROUP BY col0, col1, col2

;

SELECT DISTINCT + - col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + col1 FROM tab2 GROUP BY col2, col1 HAVING ( NULL ) = ( col1 )
;

SELECT ALL col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT - + col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col2 + + col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT - - col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT col2 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT - col0 FROM tab2 GROUP BY col2, col0 HAVING NULL IS NULL
;

SELECT ALL - col0 AS col2 FROM tab2 cor0 GROUP BY col0 HAVING NOT NULL > NULL
;

SELECT DISTINCT + col0 AS col1 FROM tab2 cor0 GROUP BY col0

;

SELECT ALL col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT ALL + col1 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT - col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT + - col2 FROM tab0 AS cor0 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT ALL col1 AS col0 FROM tab0 GROUP BY col1, col1, col2

;

SELECT - col0 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT + - col1 AS col1 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT - col0 AS col0, col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - col1 AS col0, col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT DISTINCT + col2 * + - col2 AS col1 FROM tab1 cor0 GROUP BY col2

;

SELECT + - col2 * + + col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col1 + + col1 AS col1 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT col1 AS col0 FROM tab2 GROUP BY col2, col1

;

SELECT ALL - col2 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT + col0 AS col0 FROM tab0 AS cor0 GROUP BY col1, col0 HAVING NOT NULL IS NOT NULL
;

SELECT ALL - col1 FROM tab0 AS cor0 GROUP BY col2, col0, col1 HAVING NULL IS NOT NULL
;

SELECT ALL col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - col0 AS col1 FROM tab1 AS cor0 GROUP BY col1, col0, col0

;

SELECT DISTINCT + - col0 AS col0 FROM tab1 cor0 GROUP BY col2, col0

;

SELECT ALL col0 FROM tab2 GROUP BY col1, col0, col0

;

SELECT - + col2 AS col0 FROM tab0 AS cor0 GROUP BY col0, col2, col2

;

SELECT + - col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT col0 + - - col0 FROM tab1 GROUP BY col0

;

SELECT ALL col0 FROM tab2 GROUP BY col0, col2

;

SELECT ALL + col2 AS col2 FROM tab1 GROUP BY col2, col1, col1

;

SELECT DISTINCT - col2 FROM tab1 GROUP BY col2, col1

;

SELECT - col0 FROM tab2 AS cor0 GROUP BY col2, col0, col2 HAVING NULL IS NULL
;

SELECT + - col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - + col0 AS col2 FROM tab2 cor0 GROUP BY col0

;

SELECT + - col1 AS col1 FROM tab0 cor0 GROUP BY col1

;

SELECT ALL - col1 FROM tab0 AS cor0 GROUP BY col0, col1 HAVING NULL IS NOT NULL
;

SELECT + - col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - - col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col1 FROM tab1 cor0 GROUP BY col2, col1

;

SELECT col0 AS col0 FROM tab0 AS cor0 GROUP BY col0, col1, col2

;

SELECT + col1 FROM tab1 GROUP BY col1, col2 HAVING - + col2 IS NOT NULL
;

SELECT - + col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT - - col0 * - col0 + - + col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + + col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + + col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col0 FROM tab0 AS cor0 GROUP BY col2, col1, col1, col0

;

SELECT ALL + col2 AS col0 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT - col1 FROM tab2 AS cor0 WHERE NOT ( NULL IS NULL ) GROUP BY col1 HAVING NOT NULL = NULL
;

SELECT col1, col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT - - col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT col0 AS col0 FROM tab1 GROUP BY col0 HAVING NULL IS NULL
;

SELECT DISTINCT col2 AS col2 FROM tab0 cor0 GROUP BY col2, col2

;

SELECT - col1 AS col1 FROM tab1 cor0 GROUP BY col2, col1

;

SELECT DISTINCT + col0 FROM tab0 AS cor0 WHERE NOT + col2 IS NULL GROUP BY col0

;

SELECT - - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT ALL + col0 FROM tab0 AS cor0 GROUP BY col0, col0, col0

;

SELECT - col0 FROM tab0 GROUP BY col2, col0 HAVING NOT NULL IS NULL
;

SELECT - col2 FROM tab0 WHERE NULL BETWEEN NULL AND NULL GROUP BY col1, col2

;

SELECT + - col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + col1 + + col1 FROM tab1 WHERE NULL <> NULL GROUP BY col1, col2

;

SELECT - col2 FROM tab0 cor0 GROUP BY col2

;

SELECT ALL - col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT col0 FROM tab2 GROUP BY col0 HAVING NOT - col0 IS NOT NULL
;

SELECT - col0 FROM tab1 AS cor0 GROUP BY col2, col0, col0

;

SELECT ALL - col2 FROM tab1 GROUP BY col2, col2

;

SELECT DISTINCT col1 * + col1 AS col1 FROM tab2 GROUP BY col1, col1

;

SELECT col1 + - + col1 * col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT + col2 + + col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT - - col0 + - col0 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT - col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT ALL - col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL + col0 AS col1 FROM tab1 GROUP BY col1, col0

;

SELECT col2 FROM tab0 GROUP BY col2, col1

;

SELECT DISTINCT - - col1 FROM tab1 cor0 GROUP BY col1, col1, col1

;

SELECT - col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, col2, col0

;

SELECT col2 + - col2 FROM tab1 GROUP BY col2 HAVING NOT - col2 IS NOT NULL
;

SELECT DISTINCT + col1 - - col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT col2 * + col2 FROM tab0 GROUP BY col2 HAVING ( NULL IS NULL )
;

SELECT + col1 + - - col1 FROM tab0 GROUP BY col1

;

SELECT + col0 AS col2 FROM tab0 AS cor0 GROUP BY col1, col0 HAVING NULL IS NULL
;

SELECT col1 * col1 AS col0 FROM tab2 AS cor0 GROUP BY col1 HAVING NULL IS NULL
;

SELECT - col2 FROM tab0 GROUP BY col2, col2

;

SELECT col0 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT col0 FROM tab1 cor0 GROUP BY col0, col0

;

SELECT + col2 * + col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT col0 FROM tab2 GROUP BY col2, col1, col0

;

SELECT + col2 * col2 FROM tab0 AS cor0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT - col0 FROM tab1 GROUP BY col2, col0, col0

;

SELECT ALL + + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT col1 * col0 FROM tab1 AS cor0 GROUP BY col0, col0, col1 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT - + col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT + col1 - + col1 FROM tab1 GROUP BY col1, col0

;

SELECT ALL - col0 * - col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT col1 AS col1, + col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + col0 FROM tab0 AS cor0 GROUP BY col0, col1, col0

;

SELECT ALL - col0 + - col0 AS col0 FROM tab1 cor0 GROUP BY col0, col0, col0

;

SELECT DISTINCT + col0 AS col2 FROM tab2 AS cor0 GROUP BY col0, col0, col2

;

SELECT - + col2 FROM tab2 cor0 GROUP BY col2, col2 HAVING NULL IS NOT NULL
;

SELECT - col0 * - col1 AS col0 FROM tab2 WHERE NOT NULL IS NULL GROUP BY col0, col1

;

SELECT DISTINCT + col2 * - - col2 + + + col2 FROM tab1 GROUP BY col2

;

SELECT ALL col2 AS col0 FROM tab2 GROUP BY col0, col2

;

SELECT DISTINCT - col2 AS col0 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT ALL col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL col2 + col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + col1 AS col0 FROM tab2 WHERE NOT col1 * col0 IS NULL GROUP BY col1

;

SELECT ALL - col2 FROM tab0 GROUP BY col2, col0, col2

;

SELECT - col0 AS col0 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT col1 AS col1 FROM tab2 GROUP BY col0, col1

;

SELECT DISTINCT - col1 FROM tab0 cor0 GROUP BY col1, col1

;

SELECT - col1 FROM tab2 GROUP BY col1, col1

;

SELECT DISTINCT col0 AS col0 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT + + col2 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT col1 AS col2 FROM tab2 cor0 GROUP BY col1, col2

;

SELECT + col1 - + col1 * + col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + col2 AS col1 FROM tab1 WHERE NULL IS NOT NULL GROUP BY col2

;

SELECT ALL + col2 FROM tab0 AS cor0 WHERE - col1 IS NULL GROUP BY col2

;

SELECT ALL col2 + col2 FROM tab0 GROUP BY col2

;

SELECT - + col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col1 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT ALL col0 AS col1 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL - col1 AS col1 FROM tab2 GROUP BY col2, col1

;

SELECT ALL + col1 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT col1, col1 FROM tab2 GROUP BY col0, col1

;

SELECT - col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL col2 AS col2 FROM tab0 AS cor0 WHERE NOT NULL IS NULL GROUP BY col2

;

SELECT DISTINCT - col1 AS col2 FROM tab1 GROUP BY col1, col2 HAVING NOT - + col2 IS NOT NULL
;

SELECT + col2 FROM tab0 cor0 GROUP BY col2, col0

;

SELECT + col2 AS col2 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT + - col1 * col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - col0 AS col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT - - col0 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT col1 AS col2 FROM tab2 AS cor0 WHERE NOT NULL IS NULL GROUP BY col0, col1

;

SELECT DISTINCT - - col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, col0, col0 HAVING NULL IS NULL
;

SELECT ALL - col0 * col2 FROM tab2 GROUP BY col0, col2

;

SELECT - col2 FROM tab1 AS cor0 GROUP BY col2, col2, col2

;

SELECT col0 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT ALL + col0 AS col1 FROM tab0 cor0 GROUP BY col1, col0

;

SELECT ALL + col0 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT + col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, col0, col0

;

SELECT + col2 FROM tab1 AS cor0 WHERE NULL >= ( NULL ) GROUP BY col2

;

SELECT ALL - col0 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT + + col1 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT + col1 * + - col2 AS col1 FROM tab1 GROUP BY col1, col2

;

SELECT DISTINCT col0 AS col1 FROM tab2 GROUP BY col0, col1

;

SELECT DISTINCT - col0 AS col1 FROM tab2 cor0 WHERE NOT - col1 NOT BETWEEN ( - col2 ) AND NULL GROUP BY col0, col1

;

SELECT + + col0 FROM tab2 AS cor0 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT + col0 * col1 FROM tab0 GROUP BY col0, col1

;

SELECT ALL + col2 AS col0 FROM tab0 WHERE NULL IS NULL GROUP BY col1, col2

;

SELECT ALL - col0 FROM tab0 GROUP BY col2, col0

;

SELECT DISTINCT + + col2 FROM tab0 AS cor0 GROUP BY col0, col2, col2

;

SELECT ALL + - col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + - col1 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT + col2 AS col2 FROM tab2 GROUP BY col2, col2

;

SELECT col1 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT - col1 + col1 AS col2 FROM tab1 AS cor0 GROUP BY col1 HAVING NULL IS NULL
;

SELECT + col0 AS col0, + col0 * + - col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT - col1 AS col1 FROM tab1 GROUP BY col1, col0

;

SELECT - + col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT ALL col1 + col1 AS col1 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT + col1 FROM tab1 GROUP BY col0, col1

;

SELECT DISTINCT + - col2 * - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT ALL + col0 FROM tab1 cor0 GROUP BY col0, col0

;

SELECT - col0 AS col0 FROM tab2 GROUP BY col0, col0

;

SELECT ALL - + col1 + + + col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL - col0 * col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT DISTINCT - - col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT col0 FROM tab2 WHERE NOT - col1 <> NULL GROUP BY col2, col0, col2

;

SELECT SUM ( - - col2 ) FROM tab2 WHERE NOT NULL IS NULL GROUP BY col2

;

SELECT ALL + col1 FROM tab1 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT + col2 - + col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT col2 FROM tab2 GROUP BY col1, col2

;

SELECT ALL + - col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT ALL - col0 FROM tab1 AS cor0 GROUP BY col0, col0, col0

;

SELECT DISTINCT - col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT DISTINCT col2 + col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT col1 * - - col1 * + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - col1 FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT + col2 FROM tab2 cor0 GROUP BY col2, col2

;

SELECT - col1 * - - col1 FROM tab0 GROUP BY col1

;

SELECT ALL col2 * col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + col0 FROM tab1 WHERE NULL IS NULL GROUP BY col0

;

SELECT ALL - col1 FROM tab0 WHERE col2 IS NULL GROUP BY col1

;

SELECT ALL col0 AS col1 FROM tab2 cor0 GROUP BY col0

;

SELECT ALL - col0 * + col0 FROM tab0 AS cor0 WHERE NOT NULL NOT IN ( col2 ) GROUP BY col0

;

SELECT ALL col1 + col1 FROM tab0 AS cor0 WHERE NOT NULL < NULL GROUP BY col1 HAVING NOT ( NULL ) >= NULL
;

SELECT col2 AS col2 FROM tab0 GROUP BY col2, col1

;

SELECT DISTINCT col2 FROM tab1 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - col1 AS col2 FROM tab0 cor0 GROUP BY col1, col2

;

SELECT col1 AS col1, + col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - col2 * - - col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT col2 AS col2 FROM tab1 AS cor0 GROUP BY col2, col0, col2

;

SELECT ALL col0 * - col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + - col1 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT col2 * - col0 FROM tab0 AS cor0 WHERE NOT ( NULL ) IS NOT NULL GROUP BY col0, col2

;

SELECT DISTINCT + col1 - + col1 * - col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - col2 + + col2 FROM tab2 GROUP BY col2, col2

;

SELECT ALL - + col2 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT col1 + + col0 AS col0, col0 AS col0 FROM tab0 cor0 GROUP BY col1, col0, col1

;

SELECT DISTINCT + col0 AS col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT col1 + + col1 * col0 + + - col1 + col0 FROM tab1 GROUP BY col1, col0

;

SELECT - col1 - - col1 FROM tab2 GROUP BY col1

;

SELECT col1 AS col2 FROM tab2 AS cor0 WHERE NULL IS NULL GROUP BY col1

;

SELECT - col2 FROM tab1 AS cor0 WHERE NOT - col2 <= col1 GROUP BY col2

;

SELECT + SUM ( ALL + col1 ) + col1 FROM tab0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT - col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT col1 + - col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT ALL col0 FROM tab2 AS cor0 GROUP BY col0, col0 HAVING NULL IS NOT NULL
;

SELECT ALL + col1 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT - col2 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT col0, col0 FROM tab1 GROUP BY col0, col0, col2

;

SELECT ALL - + col1 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT - - col2 + - col2 FROM tab1 WHERE NULL IS NOT NULL GROUP BY col2, col1

;

SELECT + col0 AS col0 FROM tab0 AS cor0 GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT + col1, + col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT col2 AS col1 FROM tab0 GROUP BY col2, col2

;

SELECT ALL + col1 AS col0 FROM tab0 GROUP BY col2, col1

;

SELECT - col0 FROM tab1 WHERE ( + col0 * + col1 <> NULL ) GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT - col0 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT col0 FROM tab2 AS cor0 WHERE NULL IS NULL GROUP BY col0, col0

;

SELECT ALL col0 / - col0 AS col0 FROM tab1 AS cor0 WHERE NOT ( NULL ) IS NULL GROUP BY col2, col0

;

SELECT ALL + col0 FROM tab0 GROUP BY col0, col2

;

SELECT col1 FROM tab2 GROUP BY col2, col1, col1

;

SELECT DISTINCT - + col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT + col0 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT ALL - col0 * - col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT col0 FROM tab1 GROUP BY col0, col2

;

SELECT col2 FROM tab1 cor0 GROUP BY col2, col2

;

SELECT ALL - + col1 AS col2 FROM tab2 cor0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT ALL - + col0 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT col1, - col1 FROM tab0 cor0 GROUP BY col1

;

SELECT ALL - col0 AS col2 FROM tab2 GROUP BY col0, col1

;

SELECT ALL + col2 * - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + + col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT + col2 FROM tab1 GROUP BY col2, col2 HAVING NOT ( NULL ) IS NULL
;

SELECT DISTINCT col1 + col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL + - col1 AS col2 FROM tab0 AS cor0 WHERE NOT ( NULL ) NOT BETWEEN NULL AND NULL GROUP BY col0, col1, col0

;

SELECT DISTINCT - col1 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT + col0 FROM tab0 GROUP BY col1, col0 HAVING NOT NULL IS NULL
;

SELECT - col0 FROM tab2 AS cor0 GROUP BY col0, col0 HAVING NOT NULL = NULL
;

SELECT DISTINCT col0 AS col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT ALL + col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT col2 FROM tab1 AS cor0 GROUP BY col2, col2, col2

;

SELECT - + col0 AS col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT - col2 AS col0 FROM tab0 cor0 GROUP BY col2

;

SELECT ALL - + col0, col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT + col2 FROM tab0 GROUP BY col2, col2 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT - col0 AS col1 FROM tab1 AS cor0 GROUP BY col1, col0, col1 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT DISTINCT - col1 FROM tab0 GROUP BY col1, col0

;

SELECT DISTINCT + col2 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT + + col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT ALL col1 AS col1 FROM tab2 AS cor0 GROUP BY col2, col2, col1

;

SELECT ALL col0 + - col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + col0 + + col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT col0 FROM tab2 AS cor0 GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT ALL col2 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT col2 FROM tab1 GROUP BY col2, col1

;

SELECT - col0 FROM tab2 GROUP BY col0, col1

;

SELECT - col0 AS col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT + col2 AS col2 FROM tab2 AS cor0 GROUP BY col2, col2 HAVING NOT NULL IS NOT NULL
;

SELECT ALL + + col0 * - col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT ALL - + col0 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT + - col1 - col1 AS col2, col1 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT ALL - col2 * + - col2 FROM tab2 GROUP BY col2

;

SELECT col0 AS col2 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL + - col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + + col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT - col2 FROM tab0 cor0 GROUP BY col2, col1

;

SELECT DISTINCT col0 + col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT ALL col1 AS col2 FROM tab2 AS cor0 GROUP BY col1, col0, col1

;

SELECT ALL - - col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT + + col2 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT + col2 AS col1 FROM tab0 cor0 GROUP BY col2, col2

;

SELECT + col2 AS col0 FROM tab1 GROUP BY col2 HAVING NOT ( NULL ) IS NULL
;

SELECT + - col2 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT + col0 * col0 FROM tab2 WHERE NOT ( NULL ) IS NOT NULL GROUP BY col0 HAVING NOT ( NULL ) IS NULL
;

SELECT + col0 FROM tab1 GROUP BY col1, col0 HAVING NOT ( NULL ) IS NULL
;

SELECT ALL - col2 * + col2 + + col0 AS col1 FROM tab2 cor0 WHERE col0 <> NULL GROUP BY col0, col2

;

SELECT DISTINCT - + col1 AS col2 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT col1 FROM tab0 GROUP BY col0, col1

;

SELECT + + SUM ( - col2 ) / - col2 FROM tab1 WHERE NULL <> NULL GROUP BY col1, col2

;

SELECT col1 + - col1 FROM tab0 cor0 WHERE NOT NULL IS NULL GROUP BY col1

;

SELECT DISTINCT + col1 * + col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT + + col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col0 FROM tab0 GROUP BY col2, col0, col0

;

SELECT DISTINCT + col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT + col2 * col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - col2 FROM tab0 AS cor0 GROUP BY col0, col2 HAVING NULL IS NOT NULL
;

SELECT ALL col1 AS col2 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT col1 AS col2, + col1 FROM tab1 AS cor0 GROUP BY col1, col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT + + col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL + col2 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT - col0 FROM tab0 GROUP BY col0, col1 HAVING NULL <= NULL
;

SELECT - + col0 * - col1 AS col2 FROM tab0 cor0 GROUP BY col0, col0, col1

;

SELECT + col0 * + col1 FROM tab0 GROUP BY col1, col0

;

SELECT col2 AS col1 FROM tab2 GROUP BY col1, col2

;

SELECT DISTINCT - col0 AS col1 FROM tab2 cor0 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT - col2 AS col1, col2 AS col0 FROM tab0 GROUP BY col2, col2, col2

;

SELECT - col2 AS col2 FROM tab0 cor0 GROUP BY col2

;

SELECT + col2 FROM tab0 cor0 GROUP BY col2, col1, col0, col0

;

SELECT - col0 AS col2 FROM tab0 AS cor0 GROUP BY col0, col1, col1

;

SELECT + col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL + col1 * col1 FROM tab2 GROUP BY col1

;

SELECT - + col0 FROM tab0 AS cor0 GROUP BY col2, col0 HAVING NOT NULL BETWEEN NULL AND NULL
;

SELECT DISTINCT + + col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL col1 FROM tab1 GROUP BY col1 HAVING NULL NOT BETWEEN NULL AND NULL
;

SELECT col0 FROM tab2 GROUP BY col0, col0

;

SELECT col2 FROM tab0 GROUP BY col2, col2

;

SELECT col1 AS col1 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT ALL + col2 - - col0 AS col0 FROM tab0 cor0 GROUP BY col2, col0, col0

;

SELECT DISTINCT col0 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT col2 * col1 AS col1 FROM tab1 GROUP BY col2, col1

;

SELECT DISTINCT + + col0 AS col2 FROM tab1 AS cor0 GROUP BY col0 HAVING NULL IS NULL
;

SELECT DISTINCT col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT DISTINCT col1 FROM tab2 GROUP BY col1, col1

;

SELECT ALL col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT + - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT + col2 AS col0 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT + col1 FROM tab0 AS cor0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT - col1 * col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - col2 AS col0 FROM tab1 GROUP BY col2, col0

;

SELECT col1 AS col1 FROM tab0 AS cor0 GROUP BY col2, col1 HAVING - col1 IS NOT NULL
;

SELECT ALL col1 FROM tab0 GROUP BY col2, col1

;

SELECT col1 + + col0 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT - col0 AS col1 FROM tab2 GROUP BY col0, col1

;

SELECT DISTINCT - col2 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT col0 AS col2 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT + col0 + + col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + col0 FROM tab1 AS cor0 GROUP BY col0, col0, col1

;

SELECT - col1 FROM tab1 GROUP BY col1, col2

;

SELECT ALL + col0 FROM tab1 GROUP BY col0, col0

;

SELECT - col0 FROM tab1 GROUP BY col1, col0, col0

;

SELECT DISTINCT - col2 AS col0 FROM tab1 cor0 GROUP BY col2, col2

;

SELECT - col0, col0 FROM tab1 AS cor0 WHERE ( NULL ) IS NULL GROUP BY col1, col0, col0

;

SELECT + col2 FROM tab2 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - col2 FROM tab1 AS cor0 GROUP BY col1, col2, col2

;

SELECT DISTINCT + col2 * col2 FROM tab1 GROUP BY col2

;

SELECT - - col1 AS col1 FROM tab1 AS cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT col2 * col2 AS col0 FROM tab1 GROUP BY col2, col2

;

SELECT ALL - col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT - col0 AS col2 FROM tab1 GROUP BY col0 HAVING NOT ( NULL ) = NULL
;

SELECT DISTINCT - col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT col1 * col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT ALL col0 FROM tab2 GROUP BY col1, col0, col1

;

SELECT + col2 FROM tab0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT - col0 FROM tab2 GROUP BY col2, col0, col2

;

SELECT + col0 FROM tab0 cor0 GROUP BY col0

;

SELECT - col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, col0, col0

;

SELECT col0 AS col0 FROM tab1 GROUP BY col0, col2

;

SELECT DISTINCT + col0 AS col1 FROM tab0 GROUP BY col2, col0

;

SELECT - - col2 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT - col2 AS col0 FROM tab1 AS cor0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT + col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT DISTINCT col0 * + col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT col2 AS col1 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT + + col1 * - col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT ALL - col0 AS col0 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT col2 AS col0 FROM tab0 GROUP BY col2, col0

;

SELECT + col2 AS col1, col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT - col0 - col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT + col1 AS col1 FROM tab1 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT ALL + - col2 FROM tab2 AS cor0 GROUP BY col2 HAVING - - col2 IS NULL
;

SELECT DISTINCT + - col1 * + col2 AS col2 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT + col1 AS col0 FROM tab1 GROUP BY col2, col2, col1, col0

;

SELECT DISTINCT - col2 + - col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - col0 + - - col0 AS col0 FROM tab2 GROUP BY col0, col1

;

SELECT col2 AS col1 FROM tab2 GROUP BY col2, col2 HAVING NOT NULL IS NOT NULL
;

SELECT + col0 AS col1 FROM tab2 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT + col2 FROM tab0 AS cor0 WHERE NULL BETWEEN - col1 AND NULL GROUP BY col1, col2, col0

;

SELECT ALL + + col2 FROM tab0 AS cor0 GROUP BY col2 HAVING ( NULL ) >= ( NULL )
;

SELECT ALL + + col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL col0 * col0 FROM tab1 GROUP BY col0

;

SELECT - col0 + - col0 AS col1 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT ALL col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT - col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT ALL + col0 + col0 FROM tab0 AS cor0 GROUP BY col0, col0 HAVING NOT ( NULL ) <> NULL
;

SELECT DISTINCT - + col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT col0 FROM tab0 GROUP BY col0, col0

;

SELECT DISTINCT col0 AS col2 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT - col1 * - col2 AS col2 FROM tab1 cor0 GROUP BY col1, col2

;

SELECT + col2 * SUM ( DISTINCT + col2 ) * - col2 FROM tab0 GROUP BY col0, col2 HAVING NULL IS NOT NULL
;

SELECT ALL col2 AS col2 FROM tab2 GROUP BY col1, col2

;

SELECT DISTINCT - col1 + + col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT - col1 AS col2 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT + - col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT ALL col2 AS col1 FROM tab1 GROUP BY col2, col2

;

SELECT ALL + col1 AS col1 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT - col2 FROM tab2 cor0 GROUP BY col2, col0

;

SELECT ALL + col0 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT ALL - + col2 AS col0 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT + - col0 FROM tab1 AS cor0 GROUP BY col0 HAVING NULL = NULL
;

SELECT ALL col2 FROM tab0 GROUP BY col2 HAVING NOT ( NULL ) IS NULL
;

SELECT col1 AS col1 FROM tab0 AS cor0 WHERE col2 = - col1 GROUP BY col1

;

SELECT ALL - + col1 AS col2 FROM tab1 cor0 GROUP BY col1

;

SELECT ALL + + col0 AS col1 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT + col1 FROM tab0 AS cor0 GROUP BY col1 HAVING ( NULL ) IS NULL
;

SELECT ALL - - col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, col2, col0

;

SELECT DISTINCT - col1 AS col0 FROM tab0 cor0 GROUP BY col1, col2

;

SELECT + - col0 AS col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT + col1 - + col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT ALL - col0 FROM tab2 AS cor0 GROUP BY col0, col1, col1

;

SELECT col2 FROM tab2 GROUP BY col2, col2 HAVING NULL IS NULL
;

SELECT col0 + - col0 FROM tab1 GROUP BY col0 HAVING NOT + SUM ( ALL col0 ) IS NULL
;

SELECT col0 AS col2 FROM tab0 GROUP BY col0, col0

;

SELECT + + col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT + + col1 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT - + col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - col0 FROM tab0 GROUP BY col0, col0

;

SELECT DISTINCT col1 * + col1 * - col1 AS col0 FROM tab2 GROUP BY col0, col1

;

SELECT ALL - col0 AS col2 FROM tab1 AS cor0 GROUP BY col0, col0, col2

;

SELECT col1 FROM tab1 AS cor0 GROUP BY col1, col0 HAVING NOT NULL IS NOT NULL
;

SELECT ALL - col0 FROM tab0 GROUP BY col0, col0

;

SELECT + - col0 * - + col0 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT col2 + - col1 * col2 AS col0 FROM tab2 AS cor0 GROUP BY col1, col2 HAVING ( + col2 ) IS NOT NULL
;

SELECT DISTINCT col1 + - col2 FROM tab1 GROUP BY col1, col0, col2

;

SELECT ALL - - col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - - col2 FROM tab1 AS cor0 GROUP BY col0, col2, col1

;

SELECT ALL + col2 FROM tab1 GROUP BY col0, col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT ALL - col0 FROM tab1 AS cor0 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - col2 FROM tab2 AS cor0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT - col0 AS col0 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT col0, col0 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT - + col0 FROM tab2 AS cor0 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT - - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - + SUM ( col1 ) FROM tab0 AS cor0 GROUP BY col1 HAVING NULL = NULL
;

SELECT col1 FROM tab0 GROUP BY col1, col2

;

SELECT - col1 + + col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - col0 * - - col0 * col0 FROM tab2 cor0 GROUP BY col0

;

SELECT - col1 FROM tab0 AS cor0 GROUP BY col1, col0, col2

;

SELECT DISTINCT - col2 * - col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + col2 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT + col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT ALL - col1 AS col1 FROM tab0 AS cor0 GROUP BY col1 HAVING NULL IS NULL
;

SELECT + col1 + - - col2 + - col1 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT - col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT ALL + col2 FROM tab2 GROUP BY col1, col2, col2

;

SELECT + - col1 AS col2 FROM tab2 AS cor0 GROUP BY col1 HAVING ( NULL ) IS NULL
;

SELECT - + col0 + - col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - col1 FROM tab0 AS cor0 GROUP BY col1, col2, col1

;

SELECT ALL - col1 FROM tab0 GROUP BY col1, col0

;

SELECT - col2 FROM tab1 GROUP BY col2, col0, col2

;

SELECT DISTINCT + col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + col0 AS col0 FROM tab1 GROUP BY col0, col2

;

SELECT + col1 AS col1 FROM tab1 GROUP BY col1, col1

;

SELECT col2 FROM tab0 AS cor0 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - + col1 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT - col2 FROM tab1 WHERE NOT NULL NOT BETWEEN col2 AND NULL GROUP BY col2

;

SELECT + - col0 + - - col0 AS col1 FROM tab0 AS cor0 GROUP BY col1, col0 HAVING NULL IS NOT NULL
;

SELECT ALL col1 AS col1 FROM tab1 GROUP BY col1, col1

;

SELECT - col0 * + col0 + col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT - col2 + - - col1 * col1 AS col2 FROM tab1 GROUP BY col1, col2

;

SELECT DISTINCT - col1 FROM tab1 AS cor0 GROUP BY col1 HAVING - + col1 IS NULL
;

SELECT ALL col2 FROM tab1 GROUP BY col2 HAVING ( NULL ) IS NOT NULL
;

SELECT ALL col1 AS col1 FROM tab1 GROUP BY col1, col2 HAVING NULL IS NULL
;

SELECT DISTINCT - col0 AS col0 FROM tab2 cor0 WHERE NOT NULL BETWEEN NULL AND - col0 GROUP BY col0, col0

;

SELECT DISTINCT + + col1 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT ALL col2 AS col1 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT - col1 AS col0 FROM tab0 AS cor0 GROUP BY col1, col0, col2

;

SELECT + col2 AS col2 FROM tab1 WHERE NOT - + col1 IS NULL GROUP BY col2, col2

;

SELECT + col2 AS col2 FROM tab0 AS cor0 GROUP BY col0, col2 HAVING NOT NULL IS NOT NULL
;

SELECT - col2 - + col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT col2 FROM tab1 GROUP BY col1, col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT col1 AS col2 FROM tab0 cor0 WHERE ( NULL ) IS NOT NULL GROUP BY col1, col2

;

SELECT col0 FROM tab1 GROUP BY col0 HAVING NULL IS NULL
;

SELECT ALL col2 FROM tab0 WHERE NOT ( NULL ) IS NULL GROUP BY col0, col2

;

SELECT - col2 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT - col1 AS col0 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT + col0 FROM tab0 GROUP BY col0 HAVING ( NULL IS NOT NULL )
;

SELECT col2 FROM tab0 AS cor0 GROUP BY col0, col2, col1

;

SELECT ALL col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT col2 AS col1 FROM tab2 GROUP BY col2, col2

;

SELECT DISTINCT - col0 AS col1 FROM tab0 GROUP BY col0, col2, col1

;

SELECT col1 FROM tab2 GROUP BY col1, col1, col2

;

SELECT col0 * col0 AS col1 FROM tab2 GROUP BY col0 HAVING col0 IS NULL
;

SELECT col0 + + + col1 AS col2 FROM tab2 GROUP BY col1, col0 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - col0 AS col2 FROM tab2 GROUP BY col1, col0

;

SELECT + col2 FROM tab1 WHERE NOT NULL IS NOT NULL GROUP BY col2, col0

;

SELECT DISTINCT - col0 FROM tab1 AS cor0 WHERE NOT NULL IS NOT NULL GROUP BY col0, col0

;

SELECT + + col2 FROM tab2 AS cor0 GROUP BY col2 HAVING NOT NULL = NULL
;

SELECT ALL - - col0 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT col0 AS col1 FROM tab2 GROUP BY col0, col0

;

SELECT DISTINCT + + col1 FROM tab0 AS cor0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT - col0 AS col1 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT + col0 FROM tab1 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT - col1 + - col2 FROM tab0 GROUP BY col1, col2

;

SELECT + col2 * + + col2 FROM tab1 GROUP BY col2

;

SELECT ALL + - col2 + + + col2 * + - col2 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT col0 * col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT col1 AS col0 FROM tab1 GROUP BY col1, col0

;

SELECT ALL + + col1 * col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL + col1 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT col2 FROM tab2 GROUP BY col2, col2

;

SELECT - + col2, + col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT ALL - col1 AS col1 FROM tab0 GROUP BY col1, col1, col0

;

SELECT ALL + col2 FROM tab0 AS cor0 GROUP BY col2, col2, col2

;

SELECT + col1 * + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT ALL col2 AS col0 FROM tab1 cor0 GROUP BY col2, col1

;

SELECT col2 * col2 * - + col2 AS col2 FROM tab0 GROUP BY col2, col2 HAVING NULL IS NOT NULL
;

SELECT - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT col0 FROM tab0 cor0 GROUP BY col0, col0

;

SELECT DISTINCT col1 AS col0 FROM tab0 AS cor0 GROUP BY col1 HAVING ( NOT NULL IS NOT NULL )
;

SELECT ALL + col2 AS col1, + col2 * + col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + col1 AS col1 FROM tab2 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT + + col2 FROM tab1 AS cor0 GROUP BY col2, col0, col0

;

SELECT - - col2 FROM tab0 AS cor0 GROUP BY col0, col1, col2

;

SELECT DISTINCT - col0 AS col2 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT ALL - col1 FROM tab0 AS cor0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT ALL + + col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col1 AS col2 FROM tab1 WHERE NOT NULL < NULL GROUP BY col1

;

SELECT + col2 AS col0 FROM tab1 GROUP BY col2 HAVING NULL IS NULL
;

SELECT ALL + col0 AS col2 FROM tab0 cor0 GROUP BY col0, col0

;

SELECT DISTINCT - + col2 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT ALL + col2 AS col0 FROM tab0 GROUP BY col0, col2

;

SELECT + col2 FROM tab1 AS cor0 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT + col2 * col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT + col2 FROM tab2 WHERE NULL IS NULL GROUP BY col2, col2 HAVING ( NULL ) IS NULL
;

SELECT DISTINCT - col0 * - col0 AS col2 FROM tab2 WHERE NOT ( NULL ) IS NULL GROUP BY col2, col0

;

SELECT col1 AS col1 FROM tab1 GROUP BY col1, col2 HAVING ( NULL ) <> ( col1 )
;

SELECT ALL + col2 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT ALL col2 FROM tab0 AS cor0 GROUP BY col2, col2, col2

;

SELECT DISTINCT col1 AS col1 FROM tab2 GROUP BY col1 HAVING + - col1 <> NULL
;

SELECT - - col2 * - col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - col0 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT + - col1 AS col0 FROM tab0 AS cor0 GROUP BY col0, col0, col1

;

SELECT + col2 FROM tab1 WHERE NOT ( NULL ) IS NOT NULL GROUP BY col2

;

SELECT ALL - col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT col0 FROM tab2 AS cor0 GROUP BY col0 HAVING NOT - col0 IS NULL
;

SELECT DISTINCT + col0 FROM tab1 GROUP BY col2, col0

;

SELECT + col1 AS col0 FROM tab0 AS cor0 WHERE NOT NULL IS NULL GROUP BY col1

;

SELECT DISTINCT + col0 FROM tab2 GROUP BY col1, col0, col1

;

SELECT + col0 FROM tab0 AS cor0 GROUP BY col2, col0, col0 HAVING NOT NULL IS NULL
;

SELECT - + col0, col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT col0 AS col1 FROM tab0 cor0 GROUP BY col0, col1

;

SELECT DISTINCT - col2 AS col0 FROM tab1 GROUP BY col0, col2

;

SELECT ALL - col2 AS col2 FROM tab0 GROUP BY col0, col2

;

SELECT ALL col2, col2 FROM tab2 GROUP BY col2

;

SELECT + - col2 AS col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT + col1 * + col1 FROM tab2 GROUP BY col1

;

SELECT col0 + + col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT ALL - + col1 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL + + col2 AS col2 FROM tab1 cor0 GROUP BY col0, col2

;

SELECT - col2 AS col0 FROM tab0 GROUP BY col0, col2

;

SELECT + - col2 FROM tab1 AS cor0 GROUP BY col2, col1 HAVING NULL IS NULL
;

SELECT col1 AS col0, col1 + - col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - col2 * + - col2 FROM tab1 GROUP BY col2, col0

;

SELECT ALL - col1 FROM tab0 AS cor0 GROUP BY col1 HAVING NULL IS NULL
;

SELECT ALL + + col0 + + col0 AS col2 FROM tab0 AS cor0 GROUP BY col0, col0 HAVING NOT NULL < NULL
;

SELECT col2 AS col0 FROM tab0 GROUP BY col2, col2, col0

;

SELECT DISTINCT + col2 + + - col1 FROM tab2 AS cor0 WHERE NOT NULL IS NOT NULL GROUP BY col2, col1

;

SELECT ALL col2 FROM tab0 GROUP BY col2, col2, col1

;

SELECT col2 - + col1 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT - col1 AS col0, col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + col1 FROM tab1 WHERE col1 IS NOT NULL GROUP BY col1

;

SELECT ALL - col0 FROM tab2 AS cor0 GROUP BY col0 HAVING NOT NULL > NULL
;

SELECT + col2 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT + col0 FROM tab0 cor0 GROUP BY col1, col0

;

SELECT ALL + + col2 AS col2, col0 AS col1 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT - col2 AS col2 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT - col1 FROM tab1 cor0 GROUP BY col2, col1, col0 HAVING NULL = NULL
;

SELECT DISTINCT + col2 AS col1 FROM tab0 cor0 GROUP BY col2

;

SELECT - col2 AS col0 FROM tab1 GROUP BY col0, col2

;

SELECT ALL - - col1 AS col1 FROM tab0 cor0 GROUP BY col1

;

SELECT ALL + - col1 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT col1 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT col1 AS col1 FROM tab1 cor0 GROUP BY col2, col1

;

SELECT DISTINCT + + col0 FROM tab2 cor0 GROUP BY col0 HAVING NULL IS NULL
;

SELECT DISTINCT col1 - - col1 AS col2 FROM tab0 GROUP BY col1 HAVING NOT NULL >= NULL
;

SELECT + col1 + col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT + col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT col0 AS col2 FROM tab0 cor0 GROUP BY col0, col0, col0

;

SELECT DISTINCT - col0 FROM tab1 GROUP BY col2, col0

;

SELECT col0 AS col2 FROM tab0 GROUP BY col0, col2

;

SELECT col0 AS col1 FROM tab0 AS cor0 WHERE NOT NULL = NULL GROUP BY col0

;

SELECT ALL col1 * - + col2 AS col2 FROM tab2 GROUP BY col1, col2

;

SELECT ALL + col2 + - col2 FROM tab0 GROUP BY col2

;

SELECT col1 FROM tab1 GROUP BY col1, col2

;

SELECT col0 + - + col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - col0 FROM tab0 GROUP BY col1, col0 HAVING NOT ( NULL ) IS NULL
;

SELECT + col1 * + - col1 FROM tab2 GROUP BY col1

;

SELECT col2 AS col0 FROM tab2 GROUP BY col1, col2

;

SELECT col1 * + - col1 AS col0 FROM tab0 GROUP BY col1, col1

;

SELECT ALL - col0 AS col2 FROM tab1 cor0 GROUP BY col0, col1

;

SELECT - col1 FROM tab0 GROUP BY col1, col0

;

SELECT ALL col1 AS col2 FROM tab2 GROUP BY col1 HAVING NOT NULL BETWEEN NULL AND ( NULL )
;

SELECT col2 FROM tab2 GROUP BY col2, col0

;

SELECT DISTINCT - col2 * - - col1 AS col0 FROM tab0 GROUP BY col1, col2

;

SELECT ALL - col0 AS col0 FROM tab0 AS cor0 GROUP BY col0 HAVING NOT NULL > NULL
;

SELECT ALL + col1 AS col2 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT - + col0 FROM tab2 WHERE + col2 + col1 IS NOT NULL GROUP BY col1, col0

;

SELECT DISTINCT - - col2 + + col2 AS col1 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT col2 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT ALL col0 FROM tab2 GROUP BY col0, col0

;

SELECT DISTINCT - col2 FROM tab1 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT - col2 AS col0 FROM tab2 GROUP BY col2, col1, col1

;

SELECT ALL + - col0 AS col2 FROM tab2 cor0 GROUP BY col0, col0

;

SELECT DISTINCT + col2 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT - - col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + col1 FROM tab0 GROUP BY col0, col1, col2 HAVING NOT col0 * col2 >= NULL
;

SELECT DISTINCT - col1 * col1 + + col1 FROM tab2 GROUP BY col1 HAVING NOT + col1 IS NULL
;

SELECT col2 + - col1 AS col1 FROM tab1 WHERE NOT NULL IS NULL GROUP BY col2, col1 HAVING NOT NULL IS NOT NULL
;

SELECT + col2 AS col1 FROM tab0 GROUP BY col2, col0, col2 HAVING NOT NULL <> NULL
;

SELECT ALL col1 FROM tab2 WHERE NULL IS NULL GROUP BY col1, col2, col1

;

SELECT col0 * col0 FROM tab0 GROUP BY col0 HAVING ( NULL ) IS NOT NULL
;

SELECT DISTINCT + + col2 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT + col1 FROM tab1 GROUP BY col1 HAVING NOT NULL NOT BETWEEN NULL AND NULL
;

SELECT ALL - + col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - - col2 * col2 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL + col0 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT + col1 AS col1 FROM tab0 GROUP BY col1, col1

;

SELECT ALL + col2 FROM tab1 AS cor0 GROUP BY col1, col2, col2

;

SELECT col0 * + col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT ALL col2 + + col1 FROM tab1 GROUP BY col2, col1, col2 HAVING NULL IS NOT NULL
;

SELECT col0 - col0 AS col2 FROM tab0 cor0 GROUP BY col2, col0

;

SELECT ALL col0 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT col1 AS col1 FROM tab1 GROUP BY col2, col1

;

SELECT DISTINCT - + col1 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT ALL - + col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT - col1 AS col1 FROM tab1 AS cor0 GROUP BY col0, col1, col1

;

SELECT col1 FROM tab0 cor0 GROUP BY col2, col1

;

SELECT col0 + col0 AS col1 FROM tab1 GROUP BY col0, col0

;

SELECT + + col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT col2 * col2 * - col2 + + col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT + - col1 FROM tab1 cor0 GROUP BY col0, col1

;

SELECT + - col0 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT col0 AS col0 FROM tab1 AS cor0 WHERE NULL IS NULL GROUP BY col0

;

SELECT col0 AS col0 FROM tab2 GROUP BY col0, col2

;

SELECT + - col2 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT + col0 AS col2 FROM tab0 GROUP BY col0, col0

;

SELECT DISTINCT - col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT col1 - + col1 FROM tab2 GROUP BY col1

;

SELECT ALL - col2 AS col1 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT - col0 AS col2 FROM tab2 cor0 GROUP BY col0, col2

;

SELECT - col2 * + col2 - col2 AS col0 FROM tab0 cor0 GROUP BY col2

;

SELECT + col0 AS col2 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT col1 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT col2 FROM tab0 GROUP BY col1, col2

;

SELECT - + col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - - col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + + col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, col0 HAVING NOT NULL < NULL
;

SELECT ALL col2 - col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - col0 * + + col0 * - + col0 FROM tab2 GROUP BY col0 HAVING - col0 IS NULL
;

SELECT ALL + + col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + col2 FROM tab2 GROUP BY col2, col0 HAVING NOT NULL IS NULL
;

SELECT col0 FROM tab2 GROUP BY col0, col0 HAVING NULL IS NULL
;

SELECT DISTINCT col0 AS col1 FROM tab1 GROUP BY col0, col0

;

SELECT ALL col0 AS col0 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT - + col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - + col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL col1 * - col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT col1 * col1 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT ALL col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT ALL + col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT DISTINCT col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT + col0 AS col2 FROM tab2 GROUP BY col1, col0

;

SELECT - col0 AS col1 FROM tab0 GROUP BY col0, col0 HAVING NULL IS NOT NULL
;

SELECT ALL + col0 AS col2 FROM tab0 GROUP BY col0, col0

;

SELECT ALL + col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT col2 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT + col0 AS col0 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT ALL - col2 AS col0 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT + col0 FROM tab0 AS cor0 GROUP BY col2, col0 HAVING NOT col2 - + - col0 IS NULL
;

SELECT col2 FROM tab2 GROUP BY col0, col2

;

SELECT - col1 AS col1 FROM tab1 GROUP BY col0, col1, col1, col1

;

SELECT DISTINCT + col1, col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + - col2 AS col2 FROM tab1 AS cor0 GROUP BY col1, col2, col0

;

SELECT DISTINCT + col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT ALL col2 FROM tab1 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT col2 AS col0 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT ALL - col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT - - col0 AS col2 FROM tab1 cor0 GROUP BY col1, col0

;

SELECT - - col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, col1 HAVING NULL IS NULL
;

SELECT DISTINCT col1 AS col2 FROM tab2 GROUP BY col1, col1

;

SELECT + + col0 AS col0, col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT ALL - - col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - + col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col1 + + col1 FROM tab0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT ALL + col1 * + col1 * col1 FROM tab1 GROUP BY col1

;

SELECT col0 - + col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT DISTINCT col2 AS col2 FROM tab0 GROUP BY col2 HAVING NOT ( NULL ) < ( NULL )
;

SELECT ALL col0 FROM tab1 GROUP BY col0, col0, col2

;

SELECT - - col0 FROM tab2 WHERE col0 IS NULL GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT - - col0 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT ALL + col0 FROM tab1 AS cor0 WHERE NULL = NULL GROUP BY col0

;

SELECT + - col1 * col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT ALL col0 AS col0 FROM tab0 GROUP BY col0, col0

;

SELECT ALL col0 AS col1 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT col1 AS col2 FROM tab1 AS cor0 GROUP BY col1 HAVING NULL = NULL
;

SELECT ALL + - col0 AS col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT - col1 FROM tab2 GROUP BY col1, col0

;

SELECT ALL col1 + - col1 FROM tab1 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT + col1 AS col0 FROM tab0 GROUP BY col1 HAVING NOT ( - col1 ) IS NULL
;

SELECT ALL col0 + + col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT - col2 FROM tab0 GROUP BY col2, col1, col2

;

SELECT ALL - - col1 FROM tab2 cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT + + col1 AS col0 FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT col2 AS col0 FROM tab0 GROUP BY col2, col0

;

SELECT - - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT col0 AS col0 FROM tab1 AS cor0 GROUP BY col2, col0, col2

;

SELECT ALL + + col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT col2 + + - col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + col2 * col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT col1 FROM tab1 AS cor0 WHERE NULL <= NULL GROUP BY col1, col0, col2

;

SELECT col2 * - col2 FROM tab0 GROUP BY col1, col2 HAVING NOT NULL = NULL
;

SELECT DISTINCT col2 AS col2 FROM tab0 GROUP BY col2, col0

;

SELECT ALL - col0 * col1 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT ALL + col1 AS col0 FROM tab0 AS cor0 GROUP BY col1 HAVING NULL <> NULL
;

SELECT + col2 AS col0 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT ALL - + col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - col2 FROM tab0 AS cor0 GROUP BY col2, col0, col1

;

SELECT ALL - col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT col0 AS col0 FROM tab0 GROUP BY col2, col0

;

SELECT DISTINCT - col2 FROM tab2 GROUP BY col2, col2 HAVING ( NOT NULL < ( NULL ) )
;

SELECT DISTINCT col0 AS col0 FROM tab2 GROUP BY col0, col1

;

SELECT + + col0 FROM tab0 cor0 GROUP BY col2, col0, col0

;

SELECT ALL col1 AS col2 FROM tab2 GROUP BY col1, col2

;

SELECT DISTINCT + col1 AS col2 FROM tab0 AS cor0 WHERE NULL IS NOT NULL GROUP BY col1

;

SELECT ALL + col0 FROM tab2 GROUP BY col2, col0, col0

;

SELECT DISTINCT col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT - + col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL - col1 + - col1 FROM tab2 GROUP BY col1, col1

;

SELECT + col2 FROM tab1 AS cor0 WHERE NULL >= NULL GROUP BY col0, col2

;

SELECT - col2 AS col0 FROM tab0 GROUP BY col1, col2, col0 HAVING NOT NULL IS NULL
;

SELECT - + col0 FROM tab1 cor0 GROUP BY col0

;

SELECT - col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, col2, col1

;

SELECT ALL + - col1 + - col1 AS col1 FROM tab0 AS cor0 GROUP BY col1 HAVING col1 IS NULL
;

SELECT ALL + - col1 AS col1 FROM tab0 cor0 GROUP BY col1

;

SELECT + col2 FROM tab1 AS cor0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT + col1 + col1 FROM tab1 GROUP BY col1

;

SELECT ALL + col0 AS col1 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT + col2 - - col2 FROM tab1 cor0 GROUP BY col0, col2, col2

;

SELECT + col2 AS col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT + col2 FROM tab0 GROUP BY col2, col0

;

SELECT ALL + + col1 FROM tab1 AS cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT + col1 FROM tab2 cor0 GROUP BY col1, col0

;

SELECT ALL col2 FROM tab2 GROUP BY col1, col2

;

SELECT DISTINCT + col0 FROM tab1 GROUP BY col0, col2

;

SELECT col0 - - col0 * - col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL + col2 FROM tab2 cor0 GROUP BY col2, col2

;

SELECT col0 AS col1 FROM tab2 GROUP BY col2, col0 HAVING NULL IS NOT NULL
;

SELECT ALL col0 AS col2, col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + + col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT col1 FROM tab1 GROUP BY col1, col0, col1

;

SELECT - + col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT col0 FROM tab2 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT - + col0 + - col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + + col0 AS col0 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT - col2, + col2 AS col1 FROM tab1 GROUP BY col2 HAVING ( - col2 + col2 ) IS NULL
;

SELECT - col2 FROM tab2 GROUP BY col2, col0

;

SELECT DISTINCT + col0 AS col0 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT - col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT ALL - col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - col0 AS col2 FROM tab2 GROUP BY col0, col0

;

SELECT - col2 * + col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT col1 AS col2, col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT ALL - + col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT col0 + + + col1 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT - col2, col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + col2 - - + col2 AS col0 FROM tab2 GROUP BY col2, col0

;

SELECT DISTINCT + + col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + col2 + + + col2 FROM tab0 GROUP BY col2, col1

;

SELECT ALL - col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT - - col1 + - col1 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT + col2 AS col2, + SUM ( ALL - col2 ) AS col1 FROM tab0 AS cor0 GROUP BY col2 HAVING NOT NULL NOT BETWEEN ( NULL ) AND col2
;

SELECT col1 FROM tab2 GROUP BY col2, col0, col1

;

SELECT ALL - col2 AS col0 FROM tab1 cor0 GROUP BY col2

;

SELECT DISTINCT col1 FROM tab2 GROUP BY col2, col1

;

SELECT DISTINCT + col2 AS col0 FROM tab2 GROUP BY col2, col0

;

SELECT DISTINCT + col2 FROM tab2 GROUP BY col2, col0, col0

;

SELECT + col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + col0 AS col1 FROM tab2 GROUP BY col0, col2 HAVING NOT NULL NOT IN ( + col2 * - + col0 )
;

SELECT DISTINCT - col0 * col0 AS col2 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT - col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col2, col2 HAVING NULL IS NULL
;

SELECT ALL col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT col0 AS col1 FROM tab1 GROUP BY col0, col2

;

SELECT + col1 AS col2 FROM tab1 GROUP BY col1, col2

;

SELECT ALL - col2 FROM tab1 AS cor0 GROUP BY col2, col0 HAVING NOT ( col0 ) IS NULL
;

SELECT - - col1 FROM tab0 AS cor0 GROUP BY col0, col1 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - col2 * col0 AS col0 FROM tab0 GROUP BY col2, col0 HAVING NOT NULL < + + col2
;

SELECT ALL - col2 + + col2 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT col0 FROM tab0 WHERE NOT - + col0 IS NOT NULL GROUP BY col0

;

SELECT DISTINCT + col0 FROM tab2 AS cor0 GROUP BY col0, col2 HAVING NOT NULL IS NOT NULL
;

SELECT + col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT + col0 AS col2 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT SUM ( ALL col1 ) * col1 FROM tab2 WHERE NULL IS NOT NULL GROUP BY col1, col2

;

SELECT DISTINCT + col0 FROM tab1 GROUP BY col0, col0

;

SELECT DISTINCT + col2 * col2 AS col0 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL + col1 FROM tab2 cor0 GROUP BY col1 HAVING NULL >= NULL
;

SELECT DISTINCT + col1 AS col2 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT - col2 AS col2 FROM tab1 GROUP BY col2, col0

;

SELECT DISTINCT - col1 FROM tab1 GROUP BY col1, col1

;

SELECT DISTINCT + col1 FROM tab0 cor0 GROUP BY col1, col2

;

SELECT ALL + col2 FROM tab0 AS cor0 GROUP BY col2, col2 HAVING NOT NULL IS NOT NULL
;

SELECT + col0 AS col1 FROM tab1 GROUP BY col0, col2

;

SELECT DISTINCT - + col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT ALL + col1 AS col0 FROM tab0 AS cor0 GROUP BY col1, col1, col1

;

SELECT ALL col0 AS col0 FROM tab1 GROUP BY col1, col0

;

SELECT col2 FROM tab0 GROUP BY col2, col2 HAVING NULL NOT BETWEEN NULL AND NULL
;

SELECT + col2 FROM tab2 cor0 GROUP BY col2, col0

;

SELECT ALL - col1 AS col2 FROM tab0 GROUP BY col1, col0

;

SELECT ALL - col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT col1 * col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT ALL + - col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col0 AS col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT - col1 AS col2 FROM tab1 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT - col1 FROM tab2 WHERE NOT NULL NOT IN ( col1 ) GROUP BY col1

;

SELECT DISTINCT - col1 + col1 FROM tab1 GROUP BY col1, col2

;

SELECT - SUM ( - col1 ) FROM tab0 WHERE NULL IN ( col1 ) GROUP BY col1, col0

;

SELECT + col0 AS col2 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT - - col1 AS col1 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT col0 FROM tab1 GROUP BY col0, col2, col2

;

SELECT ALL + col1 AS col0 FROM tab2 GROUP BY col1, col1

;

SELECT DISTINCT - col1 FROM tab1 GROUP BY col2, col1

;

SELECT ALL + col2 + + col2 FROM tab2 GROUP BY col2

;

SELECT ALL + col0 AS col0 FROM tab0 AS cor0 GROUP BY col1, col0 HAVING ( NULL ) IS NOT NULL
;

SELECT DISTINCT + col2 + + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT ALL + + col1, + col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT col2 * col2 AS col0 FROM tab1 GROUP BY col2, col2

;

SELECT col0 / - col0 FROM tab2 AS cor0 WHERE NULL IS NOT NULL GROUP BY col0, col2, col0

;

SELECT - col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT ALL - col2 FROM tab0 AS cor0 WHERE NULL = - col2 GROUP BY col2

;

SELECT ALL + col0 FROM tab1 GROUP BY col0, col0, col1

;

SELECT ALL + col0 + + col1 - - col1 AS col0 FROM tab0 GROUP BY col0, col1

;

SELECT ALL + col1 AS col2 FROM tab1 cor0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT - col1 - + col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT + col0 * + col0 FROM tab1 GROUP BY col2, col0

;

SELECT DISTINCT + col0 AS col1 FROM tab0 GROUP BY col2, col0 HAVING NULL > NULL
;

SELECT ALL col0 AS col2 FROM tab2 GROUP BY col2, col0

;

SELECT col1 FROM tab0 GROUP BY col1, col0

;

SELECT ALL - col1 + - + col1 FROM tab1 GROUP BY col1, col2

;

SELECT col1 FROM tab2 AS cor0 GROUP BY col1, col2 HAVING NOT - + col2 IS NOT NULL
;

SELECT DISTINCT - col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT DISTINCT + - col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL + col2 FROM tab2 GROUP BY col2, col0

;

SELECT DISTINCT + col2 AS col0 FROM tab1 AS cor0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT col1 AS col1 FROM tab2 WHERE ( + col1 ) IS NOT NULL GROUP BY col1

;

SELECT DISTINCT col1 + col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL col0 FROM tab1 WHERE col2 > ( - col0 ) GROUP BY col0

;

SELECT - col0 AS col2 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT col2 FROM tab2 GROUP BY col2, col1

;

SELECT col1 * col1 FROM tab2 GROUP BY col1

;

SELECT ALL - - col2 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT ALL + - col2 FROM tab2 AS cor0 GROUP BY col2, col0, col1

;

SELECT ALL col0 * col1 AS col2 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT + - col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT col2 AS col1 FROM tab1 GROUP BY col1, col2

;

SELECT DISTINCT + + col2 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT - col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT + col1 + + + col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT col2 AS col2 FROM tab0 GROUP BY col2, col0

;

SELECT col0 AS col2 FROM tab2 GROUP BY col0, col1

;

SELECT DISTINCT - col2 + + col0 FROM tab2 GROUP BY col0, col2, col1

;

SELECT + col1 AS col0 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT + col1 - col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT col1 * col1 + col1 * - col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + col1 AS col2 FROM tab1 cor0 WHERE NOT NULL <> NULL GROUP BY col1

;

SELECT ALL - - col2 + - - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + col0 FROM tab0 GROUP BY col2, col0 HAVING NULL IS NULL
;

SELECT col1 * + col1 + + + col2 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT col0 FROM tab1 GROUP BY col0, col0 HAVING NOT NULL IS NOT NULL
;

SELECT + + col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT ALL + + col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - col1 FROM tab0 GROUP BY col1, col2

;

SELECT ALL col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT ALL col2 FROM tab0 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT ALL col0 * - col0 FROM tab1 AS cor0 GROUP BY col0 HAVING ( - col0 ) < NULL
;

SELECT col2 FROM tab0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT SUM ( + col1 ) - + col1 AS col2 FROM tab1 GROUP BY col0, col1, col1, col1 HAVING NOT ( NULL ) IS NULL
;

SELECT DISTINCT + col0 - col0 AS col2 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT col2 + col2 AS col2 FROM tab0 GROUP BY col2, col0 HAVING NOT NULL < NULL
;

SELECT - col1 * - + col1 AS col2 FROM tab2 GROUP BY col0, col1

;

SELECT ALL + col2 AS col2 FROM tab0 GROUP BY col2, col2

;

SELECT ALL col0 + + col1 AS col0 FROM tab0 GROUP BY col1, col0 HAVING NOT NULL > NULL
;

SELECT col1 AS col1 FROM tab0 GROUP BY col1, col2, col1, col2

;

SELECT ALL + col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL + - col2, + col1 AS col0 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT ALL + + col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - + col1 FROM tab1 AS cor0 GROUP BY col2, col1, col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT + col2 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT + col0 + + - col1 FROM tab2 GROUP BY col0, col1

;

SELECT col1 AS col2 FROM tab2 GROUP BY col1, col0

;

SELECT DISTINCT + col1 FROM tab2 AS cor0 GROUP BY col1 HAVING NULL IS NULL
;

SELECT ALL col1 AS col1 FROM tab0 GROUP BY col1, col0

;

SELECT col0 FROM tab1 AS cor0 GROUP BY col1, col1, col0

;

SELECT DISTINCT + + col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + - col2 FROM tab1 AS cor0 GROUP BY col2, col1, col0

;

SELECT - col0 FROM tab0 cor0 GROUP BY col0 HAVING ( NULL ) <= NULL
;

SELECT DISTINCT - col1 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT + - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT col2 AS col1, col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + col0 FROM tab0 AS cor0 GROUP BY col2, col1, col0 HAVING NULL IS NOT NULL
;

SELECT col2 AS col2 FROM tab1 GROUP BY col0, col2

;

SELECT ALL - col0 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT col0 AS col1 FROM tab0 GROUP BY col0, col2, col0

;

SELECT ALL - + col2 AS col1 FROM tab1 AS cor0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT + col1 FROM tab0 AS cor0 GROUP BY col1, col1, col0

;

SELECT DISTINCT col2 FROM tab1 GROUP BY col2, col2

;

SELECT + col0 AS col1 FROM tab1 GROUP BY col2, col0

;

SELECT DISTINCT + col1 FROM tab0 AS cor0 GROUP BY col2, col2, col1

;

SELECT DISTINCT - col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT col2 FROM tab0 GROUP BY col1, col2, col2 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT col0 AS col0 FROM tab0 GROUP BY col0, col0

;

SELECT DISTINCT - col2 AS col2 FROM tab1 GROUP BY col2, col1

;

SELECT - + col0 AS col0 FROM tab1 AS cor0 GROUP BY col1, col2, col0 HAVING NOT + col0 / + col2 IS NOT NULL
;

SELECT col1 AS col1 FROM tab2 GROUP BY col1, col2

;

SELECT DISTINCT - col0 AS col1 FROM tab1 AS cor0 GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT ALL col1 FROM tab1 GROUP BY col1, col0

;

SELECT + + col1 FROM tab0 AS cor0 GROUP BY col1, col2 HAVING NOT NULL IS NULL
;

SELECT ALL SUM ( - - col0 ) AS col1 FROM tab2 AS cor0 GROUP BY col0, col0 HAVING NOT NULL IS NULL
;

SELECT - col1, + col1 FROM tab0 cor0 GROUP BY col1, col1

;

SELECT ALL col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col1, col1

;

SELECT DISTINCT + col0 AS col1 FROM tab0 GROUP BY col1, col0

;

SELECT - + col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT ALL col1 FROM tab1 GROUP BY col1, col2 HAVING NOT ( NULL ) > + col2
;

SELECT ALL - col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL - - col1 * - col1 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL + col2 FROM tab0 GROUP BY col0, col2

;

SELECT col0 * - col0 FROM tab1 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT DISTINCT col2 AS col1 FROM tab0 GROUP BY col2, col0

;

SELECT DISTINCT + col2 FROM tab0 GROUP BY col1, col2

;

SELECT DISTINCT col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + - col0 FROM tab0 AS cor0 GROUP BY col0 HAVING ( NULL ) IS NULL
;

SELECT col1 * + col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT col2 + + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col2 FROM tab0 GROUP BY col2, col1

;

SELECT + col1 + - + col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL - col0 FROM tab2 cor0 GROUP BY col0 HAVING NOT NULL BETWEEN NULL AND - - col0
;

SELECT col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, col0 HAVING NULL IS NOT NULL
;

SELECT col1 AS col1 FROM tab1 GROUP BY col2, col1

;

SELECT DISTINCT + col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, col0, col0

;

SELECT DISTINCT - col0 AS col0 FROM tab2 GROUP BY col0, col1 HAVING + SUM ( - col1 ) + + SUM ( DISTINCT + col1 ) IS NULL
;

SELECT ALL + col0 + - col0 AS col0 FROM tab2 GROUP BY col0, col1, col0

;

SELECT ALL + col2 FROM tab1 GROUP BY col2, col0

;

SELECT DISTINCT + - col0 AS col2 FROM tab1 cor0 GROUP BY col0

;

SELECT + col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT - + col1 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT - col2 AS col1 FROM tab2 GROUP BY col2, col0

;

SELECT - + col2 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT - col0 AS col2 FROM tab1 GROUP BY col1, col0, col0

;

SELECT ALL + col2 AS col0 FROM tab2 cor0 GROUP BY col2, col2

;

SELECT DISTINCT col1 AS col2 FROM tab0 GROUP BY col2, col1

;

SELECT SUM ( DISTINCT col0 ) AS col2 FROM tab0 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT + col2 * + col2 + - + col2 * col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL col1 * + - col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT - col2 AS col0 FROM tab0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT ALL col1 FROM tab0 GROUP BY col0, col1

;

SELECT DISTINCT - col1 - - col1 AS col2 FROM tab2 GROUP BY col1 HAVING NULL <> NULL
;

SELECT ALL - col0 AS col0 FROM tab1 cor0 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT + + col1 FROM tab0 cor0 GROUP BY col1

;

SELECT ALL - col2 FROM tab0 GROUP BY col2, col0

;

SELECT DISTINCT col1 FROM tab1 GROUP BY col1, col1 HAVING NOT col1 IS NULL
;

SELECT - col2 - + col2 * col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT ALL + col2 FROM tab0 GROUP BY col2, col1

;

SELECT DISTINCT col1 FROM tab1 GROUP BY col1, col1

;

SELECT DISTINCT col1 AS col2 FROM tab2 GROUP BY col2, col1

;

SELECT + - col1 AS col2 FROM tab2 AS cor0 GROUP BY col1, col0 HAVING NULL IS NOT NULL
;

SELECT ALL - col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT ALL + col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL col1 FROM tab1 cor0 GROUP BY col1

;

SELECT ALL - col2 FROM tab0 GROUP BY col2, col2

;

SELECT col1 FROM tab1 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT ALL col0 - - col0 FROM tab2 cor0 GROUP BY col0

;

SELECT ALL + col1 AS col2 FROM tab1 cor0 GROUP BY col1

;

SELECT ALL - col0 * - col1 FROM tab1 GROUP BY col0, col1 HAVING ( + col1 ) IS NOT NULL
;

SELECT DISTINCT col0 AS col1 FROM tab2 GROUP BY col1, col0

;

SELECT DISTINCT + col1 AS col1 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT - col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT - - col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + col2 FROM tab2 cor0 GROUP BY col1, col2

;

SELECT col0 FROM tab2 AS cor0 GROUP BY col0 HAVING NOT ( NULL ) < ( NULL )
;

SELECT ALL - col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT col2 + + col2 FROM tab0 GROUP BY col1, col2

;

SELECT + col2 * + - col0 AS col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT - + col1 * col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + col2 FROM tab1 cor0 WHERE NOT ( NULL ) IS NOT NULL GROUP BY col2

;

SELECT + col1 AS col1 FROM tab0 GROUP BY col1, col1

;

SELECT ALL col2 FROM tab1 GROUP BY col1, col2

;

SELECT ALL col0 AS col0 FROM tab1 GROUP BY col0, col1

;

SELECT DISTINCT col0 AS col0 FROM tab2 WHERE NOT col1 IS NOT NULL GROUP BY col0

;

SELECT DISTINCT + + col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT + - col2 FROM tab1 cor0 GROUP BY col1, col0, col1, col2 HAVING NULL IS NOT NULL
;

SELECT + + col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - + col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT + - col1 FROM tab2 cor0 GROUP BY col1

;

SELECT - col2 FROM tab0 GROUP BY col2, col2 HAVING NOT NULL IS NULL
;

SELECT col2 - - col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT col2 AS col2 FROM tab1 GROUP BY col1, col2, col1

;

SELECT DISTINCT col1 AS col1 FROM tab0 GROUP BY col1, col1

;

SELECT DISTINCT - col0 + - - col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL - col0 FROM tab2 cor0 GROUP BY col0

;

SELECT DISTINCT + + col2 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT col2 + + col2 * col2 * col1 AS col0 FROM tab2 GROUP BY col1, col2

;

SELECT - col0 * - col1 FROM tab1 GROUP BY col1, col0

;

SELECT ALL - + col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT col0 FROM tab0 GROUP BY col1, col1, col0

;

SELECT ALL - col2 AS col1 FROM tab1 GROUP BY col2, col2

;

SELECT ALL - col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - col0 AS col0 FROM tab0 GROUP BY col2, col0, col1 HAVING NOT ( NULL ) < - col0
;

SELECT ALL + + SUM ( ALL + col1 ) FROM tab2 AS cor0 GROUP BY col1 HAVING ( NULL ) <> NULL
;

SELECT col1 * col2 FROM tab0 AS cor0 GROUP BY col2, col2, col1 HAVING NOT NULL IS NULL
;

SELECT ALL col1 * col1 AS col1 FROM tab2 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - col0 FROM tab1 WHERE NULL IS NULL GROUP BY col0 HAVING NOT + + col0 IS NOT NULL
;

SELECT + + col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT - - col2 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT ALL col1 AS col0 FROM tab0 GROUP BY col1, col1

;

SELECT + col2 AS col1 FROM tab1 GROUP BY col1, col2

;

SELECT ALL - col0 FROM tab2 AS cor0 GROUP BY col0 HAVING NULL IS NULL
;

SELECT + col2 AS col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT ALL - col1 * - + col1 AS col0 FROM tab2 GROUP BY col0, col1

;

SELECT DISTINCT + - col0 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT ALL - col1 * + + col0 AS col2 FROM tab2 GROUP BY col1, col0

;

SELECT - col0 FROM tab0 GROUP BY col2, col0

;

SELECT col1 AS col2 FROM tab1 GROUP BY col1, col1

;

SELECT ALL - col1 + col1 AS col0 FROM tab1 cor0 GROUP BY col1

;

SELECT - col2 AS col1 FROM tab0 AS cor0 GROUP BY col2, col2, col1

;

SELECT ALL + col0 AS col0 FROM tab2 GROUP BY col0 HAVING NULL IS NULL
;

SELECT + col1 * - col1, col1 AS col2 FROM tab0 GROUP BY col1, col1

;

SELECT col1 * - + col1 AS col2 FROM tab1 GROUP BY col0, col1

;

SELECT DISTINCT + col2 AS col0 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT col2 AS col0 FROM tab0 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT - col0 AS col2 FROM tab2 AS cor0 WHERE NOT NULL IS NULL GROUP BY col0

;

SELECT DISTINCT - col1, + col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT col1 FROM tab1 GROUP BY col1, col0

;

SELECT DISTINCT col2 + - SUM ( DISTINCT col1 ) FROM tab0 WHERE NOT - col0 < col0 GROUP BY col1, col2

;

SELECT DISTINCT col2 AS col2 FROM tab1 cor0 GROUP BY col2

;

SELECT - + col2 FROM tab0 AS cor0 GROUP BY col2, col2 HAVING NOT NULL IS NULL
;

SELECT ALL col1 + + col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - + col0 * - col0 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT + - col0 FROM tab2 WHERE NOT NULL NOT BETWEEN NULL AND + + col2 GROUP BY col0, col2, col0

;

SELECT col0 FROM tab0 GROUP BY col0, col2, col1

;

SELECT ALL - col0 AS col0 FROM tab1 GROUP BY col1, col0

;

SELECT ALL col2 FROM tab2 GROUP BY col2 HAVING NULL IS NULL
;

SELECT DISTINCT - - col1 FROM tab2 AS cor0 GROUP BY col1, col1, col2

;

SELECT ALL col1 FROM tab1 GROUP BY col1 HAVING NOT + - col1 IS NULL
;

SELECT DISTINCT col2 * col2 FROM tab2 GROUP BY col0, col2

;

SELECT col2 FROM tab1 GROUP BY col2 HAVING + + col2 IS NULL
;

SELECT DISTINCT + + col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT ALL col2 + - col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT col1 * - + col1 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT col2 + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL col0 - - col0 AS col0 FROM tab2 AS cor0 GROUP BY col0 HAVING - col0 IS NULL
;

SELECT DISTINCT + col2 AS col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT col1 AS col0 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT - - col0 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT - col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT col0 FROM tab1 cor0 WHERE ( NULL ) NOT IN ( col2 ) GROUP BY col0, col0

;

SELECT ALL + + col0 FROM tab1 AS cor0 GROUP BY col0, col2 HAVING NOT NULL = - col0
;

SELECT ALL col1 AS col0 FROM tab0 cor0 GROUP BY col1, col1

;

SELECT ALL col0 AS col1 FROM tab0 AS cor0 GROUP BY col0 HAVING - col0 IS NOT NULL
;

SELECT - col1 AS col1 FROM tab0 GROUP BY col1, col0

;

SELECT - + col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT ALL col1 AS col1 FROM tab1 GROUP BY col0, col1

;

SELECT - col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT col1 + col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT - col0 AS col1 FROM tab2 GROUP BY col2, col1, col0

;

SELECT col1 AS col2 FROM tab2 GROUP BY col1, col2 HAVING NULL IS NULL
;

SELECT DISTINCT + + col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + col0 FROM tab1 AS cor0 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT col2 FROM tab2 GROUP BY col2, col2, col2

;

SELECT + col0 AS col1 FROM tab1 WHERE + col1 IS NULL GROUP BY col0 HAVING NOT - col0 IS NOT NULL
;

SELECT DISTINCT col0 AS col0 FROM tab2 GROUP BY col2, col0

;

SELECT + col0 FROM tab1 GROUP BY col0, col2, col2

;

SELECT ALL col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT col0 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT ALL + - col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + + col2 AS col0 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col2, col0

;

SELECT DISTINCT col1 AS col1 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT + col1 FROM tab1 GROUP BY col2, col1

;

SELECT + col0, col0 + + col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT col1 * col1 * col1 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, col1 HAVING + SUM ( DISTINCT + + col0 ) IS NULL
;

SELECT col2 FROM tab0 AS cor0 WHERE NOT NULL IS NOT NULL GROUP BY col2, col0

;

SELECT DISTINCT - col1 FROM tab1 AS cor0 WHERE ( NULL ) > NULL GROUP BY col1, col1

;

SELECT DISTINCT col0 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT - + col2 + col2 FROM tab1 cor0 GROUP BY col2

;

SELECT ALL + col0 FROM tab1 GROUP BY col2, col0, col0

;

SELECT col0 * col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT col0 AS col1 FROM tab2 GROUP BY col0 HAVING ( NULL ) IS NOT NULL
;

SELECT DISTINCT + col1 FROM tab2 AS cor0 GROUP BY col1, col1 HAVING col1 IS NOT NULL
;

SELECT + col1 FROM tab1 AS cor0 GROUP BY col1, col2 HAVING NULL IS NOT NULL
;

SELECT ALL col0 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT - - col0 FROM tab2 cor0 GROUP BY col0

;

SELECT ALL + col0 FROM tab2 GROUP BY col0, col0

;

SELECT ALL + col2 * + col1 * col1 - - col2 FROM tab0 GROUP BY col2, col1

;

SELECT col1 FROM tab2 AS cor0 GROUP BY col1, col1, col2

;

SELECT - SUM ( + col1 ) + + col1 + + SUM ( DISTINCT + - col1 ) + + col2 FROM tab2 GROUP BY col1, col2 HAVING NULL < NULL
;

SELECT DISTINCT - col2 FROM tab0 AS cor0 GROUP BY col2 HAVING NOT - col2 IS NULL
;

SELECT - col0 * col0 AS col0 FROM tab2 cor0 GROUP BY col0, col2

;

SELECT + col1 * + - col1 * + col0 AS col1 FROM tab0 GROUP BY col0, col1

;

SELECT ALL - - col2 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT - - col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + col2 * - col2 * + col2 FROM tab0 GROUP BY col2

;

SELECT col0 + col1 / - col1 AS col2 FROM tab2 GROUP BY col0, col1 HAVING NULL > NULL
;

SELECT ALL + col1 FROM tab1 GROUP BY col1, col1

;

SELECT + col0 AS col2 FROM tab0 AS cor0 GROUP BY col0, col1, col0

;

SELECT - col0 FROM tab1 GROUP BY col0, col1

;

SELECT - SUM ( + col0 ) AS col2 FROM tab1 AS cor0 GROUP BY col0 HAVING NOT ( NOT NULL = NULL )
;

SELECT DISTINCT - - col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT - - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL - col2 FROM tab0 AS cor0 WHERE NOT ( NULL ) IS NOT NULL GROUP BY col1, col2

;

SELECT DISTINCT col2 FROM tab0 GROUP BY col2, col0 HAVING NOT - + col2 IS NOT NULL
;

SELECT - col2 * + + col2 + - + col2 AS col2 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT - - col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - col2 AS col1 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT ALL col0 * col0 AS col2 FROM tab1 WHERE NULL IS NOT NULL GROUP BY col0

;

SELECT ALL + col2 FROM tab0 GROUP BY col0, col2, col2

;

SELECT DISTINCT - col2 FROM tab0 GROUP BY col2, col2

;

SELECT DISTINCT col0 - col0 AS col0 FROM tab1 GROUP BY col0, col0

;

SELECT ALL + col2 FROM tab0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT ALL col2 AS col2 FROM tab2 GROUP BY col1, col2 HAVING NOT + col2 + - col2 * - col1 IS NULL
;

SELECT - col1 * + col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT col2 + col2 AS col2 FROM tab1 GROUP BY col2, col2

;

SELECT + col2 AS col0 FROM tab0 GROUP BY col2, col2

;

SELECT + col0 + col1 AS col2 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT col0 FROM tab2 GROUP BY col0 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT ALL + col0 AS col1 FROM tab2 GROUP BY col0 HAVING NULL IS NULL
;

SELECT col0 * col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + - col0, + col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT col0 + + col0 FROM tab1 cor0 GROUP BY col0

;

SELECT - col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT - col1 AS col0 FROM tab2 GROUP BY col1, col1

;

SELECT DISTINCT + + col1 AS col2 FROM tab0 cor0 GROUP BY col1

;

SELECT - col2 FROM tab0 cor0 WHERE NOT ( NULL ) >= NULL GROUP BY col2

;

SELECT DISTINCT col2 FROM tab1 GROUP BY col2, col0 HAVING ( NULL ) IS NOT NULL
;

SELECT - col2 * - col2 FROM tab0 cor0 GROUP BY col2

;

SELECT ALL - col2 FROM tab2 cor0 GROUP BY col2 HAVING NOT ( + - col2 ) IS NULL
;

SELECT DISTINCT + col2 FROM tab0 GROUP BY col2, col2

;

SELECT DISTINCT + col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT ALL col1 * - - col1 FROM tab1 GROUP BY col1

;

SELECT col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT col1 - + col2 AS col1 FROM tab2 GROUP BY col2, col1

;

SELECT col1, - col1 FROM tab1 GROUP BY col1 HAVING col1 <> - - col1
;

SELECT + col1 AS col0 FROM tab1 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT ALL col1 FROM tab2 GROUP BY col2, col0, col1

;

SELECT + col0 + + - col0 AS col2 FROM tab0 GROUP BY col0 HAVING NULL IS NULL
;

SELECT DISTINCT col1, col1 AS col1 FROM tab1 cor0 GROUP BY col1, col1

;

SELECT ALL - + col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT - - col1 FROM tab0 AS cor0 GROUP BY col1 HAVING NULL IS NULL
;

SELECT DISTINCT + col2 FROM tab1 AS cor0 GROUP BY col2, col1 HAVING - col2 + SUM ( - col0 ) IS NULL
;

SELECT + - col1 * - col1 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT col0 AS col1 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT ALL col0 FROM tab0 GROUP BY col0, col2, col1

;

SELECT ALL col2 * + col2 - col2 FROM tab0 GROUP BY col2, col2

;

SELECT ALL col1 * col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL col2 FROM tab0 GROUP BY col2, col2, col2

;

SELECT col0 * col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL col2 AS col0 FROM tab0 AS cor0 GROUP BY col0, col2, col2

;

SELECT - - col1 FROM tab1 cor0 GROUP BY col1, col2

;

SELECT col2 + col2 FROM tab0 GROUP BY col2

;

SELECT ALL + col0 FROM tab2 cor0 GROUP BY col0, col2

;

SELECT DISTINCT col1 * - col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + col2 FROM tab2 GROUP BY col0, col2

;

SELECT ALL + col2 FROM tab0 AS cor0 WHERE NULL IS NOT NULL GROUP BY col2, col2

;

SELECT + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT + col2 FROM tab2 GROUP BY col2, col0

;

SELECT ALL - col2, + col1 FROM tab1 GROUP BY col2, col0, col1 HAVING NULL IS NULL
;

SELECT + col2 AS col1 FROM tab2 AS cor0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT + col2 AS col2 FROM tab1 GROUP BY col2 HAVING NULL IS NULL
;

SELECT DISTINCT - col0 * + + col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT col2 AS col1 FROM tab1 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT ALL col1 FROM tab1 GROUP BY col1, col2

;

SELECT col0 AS col2, + col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT col2 + - col2 FROM tab1 AS cor0 GROUP BY col2, col1, col2

;

SELECT col2 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT ALL col2 AS col1 FROM tab2 GROUP BY col2, col0, col2

;

SELECT col1 FROM tab1 GROUP BY col2, col1

;

SELECT col2 AS col1 FROM tab0 AS cor0 GROUP BY col2, col2 HAVING NOT NULL IS NOT NULL
;

SELECT col1, + col1 FROM tab1 GROUP BY col1

;

SELECT ALL - - col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT col1 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT + col0 FROM tab2 GROUP BY col0, col2, col0

;

SELECT DISTINCT + col1 AS col0, + col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT ALL + + col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT col0 - - SUM ( ALL col0 ) / - col0 AS col1 FROM tab2 AS cor0 WHERE NOT NULL IS NULL GROUP BY col0 HAVING ( NULL IS NOT NULL )
;

SELECT - col1 + col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT ALL + col1 * + col1 + - col1 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL + col0 * - col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + col1 FROM tab2 GROUP BY col1

;

SELECT col0 * - col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + col0 AS col0 FROM tab2 GROUP BY col0, col0

;

SELECT - - col1 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT - col1 * + col1 AS col0 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT + + col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - col0 FROM tab2 cor0 GROUP BY col0, col0

;

SELECT ALL - + col1 FROM tab0 AS cor0 GROUP BY col0, col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - col1 - col0 FROM tab0 cor0 GROUP BY col1, col0

;

SELECT - col1 AS col0 FROM tab2 cor0 GROUP BY col2, col1

;

SELECT ALL + - col0 FROM tab2 AS cor0 GROUP BY col2, col0 HAVING NOT ( NOT - col2 IS NOT NULL )
;

SELECT col0 AS col0 FROM tab0 GROUP BY col0, col0 HAVING NOT NULL IS NULL
;

SELECT DISTINCT col2 FROM tab2 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT - col1 * col1 FROM tab2 GROUP BY col1, col1 HAVING col1 IS NULL
;

SELECT ALL col1 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT col2 AS col1 FROM tab0 GROUP BY col2, col1

;

SELECT ALL col1 FROM tab2 AS cor0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT + col0 AS col0 FROM tab1 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT + - col2 + + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - + col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT - + col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + - col2 * - - col2 + + + col2 AS col1 FROM tab1 AS cor0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT ALL - col0 FROM tab0 GROUP BY col0, col1

;

SELECT ALL - col1 FROM tab0 GROUP BY col1, col1

;

SELECT col0 AS col1 FROM tab0 GROUP BY col0, col0

;

SELECT ALL - + col2 AS col2, col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + col2 FROM tab1 GROUP BY col2, col2

;

SELECT + - col0, col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - col0 AS col1 FROM tab2 GROUP BY col0, col2

;

SELECT + col0 FROM tab2 AS cor0 GROUP BY col0 HAVING NULL < NULL
;

SELECT - + col0 * - col0 * - col0 FROM tab2 AS cor0 GROUP BY col0, col0, col0

;

SELECT - col0 AS col2 FROM tab1 GROUP BY col2, col0, col1

;

SELECT ALL - - col1 AS col0 FROM tab1 cor0 GROUP BY col1

;

SELECT col1 AS col1 FROM tab1 GROUP BY col2, col0, col1

;

SELECT ALL col0 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT - + col2 FROM tab1 cor0 GROUP BY col2, col2

;

SELECT ALL + col2 + - col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT ALL + + col2 FROM tab0 cor0 GROUP BY col2

;

SELECT col0 AS col2 FROM tab1 GROUP BY col0, col2

;

SELECT ALL col0 FROM tab1 GROUP BY col0, col0, col1

;

SELECT col0 FROM tab0 GROUP BY col0, col2

;

SELECT ALL + col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT - col1 FROM tab1 GROUP BY col1, col2

;

SELECT ALL - col0 * + col0 * - col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT + col1 AS col0 FROM tab1 AS cor0 WHERE NULL IS NULL GROUP BY col1, col2

;

SELECT - col2 AS col1 FROM tab1 AS cor0 GROUP BY col2 HAVING ( NULL ) IS NULL
;

SELECT - col0 FROM tab2 GROUP BY col0, col0, col1

;

SELECT - col2 AS col2 FROM tab0 GROUP BY col2, col2, col2 HAVING NOT NULL <> NULL
;

SELECT DISTINCT - col2 FROM tab1 AS cor0 GROUP BY col2, col2 HAVING NOT NULL IS NOT NULL
;

SELECT col0 AS col1 FROM tab2 GROUP BY col0, col0

;

SELECT ALL - col1 FROM tab2 AS cor0 GROUP BY col1, col0, col1

;

SELECT - col0 - - col0 + - col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + col1 AS col2 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT col2 - col2 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT + + col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT - col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT + col1 AS col2 FROM tab1 AS cor0 WHERE NOT + col0 IS NOT NULL GROUP BY col1, col0

;

SELECT ALL + col1 FROM tab0 GROUP BY col1 HAVING ( NULL IS NOT NULL )
;

SELECT DISTINCT col1 * col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, col0, col1

;

SELECT ALL + col0 AS col1 FROM tab1 cor0 GROUP BY col0, col1

;

SELECT col0 * - col0 FROM tab0 GROUP BY col0, col0

;

SELECT + col1 AS col1 FROM tab2 GROUP BY col1, col1

;

SELECT - col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT col0 - + col0 AS col2 FROM tab0 GROUP BY col0, col0

;

SELECT DISTINCT + - col1, + col2 AS col0 FROM tab1 AS cor0 GROUP BY col0, col2, col1

;

SELECT - + col0 AS col0 FROM tab2 cor0 GROUP BY col1, col0

;

SELECT DISTINCT + + col2 AS col2 FROM tab2 AS cor0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT ALL - col2 FROM tab0 GROUP BY col1, col2 HAVING col2 * + col2 IS NULL
;

SELECT DISTINCT + col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT + col0 AS col1 FROM tab0 GROUP BY col0, col1

;

SELECT ALL - + col0 AS col0 FROM tab2 cor0 GROUP BY col0

;

SELECT DISTINCT + col0 AS col2 FROM tab2 AS cor0 GROUP BY col1, col0, col1 HAVING NOT NULL BETWEEN NULL AND NULL
;

SELECT ALL col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - col2 AS col2 FROM tab2 GROUP BY col1, col2

;

SELECT ALL + - col0 + + col0 FROM tab1 AS cor0 WHERE col1 IS NOT NULL GROUP BY col0

;

SELECT - - col1 AS col2 FROM tab2 WHERE NULL NOT BETWEEN NULL AND NULL GROUP BY col1

;

SELECT col0 FROM tab2 GROUP BY col0, col0, col2 HAVING NULL IS NOT NULL
;

SELECT - - col1 AS col0 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT col1 FROM tab2 GROUP BY col2, col1

;

SELECT - + col0 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT ALL + - col2 AS col0, col2 AS col2 FROM tab1 AS cor0 GROUP BY col2 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT ALL col1 FROM tab2 GROUP BY col1, col2

;

SELECT DISTINCT + - col2 + col2 FROM tab0 WHERE NOT NULL IS NULL GROUP BY col2, col0

;

SELECT + col0 + + - col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT col0 AS col0 FROM tab1 GROUP BY col1, col0

;

SELECT ALL col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col0, col2

;

SELECT DISTINCT - + col2 AS col0 FROM tab2 AS cor0 GROUP BY col2 HAVING NOT ( NULL ) <= NULL
;

SELECT - col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, col2 HAVING NULL IS NULL
;

SELECT ALL col2 AS col0 FROM tab2 GROUP BY col2, col1

;

SELECT ALL + col2 * - - col2 * col2 AS col2 FROM tab1 AS cor0 GROUP BY col2 HAVING ( NULL ) IS NOT NULL
;

SELECT col2 * + col2 FROM tab2 GROUP BY col2

;

SELECT - col0 - - col2 AS col1 FROM tab2 AS cor0 GROUP BY col0, col2, col0

;

SELECT - - col0 * col0 * + col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL col1 AS col2 FROM tab2 AS cor0 WHERE NOT + col0 <> col0 GROUP BY col1, col1

;

SELECT ALL - col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT + col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, col1, col0

;

SELECT + - col2 AS col1 FROM tab2 cor0 GROUP BY col2, col2 HAVING NOT + col2 IS NULL
;

SELECT DISTINCT col2 + + col2 FROM tab2 GROUP BY col2, col0

;

SELECT ALL col0 FROM tab0 AS cor0 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT - - col1 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL - col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT ALL - col1 AS col1 FROM tab0 GROUP BY col1, col2

;

SELECT + col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT ALL - col2 FROM tab2 GROUP BY col2, col2

;

SELECT ALL - col1 * + - col1 FROM tab0 cor0 GROUP BY col1

;

SELECT ALL + col1 FROM tab2 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - col0 FROM tab2 cor0 GROUP BY col1, col0

;

SELECT ALL col1 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT col2 FROM tab2 WHERE ( NULL ) IS NOT NULL GROUP BY col0, col2

;

SELECT DISTINCT - col2 FROM tab1 WHERE NOT col1 IS NOT NULL GROUP BY col2

;

SELECT col0 FROM tab0 GROUP BY col2, col1, col0

;

SELECT ALL - col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT col0 AS col1 FROM tab1 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT ALL + col0 AS col2 FROM tab2 cor0 GROUP BY col0

;

SELECT - - col1 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT ALL - col0 * col1 + + col1 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT ALL - + col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT col0 AS col2 FROM tab0 cor0 GROUP BY col0

;

SELECT - col0 AS col1 FROM tab0 GROUP BY col0, col0

;

SELECT DISTINCT + col1 FROM tab1 AS cor0 GROUP BY col0, col1 HAVING - + col1 * + col1 * - col0 IS NULL
;

SELECT + col2 FROM tab0 AS cor0 GROUP BY col2, col2

;

SELECT ALL col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT col2, + col2 AS col0 FROM tab2 GROUP BY col2, col1

;

SELECT DISTINCT + col2 FROM tab1 cor0 GROUP BY col0, col2

;

SELECT ALL col0 AS col1 FROM tab2 GROUP BY col0, col2

;

SELECT + col2 AS col1 FROM tab0 GROUP BY col2, col1

;

SELECT col2 AS col2 FROM tab2 GROUP BY col2, col0

;

SELECT ALL + col1 FROM tab0 WHERE NOT NULL IS NULL GROUP BY col1

;

SELECT ALL + + col1 + col1 AS col1 FROM tab0 cor0 GROUP BY col0, col1

;

SELECT + + col0 FROM tab0 cor0 GROUP BY col0, col1

;

SELECT DISTINCT - col2 * + - col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT + col1 AS col2 FROM tab0 AS cor0 WHERE NULL >= ( NULL ) GROUP BY col0, col1

;

SELECT ALL - col1 AS col1 FROM tab0 cor0 GROUP BY col1 HAVING NULL NOT BETWEEN NULL AND NULL
;

SELECT ALL col1 FROM tab2 GROUP BY col1, col1 HAVING ( NULL NOT BETWEEN SUM ( DISTINCT - col2 ) AND NULL )
;

SELECT ALL + + col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT ALL col2 * - col2 * col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT DISTINCT col1 FROM tab0 cor0 GROUP BY col2, col1, col2

;

SELECT + col0 * + - col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT ALL col2 FROM tab1 GROUP BY col2, col2

;

SELECT ALL + col0 AS col2 FROM tab1 cor0 GROUP BY col2, col0

;

SELECT + col0 FROM tab0 GROUP BY col0 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT - col1 FROM tab0 GROUP BY col1, col1

;

SELECT DISTINCT + SUM ( col1 ) * + col1 AS col2 FROM tab2 GROUP BY col1, col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT col1 * - - col1 FROM tab0 GROUP BY col1

;

SELECT ALL col2 AS col2 FROM tab2 WHERE NOT NULL BETWEEN NULL AND NULL GROUP BY col0, col2, col2

;

SELECT - col1 FROM tab0 AS cor0 GROUP BY col2, col1 HAVING NOT NULL IS NULL
;

SELECT ALL - col2 AS col0 FROM tab0 GROUP BY col1, col2

;

SELECT ALL col2 + + + col2 - col2 FROM tab0 GROUP BY col2, col2

;

SELECT + + col2 AS col2 FROM tab1 AS cor0 GROUP BY col0, col2, col2 HAVING NOT NULL < - SUM ( ALL + + col0 )
;

SELECT DISTINCT + col0 FROM tab0 GROUP BY col2, col0

;

SELECT DISTINCT - col1 FROM tab0 GROUP BY col1, col1

;

SELECT ALL col2 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL - col1 + + + col1 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT - col1 AS col0 FROM tab1 GROUP BY col2, col1

;

SELECT + col2 AS col0 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT - - col1 AS col2 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT + - col1 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT - col0 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT col1 * col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - col2 AS col0 FROM tab2 AS cor0 GROUP BY col0, col2, col2 HAVING NULL IS NULL
;

SELECT + col1 AS col0 FROM tab1 GROUP BY col1 HAVING NOT NULL IS NOT NULL
;

SELECT - col2 AS col0 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT ALL col2 AS col2, + col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT DISTINCT col0 AS col1 FROM tab2 GROUP BY col0, col0, col0

;

SELECT - col1 FROM tab0 cor0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - col2 AS col1 FROM tab0 GROUP BY col2, col0

;

SELECT ALL col1 AS col2, + col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT ALL - - col1 * col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT ALL - + col0 * col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT + col0 AS col0 FROM tab1 AS cor0 GROUP BY col0 HAVING NULL IS NULL
;

SELECT + col1 FROM tab2 GROUP BY col2, col1

;

SELECT ALL + col0 FROM tab0 GROUP BY col1, col0

;

SELECT + col1 AS col2 FROM tab2 GROUP BY col1, col1

;

SELECT + col1 + + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + + col0 + + col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL SUM ( col2 ) AS col1, col2 FROM tab1 GROUP BY col2, col2 HAVING NOT NULL NOT BETWEEN - col2 AND NULL
;

SELECT DISTINCT + col1 - + col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT col2 AS col2 FROM tab2 GROUP BY col1, col2

;

SELECT col2 AS col2 FROM tab1 AS cor0 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT - col0 FROM tab1 cor0 GROUP BY col0, col1

;

SELECT ALL + col0 FROM tab2 GROUP BY col2, col0

;

SELECT + col1 * - + col1 FROM tab1 GROUP BY col1

;

SELECT ALL + col1 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT + col0 FROM tab2 GROUP BY col0, col0

;

SELECT DISTINCT + - col1 AS col2 FROM tab0 AS cor0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT ALL - col2, - col2 AS col2 FROM tab0 GROUP BY col2, col2

;

SELECT col1 * - col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT + + col1 AS col0 FROM tab0 AS cor0 GROUP BY col2, col2, col1 HAVING NULL IS NOT NULL
;

SELECT + col0 AS col1 FROM tab2 cor0 GROUP BY col0

;

SELECT + col2 AS col0 FROM tab0 GROUP BY col2, col2, col1 HAVING NOT + SUM ( col2 ) + - - col1 IS NOT NULL
;

SELECT ALL + col2 * + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT col0 AS col0 FROM tab1 GROUP BY col1, col0

;

SELECT DISTINCT - col1 AS col2 FROM tab0 GROUP BY col1, col1

;

SELECT DISTINCT + + col2 FROM tab1 AS cor0 GROUP BY col2, col2

;

SELECT ALL - col0 FROM tab2 GROUP BY col1, col0, col2

;

SELECT col2 + - + col0 - + col2 FROM tab1 GROUP BY col2, col0

;

SELECT DISTINCT - - col2 FROM tab0 AS cor0 GROUP BY col2 HAVING NULL > NULL
;

SELECT DISTINCT - col0 AS col0, - col0 AS col2 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT + col2 - - col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + col0 AS col0 FROM tab1 GROUP BY col0, col1

;

SELECT - + col1 AS col2, col1 + - + col1 * - - col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL - col2 FROM tab0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT ALL + col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT col1 AS col1 FROM tab2 cor0 GROUP BY col1, col1, col1

;

SELECT + col1 * + col1 FROM tab1 GROUP BY col1

;

SELECT ALL - col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT - col2 AS col1 FROM tab0 GROUP BY col2, col2

;

SELECT col1 FROM tab2 GROUP BY col1, col2, col2

;

SELECT ALL col1, col1 * col1 + + col1 + + col1 FROM tab0 GROUP BY col1

;

SELECT + + col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - col0 AS col1, col0 + - col2 AS col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT - col0 AS col2 FROM tab2 cor0 GROUP BY col0, col0, col0

;

SELECT ALL + col2 FROM tab0 GROUP BY col2 HAVING NULL > NULL
;

SELECT ALL col2 * col2 FROM tab2 GROUP BY col0, col2

;

SELECT - - col2 * + col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + + col1 AS col0 FROM tab2 AS cor0 GROUP BY col1, col1

;

SELECT + - col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + + col0 AS col2, col0 FROM tab1 cor0 GROUP BY col1, col0

;

SELECT ALL + - col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT + SUM ( + + col2 ) FROM tab0 cor0 WHERE NOT NULL IS NULL GROUP BY col2

;

SELECT DISTINCT + SUM ( ALL - col0 ) FROM tab2 GROUP BY col0 HAVING NOT NULL IS NULL
;

SELECT DISTINCT + col2 * + - col0 * col0 FROM tab0 GROUP BY col0, col2 HAVING NOT + - col2 IS NULL
;

SELECT + col0 AS col0 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL - + col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT + col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT ALL col0 * col0 - - col1 AS col1 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT + col0 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT - col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - + col2 AS col1, col0 FROM tab2 AS cor0 GROUP BY col0, col2, col0 HAVING NULL < NULL
;

SELECT DISTINCT + - col0 AS col2 FROM tab0 AS cor0 GROUP BY col0, col1

;

SELECT col1 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT ALL + + col0 + - col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT + - col0 + + col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - col2 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT ALL col2 AS col1 FROM tab0 GROUP BY col2, col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - col2 + + col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col1 AS col0 FROM tab0 GROUP BY col1, col1

;

SELECT DISTINCT col1 AS col0 FROM tab2 GROUP BY col1, col1

;

SELECT ALL col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT col2 FROM tab1 AS cor0 GROUP BY col0, col2 HAVING NOT NULL IS NOT NULL
;

SELECT ALL + col1 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT ALL + + col2 * - col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT - col2 AS col1 FROM tab0 AS cor0 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT ALL - col1 + col1 FROM tab2 GROUP BY col1, col1

;

SELECT ALL + + col2 FROM tab1 AS cor0 GROUP BY col2, col1, col1

;

SELECT - col0 * - - col0 FROM tab2 GROUP BY col0, col0

;

SELECT ALL - col0 FROM tab2 GROUP BY col2, col0

;

SELECT col2 FROM tab1 GROUP BY col1, col2, col1

;

SELECT DISTINCT - col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, col0 HAVING col0 IS NULL
;

SELECT + col2 AS col1 FROM tab2 GROUP BY col2, col2

;

SELECT - col2 FROM tab1 WHERE NULL IS NOT NULL GROUP BY col2, col2

;

SELECT ALL + col1 AS col1, col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - col0 * - col0 FROM tab1 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT col0 FROM tab2 GROUP BY col1, col0 HAVING ( + col0 / + col0 ) IS NOT NULL
;

SELECT + col1 + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - col2 FROM tab1 GROUP BY col0, col2

;

SELECT DISTINCT col0 FROM tab2 GROUP BY col2, col0, col0

;

SELECT + - col2 * col2 FROM tab0 AS cor0 GROUP BY col2, col0, col0

;

SELECT DISTINCT - col0 AS col1 FROM tab0 GROUP BY col1, col0

;

SELECT - col1 FROM tab0 AS cor0 GROUP BY col1, col2, col1

;

SELECT - col0 AS col0 FROM tab0 GROUP BY col0, col0

;

SELECT - col1 AS col2 FROM tab1 GROUP BY col1 HAVING NOT - + SUM ( - col1 ) IS NULL
;

SELECT DISTINCT col2 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT col2 FROM tab2 GROUP BY col2, col1 HAVING NULL IS NULL
;

SELECT ALL col0 + col0 FROM tab2 GROUP BY col0

;

SELECT + col0 FROM tab2 AS cor0 GROUP BY col0, col0, col2

;

SELECT DISTINCT - col1 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - + col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT col2 AS col0 FROM tab0 AS cor0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT - col1, col1 FROM tab2 AS cor0 GROUP BY col1, col2 HAVING NOT ( NULL ) BETWEEN NULL AND NULL
;

SELECT - col2 AS col2 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT col1 AS col0 FROM tab2 AS cor0 WHERE NOT NULL <= NULL GROUP BY col1

;

SELECT DISTINCT - col0 FROM tab0 cor0 GROUP BY col0, col0

;

SELECT DISTINCT col1 AS col2, - col1 + - col1 FROM tab0 cor0 GROUP BY col1, col2

;

SELECT ALL col0 FROM tab0 GROUP BY col0, col1 HAVING NOT NULL IS NULL
;

SELECT + col1 FROM tab1 GROUP BY col2, col0, col1

;

SELECT col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT + col0 * - col1 FROM tab0 AS cor0 GROUP BY col1, col0, col0

;

SELECT DISTINCT col2 - + col2 FROM tab1 GROUP BY col2, col2

;

SELECT ALL - col0 FROM tab1 AS cor0 GROUP BY col0, col0, col2, col2

;

SELECT DISTINCT col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, col2 HAVING NULL IS NULL
;

SELECT col1 * + col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT col1 + - col2 AS col1 FROM tab0 GROUP BY col2, col1

;

SELECT ALL + col0 + col0 * + col0 FROM tab2 GROUP BY col0

;

SELECT + col0 + - - col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT + - col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT - col0 AS col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT ALL col1 + + col1 * col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT ALL + col2 FROM tab0 AS cor0 GROUP BY col2, col2 HAVING - + col2 IS NOT NULL
;

SELECT col1 * col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT col1 * + + col1 FROM tab1 AS cor0 GROUP BY col1 HAVING NOT col1 < NULL
;

SELECT ALL col1 AS col1, col2 * col2 AS col2 FROM tab1 AS cor0 GROUP BY col2, col1, col2

;

SELECT DISTINCT + - col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - col1 FROM tab2 GROUP BY col0, col1, col1

;

SELECT col1 AS col1 FROM tab2 GROUP BY col1, col1

;

SELECT ALL col0 FROM tab2 GROUP BY col1, col0

;

SELECT ALL col2 AS col0 FROM tab1 cor0 GROUP BY col2

;

SELECT ALL - col0 AS col1 FROM tab0 AS cor0 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT ALL - + col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col1 AS col2 FROM tab2 GROUP BY col1, col1

;

SELECT ALL - col1 AS col2 FROM tab0 GROUP BY col1, col0, col2

;

SELECT ALL col2 AS col1 FROM tab0 AS cor0 GROUP BY col2, col1 HAVING NOT NULL NOT BETWEEN NULL AND NULL
;

SELECT ALL - + col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + col1 AS col2 FROM tab0 cor0 GROUP BY col1, col0

;

SELECT DISTINCT - col0 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT col2 FROM tab1 AS cor0 GROUP BY col1, col2, col1

;

SELECT col0 AS col1 FROM tab0 cor0 GROUP BY col1, col0

;

SELECT + col0 * - - col0 FROM tab2 GROUP BY col0, col0

;

SELECT col2 * - - col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT ALL + col2 FROM tab1 AS cor0 WHERE col2 <> col0 GROUP BY col0, col0, col2 HAVING NULL < NULL
;

SELECT - col2 * + col2 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT ALL - col2 AS col0 FROM tab0 cor0 GROUP BY col2, col0

;

SELECT DISTINCT - + col0 - - - col0 AS col2 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT col0 + - col2 FROM tab1 GROUP BY col2, col0

;

SELECT ALL col2 AS col0 FROM tab1 AS cor0 GROUP BY col1, col2

;

SELECT - - col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT col2 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT ALL - col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT + col2 FROM tab1 GROUP BY col2 HAVING NULL IS NULL
;

SELECT DISTINCT - col1 AS col1 FROM tab1 GROUP BY col1, col1

;

SELECT - + col0 AS col2 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL col2 FROM tab2 WHERE NOT NULL IS NULL GROUP BY col2, col2

;

SELECT ALL + col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, col0 HAVING ( - col2 ) IS NOT NULL
;

SELECT - + col2 FROM tab1 AS cor0 WHERE NULL <> - col0 GROUP BY col2

;

SELECT - col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, col1, col0

;

SELECT col1 AS col0 FROM tab1 GROUP BY col1, col2

;

SELECT col2, col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - col2 + col2 AS col1 FROM tab0 GROUP BY col2, col2

;

SELECT DISTINCT col2 AS col0 FROM tab1 AS cor0 GROUP BY col2, col2, col2

;

SELECT ALL - - col2 FROM tab0 cor0 GROUP BY col2, col0

;

SELECT DISTINCT col2 AS col0 FROM tab1 AS cor0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col0

;

SELECT col1 + + col0 AS col0 FROM tab1 GROUP BY col0, col1

;

SELECT DISTINCT col2 FROM tab2 GROUP BY col2, col2

;

SELECT DISTINCT - col1 AS col2 FROM tab2 cor0 GROUP BY col0, col1

;

SELECT - - col0, + col1 * col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, col0, col1

;

SELECT ALL - col1 FROM tab2 AS cor0 GROUP BY col1, col2 HAVING NULL IS NULL
;

SELECT DISTINCT + col1 FROM tab0 AS cor0 GROUP BY col1, col2 HAVING NULL IS NOT NULL
;

SELECT + - col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + col1 - + - col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT col1 * - + col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + col0 * + col0 AS col2 FROM tab1 AS cor0 GROUP BY col0, col1 HAVING NULL IS NOT NULL
;

SELECT ALL + col1 AS col2 FROM tab2 AS cor0 GROUP BY col1 HAVING NULL < NULL
;

SELECT + col2 FROM tab2 WHERE NOT NULL IS NULL GROUP BY col0, col2 HAVING NOT NULL < NULL
;

SELECT col1 + + col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT col1 FROM tab2 GROUP BY col1, col2

;

SELECT - col1 AS col1 FROM tab1 GROUP BY col1, col1 HAVING NOT SUM ( - col2 ) > NULL
;

SELECT col2 + + col2 AS col1 FROM tab1 GROUP BY col0, col2

;

SELECT + col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT + - col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL + col2 AS col2 FROM tab2 cor0 WHERE NOT col0 IS NOT NULL GROUP BY col2, col0, col0

;

SELECT ALL + col2 AS col1 FROM tab0 GROUP BY col2, col2

;

SELECT DISTINCT col2 FROM tab1 GROUP BY col2 HAVING + + col2 NOT BETWEEN NULL AND NULL
;

SELECT ALL + col1 - col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT - - col2 AS col1 FROM tab2 AS cor0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT - col0 - col1 AS col0 FROM tab0 GROUP BY col1, col0

;

SELECT DISTINCT - + col0 AS col0, col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL col2 * + col2 FROM tab0 GROUP BY col2

;

SELECT ALL - col0 FROM tab1 GROUP BY col1, col0

;

SELECT DISTINCT + col0 FROM tab2 GROUP BY col2, col0

;

SELECT - col0 - col0 FROM tab0 GROUP BY col0, col1 HAVING NOT NULL IS NULL
;

SELECT - + col1 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT + - col2 * + col2 AS col1, - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT col1, col1 FROM tab1 GROUP BY col1

;

SELECT + col1 + col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - col0 AS col0 FROM tab0 cor0 GROUP BY col0, col2

;

SELECT ALL - col0 AS col1, col0 FROM tab0 GROUP BY col0

;

SELECT - col0 AS col0 FROM tab1 GROUP BY col0, col1, col1

;

SELECT DISTINCT col0 FROM tab0 AS cor0 GROUP BY col2, col0 HAVING NOT NULL IS NULL
;

SELECT + col2 FROM tab0 GROUP BY col2, col2

;

SELECT + - col0 AS col2 FROM tab2 AS cor0 WHERE NOT + col0 IS NULL GROUP BY col0

;

SELECT ALL - col1 + - col1 FROM tab1 GROUP BY col1 HAVING NOT + SUM ( col2 ) IS NOT NULL
;

SELECT + col1 AS col0 FROM tab1 AS cor0 WHERE NOT ( NULL ) < NULL GROUP BY col1

;

SELECT - col2 AS col0, - col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL col2 + + col2 AS col1, + col1 AS col0 FROM tab1 GROUP BY col2, col1 HAVING NULL IS NULL
;

SELECT ALL col2 AS col2 FROM tab2 cor0 GROUP BY col2

;

SELECT - col1 AS col2 FROM tab1 GROUP BY col1, col0 HAVING NOT - col1 + - + col1 IS NULL
;

SELECT DISTINCT + col2 - + - col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col1 * col1 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT col0 FROM tab2 GROUP BY col0, col2 HAVING NULL <> NULL
;

SELECT DISTINCT col0 AS col1 FROM tab2 AS cor0 GROUP BY col0 HAVING NOT SUM ( DISTINCT col1 ) IS NOT NULL
;

SELECT + col1 FROM tab1 GROUP BY col1, col1, col2

;

SELECT + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT + col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT + col1 AS col1 FROM tab2 GROUP BY col1, col0

;

SELECT ALL - col1 FROM tab2 WHERE NOT NULL IS NOT NULL GROUP BY col0, col1

;

SELECT ALL col0 + + col0 - - col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, col0 HAVING NULL IS NOT NULL
;

SELECT DISTINCT + col1 AS col2, col1 * col1 FROM tab1 GROUP BY col1

;

SELECT col0 * col0 AS col0 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT col1 FROM tab2 AS cor0 GROUP BY col2, col1, col1

;

SELECT col1 AS col1 FROM tab0 GROUP BY col1, col0, col2, col2

;

SELECT ALL - col1 FROM tab1 GROUP BY col1, col1

;

SELECT col1 AS col2, col1 AS col0 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT - col1 AS col1 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL + col1 FROM tab1 cor0 GROUP BY col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT col0 FROM tab1 GROUP BY col1, col0

;

SELECT DISTINCT + - col1 - - col1 FROM tab0 cor0 GROUP BY col1

;

SELECT col2 AS col2, - col2 AS col0 FROM tab1 GROUP BY col2

;

