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

SELECT DISTINCT - 53 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT NULLIF ( cor0.col0, cor0.col0 ) FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL + 79 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 43 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + 0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT 79 * tab2.col2 + - 76 FROM tab2, tab1 AS cor0 GROUP BY tab2.col2

;

SELECT DISTINCT - 31 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 33 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT - col2 FROM tab0 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT ALL col1 / cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NOT NULL
;

SELECT + 0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - - 17 AS col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col0 * - 21 + - 37 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL cor0.col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT col2 * - 85 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col0 * + 60 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 81 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 78 * col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + 7 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 27 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 87 + - cor0.col2 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor1.col0 FROM tab1, tab1 AS cor0, tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + cor0.col1 - + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * - 67 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - ( cor0.col0 + - cor0.col0 ) * - cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + 51 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 + + ( col1 ) AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + 2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + + 99 AS col1 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - + 23 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + 65 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - ( cor0.col2 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - ( cor0.col2 ) * col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT 25 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col0 FROM tab1 cor0 GROUP BY col0, col2

;

SELECT DISTINCT - col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 - + 48 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 10 AS col0 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 25 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 38 AS col2 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 49 * - 23 AS col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 4 FROM tab0 GROUP BY tab0.col0

;

SELECT 53 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 + + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 21 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 23 * - cor0.col1 - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL cor0.col1 * - cor0.col1 + 58 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 20 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 15 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 39 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL + + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT COALESCE ( cor0.col2, - cor0.col2 * + cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + 69 * tab1.col2 AS col2 FROM tab1, tab0 AS cor0 GROUP BY tab1.col2

;

SELECT - col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col1 + - col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - cor0.col2 FROM tab2, tab2 cor0 GROUP BY cor0.col2

;

SELECT col2 * tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 74 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + 57 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 35 FROM tab2 cor0 GROUP BY col1

;

SELECT + 60 + 38 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 34 * + 97 * cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 10 + - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT - 92 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - 2 + 50 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT NULLIF ( 87, - tab2.col0 ) AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT ( - 34 ) FROM tab0 AS cor0 GROUP BY col0

;

SELECT 65 * - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 21 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + cor0.col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT - - cor0.col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 28 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + cor0.col0 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col0 + + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 41 * - 61 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 * 26 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col0 FROM tab0 GROUP BY col0

;

SELECT ALL 0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * 1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2, col2

;

SELECT COALESCE ( cor0.col1, - cor0.col1 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 76 * 78 AS col0 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - cor0.col1 - - cor0.col1 * cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 98 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + 45 FROM tab2 GROUP BY tab2.col0

;

SELECT - - 17 AS col1 FROM tab1, tab1 AS cor0, tab1 AS cor1 GROUP BY tab1.col1

;

SELECT + 11 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + col2 AS col1 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT col0 AS col1 FROM tab2 cor0 GROUP BY col0

;

SELECT DISTINCT 93 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * - 13 - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 79 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 17 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - - 88 + cor0.col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - + 48 FROM tab1, tab0 AS cor0, tab0 AS cor1 GROUP BY cor1.col1

;

SELECT - 96 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 22 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col1 * 20 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + cor0.col0 + 25 AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col1, cor0.col2

;

SELECT + 58 AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL COALESCE ( 77, + cor0.col2 ) * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 47 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 80 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT cor0.col0 + + ( cor0.col0 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 99 + - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 30 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 69 FROM tab2 cor0 GROUP BY col2

;

SELECT - 85 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col0 * col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT 25 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 97 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT + col0 * col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - - 93 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, col0

;

SELECT ALL cor0.col1 * 60 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ( cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + - 7 + - cor0.col2 AS col2 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 17 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 96 + 28 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - col2 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col2 * 29 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col1 FROM tab2, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT COALESCE ( cor0.col0, cor0.col0 + 60 ) * + 30 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 20 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 12 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 37 * col1 * - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL + 1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 84 + 24 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 31 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 12 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 54 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT + 13 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 44 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT + cor0.col1 + col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 * cor0.col1 AS col0 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT + 44 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 50 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 50 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col0

;

SELECT ALL ( + 54 + - cor0.col2 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col2

;

SELECT ALL + ( 36 ) AS col2 FROM tab1, tab0 cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT - 67 + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 67 AS col0 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 48 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - + 16 FROM tab1 GROUP BY col0

;

SELECT DISTINCT cor0.col0 + + 28 AS col0 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 69 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 48 * 80 AS col2 FROM tab1 cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col2

;

SELECT DISTINCT 96 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT 77 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 3 + 97 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT ALL - 57 * + 0 * - cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL - 97 FROM tab1 GROUP BY col1

;

SELECT DISTINCT + 80 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + 31 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL 3 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 81 * + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1, cor0.col2

;

SELECT - + 99 * - 66 FROM tab2, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, col0, cor0.col1

;

SELECT ALL 75 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 68 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + cor0.col0 + + 68 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL + - 16 FROM tab2 GROUP BY col1

;

SELECT ALL - cor0.col1 AS col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 * 94 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 27 + 59 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 + + 35 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 32 * cor0.col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + tab2.col0 + - tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + cor0.col0 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT + cor0.col2 * + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING NULL IS NOT NULL
;

SELECT DISTINCT + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT 53 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - + tab2.col1 AS col2 FROM tab2, tab1 AS cor0 GROUP BY tab2.col1

;

SELECT DISTINCT - 87 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + ( 4 ) AS col1 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col2 * - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 50 * + cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + cor0.col0 + - cor0.col0 * - col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT cor0.col0 * 17 * col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING ( NULL ) IS NOT NULL
;

SELECT ALL cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NOT ( cor0.col1 + cor0.col1 ) IS NULL
;

SELECT DISTINCT col0 * - 58 AS col1 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 32 AS col1 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 80 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT COALESCE ( cor0.col0 * + 83, 35, + cor0.col0 ) + - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 33 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 + - cor0.col1 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT cor0.col0 FROM tab2 AS cor0 GROUP BY col1, col0, cor0.col0

;

SELECT cor1.col0 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col0, cor1.col1

;

SELECT DISTINCT cor0.col0 + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 24 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT - 18 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 17 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col1 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 23 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT 74 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + 54 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + - 90 FROM tab0, tab2 AS cor0 GROUP BY tab0.col0

;

SELECT + 89 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 54 AS col2 FROM tab1, tab2 AS cor0, tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + - 66 FROM tab0, tab2 AS cor0, tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT 22 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 19 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 94 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 61 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 68 + col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + cor0.col2 AS col2 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT 84 + - col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col0 AS col1 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT 64 * - 91 AS col0 FROM tab2 cor0 GROUP BY cor0.col1, col2

;

SELECT ALL + 17 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 13 + - 29 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 87 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + ( cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 7 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 + - 52 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col1 + + 3 AS col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT cor0.col1 * - 7 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT + 60 * - 95 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 68 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT DISTINCT - col0 FROM tab1 GROUP BY col0

;

SELECT + 39 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 41 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 86 + cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - ( cor0.col0 ) AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL 92 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - cor0.col0 + 39 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 + + 66 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL cor1.col1 + + 18 FROM tab0, tab0 cor0, tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL cor0.col0 * + cor0.col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL - cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 0 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT 73 * cor0.col1 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT - cor0.col2 * cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT + 42 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 88 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 93 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - 79 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 6 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL 37 AS col2 FROM tab1, tab2 cor0 GROUP BY tab1.col1

;

SELECT - ( - 14 ) + - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 7 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 14 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL + col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT 64 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 99 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL 4 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 21 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 13 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col1 + 48 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 96 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 68 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 54 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col1

;

SELECT ALL col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - cor0.col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 50 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT 96 - cor0.col0 * - cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT 21 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - 89 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - 41 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT 52 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT + 26 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - + 5 FROM tab0, tab1 AS cor0 GROUP BY tab0.col0

;

SELECT cor0.col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL - cor0.col2 + - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 * + 37 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 98 * + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT + 49 * 73 AS col2 FROM tab0 cor0 GROUP BY col1

;

SELECT ALL cor0.col1 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + cor0.col2 - - 90 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + ( - cor0.col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 33 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 83 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + - 72 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col0 * 90 + col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 7 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL 5 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 4 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 67 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + ( - cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT NULLIF ( cor0.col0, cor0.col0 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 90 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 95 * 78 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + ( col1 ) AS col1 FROM tab2 GROUP BY col1

;

SELECT cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 20 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col0 AS col1 FROM tab2 cor0 GROUP BY col0, cor0.col1

;

SELECT 65 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT + cor0.col2 + 9 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - + 96 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 63 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + 42 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 29 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor1.col0 * cor1.col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0, cor0.col2

;

SELECT DISTINCT cor0.col0 + + 64 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 87 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 79 + + 23 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 42 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - ( col2 ) FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 65 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col2 + + 13 * - 82 * cor0.col2 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 AS col2 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + col2 + cor0.col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 31 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col1 + + 17 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT - 86 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + ( cor0.col1 ) - - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col1 HAVING NOT ( cor0.col1 ) IS NULL
;

SELECT DISTINCT + 4 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 26 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + col0 - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT ALL cor0.col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, col2

;

SELECT - 66 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 67 - + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL + - tab2.col0 FROM tab2, tab2 AS cor0 GROUP BY tab2.col0

;

SELECT DISTINCT - col0 + cor0.col0 * cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 77 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + + cor0.col0 AS col2 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 63 * cor0.col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 33 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 94 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 59 + + 9 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ( - cor0.col1 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 36 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 87 * + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - cor0.col1 * cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col1 + col1 * cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + tab2.col1 + + 61 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - ( 13 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 51 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 * 77 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + cor0.col2 FROM tab0, tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + 70 * 37 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1, col0, cor0.col1

;

SELECT cor0.col1 * + cor0.col1 - - col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - 53 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL - 54 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + tab1.col1 * 3 - + 90 FROM tab1, tab2 AS cor0, tab2 AS cor1 GROUP BY tab1.col1

;

SELECT DISTINCT + cor0.col2 * 93 AS col0 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 89 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 34 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - 94 * 63 FROM tab2, tab1 AS cor0, tab1 AS cor1 GROUP BY tab2.col2

;

SELECT + cor0.col1 * cor0.col1 - 52 * + col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab2.col2 FROM tab2 GROUP BY col2 HAVING NOT ( NULL ) >= NULL
;

SELECT DISTINCT col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 11 * 67 AS col0 FROM tab2, tab2 cor0 GROUP BY cor0.col1

;

SELECT 96 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL 87 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 19 + 77 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 34 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL 6 + cor0.col0 - + 47 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL 36 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 * cor0.col0 FROM tab1 cor0 GROUP BY cor0.col1, col0

;

SELECT 34 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - 41 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + cor0.col1 + - 17 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT DISTINCT col1 * + cor0.col1 * 24 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT - 38 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 31 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - cor0.col0 * 38 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 52 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 38 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, col1

;

SELECT - 32 + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + cor0.col1 * col2 + col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + cor0.col0 + + col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - cor0.col2 + 53 * + 10 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - 18 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 71 AS col2 FROM tab0, tab2 AS cor0, tab0 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + 72 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 63 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 54 AS col2 FROM tab1, tab2 AS cor0, tab2 AS cor1 GROUP BY cor1.col1

;

SELECT + cor0.col1 * col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT 23 FROM tab0 GROUP BY col0

;

SELECT - 54 FROM tab2, tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 57 AS col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 43 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col0 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING ( NULL ) IS NOT NULL
;

SELECT ALL 72 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL col1 + + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + cor0.col0 + 29 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 29 * 91 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT + 72 + + cor0.col2 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 85 + - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 * - col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 89 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT ALL - 33 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col1 * COALESCE ( cor0.col0, cor0.col2 ) * + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT DISTINCT 69 * cor0.col0 FROM tab2 cor0 GROUP BY col0

;

SELECT + cor0.col2 * + 78 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 10 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 82 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL 33 * 30 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 33 AS col1 FROM tab2 cor0 GROUP BY col2, cor0.col2

;

SELECT ALL cor0.col0 * 6 FROM tab0 cor0 GROUP BY cor0.col0, col2, cor0.col1

;

SELECT - 84 * + 60 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - 61 FROM tab2, tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 + + 45 AS col1 FROM tab1, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 94 + 73 + col0 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT - + cor1.col0 FROM tab1, tab0 AS cor0, tab2 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT 47 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 * + 75 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 0 * + 49 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 27 + col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 96 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab2.col1 * 1 AS col2 FROM tab2, tab1 AS cor0 GROUP BY tab2.col1

;

SELECT ALL - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL - cor0.col0 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + 29 + - col1 + + cor0.col1 * + 64 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 66 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 * - col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL >= ( NULL )
;

SELECT DISTINCT + col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 94 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 * 67 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + col2 * col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 24 + 89 FROM tab2, tab0 cor0, tab2 AS cor1 GROUP BY cor0.col2

;

SELECT cor0.col0 * cor0.col0 AS col2 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 * + 42 + - 49 AS col0 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 59 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col0 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT tab2.col0 FROM tab2 WHERE ( NULL ) NOT BETWEEN NULL AND + col2 * + col1 GROUP BY col0

;

SELECT + 49 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col0

;

SELECT ALL 26 + - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 18 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT ALL + col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 42 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 * - cor0.col0 FROM tab0 cor0 GROUP BY col0

;

SELECT col0 * cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 97 * - cor0.col0 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 69 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 74 FROM tab0, tab2 cor0 GROUP BY tab0.col1

;

SELECT DISTINCT 58 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 95 * col1 * - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 28 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 37 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 38 * col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 * + ( + 66 ) + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 2 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 11 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL 64 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 65 * col0 * + 34 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 82 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - 70 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * - 45 AS col2 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col2 * cor0.col1 + cor0.col2 FROM tab2 AS cor0 GROUP BY col1, col2

;

SELECT DISTINCT 74 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + 30 * + cor0.col0 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL 47 FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 46 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + 68 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 * + cor0.col2 * - 67 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 6 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col2 + cor0.col2 * cor0.col1 AS col0 FROM tab2 cor0 GROUP BY col2, cor0.col1

;

SELECT - - cor0.col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - tab2.col0 + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab0 GROUP BY cor0.col2

;

SELECT ALL 21 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + 87 * + cor0.col0 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 10 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT - - 92 AS col1 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 46 AS col0 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT 63 + 48 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT - 9 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + 30 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - - 12 AS col2 FROM tab1, tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 34 * 94 * - cor0.col2 - - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 AS col2 FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 44 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 73 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col1 * - cor0.col1 * ( - cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + + cor0.col2 AS col2 FROM tab0, tab1 AS cor0, tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 + - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + col0 * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT - cor0.col2 * 25 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 13 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 2 + col2 * - cor0.col0 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT DISTINCT - cor0.col2 + - cor0.col2 + + 63 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 59 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT ( col2 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 81 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 52 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 38 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 35 * + cor0.col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + + cor0.col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - ( + col1 ) + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 0 + + cor0.col0 + - cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 48 AS col1 FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 * - col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT col1 * cor0.col1 * + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 85 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 57 AS col0 FROM tab2 cor0 GROUP BY col2

;

SELECT - 35 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL 4 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 72 FROM tab0 AS cor0 GROUP BY col0, cor0.col0

;

SELECT ALL 43 * - 87 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 58 * cor0.col2 AS col0 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL - - 73 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col1 * + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 16 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 73 * 10 AS col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 29 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col2 * + 67 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT - 72 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - tab0.col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT - 67 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 29 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 53 AS col2 FROM tab2, tab2 cor0 GROUP BY cor0.col2

;

SELECT 82 * - col0 AS col0 FROM tab0 cor0 GROUP BY col0

;

SELECT + 1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 27 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT 35 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - ( + 37 + + cor0.col2 ) AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL - + cor0.col2 AS col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + 22 + 47 FROM tab0 GROUP BY tab0.col1

;

SELECT - 36 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 43 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT - 94 * - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 8 + tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 22 FROM tab2 GROUP BY col1

;

SELECT col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 41 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 14 + - 38 FROM tab1 GROUP BY tab1.col0

;

SELECT - 91 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + + cor0.col2 AS col0 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 53 FROM tab0, tab2 AS cor0 GROUP BY tab0.col0

;

SELECT - ( 25 ) FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 96 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL - cor0.col1 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - tab2.col2 * - 33 + 17 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT 95 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 79 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 + + 22 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT tab0.col1 + - col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + cor0.col1 * + cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT + cor0.col0 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ( + 96 ) * cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 65 * - col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT ALL 60 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 75 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 69 FROM tab0 cor0 GROUP BY col1

;

SELECT - 16 + + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 * + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 93 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 * cor0.col0 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 93 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 + - col1 * cor0.col1 * 25 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 15 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 46 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 36 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 31 FROM tab0, tab1 AS cor0, tab0 cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - cor0.col1 * 69 - - 35 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0, cor0.col0

;

SELECT + ( + CASE - col2 WHEN - cor0.col2 THEN cor0.col1 ELSE NULL END ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT + ( 39 ) FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col0 - + cor0.col0 * cor0.col0 * 60 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 * + 97 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 AS col1 FROM tab2 cor0 WHERE NOT ( NULL ) NOT BETWEEN ( NULL ) AND NULL GROUP BY col2

;

SELECT tab0.col1 * tab0.col1 FROM tab0 GROUP BY tab0.col1 HAVING NULL IS NOT NULL
;

SELECT DISTINCT - 0 * - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 80 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 58 + + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT DISTINCT 42 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 22 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 45 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT + cor0.col2 * cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col0 AS col2 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 1 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT 85 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 53 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col0

;

SELECT 20 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 16 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + + cor0.col2 * cor0.col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 30 AS col1 FROM tab0, tab0 AS cor0 GROUP BY tab0.col0

;

SELECT ALL cor0.col0 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor0.col2

;

SELECT DISTINCT col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT DISTINCT + 54 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 80 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT 66 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 74 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - + 73 * + 46 AS col1 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 24 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 9 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 5 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - + 23 FROM tab0 GROUP BY tab0.col2

;

SELECT ( 37 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 99 * - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + 85 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - 21 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 92 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 AS col0 FROM tab2 cor0 GROUP BY col2

;

SELECT 90 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 90 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 - + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 51 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT ( 10 ) * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT - 7 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 15 + + 43 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col0 * - cor0.col0 * + 95 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT cor0.col1 + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - 28 + - cor0.col1 + cor0.col1 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 46 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 75 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 42 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + - 27 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 9 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT tab1.col2 - + 10 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + - cor0.col0 * + 74 * 23 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor1.col1 + cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor1.col1

;

SELECT - 54 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 75 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 67 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col2 * cor0.col2 + + 14 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 * - 56 - 73 FROM tab2, tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 94 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 54 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor1.col2

;

SELECT ALL - 38 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 AS col0 FROM tab0 cor0 GROUP BY col0

;

SELECT - cor0.col0 * - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 46 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + 43 FROM tab2 AS cor0 GROUP BY col0

;

SELECT 34 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - col0 * 15 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 22 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col0 + - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 8 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 / + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NULL
;

SELECT - col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col0 HAVING NULL IS NULL
;

SELECT ALL cor1.col2 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2 HAVING NULL > ( NULL )
;

SELECT ALL - + tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + cor0.col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 53 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 * col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + col1 + col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - tab2.col0 AS col0 FROM tab2 GROUP BY col0 HAVING NULL IS NOT NULL
;

SELECT ALL 97 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + cor0.col0 + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + tab2.col0 FROM tab2, tab1 AS cor0 GROUP BY tab2.col0

;

SELECT - - cor0.col0 AS col2 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 * - 53 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT + + 94 AS col1 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 15 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL 61 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL 94 * cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT - + 85 * + cor0.col1 + + 67 * 89 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 26 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT 17 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col0 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + 66 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + cor0.col0 * + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - - cor0.col1 AS col1 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - + 90 AS col2 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 18 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - tab2.col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT ALL 99 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 51 AS col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 31 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - cor0.col1 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0, cor0.col2

;

SELECT DISTINCT - 10 + - cor0.col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT - cor0.col2 + + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + cor0.col2 + cor0.col2 AS col2 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 35 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - 81 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col1 + - cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, col1, cor0.col0

;

SELECT ALL - 36 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 94 * + 44 + cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - 64 + tab1.col2 FROM tab1, tab2 AS cor0 GROUP BY tab1.col2

;

SELECT ALL - 91 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 81 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 26 FROM tab1, tab1 AS cor0, tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - 55 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + + 60 * + cor0.col0 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 * - cor0.col1 * cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 33 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col1 * + cor0.col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col2, col1

;

SELECT ALL cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT cor0.col0 * - cor0.col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT DISTINCT 13 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 * 80 FROM tab1 AS cor0 GROUP BY col1, cor0.col0, cor0.col1

;

SELECT + 41 * cor0.col1 AS col1 FROM tab1, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 18 FROM tab0, tab2 AS cor0, tab1 cor1 GROUP BY cor1.col0

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + 18 * - cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 60 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 45 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col0 AS col0 FROM tab2 cor0 GROUP BY col0

;

SELECT - 51 FROM tab1 cor0 GROUP BY col1

;

SELECT 28 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 90 FROM tab1, tab2 AS cor0 GROUP BY tab1.col0

;

SELECT cor0.col1 AS col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 89 AS col1 FROM tab1, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col1 * - cor0.col1 + - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + col0 * + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 34 FROM tab1 cor0 GROUP BY col1

;

SELECT 93 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 29 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - - 95 FROM tab0 GROUP BY col2

;

SELECT ALL - 23 + + cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + 59 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 44 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT + 44 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + 57 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 - cor0.col1 AS col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col2 - 82 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * 28 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col0 FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 AS col0 FROM tab0 cor0 GROUP BY col0

;

SELECT + cor0.col2 * col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - cor0.col2 AS col1 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 97 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT col0 * - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + 18 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - cor0.col1 * ( - 53 ) FROM tab0 AS cor0 GROUP BY col1

;

SELECT + cor0.col1 * 17 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - ( cor0.col2 ) + cor0.col2 AS col1 FROM tab1 cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL 62 * tab2.col2 AS col0 FROM tab2, tab1 AS cor0 GROUP BY tab2.col2

;

SELECT NULLIF ( - cor0.col0, - 97 ) + 40 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 77 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 * - ( + cor0.col1 ) - col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 20 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT - 9 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT DISTINCT + 66 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - cor0.col0 AS col0 FROM tab1 cor0 GROUP BY col0, cor0.col2

;

SELECT + 34 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 61 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col0 * - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - cor0.col1 * 13 + - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 51 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 60 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + col2 * + cor0.col2 * cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + col1 * 92 * - 93 + cor0.col1 FROM tab2 cor0 GROUP BY col1

;

SELECT 85 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 96 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - + col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT col1 * + ( cor0.col1 ) + + cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL - 61 + - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 - - cor0.col1 AS col0 FROM tab1, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 8 + 56 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - 90 * 7 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 68 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL col2 AS col1 FROM tab2 WHERE tab2.col0 IS NULL GROUP BY tab2.col2

;

SELECT + tab2.col1 AS col2 FROM tab2 GROUP BY col1 HAVING NOT NULL NOT BETWEEN NULL AND NULL
;

SELECT ALL + tab2.col2 AS col2 FROM tab2 WHERE NULL IS NOT NULL GROUP BY tab2.col2

;

SELECT ALL + 0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 18 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 11 + + col1 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - ( + cor0.col2 ) AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT DISTINCT - - cor1.col0 FROM tab0, tab1 cor0, tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 0 + - 65 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - col0 * + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + 16 FROM tab0 GROUP BY col0

;

SELECT ALL + 92 FROM tab1 GROUP BY col0

;

SELECT cor0.col1 + col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - 6 + - cor0.col1 + 85 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 62 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col0 * - cor0.col0 FROM tab2, tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL 31 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 55 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col1 * ( + 12 ) + - col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 76 * - 60 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 97 + cor0.col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 26 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 6 * cor0.col0 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 63 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 32 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + 61 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT cor0.col1 * cor0.col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, col2

;

SELECT 70 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 86 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 75 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - col0 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT - + 43 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 76 AS col0 FROM tab1, tab2 AS cor0, tab0 AS cor1 GROUP BY cor0.col1

;

SELECT + col1 AS col0 FROM tab0 GROUP BY tab0.col1 HAVING NULL IS NOT NULL
;

SELECT + col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 * + cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col0 + - col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 77 + - col0 * + ( + 29 ) AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 55 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL NULLIF ( - cor0.col2, + cor0.col2 ) * 35 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL - ( 48 ) FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - cor0.col2 + + col0 * - cor0.col0 + 67 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - col0 * + 10 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 35 AS col1 FROM tab0 cor0 GROUP BY cor0.col2, col0

;

SELECT ALL 55 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col1 + + col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT col2 AS col2 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT ALL 54 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 AS col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 33 AS col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, col1

;

SELECT + col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT ALL cor0.col0 * cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL cor0.col1 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT + 83 FROM tab1 cor0 GROUP BY col2

;

SELECT COALESCE ( - cor0.col1, col2 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col1 + cor0.col1 FROM tab2 cor0 GROUP BY col2, col0, cor0.col1

;

SELECT 93 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - + ( + 12 ) FROM tab2, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 6 * + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col2 * 80 + + 88 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL cor0.col1 AS col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 48 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 86 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 3 + - 60 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 FROM tab0, tab0 cor0 GROUP BY cor0.col1

;

SELECT 90 + + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 66 FROM tab0 GROUP BY col1

;

SELECT - 51 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 9 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 73 * 50 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 88 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL col2 * cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ( + cor0.col0 + - col0 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 86 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 3 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col1 AS col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col0 AS col2 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 * + cor0.col2 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ( - 80 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 99 - - 59 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 39 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT ALL + 20 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - 75 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col2 * + cor0.col2 * - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col2 * - ( + tab1.col2 ) - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 78 AS col1 FROM tab2, tab2 AS cor0, tab0 AS cor1 GROUP BY cor0.col2

;

SELECT - 55 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT DISTINCT - 23 AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 AS col1 FROM tab0 cor0 GROUP BY cor0.col2, col0

;

SELECT - cor0.col0 * - ( - cor0.col1 ) * + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + cor0.col0 * + cor0.col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 52 * cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT col2 * cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + 99 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL 18 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT DISTINCT + 94 FROM tab2 AS cor0 GROUP BY col0

;

SELECT tab0.col0 + tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 77 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 + + cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL 9 AS col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 36 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 35 * - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT col1 + - 31 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + ( - cor0.col2 ) FROM tab2 AS cor0 GROUP BY col2

;

SELECT - - cor0.col1 AS col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 16 AS col1 FROM tab1, tab1 AS cor0 GROUP BY tab1.col0

;

SELECT ( 59 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 11 FROM tab2 AS cor0 GROUP BY col0

;

SELECT cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - 55 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 86 AS col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 86 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - + 36 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 8 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 56 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL - 32 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - 42 AS col2 FROM tab2, tab2 AS cor0, tab0 AS cor1 GROUP BY cor1.col0

;

SELECT tab0.col0 * tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 35 AS col2 FROM tab0, tab0 AS cor0 GROUP BY tab0.col2

;

SELECT ALL - 48 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 78 FROM tab2 GROUP BY col2

;

SELECT ALL + 76 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 55 AS col2 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col0 * 37 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - - 60 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, col2

;

SELECT - 98 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 97 - 43 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col1 FROM tab0 cor0 GROUP BY col0, cor0.col1

;

SELECT ALL - 82 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 95 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 94 + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col0

;

SELECT DISTINCT 87 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 60 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 38 * col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + 45 * 57 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 36 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 43 AS col0 FROM tab0, tab2 AS cor0 GROUP BY tab0.col1

;

SELECT ALL cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 88 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 22 * - 92 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 * - 43 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ( 17 ) * + 33 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - ( cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - cor0.col0 + 51 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col0 * + cor0.col0 * + col2 + 29 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 57 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL + 61 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - 34 + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col0, cor0.col1

;

SELECT ALL 65 AS col1 FROM tab0, tab0 AS cor0, tab1 AS cor1 GROUP BY cor1.col0

;

SELECT 55 * 78 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL 11 AS col2 FROM tab2 cor0 GROUP BY col0

;

SELECT ALL - cor0.col1 * cor0.col1 - + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 33 AS col2 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( 92 ) * + cor0.col1 * - col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 91 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, cor0.col0

;

SELECT 77 + col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 76 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 41 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 89 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + cor0.col1 * 98 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ( 1 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 11 AS col0 FROM tab1 cor0 GROUP BY col2

;

SELECT - 16 FROM tab1 GROUP BY tab1.col2

;

SELECT 20 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col2 AS col1 FROM tab1, tab1 AS cor0, tab0 AS cor1 GROUP BY cor0.col2

;

SELECT - + 44 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + + 68 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + tab0.col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT + 60 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 86 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT - 26 FROM tab2, tab2 AS cor0, tab1 AS cor1 GROUP BY cor0.col1

;

SELECT 49 * 50 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 * + 71 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT 47 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col2 + + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT cor0.col2 * 44 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 26 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 + - 19 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT col0 * ( + 54 * cor0.col2 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL cor0.col1 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 41 * + 68 AS col2 FROM tab0, tab1 AS cor0, tab0 AS cor1 GROUP BY cor1.col2

;

SELECT + 51 - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0, col2

;

SELECT 94 - + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + ( + cor0.col2 * cor0.col2 + + 87 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + cor0.col0 * ( col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + - 59 FROM tab1, tab0 AS cor0 GROUP BY tab1.col1

;

SELECT ALL - - cor0.col1 AS col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 57 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT DISTINCT - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT DISTINCT + col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 18 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + + tab0.col2 FROM tab0 GROUP BY col2

;

SELECT + col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - ( col2 ) * + tab0.col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT + 63 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 55 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT COALESCE ( - 54, - cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 * cor0.col0 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - 46 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + - 27 AS col2 FROM tab0 GROUP BY col1

;

SELECT ALL + cor0.col0 * - 64 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 49 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - 11 * cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col2 * - 68 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col2 + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - cor0.col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 FROM tab1 AS cor0 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT + cor1.col2 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT 63 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 48 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 41 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 37 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 99 + - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + cor0.col1 * 73 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 * cor0.col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - - 66 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - + cor0.col0 AS col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 63 * - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT ALL - 32 * cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - 90 * 0 AS col1 FROM tab1, tab2 AS cor0, tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + cor0.col0 + - cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL - 46 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 AS col0 FROM tab1, tab2 cor0, tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL 68 + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 * + col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 80 FROM tab1 GROUP BY col1

;

SELECT + 85 + 46 AS col1 FROM tab0 GROUP BY col0

;

SELECT + cor0.col1 + col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + ( 94 * 10 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 93 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + 89 AS col0 FROM tab0, tab0 AS cor0 GROUP BY tab0.col1

;

SELECT ALL - cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 26 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 41 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL 7 * 26 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 44 + 98 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 32 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + ( + 10 ) FROM tab0 AS cor0 GROUP BY col0

;

SELECT + + 22 FROM tab1, tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 13 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col2 - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL col2 FROM tab2 AS cor0 WHERE NOT NULL IS NULL AND NOT ( NULL ) BETWEEN NULL AND cor0.col0 OR NOT NULL <= ( cor0.col0 ) GROUP BY cor0.col2

;

SELECT - 70 + col1 * col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 62 * cor0.col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL col1 * + cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT cor0.col0 * - CASE + cor0.col1 WHEN cor0.col1 THEN + col0 END * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 79 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col1 * + 45 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 39 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT col0 * - cor0.col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + 59 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT col0 FROM tab0 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NOT NULL
;

SELECT - col1 * - cor0.col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - 15 FROM tab1, tab1 AS cor0 GROUP BY tab1.col1

;

SELECT ALL 15 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 57 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 86 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + 4 + col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + 61 * - 24 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 81 AS col0 FROM tab0, tab0 AS cor0, tab0 AS cor1 GROUP BY cor1.col1

;

SELECT cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL - 9 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + tab1.col0 AS col0 FROM tab1, tab2 AS cor0 GROUP BY tab1.col0

;

SELECT - ( 81 ) AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 16 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + ( - cor0.col1 ) FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 37 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 5 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT 29 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 0 * 41 FROM tab1, tab1 AS cor0, tab2 AS cor1 GROUP BY tab1.col2

;

SELECT ALL - 42 + + cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 + + 1 * 79 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT 56 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 75 - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - + cor0.col0 AS col1 FROM tab1, tab1 cor0 GROUP BY cor0.col0

;

SELECT 65 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col2 + - col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL cor0.col2 * 23 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 33 AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT cor0.col2 * cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col2 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col0 * ( cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL col2 AS col0 FROM tab0 GROUP BY tab0.col2 HAVING NOT NULL <> NULL
;

SELECT tab0.col0 * tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT - 89 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL 14 * - COALESCE ( - 87, tab0.col2 ) AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + cor0.col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, col2

;

SELECT - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + 40 + 1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + - 82 FROM tab1 GROUP BY col1

;

SELECT + ( cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - ( + col2 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 18 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 56 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 AS col1 FROM tab0 cor0 GROUP BY col1, cor0.col1

;

SELECT ALL + cor0.col0 * cor0.col2 + + cor0.col2 + 37 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - - tab2.col2 FROM tab2, tab0 AS cor0 GROUP BY tab2.col2

;

SELECT cor0.col1 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - ( cor0.col2 ) AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 29 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 81 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 33 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT 97 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col1 AS col1 FROM tab1, tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 AS col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 * 93 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 + + 19 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 66 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 84 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 76 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT ALL + 73 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT + cor1.col1 + cor1.col1 FROM tab2, tab1 AS cor0, tab1 AS cor1 GROUP BY cor1.col1

;

SELECT 0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 1 FROM tab1 AS cor0 GROUP BY col0, cor0.col2, cor0.col0

;

SELECT 85 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 69 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL + CASE - cor0.col1 WHEN - 29 * cor0.col1 THEN NULL ELSE + 5 END AS col2 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + 51 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 37 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + + 49 FROM tab0, tab2 AS cor0, tab1 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - cor1.col0 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 96 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 13 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 61 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 35 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 26 + col2 FROM tab1 cor0 GROUP BY col2

;

SELECT ALL - 18 + - cor0.col0 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 11 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 36 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 92 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 45 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 19 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 48 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 25 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - 13 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 68 FROM tab2 GROUP BY tab2.col2

;

SELECT - tab0.col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT - 12 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT ALL 8 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT 40 + - cor0.col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 37 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 24 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 60 FROM tab1, tab1 AS cor0, tab0 AS cor1 GROUP BY cor0.col2

;

SELECT 19 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 9 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT - - ( + 36 ) FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + ( cor0.col1 ) * + cor0.col1 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 33 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + - 47 FROM tab2, tab2 AS cor0, tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT col0 + - ( cor0.col0 ) - + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 + col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL cor0.col0 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 93 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - 57 FROM tab2 GROUP BY tab2.col2

;

SELECT ( cor0.col2 ) AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - ( + cor0.col1 ) + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + 46 AS col2 FROM tab2, tab1 cor0 GROUP BY tab2.col1

;

SELECT DISTINCT 65 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 + 36 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL - 77 * col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT + 89 * - 34 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + col0 / + tab0.col0 FROM tab0 WHERE NOT ( NULL ) IS NULL GROUP BY tab0.col0

;

SELECT DISTINCT col1 AS col2 FROM tab2 WHERE NOT NULL IS NULL GROUP BY tab2.col1

;

SELECT DISTINCT + col2 * + col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NULL
;

SELECT DISTINCT cor0.col2 * + cor0.col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT + cor1.col0 FROM tab2, tab2 AS cor0, tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - 86 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col2

;

SELECT ALL + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1, cor0.col1

;

SELECT - 69 * 65 FROM tab1, tab0 AS cor0 GROUP BY tab1.col0

;

SELECT ALL 1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 * ( + cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 28 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - - 47 FROM tab2, tab0 AS cor0, tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - 19 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 96 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col1 * + ( - cor0.col1 ) FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 82 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + - tab1.col1 + - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + 76 * 81 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + cor0.col0 * 92 * + 12 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - 90 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - COALESCE ( - 89, cor0.col2, + cor0.col2 ) + + NULLIF ( - 30, + cor0.col2 * + 47 ) AS col0 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL cor1.col0 * + 11 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ( - cor0.col0 + + cor0.col0 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL 98 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 77 FROM tab2, tab1 AS cor0, tab0 cor1 GROUP BY tab2.col1

;

SELECT 24 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 14 * + 86 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - ( 34 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + 85 + cor0.col0 * - 42 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 63 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING ( NULL ) IS NOT NULL
;

SELECT ALL + col0 / cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL <= NULL
;

SELECT - tab0.col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT + cor0.col2 + cor0.col2 FROM tab1 AS cor0 CROSS JOIN tab0 GROUP BY cor0.col2 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT ALL cor0.col1 + + col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL + col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 80 * + cor0.col1 + - cor0.col1 + + NULLIF ( cor0.col1, cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1, cor0.col0

;

SELECT DISTINCT + cor0.col1 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 54 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor0.col2

;

SELECT - col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + - 36 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col1 FROM tab1 GROUP BY tab1.col1 HAVING NULL IS NOT NULL
;

SELECT ALL - cor0.col1 + - cor0.col1 * - cor0.col1 AS col1 FROM tab0, tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1, col2

;

SELECT cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor1.col2, cor1.col0

;

SELECT col1 * + 57 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 39 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT - 72 AS col2 FROM tab0, tab1 AS cor0, tab1 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT + cor0.col2 AS col1 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + ( - 24 ) FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 * + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL 68 * cor0.col0 + 68 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 34 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 28 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT COALESCE ( - 0 * + col0 + - 14, 24, col0 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, col0

;

SELECT ALL - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT ALL + 81 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab0.col1 * - 34 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT cor1.col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT 88 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - 71 AS col1 FROM tab1, tab2 AS cor0 GROUP BY tab1.col0

;

SELECT cor0.col2 * col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT 39 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 0 - - 90 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT - cor0.col2 AS col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 7 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - cor0.col0 * 43 + - 58 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT COALESCE ( + 44, cor0.col2, - 39 ) + - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 23 + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + cor0.col0 + 39 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ( - col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - cor0.col1 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, col1

;

SELECT - cor0.col0 + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - 62 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 50 AS col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 65 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT cor0.col0 + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 35 AS col0 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL ( + 69 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 30 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + 97 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + 63 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 12 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT + cor0.col1 + cor0.col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col1, cor0.col1

;

SELECT ALL - 42 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 81 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 80 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT NULLIF ( cor0.col2, - cor0.col2 ) * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 54 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 85 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 86 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT col2 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + 1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + col1 * 69 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 83 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 23 AS col2 FROM tab1, tab2 AS cor0 GROUP BY tab1.col1

;

SELECT ALL 50 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 30 AS col0 FROM tab1, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 1 * - cor0.col1 AS col0 FROM tab0, tab1 cor0, tab1 cor1 GROUP BY cor0.col1

;

SELECT ALL + NULLIF ( + cor0.col1, cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 10 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 51 FROM tab0, tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 + 82 * - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 80 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT 36 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 46 - + col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 36 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 63 FROM tab1, tab2 AS cor0, tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + NULLIF ( - tab2.col2, - tab2.col2 ) FROM tab2 GROUP BY tab2.col2

;

SELECT 53 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT + tab2.col1 * tab2.col1 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col0 + - 81 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - tab0.col0 FROM tab0 GROUP BY col0

;

SELECT + 92 FROM tab0 cor0 GROUP BY col1

;

SELECT 65 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT - 76 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 85 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + + 26 * 39 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 19 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col1 AS col2 FROM tab0 cor0 GROUP BY col1

;

SELECT - - 33 + 5 AS col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - tab1.col1 - - 58 FROM tab1, tab1 AS cor0 GROUP BY tab1.col1

;

SELECT DISTINCT - tab1.col0 AS col0 FROM tab1, tab0 AS cor0 GROUP BY tab1.col0

;

SELECT - 39 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + + 42 * 91 AS col0 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - cor0.col2 * - cor0.col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL COALESCE ( + 8, cor0.col0 * col0, + cor0.col1 ) + cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, col0

;

SELECT 6 AS col0 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col0, cor0.col1

;

SELECT ALL - 71 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT - cor0.col2 * + col0 * - COALESCE ( cor0.col0 * cor0.col2, - cor0.col0 ) FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT ALL + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col2 - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col0, cor0.col2

;

SELECT DISTINCT 29 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL + - 82 + 3 FROM tab1 GROUP BY tab1.col0

;

SELECT + col2 FROM tab0 GROUP BY col2

;

SELECT + col2 * col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col2 - + cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col0 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 43 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - cor0.col2 * - 45 AS col1 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 73 * col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 76 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 84 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL - 52 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT 87 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 98 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 24 * 82 FROM tab0, tab0 AS cor0 GROUP BY tab0.col2

;

SELECT ALL + + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + cor0.col0 * - 32 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT 81 + 23 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 80 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 41 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 48 * 52 AS col0 FROM tab2, tab0 AS cor0 GROUP BY tab2.col0

;

SELECT cor0.col2 - + cor0.col2 AS col1 FROM tab1 cor0 GROUP BY col2

;

SELECT ALL - cor0.col2 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col2 HAVING NOT NULL <= NULL
;

SELECT DISTINCT 60 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - ( + 20 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 * 31 * cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT ( NULL ) IN ( - cor0.col2 )
;

SELECT + 11 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 27 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + ( cor0.col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 FROM tab2, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 76 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL col1 + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * - cor0.col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 49 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor1.col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT 17 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 51 + 54 AS col1 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 12 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 58 AS col2 FROM tab1, tab2 AS cor0 GROUP BY tab1.col0

;

SELECT - - 85 AS col0 FROM tab2, tab0 AS cor0 GROUP BY tab2.col2

;

SELECT + 99 + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + cor0.col0 + cor0.col0 * 27 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 38 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 13 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 10 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT 65 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + + col1 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 22 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 16 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col1, cor0.col0

;

SELECT cor0.col2 * - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT + col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 AS col2 FROM tab1, tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor1.col0 * cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor1.col0

;

SELECT DISTINCT 49 + 96 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 74 FROM tab2 AS cor0 GROUP BY col1, col1, cor0.col2

;

SELECT 80 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + cor0.col1 * - cor0.col1 AS col1 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - 68 AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - 96 AS col2 FROM tab1, tab0 AS cor0, tab1 AS cor1 GROUP BY cor0.col2

;

SELECT + COALESCE ( 12, cor0.col0 ) FROM tab2 cor0 GROUP BY col0

;

SELECT DISTINCT - NULLIF ( - 14 * cor0.col1 + cor0.col1 * 68, - cor0.col1 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + cor0.col1 * - cor0.col1 + cor0.col1 * ( - 83 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 47 FROM tab1, tab2 AS cor0, tab0 AS cor1 GROUP BY tab1.col1

;

SELECT + 1 AS col0 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL ( + 56 ) FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + 49 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 60 + + tab0.col2 * tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + + cor0.col0 * 6 FROM tab1, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT 42 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - - cor0.col0 FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - + 10 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT cor0.col0 * - 40 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 75 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT - 74 + - 30 * + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ( - cor0.col1 ) + + 59 * + cor0.col1 + 1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 81 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL - tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + 44 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 0 + - cor0.col2 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 * - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 AS col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 87 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 14 * cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL + 58 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL 90 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 * + 98 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + 25 * + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 73 + cor0.col1 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 61 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT - cor0.col1 + - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 43 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 + - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT tab2.col2 * tab2.col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - tab1.col1 FROM tab1, tab2 cor0 GROUP BY tab1.col1

;

SELECT - cor0.col0 FROM tab2, tab2 AS cor0, tab0 AS cor1 GROUP BY cor0.col0

;

SELECT ALL 45 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 + - 96 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL - 57 FROM tab1 GROUP BY col1

;

SELECT + 31 * + 34 FROM tab2 GROUP BY tab2.col2

;

SELECT + 39 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 50 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 16 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col0 + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 17 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 * cor0.col2 * 44 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - 44 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + col2 + - cor0.col2 * - cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT 34 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 25 + + col1 AS col0 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL cor0.col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col1

;

SELECT cor1.col1 AS col2 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor0.col0

;

SELECT ALL + 52 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - cor0.col1 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 - - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col2, cor0.col1

;

SELECT + 16 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT tab0.col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT cor0.col0 * - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 50 * + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 22 * 73 + + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 92 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 15 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 78 FROM tab2, tab2 AS cor0, tab0 AS cor1 GROUP BY cor1.col1

;

SELECT - 66 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 92 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 27 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT - 19 FROM tab1, tab0 AS cor0, tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT 29 * cor0.col0 + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 22 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + + 7 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT 38 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 12 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 17 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT ALL 34 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT DISTINCT 78 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 96 * - 85 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 19 + - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col0, cor0.col1

;

SELECT cor0.col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 8 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col2 * 95 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 8 + + col0 + + 9 * 51 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT + 10 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL 36 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 27 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL + 15 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, col1

;

SELECT cor0.col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col1, col0

;

SELECT + cor0.col2 * 0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 27 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 + cor0.col2 + + 40 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 AS col2 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - col0 FROM tab0 GROUP BY col0

;

SELECT + 57 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 70 * - cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 + - cor0.col0 AS col2 FROM tab2 cor0 GROUP BY col0

;

SELECT - cor0.col0 - ( cor0.col1 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 53 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 * 34 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 35 + 64 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 * + col1 + + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + ( cor0.col1 + + cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - col1 * - 45 + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT col2 + cor0.col2 * cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2, col0

;

SELECT ALL - 74 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 9 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - col0 + + 18 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL - cor0.col2 + + cor0.col2 * cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 70 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - + ( + 63 ) * + col2 - + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col1 + 9 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 81 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL 8 FROM tab1 AS cor0 GROUP BY col1

;

SELECT cor0.col2 * 23 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 28 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ( 57 ) AS col2 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL - col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT 63 FROM tab1 cor0 GROUP BY col2, cor0.col1

;

SELECT ALL + 91 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - cor0.col2 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 67 FROM tab2, tab1 cor0 GROUP BY cor0.col0

;

SELECT 89 FROM tab1, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 35 * + 15 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - + ( + 29 ) FROM tab0, tab2 AS cor0 GROUP BY tab0.col0

;

SELECT - 22 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 22 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + NULLIF ( cor0.col0, cor0.col2 ) / + CASE + 80 WHEN - 66 THEN - col0 END FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT NULLIF ( 22, cor0.col0 ) * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col0 + cor0.col0 - + 42 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + ( 15 ) - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 23 * + 10 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - cor0.col0 + cor0.col0 * cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col1 + - 17 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + + ( + tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 8 FROM tab0 GROUP BY col2

;

SELECT + 69 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 61 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + col2 * 39 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL - cor0.col0 * cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL + 26 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - 88 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + NULLIF ( - cor0.col2, + cor0.col2 ) * - 9 + col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT + col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT + cor0.col1 AS col0 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 76 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 61 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL - COALESCE ( col0, + cor0.col0 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 95 FROM tab1 cor0 GROUP BY col0

;

SELECT NULLIF ( cor0.col0 * + 54, + cor0.col0 ) FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL 20 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + - col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT - 66 FROM tab1 GROUP BY tab1.col0

;

SELECT col0 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 36 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 24 + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, col2

;

SELECT ALL - 97 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL - 61 FROM tab0 GROUP BY col1

;

SELECT ALL + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - 54 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT DISTINCT - col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - 6 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 89 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 37 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + - 59 FROM tab0 GROUP BY col0

;

SELECT ALL ( - 32 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 35 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - + 36 FROM tab1, tab0 AS cor0 GROUP BY tab1.col0

;

SELECT DISTINCT + 59 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 80 * cor0.col2 + - cor0.col2 * 52 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 49 FROM tab0 GROUP BY tab0.col1

;

SELECT + 66 * + 68 FROM tab0, tab1 AS cor0, tab2 AS cor1 GROUP BY tab0.col1

;

SELECT ALL - - 88 AS col1 FROM tab1, tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 FROM tab2, tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 8 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 23 + + 83 FROM tab2 GROUP BY col0

;

SELECT + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - cor0.col2 - - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 99 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 47 * - 95 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col1 * cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2, cor0.col1

;

SELECT cor0.col0 + - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT 17 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT + tab2.col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT + col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + cor0.col1 AS col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col2 + + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 38 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 73 AS col2 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL - cor0.col0 * 10 FROM tab2 cor0 GROUP BY col0

;

SELECT DISTINCT - cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 39 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 27 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 71 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 76 * cor0.col2 AS col0 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 16 AS col2

;

SELECT + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT 69 * cor0.col1 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 90 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL col0 - - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL cor0.col1 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT - col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + 31 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 50 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT ( 12 ) FROM tab0 AS cor0 GROUP BY col0

;

SELECT + + col2 FROM tab0 GROUP BY col2

;

SELECT ALL + + 99 AS col0 FROM tab0, tab0 AS cor0 GROUP BY tab0.col2

;

SELECT + 99 * ( - cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + ( + 78 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( cor0.col2 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + + 53 FROM tab2, tab1 AS cor0, tab0 cor1 GROUP BY cor0.col1

;

SELECT - + cor0.col2 AS col0 FROM tab1, tab2 cor0, tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - cor0.col0 * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 91 AS col2 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 + - 94 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT DISTINCT 76 AS col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + - cor0.col1 AS col2 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 * col0 - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 AS col1 FROM tab2, tab1 AS cor0, tab0 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 * - cor0.col2 + + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 * cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + col1 * + 26 + - cor0.col2 * - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col2 + + 30 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL tab0.col1 FROM tab0, tab0 AS cor0 GROUP BY tab0.col1

;

SELECT ALL cor0.col2 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col1 + - 30 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 * col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - ( cor0.col0 ) * + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 AS col0 FROM tab0, tab2 AS cor0, tab0 cor1 GROUP BY cor0.col1

;

SELECT 95 AS col0 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 1 AS col2 FROM tab1, tab0 AS cor0 GROUP BY tab1.col1

;

SELECT + col0 * + 66 FROM tab0 GROUP BY tab0.col0

;

SELECT + 95 AS col0 FROM tab0, tab2 cor0 GROUP BY cor0.col0

;

SELECT ( + 7 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 29 FROM tab2, tab2 AS cor0 GROUP BY tab2.col0

;

SELECT 2 FROM tab0, tab2 cor0 GROUP BY cor0.col0

;

SELECT - 34 * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 13 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 71 + cor0.col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT - 38 * + cor0.col1 FROM tab2, tab0 AS cor0, tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL 59 * 5 + cor0.col0 AS col0 FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 20 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - + 78 AS col2 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 9 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 66 * - 61 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 * + cor0.col2 + cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - cor0.col1 - - 99 * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + - col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - - cor0.col2 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 3 FROM tab2, tab1 AS cor0 GROUP BY tab2.col0

;

SELECT + 5 + + 69 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - tab2.col0 + tab2.col0 FROM tab2 WHERE + tab2.col2 IS NOT NULL GROUP BY col0

;

SELECT ALL + ( cor0.col0 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT + + 90 AS col0 FROM tab2 GROUP BY col2

;

SELECT + COALESCE ( - 54, col1 ) + col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT cor0.col2 + + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + NULLIF ( 40, - cor0.col1 / + 36 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 * - cor0.col1 + 96 AS col2 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT ALL 23 * tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 78 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col1 + + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT + cor0.col1 * cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + cor0.col2 FROM tab1, tab1 AS cor0, tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 * + cor0.col1 + 4 AS col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 71 + + cor0.col1 * - ( + 93 + 96 ) FROM tab1, tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col0 * - ( 99 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 93 * cor0.col1 + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 99 * - cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - cor0.col0 - - col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - 97 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + - 91 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 44 FROM tab1, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 82 FROM tab0, tab1 cor0 GROUP BY cor0.col1

;

SELECT - 78 FROM tab1, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT ( cor0.col0 ) * - col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 77 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + ( + tab1.col2 ) FROM tab1, tab1 AS cor0 GROUP BY tab1.col2

;

SELECT ALL + 17 + - col1 * - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 65 AS col0 FROM tab2 cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col2

;

SELECT ALL + cor1.col2 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT - cor0.col2 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT + 63 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT + cor0.col0 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT ALL - 27 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1, cor1.col0

;

SELECT DISTINCT 61 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor1.col0

;

SELECT ALL cor1.col0 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT ALL cor1.col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor1.col2

;

SELECT cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1, cor0.col2

;

SELECT cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT + 23 + - 92 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col1

;

SELECT 98 AS col2 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor1.col1

;

SELECT DISTINCT - cor1.col2 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT cor1.col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT + cor0.col2 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT cor0.col0 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 GROUP BY cor0.col0

;

SELECT - 75 * cor0.col0 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 43 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1

;

SELECT - 77 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + cor1.col2 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0, cor1.col2

;

SELECT DISTINCT cor1.col0 * - 66 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT - 55 * cor0.col0 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col0 HAVING NOT ( NULL ) <> NULL
;

SELECT + 88 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor0.col2

;

SELECT 35 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT + ( 90 ) FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col1, cor1.col0

;

SELECT DISTINCT + cor1.col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0, cor1.col2

;

SELECT ALL 99 * + 22 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT cor1.col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - cor0.col0 * - cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 7 * cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 4 AS col1 FROM tab1 GROUP BY col2

;

SELECT - - tab1.col0 FROM tab1 GROUP BY col0

;

SELECT ALL col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 14 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 87 FROM tab1 GROUP BY col0

;

SELECT DISTINCT 25 AS col2 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT col0 + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 78 FROM tab1 GROUP BY tab1.col1

;

SELECT + 23 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - - tab0.col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT 79 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - - 43 + tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + tab2.col1 * + tab2.col1 FROM tab2 GROUP BY col1

;

SELECT ALL - + tab0.col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT ALL + - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT tab0.col1 + 90 AS col2 FROM tab0 GROUP BY col1

;

SELECT + 40 FROM tab0 GROUP BY col0

;

SELECT - col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + - 28 AS col1 FROM tab0 GROUP BY col2

;

SELECT + + 80 FROM tab0 GROUP BY tab0.col1

;

SELECT - col1 + + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - + tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col2 AS col2 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 69 FROM tab0 GROUP BY tab0.col0

;

SELECT + - tab0.col2 * col2 FROM tab0 GROUP BY col2

;

SELECT + + col2 * 23 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + 7 FROM tab2 GROUP BY tab2.col1

;

SELECT - 54 AS col0 FROM tab1 GROUP BY col1

;

SELECT 4 FROM tab1 GROUP BY col0

;

SELECT DISTINCT - 56 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 9 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 26 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - 18 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - - 81 AS col1 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - - tab1.col2 FROM tab1 GROUP BY col2

;

SELECT tab0.col1 - + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT + + tab2.col1 + + 45 FROM tab2 GROUP BY tab2.col1

;

SELECT + 89 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - tab0.col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + tab1.col1 + - col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + - 29 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 44 * + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 30 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - + col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 73 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 62 FROM tab1 GROUP BY tab1.col0

;

SELECT tab0.col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT - 6 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + + 42 FROM tab0 GROUP BY col2

;

SELECT - + ( - 21 ) AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 56 + - 94 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 77 FROM tab0 GROUP BY col1

;

SELECT ALL + - 90 FROM tab2 GROUP BY col1

;

SELECT ALL - tab0.col0 * tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT 23 FROM tab1 GROUP BY col0

;

SELECT + col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - + tab1.col2 * + 71 AS col1 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - NULLIF ( 35, + 61 ) AS col0 FROM tab0 GROUP BY col2

;

SELECT - - 29 AS col1 FROM tab0 GROUP BY col2

;

SELECT - + tab2.col1 * 7 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 26 * col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 29 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - + 10 FROM tab2 GROUP BY tab2.col2

;

SELECT - tab0.col0 FROM tab0, tab1 AS cor0 GROUP BY tab0.col0

;

SELECT tab0.col0 * + tab0.col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT tab1.col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT + 35 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT 87 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 63 + 39 * + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - 46 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT + 76 FROM tab2 GROUP BY tab2.col1

;

SELECT - + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 84 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + + tab0.col2 + 36 * + 67 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT tab1.col2 * - 60 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col1 + ( cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL cor0.col1 + + col2 * 2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 73 * - col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT 53 FROM tab2 GROUP BY col1

;

SELECT + + cor0.col2 * cor0.col2 + - 4 FROM tab1, tab0 cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL tab2.col1 + 73 AS col1 FROM tab2 GROUP BY col1

;

SELECT ALL - - tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 90 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + - 91 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + + 19 * - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + - col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 14 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 80 + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + cor0.col0 * + col0 + - 85 * - cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - 51 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT ALL tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 62 * cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 21 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - - 4 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - - 40 * + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - ( cor0.col2 ) FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT + 79 * 93 FROM tab1 GROUP BY tab1.col0

;

SELECT 76 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - 93 - tab1.col2 * - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col2 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor1.col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT ALL - 23 * col0 AS col1 FROM tab0 AS cor0 GROUP BY col2, cor0.col2, cor0.col0

;

SELECT ALL 66 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL - 74 + + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - 46 * - tab0.col0 FROM tab0 GROUP BY col0

;

SELECT + + 94 AS col0 FROM tab1 GROUP BY col2

;

SELECT - - 13 * + 4 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - cor0.col2 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + - tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor1.col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT - + cor0.col1 AS col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 69 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 39 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT col0 + tab0.col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT 40 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT NULLIF ( + cor0.col2, + cor0.col2 * col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + tab1.col1 + col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + - 0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - 72 * + 45 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0, cor1.col1

;

SELECT + 36 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT 64 + 38 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0, cor1.col1

;

SELECT + + tab1.col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT ALL + ( 42 ) FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 43 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - 53 FROM tab2 GROUP BY tab2.col2

;

SELECT + 80 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT - 40 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT - ( + 85 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 10 AS col2 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + 72 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT + 60 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ( + 14 ) * - 92 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 FROM tab0 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT 70 + - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + cor0.col0 AS col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + 46 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 54 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - + 77 AS col2 FROM tab2 GROUP BY col0

;

SELECT ALL - 98 + cor0.col0 * - 43 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ( cor0.col2 ) * + col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - 8 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 94 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - - 20 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 87 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 3 FROM tab2 GROUP BY tab2.col2

;

SELECT - tab0.col2 * - 43 FROM tab0 GROUP BY col2

;

SELECT ALL + cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - 45 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT NULLIF ( 13, cor0.col2 * + col2 ) * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 95 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT - + 28 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 47 + - 39 * + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 0 FROM tab2 GROUP BY col0

;

SELECT ALL ( + cor0.col2 ) FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT + 67 * col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - + 61 FROM tab0 GROUP BY tab0.col2

;

SELECT 52 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT + - cor0.col2 AS col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor1.col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT + 90 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT + cor1.col2 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor0.col0

;

SELECT ALL + 20 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 84 AS col0 FROM tab2 GROUP BY col0

;

SELECT + tab2.col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT cor0.col1 + + 96 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor0.col1

;

SELECT DISTINCT + 50 AS col1 FROM tab1 GROUP BY col1

;

SELECT 45 * 44 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT NULLIF ( + 87, cor0.col1 + + 90 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 48 AS col0 FROM tab2, tab2 AS cor0 GROUP BY tab2.col2

;

SELECT ALL + ( - 22 ) FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 24 + - 53 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 93 FROM tab0 GROUP BY tab0.col2

;

SELECT tab0.col1 - - 19 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1, cor0.col2

;

SELECT + 12 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 88 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col1 - 76 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor1.col2 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - cor0.col2 * - 60 FROM tab1 AS cor0 GROUP BY col0, cor0.col1, cor0.col2

;

SELECT + 36 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 75 FROM tab0 GROUP BY col0

;

SELECT DISTINCT tab1.col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT 38 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT - tab2.col0 * + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL CASE + cor0.col2 WHEN cor0.col2 + cor0.col2 THEN NULL ELSE cor0.col2 END + - 7 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - + 1 AS col0 FROM tab2 GROUP BY col1

;

SELECT + cor0.col1 + + cor0.col1 * - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL - + 9 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + - 47 FROM tab0 GROUP BY col0

;

SELECT 91 * 79 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 12 + - 45 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL + - tab2.col1 FROM tab2 GROUP BY col1

;

SELECT 6 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL + 41 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 27 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 22 FROM tab1 GROUP BY col2

;

SELECT 93 FROM tab1 GROUP BY tab1.col0

;

SELECT + 65 FROM tab0 GROUP BY tab0.col0

;

SELECT + - 7 + 9 FROM tab1 GROUP BY tab1.col0

;

SELECT - 79 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL tab2.col1 * + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 67 + + 49 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 99 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 21 FROM tab1 GROUP BY tab1.col0

;

SELECT - ( col2 ) * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ( - cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col0 * cor0.col0 + - cor0.col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL 18 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor0.col2

;

SELECT - cor0.col2 + + cor0.col1 * + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + cor0.col0 + 63 * - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - ( 42 ) FROM tab1 GROUP BY col2

;

SELECT DISTINCT + tab0.col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + 11 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 68 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col0 - 5 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 11 * + tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + cor0.col0 * cor0.col0 + + cor0.col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL col1 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT DISTINCT 45 * 25 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 15 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - + ( tab0.col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT 38 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 24 FROM tab2 GROUP BY col1

;

SELECT 88 AS col2 FROM tab2 GROUP BY col0

;

SELECT ALL - + 35 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 45 * - 31 - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 41 FROM tab0 GROUP BY tab0.col2

;

SELECT 60 * + col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 31 + 19 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT 72 AS col1 FROM tab1 cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + 1 AS col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT tab2.col2 * + col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + cor0.col0 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT 88 + cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT 73 * - cor0.col0 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0, cor1.col1, cor1.col0

;

SELECT - + col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL ( + tab2.col0 ) * - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 62 * + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ( 53 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 16 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL tab0.col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT + col2 + - 22 * - tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - cor0.col2 * 48 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col1 * - cor0.col1 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT ALL + tab0.col0 * 58 FROM tab0 GROUP BY col0

;

SELECT ALL cor1.col2 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + + 36 FROM tab2 GROUP BY tab2.col0

;

SELECT + 25 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT - cor1.col2 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT - + col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT cor0.col2 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT 82 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT - 64 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + - 71 FROM tab2 GROUP BY tab2.col0

;

SELECT 68 * cor0.col2 - col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT - 56 AS col1 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT + - 26 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + - tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 20 FROM tab1 GROUP BY tab1.col2

;

SELECT 25 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT - 94 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT NULLIF ( - 12, + cor0.col0 ) FROM tab1 AS cor0 GROUP BY col0

;

SELECT col1 + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * 50 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 62 FROM tab1 GROUP BY col0

;

SELECT + ( col0 ) FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col0 * - 66 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL - 82 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 89 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 45 * + 76 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 59 FROM tab0 GROUP BY tab0.col1

;

SELECT 23 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT ALL - - 91 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT col0 + col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + - tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 34 * 71 FROM tab0 GROUP BY tab0.col1

;

SELECT - + tab0.col0 * 38 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - + tab2.col1 FROM tab2, tab0 AS cor0 GROUP BY tab2.col1

;

SELECT + - col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT tab0.col1 + 70 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 13 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT 13 FROM tab1 GROUP BY tab1.col1

;

SELECT - + tab1.col2 + tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 82 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - ( - 54 ) FROM tab1 cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT 21 FROM tab1 GROUP BY col2

;

SELECT ALL + 17 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT tab1.col1 * 0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 34 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - 68 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - + 73 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + cor0.col1 * 91 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - + 81 AS col1 FROM tab0 GROUP BY col2

;

SELECT 24 FROM tab1 GROUP BY col1

;

SELECT DISTINCT 13 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT + tab0.col2 FROM tab0 GROUP BY col2

;

SELECT + NULLIF ( 55, cor0.col1 * cor0.col1 ) AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col1, cor0.col0

;

SELECT ALL 3 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT - + tab1.col1 * - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + 37 FROM tab2 GROUP BY tab2.col1

;

SELECT - 20 FROM tab1 GROUP BY col0

;

SELECT 34 * + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + ( - 93 ) + tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 74 FROM tab2 GROUP BY tab2.col2

;

SELECT + - 26 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 72 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col0 * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - + tab1.col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT cor0.col0 AS col0 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT + 6 * cor0.col2 + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 38 AS col1 FROM tab2 GROUP BY col2

;

SELECT + 83 FROM tab2 GROUP BY col2

;

SELECT + cor0.col2 - - 86 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - col2 * + 18 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 45 AS col1 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1, cor0.col1

;

SELECT - 92 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1, cor1.col2

;

SELECT DISTINCT + 38 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT ( 50 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 8 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 46 * cor1.col0 - cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT 58 AS col1 FROM tab1 GROUP BY col0

;

SELECT - + 79 FROM tab1 GROUP BY col2

;

SELECT ALL 46 * cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT - + 21 FROM tab1 GROUP BY tab1.col2

;

SELECT 14 + - tab2.col1 * - 90 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - ( 28 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 22 * - cor0.col1 FROM tab1, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - ( 79 ) AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + 41 AS col0 FROM tab1, tab1 AS cor0 GROUP BY tab1.col0

;

SELECT DISTINCT - + 42 * 36 AS col0 FROM tab0, tab0 cor0 GROUP BY cor0.col0

;

SELECT 24 - - cor0.col1 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT + - 27 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col0 * 72 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 10 FROM tab0 GROUP BY col2

;

SELECT - - 74 FROM tab0 GROUP BY tab0.col0

;

SELECT - - 72 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + + col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 36 * - cor0.col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL tab2.col0 * - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + - 14 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - tab0.col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT + tab1.col0 - 13 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + 26 * + 75 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - - 7 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 65 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 20 * - 35 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 3 AS col2 FROM tab0 GROUP BY col0

;

SELECT - 65 * 90 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 - - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 64 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + - 81 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT + - 80 + + tab2.col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 96 FROM tab2 GROUP BY col2

;

SELECT ALL - 12 * 74 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - + 87 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 7 FROM tab0 GROUP BY tab0.col2

;

SELECT - 77 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + col2 FROM tab1 GROUP BY col2

;

SELECT ALL - + tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 31 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT + + 13 FROM tab2 GROUP BY col0

;

SELECT 70 FROM tab1 GROUP BY tab1.col1

;

SELECT - tab2.col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT 29 * col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT DISTINCT - 15 + + col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - NULLIF ( + cor0.col1, cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + NULLIF ( - 40, cor0.col0 ) AS col2 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + 72 FROM tab2 GROUP BY col2

;

SELECT ALL - col0 * - col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT 67 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col0 * CASE cor0.col2 * cor0.col2 WHEN cor0.col2 THEN NULL WHEN - 31 THEN NULL ELSE + cor0.col2 END AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT + 33 + + 82 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 10 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT 49 * + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col2, col1

;

SELECT - 94 * + 34 - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + col0 + + 83 * + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT + cor0.col0 + cor0.col0 * 19 AS col1 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT + 78 FROM tab0 GROUP BY tab0.col0

;

SELECT + 50 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 85 + col1 FROM tab2 GROUP BY col1

;

SELECT ALL 87 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - tab1.col0 * - 52 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - tab0.col1 + 73 AS col1 FROM tab0 GROUP BY col1

;

SELECT - 28 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 2 FROM tab0 GROUP BY tab0.col0

;

SELECT + + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 25 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT - - 85 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + - tab0.col2 + + 2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + NULLIF ( - 74, - cor0.col2 + - col2 * 83 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 8 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL + 24 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT - 2 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL + cor0.col0 * 0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - + 53 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 97 + + tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT + 49 * + col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - + tab1.col0 + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 48 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT + col0 + - cor0.col0 * cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT - col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT + 53 AS col1 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + - col0 + - tab1.col0 * + col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - - col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT + - ( + 1 ) FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 39 AS col2 FROM tab2 GROUP BY col1

;

SELECT ALL - ( 30 ) AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + - 44 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ( + cor1.col0 ) AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - 24 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col0 * 42 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 75 AS col1 FROM tab0 GROUP BY col2

;

SELECT + 40 + + 34 * cor0.col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + - col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + 48 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - + 75 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + - tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - tab2.col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT - - 91 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col2 + - 93 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 12 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT COALESCE ( 5, + cor0.col1 * cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 14 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT + 42 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + ( 69 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 + + cor0.col1 * - col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT - + tab0.col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT - - 42 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + 63 * cor0.col2 + col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 12 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - ( cor0.col1 ) FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL - COALESCE ( tab0.col0, tab0.col0 * tab0.col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT + 56 AS col2 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - 32 AS col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT 93 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 42 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - COALESCE ( - cor0.col2, cor0.col2 * - 31 ) + + col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 47 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + - 82 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ( 57 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + tab2.col2 - 41 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + col0 * - 12 FROM tab1 GROUP BY col0

;

SELECT ALL + 86 FROM tab0 GROUP BY tab0.col1

;

SELECT 15 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + 1 + + 86 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT COALESCE ( cor0.col0, 47 ) AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL + 46 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 44 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT 28 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT tab1.col0 * + tab1.col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT + - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL cor0.col2 + + 76 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - - 56 AS col0 FROM tab2 GROUP BY col1

;

SELECT ALL - cor0.col1 + - 67 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 44 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col1 + - col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 3 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT 73 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 + - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, cor0.col0, cor0.col1

;

SELECT DISTINCT col2 * + tab1.col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT DISTINCT cor0.col2 - + cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 61 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 55 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - + 50 FROM tab2 GROUP BY tab2.col2

;

SELECT - + 51 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - tab2.col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT + CASE + cor0.col1 WHEN cor0.col1 THEN NULL ELSE cor0.col1 END * - cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + - 47 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 33 * 98 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 37 FROM tab0 GROUP BY tab0.col0

;

SELECT - + cor0.col0 FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 50 AS col0 FROM tab2 GROUP BY col2

;

SELECT 38 * - cor0.col0 + + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL col2 + - cor0.col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + ( + tab2.col1 ) FROM tab2 GROUP BY col1

;

SELECT ALL 90 + + cor0.col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + 22 * + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + + tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 94 * 29 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - + tab1.col2 * ( 91 + - col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT 81 + cor0.col0 AS col0 FROM tab2 cor0 GROUP BY col0

;

SELECT 5 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 83 * - 25 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - COALESCE ( 18, - cor0.col1 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col0, cor0.col2

;

SELECT ALL + cor0.col1 + - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 83 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL COALESCE ( 15, cor0.col2 * cor0.col1 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - CASE cor0.col1 WHEN + cor0.col2 THEN 63 END + cor0.col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL - cor0.col0 - cor0.col0 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT + + 44 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 36 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - - col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 6 FROM tab0 GROUP BY tab0.col0

;

SELECT NULLIF ( cor0.col1, - col1 * 35 + 87 ) * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * + cor0.col2 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT - - 90 AS col1 FROM tab0 GROUP BY col2

;

SELECT - ( 54 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + + 32 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col1 * + 12 + cor0.col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + 98 + tab2.col2 FROM tab2 GROUP BY col2

;

SELECT + cor0.col0 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 67 FROM tab2 GROUP BY tab2.col0

;

SELECT - 3 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 30 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 48 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 7 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 82 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 87 - + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + cor0.col1 - - cor0.col1 * + 0 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - 50 FROM tab1 GROUP BY col1

;

SELECT + + tab1.col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT 13 * - 82 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + 54 + - 42 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT ALL + 19 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - ( COALESCE ( tab2.col2, - col2 ) ) AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - - tab2.col1 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - + 97 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col1 * - 66 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 1 + - 4 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - - tab2.col2 FROM tab2 GROUP BY col2

;

SELECT - 65 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + - 66 AS col0 FROM tab1, tab2 AS cor0 GROUP BY tab1.col1

;

SELECT cor0.col0 + + cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab0 GROUP BY cor0.col0 HAVING NULL IN ( cor0.col0 )
;

SELECT ALL - + col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - 99 FROM tab0 GROUP BY col2

;

SELECT ( 42 ) + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 81 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT 60 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT 19 + + 84 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + COALESCE ( cor0.col1, 99 * - cor0.col2 ) * cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, col1

;

SELECT 81 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + ( + col2 ) * - col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - NULLIF ( cor0.col1, cor0.col1 ) / + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 * 12 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - 85 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col0 * + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 26 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 28 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 12 * col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - ( 85 ) FROM tab2, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ( + 24 ) - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col2

;

SELECT DISTINCT 76 AS col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL + CASE 59 WHEN - cor0.col2 THEN NULL ELSE ( 53 ) END AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 89 + + 83 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 9 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2, cor1.col2

;

SELECT ALL + 47 + cor0.col0 AS col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL ( 79 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor1.col1

;

SELECT tab1.col2 + tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col2 + cor0.col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - 40 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT 43 * + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - + col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT tab1.col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT + tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col0 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor0.col1, cor0.col0

;

SELECT DISTINCT - col0 + - 96 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 23 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 47 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - - 32 * 58 FROM tab0 GROUP BY tab0.col1

;

SELECT + - 27 FROM tab2 GROUP BY tab2.col2

;

SELECT - - tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL tab0.col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL 86 + cor1.col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1, cor1.col0

;

SELECT + ( 38 ) FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT 40 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 34 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT 39 AS col0 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - 65 FROM tab1 GROUP BY tab1.col0

;

SELECT - 21 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + + col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col2 * + 67 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 + - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - cor0.col0 AS col2 FROM tab2, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - col2 * + cor0.col2 + 91 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - - ( + 1 ) AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - + 84 * 64 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT ( + 58 ) + + tab0.col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT - + col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col0 + - ( 19 ) AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - - 82 * col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + - 83 FROM tab2 GROUP BY col0

;

SELECT ALL - ( 95 ) AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - 67 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col0 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - col1 + + 65 FROM tab0 GROUP BY tab0.col1

;

SELECT 65 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 * 93 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT ( + 52 ) + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT ( 10 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL tab0.col0 + col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 7 FROM tab2 GROUP BY tab2.col0

;

SELECT - - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + col0 * + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - + 63 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - cor0.col1 AS col2 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 77 FROM tab0 GROUP BY col0

;

SELECT ALL + col1 FROM tab1 GROUP BY col1

;

SELECT + cor0.col2 + + cor0.col0 * + cor0.col0 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 35 AS col0 FROM tab0 GROUP BY col1

;

SELECT + 34 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 97 + - 88 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - ( cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - 7 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col1 + - col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1, col0

;

SELECT - 41 * col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + + 34 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 93 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT tab2.col1 * + col1 FROM tab2 GROUP BY col1

;

SELECT ALL col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT ALL - 84 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + tab0.col1 * - tab0.col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 89 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 26 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT 64 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - 71 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT col0 * ( cor0.col0 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT + cor1.col1 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor1.col1

;

SELECT + - 40 * 38 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col2 * ( - cor0.col2 * + cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 0 FROM tab1 GROUP BY tab1.col2

;

SELECT - col1 * 48 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1, cor0.col0

;

SELECT + 80 + cor1.col0 * 32 AS col1 FROM tab0 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT col1 * - 54 FROM tab0 GROUP BY tab0.col1

;

SELECT ( + 57 ) FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 73 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col2

;

SELECT ALL + + 10 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 82 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 29 * tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + 44 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0

;

SELECT + col0 FROM tab2 GROUP BY col0

;

SELECT - 98 AS col1 FROM tab2 GROUP BY col2

;

SELECT ALL + tab2.col0 * + 25 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col0 * + 95 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + + col0 FROM tab2 GROUP BY col0

;

SELECT + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + cor0.col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor0.col2

;

SELECT + - tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT + 52 FROM tab1 GROUP BY tab1.col1

;

SELECT 48 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 4 AS col0 FROM tab0 GROUP BY col1

;

SELECT ALL - 53 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 42 AS col1 FROM tab1, tab1 AS cor0 GROUP BY tab1.col1

;

SELECT + + cor0.col1 FROM tab1, tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab0.col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT ALL + 43 + - 41 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - + 82 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 13 - + tab0.col1 FROM tab0 GROUP BY col1

;

SELECT 4 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab2 WHERE ( NULL ) NOT BETWEEN NULL AND NULL GROUP BY cor0.col2

;

SELECT ALL tab1.col0 + 70 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 78 AS col0 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor1.col0, cor1.col2

;

SELECT 17 * 95 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 2 - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + + 69 AS col2 FROM tab1 GROUP BY col1

;

SELECT ALL - 4 FROM tab1 GROUP BY col2

;

SELECT ALL 87 AS col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT + col0 FROM tab1 GROUP BY col0

;

SELECT - - 52 * col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - - col0 * + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + tab1.col2 * tab1.col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT - 90 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 90 * - tab1.col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT 13 * cor0.col1 + + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 24 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - - 20 FROM tab2 GROUP BY tab2.col1

;

SELECT + + col1 + tab2.col1 * - 43 FROM tab2 GROUP BY tab2.col1

;

SELECT - + 34 FROM tab0 GROUP BY col0

;

SELECT cor1.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT 37 AS col2 FROM tab1, tab1 AS cor0 GROUP BY tab1.col0

;

SELECT + 0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2, cor0.col0

;

SELECT DISTINCT + 89 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col0, cor0.col1

;

SELECT ( - 96 ) FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1

;

SELECT - 82 FROM tab2 GROUP BY tab2.col2

;

SELECT - 38 FROM tab1 GROUP BY tab1.col0

;

SELECT 37 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 33 * + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT ALL - tab2.col0 FROM tab2 GROUP BY col0

;

SELECT - + 67 + 41 FROM tab0 GROUP BY tab0.col0

;

SELECT - ( 64 ) * + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 97 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 82 FROM tab0 GROUP BY tab0.col0

;

SELECT + 16 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL 26 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT 2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + 48 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - 97 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + 90 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 62 + + 93 AS col0 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT - 14 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 12 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT - tab2.col0 FROM tab2, tab0 AS cor0 GROUP BY tab2.col0

;

SELECT 15 + cor0.col1 * 90 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col0

;

SELECT - col2 FROM tab2 GROUP BY col2

;

SELECT ALL + 7 FROM tab0 GROUP BY col2

;

SELECT + 37 FROM tab2 GROUP BY col0

;

SELECT ALL - 50 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT ( cor1.col2 ) AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT - cor0.col0 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT - 22 FROM tab2 GROUP BY col1

;

SELECT ALL + 13 FROM tab1 GROUP BY tab1.col0

;

SELECT tab2.col0 - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + + 67 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 95 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT col0 * 31 AS col1 FROM tab1 GROUP BY col0

;

SELECT COALESCE ( - 47, - col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + - tab1.col2 + + 31 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT 95 AS col0 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT + + 73 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + col2 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 39 + tab1.col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT ALL + cor0.col0 * + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - - 95 + tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col2 * + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - ( cor0.col0 ) * + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 61 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - 40 AS col0 FROM tab2, tab2 cor0 GROUP BY cor0.col0

;

SELECT - 76 FROM tab2 GROUP BY col1

;

SELECT ALL - col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + + col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 30 * - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + - 79 * 73 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 90 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 31 AS col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + + 87 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - 20 * + 91 FROM tab2 GROUP BY tab2.col2

;

SELECT + 75 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + COALESCE ( 55, + tab1.col0 ) AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + 58 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col1 - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 27 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 13 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + ( - cor0.col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor1.col0 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor1.col0

;

SELECT 91 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - tab0.col0 * - 47 FROM tab0 GROUP BY tab0.col0

;

SELECT 34 FROM tab1 GROUP BY col2

;

SELECT + + tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 32 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT ALL - - 39 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 25 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + - tab2.col2 * tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + - tab1.col2 * 43 AS col0 FROM tab1 GROUP BY col2

;

SELECT + 43 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT + + cor0.col1 AS col1 FROM tab2, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 26 FROM tab2 GROUP BY col1

;

SELECT + 44 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - + col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 49 * cor0.col1 + + 77 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor1.col0 AS col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - + 86 AS col2 FROM tab0 GROUP BY col2

;

SELECT + 60 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 52 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT - + col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT ALL - cor0.col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT tab0.col0 + tab0.col0 * col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + - 1 AS col1 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT 75 + 9 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1 HAVING NOT NULL IS NULL
;

SELECT cor1.col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0, cor1.col2

;

SELECT + 55 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + 74 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 30 * cor0.col2 + cor0.col1 * NULLIF ( + cor0.col2, cor0.col2 * 58 ) FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + + col0 * - 66 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 90 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + ( - tab2.col2 ) AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 98 FROM tab1 GROUP BY tab1.col0

;

SELECT 22 * 16 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor1.col0 * 79 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + 81 FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 53 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col2

;

SELECT cor1.col0 AS col0 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - col2 - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - + col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + tab1.col2 * tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - cor0.col0 * 23 - + cor0.col0 FROM tab2 AS cor0 GROUP BY col0, col0, cor0.col0, cor0.col2

;

SELECT + + col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT 94 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - tab0.col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT - 98 FROM tab2 GROUP BY col2

;

SELECT - 62 * cor0.col0 + - ( - 67 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - - tab2.col0 + + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 55 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 25 AS col2 FROM tab0 GROUP BY col2

;

SELECT cor0.col0 + + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, col0

;

SELECT cor0.col1 - - ( 35 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor1.col0 - 18 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - 32 - col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT + 55 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - cor1.col1 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT - NULLIF ( - cor0.col0, 52 ) FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL - 26 FROM tab2 GROUP BY tab2.col2

;

SELECT + 66 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - - tab1.col1 + - 68 * - col1 FROM tab1 GROUP BY tab1.col1

;

SELECT col0 + 71 FROM tab0 cor0 GROUP BY col0

;

SELECT - 99 FROM tab0 GROUP BY tab0.col2

;

SELECT + 21 - 74 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - col1 * tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 38 * - 47 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - + 76 FROM tab0 GROUP BY col2

;

SELECT + 35 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 11 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 39 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT 58 FROM tab1 GROUP BY tab1.col1

;

SELECT 44 FROM tab0 GROUP BY tab0.col0

;

SELECT - - col1 * tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL col2 - 3 * - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 - - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col0 + + 62 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - 39 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col0

;

SELECT - 4 AS col1 FROM tab0 GROUP BY col0

;

SELECT + cor0.col2 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL tab1.col0 + tab1.col0 FROM tab1 GROUP BY col0 HAVING ( NULL ) IS NULL
;

SELECT - 61 AS col1 FROM tab1, tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL ( - col1 ) AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 59 FROM tab1 cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2, cor1.col2

;

SELECT col0 * NULLIF ( cor0.col0, + cor0.col2 + + col0 * cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + + 74 + + 14 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + ( tab0.col1 ) FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 32 * - 70 + - col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 67 * - 47 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - 41 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor1.col2 * cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2, cor1.col1

;

SELECT tab0.col0 * + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT + 27 + + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - ( - cor1.col2 ) FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col2

;

SELECT + cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT - col2 + + ( 19 ) AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ( - tab2.col0 ) AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT ( cor0.col2 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + 1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 40 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - tab1.col1 + col1 * + 47 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT tab1.col0 + 13 FROM tab1 GROUP BY col0

;

SELECT col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - tab1.col0 FROM tab1 GROUP BY col0

;

SELECT ( - cor0.col2 ) * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col1, cor0.col0

;

SELECT ALL ( cor0.col2 ) + cor0.col2 * - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT ( + 62 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - ( cor0.col0 ) FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 20 AS col1 FROM tab0 GROUP BY col0

;

SELECT 73 FROM tab1 GROUP BY tab1.col0

;

SELECT 70 FROM tab2 cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col0

;

SELECT cor0.col1 * - 32 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor1.col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1, cor1.col2

;

SELECT ALL cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor0.col1

;

SELECT - 96 * tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + 56 FROM tab1 GROUP BY tab1.col1

;

SELECT + 57 * - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + 78 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor1.col1

;

SELECT DISTINCT + - tab2.col0 + - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 92 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - COALESCE ( tab2.col1, tab2.col1 ) FROM tab2 GROUP BY col1

;

SELECT ALL - 70 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + - 5 + + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 41 - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - + col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + 98 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 66 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + cor0.col2 + NULLIF ( col2 + cor0.col2, + COALESCE ( - 23, col1 ) ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ( - 26 ) + + col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col2 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + 85 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 39 - - 91 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + tab2.col2 * tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + tab1.col0 + 60 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 82 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + 78 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL ( cor0.col1 ) FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL - + 13 FROM tab0 GROUP BY col2

;

SELECT 30 FROM tab0 GROUP BY tab0.col1

;

SELECT + 33 FROM tab1 GROUP BY tab1.col0

;

SELECT - - tab0.col2 FROM tab0 GROUP BY col2

;

SELECT ALL + tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 83 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT 30 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - 0 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL - tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col2 + 78 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ( - 63 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 68 FROM tab2 GROUP BY tab2.col2

;

SELECT 64 + 15 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT + cor0.col2 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT 95 FROM tab2 GROUP BY tab2.col2

;

SELECT - - tab2.col2 * + 52 FROM tab2 GROUP BY tab2.col2

;

SELECT - - 14 * 21 FROM tab2 GROUP BY col2

;

SELECT - 38 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor1.col1 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0, cor1.col1

;

SELECT + + tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 82 FROM tab0 GROUP BY tab0.col2

;

SELECT + - 69 FROM tab2 GROUP BY tab2.col2

;

SELECT - 53 FROM tab0 GROUP BY tab0.col2

;

SELECT + - 2 FROM tab0 GROUP BY tab0.col2

;

SELECT + col0 * 54 FROM tab1 GROUP BY col0

;

SELECT + 55 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + 28 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 60 - + 92 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT + 57 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + cor0.col2 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL ( 50 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 / cor0.col0 + CASE + cor0.col0 + + cor0.col0 * cor0.col0 WHEN cor0.col0 THEN cor0.col0 WHEN - col0 + cor0.col0 THEN + 31 END AS col2 FROM tab1 cor0 GROUP BY col0, cor0.col0

;

SELECT DISTINCT - + 21 AS col0 FROM tab2 GROUP BY col2

;

SELECT ALL cor1.col1 AS col2 FROM tab1 cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1

;

SELECT DISTINCT cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + - ( 77 ) FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 31 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT ( 66 ) AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor0.col0

;

SELECT DISTINCT cor0.col0 - - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 82 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + + tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT + - 55 AS col2 FROM tab1 GROUP BY col0

;

SELECT ALL - cor0.col2 * 3 + col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT - cor0.col2 + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT NULLIF ( cor0.col2, - cor0.col2 / + 63 ) FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - tab0.col0 FROM tab2 AS cor0 CROSS JOIN tab0 GROUP BY tab0.col0

;

SELECT ALL - col1 + + tab1.col1 * 57 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - + tab0.col2 * col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + 29 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - + tab1.col2 * 46 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - cor1.col1 AS col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL + 51 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + + 50 FROM tab0 GROUP BY col2

;

SELECT ALL 10 FROM tab0 GROUP BY col0

;

SELECT ALL + 78 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT 85 + 73 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL - 69 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT cor0.col1 * + cor0.col1 + 29 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 78 AS col0 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT + col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT 46 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + - 99 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT + 74 FROM tab0 GROUP BY tab0.col2

;

SELECT 65 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL cor1.col0 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT + + 17 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + + col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT - 91 * - tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 77 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT 36 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + 5 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + + 92 FROM tab2 GROUP BY col0

;

SELECT ALL + CASE + cor0.col2 WHEN NULLIF ( 23, col0 ) THEN - cor0.col1 * cor0.col2 WHEN - cor0.col2 * cor0.col1 THEN NULL END * cor0.col1 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT + 47 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT + tab2.col1 - col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 80 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT + 9 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - 19 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT cor1.col2 + 98 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor1.col2, cor0.col2

;

SELECT cor0.col1 + cor0.col1 AS col1 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT + 44 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 9 FROM tab0 GROUP BY col0

;

SELECT + cor0.col0 + + cor0.col0 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col0

;

SELECT + 55 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 75 + cor0.col1 * cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 95 + - 76 AS col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 85 AS col1 FROM tab2, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 86 * tab0.col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT ALL - tab0.col0 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 + + 86 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + + 84 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 15 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col0 + - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT col0 + col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT - 13 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col2 * cor0.col2 + + 33 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT - ( + 26 ) FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - cor0.col2 + + 40 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - cor0.col0 - 87 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 * cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT cor0.col1 * + ( - 32 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 39 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 87 FROM tab2 GROUP BY col2

;

SELECT + 68 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 86 FROM tab2 GROUP BY tab2.col1

;

SELECT - 12 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 31 FROM tab0 GROUP BY tab0.col1

;

SELECT - tab1.col0 - - tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 57 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 57 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT ALL - cor0.col2 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT cor0.col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0, cor0.col1, cor0.col2

;

SELECT DISTINCT - 64 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT - col0 FROM tab2 GROUP BY col0

;

SELECT cor0.col2 * + 7 + + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 27 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT 91 FROM tab0 GROUP BY tab0.col1

;

SELECT + - tab2.col2 + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 42 AS col0 FROM tab2 GROUP BY col1

;

SELECT cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1, cor1.col0

;

SELECT - + 93 + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL ( cor0.col2 ) * col2 + ( 77 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 78 FROM tab1 GROUP BY col1

;

SELECT ALL - col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + - 31 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col1 * cor0.col2 + + 98 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + cor0.col2 + + cor0.col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL col2 + - 3 * - 10 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + 50 FROM tab0 GROUP BY col2

;

SELECT cor0.col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL - cor0.col1 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 GROUP BY cor0.col1

;

SELECT DISTINCT - - 2 FROM tab0 GROUP BY col1

;

SELECT 90 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT + 67 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 59 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - + tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT tab1.col0 * tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor1.col0 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col0, cor0.col1, cor0.col1

;

SELECT ALL + tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 43 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 9 FROM tab2 GROUP BY col1

;

SELECT cor0.col0 + - 52 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT - tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - 7 + tab2.col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT - cor1.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + 63 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col0 * + ( - cor0.col0 ) FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - - 97 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT cor1.col0 * cor1.col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor0.col1

;

SELECT ALL + 63 + + 9 * cor1.col0 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - 36 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1, cor1.col1

;

SELECT - + 19 AS col2 FROM tab2 GROUP BY col1

;

SELECT cor0.col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT - + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 82 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT - - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col0

;

SELECT + cor0.col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL - 96 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT COALESCE ( - 80, cor0.col2 ) * - ( - cor0.col2 + + cor0.col2 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 95 FROM tab0 GROUP BY tab0.col2

;

SELECT + 90 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 79 AS col0 FROM tab0 GROUP BY col1

;

SELECT cor0.col0 * - 90 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ( + cor0.col2 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 46 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - 75 * + col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + + 8 FROM tab1 GROUP BY tab1.col1

;

SELECT 87 * 44 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 3 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT - + 41 + + cor0.col2 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 89 + + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + tab2.col2 * - 14 FROM tab2 GROUP BY tab2.col2

;

SELECT + ( - col1 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 74 FROM tab0 GROUP BY col2

;

SELECT cor0.col1 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - + col1 + - 64 * - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 63 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 41 * - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + 54 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - ( cor0.col2 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 81 * + col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 25 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 22 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + tab0.col0 FROM tab0, tab2 cor0 GROUP BY tab0.col0

;

SELECT ALL 54 FROM tab2 GROUP BY tab2.col0

;

SELECT ( 44 ) AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 38 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + col0 * + col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT CASE cor0.col2 WHEN ( + COALESCE ( cor0.col1, col1, NULLIF ( cor0.col0, + cor0.col1 ) ) ) / CASE col1 WHEN + cor0.col0 + + cor0.col2 THEN NULL ELSE + cor0.col2 * col0 + cor0.col0 * 5 END THEN + cor0.col1 - cor0.col0 * - cor0.col2 WHEN COALESCE ( - cor0.col0, cor0.col1 ) THEN 81 END / CASE cor0.col2 / cor0.col2 WHEN cor0.col2 THEN + cor0.col0 + + cor0.col1 * COALESCE ( - 97 * + col1, - cor0.col1, - cor0.col1 - + cor0.col0 ) ELSE NULL END FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT DISTINCT 68 FROM tab0 GROUP BY tab0.col2

;

SELECT - col0 + + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT ALL + 43 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor0.col0

;

SELECT - 7 - + cor1.col1 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT 17 * - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 * ( 13 ) AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2, cor0.col0

;

SELECT - 55 FROM tab2 GROUP BY col1

;

SELECT + 89 * + 51 FROM tab0 GROUP BY col1

;

SELECT ALL + 68 FROM tab2 GROUP BY col2

;

SELECT + cor0.col0 + + cor0.col0 * + 43 FROM tab2 AS cor0 GROUP BY col0, cor0.col0, cor0.col2

;

SELECT DISTINCT - + tab2.col1 FROM tab2 GROUP BY col1

;

SELECT + - col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 43 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - 53 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + cor0.col1 * + col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor1.col2 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - - col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - - tab2.col0 * col0 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 * 1 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - + 9 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - - 82 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + 52 + + 70 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 43 FROM tab1 GROUP BY col0

;

SELECT - 50 + col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 7 FROM tab2 GROUP BY col1

;

SELECT + ( 6 ) FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + - 19 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - + 30 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 25 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + 28 * - 41 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 83 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0, cor1.col0

;

SELECT + - tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + tab2.col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT 26 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT + 65 FROM tab1 GROUP BY tab1.col1

;

SELECT - 86 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col0 - cor0.col2 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col0 * cor0.col0 AS col0 FROM tab2 cor0 CROSS JOIN tab0 GROUP BY cor0.col0

;

SELECT cor0.col2 FROM tab2 AS cor0 WHERE NOT ( NULL ) NOT IN ( col2 / cor0.col0 + cor0.col1 ) GROUP BY cor0.col2

;

SELECT DISTINCT col1 * - ( - col2 * - cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 34 * - cor0.col0 + + ( col0 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 * cor0.col1 + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - + tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 65 AS col2 FROM tab0 GROUP BY col2

;

SELECT 90 * 20 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 60 FROM tab1 GROUP BY col2

;

SELECT 53 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + - 7 * tab0.col0 FROM tab0 GROUP BY col0

;

SELECT 66 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT 78 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL tab2.col0 + + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - + col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - - 93 + 51 FROM tab1 GROUP BY col2

;

SELECT ALL + cor0.col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT ALL - cor0.col1 * + 29 AS col0 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor1.col0 * cor1.col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT + - 14 FROM tab1 GROUP BY tab1.col2

;

SELECT 80 - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 43 + + col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 4 AS col2 FROM tab0 GROUP BY col0

;

SELECT ALL tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT col2 - - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - + 18 FROM tab2 GROUP BY col0

;

SELECT ALL - tab2.col1 - - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 12 * + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ( - tab1.col0 ) FROM tab1 GROUP BY col0

;

SELECT cor0.col1 + - cor0.col1 * 43 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col0 * cor0.col0 + cor0.col2 * 27 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 43 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - 67 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor1.col0 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + 13 * 89 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - - 62 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + + 74 + - tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT - 73 FROM tab1 GROUP BY col0

;

SELECT - cor0.col1 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT ALL - cor1.col1 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col1

;

SELECT - + 33 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 78 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - + 25 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT 55 * col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + - 2 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col1 + ( - cor0.col1 + + col1 ) * + 25 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ( cor0.col1 ) + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 * cor0.col0 + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - + tab1.col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT DISTINCT 76 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + - 95 AS col2 FROM tab1 GROUP BY col1

;

SELECT + 77 * 56 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + tab2.col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT 67 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 + NULLIF ( + cor0.col2, + cor0.col2 * col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - cor0.col1 + 50 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - + 3 AS col2 FROM tab1 GROUP BY col0

;

SELECT + 38 AS col0 FROM tab2 GROUP BY col1

;

SELECT ALL cor1.col0 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor1.col0

;

SELECT ALL - 70 * 75 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - 69 FROM tab1 GROUP BY tab1.col1

;

SELECT - cor0.col2 AS col1 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT + 34 AS col0 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0, cor1.col0

;

SELECT ALL 80 - col0 * cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - + 57 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - 89 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + tab0.col0 + 81 FROM tab0 GROUP BY tab0.col0

;

SELECT + - 97 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 6 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + - col2 FROM tab2 GROUP BY col2

;

SELECT 38 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT tab2.col1 FROM tab2 GROUP BY col1

;

SELECT ALL + ( - col1 ) * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 81 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT + - 73 FROM tab1 GROUP BY col0

;

SELECT + 19 + - 61 FROM tab1 GROUP BY tab1.col2

;

SELECT - + 34 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + 56 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + ( tab0.col2 ) FROM tab0 GROUP BY col2

;

SELECT DISTINCT - COALESCE ( + 50, - cor1.col1 ) + 83 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - 22 + tab1.col0 * 68 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 21 + cor0.col1 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + 43 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col2 + cor0.col2 * cor0.col2 FROM tab2, tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL - - tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT - + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 50 * - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + ( cor0.col0 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + col1 * - 9 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + + tab2.col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT ALL - cor0.col2 + 9 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - + tab0.col1 + - 53 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor1.col1 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT - cor1.col0 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT + - 40 AS col1 FROM tab0 GROUP BY col2

;

SELECT ( + col2 ) AS col1 FROM tab0 GROUP BY col2

;

SELECT + - tab1.col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT cor0.col0 + 87 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 75 - 34 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT ALL 16 * + cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT - 87 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 72 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + 67 + + col1 AS col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT - col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + 52 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT ALL 15 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 78 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 74 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col2 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor0.col2

;

SELECT cor1.col1 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0, cor1.col1, cor1.col0

;

SELECT ALL 20 * - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT tab1.col0 * + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT cor1.col0 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col0

;

SELECT ALL col0 + + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT + 93 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col2 AS col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 + col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - col1 * cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 30 FROM tab2 GROUP BY col1

;

SELECT - COALESCE ( col1, cor0.col1 * - cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT tab2.col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT ALL CASE - cor0.col1 WHEN cor0.col1 THEN NULL ELSE cor0.col1 END FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL 34 FROM tab0 GROUP BY tab0.col0

;

SELECT + tab2.col0 * 93 FROM tab2 GROUP BY tab2.col0

;

SELECT + + 19 FROM tab1 GROUP BY col1

;

SELECT - 88 * 34 AS col0 FROM tab0 GROUP BY col2

;

SELECT - - 25 FROM tab2 GROUP BY col1

;

SELECT - + 19 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + col2 * - col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col0 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 84 * 29 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - - tab2.col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + 69 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - + tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col0 + 2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 5 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL cor0.col2 - 55 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT - COALESCE ( - 76, cor0.col0 ) FROM tab0 AS cor0 GROUP BY col0

;

SELECT 47 FROM tab0, tab1 AS cor0 GROUP BY tab0.col1

;

SELECT DISTINCT - 14 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + + 68 FROM tab1 GROUP BY tab1.col0

;

SELECT 74 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 25 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col1 + - 55 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col0 + + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 23 FROM tab0 GROUP BY col2

;

SELECT ALL - + 74 * 8 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL tab2.col2 FROM tab2 GROUP BY col2

;

SELECT + tab2.col0 FROM tab2, tab0 AS cor0 GROUP BY tab2.col0

;

SELECT ALL + ( 95 ) * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + - col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 95 AS col0 FROM tab0 cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 26 FROM tab0 cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT + 91 FROM tab1 GROUP BY tab1.col1

;

SELECT 41 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 15 FROM tab2 GROUP BY col1

;

SELECT - 82 AS col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - - cor0.col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + + tab0.col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + NULLIF ( + 14, + cor0.col2 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 * col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT col1 * - cor0.col2 + - 76 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 31 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 96 * cor0.col1 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 51 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor1.col1

;

SELECT - - 17 FROM tab0 GROUP BY col0

;

SELECT 1 FROM tab2 GROUP BY tab2.col1

;

SELECT 84 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + 8 FROM tab1 GROUP BY tab1.col1

;

SELECT - tab2.col1 - 88 AS col2 FROM tab2 GROUP BY col1

;

SELECT 19 - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + col2 FROM tab1 GROUP BY tab1.col2

;

SELECT cor1.col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL cor0.col0 FROM tab1, tab2 cor0 GROUP BY cor0.col0

;

SELECT + - NULLIF ( tab1.col0, 71 / 47 ) FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 56 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + 22 - - cor0.col0 * cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT - ( tab0.col0 ) FROM tab0 GROUP BY col0

;

SELECT ALL + - 0 + - 41 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - ( 93 ) + 75 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 83 FROM tab0 GROUP BY tab0.col2

;

SELECT - cor0.col2 * 28 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - cor0.col0 AS col1 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT col2 + col2 * 56 AS col1 FROM tab0 GROUP BY col2

;

SELECT ALL cor0.col0 + CASE cor0.col1 + + cor0.col0 WHEN 68 * cor0.col1 THEN cor0.col1 END AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + CASE + 13 WHEN + cor0.col0 * - col2 + - 68 / cor0.col0 THEN NULL ELSE cor0.col0 END FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT 39 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + 29 * 14 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + + tab1.col0 FROM tab1 GROUP BY col0

;

SELECT ALL + 95 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + - 16 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 75 - 28 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col2 * cor0.col2 + - 79 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 + - col0 * + CASE CASE + cor0.col2 WHEN cor0.col0 THEN 55 WHEN - cor0.col0 THEN NULL ELSE - cor0.col0 END WHEN cor0.col2 THEN cor0.col0 END AS col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT cor1.col0 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + 54 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 8 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 0 FROM tab2 GROUP BY col0

;

SELECT 47 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - - 84 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + - col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT + cor1.col1 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT + ( 55 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 9 AS col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT ( + 28 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT col1 AS col0 FROM tab2 GROUP BY col1

;

SELECT + tab0.col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT NULLIF ( 20, - tab0.col1 ) AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT 69 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT col2 * - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 * - 98 + cor0.col1 * + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - ( cor0.col0 ) * col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + col0 * + 36 FROM tab0 AS cor0 GROUP BY cor0.col0, col0

;

SELECT cor0.col2 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT + + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 11 + cor1.col0 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + + 35 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 79 FROM tab1 GROUP BY tab1.col2

;

SELECT 91 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT + 38 AS col1 FROM tab1 GROUP BY col2

;

SELECT - cor0.col1 AS col2 FROM tab1, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 68 + 4 FROM tab0 GROUP BY tab0.col0

;

SELECT 4 - - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ( 3 ) AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT - tab1.col1 * - 43 FROM tab1 GROUP BY tab1.col1

;

SELECT 74 * cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + + col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT DISTINCT - col1 - col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 79 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - cor0.col2 * + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL - + 38 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col1 * - 17 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + + 37 FROM tab0 GROUP BY col0

;

SELECT + ( 51 ) FROM tab2, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( col2 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col2

;

SELECT ALL - 29 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col0

;

SELECT DISTINCT 4 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT 90 * tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 68 AS col1 FROM tab0 GROUP BY col2

;

SELECT ALL 14 AS col1 FROM tab1 GROUP BY col0

;

SELECT DISTINCT 67 FROM tab2 GROUP BY col1

;

SELECT col2 * + 69 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + 16 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor1.col1

;

SELECT + cor1.col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0, cor1.col1

;

SELECT + 0 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 81 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + 61 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL col0 * 43 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL col2 * - 46 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - 1 FROM tab0 GROUP BY col1

;

SELECT ALL NULLIF ( NULLIF ( - cor0.col0, - cor0.col0 ), - col0 ) FROM tab1 cor0 GROUP BY cor0.col1, col0

;

SELECT + - 85 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT 38 + + 95 * cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT 65 - 95 FROM tab2 GROUP BY tab2.col1

;

SELECT - 25 - + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 * 42 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 6 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 81 AS col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + 80 AS col2 FROM tab0 GROUP BY col0

;

SELECT + 55 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - cor1.col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1, cor1.col1

;

SELECT + 26 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - + tab1.col1 - + tab1.col1 FROM tab1 GROUP BY col1

;

SELECT 1 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT 73 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT + 41 AS col1 FROM tab1 GROUP BY col0

;

SELECT ALL + - 44 FROM tab1 GROUP BY tab1.col2

;

SELECT NULLIF ( + tab2.col0, tab2.col0 ) * + 93 + 6 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 19 * + col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 99 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + + tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT 69 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + 2 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - CASE - cor0.col2 WHEN - cor0.col2 - + cor0.col1 THEN NULL ELSE + col2 + - col2 END AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - + tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - col1 FROM tab1 GROUP BY col1

;

SELECT cor0.col1 * - cor0.col1 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT 76 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 44 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - + 62 AS col1 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - 54 FROM tab1 GROUP BY tab1.col2

;

SELECT 80 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - 41 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT + + 4 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT tab2.col1 * ( 74 ) AS col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT + 96 * 81 AS col2 FROM tab2, tab0 AS cor0 GROUP BY tab2.col2

;

SELECT ALL cor1.col2 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2 HAVING ( NULL ) IS NOT NULL
;

SELECT DISTINCT tab0.col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT ALL CASE - cor0.col2 WHEN cor0.col2 THEN + cor0.col1 ELSE NULL END * cor0.col1 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + - col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT tab2.col0 - - tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 43 * - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - col1 * 32 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col1 + 64 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 * - 31 AS col0 FROM tab0 cor0 GROUP BY col2

;

SELECT ALL - cor1.col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0, cor0.col2

;

SELECT 41 AS col1 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT + cor0.col1 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT cor1.col1 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT ALL - 79 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2, cor1.col0, cor1.col2

;

SELECT ALL + 2 + col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 73 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + + ( - tab2.col2 ) FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + cor0.col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor1.col0 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + 71 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL col0 - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 86 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 12 * - 15 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 * + cor0.col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT - col1 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + ( cor1.col0 ) FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT + NULLIF ( + 9, + col0 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + + tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL ( - cor0.col0 ) AS col1 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - 19 * cor1.col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT + cor0.col2 * + 30 + + cor0.col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - + 52 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - 73 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 43 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - 33 + - 3 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 48 FROM tab2 GROUP BY tab2.col0

;

SELECT 51 FROM tab0 GROUP BY tab0.col1

;

SELECT 51 * 80 + + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 59 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 16 * + 8 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 19 FROM tab1 GROUP BY col1

;

SELECT DISTINCT cor1.col0 - + cor0.col0 * cor0.col0 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0, cor1.col0

;

SELECT ( 76 ) FROM tab1 GROUP BY tab1.col2

;

SELECT - NULLIF ( 95, + tab0.col2 ) FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + COALESCE ( COALESCE ( cor0.col0, 87 * cor0.col2 ), + cor0.col0 + cor0.col0 * + cor0.col0, + 70 * - cor0.col1 ) * - ( cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT - ( - 97 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT col1 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor1.col0

;

SELECT DISTINCT + 59 * + 80 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT ( - 9 ) FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - ( 56 ) AS col2 FROM tab1 GROUP BY col2

;

SELECT cor0.col0 * 21 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 91 FROM tab1 GROUP BY tab1.col1

;

SELECT - ( - 31 ) FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL cor1.col0 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT - 69 * + tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - 4 * - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT + 78 * + tab1.col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT + col0 * + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 31 * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 87 AS col0 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - col1 * - ( cor0.col1 ) + - 68 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - + tab0.col0 * col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 14 - tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 31 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ( - 62 ) + + col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 32 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT + 41 * + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col0, col2, cor0.col0

;

SELECT col1 FROM tab2 GROUP BY col1

;

SELECT col2 * cor0.col2 + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 20 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT ( - 60 ) FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - cor1.col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT - + tab0.col1 * col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - 58 FROM tab2 GROUP BY tab2.col1

;

SELECT + tab0.col0 + - tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - ( ( + 3 ) ) AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + - cor0.col2 FROM tab1, tab0 cor0 GROUP BY cor0.col2

;

SELECT + 51 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 + + cor0.col2 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT 88 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 95 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 34 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + 17 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + + 14 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 56 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT cor0.col0 + 57 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - - tab0.col1 * - 96 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - tab1.col0 * 68 + + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + - col2 FROM tab1 GROUP BY col2

;

SELECT 55 - + tab0.col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT 80 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT ( 34 ) AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + ( + CASE col2 WHEN cor0.col2 + cor0.col1 * - cor0.col2 THEN NULL WHEN - cor0.col1 THEN NULL WHEN ( cor0.col2 ) * + cor0.col2 THEN cor0.col0 / cor0.col2 END ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT ALL + cor0.col1 + + cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - 14 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 43 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - 92 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT + 82 FROM tab1 GROUP BY col0

;

SELECT - - 8 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - + 16 FROM tab2 GROUP BY col1

;

SELECT DISTINCT cor0.col2 + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 25 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor1.col0 AS col0 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT - 81 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - + ( tab2.col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - + 29 FROM tab1 GROUP BY col1

;

SELECT + 94 * + 74 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor0.col0 * 48 AS col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL cor0.col0 * 30 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 - + 78 * - 32 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 39 + - col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor1.col2 AS col2 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT ALL - cor0.col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT - 65 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + - col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + col1 + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + cor1.col1 AS col2 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT 42 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT - col1 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 59 * cor1.col0 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT 86 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT 41 AS col0 FROM tab2 GROUP BY col2

;

SELECT ALL + + col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + cor0.col2 * - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + + col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor0.col0

;

SELECT - tab2.col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT ALL 29 FROM tab0 GROUP BY tab0.col2

;

SELECT + 9 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT - 5 FROM tab0 GROUP BY tab0.col0

;

SELECT - 62 * - 9 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + - 30 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL col0 - - 58 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL ( col0 ) AS col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT cor0.col2 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col0, cor0.col2

;

SELECT DISTINCT ( 17 ) FROM tab0 cor0 GROUP BY col1

;

SELECT 56 * - 18 FROM tab0 GROUP BY tab0.col2

;

SELECT 9 + + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + ( + 55 ) FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 52 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - 37 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT + + 68 + tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - col2 * + 8 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 10 FROM tab1 GROUP BY tab1.col1

;

SELECT + 66 + 42 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab0.col0 + - 67 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + ( tab2.col0 ) FROM tab2 GROUP BY col0

;

SELECT - ( + cor0.col2 ) * cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 1 FROM tab1 GROUP BY col0

;

SELECT + tab1.col0 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 39 AS col1 FROM tab0 GROUP BY col0

;

SELECT ALL - 14 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 72 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 23 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT + 16 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - - tab0.col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT + tab2.col2 * tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + + col0 + 60 FROM tab0 GROUP BY col0

;

SELECT ALL cor0.col2 + - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - cor0.col2 * + cor0.col2 + - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col1 * - 39 - cor0.col1 * - 37 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 82 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - - col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT cor0.col2 + 8 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + 76 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + 98 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col0

;

SELECT 16 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ( + 95 ) AS col1 FROM tab1 GROUP BY col2

;

SELECT + 79 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 30 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - + 90 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col1 - ( - 91 + col1 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT tab0.col1 + 87 * - 25 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT COALESCE ( + cor0.col0, cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT tab2.col1 + - tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 11 + cor0.col1 * cor0.col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2, cor0.col1, cor0.col0

;

SELECT + 47 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL tab1.col1 + 99 FROM tab1 GROUP BY col1

;

SELECT + cor0.col2 AS col2 FROM tab1 AS cor0 WHERE NOT - cor0.col2 IS NOT NULL OR NOT NULL NOT IN ( cor0.col1 * col1 ) GROUP BY cor0.col2

;

SELECT cor1.col1 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0, cor1.col1

;

SELECT + col1 * - ( + 87 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + ( cor0.col0 ) FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL 50 + - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - 85 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - - 35 AS col2 FROM tab2, tab0 AS cor0 GROUP BY tab2.col1

;

SELECT DISTINCT 16 FROM tab0 GROUP BY tab0.col0

;

SELECT ( 7 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - ( col0 ) AS col1 FROM tab1 GROUP BY col0

;

SELECT - - col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 5 AS col0 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - - 59 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 48 * 0 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT 13 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 14 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 24 FROM tab2 GROUP BY col0

;

SELECT ALL - 68 FROM tab0 GROUP BY tab0.col0

;

SELECT - 40 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - 18 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + CASE - 81 WHEN + 0 THEN + cor0.col2 * ( + cor0.col2 ) END AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - - 32 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 2 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT - tab0.col1 * 75 FROM tab0 GROUP BY tab0.col1

;

SELECT - 93 + 49 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 24 * + 56 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ( - tab0.col1 ) FROM tab0 GROUP BY tab0.col1

;

SELECT CASE cor0.col1 WHEN - cor0.col1 THEN cor0.col1 WHEN cor0.col1 + - 54 THEN NULL ELSE NULL END AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + + 38 FROM tab2 GROUP BY tab2.col1

;

SELECT 11 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL CASE cor0.col2 WHEN cor0.col2 THEN cor0.col2 ELSE NULL END AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 44 * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 78 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT + - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT tab1.col2 - - 10 FROM tab1 GROUP BY col2

;

SELECT + ( + col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 60 - - col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - + col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 57 * - 24 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 81 FROM tab2 GROUP BY tab2.col0

;

SELECT cor1.col0 * 39 + - 78 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL cor0.col2 * col2 + + 50 * - col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL ( cor0.col1 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT + ( - cor0.col0 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col1 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL tab2.col1 * tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - - 65 FROM tab1 GROUP BY col0

;

SELECT DISTINCT - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 79 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT 89 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col1

;

SELECT ALL - 58 AS col0 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 * 19 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 84 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col0 - - 45 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 53 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT 26 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 68 FROM tab2 GROUP BY col0

;

SELECT ALL + cor0.col0 AS col0 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 AS col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - 93 FROM tab2 GROUP BY tab2.col1

;

SELECT + + 4 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + cor0.col1 * 52 + + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT NULLIF ( cor0.col2, + cor0.col2 * cor0.col2 ) * 82 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 39 * tab1.col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - 93 * - 44 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 * - 50 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - 13 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - cor0.col0 * ( cor0.col0 * + cor0.col0 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - 39 AS col1 FROM tab2 GROUP BY col1

;

SELECT ALL + cor0.col0 + cor0.col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL + CASE cor0.col1 WHEN - 29 / cor0.col1 THEN NULL ELSE + 5 END AS col2 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 63 * - cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + 76 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL cor0.col0 * - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 33 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT + tab2.col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT ALL + col1 * + 50 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + + 93 * + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 56 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT + NULLIF ( cor0.col1, cor0.col1 / - 56 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor1.col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2, cor1.col1

;

SELECT 98 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - - 6 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col1 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + + 7 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 41 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT 63 * col0 FROM tab1 GROUP BY col0

;

SELECT - tab0.col2 * 68 AS col0 FROM tab0 GROUP BY col2

;

SELECT - 70 * 20 + - col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 27 - tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + 59 AS col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT + cor0.col0 * - 52 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT - - col1 + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 68 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + - tab0.col0 * + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col1 + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col1, cor0.col0, cor0.col2

;

SELECT - 93 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT 61 * 51 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - + 47 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + col0 + - col0 AS col2 FROM tab0 GROUP BY tab0.col0 HAVING NOT NULL IS NULL
;

SELECT - COALESCE ( tab1.col1, tab1.col1 ) + 95 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - + 28 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 18 FROM tab2 GROUP BY tab2.col2

;

SELECT 91 + - COALESCE ( + 99, col0 ) FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL - - 55 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 19 FROM tab0 GROUP BY col2

;

SELECT - 6 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL ( + cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 26 FROM tab2 GROUP BY tab2.col0

;

SELECT ( + cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT - col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + - col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT - tab1.col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT + + col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + + tab0.col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 66 AS col0 FROM tab2 GROUP BY col0

;

SELECT ALL - cor0.col2 + - cor0.col2 * - 52 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - - 36 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 93 * 10 + cor0.col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 40 AS col1 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 68 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT + - col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor1.col1 + - 5 AS col2 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2, cor1.col1, cor1.col0

;

SELECT cor0.col2 * + cor0.col2 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + NULLIF ( + cor0.col1, cor0.col1 * - 33 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - 72 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - - 37 * 88 AS col1 FROM tab0, tab1 cor0 GROUP BY tab0.col0

;

SELECT - 65 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - 47 + - 28 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 92 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT NULLIF ( 98, cor0.col2 + - cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL ( + 86 ) FROM tab2 GROUP BY col0

;

SELECT + cor0.col0 * - ( + cor0.col0 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT - cor0.col0 * + col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT ALL COALESCE ( + 8, cor0.col0 * col0, - cor0.col0 * cor0.col1 - - cor0.col1, cor0.col0 ) + cor0.col0 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, col0

;

SELECT - 43 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - cor1.col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0 HAVING NOT NULL = + cor1.col0
;

SELECT DISTINCT - 33 * 3 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 59 FROM tab0 GROUP BY col0

;

SELECT 41 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - cor0.col2 * ( cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - 29 + NULLIF ( - col1 + - 68, cor0.col0 ) * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 95 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT + - col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 63 AS col0 FROM tab2 GROUP BY col2

;

SELECT - - 70 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + cor0.col0 + + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT cor1.col2 AS col1 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT 32 - - cor0.col2 * + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + col2 * cor0.col2 + 29 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - cor0.col1 - + ( - 55 ) FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 45 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + 24 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT + - 90 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 94 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT + 36 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT 12 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT - - 80 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 14 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col0 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col2 + 6 AS col1 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col1 * cor0.col1 + COALESCE ( cor0.col2, cor0.col2 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT - 16 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - ( + 70 ) FROM tab0 GROUP BY tab0.col0

;

SELECT 51 FROM tab0 GROUP BY tab0.col2

;

SELECT 68 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + 27 * + 89 + cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 91 AS col1 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + + 3 * 67 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - COALESCE ( + cor0.col0, - 77 + cor0.col1 ) * 31 + col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 68 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT + cor0.col2 * col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 56 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 98 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - tab1.col1 FROM tab1 GROUP BY col1

;

SELECT - ( - tab0.col2 ) AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 82 + 9 * 36 FROM tab2 GROUP BY col2

;

SELECT - tab1.col2 + 74 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 57 FROM tab0 GROUP BY tab0.col1

;

SELECT col2 + - cor0.col2 * 12 FROM tab2 AS cor0 GROUP BY col2, col2

;

SELECT DISTINCT 98 + - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + + col2 + + 92 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + - tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT cor1.col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor0.col0

;

SELECT DISTINCT + col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col2 - ( 51 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 + cor0.col2 * col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL tab1.col1 * tab1.col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT + 54 FROM tab0 GROUP BY tab0.col1

;

SELECT - col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT + tab0.col0 * + 60 FROM tab0 GROUP BY col0

;

SELECT ALL + 19 * 39 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col1

;

SELECT ALL 43 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT - 14 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + col2 * 85 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 53 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL 17 + + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 11 + - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + - 98 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 51 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT + ( + 63 ) FROM tab2, tab0 AS cor0 GROUP BY tab2.col2

;

SELECT + 97 - + 41 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 28 + cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor0.col0, cor0.col0

;

SELECT DISTINCT cor0.col2 + - 87 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + - 67 * 13 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - 7 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 22 + 44 FROM tab1 GROUP BY tab1.col0

;

SELECT - col0 + tab2.col0 * + 66 FROM tab2 GROUP BY col0

;

SELECT + col0 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT + 5 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - + 83 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 56 + 63 FROM tab0 GROUP BY tab0.col0

;

SELECT - + col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT + + 42 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 90 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + cor0.col0 * + 28 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL + 53 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 75 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + - 52 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL cor0.col1 * + 68 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 94 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT 15 FROM tab1 GROUP BY tab1.col0

;

SELECT - 11 * 23 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + - tab1.col0 FROM tab1 GROUP BY col0

;

SELECT - cor0.col0 * 34 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT - - tab2.col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - 33 * + 97 FROM tab1 GROUP BY col2

;

SELECT ALL ( + 67 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - - 38 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 78 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - tab1.col1 * + tab1.col1 + + tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 91 FROM tab2 GROUP BY col2

;

SELECT + 72 * - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + cor0.col1 - - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - 34 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 22 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL cor0.col1 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - ( 69 ) FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - - 46 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + + 47 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - - tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT + - tab2.col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT + cor0.col1 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NOT ( NULL ) IN ( cor0.col1 )
;

SELECT ALL cor0.col0 AS col0 FROM tab1 AS cor0 WHERE ( NULL ) <= NULL GROUP BY cor0.col0

;

SELECT - - 95 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 62 * - 66 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 64 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 48 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 44 AS col1 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT cor1.col0 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + 60 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 62 FROM tab2 GROUP BY tab2.col0

;

SELECT + 86 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 50 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 75 FROM tab1 GROUP BY tab1.col2

;

SELECT 92 FROM tab0 GROUP BY tab0.col2

;

SELECT 79 FROM tab0 GROUP BY tab0.col0

;

SELECT - 22 FROM tab2 GROUP BY tab2.col2

;

SELECT + 28 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL + 41 - 33 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - ( 18 ) AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + + 19 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - + col1 * 87 FROM tab2 GROUP BY tab2.col1

;

SELECT + ( 80 ) - - 1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 19 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 76 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL + ( col2 ) AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 60 FROM tab1 GROUP BY tab1.col2

;

SELECT 77 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - - 0 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col0 - 69 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 + col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + - 62 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 68 FROM tab0 GROUP BY tab0.col1

;

SELECT - ( cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + - cor0.col2 * cor0.col2 AS col1 FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + - 1 FROM tab0 GROUP BY tab0.col0

;

SELECT 91 * + 90 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + col0 FROM tab2 cor0 GROUP BY cor0.col1, col0

;

SELECT + 44 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 71 * 98 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 80 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + - col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT ALL cor0.col0 + 76 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 * - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 76 + + cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT 77 + + 10 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + + cor0.col1 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT - 35 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT - 53 * + cor0.col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - 96 + - tab0.col0 FROM tab0 GROUP BY col0

;

SELECT 75 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 87 + - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 7 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 52 + + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + + tab0.col1 * - NULLIF ( tab0.col1, + 17 ) FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 32 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 80 FROM tab1, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 * 16 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT col1 * 97 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - - ( tab0.col2 ) + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + cor0.col0 + + cor0.col0 FROM tab1 cor0 GROUP BY col0, cor0.col2

;

SELECT - 23 FROM tab0 GROUP BY col0

;

SELECT ALL - cor0.col1 * 83 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL - tab1.col1 + ( 3 ) FROM tab1 GROUP BY tab1.col1

;

SELECT + 80 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT - 24 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 69 AS col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT - 14 AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL cor0.col2 + 5 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT + 3 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 9 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 45 AS col0 FROM tab0 GROUP BY col1

;

SELECT + 50 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT NULLIF ( cor0.col1, cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 25 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - cor0.col2 * 92 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col0, cor0.col2

;

SELECT + 42 * cor0.col1 + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT ALL - cor0.col1 - + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 15 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 * - cor0.col2 - col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 82 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT + tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - + 95 + col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col2 + - cor0.col2 * 85 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 56 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 97 AS col0 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - - 32 AS col1 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 36 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - tab0.col0 + tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - cor0.col0 * col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT 39 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 15 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 50 - cor0.col1 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 74 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - 7 * - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + col0 FROM tab2 GROUP BY col0

;

SELECT cor0.col2 * 3 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ( + cor0.col2 ) AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 49 * 47 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT 52 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT + cor0.col2 * cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL 63 FROM tab2 GROUP BY col0

;

SELECT ALL - + 79 FROM tab0 GROUP BY tab0.col1

;

SELECT - col0 * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 3 * - 73 + - cor0.col0 * 52 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 90 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 * - 49 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 88 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 99 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 42 FROM tab0 GROUP BY tab0.col1

;

SELECT - col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL - NULLIF ( + cor0.col2, - 83 ) * - 28 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT 59 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + tab2.col1 * COALESCE ( tab2.col1, tab2.col1 ) + + 37 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 26 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 33 + 85 * 96 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 26 * cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 61 * + 27 AS col2 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NULL
;

SELECT + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING NULL IS NULL
;

SELECT ALL col2 + + cor0.col2 / - cor0.col2 AS col1 FROM tab0 AS cor0 WHERE NOT NULL <= NULL GROUP BY cor0.col2 HAVING NOT ( NULL ) IS NULL
;

SELECT DISTINCT - tab0.col2 + - tab0.col2 * tab0.col2 FROM tab0 GROUP BY col2

;

SELECT + 59 AS col0 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL - + tab2.col0 FROM tab2 GROUP BY col0

;

SELECT col0 + + col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 - + 66 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 17 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 28 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 * 14 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - - 11 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 30 FROM tab1 GROUP BY tab1.col0

;

SELECT + col0 + 12 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + 43 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 73 + + col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + cor0.col2 * - 73 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 91 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 1 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + 66 - - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 85 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 78 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ( + tab1.col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT ( 11 ) * - 28 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 2 AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col1

;

SELECT DISTINCT + 87 FROM tab2 GROUP BY col2

;

SELECT ALL tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + tab0.col0 + - 25 FROM tab0 GROUP BY tab0.col0

;

SELECT ( + 53 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 88 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT tab2.col0 * + 98 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 71 FROM tab2 GROUP BY col2

;

SELECT DISTINCT 23 AS col1 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0

;

SELECT + cor0.col2 * - col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 61 FROM tab2 GROUP BY tab2.col2

;

SELECT 46 FROM tab2 GROUP BY tab2.col2

;

SELECT 48 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col2 * cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 87 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 1 * + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 26 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 69 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - 93 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 + + 42 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 - - cor0.col1 * 74 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT ALL + 37 FROM tab2 GROUP BY tab2.col2

;

SELECT 22 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 41 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 97 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 69 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + 30 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + col1 * 77 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + col1 - - 46 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + cor0.col2 * + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - 69 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 74 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 80 AS col2 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT 84 * - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT - - tab2.col2 * - ( - tab2.col2 ) FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - - 95 - + 99 AS col2 FROM tab2 GROUP BY col2

;

SELECT ALL - cor0.col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 86 * tab2.col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT 85 + col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 38 * 51 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col2 - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - NULLIF ( - col0, col0 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 50 * 33 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 47 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 17 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + ( 50 ) * col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - - tab0.col2 + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL tab2.col0 - + 17 * col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 13 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 98 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - - tab1.col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT - 17 FROM tab0 GROUP BY col0

;

SELECT + cor0.col2 + cor0.col0 * - 82 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT col2 * - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col2 + + col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + cor0.col0 + - cor0.col0 AS col1 FROM tab2 cor0 GROUP BY col0

;

SELECT + - tab2.col2 + + 39 FROM tab2 GROUP BY tab2.col2

;

SELECT - 81 + 85 FROM tab2 GROUP BY tab2.col1

;

SELECT - col1 + 97 * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - 17 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col2 * + cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 FROM tab0 cor0 GROUP BY col2

;

SELECT + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT 58 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL ( + cor0.col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - col0 + 70 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT col1 AS col2 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT + cor0.col0 * 70 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT 84 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT tab1.col2 * 28 AS col2 FROM tab1 GROUP BY col2

;

SELECT + CASE cor0.col2 WHEN + cor0.col2 THEN + 92 ELSE NULL END AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 + 19 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL cor0.col0 AS col1 FROM tab0 cor0 GROUP BY col0, cor0.col0

;

SELECT ALL - col2 - 94 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col1 * + 44 + cor0.col1 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT + 61 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT - + tab2.col0 * - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 70 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT 76 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + 61 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 * - col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT + cor0.col1 + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 55 * 8 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - tab1.col2 + + col2 FROM tab1 GROUP BY tab1.col2

;

SELECT tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2 HAVING NULL > NULL
;

SELECT ALL - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col0 * 90 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT - 12 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT ALL - 39 * + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + ( 29 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - - 22 AS col2 FROM tab2 GROUP BY col0

;

SELECT + 14 + tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL NULLIF ( 27, + cor0.col1 * col1 - cor0.col1 ) FROM tab1 AS cor0 GROUP BY col1

;

SELECT - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + cor0.col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col0, cor0.col1

;

SELECT - + 57 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - cor0.col1 * + 54 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 97 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 14 AS col1 FROM tab1 GROUP BY col1

;

SELECT col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab2.col1 * + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col2 - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 59 * - col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT + 93 * 66 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 33 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 22 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 + - 82 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 * cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 61 AS col0 FROM tab1 GROUP BY col2

;

SELECT + tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT ALL + 1 FROM tab1 GROUP BY col0

;

SELECT DISTINCT 23 - cor0.col2 * + cor0.col0 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT DISTINCT - 70 * 9 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 96 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + 99 * - 91 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT + 41 AS col2 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2, cor1.col2

;

SELECT ALL - cor0.col1 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT 86 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col0, cor0.col0

;

SELECT DISTINCT + - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 52 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + tab1.col1 * 38 FROM tab1 GROUP BY col1

;

SELECT ALL - + 56 FROM tab0 GROUP BY col0

;

SELECT - cor0.col2 AS col0 FROM tab1 cor0 GROUP BY col2, cor0.col2

;

SELECT ALL - cor0.col2 + cor0.col2 * 92 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 24 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col2, cor0.col0, col1

;

SELECT ALL - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL ( + col2 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 85 FROM tab2 GROUP BY col2

;

SELECT ALL + - 84 FROM tab2 GROUP BY col1

;

SELECT ALL + 1 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ( - 9 ) + - 40 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 31 FROM tab2 cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col2

;

SELECT ALL 80 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL 92 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 87 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + 9 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 37 * + col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col0 + - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - col0 * cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT - cor0.col0 + cor0.col0 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0, cor0.col1

;

SELECT 3 + 96 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT tab1.col0 * + 62 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT 23 * - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - 79 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT cor0.col0 AS col0 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT 99 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT ALL - 53 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 89 + col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + 69 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 65 FROM tab0 AS cor0 GROUP BY col1, cor0.col0, cor0.col1

;

SELECT 4 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 73 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col1 * + col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 * ( 8 * cor0.col1 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + + 34 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - + 72 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 13 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 45 + - 34 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 AS col2 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + cor1.col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 93 * 52 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 25 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 69 + + cor0.col2 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 20 * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col2 + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - + tab1.col0 * - 26 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT cor0.col2 - cor0.col0 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT ALL 84 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - cor0.col0 * - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT cor0.col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col0, cor0.col2

;

SELECT - 81 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col0 + ( 50 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 83 * + 54 FROM tab2 GROUP BY col2

;

SELECT COALESCE ( 87, - 61 ) AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT - cor0.col1 - cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - 35 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL cor0.col2 + col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + 62 - - 95 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 65 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 22 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 56 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 54 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL - col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 67 AS col1 FROM tab2 GROUP BY col1

;

SELECT DISTINCT cor0.col1 * - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 50 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + 62 * - tab1.col2 + col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT + col2 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col0 * + cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - 70 FROM tab0 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT 90 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + cor0.col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL tab0.col1 + - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + cor0.col2 - - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + 8 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + col1 - 42 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + 4 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 5 * + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + cor0.col1 + - 83 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 58 * + cor0.col0 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT col0 + - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT 77 * cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 * + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT col1 FROM tab0 GROUP BY tab0.col1 HAVING NOT ( NULL ) IS NULL
;

SELECT DISTINCT + col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT COALESCE ( + cor0.col1, cor0.col1, 2, cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 75 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 * 6 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 - - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 23 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 41 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ( + cor0.col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 * + cor0.col2 - 83 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + ( + 46 ) + - cor0.col2 * col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL col0 + + 3 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 35 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 14 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + 59 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - col1 + col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - 68 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 75 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 67 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 6 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT ALL tab0.col1 - + 0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 4 * 72 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - tab0.col0 * + col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 68 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - cor0.col2 + 40 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL - ( 91 ) - - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL 80 * - 98 + - cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + + 94 + 16 FROM tab0 GROUP BY tab0.col1

;

SELECT - 54 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 58 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 29 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 65 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + 74 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 15 FROM tab0 AS cor0 GROUP BY col2

;

SELECT cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1, col0

;

SELECT DISTINCT 77 * - cor1.col0 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + 78 FROM tab0 AS cor0 GROUP BY col1, cor0.col2, col0

;

SELECT DISTINCT - ( cor0.col0 ) * 46 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT - ( + 71 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT ALL + 36 FROM tab0 GROUP BY tab0.col1

;

SELECT 33 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 + + 99 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col2 + + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 73 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ( 89 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 13 FROM tab2 GROUP BY tab2.col1

;

SELECT 63 FROM tab1 GROUP BY tab1.col0

;

SELECT + tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT + 51 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 54 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 * cor0.col2 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - 93 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 24 FROM tab0 GROUP BY col1

;

SELECT - cor0.col0 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 60 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 76 + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 44 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 39 FROM tab0 GROUP BY tab0.col0

;

SELECT 36 - 36 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 * - 6 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + ( 44 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 90 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 77 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 67 + 11 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + 30 FROM tab1 GROUP BY col2

;

SELECT 44 AS col0 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT + ( 96 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 * 42 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 - + col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 52 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + tab2.col2 * 84 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL cor0.col2 * 73 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT 29 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 50 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 97 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 89 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - 81 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 48 * - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 79 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + 72 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 + - cor0.col2 * 77 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + + 95 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 31 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - 5 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * 39 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 29 AS col1 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT 79 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 * cor0.col1 + - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT - 75 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 71 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - ( + cor0.col1 ) FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - 59 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 82 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + 98 FROM tab0 GROUP BY col0

;

SELECT ALL + 70 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + - 63 FROM tab1 GROUP BY tab1.col1

;

SELECT 10 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - ( 42 ) FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col2 * cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 55 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 67 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 + - cor0.col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + cor0.col0 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 10 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 80 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT - cor0.col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col1

;

SELECT - 68 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 56 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT - 83 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT 2 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT + 83 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 34 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 98 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - tab0.col0 FROM tab0 GROUP BY col0

;

SELECT - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 56 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 83 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT NULLIF ( 43, + cor0.col1 ) * 17 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col0 * + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 38 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 86 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 59 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + - tab1.col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT ALL + - col0 * tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 29 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 92 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 9 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING ( NULL ) IS NULL
;

SELECT DISTINCT + tab1.col1 FROM tab1 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT - 96 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL 61 AS col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT + 49 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - 22 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col1 * - cor0.col1 FROM tab2 cor0 GROUP BY col1

;

SELECT cor0.col0 + + 94 * - 89 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - cor0.col2 * 88 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL + ( - cor0.col2 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 39 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 92 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 93 + cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 4 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 8 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 80 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 19 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT 70 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - - 23 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab0 cor0 GROUP BY col1

;

SELECT + ( - cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 56 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - + 17 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - 7 * 50 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT ALL + 95 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + - 72 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT ( - 66 ) AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 1 + + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT 48 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT 82 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT DISTINCT 10 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2, cor0.col2

;

SELECT + 67 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor1.col0 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT + + 94 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 90 FROM tab2 GROUP BY tab2.col2

;

SELECT + 74 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + 3 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - - 16 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 73 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 32 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + 49 FROM tab1 AS cor0 GROUP BY col0

;

SELECT col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col1 + - 89 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - col0 + col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 51 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 25 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col2 * + 24 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 62 FROM tab2 GROUP BY tab2.col2

;

SELECT - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2 HAVING NOT - tab1.col2 IS NOT NULL
;

SELECT ALL cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + + 18 FROM tab1 GROUP BY tab1.col0

;

SELECT 64 AS col1 FROM tab2 GROUP BY col2

;

SELECT ALL - 81 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 5 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + 68 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 * - ( 68 ) FROM tab1 AS cor0 GROUP BY col1

;

SELECT - ( 67 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - + 54 FROM tab0 GROUP BY col1

;

SELECT 56 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 4 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 34 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 - 38 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 31 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor0.col0

;

SELECT + cor0.col1 * + 76 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 + + col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL tab2.col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + + 37 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - + tab0.col2 * 92 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 91 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT - + 32 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + tab0.col2 * + 49 FROM tab0 GROUP BY col2

;

SELECT 16 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + cor0.col2 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + 84 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT tab2.col2 * tab2.col2 FROM tab2 GROUP BY tab2.col2 HAVING NOT ( NULL ) NOT BETWEEN NULL AND NULL
;

SELECT + 8 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT 52 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 80 * col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 8 * + col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 30 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT tab2.col2 + - 7 FROM tab2 GROUP BY tab2.col2

;

SELECT col0 * cor0.col0 + + 32 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 62 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + 59 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT cor0.col0 + cor0.col0 * col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 65 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + cor0.col1 * col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT + - 72 FROM tab0 GROUP BY tab0.col0

;

SELECT + 39 - - tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT 88 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT ALL - - 83 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 77 + + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT NULLIF ( - cor0.col2, cor0.col2 - + cor0.col2 * 41 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 61 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL + 81 FROM tab2 GROUP BY tab2.col0

;

SELECT + 13 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 34 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + 36 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT 77 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + tab2.col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT ALL col0 - 98 * + col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 43 AS col1 FROM tab0 GROUP BY col2

;

SELECT - 63 * cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT tab2.col2 * 63 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + cor0.col2 + cor0.col0 * cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + 85 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 25 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 91 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 * - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 AS col2 FROM tab1 cor0 GROUP BY col2

;

SELECT - 49 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 63 + col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - + 31 FROM tab2 GROUP BY tab2.col2

;

SELECT 17 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col1 * col1 + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 52 - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col1, col0

;

SELECT ALL - + ( + 85 ) AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - + 24 + 57 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - 40 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT 67 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col2 * + 86 + - cor0.col2 * 61 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col1 + + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 93 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT - col2 FROM tab1 GROUP BY col2

;

SELECT 15 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col2 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col0, cor0.col2

;

SELECT ALL 65 + - 87 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + cor0.col0 - 60 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 98 AS col0 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 - + ( 19 ) AS col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col0 * - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT 94 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - 48 + 52 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + 55 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - 79 FROM tab1 GROUP BY col0

;

SELECT - 28 FROM tab0 GROUP BY col0

;

SELECT + cor0.col2 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + ( 86 ) FROM tab2 GROUP BY tab2.col1

;

SELECT - - 27 + 2 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - 88 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + + 51 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 69 + 36 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT tab1.col0 * tab1.col0 + 1 AS col1 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + cor0.col2 + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 AS col2 FROM tab2 cor0 GROUP BY col1 HAVING NOT NULL > NULL
;

SELECT + 30 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT col1 * - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + ( + 81 ) * col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - + tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 34 + - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col1 + - 42 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + 44 AS col0 FROM tab0 cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col2

;

SELECT DISTINCT 45 FROM tab2 GROUP BY tab2.col0

;

SELECT + NULLIF ( cor0.col1, col0 + cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT 67 + col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab2.col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT DISTINCT 20 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 35 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - 38 * cor0.col2 - 54 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 6 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + 92 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT col2 * tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 53 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - 98 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - 27 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 - + cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 13 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + + 0 AS col0 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT - + 16 + col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 23 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - + 57 FROM tab0 GROUP BY col1

;

SELECT ALL + 29 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 45 FROM tab0 GROUP BY tab0.col0

;

SELECT + cor0.col1 FROM tab0 cor0 GROUP BY col1, cor0.col2

;

SELECT 10 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0 HAVING NULL IS NOT NULL
;

SELECT + 58 + 80 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - tab1.col1 AS col2 FROM tab1, tab1 AS cor0 GROUP BY tab1.col1

;

SELECT DISTINCT + 30 FROM tab1 cor0 GROUP BY col1

;

SELECT col0 * cor0.col2 FROM tab2 cor0 GROUP BY col0, cor0.col2

;

SELECT ALL - 4 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 42 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + 7 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT col1 * - col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 8 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 53 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT cor0.col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col0 - + cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT + - 8 + + 5 AS col2 FROM tab0 GROUP BY col0

;

SELECT 94 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 0 FROM tab2 GROUP BY tab2.col1

;

SELECT + 86 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - cor0.col1 * - 28 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 + 33 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 78 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL - + 52 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - 1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 6 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 30 FROM tab0 GROUP BY tab0.col2

;

SELECT + 55 FROM tab2 GROUP BY tab2.col2

;

SELECT - 82 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 42 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 83 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 54 AS col0 FROM tab0 cor0 GROUP BY col0, cor0.col0, cor0.col0

;

SELECT 50 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + 42 FROM tab0 GROUP BY tab0.col0

;

SELECT - 66 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT ALL - 43 * 45 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 25 + cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT - tab0.col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT - 93 FROM tab1 GROUP BY col1

;

SELECT 88 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 40 FROM tab2 GROUP BY tab2.col1

;

SELECT 97 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT col1 + - 85 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 52 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + 47 FROM tab1 GROUP BY tab1.col0

;

SELECT - 51 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 38 + 62 FROM tab0 GROUP BY tab0.col0

;

SELECT + NULLIF ( cor0.col0, + cor0.col0 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - 82 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 21 + - tab0.col0 FROM tab0 GROUP BY col0

;

SELECT ALL + 27 + - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 92 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + cor0.col2 * + cor0.col2 + - 58 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 38 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - - 84 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - tab2.col1 FROM tab2 GROUP BY col1

;

SELECT - tab0.col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT DISTINCT 36 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 49 FROM tab0 GROUP BY tab0.col1

;

SELECT - 26 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 34 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 98 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT + 8 * + 99 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 + + ( + 37 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + ( 65 ) FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col2 - cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - 62 FROM tab2 GROUP BY tab2.col1

;

SELECT - 89 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - 93 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 19 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 53 FROM tab2 GROUP BY tab2.col0

;

SELECT 88 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 20 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 + - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 85 FROM tab0 GROUP BY col1

;

SELECT DISTINCT - 43 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT ( + tab1.col1 ) FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - col2 * 53 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 12 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL - cor0.col1 + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + + 27 * 17 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT - 78 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT 23 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT DISTINCT + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ( col0 ) * col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - ( + tab2.col0 ) FROM tab2 GROUP BY tab2.col0

;

SELECT 69 FROM tab0 GROUP BY col0

;

SELECT ( - 3 ) * - col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 FROM tab2 cor0 GROUP BY col2, cor0.col2, cor0.col0

;

SELECT + 86 * 67 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 31 + - col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + ( 96 ) FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 22 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 31 FROM tab1 GROUP BY col2

;

SELECT ALL cor0.col2 * col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT tab2.col1 * tab2.col1 FROM tab2 GROUP BY col1

;

SELECT - tab1.col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL IS NOT NULL
;

SELECT 5 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT tab2.col1 * + col1 FROM tab2 GROUP BY col1

;

SELECT 3 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + tab0.col1 AS col0 FROM tab0, tab0 AS cor0 GROUP BY tab0.col1

;

SELECT ALL 47 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col0 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT ALL 57 + cor0.col1 * - 43 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 66 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 73 FROM tab1 GROUP BY tab1.col1

;

SELECT - 42 FROM tab1 cor0 GROUP BY col0

;

SELECT 93 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL cor0.col0 + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 11 * 8 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col1 * - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 82 FROM tab0 GROUP BY col1

;

SELECT ALL + cor0.col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col0

;

SELECT ALL - 86 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - col2 AS col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL 97 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - col1 * + cor0.col1 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 37 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 50 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 73 + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + 47 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT ( + 54 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 23 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 24 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 57 * tab2.col0 + - 27 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col2

;

SELECT DISTINCT 46 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 13 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + - col1 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT 40 * - cor0.col0 - NULLIF ( 80, - 21 ) * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 73 FROM tab0 cor0 GROUP BY cor0.col1, col1

;

SELECT - col2 * - 8 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 * + col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - cor0.col2 * cor0.col2 FROM tab2, tab0 cor0 GROUP BY cor0.col2

;

SELECT 12 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col1 + + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 96 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 46 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 47 AS col2 FROM tab1 cor0 GROUP BY col1

;

SELECT ALL 28 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col2

;

SELECT cor0.col2 * 45 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col0 - NULLIF ( cor0.col1, + cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 84 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col1 + 17 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 76 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 6 * cor0.col0 + 29 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 * cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL + + 79 + 50 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - 16 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 16 FROM tab2 GROUP BY tab2.col1

;

SELECT 92 FROM tab2 cor0 GROUP BY col2, cor0.col0

;

SELECT + 13 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + - 23 FROM tab0, tab0 AS cor0 GROUP BY tab0.col0

;

SELECT DISTINCT + - 15 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + 64 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 83 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - tab2.col2 * 11 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT col2 * - tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - cor0.col1 * + 14 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col0 * + cor0.col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT - 58 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - ( - tab1.col1 ) + + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + - tab0.col0 + 19 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 44 - + 71 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 89 * - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 26 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 92 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col2 * - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 66 * - 40 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT ALL - 24 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT cor1.col0 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0, cor1.col0

;

SELECT - - 90 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 61 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 75 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 57 AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + cor0.col2 + - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 8 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 93 * - col1 - - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT ALL - 21 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor1.col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - - 88 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 41 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT ( tab0.col2 ) FROM tab0 GROUP BY col2

;

SELECT ALL + 69 + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - tab0.col2 AS col1 FROM tab0 GROUP BY col2

;

SELECT col0 - tab2.col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT cor0.col2 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + cor0.col0 * + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT - cor0.col0 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 64 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 68 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL col2 * 52 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + ( + cor0.col1 ) * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 36 * + cor0.col1 + - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 25 * col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col2 FROM tab1 cor0 GROUP BY col2

;

SELECT col0 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT col0 + - cor0.col1 * - 66 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT - cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - 93 + + 98 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor1.col0

;

SELECT ALL 47 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT col0 FROM tab0 cor0 GROUP BY col2, cor0.col1, cor0.col0

;

SELECT + tab2.col0 * - 14 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL tab2.col0 FROM tab2 GROUP BY col0

;

SELECT 17 FROM tab0 GROUP BY col0

;

SELECT ALL + 36 * 60 AS col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col1

;

SELECT DISTINCT 25 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + col1 AS col2 FROM tab2 GROUP BY col1

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT ALL cor0.col1 * 10 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, col1

;

SELECT + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ( - cor0.col2 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 2 + + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + 23 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 38 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 76 + cor0.col0 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 34 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL + cor0.col0 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col1 * cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 + 66 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 79 * tab0.col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT ALL + tab2.col1 * + col1 FROM tab2 GROUP BY tab2.col1

;

SELECT col0 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 45 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 84 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, col1

;

SELECT ALL + COALESCE ( - col2, + col2 * cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 35 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 83 AS col1 FROM tab0 GROUP BY col2

;

SELECT + 64 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT NULLIF ( cor0.col1, - NULLIF ( - cor0.col0, - cor0.col0 - cor0.col0 ) ) * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 31 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 84 + 14 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 13 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 67 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + + 91 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + - tab0.col1 FROM tab0 GROUP BY col1

;

SELECT ALL - 73 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 25 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + 0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col1 * - 21 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 11 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL 15 + + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL col0 * 1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 49 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 62 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL + 66 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 43 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 71 + cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + 15 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 41 * + col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 * - 50 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + 81 FROM tab2 GROUP BY tab2.col1

;

SELECT + 45 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL col2 * + cor0.col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 * cor0.col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - 74 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 71 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + 63 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL 74 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 27 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 91 + + 73 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 28 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - - tab1.col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - 52 AS col2 FROM tab1 GROUP BY col1

;

SELECT - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - - 22 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT 83 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 66 + 95 * col0 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT - 35 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col1 - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col0, cor0.col2

;

SELECT ALL cor0.col2 + - ( + cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col1 * 26 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - tab0.col2 * 85 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 26 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 85 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 + 83 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ( - tab2.col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 42 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 53 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 75 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - 32 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 16 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ( cor0.col0 ) * - cor0.col0 + 29 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT ALL 18 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT ALL + 58 AS col2 FROM tab0 cor0 GROUP BY col0, cor0.col0

;

SELECT DISTINCT - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col2 * - cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT ALL + ( + 3 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 40 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 73 + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT + col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL cor1.col1 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col1

;

SELECT ALL ( - 32 ) FROM tab0 GROUP BY tab0.col2

;

SELECT 25 AS col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2, cor0.col2

;

SELECT ALL - 64 - 95 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - - tab1.col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT 2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT DISTINCT + 62 FROM tab1 GROUP BY col2

;

SELECT 43 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 AS col0 FROM tab2, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col2 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT 69 AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 98 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL < NULL
;

SELECT + cor0.col1 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT tab1.col1 + col1 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col2 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 GROUP BY cor0.col2 HAVING NOT ( NULL ) IS NULL
;

SELECT cor0.col0 AS col2 FROM tab0 cor0 CROSS JOIN tab0 GROUP BY cor0.col0

;

SELECT - 56 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL + + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + col1 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 67 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 5 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT tab2.col2 * col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + col2 + + 86 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col0 * + 16 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 48 FROM tab2 GROUP BY tab2.col1

;

SELECT + 45 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 54 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 64 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - cor0.col0 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0, cor0.col0

;

SELECT - col1 - 24 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL 81 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 31 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT cor0.col1 + - 9 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL 67 * 87 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 95 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col0 AS col2 FROM tab2 GROUP BY col0

;

SELECT col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL - 34 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 51 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - 13 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 19 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + tab0.col1 + - 45 AS col0 FROM tab0 GROUP BY col1

;

SELECT cor0.col0 + - COALESCE ( cor0.col1 + cor0.col0, - col1 ) * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + cor0.col1 + 95 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL + 66 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col1 + 45 AS col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT + 92 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL ( + 85 ) AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL + 75 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 45 AS col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT + 95 AS col2 FROM tab1 GROUP BY col0

;

SELECT - cor0.col1 + col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor1.col2 AS col2 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT - col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - tab2.col0 FROM tab2 WHERE NOT + col0 + - col2 IS NOT NULL GROUP BY tab2.col0

;

SELECT 7 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - + 37 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col0 * - 14 FROM tab0 cor0 GROUP BY cor0.col2, col0

;

SELECT cor0.col1 - + cor0.col1 * + 73 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor0.col1

;

SELECT + - col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT ALL 27 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 30 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 22 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 79 * + tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - 33 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 87 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 65 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 63 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + ( cor0.col0 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 71 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 70 + + cor0.col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col0 * + col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col2 + - 48 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col2 AS col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 59 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + + 6 FROM tab1 GROUP BY tab1.col0

;

SELECT 59 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 3 * cor0.col0 + + 27 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 6 * col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 * - cor0.col1 + - 82 * 97 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL 40 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 13 AS col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col1

;

SELECT + ( - cor0.col0 ) + - col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT ALL + 21 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 59 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 95 FROM tab0 AS cor0 GROUP BY cor0.col0, col0

;

SELECT DISTINCT + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT tab0.col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT - 79 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 10 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 81 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 41 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 17 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 73 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 73 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 45 FROM tab1 GROUP BY col2

;

SELECT ALL + 24 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col1 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + 69 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 87 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col0 * 36 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT DISTINCT cor0.col2 * 18 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 * - 26 + 54 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 22 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( 60 ) * - 59 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - 83 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col1 + + cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT 83 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col0 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - 29 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + + 62 * tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 42 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL - cor0.col2 * + 31 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 64 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - ( cor0.col2 ) AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - 85 * - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - col0 * + col0 - - col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 76 * 53 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT DISTINCT 23 + 15 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col2

;

SELECT + cor0.col2 + + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 73 - + 4 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 0 AS col1 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - - 55 FROM tab2 GROUP BY col0

;

SELECT ALL 39 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL - 3 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 19 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + 68 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - ( - 21 ) AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1, cor0.col0

;

SELECT - 43 - tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 36 FROM tab0 GROUP BY col0

;

SELECT - 5 FROM tab0 GROUP BY col2

;

SELECT ALL - 67 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab1.col2 FROM tab1 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT cor0.col1 FROM tab2 cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT - 19 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + ( ( cor0.col0 ) ) FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + - 3 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT 1 + cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 36 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - cor0.col1 * 62 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 30 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 30 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - + 89 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 88 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 92 * + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 61 * col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 * cor0.col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT 84 FROM tab1 cor0 GROUP BY col1

;

SELECT tab2.col1 * tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - 22 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - 86 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - ( cor0.col1 ) * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - ( + cor0.col1 ) + + 94 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 + + 35 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 71 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + - tab2.col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT 95 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 35 * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ( + ( - 48 ) ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 59 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 32 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 44 FROM tab1 AS cor0 GROUP BY cor0.col2, col2

;

SELECT - 10 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL cor0.col0 * cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 10 - + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 6 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 79 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT 87 FROM tab2 GROUP BY col1

;

SELECT - + tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT + 82 * - col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + 52 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT - 74 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 7 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 41 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + - 95 FROM tab1 GROUP BY tab1.col2

;

SELECT 29 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL - 26 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 70 * cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - cor0.col2 * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT - cor0.col1 AS col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - col2 * cor0.col2 + - 98 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT ALL + 80 * + 9 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 10 FROM tab0 GROUP BY tab0.col0

;

SELECT - 53 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + ( + 61 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 38 * col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - col1 AS col0 FROM tab1 WHERE NULL NOT IN ( + tab1.col1 ) GROUP BY col1 HAVING NULL <> NULL
;

SELECT DISTINCT - 96 AS col0 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 + - 8 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - + tab0.col1 FROM tab0 GROUP BY col1

;

SELECT 83 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + - col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col1 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL 20 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 15 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT + 51 FROM tab1 GROUP BY tab1.col2

;

SELECT + 80 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL 14 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 0 FROM tab1 GROUP BY tab1.col0

;

SELECT 29 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT NULLIF ( cor0.col0, - cor0.col0 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 28 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 50 FROM tab0 GROUP BY col1

;

SELECT - cor0.col1 * - 40 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 2 * cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT 34 * - ( - cor0.col1 * - cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 4 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 43 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + 24 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 46 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 88 * tab0.col0 + - 52 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 92 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL 70 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT ( + cor0.col1 ) * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - col2 * - tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 90 + + col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - - 67 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col1 + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT + 50 + + col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT + tab1.col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT - 74 + tab2.col2 FROM tab2 GROUP BY col2

;

SELECT - 54 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 65 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NULL
;

SELECT ALL + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL tab2.col1 + 11 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT cor0.col1 - col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - + 38 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 82 * - 47 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 34 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 * - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 40 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 36 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 98 * + 15 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 7 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT cor1.col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - + 71 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 14 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 90 * 84 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col1 * - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT - cor0.col0 * - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT cor0.col0 * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT col0 * + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 28 - + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 63 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 81 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT - cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 1 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING ( NULL IS NOT NULL ) AND NOT NULL IS NULL
;

SELECT cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT col2 * - cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT col2 AS col1 FROM tab0 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL + - tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT cor0.col1 - cor0.col1 * col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + cor0.col1 + + col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 86 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - - 63 + - 24 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 58 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 91 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 44 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL + col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT cor0.col1 * cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT + 96 AS col1 FROM tab1 cor0 GROUP BY col2, cor0.col2

;

SELECT ALL + 67 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL col0 + + 35 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 48 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 99 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT 52 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col2 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT + 2 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 41 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + 52 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL + cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT - tab2.col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT 54 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT - 79 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 23 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 62 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + 49 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL 56 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 58 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + ( 24 ) AS col1 FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 64 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + - col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT cor0.col1 * + cor0.col1 FROM tab2 cor0 GROUP BY col1

;

SELECT - 49 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT cor0.col2 - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + 3 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT ALL - 11 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + + 58 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - ( cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - 85 + + tab2.col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT col0 * - 42 + 53 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 23 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT cor0.col1 - - 91 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab0.col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 4 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 64 + - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 76 * col1 FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT cor0.col2 FROM tab1 AS cor0 WHERE NOT cor0.col1 IS NULL GROUP BY cor0.col2 HAVING NOT NULL <> ( NULL )
;

SELECT DISTINCT - cor0.col0 FROM tab0 AS cor0 WHERE ( NULL ) IS NOT NULL GROUP BY cor0.col0

;

SELECT ALL cor0.col1 + - 69 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + + 63 FROM tab2 GROUP BY tab2.col2

;

SELECT + - 49 * 22 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT ( cor0.col2 ) FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT + cor0.col1 + 98 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + cor0.col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT + 73 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 58 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 + - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + + 72 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - tab0.col1 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT 14 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - col1 + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + 55 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 77 * + 84 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col2 + - ( - cor0.col2 + + cor0.col2 ) * + 90 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL ( + 44 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 33 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + 32 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - + col2 FROM tab0 GROUP BY col2

;

SELECT ALL + 26 AS col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT + cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col1

;

SELECT + - 76 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 94 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 76 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col2 + 88 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 12 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 23 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 70 + - cor0.col1 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT 49 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL tab2.col0 - tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + 61 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + - 86 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT col1 * - 28 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + col2 + - ( + 87 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + + 47 AS col2 FROM tab2 GROUP BY col1

;

SELECT 16 FROM tab1 GROUP BY col0

;

SELECT + + ( + cor0.col1 ) FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT ( 59 ) AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - + 49 * - tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 60 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2 HAVING NOT ( NULL ) < NULL AND NOT NULL IN ( col0 )
;

SELECT - col0 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 * + col0 FROM tab0 cor0 GROUP BY col0

;

SELECT + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT cor0.col1 + 90 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 51 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + cor0.col1 - 4 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col1 + - cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 52 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 FROM tab2 cor0 GROUP BY col0, cor0.col0

;

SELECT - cor0.col2 - - cor0.col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 66 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - col0 * cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL col0 * - 82 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col2

;

SELECT - ( 52 ) FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT cor0.col0 + 90 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 29 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 52 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col1 - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT col1 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT - tab0.col0 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - - ( - tab1.col2 ) AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 79 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 94 FROM tab2 GROUP BY col0

;

SELECT - + 10 FROM tab2 GROUP BY col2

;

SELECT 58 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + ( cor0.col2 ) FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL cor1.col0 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT cor0.col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor0.col1

;

SELECT + - tab1.col0 * 51 + 65 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col2 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 27 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT col1 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 32 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0

;

SELECT ALL 78 AS col2 FROM tab2 GROUP BY col1

;

SELECT CASE cor0.col0 WHEN - cor0.col0 + - cor0.col0 THEN cor0.col0 ELSE NULL END FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 54 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 91 - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 + cor0.col2 * + ( 8 * + col2 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT + 47 * - 47 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 AS col2 FROM tab2 cor0 GROUP BY col2

;

SELECT cor0.col1 - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 91 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT 76 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - - 76 FROM tab2 GROUP BY col2

;

SELECT DISTINCT cor0.col1 + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT + - tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT - 22 + + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 44 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT - 89 * + cor0.col1 + - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL cor0.col1 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT cor0.col1 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - cor0.col0 + ( cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 66 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col2 * 19 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 55 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 7 FROM tab2 GROUP BY tab2.col0

;

SELECT 71 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 37 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - cor0.col2 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * cor0.col2 + - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col1, col0

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - cor0.col0 * + COALESCE ( 19, - col0 * + cor0.col0 + cor0.col1, cor0.col1 ) FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT cor0.col1 * - 10 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 74 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 0 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - 66 FROM tab0 GROUP BY col2

;

SELECT 51 FROM tab1 AS cor0 GROUP BY cor0.col1, col1

;

SELECT + 87 * tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 24 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT + col2 + + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - - ( 23 ) AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT 4 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - cor0.col2 * + 88 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 12 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 71 AS col2 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT tab1.col1 + tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 80 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 12 + - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 + ( - 88 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT - 17 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0, cor0.col1

;

SELECT 80 + - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 59 * cor0.col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, col0

;

SELECT cor0.col2 + col2 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IS NOT NULL
;

SELECT + cor0.col2 FROM tab1 AS cor0 CROSS JOIN tab1 GROUP BY cor0.col2

;

SELECT DISTINCT - ( 65 ) AS col0 FROM tab1 GROUP BY col0

;

SELECT - + ( col2 ) AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + ( 66 ) FROM tab0 GROUP BY col1

;

SELECT - + 53 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT cor0.col0 + - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 3 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + + cor0.col0 * 65 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col0 * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 47 + + 24 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + ( + col1 ) + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 14 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT ALL cor0.col0 - + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col1 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, col1

;

SELECT ( COALESCE ( - cor0.col0, 56 + + cor0.col0 ) ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 40 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 67 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 53 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT + 74 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 7 AS col0 FROM tab0 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT - cor0.col1 * cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT col0 - - 49 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 19 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col1

;

SELECT + 48 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - 78 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + 56 + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 25 FROM tab2 GROUP BY col0

;

SELECT cor0.col0 + 66 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - cor0.col2 + + 5 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 41 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + - col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 48 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING NOT ( NULL ) = NULL
;

SELECT ALL col2 * col2 FROM tab1 GROUP BY col2

;

SELECT tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2 HAVING NOT NULL = NULL
;

SELECT ALL + 21 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2, col1

;

SELECT 38 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 36 + + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - col1 + 25 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - col2 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT + cor0.col2 FROM tab0 cor0 GROUP BY col2, col0

;

SELECT ALL 51 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - + 20 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col1 + + cor0.col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 + 31 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 87 * tab1.col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT col0 * cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 52 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 4 * cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - + col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - + 82 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT 3 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col2 FROM tab1, tab1 cor0 GROUP BY cor0.col2

;

SELECT 56 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col1 * + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 66 + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 49 * - col2 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 51 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 93 * + 71 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + col1 * 69 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ( col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 26 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ( 64 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 58 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + + tab1.col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT 87 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT ALL - cor0.col1 * 46 FROM tab1 cor0 GROUP BY cor0.col0, col1

;

SELECT - 28 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 59 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 50 AS col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - 30 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 27 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 94 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - cor0.col0 + + cor0.col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, col0

;

SELECT cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT 94 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 48 FROM tab1 GROUP BY col1

;

SELECT ALL - 81 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT - - 80 FROM tab2 GROUP BY col0

;

SELECT 45 * - 28 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - 94 FROM tab1 GROUP BY tab1.col1

;

SELECT - cor1.col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT ALL - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + + 41 FROM tab2 GROUP BY col1

;

SELECT - 4 * - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 46 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 92 FROM tab0 AS cor0 GROUP BY col0, cor0.col0

;

SELECT cor0.col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col1, cor0.col0

;

SELECT ALL 59 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 89 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 7 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 82 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 8 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 - 41 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 10 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - 74 AS col0 FROM tab1 GROUP BY col1

;

SELECT + 63 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 90 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col0, col2

;

SELECT DISTINCT 79 + - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - cor0.col1 + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 36 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 3 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + tab1.col2 * - tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT - 29 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - tab1.col2 * col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT ALL 17 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 18 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 8 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 FROM tab0 cor0 GROUP BY col1

;

SELECT + cor0.col2 + - 71 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + cor0.col0 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0, cor1.col2

;

SELECT DISTINCT - + 19 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT + tab1.col0 + 56 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT 31 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + - 26 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + ( - cor0.col1 ) AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + - col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT ALL 44 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col0 + + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col1 FROM tab0 AS cor0 GROUP BY col1 HAVING ( NULL ) IS NOT NULL
;

SELECT col2 AS col1 FROM tab0 WHERE NOT NULL IS NOT NULL GROUP BY tab0.col2

;

SELECT - + col0 * 29 FROM tab0 GROUP BY tab0.col0

;

SELECT 41 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL + 35 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 33 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 64 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 21 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - 91 FROM tab1 GROUP BY tab1.col2

;

SELECT + + 76 FROM tab0 GROUP BY tab0.col1

;

SELECT - col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT 77 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 83 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL NULLIF ( cor0.col0, + cor0.col0 ) FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 3 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 44 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1, cor1.col1

;

SELECT - cor0.col2 + - 45 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 88 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 93 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + 55 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 * - 21 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 90 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + ( + 78 ) FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT 25 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + 94 + 4 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 94 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 14 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - 31 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 87 * + tab0.col0 FROM tab0 GROUP BY col0

;

SELECT ALL col2 + col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL col0 + tab1.col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT - - 80 FROM tab1 GROUP BY tab1.col2

;

SELECT + cor0.col0 * + 94 + + col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + 81 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 - cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col0 AS col1 FROM tab0 cor0 GROUP BY col0

;

SELECT 71 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - - tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - - 73 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 98 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 + - 57 * + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col0, cor0.col2

;

SELECT + 82 - + 16 AS col1 FROM tab1, tab2 AS cor0 GROUP BY tab1.col0

;

SELECT DISTINCT + ( tab2.col1 ) FROM tab2 GROUP BY col1

;

SELECT DISTINCT cor0.col1 * + 55 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 60 * - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + cor0.col2 - 82 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + ( - cor0.col0 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 75 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col1

;

SELECT DISTINCT + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 4 + cor0.col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 98 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT 31 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2, cor1.col0

;

SELECT + col2 + cor0.col0 * cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT DISTINCT - cor0.col2 + col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 90 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - col1 + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 73 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT col1 + - cor0.col1 * - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col2 + + 31 * + 86 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 29 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + ( + 78 ) FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0

;

SELECT ALL + 18 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + + tab1.col2 FROM tab1 GROUP BY col2

;

SELECT cor0.col2 * - cor0.col2 + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 78 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT - cor0.col0 * + cor0.col1 + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + cor0.col1 * col2 AS col0 FROM tab0 AS cor0 GROUP BY col1, col2

;

SELECT cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - 53 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col0 + 78 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - + 48 FROM tab1 GROUP BY tab1.col0

;

SELECT NULLIF ( 82, cor0.col1 / 79 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col2 * cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col0 + - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT cor0.col1 + - 18 FROM tab1 cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT cor0.col1 + + 46 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 32 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 12 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 AS col0 FROM tab1, tab2 cor0 GROUP BY cor0.col2

;

SELECT 45 FROM tab2 AS cor0 GROUP BY cor0.col1, col1

;

SELECT - 23 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT ( 48 ) FROM tab0 GROUP BY col1

;

SELECT ( - 73 ) * 71 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 37 * 61 + + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 54 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 62 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - - 29 AS col0 FROM tab2 GROUP BY col2

;

SELECT 16 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 75 * 45 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 91 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col2 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 90 * 9 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL 26 + 72 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 26 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 32 FROM tab2 cor0 GROUP BY col1

;

SELECT COALESCE ( 48, cor0.col2 ) FROM tab1 cor0 GROUP BY col2

;

SELECT - 70 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 17 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + NULLIF ( col2, cor0.col2 * + cor0.col2 ) AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 52 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT tab2.col1 + + 11 FROM tab2 GROUP BY tab2.col1

;

SELECT 99 * + cor0.col1 AS col0 FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT + ( - 30 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - + 2 AS col1 FROM tab1 GROUP BY col0

;

SELECT - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, col0

;

SELECT DISTINCT + 82 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + 91 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + col1 + - 38 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - - 39 AS col1 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 6 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 85 + + 11 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 60 AS col0 FROM tab0 GROUP BY col2

;

SELECT + 67 - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 + + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT DISTINCT 62 * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT + col0 * + col0 + - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT 27 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 61 * + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 35 FROM tab1 GROUP BY col2

;

SELECT cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL + col0 + + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - - 37 FROM tab0 GROUP BY col0

;

SELECT 6 FROM tab2 GROUP BY col0

;

SELECT DISTINCT 36 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT ALL + 58 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 72 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + 84 * 75 FROM tab1, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + 36 FROM tab1 GROUP BY tab1.col0

;

SELECT - - tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - - 19 FROM tab1 GROUP BY tab1.col1

;

SELECT - - 67 * tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - cor0.col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 73 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 44 + tab0.col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT ALL 46 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 * + 5 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 23 FROM tab1 GROUP BY col1

;

SELECT - 61 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + cor0.col2 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - + tab0.col1 * - 29 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col2 * - col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - col1 + 59 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + ( + 5 ) AS col1 FROM tab0 GROUP BY col2

;

SELECT ALL - 31 AS col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT ALL 31 FROM tab2 GROUP BY col2

;

SELECT 88 FROM tab2 GROUP BY tab2.col0

;

SELECT - NULLIF ( - tab0.col2, tab0.col2 ) + + 16 FROM tab0 GROUP BY tab0.col2

;

SELECT + 19 * cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 91 AS col1 FROM tab2 GROUP BY col0

;

SELECT + 8 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 45 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col0, cor0.col0

;

SELECT - + 46 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 87 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col1 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT - ( - 32 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - + tab0.col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT - 31 + - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 71 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + tab0.col0 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT - col0 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 * cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col2 HAVING NULL IS NULL
;

SELECT cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT cor0.col0 * - 80 FROM tab0 cor0 GROUP BY col0

;

SELECT cor0.col1 * + 53 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL 85 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT - 23 + 42 FROM tab2 AS cor0 GROUP BY col2

;

SELECT cor0.col2 + + 45 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT ( - cor0.col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 64 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL 38 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 82 AS col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT ALL - 15 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 49 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + cor0.col2 * - cor0.col0 + - 56 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 * col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 80 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col2

;

SELECT 56 * + cor0.col2 + - 18 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - + col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + 75 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 52 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 56 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT ALL 44 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor1.col0 FROM tab1 cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT + cor0.col2 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT cor0.col2 + - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 37 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 93 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 3 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL - cor0.col0 * col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col2

;

SELECT cor0.col2 * - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - cor0.col2 - cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 29 AS col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + 22 AS col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 40 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + tab0.col1 + + 85 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 96 * cor1.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col1

;

SELECT DISTINCT ( - 54 ) AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 85 AS col2 FROM tab1 cor0 GROUP BY col2, cor0.col0

;

SELECT 73 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT + ( + cor0.col1 ) * 2 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 50 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 98 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT 51 - - tab0.col1 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT ( 55 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + 42 AS col2 FROM tab0 cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col2

;

SELECT ALL - ( + cor0.col2 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 70 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - - tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - + 64 FROM tab2, tab1 AS cor0 GROUP BY tab2.col1

;

SELECT + 86 FROM tab2 GROUP BY tab2.col2

;

SELECT + 19 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT - cor0.col0 * + NULLIF ( + 71, cor0.col0 ) + 37 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 21 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL - 84 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 62 FROM tab1 GROUP BY tab1.col1

;

SELECT ( cor0.col1 ) * cor0.col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 89 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL + cor0.col1 * 72 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 77 * + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL tab2.col1 FROM tab2 GROUP BY col1

;

SELECT cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col0

;

SELECT ALL - cor0.col2 + - 59 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - - COALESCE ( - 76, - tab0.col0 - + 58 ) FROM tab0 GROUP BY tab0.col0

;

SELECT + 61 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 49 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 27 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 76 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 49 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 6 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + 29 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 56 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 * 9 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 78 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 32 * cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 65 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 * + 9 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 19 + col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 89 FROM tab0 GROUP BY tab0.col1

;

SELECT + 47 * cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0 HAVING cor0.col0 IS NULL AND NOT NULL NOT BETWEEN NULL AND NULL
;

SELECT DISTINCT col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT - 0 AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 0 FROM tab0 GROUP BY tab0.col0

;

SELECT + 90 - + tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col2 * + 41 + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + ( cor0.col0 ) AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - ( tab2.col0 ) + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 76 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col0 FROM tab0 cor0 GROUP BY col0

;

SELECT 19 FROM tab0 cor0 GROUP BY col0

;

SELECT 8 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 9 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col0

;

SELECT DISTINCT - col0 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT col1 * + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + 64 + + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL - 94 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 + - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT COALESCE ( - COALESCE ( cor0.col0, cor0.col0 ), - 80 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 63 - col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col0 + cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1, col1

;

SELECT + col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - 70 - 74 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - 91 + - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 5 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL 0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - + col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, col2

;

SELECT cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col0, col2, cor0.col0

;

SELECT 64 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + tab1.col1 + + col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL cor0.col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2, cor0.col2

;

SELECT DISTINCT - ( cor0.col2 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 88 * 31 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 57 * cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab0.col2 * tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - 55 FROM tab1 GROUP BY col0

;

SELECT + 16 * - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 79 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 63 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 12 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 26 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 36 FROM tab2 GROUP BY tab2.col1

;

SELECT + NULLIF ( + 9, + cor0.col2 + col2 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * + 97 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 76 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 - + cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ( cor0.col0 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col2 * 39 + - 58 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + - tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT DISTINCT 51 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + col1 + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 24 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col0, cor0.col1

;

SELECT DISTINCT 71 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 92 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col0 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 90 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col0 * 76 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - - 29 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor1.col2 AS col2 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT + 59 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 13 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 + + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 61 + - 52 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT NULLIF ( - col1, cor0.col1 + + cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 70 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + 79 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT DISTINCT - 76 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col0, cor0.col2

;

SELECT DISTINCT - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 44 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 - - 32 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 36 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 69 + - col2 * cor0.col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL + col1 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 9 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - - 91 FROM tab2 GROUP BY tab2.col2

;

SELECT + 31 * - cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL 60 + + tab1.col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT ALL - 65 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + 65 * - col0 + 73 FROM tab2 GROUP BY col0

;

SELECT col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT DISTINCT cor0.col2 * + 88 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor1.col2 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT ALL 23 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 3 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 + - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 62 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - - 98 FROM tab1 GROUP BY tab1.col2

;

SELECT + 10 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col0 + - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + cor0.col1 + + 11 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col0 * + 71 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 45 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 87 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col1 + - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + 66 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 62 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + 50 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 12 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 24 * 52 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL 45 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT + cor0.col2 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL 80 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + cor0.col1 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col1 - - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT col1 * 46 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT 99 FROM tab0 cor0 GROUP BY col2, cor0.col2, cor0.col2

;

SELECT DISTINCT + 97 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL tab1.col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT cor0.col0 + - cor0.col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT ( col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 99 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col1 + + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + - 39 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 80 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 66 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 + + cor0.col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT + 54 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ( cor1.col1 ) AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT ( + cor0.col1 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 53 FROM tab1 GROUP BY tab1.col1

;

SELECT - 50 + - tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 25 FROM tab0, tab0 AS cor0 GROUP BY tab0.col1

;

SELECT DISTINCT 82 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2

;

SELECT ALL - cor0.col2 - - 51 AS col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL - 44 * col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col0 + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col1 + col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT cor0.col2 + + 26 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 62 + + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + ( 76 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 13 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + col0 FROM tab0 GROUP BY col0

;

SELECT cor0.col2 + - cor0.col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL cor0.col2 * + 81 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + cor0.col0 * - CASE + cor0.col1 WHEN cor0.col2 THEN cor0.col2 WHEN cor0.col2 / cor0.col2 THEN + cor0.col2 END FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT DISTINCT - cor0.col1 * NULLIF ( 64, col1 * cor0.col0 + cor0.col0 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + cor0.col1 + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT ALL 3 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 69 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 82 + 16 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - col2 AS col1 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT + col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT - cor0.col2 - - col2 AS col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL 88 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT - cor0.col0 * - 96 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL cor0.col2 + + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col2 + - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col2 / col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT ( NULL ) IS NULL
;

SELECT ALL - + 51 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - 45 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 50 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT + + 41 AS col2 FROM tab0 GROUP BY col1

;

SELECT + ( - 57 ) FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + 17 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 56 + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT + - 95 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + + 58 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - cor0.col0 FROM tab0 cor0 GROUP BY col0

;

SELECT 87 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - 90 AS col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + + tab1.col1 + tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT cor0.col1 * 96 + col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + ( 57 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 86 FROM tab2, tab2 AS cor0 GROUP BY tab2.col1

;

SELECT DISTINCT - - tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col0 * cor0.col0 + + ( - col0 ) FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + 87 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + cor0.col0 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 * cor0.col0 + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 + + cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT - cor0.col2 + + cor0.col1 * + 25 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT cor0.col2 * - 81 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 * 21 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL 3 AS col0 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT ( - cor0.col0 ) AS col1 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT - 41 + + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - 30 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 38 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 AS col1 FROM tab1 cor0 GROUP BY col0, cor0.col0

;

SELECT - tab0.col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT ALL + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT ( NULL ) IS NOT NULL
;

SELECT + + 3 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT COALESCE ( cor0.col2, cor0.col2 ) * 14 + 36 * - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col1 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + ( + 48 ) FROM tab1 GROUP BY col0

;

SELECT ALL + cor0.col2 * ( + cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 35 + - 24 * - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 8 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT + col2 AS col2 FROM tab0 cor0 GROUP BY col2

;

SELECT 37 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 84 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor0.col0

;

SELECT DISTINCT - cor0.col1 * + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT + ( 11 ) AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 12 * + 49 FROM tab2 GROUP BY col1

;

SELECT - ( cor0.col0 ) + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + 2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 + cor0.col2 * 58 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 53 + col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 76 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1, cor1.col2

;

SELECT - 28 FROM tab0 GROUP BY tab0.col2

;

SELECT + 67 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ALL + + tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT cor0.col0 - cor0.col0 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col2 * 80 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 * - cor0.col0 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT 73 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 95 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col1 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - - 51 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - - 60 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 36 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 21 + - cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 94 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 85 * - 97 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 27 + + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + 15 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT col0 + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 + + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - cor0.col0 * - cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 23 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 89 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 70 + 53 FROM tab2 cor0 GROUP BY col2, cor0.col1

;

SELECT + 12 * + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + - 72 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT 4 FROM tab0 AS cor0 GROUP BY col1

;

SELECT cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT ALL - - 98 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 50 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 32 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL 71 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 60 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL cor0.col0 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT 15 * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * cor0.col0 + + cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 6 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col1, cor0.col2

;

SELECT ALL + 7 + 81 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col0

;

SELECT + cor0.col0 + + 52 FROM tab0 AS cor0 GROUP BY col0

;

SELECT cor0.col0 AS col0 FROM tab1 cor0 GROUP BY col0

;

SELECT - ( + col1 ) FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 46 * 65 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 * - 47 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 28 AS col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT 15 * - 66 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - 34 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL col2 - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 92 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 86 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT NULLIF ( 59, - cor0.col2 ) FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col1 + + cor0.col1 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + cor0.col2 - - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + + 96 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT cor0.col1 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 98 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 * cor0.col1 FROM tab1 AS cor0 WHERE NOT ( NULL ) IN ( cor0.col0 + cor0.col2 ) GROUP BY cor0.col1

;

SELECT - cor0.col1 * + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NOT NULL
;

SELECT ALL tab0.col0 * tab0.col0 FROM tab0 GROUP BY col0

;

SELECT + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col1 + - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT DISTINCT + cor0.col2 * 72 FROM tab2 AS cor0 GROUP BY col2

;

SELECT cor0.col1 - - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col1, col1, cor0.col2

;

SELECT DISTINCT + + tab2.col2 * col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL <= cor0.col1
;

SELECT + ( 84 ) FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 80 * + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 9 FROM tab1 GROUP BY tab1.col0

;

SELECT - + col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - col1 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col1

;

SELECT DISTINCT cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, col2

;

SELECT - 57 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - - 51 FROM tab0 GROUP BY tab0.col0

;

SELECT + + tab0.col1 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + + 58 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 49 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 15 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT - cor1.col1 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT - tab1.col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - + col1 FROM tab2 GROUP BY tab2.col1

;

SELECT 0 * cor0.col0 + + 72 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 41 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + cor0.col2 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT + 57 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 68 + + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT 37 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 42 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 90 AS col0 FROM tab2 GROUP BY col2

;

SELECT + 56 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NULL IS NOT NULL
;

SELECT DISTINCT cor0.col1 FROM tab2, tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - col1 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 79 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 + 26 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col1 * cor0.col1 + 11 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 59 AS col2 FROM tab1, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 25 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + ( 78 ) AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT 87 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + cor0.col1 * + 15 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 67 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 77 FROM tab1, tab1 AS cor0 GROUP BY tab1.col0

;

SELECT + cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT - ( 22 * + cor0.col0 ) FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 47 - - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT * FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT DISTINCT + 84 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 72 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 60 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - ( + 74 ) AS col1 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 43 AS col2 FROM tab2, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - tab1.col1 FROM tab1 GROUP BY col1

;

SELECT - ( - ( cor0.col0 ) ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col0, cor0.col2

;

SELECT + - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + - cor0.col0 AS col2 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 AS col2 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 29 FROM tab0, tab1 AS cor0 GROUP BY tab0.col2

;

SELECT + 27 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 62 FROM tab2 AS cor0 GROUP BY col0

;

SELECT 47 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 86 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - cor0.col2 * + ( 82 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT cor1.col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT + + 99 * - 46 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT + 53 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 14 * - 96 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 79 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - ( + cor0.col0 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col2 + 95 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 48 + cor0.col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - 54 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 AS col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 16 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT 0 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + 95 + 62 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - 65 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, col0

;

SELECT - tab0.col1 * - ( + tab0.col1 ) AS col1 FROM tab0 GROUP BY col1

;

SELECT 42 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT 68 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 63 AS col2 FROM tab1 GROUP BY col1

;

SELECT 9 * + 4 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 41 + 54 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col2

;

SELECT DISTINCT + tab1.col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT col0 - - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 87 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT ( 60 ) FROM tab2 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + col0 FROM tab0 GROUP BY tab0.col0 HAVING NULL <= ( NULL )
;

SELECT DISTINCT + cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col2

;

SELECT cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT 52 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT cor0.col2 AS col1 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 62 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT col0 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT + 72 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 45 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 + 30 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - cor0.col2 AS col0 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 * 2 + + col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 3 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - cor0.col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + ( - cor0.col1 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 23 FROM tab1, tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT * FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT - cor0.col0 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL + 59 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - col2 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT cor0.col0 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - 27 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 79 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT col1 * ( col1 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - + ( 2 ) AS col1 FROM tab0, tab1 AS cor0 GROUP BY tab0.col2

;

SELECT + ( + col0 ) FROM tab0 GROUP BY tab0.col0

;

SELECT - 13 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 8 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col0

;

SELECT DISTINCT - 37 FROM tab1 GROUP BY col2

;

SELECT col0 * cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT 20 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT - 39 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 4 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 98 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL - 13 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL 54 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 15 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 76 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT col2 * 11 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + - 87 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 1 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - col0 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ( + 48 ) AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 69 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor1.col2 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + 58 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + col1 * - cor0.col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT + cor0.col2 * - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL + cor0.col2 * - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 * 47 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 50 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 38 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT DISTINCT - 62 FROM tab2 GROUP BY col2

;

SELECT - + 36 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - 60 * - 84 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - - 18 * - tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 75 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT NULLIF ( 97, cor0.col1 ) AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT + 33 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + 85 - - 56 AS col0 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 97 + + 90 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 31 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 + col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col2, cor0.col2

;

SELECT - 52 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 7 FROM tab1 GROUP BY col1

;

SELECT + cor0.col2 * - col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL cor0.col2 + col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - cor0.col2 * + 40 + - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 40 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 52 AS col2 FROM tab2 GROUP BY col0

;

SELECT ALL + + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - col0 * + 92 - - cor0.col0 * + 34 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL 94 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - cor0.col2 * - 3 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + - 99 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 81 + - 98 * - 65 AS col2 FROM tab1 GROUP BY col1

;

SELECT DISTINCT ( cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 25 * + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + ( cor0.col2 ) AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 2 + - cor0.col1 * + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 92 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT cor0.col0 * + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col0, col2

;

SELECT ALL 95 * 10 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 69 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 72 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL 92 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + 91 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 49 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + cor0.col0 * 72 + - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 65 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT + + col2 * + tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col2 FROM tab0 cor0 GROUP BY col0, cor0.col2, cor0.col0

;

SELECT ALL 83 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ( 3 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 64 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 34 * - 0 FROM tab2 GROUP BY tab2.col1

;

SELECT + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col1

;

SELECT - col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 86 FROM tab1 GROUP BY col1

;

SELECT + 51 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col1 FROM tab2 cor0 GROUP BY cor0.col0, col1

;

SELECT ALL + - 17 AS col1 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + tab0.col2 * - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col1 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL >= NULL
;

SELECT tab1.col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT cor0.col2 + - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - 80 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL + 62 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + 37 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col1 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL + 49 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + - 92 * tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + 89 FROM tab2 GROUP BY tab2.col1

;

SELECT + 67 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col0 + - 14 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0, col1

;

SELECT cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, col1, cor0.col1

;

SELECT DISTINCT 16 * + 72 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 * cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col1 + 14 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 + 62 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - 32 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 82 - 99 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 * - col2 + + cor0.col2 * 26 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 64 * - cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL 28 FROM tab0 cor0 GROUP BY cor0.col2, col0, col0

;

SELECT ALL 44 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - - 58 FROM tab1, tab1 AS cor0 GROUP BY tab1.col1

;

SELECT ( 2 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 92 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - CASE 1 WHEN - cor0.col1 THEN col1 * - col1 + + cor0.col0 END * cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 66 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 39 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + 59 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 27 * - 48 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT 64 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 58 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 8 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT tab2.col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + cor0.col0 + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 2 * cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col0 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col2 + 2 * + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, col0

;

SELECT - 49 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 84 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 69 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 52 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL + 75 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ( + cor0.col2 ) * cor0.col2 - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 69 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 18 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL col2 * - ( cor0.col2 ) FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT + col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 93 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 8 * - 93 FROM tab0 AS cor0 GROUP BY col1

;

SELECT col0 AS col2 FROM tab1 WHERE NULL IS NOT NULL GROUP BY tab1.col0

;

SELECT 79 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL + tab2.col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT DISTINCT ( - col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col2

;

SELECT - cor0.col0 + col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT ALL 47 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT ALL cor0.col2 + 93 AS col2 FROM tab0 cor0 GROUP BY col2

;

SELECT - 24 * 6 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 * 36 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT ( + 29 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor1.col2 * - cor1.col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor1.col1

;

SELECT + 77 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 90 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 2 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT 64 + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT 54 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY col0, cor0.col2, cor0.col1, cor0.col1

;

SELECT DISTINCT + 27 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT + 51 * 2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT ALL 63 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 66 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 - 50 * - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col2 * ( 99 ) FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * + 90 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 * + cor0.col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 6 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT ALL 69 * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 95 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL 64 * cor0.col1 + - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - col1 + + cor0.col1 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL + 89 FROM tab1 cor0 GROUP BY col1

;

SELECT ALL 35 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT cor0.col1 * + 87 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT 22 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 63 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 * cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + 42 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 46 + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 72 AS col1 FROM tab0 AS cor0 GROUP BY col2, cor0.col2

;

SELECT - 15 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT col1 * - cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 0 * col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 99 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col2

;

SELECT cor0.col1 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 28 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col1 + - 85 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 66 FROM tab2 GROUP BY col2

;

SELECT ALL - 11 FROM tab0 GROUP BY tab0.col1

;

SELECT tab1.col2 - + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col2 + col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 52 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT 67 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 41 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 46 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL - + 19 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 46 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - COALESCE ( - cor0.col1, cor0.col1 + + cor0.col0 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 66 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL tab1.col2 * - tab1.col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + 60 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 5 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 * + ( - 56 ) - 24 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT ( - 42 ) AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 15 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col1 + cor0.col0 * - 3 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT 2 FROM tab1 GROUP BY tab1.col0

;

SELECT + col1 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT - ( cor0.col0 ) + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 47 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - cor0.col2 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col2 * - cor0.col2 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL cor0.col0 * col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + cor0.col1 + + col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col0 + + 28 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - - col0 * 66 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col1 + col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 + - 57 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT - tab1.col2 + + tab1.col2 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col0 + cor0.col0 * 2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col2 + + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - ( 19 ) FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT 25 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - - tab0.col2 FROM tab0 GROUP BY col2

;

SELECT ALL ( - 34 ) FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + ( + 30 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - + col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - 35 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 8 + cor0.col1 * cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT cor0.col1 + 74 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + cor0.col0 + + cor0.col0 * 12 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 6 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 * cor0.col2 FROM tab1 cor0 GROUP BY col0, col2, cor0.col1

;

SELECT + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col1 + - 18 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + 75 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - tab2.col0 AS col1 FROM tab2 GROUP BY col0

;

SELECT 62 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 24 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 48 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - 47 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + 69 + 33 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 64 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 28 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - - 71 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - tab2.col0 + - 14 FROM tab2 GROUP BY col0

;

SELECT ALL + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT + 62 + - 46 FROM tab2 GROUP BY col2

;

SELECT cor0.col2 AS col1 FROM tab1 cor0 GROUP BY col2, cor0.col0

;

SELECT ALL + 82 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 26 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT 52 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - col2 + 48 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT ALL - cor0.col2 * - cor0.col2 + - 51 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 30 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 81 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab0.col1 * + tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL col2 - - 50 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 + - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 44 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 1 + + tab1.col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 60 * + col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - - 79 AS col1 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 91 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col1 FROM tab0 AS cor0 GROUP BY col1 HAVING NOT NULL IS NULL
;

SELECT ALL 88 * 77 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 37 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - 33 * + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 45 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col2 FROM tab2 cor0 GROUP BY cor0.col1, col1, cor0.col2

;

SELECT DISTINCT cor0.col1 * + cor0.col1 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ( - col1 ) AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL - 59 AS col1 FROM tab0 GROUP BY col2

;

SELECT + 84 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 50 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + - 6 FROM tab2 GROUP BY col0

;

SELECT ALL ( + 51 ) AS col2 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL + 65 FROM tab0 GROUP BY tab0.col1

;

SELECT NULLIF ( 50, - col1 ) FROM tab2 GROUP BY tab2.col1

;

SELECT col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 37 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor1.col1

;

SELECT DISTINCT + 52 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + 16 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - ( + 72 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + tab1.col0 FROM tab1 GROUP BY tab1.col0 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT 15 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - - 96 FROM tab1 GROUP BY col2

;

SELECT DISTINCT 12 AS col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - 63 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col2 * + ( + cor0.col2 ) AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT cor0.col2 - - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + cor0.col0 - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT cor0.col2 + - 38 AS col1 FROM tab0 cor0 GROUP BY col2

;

SELECT ALL col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT col2 * + ( - cor0.col2 * cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 80 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL NULLIF ( 10, cor0.col0 ) * cor0.col0 + - col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT COALESCE ( + 87, - cor0.col1 + + cor0.col1 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - - tab2.col1 FROM tab2 GROUP BY col1

;

SELECT - 44 - col1 AS col1 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL - col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 72 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 16 FROM tab1 GROUP BY col1

;

SELECT DISTINCT + 55 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + col2 * - 46 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL col2 - cor0.col2 * - col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 * - 87 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL cor0.col2 * + col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - 96 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + 89 * cor0.col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL - 17 * + tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 78 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 92 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - col1 * - col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - cor0.col2 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 56 FROM tab1 cor0 GROUP BY col0

;

SELECT tab0.col0 + - tab0.col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT ALL - + 23 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 24 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 * + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 74 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + 65 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 3 FROM tab1 GROUP BY tab1.col1

;

SELECT - 65 + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 39 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 94 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT + 44 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT 57 FROM tab1 GROUP BY col1

;

SELECT 38 FROM tab0 GROUP BY col1

;

SELECT ALL + 38 * - cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + 56 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - 26 FROM tab0 AS cor0 GROUP BY col0, cor0.col0

;

SELECT 72 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 68 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 53 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - 60 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 3 + col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 34 FROM tab1 GROUP BY tab1.col1

;

SELECT - col2 + - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 64 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL 17 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 38 * - 64 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT - 58 FROM tab0 GROUP BY tab0.col0

;

SELECT + + 0 * - col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT ALL 15 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 36 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT + - ( + 96 ) FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - 59 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - cor0.col2 + + cor0.col2 * cor0.col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col0, col2

;

SELECT 25 + 12 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 60 FROM tab2 AS cor0 GROUP BY col0

;

SELECT tab0.col2 * 96 FROM tab0 GROUP BY tab0.col2

;

SELECT + 68 * cor1.col1 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT 93 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 * + 61 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + COALESCE ( - cor0.col2, + cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 99 * col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, col2

;

SELECT col1 + + tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - tab1.col2 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL >= ( NULL )
;

SELECT DISTINCT - + tab0.col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + 58 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT - 50 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL + cor0.col2 - + cor0.col2 AS col1 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT + 95 + + 43 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL col1 FROM tab2 GROUP BY col1

;

SELECT + tab2.col0 - ( 66 ) AS col0 FROM tab2 GROUP BY col0

;

SELECT + cor0.col1 * 58 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - col0 * + 49 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + ( cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col0 * 28 + 71 * cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL cor0.col2 AS col1 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col2 * - cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - col1 AS col1 FROM tab0 cor0 GROUP BY col1

;

SELECT - 64 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT 43 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + + 89 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + - 83 FROM tab2 GROUP BY tab2.col2

;

SELECT - - col1 FROM tab1 GROUP BY col1

;

SELECT cor0.col0 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 * 71 + + 84 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT DISTINCT - 74 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + - 1 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 67 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 40 FROM tab2 AS cor0 GROUP BY col0

;

SELECT cor0.col2 FROM tab1 AS cor0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT + cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor1.col2

;

SELECT - col2 * cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 + + 85 FROM tab0 cor0 GROUP BY col2, cor0.col0

;

SELECT ALL - 29 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + 29 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL 18 - 81 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT 9 FROM tab2 GROUP BY col1

;

SELECT ALL 14 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT + 5 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 79 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL 90 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 87 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 19 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT 84 FROM tab1 GROUP BY tab1.col2

;

SELECT 46 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 * 48 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 + + 57 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + tab0.col2 * - 10 FROM tab0 GROUP BY tab0.col2

;

SELECT - cor0.col0 * + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT + cor0.col2 + cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL + cor0.col1 + cor0.col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 92 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 81 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 * - 50 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 * ( 94 ) FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT cor0.col1 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col0, cor0.col1

;

SELECT - cor1.col1 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor1.col1

;

SELECT 96 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 * + cor0.col2 + - cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + 86 + - 94 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 18 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT tab1.col1 + + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 92 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 92 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - ( + 51 ) AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2 HAVING NOT ( NULL ) <= NULL AND NULL > NULL
;

SELECT DISTINCT cor0.col1 AS col0 FROM tab0 cor0 GROUP BY col1

;

SELECT + cor0.col0 * cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + col0 FROM tab1 GROUP BY tab1.col0 HAVING NOT NULL IS NULL
;

SELECT - 14 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 5 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col2 * 47 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 81 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - cor0.col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + 16 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 15 - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 38 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + - 77 FROM tab2 GROUP BY col0

;

SELECT ALL col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col2 * + col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col2 * cor0.col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 73 + + cor0.col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT ALL + + 53 AS col2 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col0 + - 42 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 85 FROM tab2 GROUP BY tab2.col2

;

SELECT + ( 82 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col2 + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 68 + + 90 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT ALL - 28 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT 86 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL 97 * - 58 + + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col0 * - 42 - + 72 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col2 * 84 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 94 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - 87 * - cor0.col2 + - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 33 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - 86 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 78 * 78 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 + + cor0.col2 FROM tab0 cor0 GROUP BY col2, cor0.col1

;

SELECT ALL 37 FROM tab0 cor0 GROUP BY col1

;

SELECT - col2 + cor0.col2 * 77 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 48 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 84 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + 82 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + tab0.col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT ALL + 60 FROM tab1 GROUP BY col1

;

SELECT + + 5 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - - 44 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 27 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT tab1.col2 * 39 + + 61 FROM tab1 GROUP BY col2

;

SELECT + + 20 AS col0 FROM tab2, tab1 cor0 GROUP BY cor0.col2

;

SELECT + 67 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 3 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT - 36 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 50 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT + 70 AS col2 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - 60 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - 33 * cor0.col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL - 93 - col0 FROM tab2 GROUP BY tab2.col0

;

SELECT 0 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT 29 + cor0.col0 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT col1 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 41 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 29 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT 57 + + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 16 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 75 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + col0 FROM tab2 GROUP BY tab2.col0 HAVING NOT NULL IS NOT NULL
;

SELECT col0 * col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT 13 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - - 99 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 * + col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL 40 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 10 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + 68 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + 26 + cor0.col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 26 FROM tab0 GROUP BY col1

;

SELECT + cor0.col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 99 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 8 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT col2 + - cor0.col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col2 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col1 + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col2 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 41 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 61 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 56 FROM tab2 GROUP BY tab2.col0

;

SELECT 51 AS col0 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1, cor1.col1

;

SELECT DISTINCT - 63 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL 10 - - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 21 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT - 17 + + cor0.col1 * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - ( - cor0.col1 ) * cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 97 FROM tab2 GROUP BY col2

;

SELECT DISTINCT + 33 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - 36 * + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - CASE cor0.col1 WHEN + cor0.col1 + - 20 * 44 THEN NULL WHEN 62 * + cor0.col2 THEN cor0.col1 + cor0.col1 * + cor0.col2 END / - 81 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - cor0.col2 + cor0.col2 FROM tab0 cor0 GROUP BY col2

;

SELECT cor0.col2 * + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - tab0.col2 * + tab0.col2 - + 40 AS col0 FROM tab0 GROUP BY col2

;

SELECT NULLIF ( - cor0.col2, - cor0.col0 * cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + - 14 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 17 AS col0 FROM tab2 GROUP BY col0

;

SELECT ALL - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 87 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 59 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - 75 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 92 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col1 * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 20 * - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 98 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ( - 56 ) FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL 80 + 13 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, col2

;

SELECT 83 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + ( + 10 ) FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT 56 FROM tab2 GROUP BY col2

;

SELECT - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + tab2.col1 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL - NULLIF ( - tab2.col1, 39 ) AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT ALL cor0.col1 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - cor0.col2 * - col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col0

;

SELECT - 72 FROM tab0 GROUP BY col1

;

SELECT + col0 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT col0 * 66 - 98 FROM tab1 GROUP BY col0

;

SELECT - cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 62 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 18 * - 85 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - 42 AS col2 FROM tab0 cor0 GROUP BY col1

;

SELECT 34 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 68 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - 14 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + 85 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT + 98 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ( + 89 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - col1 AS col2 FROM tab0 GROUP BY col1

;

SELECT 17 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - + 77 FROM tab0 GROUP BY col2

;

SELECT - 36 * - 26 + cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col0 FROM tab0 cor0 GROUP BY col0, cor0.col2

;

SELECT ALL + 37 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col0 * cor0.col0 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 92 + - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT DISTINCT + 67 + cor0.col2 * 6 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 63 AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 72 + 51 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + 57 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 97 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col1 + + cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 28 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 18 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor1.col0 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - 72 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + - tab1.col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT cor0.col2 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL tab2.col2 AS col1 FROM tab2 GROUP BY col2 HAVING NOT NULL IS NULL
;

SELECT DISTINCT 30 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 45 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 72 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 50 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT 91 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL - 81 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + tab1.col1 - 85 FROM tab1 GROUP BY col1

;

SELECT ALL - tab1.col2 * - 11 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col2 * 82 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - cor0.col1 * col1 + 9 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT ALL - 32 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 37 * col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 35 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 38 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col1 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 99 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT + 23 * - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - col2 * col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 27 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 - - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - - cor0.col0 - 64 FROM tab1, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 * - col2 + 77 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 47 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT - COALESCE ( 15, + cor0.col0, 29 + + cor0.col0 ) + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 83 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 * + 2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 33 + - 16 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + 79 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT + 24 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + cor0.col0 + 29 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 76 FROM tab2 GROUP BY tab2.col0

;

SELECT + 98 * - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 + - col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + + 48 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + 36 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 53 + 99 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 36 - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 5 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 82 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT - 44 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 34 FROM tab2 GROUP BY col0

;

SELECT ALL - COALESCE ( + cor0.col1, - cor0.col1 + col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 62 + + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 41 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 48 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 75 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - + 80 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - 99 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 35 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 62 + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 67 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col1 + col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 11 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - NULLIF ( cor0.col0, cor0.col0 ) + 11 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 34 FROM tab2 GROUP BY tab2.col2

;

SELECT 10 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col0 + - cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL 2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 91 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2

;

SELECT cor0.col1 * + 89 + 53 FROM tab0 cor0 GROUP BY col1

;

SELECT ALL 46 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 72 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - cor0.col0 * cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2 HAVING NOT NULL > col2
;

SELECT tab2.col1 FROM tab2 GROUP BY tab2.col1 HAVING ( NULL ) IS NOT NULL
;

SELECT + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1 HAVING NULL IS NOT NULL
;

SELECT ALL - col0 + tab0.col0 AS col1 FROM tab0 GROUP BY col0

;

SELECT DISTINCT 9 * cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - 9 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL cor0.col0 + + ( 68 ) FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - + col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - + tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 12 + 9 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 60 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL ( 83 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 54 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ( cor0.col2 ) * - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL ( cor0.col0 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 13 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - 30 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * - cor0.col0 + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL cor0.col0 + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - ( + 69 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 4 AS col0 FROM tab1 cor0 GROUP BY col1

;

SELECT ALL cor0.col0 FROM tab1, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 59 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - cor0.col1 * - 48 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL 1 + 27 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + + 21 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + 41 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 48 + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 68 * 32 - col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * + 87 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 74 * + cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 93 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, col1

;

SELECT 25 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 2 * tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - 4 + - cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - - 41 * + tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT - 89 FROM tab1, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col2 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 80 AS col1 FROM tab2 GROUP BY col0

;

SELECT DISTINCT - 66 + tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + - 31 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 75 AS col0 FROM tab1 cor0 GROUP BY col2

;

SELECT + 8 * + tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 24 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + 19 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT DISTINCT 90 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col1, cor0.col0

;

SELECT DISTINCT 13 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT COALESCE ( - cor0.col2, cor0.col2 ) AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT ( - 63 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 92 * + 89 FROM tab0 GROUP BY tab0.col1

;

SELECT + col2 * ( 83 ) AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 54 * + tab2.col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - 61 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 64 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 30 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 18 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 11 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 * cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, col1

;

SELECT - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + + tab2.col2 FROM tab2 GROUP BY col2

;

SELECT ALL - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - cor0.col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 16 AS col2 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT ALL col0 * 39 - + col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT 73 AS col1 FROM tab0 GROUP BY col2

;

SELECT ALL cor0.col0 + 75 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col1

;

SELECT DISTINCT 70 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 21 + + 86 AS col0 FROM tab1 GROUP BY col1

;

SELECT ALL cor0.col1 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - 92 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor1.col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor1.col0

;

SELECT ALL 1 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col2 * 32 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT ALL 44 + - 84 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + 85 * COALESCE ( cor0.col1, cor0.col1 ) FROM tab2 AS cor0 GROUP BY col1

;

SELECT + col1 AS col0 FROM tab1 cor0 GROUP BY col1

;

SELECT NULLIF ( cor0.col1, cor0.col1 * 4 + - col1 ) * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT DISTINCT + + 52 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - cor1.col2 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1, cor1.col2

;

SELECT + 43 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + col1 AS col0 FROM tab1 AS cor0 WHERE ( NULL ) IN ( + cor0.col0 * cor0.col2 ) OR ( NULL ) IS NOT NULL GROUP BY cor0.col1 HAVING NOT NULL IS NULL
;

SELECT 82 FROM tab1, tab0 AS cor0 GROUP BY tab1.col1

;

SELECT tab2.col2 AS col2 FROM tab2 WHERE NOT NULL NOT BETWEEN NULL AND col1 GROUP BY col2

;

SELECT col2 * + cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab0 GROUP BY cor0.col1 HAVING NOT NULL > NULL
;

SELECT 55 * - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT + cor0.col0 * 33 - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 61 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 23 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + col0 + - 68 AS col0 FROM tab1 GROUP BY col0

;

SELECT ALL 13 + + 10 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + 80 - - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col2 * + 77 FROM tab2 GROUP BY col2

;

SELECT ALL cor0.col0 * - 55 + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - 37 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT 68 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 89 FROM tab0 GROUP BY tab0.col2

;

SELECT + 49 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - 0 - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT 14 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ( 91 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( - 11 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 41 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 * cor0.col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 58 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col1 - - 32 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + col2 FROM tab1 GROUP BY tab1.col2

;

SELECT + - col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + + 18 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 8 * + cor0.col2 + cor0.col0 FROM tab2 cor0 GROUP BY col2, cor0.col0

;

SELECT ALL 48 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 94 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 71 * - col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - cor0.col0 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + 92 * + 24 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 * 97 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ( + cor0.col0 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col1 * - cor0.col1 + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 15 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 54 FROM tab0 GROUP BY col2

;

SELECT + 47 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, col1

;

SELECT - + 94 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - + 73 FROM tab1, tab0 cor0 GROUP BY tab1.col2

;

SELECT DISTINCT 87 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - 2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - 50 * - tab1.col1 AS col1 FROM tab1 GROUP BY col1

;

SELECT cor0.col1 - 77 * 0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 64 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + 99 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ( 79 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col1 + 42 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor1.col0 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT - ( 0 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 34 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - tab1.col1 * + tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - cor0.col1 FROM tab1 cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col1 + cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col1 * + 15 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 17 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT ALL + 94 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 97 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT ALL - 58 * + 79 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT 39 FROM tab0 AS cor0 GROUP BY col0, cor0.col2, cor0.col2

;

SELECT + 46 FROM tab0 cor0 GROUP BY col1

;

SELECT ALL cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT - cor0.col2 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + + 92 FROM tab0 GROUP BY tab0.col2

;

SELECT + cor0.col1 * - cor0.col1 + 74 * - cor0.col1 FROM tab1 cor0 GROUP BY col1

;

SELECT - tab0.col2 * + tab0.col2 FROM tab0 GROUP BY col2

;

SELECT - tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY col2, col1

;

SELECT 33 + - 41 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT ALL + col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT cor0.col2 * cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 * cor0.col1 + + 66 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT col1 + - col0 * cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL cor0.col1 * - 32 + 60 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - cor0.col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - + 54 + tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL cor0.col0 * 75 + + 9 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT ALL + - 93 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - - 84 * + 46 AS col2 FROM tab1 GROUP BY col2

;

SELECT ALL + cor0.col1 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING ( cor0.col2 ) IS NULL
;

SELECT cor0.col1 + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT + cor0.col0 * ( + cor0.col0 * + 88 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + cor0.col2 * col1 + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 86 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 70 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col1 * - col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT DISTINCT + COALESCE ( cor0.col1, cor0.col1 ) + cor0.col1 * 31 AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ( cor0.col0 ) FROM tab1 AS cor0 GROUP BY col1, col0, cor0.col1

;

SELECT DISTINCT - 60 + - 18 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 46 AS col0 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 * cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 0 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 48 AS col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0, col0

;

SELECT DISTINCT 82 * - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL tab0.col2 AS col0 FROM tab0 GROUP BY col2 HAVING NULL IS NOT NULL
;

SELECT ALL + 87 FROM tab2 GROUP BY col2

;

SELECT ALL - 12 FROM tab0 GROUP BY col1

;

SELECT ALL 73 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT COALESCE ( - 23, 23 ) AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - 84 * + COALESCE ( - 32, + cor0.col1 * 59 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 58 FROM tab1 cor0 GROUP BY col0

;

SELECT 86 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT ALL + 40 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL 66 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 19 * 87 + 73 FROM tab0 GROUP BY tab0.col0

;

SELECT 85 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 98 + + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 75 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 46 * + 58 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT + 44 AS col0 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + 79 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + tab2.col0 * + 72 + 24 FROM tab2 GROUP BY tab2.col0

;

SELECT + 5 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 5 + 16 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + tab1.col0 + + col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - tab1.col1 FROM tab1 GROUP BY tab1.col1 HAVING NOT NULL IS NOT NULL
;

SELECT cor0.col0 - - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING NOT NULL IS NOT NULL
;

SELECT ALL + col0 AS col1 FROM tab1 WHERE NULL < ( + tab1.col0 ) GROUP BY tab1.col0

;

SELECT + col1 * + 87 + - 69 * - 81 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 67 - - cor0.col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL col2 + cor0.col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 34 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - cor0.col1 + col1 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT - 74 - 90 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT 94 FROM tab1 GROUP BY tab1.col0

;

SELECT + 49 * - cor0.col2 FROM tab1 cor0 GROUP BY col2

;

SELECT + 84 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 21 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 65 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT - 9 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 FROM tab2 cor0 GROUP BY cor0.col2, col2

;

SELECT - 81 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + tab2.col2 AS col0 FROM tab2 GROUP BY col2

;

SELECT ( 47 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 77 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 57 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 72 * - col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT - cor0.col2 AS col2 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT + 88 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL 4 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 53 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 98 * col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 71 + - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 67 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 65 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 45 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT ALL cor0.col1 * + 76 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 91 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT + - 9 FROM tab2 GROUP BY tab2.col0

;

SELECT + + 71 FROM tab2 GROUP BY tab2.col1

;

SELECT + col0 + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL ( cor0.col1 ) AS col0 FROM tab1 cor0 GROUP BY col1, cor0.col0

;

SELECT ALL col1 + 10 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - cor0.col0 FROM tab2 AS cor0 GROUP BY col0, col0

;

SELECT col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 62 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - tab2.col0 - col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + ( 69 ) AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 95 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 73 * 28 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col2 * col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 10 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT 46 FROM tab2 GROUP BY tab2.col1

;

SELECT 27 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - 66 * 58 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col0 + + NULLIF ( cor0.col2, cor0.col0 + cor0.col0 ) AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - 6 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 22 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 * cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT - 1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT + 6 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab0.col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT - - tab0.col1 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 89 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 68 + 31 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 5 + col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 62 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + - 40 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL + 43 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 10 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 76 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - cor0.col0 + 65 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + cor0.col0 + ( cor0.col1 ) AS col0 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + cor0.col1 * 5 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 70 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT tab0.col2 FROM tab0 GROUP BY tab0.col2 HAVING NOT NULL > NULL
;

SELECT DISTINCT - col1 * cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT ALL 2 FROM tab1 GROUP BY tab1.col2

;

SELECT + 90 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 * 87 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - + tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - 9 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 - 47 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + col1 * cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 71 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT ALL cor0.col1 + 11 FROM tab2 cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT 78 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT cor0.col1 * + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * - cor0.col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - 29 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 71 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 7 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 75 + 33 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL tab2.col2 AS col1 FROM tab2 GROUP BY col2

;

SELECT ALL - - tab0.col1 FROM tab0 GROUP BY col1

;

SELECT ALL - 4 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 93 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + cor0.col1 FROM tab2 AS cor0 GROUP BY col0, col1

;

SELECT DISTINCT - 44 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 80 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 29 * 34 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT 27 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 72 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 9 + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - - 46 FROM tab2 GROUP BY tab2.col2

;

SELECT - 49 FROM tab2 GROUP BY tab2.col0

;

SELECT col0 + - tab1.col0 * - col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 13 FROM tab1 cor0 GROUP BY cor0.col2, col0

;

SELECT - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT 61 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT cor0.col0 * + col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT 0 * - col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ( + cor0.col2 ) FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + 9 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT cor0.col1 * - col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 29 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - 70 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 96 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 90 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col1

;

SELECT ALL + 27 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 89 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 95 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 83 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 13 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 55 AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - col1 AS col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - cor0.col2 * cor0.col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT 16 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 83 + 5 * cor0.col2 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 53 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - + tab2.col1 + 32 FROM tab2 GROUP BY tab2.col1

;

SELECT + + 31 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + 46 FROM tab1 GROUP BY col0

;

SELECT DISTINCT 97 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + NULLIF ( 98, tab2.col2 ) AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT 39 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 94 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - col0 * - col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 67 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 89 - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT 95 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 80 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 AS col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor0.col0

;

SELECT ALL 7 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * ( + 91 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 82 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT - 82 * + 70 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - 90 * col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 81 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, col1

;

SELECT ALL 58 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + col0 + - cor0.col1 * cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT ALL - + tab1.col0 - - col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 98 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL tab2.col0 * + tab2.col0 + col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT 4 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - + 90 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT col0 + 6 FROM tab2 cor0 GROUP BY col1, cor0.col0

;

SELECT + 7 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 25 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - col0 * + col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col0 + - 76 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col2 + - col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL - col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 68 FROM tab2 GROUP BY col0

;

SELECT 11 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - + 4 + + col0 FROM tab2 GROUP BY col0

;

SELECT - 16 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 57 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 + + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT + 98 FROM tab1 GROUP BY tab1.col0

;

SELECT 39 * + 5 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - + 92 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + 9 * - 81 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col0 + 37 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col0

;

SELECT DISTINCT cor0.col1 * - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + col2 FROM tab2 WHERE ( NULL ) IS NULL GROUP BY col2

;

SELECT ALL 82 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col2 * + cor0.col2 + col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 * 32 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + - col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 43 FROM tab1 GROUP BY tab1.col2

;

SELECT + - 74 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 69 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + 0 - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + cor0.col1 * - 98 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 85 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 97 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - 43 AS col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 92 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + col1 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - - 43 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - 58 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 12 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col1 * col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col2 * - cor0.col2 + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - 26 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT 49 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT 15 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - 37 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - 34 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 69 * + col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT - 17 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - col2 * - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT col1 + cor0.col1 * 30 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT cor0.col2 * cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col2 HAVING NOT NULL IS NOT NULL
;

SELECT + - 17 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 38 + 39 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - 69 - - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + 3 FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col2 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT - 28 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + - 41 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 7 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + cor0.col0 + 44 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 99 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + 18 FROM tab2 GROUP BY tab2.col2

;

SELECT 83 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 1 * - 78 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 72 FROM tab0 GROUP BY tab0.col2

;

SELECT 78 FROM tab2 GROUP BY tab2.col1

;

SELECT 67 * 86 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 69 + cor0.col0 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ( + 94 ) AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL 89 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT - 74 FROM tab2 GROUP BY col0

;

SELECT col2 - cor0.col1 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + cor0.col2 + - cor0.col1 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 16 FROM tab0 GROUP BY tab0.col1

;

SELECT + ( 26 ) FROM tab2 GROUP BY tab2.col2

;

SELECT + 49 + + 27 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT - 57 AS col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + - tab1.col2 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT tab0.col1 + - tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 30 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 68 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 67 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - 37 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT 4 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col2 * - 92 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ( + 79 ) AS col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 19 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 * - 84 + + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col0 - - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + tab0.col1 AS col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT + 44 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor1.col2 AS col1 FROM tab2 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT cor0.col0 * - ( + cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT col2 * + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 7 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT NULLIF ( 85, + cor0.col2 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col0 + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 99 * + 49 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT + 86 FROM tab1 AS cor0 GROUP BY col1

;

SELECT cor0.col0 + col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + 18 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 FROM tab1 AS cor0 CROSS JOIN tab1 GROUP BY cor0.col0

;

SELECT DISTINCT - 44 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 58 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, col2, cor0.col1

;

SELECT ALL 23 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT 26 * - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + + tab1.col0 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col1, cor0.col2

;

SELECT DISTINCT - 38 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 0 * 99 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor0.col2

;

SELECT ALL - 91 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + 3 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 99 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + - tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT cor1.col2 AS col0 FROM tab1 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + cor0.col0 + - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 * col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT 93 + + 83 * col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 56 * + cor0.col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL 29 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + cor0.col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col1

;

SELECT - - 72 FROM tab0 GROUP BY col1

;

SELECT cor0.col2 * + 0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + cor0.col1 + + cor0.col2 AS col0 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 87 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 17 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 1 + 66 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 67 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 85 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + cor0.col2 + - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor1.col0 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 76 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT + 3 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL 35 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 5 + + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT tab1.col2 FROM tab1 GROUP BY tab1.col2 HAVING NULL > ( NULL )
;

SELECT - cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT - 0 + - 15 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT COALESCE ( cor0.col2, cor0.col1 ) * - col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col1 + cor0.col1 * + 8 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL 47 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - 85 AS col0 FROM tab1 GROUP BY col2

;

SELECT ALL - 98 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + cor0.col0 * - 80 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + 99 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - cor0.col0 + - 42 * col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 17 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 15 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 86 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 56 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( + tab2.col0 ) AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 17 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + 99 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 79 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 46 + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col0 - cor0.col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT 33 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 19 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 91 AS col1 FROM tab2 cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT - cor0.col2 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 3 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT tab1.col1 * + tab1.col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT ALL NULLIF ( - 67, + cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 + + col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + + 23 AS col0 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - 32 - + 16 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 59 + col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 43 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL 61 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 17 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT cor0.col1 * 84 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + NULLIF ( cor0.col2, cor0.col2 ) * ( 50 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + + tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - 81 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - 5 * tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY col0, cor0.col0

;

SELECT + - tab1.col1 FROM tab1 GROUP BY col1

;

SELECT cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT tab2.col0 - + 27 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT cor0.col2 * cor0.col2 + - cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL 95 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 56 FROM tab1 GROUP BY col1

;

SELECT ALL - + 40 FROM tab0, tab0 cor0 GROUP BY tab0.col2

;

SELECT DISTINCT 2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 + cor0.col1 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - 80 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT col2 * + 41 + + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL cor0.col2 * - col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 96 * 61 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 50 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - cor0.col0 * + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 8 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 91 + + 80 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 12 * 58 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - + col2 AS col2 FROM tab1 GROUP BY col2

;

SELECT - 77 + - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 93 * cor0.col2 FROM tab1 cor0 GROUP BY col2

;

SELECT DISTINCT - - col2 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY col0 HAVING NOT NULL IS NOT NULL
;

SELECT DISTINCT - cor1.col0 AS col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - 4 - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 35 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 21 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 13 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT + 88 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 91 + 81 * cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 90 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - 68 FROM tab1 cor0 GROUP BY col1

;

SELECT ALL - 23 * 62 + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 84 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 35 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT 71 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 24 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * cor0.col2 + - 0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 68 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col2

;

SELECT DISTINCT 12 FROM tab1 GROUP BY col1

;

SELECT ALL - 63 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 64 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col1 * + col1 + 71 * col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 78 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 38 AS col0 FROM tab2 GROUP BY col2

;

SELECT cor0.col1 AS col0 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 - - 33 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor0.col0 * cor0.col0 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 45 * tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT + 10 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 + col1 * - 20 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 62 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0 HAVING NOT col0 IN ( + cor0.col0 )
;

SELECT DISTINCT + 23 FROM tab0 GROUP BY col2

;

SELECT + cor0.col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - col2 + + col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 * cor0.col0 AS col1 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + cor0.col2 * - 27 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + cor0.col1 * - ( + cor0.col2 ) - col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 34 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 + - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + 1 * 34 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + - 83 AS col1 FROM tab2 GROUP BY col2

;

SELECT ( 3 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 42 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 8 FROM tab2 GROUP BY tab2.col0

;

SELECT - - 12 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - cor0.col2 * cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 * - 38 + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 60 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - 73 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 5 * - 48 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - 29 + - tab2.col0 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT - tab0.col1 * ( - tab0.col1 ) AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT + 53 FROM tab0 AS cor0 GROUP BY col2

;

SELECT - 33 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + - 7 + - tab1.col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + 25 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 36 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 15 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 48 FROM tab1 GROUP BY tab1.col1

;

SELECT 80 FROM tab1 cor0 GROUP BY col2, cor0.col0

;

SELECT ALL + 85 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 46 * - 58 FROM tab1 GROUP BY col0

;

SELECT - - tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + - 19 FROM tab2 GROUP BY col2

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab1 cor0 GROUP BY col2, cor0.col1

;

SELECT - 68 + + 29 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 - + 63 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT + - tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT tab1.col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT 2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 99 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col0 - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 + cor0.col2 * 72 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 19 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - + 68 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 75 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + 16 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL 14 + - 63 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col1

;

SELECT 84 FROM tab2 GROUP BY tab2.col2

;

SELECT + 89 FROM tab0 GROUP BY tab0.col0

;

SELECT + + 60 FROM tab0 GROUP BY tab0.col2

;

SELECT 34 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 77 * cor0.col0 + + 52 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + 7 AS col1 FROM tab1 GROUP BY col1

;

SELECT 72 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - ( - 54 ) FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT - 28 * - 32 + - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - tab1.col1 * + 58 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 30 AS col0 FROM tab2 GROUP BY col1

;

SELECT - 76 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + ( - 99 ) + - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 16 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL cor0.col1 + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL 82 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT + cor0.col2 + + cor0.col2 * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - cor0.col2 * - cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL 74 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 68 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL cor0.col2 AS col0 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT 70 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + cor0.col0 * - cor0.col0 + 59 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT 6 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col2 + 48 * + cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 92 FROM tab0 cor0 GROUP BY col0

;

SELECT + 81 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col2 + - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT - cor0.col1 * 1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 11 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - cor0.col2 * + col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 93 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - 88 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 72 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT DISTINCT + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT ALL + 94 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 * cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT 37 FROM tab2 GROUP BY col0

;

SELECT ALL + 53 * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT + col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT col0 * 54 + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 26 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + tab0.col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT + 88 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + + 81 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 4 * + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 79 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT - col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL - 58 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 8 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, col1

;

SELECT DISTINCT 57 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 29 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + col1 * tab0.col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 21 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 19 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT - 71 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 62 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 68 FROM tab0 GROUP BY tab0.col2

;

SELECT + - tab2.col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT 35 * tab0.col1 FROM tab0 GROUP BY tab0.col1

;

SELECT 56 FROM tab1 cor0 GROUP BY col2

;

SELECT - cor0.col0 * col0 + col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 25 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - ( - 81 ) FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL 24 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col0 FROM tab2 AS cor0 GROUP BY col1, col0

;

SELECT DISTINCT 43 + - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - NULLIF ( - cor0.col1, cor0.col0 ) * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 50 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT - NULLIF ( - 24, col0 ) AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col1 + 56 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT - 18 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col0 * cor0.col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 31 FROM tab2 GROUP BY tab2.col0

;

SELECT - 50 FROM tab2 AS cor0 GROUP BY col1

;

SELECT col2 - tab1.col2 FROM tab1 GROUP BY col2

;

SELECT DISTINCT - + tab0.col0 AS col2 FROM tab0 GROUP BY col0

;

SELECT ALL cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 - - cor0.col2 * + cor0.col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + 21 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col2 * ( - cor0.col2 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - ( col2 ) FROM tab1 GROUP BY tab1.col2

;

SELECT ALL 41 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col2 + cor0.col0 * - 69 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + col0 FROM tab0 GROUP BY col0

;

SELECT - ( cor0.col1 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col1

;

SELECT ALL 66 + col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 86 FROM tab0 GROUP BY tab0.col0

;

SELECT - 65 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT + cor0.col2 * 47 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT 26 * tab2.col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT DISTINCT - 63 AS col0 FROM tab0 GROUP BY col1

;

SELECT cor0.col0 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col0

;

SELECT DISTINCT - 9 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2

;

SELECT cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT ALL + NULLIF ( col2, col1 * + cor0.col1 ) + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + 86 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 18 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - + 84 * col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 55 AS col1 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT - 75 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 + - 67 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 70 * tab2.col2 + + ( - 11 ) FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 64 * - col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col1 * - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT 61 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT - cor0.col0 * - cor0.col1 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - 65 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT - 7 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - cor0.col0 + + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 88 FROM tab1 GROUP BY tab1.col2

;

SELECT - 38 - 65 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 78 FROM tab0 GROUP BY col1

;

SELECT ALL 92 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 81 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT - cor0.col1 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - NULLIF ( + col0, cor0.col0 * cor0.col0 ) + + cor0.col0 * - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 59 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - tab2.col1 + 3 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col1 + cor0.col1 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 73 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT ALL - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 1 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 81 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + - 34 - + 95 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL - cor0.col0 * 10 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 12 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 78 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + tab0.col1 + 59 AS col2 FROM tab0 GROUP BY col1

;

SELECT + tab1.col2 FROM tab1 GROUP BY col2

;

SELECT ALL + + tab0.col0 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL 19 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 45 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor1.col2 AS col2 FROM tab0 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor0.col2

;

SELECT - col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 90 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 41 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 28 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 + 69 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT tab1.col1 + - 84 FROM tab1 GROUP BY tab1.col1

;

SELECT - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, col2, cor0.col0

;

SELECT - 6 FROM tab2 GROUP BY tab2.col2

;

SELECT 29 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 46 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 91 - 48 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1, cor1.col2

;

SELECT - 12 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + ( - cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 70 + 41 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT col1 * col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col0 * tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 94 * cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 + cor0.col2 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 67 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 2 * col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col0

;

SELECT ALL + - 32 FROM tab1 GROUP BY tab1.col0

;

SELECT + col0 - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT + - 25 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0

;

SELECT DISTINCT 76 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col2 * 82 FROM tab0 cor0 GROUP BY col2

;

SELECT + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT + 38 * + 9 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col2 * 57 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 1 FROM tab1 GROUP BY tab1.col2

;

SELECT + 24 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 25 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 11 * + cor0.col2 AS col1 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 + 7 * cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT ALL 52 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 6 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT COALESCE ( - NULLIF ( cor0.col0, - 11 * - 3 ), - cor0.col0 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - 58 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 74 AS col2 FROM tab2 GROUP BY col1

;

SELECT DISTINCT - 89 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT 28 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab0.col0 + tab0.col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + cor0.col0 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT cor0.col1 + - ( 57 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + col2 + 56 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT - 67 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 71 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 42 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + col2 FROM tab2 GROUP BY tab2.col2 HAVING NOT NULL = ( NULL )
;

SELECT ALL + col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT - 33 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL ( cor0.col1 ) * 92 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col1 * 19 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL cor0.col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT col1 * cor0.col1 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT 41 * cor0.col2 + - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 55 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 + 45 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - cor0.col1 * + col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - col2 + cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 62 - col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 46 * - 54 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL cor0.col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT cor1.col0 * 6 + - 91 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1, cor1.col0

;

SELECT ALL + 81 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ( cor0.col0 ) * + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 36 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 + 62 * cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 36 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL 85 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL + 54 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT col1 * 85 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT NULLIF ( + cor0.col0, - col2 ) - cor0.col0 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL - cor0.col0 * cor0.col1 - cor0.col1 * 66 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, col1

;

SELECT ALL 84 + + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL + 57 * + cor0.col1 AS col1 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 76 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - tab2.col1 + tab2.col1 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL cor0.col2 / cor0.col2 FROM tab0 AS cor0 WHERE NULL = NULL GROUP BY cor0.col2 HAVING NOT NULL NOT IN ( cor0.col2 / - col2 )
;

SELECT + 77 AS col2 FROM tab1 AS cor0 GROUP BY col0, col1

;

SELECT ALL + 31 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 60 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + 45 * - 54 FROM tab2 GROUP BY col0

;

SELECT col2 - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 76 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL - 47 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 31 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 95 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - col2 + col2 FROM tab1 GROUP BY tab1.col2

;

SELECT 49 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col2 + + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT DISTINCT - cor0.col0 * - cor0.col0 + - 75 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT col0 + + cor0.col2 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 9 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT ALL + NULLIF ( - cor0.col0, + cor0.col0 - cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 96 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL 34 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 33 + + tab0.col1 FROM tab0 GROUP BY col1

;

SELECT + - 86 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT 18 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT ( - cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 * - 83 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 + col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 52 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT NULLIF ( - 89, cor0.col1 * - cor0.col1 ) + 52 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL - cor0.col2 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col2, cor0.col1

;

SELECT 29 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 27 FROM tab2 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0, cor0.col1

;

SELECT ALL 65 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT + 18 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT + 24 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + col0 + - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - cor0.col2 + - col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT + 58 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + 13 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT col0 * + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0 HAVING + cor0.col0 IS NULL
;

SELECT ALL - 65 * col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL + - col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 84 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT - 35 FROM tab0 GROUP BY col0

;

SELECT - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col1

;

SELECT ALL - - 27 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col1 * - 57 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 * ( + 13 ) FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL cor0.col0 + - 66 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 + + 82 * cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 * + 61 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + + 30 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 54 * cor0.col0 + 61 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 81 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 80 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col0 + 28 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL cor0.col1 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT ( 14 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT ( - NULLIF ( col2, + cor0.col2 ) ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 89 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - 83 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 + 37 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 73 FROM tab1 GROUP BY tab1.col2

;

SELECT - - 59 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 61 FROM tab0 GROUP BY col2

;

SELECT - 39 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 7 + 21 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + cor0.col0 * - cor0.col0 + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 * - cor0.col0 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT tab1.col2 * ( + 82 ) FROM tab1 GROUP BY tab1.col2

;

SELECT - tab0.col2 + col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 99 FROM tab1 GROUP BY tab1.col0

;

SELECT + 24 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 16 + + 67 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - 2 + + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT + - tab0.col2 AS col0 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + 37 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 * - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 45 * cor0.col2 + - col2 * 33 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 4 AS col0 FROM tab2, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 46 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + CASE cor0.col1 WHEN cor0.col0 + 1 * cor0.col0 THEN cor0.col0 * - 29 END FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + ( cor0.col2 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - tab1.col2 AS col0 FROM tab1 GROUP BY col2

;

SELECT 26 FROM tab1 cor0 GROUP BY col0

;

SELECT cor0.col1 * cor0.col1 + 93 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 6 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 64 AS col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - col0 * + 90 AS col0 FROM tab0 GROUP BY col0

;

SELECT ALL col0 FROM tab1 GROUP BY col0

;

SELECT cor0.col2 * 77 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col0 + + 12 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 - cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 91 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL NULLIF ( col0, - cor0.col0 + 76 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 43 FROM tab1, tab2 AS cor0 GROUP BY tab1.col0

;

SELECT 56 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT 81 FROM tab1 GROUP BY tab1.col0

;

SELECT + col2 AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT 47 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT ( cor0.col0 ) * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 9 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 18 * + col1 + cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, col1

;

SELECT DISTINCT + 17 AS col2 FROM tab0 GROUP BY col1

;

SELECT ( 6 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 5 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ( cor0.col2 ) * - cor0.col2 + ( cor0.col1 ) AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + - 15 FROM tab0 GROUP BY tab0.col1

;

SELECT + 9 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT ALL + cor0.col1 + 19 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + - 81 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL 69 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 8 FROM tab1 GROUP BY col0

;

SELECT DISTINCT - - 50 * + tab2.col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT 46 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + 29 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT cor0.col2 * + 20 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - cor0.col1 + 72 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 28 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL 89 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 + - cor0.col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 67 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 12 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 97 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 * + CASE cor0.col1 WHEN + col2 THEN - ( - cor0.col2 ) ELSE + cor0.col1 END AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + + 23 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 37 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ( cor0.col1 ) + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - tab2.col0 + 95 * 44 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + cor0.col0 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0 HAVING NULL IS NOT NULL
;

SELECT ALL + cor0.col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + cor1.col0 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT 12 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 8 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 + 53 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + - 52 FROM tab2 GROUP BY col2

;

SELECT ALL + 46 + cor0.col2 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor1.col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0, cor1.col2

;

SELECT + col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT - + col2 + + tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 48 FROM tab0 AS cor0 GROUP BY cor0.col1, col1, cor0.col1

;

SELECT DISTINCT - 53 * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + cor0.col1 + - cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT col1 * NULLIF ( - cor0.col1, cor0.col1 ) AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 59 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT + 17 + + tab1.col2 FROM tab1 GROUP BY col2

;

SELECT + 31 * + col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT 6 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 8 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 46 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + + tab2.col0 * - col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - cor0.col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - 38 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ( - cor0.col1 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col1 * 93 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 44 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 90 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + col0 * - 14 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 * cor0.col1 + cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + col0 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT - tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0 HAVING NULL IS NOT NULL
;

SELECT ALL + col0 * cor0.col0 + col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 + - cor0.col1 * cor0.col1 AS col2 FROM tab1 cor0 GROUP BY col1, cor0.col0

;

SELECT + 44 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 64 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 22 * + 60 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + - tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT col1 * 49 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 83 - + ( - col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT - 33 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - + 98 FROM tab2, tab0 AS cor0 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col0 + + col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 5 + 51 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL - 68 * col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL - + 11 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT 81 * - 73 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 54 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 * 33 + cor0.col1 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT NULLIF ( + 30, + col2 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 39 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + cor0.col2 * 57 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - 19 AS col0 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col2

;

SELECT ALL + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - tab1.col1 AS col0 FROM tab1 GROUP BY col1

;

SELECT - + cor0.col2 AS col2 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 91 * - 74 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + 10 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col0 * 94 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 82 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 25 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + col2 * 83 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ( col0 ) - + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 63 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL 71 * 96 + - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + 95 FROM tab0 GROUP BY col0

;

SELECT cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, col0

;

SELECT ALL - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - col0 + - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 + 25 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - + col1 * - tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + - tab2.col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT - 56 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT - cor0.col0 * - cor0.col0 + - 44 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 77 AS col1 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - 65 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - 66 FROM tab2 GROUP BY tab2.col2

;

SELECT + cor0.col1 + 62 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col1

;

SELECT + 68 * tab2.col2 FROM tab2 GROUP BY col2

;

SELECT + tab0.col2 FROM tab0 GROUP BY col2

;

SELECT ALL - 48 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 75 + col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 58 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 52 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - 31 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 79 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 11 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT + cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 3 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 21 FROM tab2 AS cor0 GROUP BY col0

;

SELECT cor0.col0 FROM tab1 cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 2 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 20 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + cor0.col1 + 95 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - cor0.col1 * cor0.col2 - + COALESCE ( - 83, col2 * - 56, cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL cor0.col0 * 45 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ( cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 75 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT 95 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT - cor0.col2 + - col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 7 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + 32 * 33 AS col2 FROM tab0 GROUP BY col2

;

SELECT - col0 * 63 - + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 22 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT + cor0.col2 + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + cor0.col1 + - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col1, col0, cor0.col2

;

SELECT 31 * cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT + - col1 * 12 FROM tab2 GROUP BY tab2.col1

;

SELECT 94 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + - 25 FROM tab1 GROUP BY col1

;

SELECT ALL - 69 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT ALL tab0.col2 * + tab0.col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + cor0.col1 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT + 16 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - tab1.col2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT tab1.col1 * 98 FROM tab1 GROUP BY tab1.col1

;

SELECT 53 AS col2 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1, cor1.col1

;

SELECT - cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT + 58 FROM tab2 AS cor0 GROUP BY col1, cor0.col1, col0

;

SELECT ALL 50 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 6 - - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 + + col2 * - col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT - 72 * tab2.col0 FROM tab2 GROUP BY col0

;

SELECT ALL - 1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + 45 AS col2 FROM tab2 GROUP BY col0

;

SELECT DISTINCT 69 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 43 FROM tab2 GROUP BY tab2.col1

;

SELECT - col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT COALESCE ( + col0, + col0 ) * 79 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 97 * 40 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 86 FROM tab2 cor0 GROUP BY col1

;

SELECT - 30 + 67 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL + NULLIF ( 43, - cor0.col0 ) AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 81 AS col0 FROM tab1, tab2 AS cor0 GROUP BY tab1.col0

;

SELECT ALL - 74 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL tab0.col0 * col0 FROM tab0 GROUP BY col0

;

SELECT DISTINCT - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2 HAVING ( + cor0.col2 ) IS NOT NULL
;

SELECT - tab1.col0 AS col2 FROM tab1 AS cor0 CROSS JOIN tab1 GROUP BY tab1.col0 HAVING NOT ( NULL ) >= ( NULL )
;

SELECT + + 18 FROM tab2 GROUP BY tab2.col1

;

SELECT 90 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col1

;

SELECT + ( - 94 ) FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL - 30 AS col0 FROM tab2, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 62 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - tab0.col0 * tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 21 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - 4 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT 38 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 30 + + 20 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 29 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT 79 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 61 + - cor0.col0 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 59 * cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 73 + 27 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - 22 FROM tab1 GROUP BY col0

;

SELECT ALL - 87 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT 32 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL col0 * cor0.col0 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT + cor0.col2 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 27 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + col2 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + cor0.col2 * 59 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 40 AS col1 FROM tab1 GROUP BY col2

;

SELECT ALL 9 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 18 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col1 * 10 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - col1 * + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col0 * col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 40 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 43 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + cor0.col2 * - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 34 * 61 - cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 37 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 68 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT + 0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT ( col1 ) * 14 + + cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 44 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 93 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT cor0.col2 + cor0.col1 * + col1 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 64 * + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT DISTINCT + + 32 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT 43 * - cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL 27 + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab0 cor0 GROUP BY col2 HAVING ( NULL ) IS NOT NULL
;

SELECT tab2.col0 + + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + 9 AS col0 FROM tab2 GROUP BY col2

;

SELECT ALL + 9 + + col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 6 FROM tab0 GROUP BY col1

;

SELECT 42 FROM tab1 GROUP BY col2

;

SELECT ALL + 84 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT col2 * 36 AS col0 FROM tab0 GROUP BY col2

;

SELECT + cor0.col1 FROM tab0 cor0 GROUP BY col1, col2

;

SELECT 59 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + cor0.col2 + NULLIF ( - col0, + cor0.col0 / - col0 + - 36 ) AS col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT 18 + - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 21 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + 81 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + - 0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT + col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + 55 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT - col0 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 50 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT DISTINCT + 85 FROM tab1 AS cor0 GROUP BY cor0.col0, col2, cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col1 * + 45 + cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 + NULLIF ( col2, + cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 87 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + - 80 FROM tab1 GROUP BY tab1.col1

;

SELECT + tab0.col2 * 0 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + - tab2.col2 * 45 FROM tab2 GROUP BY tab2.col2

;

SELECT + + 72 FROM tab2 GROUP BY col1

;

SELECT + 37 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 17 AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 87 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT - 53 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - cor0.col2 + - cor0.col2 * - col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT ALL + col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 88 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col0

;

SELECT DISTINCT 98 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT + col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 90 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT col0 * + 29 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, col1, cor0.col2

;

SELECT ALL cor0.col0 * cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT + 68 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 48 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor0.col2

;

SELECT DISTINCT 77 + - cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, col0

;

SELECT - cor0.col0 * cor0.col0 + - 35 * - col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + cor0.col2 * 54 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 74 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL ( 81 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 83 FROM tab1 GROUP BY tab1.col0

;

SELECT 57 FROM tab1 GROUP BY col0

;

SELECT 38 * cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 55 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 20 FROM tab1 GROUP BY tab1.col0

;

SELECT - cor0.col1 + 13 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - 54 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 67 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 81 - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT col2 AS col0 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT ALL + 97 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - CASE cor0.col0 WHEN col1 + + cor0.col1 * cor0.col1 THEN NULL WHEN + cor0.col1 THEN cor0.col0 ELSE NULL END FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT 5 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 64 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 10 FROM tab2 GROUP BY tab2.col0

;

SELECT - 40 * - 64 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL 20 * cor0.col1 - - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - 22 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT col2 + 3 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col1 + 99 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + cor0.col0 + 94 * + 90 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 49 + + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + tab0.col0 + + 8 AS col2 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL - 35 * 76 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + tab1.col2 AS col1 FROM tab1 GROUP BY col2

;

SELECT - 19 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT ALL cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + 99 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - ( - 69 ) AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + ( + 78 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 44 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT cor1.col1 FROM tab2 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0, cor1.col1

;

SELECT ALL cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, col0

;

SELECT DISTINCT - tab1.col0 + - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + col2 FROM tab2 WHERE NOT ( NULL ) IS NOT NULL GROUP BY tab2.col2

;

SELECT - - 76 FROM tab1 GROUP BY tab1.col0

;

SELECT - 18 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - 38 AS col0 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT ALL + cor0.col2 - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - tab1.col1 * 65 FROM tab1 GROUP BY tab1.col1

;

SELECT cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT - + 89 FROM tab2 GROUP BY tab2.col0

;

SELECT + 18 * + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col0

;

SELECT + 21 FROM tab1 GROUP BY col0

;

SELECT ALL - cor0.col0 * - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - tab2.col2 * 69 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col0 * cor0.col2 - ( - col2 - - cor0.col1 ) * - ( - cor0.col1 * cor0.col1 ) AS col2 FROM tab2 AS cor0 GROUP BY col0, cor0.col2, cor0.col1

;

SELECT + col0 * - col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 46 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT col0 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT 75 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0, cor1.col0

;

SELECT ALL - 11 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT - - ( 81 ) AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + - tab2.col1 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL + cor0.col0 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 28 AS col1 FROM tab1 GROUP BY col0

;

SELECT ALL - cor0.col2 * + 85 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - cor0.col0 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT DISTINCT - col0 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + 90 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL ( + cor0.col0 ) * + 24 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT cor0.col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - tab1.col0 AS col0 FROM tab1 GROUP BY col0

;

SELECT + 48 AS col1 FROM tab2 GROUP BY col0

;

SELECT 15 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 21 FROM tab0 GROUP BY tab0.col0

;

SELECT ALL cor0.col0 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL 44 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 76 FROM tab0 AS cor0 GROUP BY col1

;

SELECT NULLIF ( cor0.col1, - cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col2

;

SELECT - cor0.col1 * - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 20 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 95 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 50 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 35 * col0 FROM tab1 GROUP BY tab1.col0

;

SELECT 41 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + tab0.col2 + + 62 * + 0 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL + 57 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col0

;

SELECT - 11 + - tab1.col0 FROM tab1 GROUP BY col0

;

SELECT DISTINCT ( 53 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 AS col1 FROM tab0 cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT + tab0.col1 * col1 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT - tab2.col2 + + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - 60 + - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + col1 FROM tab0 cor0 GROUP BY cor0.col0, col1, cor0.col2

;

SELECT cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT ALL - col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL 47 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL cor0.col2 / cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2 HAVING NOT NULL IN ( col2 )
;

SELECT DISTINCT - cor0.col2 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT + 20 + - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 21 FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT cor0.col0 * + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT - + col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col1 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - - 24 * col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 19 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + 63 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL - 3 * 57 AS col1 FROM tab1 cor0 GROUP BY col2

;

SELECT ALL + 85 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + 6 + 67 FROM tab0 GROUP BY col1

;

SELECT DISTINCT NULLIF ( - NULLIF ( 55, - cor0.col2 * cor0.col2 ), 89 * cor0.col2 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 83 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 13 - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 3 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT + cor0.col0 + + cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 + 48 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 88 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 40 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 52 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - 83 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col1

;

SELECT ALL - tab2.col0 FROM tab2 GROUP BY tab2.col0 HAVING NOT ( NULL ) > NULL
;

SELECT - cor0.col0 * cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 13 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col2 + + 77 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 43 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, col0

;

SELECT - 59 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 80 + cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - 82 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL cor0.col0 * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 28 * + cor0.col1 + + col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 14 * - 8 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + + col1 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 51 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col2 - cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 65 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + cor0.col0 - + 50 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 49 FROM tab0 GROUP BY col2

;

SELECT ALL - ( cor0.col1 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 36 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - cor0.col2 * + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 59 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 64 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 29 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 85 - col0 FROM tab0 GROUP BY tab0.col0

;

SELECT col1 FROM tab0 cor0 GROUP BY col1

;

SELECT DISTINCT - 6 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 96 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL cor0.col2 + 42 AS col0 FROM tab0 AS cor0 GROUP BY col0, col2, cor0.col1

;

SELECT ALL + 26 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT col0 - cor0.col0 * cor0.col1 FROM tab1 cor0 GROUP BY col0, cor0.col1

;

SELECT ALL cor0.col2 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + cor0.col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor0.col2

;

SELECT ALL cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0 HAVING NOT - cor0.col0 IS NOT NULL
;

SELECT DISTINCT 38 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + 40 AS col2 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL - cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - cor0.col2 * - col2 + + cor0.col2 FROM tab1 cor0 GROUP BY col2, col0

;

SELECT ALL 15 * col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 60 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col0

;

SELECT ALL - + 29 AS col2 FROM tab2, tab1 cor0 GROUP BY cor0.col2

;

SELECT 45 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 78 * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 4 FROM tab2 GROUP BY col0

;

SELECT + cor0.col1 + + cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - col1 + 70 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 79 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 98 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + 16 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 40 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 - - cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - - 99 FROM tab1 GROUP BY col0

;

SELECT ALL - cor0.col1 * - col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - 88 * + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - cor0.col1 * - 75 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT ( - 8 ) * - 65 + - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 57 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 * col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 85 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 76 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 * + col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT ALL cor0.col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT - cor0.col2 + - cor0.col2 * + 59 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 + 39 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL cor1.col1 * + cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1, cor1.col1

;

SELECT DISTINCT 18 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT 82 * cor0.col0 FROM tab2 cor0 GROUP BY col0

;

SELECT DISTINCT + col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 46 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 79 FROM tab1 GROUP BY tab1.col1

;

SELECT - 46 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL ( + 47 ) FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col0 AS col0 FROM tab2 GROUP BY col0

;

SELECT DISTINCT + + 88 * 39 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 99 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + 18 FROM tab0 GROUP BY col0

;

SELECT ALL + - 68 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + tab1.col0 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT + 36 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

