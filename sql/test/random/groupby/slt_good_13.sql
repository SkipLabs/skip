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

SELECT ALL 81 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 72 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + - 69 FROM tab0, tab2 AS cor0, tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL + cor0.col2 - + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 70 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT + ( 64 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 80 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 36 * cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL - - 49 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + ( cor0.col0 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 9 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, col1

;

SELECT ALL - 85 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 50 * + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 7 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 45 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - - 5 * tab1.col2 * tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - + 42 FROM tab0, tab1 AS cor0 GROUP BY tab0.col2

;

SELECT - - 18 * 56 AS col0 FROM tab2, tab0 AS cor0, tab0 cor1 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 + - ( - cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL - 27 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 85 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 23 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 99 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 97 * + 3 + - cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - 4 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 41 + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT col0 + - cor0.col0 * + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + 47 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 80 FROM tab1, tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 * - 12 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + 93 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL + NULLIF ( + 29, col1 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 50 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 65 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 95 + + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 86 FROM tab1 cor0 GROUP BY col2

;

SELECT ALL 84 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 53 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 32 FROM tab2 GROUP BY col1

;

SELECT + 93 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 89 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 7 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL cor0.col1 * + 82 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - cor0.col1 - + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - ( + cor0.col2 ) AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - col0 * col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + ( - cor0.col0 ) + - cor0.col0 * cor0.col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 4 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT - 77 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT 25 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 87 AS col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 21 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 21 FROM tab1, tab2 cor0 GROUP BY tab1.col1

;

SELECT - 27 AS col1 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 36 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 37 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab0.col2 - - tab0.col2 * tab0.col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT ( 84 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 45 FROM tab2 GROUP BY tab2.col0

;

SELECT + 82 * + 54 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 43 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 80 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 88 - cor0.col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 48 FROM tab1, tab0 AS cor0, tab0 AS cor1 GROUP BY cor1.col1

;

SELECT cor0.col0 + col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT 22 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, col0

;

SELECT DISTINCT 75 FROM tab2, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 69 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 49 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 61 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 14 * + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 54 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 AS col2 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT - cor0.col2 * + ( cor0.col2 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT NULLIF ( - cor0.col1, cor0.col1 ) FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + 92 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - col1 + - 26 AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL - 23 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 30 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 44 * - 28 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 16 FROM tab1 GROUP BY col0

;

SELECT - 27 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL 82 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 + + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT col2 * - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 54 + + 95 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL - 57 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - ( + cor0.col2 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, col0, cor0.col1

;

SELECT + col0 FROM tab2 AS cor0 GROUP BY col1, col0, cor0.col0

;

SELECT + 89 FROM tab2, tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 AS col2 FROM tab0, tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL - 21 AS col2 FROM tab0, tab0 cor0, tab1 AS cor1 GROUP BY cor0.col2

;

SELECT - 63 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 68 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 33 - col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 79 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + 70 FROM tab0 AS cor0 GROUP BY col0

;

SELECT 36 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 55 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2, col0

;

SELECT - ( + cor0.col1 ) FROM tab2, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - + 53 + + 10 AS col2 FROM tab0, tab1 AS cor0, tab1 AS cor1 GROUP BY tab0.col2

;

SELECT + 16 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 82 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 24 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 25 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + cor0.col1 - + ( cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 * - 22 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 70 AS col0 FROM tab0, tab1 AS cor0 GROUP BY tab0.col1

;

SELECT 95 + 76 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - NULLIF ( tab2.col0, col0 ) AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + 22 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * + cor0.col2 + + 98 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 85 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + 30 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 54 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 37 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 43 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 77 + - cor0.col0 - 97 AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - 63 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 33 FROM tab1, tab1 AS cor0 GROUP BY tab1.col0

;

SELECT + 42 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT 38 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 23 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 90 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 70 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 81 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT - 8 AS col1 FROM tab1 cor0 GROUP BY cor0.col2, col1

;

SELECT - 65 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - + 33 * 80 FROM tab2, tab1 AS cor0 GROUP BY tab2.col1

;

SELECT DISTINCT - 74 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 10 * cor0.col2 * - cor0.col2 + 85 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT - cor0.col1 + 92 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 89 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT DISTINCT 10 AS col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - cor0.col2 * 60 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 + - 50 - - 79 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - ( 70 ) FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col1

;

SELECT + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 79 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - cor0.col1 + 52 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 74 FROM tab1, tab1 AS cor0 GROUP BY tab1.col2

;

SELECT ALL + 38 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 75 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 35 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + 35 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2, cor0.col0, cor0.col0

;

SELECT DISTINCT - 12 AS col2 FROM tab1, tab1 cor0 GROUP BY cor0.col1

;

SELECT + 20 * - col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ( + col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 57 AS col0 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL - 22 * - 81 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + - ( + cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 * - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col2 + - cor0.col2 - + 63 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 59 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - + 56 * cor0.col1 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 52 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 25 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 58 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL - 73 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 56 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 * 46 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 23 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - ( + 13 ) * + 3 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL col1 + - ( - 51 ) * cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 82 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 * - NULLIF ( - cor0.col0, - cor0.col1 * cor0.col0 ) + 45 + + 38 * + cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, col1

;

SELECT ( cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 57 * + 35 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 61 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 77 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL ( - 11 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 47 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT + cor0.col2 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT 20 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 91 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 76 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL - COALESCE ( 78, cor0.col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 81 AS col2 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col2

;

SELECT ALL + 63 FROM tab0 cor0 GROUP BY cor0.col0, col2

;

SELECT - 20 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 82 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 73 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - 29 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT col1 + 85 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL COALESCE ( cor0.col1, cor0.col2 * 59 ) + 30 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 17 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 61 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL 89 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - + 49 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 54 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT col0 + - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 50 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 54 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL 39 + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 42 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col1 + - col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 96 + 26 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT - cor0.col2 + NULLIF ( 85, - 68 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT col0 + + 14 * + 98 FROM tab0 AS cor0 GROUP BY col0

;

SELECT 67 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 94 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 22 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 64 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL 6 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + cor0.col0 FROM tab2, tab0 AS cor0, tab0 cor1 GROUP BY cor0.col0

;

SELECT DISTINCT + ( 61 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 35 + + 30 AS col1 FROM tab1, tab1 AS cor0, tab2 AS cor1 GROUP BY cor0.col1

;

SELECT - cor0.col2 + - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - 50 - - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 57 AS col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 7 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - 2 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 68 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ( cor0.col2 ) + cor0.col2 AS col1 FROM tab1 cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT - 51 + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 11 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT ALL + 74 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 32 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 91 * + cor0.col2 + - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col1 * 92 + - 15 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ( + cor0.col2 ) AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1, cor0.col2

;

SELECT ALL 46 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + + 17 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 25 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( 48 ) FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL - 39 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - col1 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT + 51 + - cor0.col2 * cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL cor0.col0 * - cor0.col0 + - 74 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 34 * cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 41 AS col0 FROM tab2, tab1 cor0, tab0 AS cor1 GROUP BY cor1.col1

;

SELECT ALL NULLIF ( + 71 * 22, cor0.col0 ) AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 76 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 75 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 24 + + cor0.col1 + 45 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 + - cor0.col2 * cor0.col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT 88 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - col1 * - ( + 21 ) AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT + cor0.col2 + col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + cor0.col0 + cor0.col0 * 30 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT - 98 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col1 * cor0.col0 * cor0.col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + + 16 AS col2 FROM tab2 GROUP BY col1

;

SELECT cor0.col2 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - 89 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 58 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + COALESCE ( 46 + + cor0.col1, NULLIF ( 22, cor0.col1 ) ) FROM tab1 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 62 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 35 + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT col2 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 79 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 59 AS col1 FROM tab0, tab0 AS cor0 GROUP BY tab0.col2

;

SELECT ALL cor0.col2 + cor0.col0 * - 41 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL cor0.col2 + col2 * ( - cor0.col0 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - ( 87 ) FROM tab2 GROUP BY col2

;

SELECT DISTINCT + 83 * 19 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 68 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + cor0.col2 + + 42 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - ( + 53 ) AS col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 71 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 44 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col0 * ( + cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 * cor0.col2 * - 9 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - NULLIF ( + 21, cor0.col0 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - 23 * + cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 34 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + 55 AS col1 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL 26 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - - 41 AS col2 FROM tab0, tab1 AS cor0, tab0 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + cor0.col0 * - cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 18 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 68 + + 40 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 56 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 36 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 11 - col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 58 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - cor0.col0 - - cor0.col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 84 * 98 FROM tab2, tab2 cor0 GROUP BY tab2.col2

;

SELECT 15 FROM tab1, tab1 AS cor0 GROUP BY tab1.col1

;

SELECT 41 + 49 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 49 + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT NULLIF ( col2, + 5 ) + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL + cor0.col2 * + 53 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + 79 + - 36 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 7 FROM tab0 GROUP BY tab0.col2

;

SELECT cor0.col1 + - col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - ( cor0.col1 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + + 26 AS col1 FROM tab2, tab1 AS cor0 GROUP BY tab2.col0

;

SELECT ALL + NULLIF ( + 62, + cor0.col0 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 23 AS col1 FROM tab2, tab1 AS cor0, tab1 AS cor1 GROUP BY cor1.col1

;

SELECT - cor0.col2 + + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 27 + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 33 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT cor0.col1 - cor0.col2 AS col2 FROM tab1 cor0 GROUP BY col2, col1

;

SELECT ALL 47 + + 7 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + + 60 + - cor0.col1 AS col1 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 32 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 12 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col0

;

SELECT ALL - 92 AS col1 FROM tab2, tab2 cor0 GROUP BY tab2.col0

;

SELECT DISTINCT + 80 * + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + cor0.col0 * - ( cor0.col0 ) + col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 + col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 35 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT ( 34 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL col1 * + 54 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + - 76 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + + cor0.col1 AS col1 FROM tab2, tab0 AS cor0, tab0 AS cor1 GROUP BY cor0.col1

;

SELECT 13 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 + + 96 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 76 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 52 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - ( - 99 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + - 22 * - cor0.col2 * 91 - + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + cor0.col0 + 71 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 16 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 42 * - 10 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL cor0.col2 - - cor0.col2 * - 52 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 80 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ( - cor0.col1 + - cor0.col1 ) * - 71 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 97 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT 86 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 47 + - 28 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + 81 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 37 * + 24 AS col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 76 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 67 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 25 * - 7 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT + - 70 - 26 AS col0 FROM tab0, tab0 AS cor0, tab0 AS cor1 GROUP BY cor0.col1

;

SELECT ALL + - tab0.col2 AS col2 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - 81 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 42 FROM tab2, tab0 AS cor0 GROUP BY tab2.col0

;

SELECT ALL ( + 20 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL NULLIF ( cor0.col2, + 0 ) * 23 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 98 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + + 64 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT + + 86 * cor0.col1 FROM tab0, tab2 cor0 GROUP BY cor0.col1

;

SELECT tab2.col2 + + col2 * - 80 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT - ( + col2 ) FROM tab2 GROUP BY col2

;

SELECT ALL - cor1.col1 * - cor1.col1 FROM tab0, tab2 AS cor0, tab0 AS cor1 GROUP BY cor1.col1

;

SELECT 82 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL - 8 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 2 * ( - cor0.col0 + cor0.col0 * cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 51 + 54 AS col1 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 16 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 - + ( - 55 ) FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT col0 + 97 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col0 + - col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT NULLIF ( - 14 * cor0.col1 + cor0.col1 * 68, - cor0.col1 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 62 + cor0.col1 * - 52 + - cor0.col1 * - 1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 * + cor0.col1 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + 10 + tab0.col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 74 - - 30 * + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT col1 * + 45 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - ( - cor0.col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + - 69 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 10 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + col1 * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 * + 78 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + cor0.col0 FROM tab2 cor0 GROUP BY col0

;

SELECT DISTINCT col0 * 90 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 86 AS col2 FROM tab1, tab0 AS cor0 GROUP BY tab1.col0

;

SELECT DISTINCT 86 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL 99 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 7 + cor0.col2 * col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - cor0.col0 - + ( - cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 70 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + ( + 29 ) FROM tab0, tab2 AS cor0 GROUP BY tab0.col0

;

SELECT ALL 22 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT col2 * - 23 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 * 16 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 82 AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT - 80 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 30 * - cor0.col2 + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - ( 76 ) FROM tab2 GROUP BY col0

;

SELECT ALL cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT - col1 * - 24 FROM tab1 AS cor0 GROUP BY cor0.col1, col1

;

SELECT cor0.col1 + - cor0.col2 + cor0.col1 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT 66 FROM tab1 GROUP BY tab1.col0

;

SELECT + tab0.col1 + + 73 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 22 AS col0 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - col1 + + cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT + cor0.col0 * + cor0.col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + 3 FROM tab2 GROUP BY tab2.col0

;

SELECT - 19 * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col0 * - 38 + col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 75 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 63 * col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 42 AS col1 FROM tab2, tab2 AS cor0 GROUP BY tab2.col2

;

SELECT ALL cor0.col2 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL + 99 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - 16 * 13 AS col0 FROM tab2, tab1 AS cor0 GROUP BY tab2.col2

;

SELECT ALL + 15 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT 43 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ( 69 ) FROM tab0 GROUP BY tab0.col0

;

SELECT ALL + 51 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 42 AS col2 FROM tab1, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 92 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 13 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL 69 FROM tab0 AS cor0 GROUP BY col2, cor0.col0

;

SELECT ALL + COALESCE ( 93, - cor0.col0 ) + + 91 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 18 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 95 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT + ( - col0 ) + - 67 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 * - 7 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - tab1.col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT + 47 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ( + 52 ) FROM tab1 GROUP BY tab1.col0

;

SELECT - 21 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 22 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 * + ( 51 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL 16 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - 73 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 90 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL 76 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + 31 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - ( + 18 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 49 FROM tab1, tab2 cor0 GROUP BY tab1.col2

;

SELECT ( 54 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 57 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col0

;

SELECT + 78 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 14 AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT 33 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + 41 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 58 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col0 * ( cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ( + ( + cor0.col1 ) ) FROM tab2 AS cor0 GROUP BY col1, cor0.col1

;

SELECT 45 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 66 * - cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + 57 + 73 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 74 AS col1 FROM tab2 cor0 GROUP BY col0

;

SELECT ALL + 38 AS col0 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + - 77 - + 92 AS col0 FROM tab0, tab0 cor0 GROUP BY tab0.col1

;

SELECT + 75 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + 79 FROM tab2 cor0 GROUP BY col2

;

SELECT 68 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 2 + cor0.col1 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + 7 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 76 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + - 1 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - 49 + 54 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col1 * - 23 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT - NULLIF ( cor0.col1, + cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 62 AS col1 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 35 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 63 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * cor0.col1 FROM tab0 cor0 GROUP BY cor0.col2, col1

;

SELECT ALL - 59 + - cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT - 1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + 4 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 * + 17 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 4 FROM tab2 AS cor0 GROUP BY col0

;

SELECT 29 + + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 10 + + 9 AS col0 FROM tab1, tab0 AS cor0 GROUP BY tab1.col2

;

SELECT - cor0.col1 * - 12 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 82 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 73 AS col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ALL + 56 FROM tab1, tab2 AS cor0 GROUP BY tab1.col0

;

SELECT - 45 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 18 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 35 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL 55 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 22 AS col1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - 1 * - 58 * + col0 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - col0 - 46 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 40 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ( cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 93 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT 56 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 1 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - 77 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 86 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 + 55 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 + 67 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 38 * - cor0.col1 + cor0.col1 + ( 76 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 34 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 13 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT col2 + 56 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 67 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - cor0.col1 + - 54 AS col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + NULLIF ( cor0.col0, + col0 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 * - 5 + + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT col2 * 90 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col1 * 8 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL 59 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 90 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 5 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ( - cor0.col1 + 14 * + cor0.col1 ) AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT + cor0.col2 + - cor0.col2 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 7 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 * - 50 + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, col2

;

SELECT 11 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT - 33 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 * 10 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT col2 * col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 85 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 7 FROM tab2, tab1 AS cor0, tab2 AS cor1 GROUP BY cor1.col0

;

SELECT cor0.col0 + + cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 49 AS col1 FROM tab2 GROUP BY tab2.col0

;

SELECT + NULLIF ( + 64, cor0.col1 ) FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - 72 FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 77 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + col0 * tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT 20 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 10 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 63 FROM tab1 GROUP BY col2

;

SELECT ALL - cor1.col2 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT ALL - - 35 AS col2 FROM tab1, tab2 AS cor0 GROUP BY tab1.col1

;

SELECT + + 58 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 78 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col1 - NULLIF ( + cor0.col1, cor0.col2 ) * col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 13 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 16 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 78 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT 32 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - cor1.col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col2 AS col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 43 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + - 55 * cor1.col0 FROM tab1, tab1 cor0, tab1 cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - 41 AS col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL col2 + + 44 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT + 79 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 31 FROM tab2, tab0 AS cor0, tab0 cor1 GROUP BY cor0.col2

;

SELECT ALL + NULLIF ( - cor0.col2, - cor0.col2 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 16 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab2.col0 * 17 AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 77 * 76 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 12 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab0.col0 * + 51 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col1 * - cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 3 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 90 AS col2 FROM tab0, tab1 cor0 GROUP BY tab0.col2

;

SELECT ALL + 6 FROM tab1, tab0 cor0 GROUP BY cor0.col2

;

SELECT - 50 FROM tab2, tab1 cor0 GROUP BY tab2.col1

;

SELECT 78 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 81 - 7 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 * 16 + - cor0.col0 - - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT + 73 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 + 83 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT col0 * - ( col0 ) AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col0 * cor0.col0 + 68 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 13 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 94 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT + ( 40 ) FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT cor0.col1 * 44 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT NULLIF ( - cor0.col0, + cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 36 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 27 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 85 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 53 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + tab0.col2 AS col0 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL - ( 20 * + cor0.col1 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + cor0.col1 + + 16 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + + 59 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT - 7 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 64 + 74 AS col2 FROM tab2, tab0 AS cor0, tab1 AS cor1 GROUP BY cor1.col0

;

SELECT - cor0.col2 * cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 38 + cor0.col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + + col2 * + 40 AS col0 FROM tab2 GROUP BY col2

;

SELECT - 72 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + col0 + - ( + 83 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 82 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 17 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ( - 28 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 9 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 + + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 46 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 92 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 - + 27 FROM tab0 cor0 GROUP BY col1

;

SELECT + cor0.col0 + + 35 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 73 FROM tab1 GROUP BY col2

;

SELECT ALL + 83 FROM tab0, tab1 AS cor0, tab0 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + 70 + + 83 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL 78 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 45 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + col0 * 65 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT 42 FROM tab1 cor0 GROUP BY col0

;

SELECT DISTINCT + 98 FROM tab0, tab2 AS cor0 GROUP BY tab0.col0

;

SELECT - cor0.col0 * - col0 * ( cor0.col0 ) FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT 91 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col2 + - 19 * - 52 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col1 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 80 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT + 34 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT 79 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 49 AS col1 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 * - 36 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 42 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 * 10 + cor0.col1 - + 40 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 23 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 52 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 60 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + ( - 86 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 + + cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT - 16 + - 61 FROM tab2 GROUP BY tab2.col1

;

SELECT 54 * cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL + 79 + 50 AS col1 FROM tab0 GROUP BY tab0.col0

;

SELECT - ( - 14 ) FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 17 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 28 FROM tab2, tab2 AS cor0, tab1 AS cor1 GROUP BY tab2.col2

;

SELECT 60 FROM tab2 GROUP BY col2

;

SELECT ALL 66 * 39 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 32 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 94 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + - cor0.col0 * cor0.col0 + + cor0.col0 * + 96 + + 91 AS col2 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col1 * + col1 * + 16 + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 58 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL 24 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 60 AS col1 FROM tab1, tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 * + cor0.col1 + + 3 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 - 39 FROM tab1, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 68 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 27 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 54 * + cor0.col2 + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL col0 * 2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + col1 * - NULLIF ( 85 + + cor0.col0, cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, col1

;

SELECT ALL - tab0.col1 * col1 + + 84 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - tab0.col0 * + tab0.col0 + 7 AS col0 FROM tab0 GROUP BY col0

;

SELECT ALL + 4 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 22 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 21 + 73 FROM tab0, tab2 AS cor0 GROUP BY tab0.col2

;

SELECT ALL - ( 20 ) FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL ( 19 ) FROM tab0 AS cor0 GROUP BY col1

;

SELECT 38 * cor0.col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + 27 + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 7 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT + 68 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 83 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + - 6 * + tab2.col2 AS col1 FROM tab2, tab2 AS cor0, tab0 AS cor1 GROUP BY tab2.col2

;

SELECT DISTINCT - ( cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 33 * + 39 FROM tab2 GROUP BY tab2.col2

;

SELECT - 37 AS col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - cor0.col1 + 77 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - ( 52 ) * 38 AS col0 FROM tab1, tab0 cor0 GROUP BY tab1.col1

;

SELECT - NULLIF ( + cor0.col2, 45 ) AS col0 FROM tab2, tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL 83 + + cor0.col2 + + cor0.col0 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT ( - cor0.col0 ) FROM tab1 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 11 * cor0.col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + 20 FROM tab2 GROUP BY tab2.col0

;

SELECT + - 91 AS col2 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 * + 2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 47 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL ( 70 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 16 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 84 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 51 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 49 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 98 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col0 + 69 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT 4 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 28 AS col2 FROM tab1 GROUP BY col2

;

SELECT ALL - tab1.col1 + - 90 * - 72 FROM tab1 GROUP BY col1

;

SELECT DISTINCT cor0.col2 * col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 63 AS col0 FROM tab2, tab2 AS cor0, tab2 AS cor1 GROUP BY cor1.col0

;

SELECT 20 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL + 71 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 12 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + ( cor0.col1 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 81 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 16 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 22 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 10 AS col1 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 90 - - cor1.col0 FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ( + cor0.col1 ) * - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 12 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * 78 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 83 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT NULLIF ( cor0.col2, + cor0.col2 ) * 11 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 82 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL 58 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - + 86 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 74 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + 23 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 13 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 43 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 12 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - 45 FROM tab1, tab0 cor0 GROUP BY cor0.col0

;

SELECT - 83 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col2 * 99 AS col2 FROM tab1, tab0 AS cor0, tab0 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 35 * 17 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 97 AS col1 FROM tab1, tab1 AS cor0, tab1 AS cor1 GROUP BY tab1.col1

;

SELECT ALL - 20 * + 60 AS col1 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 94 AS col1 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT - 90 FROM tab2, tab1 AS cor0, tab0 AS cor1 GROUP BY cor0.col1

;

SELECT + 82 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col2

;

SELECT ( - cor0.col2 ) + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + ( col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 99 + + 40 FROM tab1 GROUP BY tab1.col1

;

SELECT 94 * ( - cor0.col1 * - cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 8 * 31 + + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 67 FROM tab2 GROUP BY tab2.col2

;

SELECT - 50 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 * cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 82 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 36 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL ( col2 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 39 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 58 FROM tab0, tab0 cor0 GROUP BY tab0.col0

;

SELECT DISTINCT - 57 + - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col1

;

SELECT DISTINCT + 8 * + 31 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 84 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL 77 * 60 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + cor0.col2 + - 17 * cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 36 FROM tab0 GROUP BY tab0.col1

;

SELECT - 47 + tab0.col0 AS col0 FROM tab0 GROUP BY tab0.col0

;

SELECT DISTINCT - 17 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL col2 * - col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 79 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 11 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + cor0.col1 * NULLIF ( - cor0.col1, cor0.col1 ) + - 24 + cor0.col1 * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + ( cor0.col1 ) FROM tab2, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + tab2.col0 + + 28 AS col0 FROM tab2 GROUP BY col0

;

SELECT ALL 9 * + 23 * - cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + - 18 FROM tab0 GROUP BY col2

;

SELECT + 5 AS col2 FROM tab2 GROUP BY col0

;

SELECT ALL - ( - tab1.col2 ) AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL - + 47 FROM tab2 GROUP BY tab2.col0

;

SELECT - 61 + - 6 AS col1 FROM tab2, tab1 AS cor0, tab0 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 81 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - 40 FROM tab0, tab0 AS cor0 GROUP BY tab0.col2

;

SELECT + cor0.col1 * - 16 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 90 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - - col2 FROM tab0 GROUP BY tab0.col2

;

SELECT - col1 * ( 55 ) AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + + 80 FROM tab0, tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 + - 40 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 76 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 12 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + ( + 42 ) FROM tab0 AS cor0 GROUP BY col2

;

SELECT - 84 AS col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 80 * cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ( cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + ( + cor0.col1 ) AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + - 73 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT + 24 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL cor0.col1 + - 71 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 57 FROM tab0, tab2 cor0, tab1 AS cor1 GROUP BY cor1.col2

;

SELECT 8 AS col2 FROM tab1 GROUP BY col1

;

SELECT ALL - 72 FROM tab1, tab1 cor0, tab1 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT 48 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + + 26 FROM tab1, tab0 AS cor0 GROUP BY tab1.col1

;

SELECT ALL + col1 * cor0.col1 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT + 1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 35 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 20 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT 0 FROM tab0 cor0 GROUP BY col1

;

SELECT - 66 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 40 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 71 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 94 FROM tab1 AS cor0 GROUP BY col2

;

SELECT - 71 * 30 FROM tab2 AS cor0 GROUP BY cor0.col1, col1

;

SELECT ALL cor0.col1 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 + cor0.col2 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 94 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 93 AS col2 FROM tab1 cor0 GROUP BY cor0.col2, col2

;

SELECT 99 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor1.col2 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - 79 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT + cor0.col1 + - cor0.col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL cor0.col2 * 9 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT + 11 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 33 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT - 56 * - cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT + 99 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 20 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - + tab1.col0 + ( - 11 ) * - tab1.col0 AS col1 FROM tab1 GROUP BY col0

;

SELECT ALL 99 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 73 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT + col1 + 68 * col1 AS col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL + 8 FROM tab2 GROUP BY tab2.col1

;

SELECT - cor0.col2 * - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col2 * 32 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 95 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 16 AS col0 FROM tab1, tab1 AS cor0, tab0 AS cor1 GROUP BY cor1.col1

;

SELECT 37 * + 44 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 40 AS col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT + 48 FROM tab1 GROUP BY tab1.col0

;

SELECT 37 + + col0 + 24 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 70 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + cor0.col1 + - cor0.col2 + cor0.col1 * NULLIF ( 69, cor0.col2 + + cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 32 FROM tab2 cor0 GROUP BY col1

;

SELECT DISTINCT + 26 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT COALESCE ( cor0.col2, cor0.col1 ) * cor0.col2 * - 93 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - 91 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT ALL cor1.col2 AS col2 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT - 48 FROM tab0 cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT 0 * - 17 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT ALL + 79 - 42 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 6 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col0

;

SELECT 84 * + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL cor0.col0 * - 67 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 42 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 - col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 47 * - 3 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 65 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 8 + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 93 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT 36 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 6 + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * + cor0.col0 * cor0.col0 - - 94 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 40 FROM tab2 GROUP BY tab2.col2

;

SELECT - 80 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT + 81 AS col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - 0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + ( - cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 + + 60 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT cor0.col0 * + cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 54 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 59 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 19 + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + 28 + - cor0.col1 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + COALESCE ( cor0.col1, + cor0.col1 * + 55 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 47 + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 7 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - + tab0.col1 - 55 AS col2 FROM tab0, tab0 cor0 GROUP BY tab0.col1

;

SELECT DISTINCT + 60 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 48 * 68 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 4 * - cor0.col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - 60 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + cor0.col0 + + 22 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 55 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL ( + 72 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT + col0 * + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ( - 51 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 76 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 14 AS col2 FROM tab2, tab0 AS cor0, tab1 cor1 GROUP BY cor0.col1

;

SELECT DISTINCT - 9 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - 37 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - 71 FROM tab1 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col0, cor1.col0

;

SELECT + 84 * + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT col1 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT ALL - col0 + - cor0.col2 + 75 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT cor0.col2 - - 33 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 * + 32 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT COALESCE ( - cor0.col0, cor0.col0 ) + - 3 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 86 FROM tab0, tab2 AS cor0 GROUP BY tab0.col2

;

SELECT DISTINCT NULLIF ( + 2 * + cor0.col1, - cor0.col1 ) + - 95 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 4 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 44 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col1

;

SELECT ALL ( - cor0.col1 ) AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col2 * - 5 * - 48 + + 83 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 57 * cor0.col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT - cor1.col0 FROM tab0, tab2 AS cor0, tab2 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT - ( cor0.col2 ) * col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - ( cor0.col2 ) + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 17 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - 6 FROM tab2 AS cor0 GROUP BY col2

;

SELECT + 79 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - NULLIF ( cor0.col2, cor0.col2 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor1.col1 AS col1 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL - 8 + - col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - - 25 AS col1 FROM tab2, tab1 AS cor0 GROUP BY tab2.col2

;

SELECT + cor0.col2 + cor0.col2 AS col1 FROM tab0 cor0 GROUP BY col2, cor0.col2

;

SELECT - cor0.col1 * 87 + + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ( col2 ) * cor0.col1 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT + 83 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 91 FROM tab2 GROUP BY tab2.col2

;

SELECT + 45 FROM tab0, tab1 AS cor0 GROUP BY tab0.col1

;

SELECT ALL + 67 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT - 34 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 + cor0.col1 + - 24 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 69 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 23 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 5 * 4 - cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - - cor0.col2 FROM tab0, tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 26 * 47 AS col0 FROM tab0, tab2 AS cor0, tab1 AS cor1 GROUP BY cor0.col0

;

SELECT - 60 * col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 4 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 93 FROM tab0 GROUP BY col2

;

SELECT - cor0.col0 + cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT 35 AS col2 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 * + 85 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 + + cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2, cor0.col1

;

SELECT ALL - 14 + - 87 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 39 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 78 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 * 15 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + 89 FROM tab2, tab0 AS cor0 GROUP BY tab2.col2

;

SELECT 62 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + - 95 AS col1 FROM tab0, tab0 AS cor0, tab2 cor1 GROUP BY cor1.col0

;

SELECT - 8 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ( cor0.col0 ) - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + - 70 * + 86 FROM tab2, tab2 AS cor0 GROUP BY tab2.col0

;

SELECT ( 38 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 53 * cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 76 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 96 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - 30 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL 63 * 49 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 92 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT + 72 * + 60 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 28 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 23 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT 22 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 75 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 24 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 6 + cor0.col2 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT + 52 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 44 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT col2 * cor0.col0 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0, col2

;

SELECT + ( - 32 ) AS col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 * + NULLIF ( cor0.col0 * + cor0.col2, cor0.col2 ) FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 26 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + + cor0.col0 * 49 + - 80 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 50 * cor0.col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 17 * cor1.col2 AS col2 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + 82 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2, cor0.col1

;

SELECT ALL - 92 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 90 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 36 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT 6 + 65 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - ( cor0.col1 ) AS col1 FROM tab1 cor0 GROUP BY col1

;

SELECT + ( + 33 ) FROM tab2 GROUP BY col2

;

SELECT cor0.col2 * 81 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 66 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + cor0.col2 + 81 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT 4 + + col0 + - 65 * - 12 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 * cor0.col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 51 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT NULLIF ( 98 + - cor0.col2, - cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 96 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, col1

;

SELECT 40 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL - NULLIF ( 37, col2 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 55 * + 88 * + tab2.col2 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT cor0.col0 * - 13 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ( 13 ) AS col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - ( 14 ) FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 35 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 23 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL - 7 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + 84 AS col1 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT + 53 AS col2 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT cor0.col2 - - 78 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 66 AS col2 FROM tab0, tab0 AS cor0, tab2 AS cor1 GROUP BY tab0.col0

;

SELECT - cor0.col0 * 21 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 55 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 5 FROM tab0 AS cor0 GROUP BY col0

;

SELECT - 66 AS col2 FROM tab2, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT NULLIF ( cor0.col2, 49 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + 98 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + col2 * cor0.col1 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT + cor1.col1 AS col0 FROM tab0 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1, cor0.col2

;

SELECT DISTINCT - 31 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 37 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 1 AS col1 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 3 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL + 77 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 97 * cor0.col2 + 37 * + 95 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + ( 75 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL NULLIF ( + 28, col0 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 93 + - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 82 + 88 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - 70 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL - 20 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - 84 * + 87 FROM tab1, tab0 AS cor0 GROUP BY tab1.col1

;

SELECT - 29 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - 19 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT ALL + col1 + tab1.col1 AS col2 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - 17 * 95 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 30 + 43 FROM tab1, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor1.col0 * cor1.col1 * - 76 FROM tab1 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col0, cor1.col1

;

SELECT - 27 + - 94 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 71 * - 76 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 27 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 95 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 39 AS col2 FROM tab2, tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 70 FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 + + col0 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + 82 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 37 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT NULLIF ( 38, cor0.col0 ) + - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL NULLIF ( - cor0.col1, + cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 64 AS col0 FROM tab2, tab1 AS cor0, tab1 AS cor1 GROUP BY cor1.col1

;

SELECT ( - cor0.col1 ) AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 78 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 45 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 30 FROM tab1 cor0 GROUP BY col1

;

SELECT + 84 FROM tab0 GROUP BY col1

;

SELECT - 33 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 81 * - col2 + - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 73 * - cor0.col1 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 17 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - - 32 AS col2 FROM tab0, tab2 cor0 GROUP BY tab0.col2

;

SELECT ( - col1 * - col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 99 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - NULLIF ( + tab0.col0, tab0.col0 ) FROM tab0 GROUP BY col0

;

SELECT + cor0.col1 * NULLIF ( 35, cor0.col1 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 AS col1 FROM tab2, tab1 cor0 GROUP BY cor0.col1

;

SELECT 68 FROM tab1 AS cor0 GROUP BY cor0.col2, col2

;

SELECT - 11 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + ( col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - 78 + 2 AS col2 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col2

;

SELECT ALL + 52 FROM tab0 GROUP BY col2

;

SELECT ALL cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 76 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 3 AS col0 FROM tab2, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 17 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT col1 + 30 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT ( + 15 ) * cor0.col2 * 54 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 11 * tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT - cor0.col1 * - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 44 FROM tab1 AS cor0 GROUP BY col2, cor0.col0

;

SELECT cor0.col0 * 44 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + 81 AS col1 FROM tab2, tab1 AS cor0 GROUP BY tab2.col1

;

SELECT ALL - 25 FROM tab0 GROUP BY tab0.col2

;

SELECT + 79 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 90 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL - 61 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 18 + + col1 * cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 84 * - 27 + - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ( - 43 ) AS col2 FROM tab2 GROUP BY tab2.col0

;

SELECT + COALESCE ( cor0.col2, - 31 * + 46 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT NULLIF ( - cor0.col2, - cor0.col2 ) * 40 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL ( - 23 + + col1 * - cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 73 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 * cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 35 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 89 FROM tab1, tab0 AS cor0, tab1 AS cor1 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 + cor0.col0 * cor0.col0 - + cor0.col2 FROM tab1 cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT cor0.col2 FROM tab0, tab2 cor0 GROUP BY cor0.col2

;

SELECT - 37 AS col0 FROM tab1, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 39 AS col0 FROM tab1 GROUP BY col2

;

SELECT 44 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 59 + cor0.col2 + + 18 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col2

;

SELECT DISTINCT - 16 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col1

;

SELECT - cor0.col1 * + 47 + - cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 80 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + ( 61 ) AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - 27 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 32 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 70 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT cor0.col2 + 1 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT + col0 - cor0.col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT 14 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + ( + cor0.col2 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT + - 14 AS col1 FROM tab1, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * - 76 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL - 0 FROM tab0 AS cor0 CROSS JOIN tab2 cor1 GROUP BY cor1.col2

;

SELECT 22 FROM tab0 AS cor0 GROUP BY col1, cor0.col1

;

SELECT ALL 49 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + + 48 * - tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + ( 57 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 38 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 22 + + 64 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT 10 * - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 47 + + cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + 75 * cor0.col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 74 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 + + 76 FROM tab1, tab0 cor0 GROUP BY cor0.col0

;

SELECT + 20 FROM tab0, tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + 80 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 13 * col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 68 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 * cor0.col1 * 52 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 58 * 66 + - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 92 AS col2 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 66 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 78 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 + 4 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 + 28 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + ( cor0.col0 ) * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 67 + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 9 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT - NULLIF ( 25, 24 ) FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 + 13 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 58 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 71 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT DISTINCT 1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 + 97 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 81 AS col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 81 FROM tab2, tab2 AS cor0, tab2 AS cor1 GROUP BY cor1.col0

;

SELECT + 70 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 63 * + cor0.col1 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 76 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 76 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 35 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 94 - 68 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT - 84 AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL 27 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 4 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col0 * + cor0.col0 * 93 + + cor0.col0 + + 46 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 96 * - 53 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 * + 74 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT DISTINCT 85 FROM tab0, tab0 AS cor0 GROUP BY tab0.col2

;

SELECT cor0.col2 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 43 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 9 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + col1 * ( 58 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 57 * - col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col2 + - cor0.col0 * + 13 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 94 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - 3 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT tab1.col1 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT 11 * + 39 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL COALESCE ( cor0.col0, cor0.col0 ) - + cor0.col0 * + 64 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT DISTINCT NULLIF ( 44, + cor0.col0 ) * cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 26 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col1 + cor0.col1 AS col0 FROM tab1 cor0 GROUP BY col1

;

SELECT 30 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 95 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 70 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 56 * - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT cor0.col2 + + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT DISTINCT 75 FROM tab1, tab2 AS cor0 GROUP BY tab1.col0

;

SELECT DISTINCT - 96 FROM tab0, tab0 AS cor0 GROUP BY tab0.col2

;

SELECT ALL - 50 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 31 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + - 76 FROM tab1, tab2 AS cor0 GROUP BY tab1.col2

;

SELECT ALL - 75 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + - 19 AS col1 FROM tab1, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 + 55 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 90 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 98 * + 46 + - 60 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 57 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 * 61 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 79 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - ( - 10 ) * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 82 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + - 82 + + 91 AS col0 FROM tab1 GROUP BY col2

;

SELECT ALL 54 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + 56 + - 22 + - cor0.col0 * cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + col0 * + 94 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 45 * cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - ( + 21 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 91 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT 49 AS col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - ( + cor1.col0 ) FROM tab0, tab0 cor0, tab0 AS cor1 GROUP BY cor1.col0

;

SELECT ALL cor0.col2 * + 39 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 89 AS col0 FROM tab1 AS cor0 GROUP BY col1

;

SELECT ALL 21 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col1 * + cor0.col1 * cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 14 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 44 * 43 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 69 + + 49 + + 25 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 + - 76 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 5 + 81 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col2 * COALESCE ( cor0.col2 * - cor0.col0, - cor0.col2 ) FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 46 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 80 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 85 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 73 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 29 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 6 + cor0.col0 + - 45 FROM tab0 cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT tab1.col1 FROM tab1 GROUP BY col1

;

SELECT ALL 50 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 * + cor0.col0 FROM tab2 cor0 GROUP BY col0

;

SELECT cor0.col2 - 34 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 5 * cor0.col2 + 64 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col0 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT cor0.col2 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT ALL + 22 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 66 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - - 72 AS col1 FROM tab2 GROUP BY tab2.col1

;

SELECT ALL 42 - col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL cor0.col0 + 55 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT + - 26 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + NULLIF ( - 91, - cor0.col2 ) * + cor0.col2 * - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 31 AS col0 FROM tab0, tab2 AS cor0 GROUP BY tab0.col1

;

SELECT - 96 + - col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 86 FROM tab0, tab0 AS cor0, tab1 AS cor1 GROUP BY tab0.col1

;

SELECT - 83 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col1 * cor0.col1 * + 12 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL cor0.col1 - + col0 * + col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 51 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 9 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 25 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 59 FROM tab2, tab1 AS cor0, tab0 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 * - cor0.col1 + + ( + 25 ) * - cor0.col1 AS col2 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 53 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 94 AS col0 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT 92 * - col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 38 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 48 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 70 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 84 * cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 40 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + 75 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT DISTINCT - 18 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT + 57 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 20 * - 41 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 45 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col0

;

SELECT cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT + tab0.col2 * 63 FROM tab0, tab0 AS cor0 GROUP BY tab0.col2

;

SELECT 10 FROM tab2, tab1 AS cor0, tab2 AS cor1 GROUP BY cor0.col0

;

SELECT DISTINCT 98 * 4 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 * cor0.col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 96 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - cor0.col2 AS col2 FROM tab2 cor0 GROUP BY col2, cor0.col1

;

SELECT + 36 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 83 * - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + ( cor0.col2 * 88 ) FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1, col2

;

SELECT ALL - ( - 2 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 * 13 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col2 AS col0 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL 89 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col0 FROM tab0 AS cor0 GROUP BY col0, col0

;

SELECT + 70 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 60 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - ( cor0.col2 * 92 ) AS col2 FROM tab2 AS cor0 GROUP BY col1, cor0.col2, cor0.col1

;

SELECT DISTINCT + 11 FROM tab0 GROUP BY col0

;

SELECT DISTINCT 27 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL - - 80 + cor0.col2 + cor0.col2 AS col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 55 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 1 AS col0 FROM tab0 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT - 60 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 14 FROM tab2, tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL + 88 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + 33 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 + 18 FROM tab0 AS cor0 GROUP BY col1, col1

;

SELECT ALL + cor0.col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col2, cor0.col2

;

SELECT DISTINCT - 79 + tab0.col2 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 77 FROM tab2, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 99 + + 10 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 77 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL ( ( col0 ) ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ( + 88 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 18 + + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 33 FROM tab0 AS cor0 GROUP BY col0

;

SELECT 1 * - cor0.col0 + + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT - 39 * - 21 FROM tab1 GROUP BY col1

;

SELECT DISTINCT - 27 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + + 22 + 25 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT + 85 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 14 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, col1

;

SELECT 25 * + col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 71 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col1 * - 16 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 47 + cor0.col1 AS col2 FROM tab1, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 21 FROM tab0, tab1 cor0 GROUP BY cor0.col2

;

SELECT + 29 AS col2 FROM tab2, tab2 AS cor0, tab0 cor1 GROUP BY cor0.col1

;

SELECT + 13 - - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - + 82 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - 61 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 76 AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col1

;

SELECT 45 * + 2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col1 * 29 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 98 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 6 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT + cor0.col0 + cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL - 89 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 74 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 55 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 38 * 34 AS col1 FROM tab0, tab2 AS cor0 GROUP BY tab0.col0

;

SELECT DISTINCT cor0.col0 + + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 10 + + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - NULLIF ( cor0.col0, - cor0.col0 ) FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 42 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 78 FROM tab0, tab1 AS cor0, tab0 AS cor1 GROUP BY cor1.col0

;

SELECT - 68 - + 29 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 42 AS col2 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 37 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - 99 * + cor1.col2 AS col1 FROM tab1, tab1 AS cor0, tab2 AS cor1 GROUP BY cor1.col2

;

SELECT + 11 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 + 82 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + - cor1.col1 * 10 FROM tab1, tab0 AS cor0, tab0 AS cor1 GROUP BY cor1.col1

;

SELECT col1 FROM tab0 cor0 GROUP BY cor0.col1, col2

;

SELECT ALL cor0.col1 * NULLIF ( - 36, col1 + + 30 ) * - 98 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 8 + + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT 37 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - - 15 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT 96 + cor0.col2 * ( - 49 ) - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 37 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 AS col2 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL + 69 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( - col1 ) FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT 47 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 32 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 13 + - 38 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 12 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 16 + + 70 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL NULLIF ( cor0.col0, cor0.col0 ) AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + ( cor0.col2 ) * - col2 AS col1 FROM tab2 cor0 GROUP BY col2

;

SELECT ALL + col2 + 1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + - 36 FROM tab1, tab0 AS cor0 GROUP BY tab1.col0

;

SELECT ALL - ( cor0.col0 ) AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 72 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + cor0.col2 * + cor0.col2 + 83 - 45 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * - 49 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - col2 + + 26 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 55 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - 92 * + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 4 AS col2 FROM tab2, tab1 cor0 GROUP BY cor0.col1

;

SELECT 70 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT 25 AS col1 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col2

;

SELECT - + 38 * + 89 + cor0.col2 AS col0 FROM tab0, tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - 36 FROM tab2, tab0 AS cor0, tab1 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT + 52 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT + 92 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 89 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT ( 83 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 72 * 16 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 22 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 61 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT + cor0.col2 + - cor0.col1 - 66 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + 57 FROM tab0 cor0 GROUP BY col1, cor0.col2

;

SELECT + cor0.col0 + cor0.col0 * cor0.col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 1 * - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY col1

;

SELECT - + 9 + 62 AS col2 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - 30 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 75 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL 13 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 30 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col2 + 65 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 39 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 54 * - cor0.col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 9 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 79 * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 68 * 57 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT - COALESCE ( 25, 22 ) FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 26 AS col1 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col0

;

SELECT + 35 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 26 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + ( - cor0.col1 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col2

;

SELECT 7 + 98 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 87 AS col1 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL 94 * + cor0.col1 + col0 * + col1 AS col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT + cor0.col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col2

;

SELECT ALL cor0.col2 * cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * 80 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 33 + - 78 * cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 23 AS col2 FROM tab1, tab1 cor0, tab1 AS cor1 GROUP BY cor1.col2

;

SELECT cor0.col0 + + ( + cor0.col2 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT DISTINCT 51 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - cor0.col1 * cor0.col1 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 - col2 * + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 93 * 51 FROM tab2 GROUP BY col0

;

SELECT DISTINCT 86 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 * + cor0.col2 + + ( + cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 41 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL + 48 FROM tab2 cor0 GROUP BY col1

;

SELECT ALL - 18 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL + - tab2.col1 * - 67 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 44 AS col0 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL NULLIF ( + cor0.col2, cor0.col2 ) * + cor0.col2 FROM tab0 cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT 85 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 87 * - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 79 * 90 * cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + 9 AS col1 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 * + col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL - 5 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col2 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - col0 * cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 AS col1 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 25 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 23 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 82 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 38 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 47 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 67 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 40 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 4 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + - 67 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 33 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 68 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 54 AS col0 FROM tab2, tab1 cor0 GROUP BY cor0.col0

;

SELECT - + 85 + 76 AS col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 20 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 41 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 54 + - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 53 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 54 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 32 - col1 * + cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 30 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col2 * cor0.col2 AS col1 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 14 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT DISTINCT 24 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 21 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 20 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 63 FROM tab1 GROUP BY col0

;

SELECT 54 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 87 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 5 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL + 21 + 88 FROM tab1 GROUP BY tab1.col0

;

SELECT + cor0.col1 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - NULLIF ( cor0.col2, cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 96 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 69 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 3 + cor0.col1 FROM tab1, tab2 cor0 GROUP BY cor0.col1

;

SELECT col2 + - 5 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 26 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 + - 84 + + cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 13 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 94 + 63 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 29 FROM tab2 GROUP BY tab2.col1

;

SELECT + cor0.col1 * cor0.col1 + col1 * cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT + 38 + + col0 + 0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 14 + cor0.col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 4 + NULLIF ( + col0, - cor0.col0 ) FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT ALL 92 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + tab2.col0 + 80 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col2 * - col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 19 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 19 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 90 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 17 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 29 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 45 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 80 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 + - cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 40 AS col0 FROM tab0, tab2 AS cor0, tab2 AS cor1 GROUP BY tab0.col0

;

SELECT ALL 6 * cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - 6 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT + 55 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col0

;

SELECT DISTINCT - + 72 + - 96 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT - cor0.col1 * 95 AS col0 FROM tab2, tab0 cor0 GROUP BY cor0.col1

;

SELECT - 25 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 78 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 * - ( cor0.col1 ) FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 76 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 71 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY col0

;

SELECT cor0.col2 * - 27 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 61 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 16 FROM tab0 cor0 GROUP BY cor0.col2, col1

;

SELECT DISTINCT col1 - 41 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 94 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - - 55 FROM tab0 GROUP BY tab0.col2

;

SELECT ( 78 + + 47 * cor0.col1 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 11 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 80 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 40 FROM tab0, tab1 cor0 GROUP BY cor0.col2

;

SELECT 5 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 80 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + col1 + 99 * + 60 * cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + ( 1 ) + 81 AS col1 FROM tab2, tab1 AS cor0 GROUP BY tab2.col1

;

SELECT ALL cor0.col0 * 28 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 90 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT ALL - - 34 FROM tab1 GROUP BY col1

;

SELECT + ( + col1 ) * - 29 FROM tab1 GROUP BY col1

;

SELECT 52 * cor0.col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 19 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 37 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT cor0.col1 * + ( 81 ) FROM tab0 AS cor0 GROUP BY col1

;

SELECT 3 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT DISTINCT - cor0.col1 + 48 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor1.col0 * - 73 AS col2 FROM tab0 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor0.col0, cor1.col0

;

SELECT 83 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + ( 63 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 14 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 * cor0.col1 + + 84 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 * cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 5 + + cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 85 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 59 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT col2 + 90 FROM tab0 GROUP BY tab0.col2

;

SELECT ALL + col2 - - 63 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 52 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 18 * cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL - ( + 58 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 12 AS col0 FROM tab1, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 57 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 70 * + 39 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 53 + + col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 50 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT DISTINCT + 3 AS col1 FROM tab1, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 22 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 13 - - 7 * 50 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL cor0.col2 * cor0.col2 AS col0 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL + 95 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - col2 AS col2 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT ALL + 51 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT + cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 46 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT + - 59 * + 20 FROM tab0 GROUP BY tab0.col1

;

SELECT NULLIF ( cor0.col1, cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + 56 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 39 * - 28 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 40 AS col0 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 13 AS col1 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 99 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 19 FROM tab0 AS cor0 GROUP BY col1

;

SELECT col0 * 91 * 40 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 52 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 21 * cor0.col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + 19 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 31 * - cor0.col2 AS col2 FROM tab1, tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + tab2.col1 + 13 AS col0 FROM tab2 GROUP BY tab2.col1

;

SELECT 83 FROM tab2, tab0 cor0, tab1 AS cor1 GROUP BY tab2.col1

;

SELECT cor0.col1 + 27 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - cor0.col0 * ( + 90 ) * - col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + ( - cor0.col0 ) * cor0.col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + - cor0.col0 * 19 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 32 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + ( - 38 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 73 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 76 FROM tab1 AS cor0 GROUP BY col1, cor0.col0

;

SELECT DISTINCT + 47 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - + cor0.col0 AS col2 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 46 FROM tab2, tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - NULLIF ( 40, cor0.col0 ) * - NULLIF ( cor0.col0 + cor0.col0, + cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0, cor0.col1

;

SELECT DISTINCT + + cor0.col2 * - 9 + 88 * + 22 AS col1 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 10 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col1 * - 82 + - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 20 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 70 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 43 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 80 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT cor1.col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT + 35 AS col2 FROM tab0 GROUP BY tab0.col2

;

SELECT + 16 FROM tab2, tab0 AS cor0 GROUP BY tab2.col0

;

SELECT ALL + cor0.col0 + - 14 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + - 44 * - 87 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 77 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 50 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 62 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 * 0 AS col0 FROM tab2 cor0 GROUP BY cor0.col2, col2

;

SELECT ALL 36 + + tab1.col1 FROM tab1 GROUP BY col1

;

SELECT - 17 * - cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 30 FROM tab1 AS cor0 CROSS JOIN tab0 cor1 GROUP BY cor1.col2

;

SELECT DISTINCT - 98 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - ( - cor0.col2 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + ( + 8 ) AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT 91 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 85 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - tab1.col2 * + ( + 34 ) FROM tab1 GROUP BY col2

;

SELECT + col2 * 58 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL cor0.col0 + - 10 FROM tab1, tab2 cor0 GROUP BY cor0.col0

;

SELECT - + 23 * - tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT + 70 AS col2 FROM tab2, tab1 AS cor0, tab0 AS cor1 GROUP BY cor1.col0

;

SELECT 94 + - cor0.col2 * - cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + NULLIF ( 34, cor0.col0 ) FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 * cor0.col0 + - cor0.col0 - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 94 FROM tab0, tab2 AS cor0 GROUP BY tab0.col2

;

SELECT DISTINCT - 43 + - 84 FROM tab2 GROUP BY tab2.col2

;

SELECT 19 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 10 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 40 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + + tab1.col2 FROM tab1 GROUP BY tab1.col2

;

SELECT tab2.col0 + - col0 + col0 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL - - 3 FROM tab1, tab1 cor0, tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL - 94 FROM tab2, tab1 cor0 GROUP BY tab2.col0

;

SELECT - cor0.col0 * 28 * + 62 - 2 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + 54 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + cor0.col0 - - cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT ALL - 66 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + ( col1 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT col2 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + cor0.col0 + - 80 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + ( cor0.col1 ) AS col1 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT 41 + + 45 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL - 96 AS col2 FROM tab0, tab1 AS cor0 GROUP BY tab0.col1

;

SELECT DISTINCT 81 + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 8 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + - 96 AS col2 FROM tab2, tab1 cor0 GROUP BY tab2.col1

;

SELECT ( + 93 ) AS col0 FROM tab0, tab1 cor0 GROUP BY tab0.col1

;

SELECT DISTINCT + 86 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + ( 2 ) + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT cor0.col1 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 92 + + 66 * cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col2 + ( - 55 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 * cor0.col2 FROM tab0, tab2 AS cor0, tab1 cor1 GROUP BY cor0.col2

;

SELECT tab2.col0 + + 20 FROM tab2 GROUP BY tab2.col0

;

SELECT - 58 + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col2 * 46 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + - ( 64 ) AS col1 FROM tab1, tab0 AS cor0 GROUP BY tab1.col1

;

SELECT - 3 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + ( + 15 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 15 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 90 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 74 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 71 + col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 91 * 10 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + 2 AS col1 FROM tab0, tab0 AS cor0, tab2 AS cor1 GROUP BY tab0.col0

;

SELECT DISTINCT col2 + 35 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL - + tab1.col0 + + 22 FROM tab1 GROUP BY col0

;

SELECT - col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT 74 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + col1 + - cor0.col1 * - ( cor0.col1 ) AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT cor0.col2 + - 75 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 63 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL 9 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 88 + - cor0.col2 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 74 * + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + - 58 FROM tab0, tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 69 AS col2 FROM tab1, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 42 * + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 63 * cor0.col1 * 62 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT - 8 AS col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - 95 * - 77 FROM tab0 AS cor0 GROUP BY col0

;

SELECT 53 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 * - 33 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - + 69 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT + 11 FROM tab1, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 67 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col0 * + 48 * 75 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ( + NULLIF ( cor0.col2, cor0.col2 ) ) * - 35 + - col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - + cor0.col0 * 76 AS col2 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL NULLIF ( cor0.col0, cor0.col2 ) * 60 AS col0 FROM tab1 AS cor0 GROUP BY col1, cor0.col0, cor0.col2

;

SELECT - col1 + ( col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - col0 * 1 + - 3 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 + cor0.col0 AS col0 FROM tab0, tab0 cor0 GROUP BY cor0.col0

;

SELECT + + 60 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 69 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + NULLIF ( cor0.col1, - 40 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 + ( 35 ) * 54 FROM tab2 AS cor0 GROUP BY col1, cor0.col1

;

SELECT - 68 - - cor0.col0 FROM tab2 cor0 GROUP BY col0

;

SELECT DISTINCT - ( cor0.col0 ) + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY col2, col0

;

SELECT ALL - cor0.col1 AS col0 FROM tab2, tab0 AS cor0, tab2 AS cor1 GROUP BY cor0.col1

;

SELECT ALL 27 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 29 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 87 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 28 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 88 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 71 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 * ( 37 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 44 AS col0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 80 * - 68 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 35 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL - + 86 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - NULLIF ( - cor0.col0, cor0.col0 * col1 ) FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT 16 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 37 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - + cor0.col0 * + 31 FROM tab1, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 9 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 28 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + cor0.col2 * 95 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 79 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col0 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col0 + 64 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT cor0.col1 * 60 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT + + 35 FROM tab0, tab1 AS cor0, tab2 cor1 GROUP BY cor1.col2

;

SELECT 5 * - col2 FROM tab2 GROUP BY tab2.col2

;

SELECT 94 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 51 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 71 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 * cor0.col1 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT NULLIF ( - 27, cor0.col1 + cor0.col1 ) * cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT cor1.col1 * 27 FROM tab1 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor1.col1

;

SELECT ( - 29 ) AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 53 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 85 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 38 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 76 * cor0.col0 + 66 AS col1 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 36 AS col1 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 40 + - col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + + ( + 30 ) AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 67 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - + tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col0

;

SELECT + 98 * cor0.col2 AS col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 76 FROM tab0 cor0 GROUP BY col0

;

SELECT + - 10 * tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 7 * 7 AS col2 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT 23 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT - cor0.col2 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT + 29 * - 65 AS col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 49 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ( 65 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - - tab0.col1 * - tab0.col1 AS col0 FROM tab0 GROUP BY col1

;

SELECT DISTINCT 80 AS col2 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL + - 6 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT - - 10 AS col1 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + - 31 * 63 AS col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + ( - 95 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 41 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 19 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 72 * cor0.col1 + - cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0, cor0.col0

;

SELECT + - cor0.col2 + ( - NULLIF ( + cor0.col2, - cor0.col2 ) ) AS col1 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 78 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 50 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ( 48 ) * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL 12 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 74 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col0 * + cor0.col0 * cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + - cor0.col1 * - 14 * 61 AS col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT COALESCE ( cor0.col1, cor0.col1 ) * + cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT tab2.col0 AS col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - cor0.col2 AS col1 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 92 + - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + - 59 + 25 AS col0 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 21 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 10 + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 51 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - + 72 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 7 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 32 FROM tab1 GROUP BY tab1.col0

;

SELECT DISTINCT 85 FROM tab2 AS cor0 GROUP BY col0

;

SELECT - + cor0.col1 + cor0.col1 AS col0 FROM tab1, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 88 + + 35 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT ( 97 ) AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL + 19 + 79 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 73 * + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 56 * - 85 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col2 - - ( - 99 + - 17 ) FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT + ( - 93 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 93 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 13 FROM tab1 AS cor0 GROUP BY col1

;

SELECT DISTINCT 45 AS col0 FROM tab1 GROUP BY tab1.col0

;

SELECT - 7 AS col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col2

;

SELECT ALL + 70 * NULLIF ( col1, + tab1.col1 ) FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT - 81 + 77 AS col2 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT ( - 13 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 35 * - 61 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 + 15 * + 12 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 97 * + cor0.col1 * + 73 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 14 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT - cor0.col0 + + 34 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 96 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 97 + + cor0.col1 * + ( col2 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, col2

;

SELECT - 49 * - 93 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 + + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 72 FROM tab1 cor0 GROUP BY cor0.col2, col2, cor0.col2, cor0.col2

;

SELECT DISTINCT - 11 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT + - 42 AS col0 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL + 81 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 19 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 94 AS col0 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT - 49 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - + 81 FROM tab1, tab1 AS cor0, tab2 AS cor1 GROUP BY tab1.col1

;

SELECT - cor0.col1 AS col2 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 57 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + cor0.col0 * + 86 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 37 + + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 37 FROM tab2, tab1 AS cor0 GROUP BY tab2.col2

;

SELECT 25 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 - + ( - cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 10 * 7 + cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 20 + cor0.col0 FROM tab2 AS cor0 GROUP BY col2, col0

;

SELECT + cor0.col1 + 78 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 34 AS col2 FROM tab2, tab0 AS cor0 GROUP BY tab2.col0

;

SELECT 46 * - 69 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT - 58 AS col2 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 71 AS col1 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT cor0.col1 FROM tab2 AS cor0 GROUP BY col1, cor0.col1, cor0.col1

;

SELECT ALL 84 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT cor0.col1 * + 45 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT 30 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 42 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 33 * cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 57 AS col0 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL 66 * 30 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 0 FROM tab1 GROUP BY col0

;

SELECT ALL - cor0.col2 + - 67 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL + col2 * 85 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT DISTINCT + cor0.col2 * cor0.col2 + - 61 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 2 AS col0 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 70 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 62 * 16 AS col0 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT cor0.col0 * + 34 * 59 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 61 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + ( - 17 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL ( - cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col1, col2, col1

;

SELECT 40 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 9 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 9 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 20 + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 72 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 11 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT ALL 46 * cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + ( cor0.col2 ) AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + 35 - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + + cor1.col2 * 47 + 73 - cor1.col2 FROM tab1, tab1 AS cor0, tab2 AS cor1 GROUP BY cor1.col2

;

SELECT cor0.col1 + + 2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL - tab2.col0 - tab2.col0 * col0 FROM tab2 GROUP BY tab2.col0

;

SELECT 26 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 52 FROM tab0 AS cor0 GROUP BY col2, cor0.col2

;

SELECT ALL - col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col0 - 31 FROM tab1 cor0 GROUP BY col0

;

SELECT cor0.col1 + 43 FROM tab0 AS cor0 GROUP BY cor0.col2, col1

;

SELECT - cor1.col0 AS col0 FROM tab1, tab0 AS cor0, tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 48 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT - 13 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 64 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 92 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col0 AS col1 FROM tab1 AS cor0 GROUP BY col0, cor0.col0, cor0.col1

;

SELECT ALL - 84 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT 60 + + 67 - col2 AS col0 FROM tab2 cor0 GROUP BY cor0.col1, col2

;

SELECT ALL - cor0.col1 * - 9 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 81 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 99 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 39 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT + 68 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 6 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 + 41 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 59 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + 97 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 56 * - 56 FROM tab0 GROUP BY tab0.col1

;

SELECT - + 65 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT DISTINCT - ( cor0.col1 * - cor0.col1 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 65 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT - + cor0.col1 * 92 AS col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - cor0.col0 FROM tab0 cor0 GROUP BY col0

;

SELECT ALL + 92 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1, cor0.col0

;

SELECT DISTINCT - 95 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 + 43 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 22 FROM tab1 GROUP BY col2

;

SELECT ( - col0 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 21 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - 53 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 * 11 AS col1 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - 45 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - 20 FROM tab0 GROUP BY col2

;

SELECT DISTINCT + 88 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 2 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col2

;

SELECT ALL + 45 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 97 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + col0 * - 87 FROM tab0 GROUP BY col0

;

SELECT - 62 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 89 * - cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - - 0 * 43 AS col2 FROM tab0, tab0 AS cor0, tab1 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + - cor1.col2 - 29 FROM tab2, tab0 AS cor0, tab2 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT NULLIF ( NULLIF ( 7, cor0.col1 ), + 59 ) FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1, cor0.col1

;

SELECT ALL - 85 * + cor0.col2 AS col2 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + - cor0.col1 AS col1 FROM tab0, tab1 AS cor0, tab1 cor1 GROUP BY cor0.col1

;

SELECT - 1 - - col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 75 AS col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col0

;

SELECT + 69 * 34 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 35 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 31 * + 74 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT + cor0.col2 * - 44 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT - 91 FROM tab1, tab0 AS cor0 GROUP BY tab1.col1

;

SELECT cor0.col0 * NULLIF ( - cor0.col1, col0 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 68 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 11 AS col2 FROM tab0, tab2 cor0 GROUP BY cor0.col1

;

SELECT cor1.col1 FROM tab2, tab2 AS cor0, tab2 AS cor1 GROUP BY cor1.col1

;

SELECT ALL cor0.col0 FROM tab0 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col2 - + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT 30 * - col1 + + cor0.col1 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 * - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 75 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT 79 - + col2 FROM tab0 AS cor0 GROUP BY col2, col0

;

SELECT - 59 * - 40 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT ALL - 88 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 56 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 58 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 85 * cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 53 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col1 AS col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + ( 46 ) FROM tab1 cor0 GROUP BY col0

;

SELECT 47 * cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 24 FROM tab1, tab2 AS cor0 GROUP BY tab1.col2

;

SELECT DISTINCT - 44 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 13 + - 63 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL - 14 AS col2 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + ( 66 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 56 FROM tab0, tab2 cor0 GROUP BY cor0.col1

;

SELECT ALL + 94 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ( - 72 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 * - cor0.col0 * 15 + + 42 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 46 FROM tab2, tab1 AS cor0, tab2 AS cor1 GROUP BY cor0.col2

;

SELECT 67 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 51 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 95 + col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT DISTINCT 27 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + col2 * - cor0.col2 * cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT cor0.col1 + - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 4 FROM tab0 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2, cor1.col0

;

SELECT + 49 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 3 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 * - cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + 41 FROM tab1, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 62 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 37 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col2 + 25 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col1 * + cor0.col1 - ( 86 ) FROM tab2 AS cor0 GROUP BY cor0.col1, col1

;

SELECT + 89 + cor0.col1 * + cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT cor0.col2 * - 97 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 + 6 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT 94 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 67 AS col0 FROM tab1 GROUP BY col1

;

SELECT ALL - 70 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + cor0.col0 * - 64 FROM tab0, tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 25 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 + 97 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT 25 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT - 94 - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 75 + cor0.col2 * col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - 24 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT - 10 * + 57 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 73 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 40 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + ( - 68 ) FROM tab0 AS cor0 GROUP BY cor0.col0, col0

;

SELECT ALL - + 49 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + tab2.col0 * - 80 AS col0 FROM tab2 GROUP BY col0

;

SELECT 33 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT 17 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 96 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT cor0.col2 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + 4 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, col1

;

SELECT - 53 + tab2.col2 + - tab2.col2 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT 88 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 37 AS col1 FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 95 AS col0 FROM tab2, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - ( 81 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 49 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 26 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT + NULLIF ( cor0.col2 + col2, col2 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 63 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT NULLIF ( cor0.col0, + 70 ) FROM tab2 AS cor0 GROUP BY col0

;

SELECT + 36 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT col0 * - tab2.col0 + - 20 FROM tab2 GROUP BY tab2.col0

;

SELECT + 0 FROM tab0, tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col1 * 68 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col0 * ( cor0.col0 ) + - 2 + cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT ALL + 23 + - cor0.col1 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - + cor0.col0 AS col0 FROM tab0, tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 * + 32 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 3 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 43 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 47 * + cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT + 3 * + tab2.col0 FROM tab2 GROUP BY tab2.col0

;

SELECT 56 * cor0.col0 * col1 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - - 94 FROM tab0, tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL 6 AS col2 FROM tab2 AS cor0 GROUP BY col1

;

SELECT 56 * 17 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - 18 * - cor0.col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT 52 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 * - 75 * 95 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 + + 18 + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - - cor0.col2 * + cor0.col2 * - cor0.col2 AS col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 47 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL - 33 AS col1 FROM tab2 AS cor0 GROUP BY col0

;

SELECT + 9 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT cor0.col2 * - 57 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 80 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + COALESCE ( tab2.col1, 55 ) FROM tab2, tab2 cor0 GROUP BY tab2.col1

;

SELECT ALL col2 + - ( COALESCE ( cor0.col2, cor0.col2 ) ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL - 32 * + col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 23 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col1 * + 18 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 14 * + cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + + col1 AS col2 FROM tab2 GROUP BY tab2.col1

;

SELECT 24 * cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col2

;

SELECT DISTINCT + 32 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + NULLIF ( - tab0.col0, 35 ) FROM tab0, tab0 AS cor0 GROUP BY tab0.col0

;

SELECT ALL 64 FROM tab1 AS cor0 GROUP BY col2, cor0.col1

;

SELECT - 64 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL 92 AS col2 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT col0 AS col0 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - + 97 * tab1.col1 FROM tab1 GROUP BY tab1.col1

;

SELECT 34 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 26 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + ( + cor0.col1 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + - 30 - 40 FROM tab2, tab2 AS cor0 GROUP BY tab2.col1

;

SELECT ALL cor0.col1 * + col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT cor0.col2 * + 3 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 24 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 76 - 49 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 28 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 94 FROM tab0, tab2 AS cor0, tab2 AS cor1 GROUP BY cor0.col2

;

SELECT 86 AS col2 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 18 - - 33 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 22 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT NULLIF ( - cor0.col2 * cor0.col2, + cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT + 39 + 43 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT col2 AS col0 FROM tab1 AS cor0 GROUP BY col0, col2

;

SELECT - - tab0.col2 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT 6 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 0 AS col2 FROM tab1 AS cor0 GROUP BY col0

;

SELECT - 97 AS col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 84 + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 83 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL 52 + 78 FROM tab0 GROUP BY tab0.col2

;

SELECT DISTINCT - 17 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT + 36 AS col0 FROM tab1 GROUP BY col1

;

SELECT ALL + 55 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 11 - - 62 FROM tab1 cor0 GROUP BY col1

;

SELECT ALL + 88 FROM tab1 AS cor0 GROUP BY col0

;

SELECT ALL + 63 * + 86 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col2

;

SELECT - - col1 * + 71 FROM tab2 GROUP BY col1

;

SELECT ALL 91 AS col0 FROM tab0 AS cor0 GROUP BY col2

;

SELECT ALL col1 * ( 2 ) + cor0.col0 AS col0 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT DISTINCT - 8 FROM tab1 GROUP BY col2

;

SELECT DISTINCT + col2 * + 71 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT 25 AS col0 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col2

;

SELECT - 21 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + cor0.col2 * cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col0 + + col0 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT - cor0.col0 * 11 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 22 * - cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT + 95 * - 21 + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL + ( cor0.col2 ) FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL 78 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - ( + cor0.col2 ) + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 0 AS col2 FROM tab2, tab2 cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + 60 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 * 79 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 47 * cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT - 90 * + col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 76 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 86 AS col0 FROM tab2 AS cor0 GROUP BY col0

;

SELECT DISTINCT + col0 - 26 AS col0 FROM tab0 cor0 GROUP BY col0

;

SELECT DISTINCT 55 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT DISTINCT - cor0.col1 * - cor0.col1 * 38 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, col2

;

SELECT 86 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 * + col0 * + cor0.col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 0 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT ALL + 91 * cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 23 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 19 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 85 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 44 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 90 AS col2 FROM tab2, tab0 AS cor0 GROUP BY tab2.col0

;

SELECT - 59 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT - 51 * cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 28 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 87 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 72 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 46 * cor0.col0 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col0

;

SELECT cor0.col1 FROM tab1 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT DISTINCT ( - cor0.col1 + - col2 ) FROM tab1 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - 55 - - cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT 43 + - cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 47 AS col2 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 18 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 81 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 12 FROM tab2 cor0 GROUP BY col2

;

SELECT DISTINCT + COALESCE ( cor0.col2, - cor0.col2 * 96 ) AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT ALL 18 * + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ( - cor0.col1 + 90 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 * 7 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL 11 FROM tab2 GROUP BY tab2.col1

;

SELECT 98 * - 39 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 36 * + cor0.col1 + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 36 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 54 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 41 - + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT 38 + - cor0.col1 + + cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 90 FROM tab2, tab0 AS cor0, tab2 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT - + 39 + + cor0.col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 7 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 71 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + NULLIF ( - 78 * cor0.col2, 87 ) + 68 * - cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 34 AS col1 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col2 + + cor0.col2 AS col1 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + ( 39 ) FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - ( 78 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 66 AS col0 FROM tab1 cor0 GROUP BY cor0.col2, col0

;

SELECT - 8 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + + 85 FROM tab0 GROUP BY col1

;

SELECT ALL + + 24 FROM tab1, tab2 cor0, tab2 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 34 * + 0 FROM tab1, tab0 AS cor0 GROUP BY tab1.col2

;

SELECT ALL 58 + - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 * 54 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 43 FROM tab0 AS cor0 GROUP BY col0, cor0.col1

;

SELECT 61 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 46 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col0 + 67 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 92 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + cor0.col1 AS col2 FROM tab0, tab2 cor0 GROUP BY cor0.col1

;

SELECT + 60 * - cor0.col2 AS col2 FROM tab0, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT - 79 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ( cor0.col0 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 80 * - cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 53 AS col2 FROM tab1 GROUP BY col0

;

SELECT DISTINCT - 17 AS col0 FROM tab1 cor0 GROUP BY col1, col2, cor0.col2

;

SELECT ALL 21 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 6 FROM tab2 GROUP BY tab2.col2

;

SELECT - 43 AS col2 FROM tab0 GROUP BY tab0.col1

;

SELECT + + 25 * - 61 * - tab1.col1 AS col0 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL - tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT 89 AS col1 FROM tab0, tab2 AS cor0, tab1 AS cor1 GROUP BY cor0.col2

;

SELECT DISTINCT 18 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 54 + cor0.col0 * cor0.col0 * 85 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 12 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + ( + 14 ) AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL 42 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 13 FROM tab2 cor0 GROUP BY col0

;

SELECT DISTINCT 97 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor0.col1

;

SELECT - 2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 79 + + tab2.col0 * 23 FROM tab2 GROUP BY tab2.col0

;

SELECT ALL + 2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col0 + + 81 FROM tab1 AS cor0 GROUP BY col0

;

SELECT + 28 + - tab2.col2 AS col2 FROM tab2 GROUP BY tab2.col2

;

SELECT - ( - cor0.col1 ) + cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, col1

;

SELECT DISTINCT + ( + cor0.col1 * cor0.col1 ) AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT + 30 + cor0.col2 * cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL - + 51 * + 5 FROM tab0 GROUP BY col2

;

SELECT DISTINCT - 64 FROM tab2 GROUP BY tab2.col2

;

SELECT 60 + + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + - cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL 92 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 43 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 21 * cor0.col2 FROM tab2 AS cor0 GROUP BY col2

;

SELECT 3 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 51 * + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT + + 42 FROM tab2, tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL + 38 AS col2 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 95 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL + + tab2.col2 * 20 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT ( - cor0.col0 ) * cor0.col1 + cor0.col1 * 54 FROM tab0 AS cor0 GROUP BY cor0.col0, col1

;

SELECT 36 * tab2.col2 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT + ( cor0.col0 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 24 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 44 FROM tab0 AS cor0 GROUP BY col1

;

SELECT DISTINCT - col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 64 * 30 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT NULLIF ( - cor0.col2 * 4, cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 84 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT DISTINCT cor0.col1 * - 94 AS col0 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 31 AS col0 FROM tab2 cor0 GROUP BY col1

;

SELECT - + tab0.col1 * + 0 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 37 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + cor0.col1 + ( 31 ) AS col0 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 35 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT 15 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 * 5 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 61 FROM tab1 cor0 GROUP BY col2

;

SELECT + 47 FROM tab2 GROUP BY tab2.col0

;

SELECT ( + 99 ) FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 + - ( - cor0.col0 ) * 14 * cor0.col0 AS col0 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 7 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - 81 * + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ALL - cor0.col0 * col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 17 FROM tab0 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col1

;

SELECT - 58 AS col2 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 44 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 + 74 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 84 FROM tab1 AS cor0 GROUP BY cor0.col0, col0

;

SELECT DISTINCT - 22 FROM tab1 GROUP BY col1

;

SELECT ALL ( + ( - 53 ) ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 35 * 94 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 25 + - 28 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 5 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + + 78 AS col0 FROM tab0, tab0 AS cor0 GROUP BY tab0.col1

;

SELECT ALL - 52 * - col0 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1, col0

;

SELECT - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col1

;

SELECT cor0.col2 * 37 + + 74 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + 35 * + cor0.col1 + cor0.col0 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT - - 21 AS col0 FROM tab1 GROUP BY col0

;

SELECT col2 * + 44 AS col0 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT cor0.col0 + - cor0.col0 FROM tab0 cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 10 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 95 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 * - 83 + + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT + 19 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 4 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 93 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 49 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col2 * cor1.col0 AS col2 FROM tab2 AS cor0 CROSS JOIN tab1 cor1 GROUP BY cor0.col2, cor1.col0

;

SELECT + 89 - cor0.col2 FROM tab1 cor0 GROUP BY col2

;

SELECT DISTINCT + cor0.col0 + - cor0.col1 * ( + cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - cor0.col0 * + 14 AS col1 FROM tab0 cor0 GROUP BY col0

;

SELECT ( + cor0.col0 ) FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT cor0.col1 * 81 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 99 + + 56 * col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + cor0.col0 FROM tab1 cor0 GROUP BY col0

;

SELECT - 9 FROM tab0 cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col1

;

SELECT - cor0.col1 + 28 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL NULLIF ( cor0.col0, - cor0.col0 ) * + ( cor0.col1 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + cor0.col2 * cor0.col2 FROM tab2, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 86 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 60 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT + 91 + 38 FROM tab0 cor0 GROUP BY col0

;

SELECT 82 * cor0.col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 41 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 56 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 81 FROM tab0 GROUP BY tab0.col2

;

SELECT - cor0.col2 + - 63 FROM tab2 cor0 GROUP BY cor0.col2

;

SELECT - 21 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + 32 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL + 30 AS col2 FROM tab0 cor0 GROUP BY col1

;

SELECT ( 72 ) FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT cor0.col0 + 1 * 89 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT col2 + 99 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 89 AS col1 FROM tab1, tab0 AS cor0, tab1 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT DISTINCT 37 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( cor0.col2 ) * - 45 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + 95 FROM tab1 AS cor0 GROUP BY col2

;

SELECT + 48 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - + 65 FROM tab1, tab0 cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col2 * col0 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT 93 AS col1 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT - 22 - + 28 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 98 * + cor0.col0 AS col1 FROM tab1, tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT ( col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT ( cor0.col2 * + cor0.col2 ) - 60 * cor0.col2 FROM tab0 cor0 GROUP BY col2

;

SELECT 61 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + 2 FROM tab0 GROUP BY tab0.col0

;

SELECT - 94 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - NULLIF ( + 66, cor0.col0 ) FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 35 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT 88 FROM tab1 AS cor0 GROUP BY col2, col1

;

SELECT + 98 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 3 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 99 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 6 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 45 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT 20 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col2, col0

;

SELECT DISTINCT - 30 * - 18 FROM tab2 GROUP BY tab2.col1

;

SELECT cor0.col0 * COALESCE ( 17 + cor0.col0 * cor0.col0, cor0.col0 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 13 * col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 * 85 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + 56 + + cor0.col1 * ( + cor0.col1 ) AS col2 FROM tab0 cor0 GROUP BY col1, cor0.col2

;

SELECT DISTINCT - col2 - + cor0.col2 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT + 77 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + 41 FROM tab0 cor0 GROUP BY cor0.col1

;

SELECT 37 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 81 * ( - 52 ) FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 33 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + - 93 FROM tab2, tab2 cor0, tab1 AS cor1 GROUP BY cor0.col2

;

SELECT 96 AS col1 FROM tab2 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT DISTINCT + 28 * + cor0.col0 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 97 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + - 5 * tab2.col1 AS col1 FROM tab2 GROUP BY col1

;

SELECT - NULLIF ( + 26 + + cor0.col0, 96 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 97 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 * + 93 FROM tab0 AS cor0 GROUP BY col1, cor0.col2

;

SELECT - 46 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 98 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 84 FROM tab0 GROUP BY col0

;

SELECT ALL + 12 FROM tab0, tab1 AS cor0 GROUP BY tab0.col0

;

SELECT + 81 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 85 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 25 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL - 20 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col0 + cor0.col1 * + 76 AS col1 FROM tab2 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT - 29 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT + 80 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col0 * 66 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 6 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL - 3 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 37 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col2 * 91 * cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT + 22 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + 86 AS col1 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 33 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 74 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT cor1.col0 * 76 + ( - 24 ) FROM tab1 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor1.col0

;

SELECT + + 53 * 64 AS col2 FROM tab2, tab0 AS cor0, tab1 AS cor1 GROUP BY cor1.col2

;

SELECT ALL 0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + NULLIF ( cor0.col2, - cor0.col2 ) FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 + 26 + cor0.col1 * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT DISTINCT 38 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - - 90 FROM tab2, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + ( - cor0.col0 + - 90 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 41 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ( 94 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 68 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 93 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT NULLIF ( - 52, + cor0.col0 ) + cor0.col0 * - 18 * - 64 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT DISTINCT + 87 + 79 FROM tab1, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - 30 + 67 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + col0 AS col0 FROM tab0 GROUP BY col0

;

SELECT - 89 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + ( + 96 ) + + 27 AS col0 FROM tab2, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 16 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT ( + 67 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + 94 FROM tab0 GROUP BY tab0.col0

;

SELECT cor0.col2 * col0 - - cor0.col1 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0, col1

;

SELECT DISTINCT - - 43 FROM tab2 GROUP BY col1

;

SELECT + 18 FROM tab1, tab0 cor0 GROUP BY cor0.col1

;

SELECT ALL + ( + 44 ) FROM tab0 cor0 GROUP BY col0, cor0.col1

;

SELECT + cor0.col1 + + cor0.col1 AS col2 FROM tab0 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT cor0.col1 * + 95 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col2 * 58 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT + 0 FROM tab0 cor0 GROUP BY col2

;

SELECT - 11 AS col1 FROM tab0 GROUP BY tab0.col1

;

SELECT - 93 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT + 52 - 89 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 85 + cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 0 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT - 84 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 92 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 97 AS col2 FROM tab1, tab1 AS cor0, tab0 AS cor1 GROUP BY cor0.col0

;

SELECT ALL - cor0.col2 * + 12 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + 32 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 81 + cor0.col1 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 41 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 7 AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT 56 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 41 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor1.col1 * cor1.col1 + - 37 FROM tab1, tab1 AS cor0, tab0 AS cor1 GROUP BY cor1.col1

;

SELECT ALL NULLIF ( cor0.col2, cor0.col2 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor1.col2 * 78 AS col1 FROM tab2, tab2 AS cor0, tab0 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT 73 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT 88 * 97 - - col0 * 5 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 * 57 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT + 7 * + 46 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2, cor0.col1

;

SELECT 80 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + tab2.col2 - - 63 FROM tab2 GROUP BY tab2.col2

;

SELECT + 7 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - 27 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - 71 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT cor0.col1 * 1 * cor0.col1 + cor0.col2 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT DISTINCT 51 * + cor0.col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + tab0.col2 FROM tab0, tab1 AS cor0 GROUP BY tab0.col2

;

SELECT + 52 AS col2 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT + 56 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 83 * col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - col1 - - 56 FROM tab0 GROUP BY tab0.col1

;

SELECT ALL 58 * col0 - + 94 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL COALESCE ( - tab2.col2, 64 ) FROM tab2 GROUP BY tab2.col2

;

SELECT - ( COALESCE ( cor0.col1, cor0.col1 ) ) * + cor0.col2 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT - 6 AS col0 FROM tab0 GROUP BY col1

;

SELECT 77 AS col0 FROM tab2 cor0 GROUP BY col2

;

SELECT + cor0.col1 + cor0.col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 10 AS col2 FROM tab0 AS cor0 GROUP BY col1

;

SELECT ALL 25 + - 82 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - ( cor0.col0 ) AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - NULLIF ( 92, - cor0.col0 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 99 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - cor0.col2 FROM tab1 cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT DISTINCT cor0.col1 * + 13 + cor0.col1 AS col1 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL col0 * + 46 - 36 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 70 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 15 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 * 31 * 22 AS col1 FROM tab2 cor0 GROUP BY cor0.col1, col1

;

SELECT ALL - cor0.col0 * + 53 + 12 FROM tab1, tab2 cor0 GROUP BY cor0.col0

;

SELECT 12 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT 95 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL ( + tab2.col2 ) AS col1 FROM tab2, tab2 AS cor0 GROUP BY tab2.col2

;

SELECT DISTINCT - 15 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 34 AS col0 FROM tab0 cor0 GROUP BY col2

;

SELECT DISTINCT 7 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT 6 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL 82 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 73 + cor0.col1 + + col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 89 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 60 * cor0.col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL + - 25 FROM tab2, tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL + cor0.col2 + cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col1, cor0.col1

;

SELECT DISTINCT 4 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 36 FROM tab1, tab2 cor0 GROUP BY cor0.col1

;

SELECT - 92 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 16 + + cor1.col2 AS col0 FROM tab1, tab1 AS cor0, tab0 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT + 54 AS col1 FROM tab2 GROUP BY tab2.col2

;

SELECT - cor0.col2 AS col1 FROM tab2 AS cor0 CROSS JOIN tab1 AS cor1 GROUP BY cor0.col2

;

SELECT - - 86 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT + 78 - - 87 AS col0 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 87 + - 78 AS col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT - 44 * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL 18 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT ALL + NULLIF ( 38 + + cor0.col2, 96 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + ( - cor0.col2 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 91 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 95 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT cor0.col0 * + cor0.col0 + - 53 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 15 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL + 83 * - cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + 3 FROM tab0, tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col2 * cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - + 55 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL + 53 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + 10 * + cor0.col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT 38 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - tab2.col0 FROM tab2, tab2 cor0 GROUP BY tab2.col0

;

SELECT ALL 38 + 85 * col2 FROM tab1 AS cor0 GROUP BY col1, cor0.col2, cor0.col2

;

SELECT DISTINCT - 72 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 84 * 23 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col1 * cor0.col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT 50 FROM tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - 24 FROM tab2 AS cor0 GROUP BY col2, cor0.col1

;

SELECT DISTINCT - 3 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 82 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col0 * cor0.col0 * 9 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT - 69 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT cor0.col1 * + 34 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL - 44 * - cor0.col1 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + 0 * + 90 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + col2 * cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - cor0.col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col0

;

SELECT 17 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col1, cor0.col2

;

SELECT DISTINCT ( cor0.col0 ) - - cor0.col0 FROM tab1 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT + cor0.col2 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - 54 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT 88 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 75 AS col1 FROM tab1 GROUP BY tab1.col2

;

SELECT + 3 + - cor0.col0 * 73 FROM tab2 AS cor0 GROUP BY col0

;

SELECT cor0.col1 * 20 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - + 46 FROM tab2, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 8 * - 21 + - cor0.col0 FROM tab2, tab2 cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - ( - 36 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col2 * 58 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + 71 AS col1 FROM tab1 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor1.col0

;

SELECT + 11 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 19 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - COALESCE ( - 48 + - col2, 72 ) AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 62 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 56 FROM tab2, tab0 AS cor0 GROUP BY tab2.col2

;

SELECT + 4 + 13 + cor0.col2 AS col2 FROM tab2, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL 60 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - 3 * cor0.col1 * cor0.col1 + 69 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL 63 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT 53 * - cor0.col2 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT + + 82 + + cor0.col2 FROM tab1, tab1 AS cor0 GROUP BY cor0.col2

;

SELECT + cor0.col1 AS col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 77 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT - 52 FROM tab0 AS cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT + 58 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL - cor0.col0 * cor0.col0 FROM tab0 AS cor0 GROUP BY col0

;

SELECT + cor0.col1 * cor0.col1 + + col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 18 FROM tab0, tab0 AS cor0, tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL 3 AS col0 FROM tab2 GROUP BY tab2.col2

;

SELECT DISTINCT 36 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT - cor0.col0 + + col0 FROM tab0 AS cor0 GROUP BY col1, cor0.col0

;

SELECT cor0.col2 * cor0.col2 AS col1 FROM tab0 cor0 GROUP BY col2, cor0.col1

;

SELECT - cor0.col2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col2

;

SELECT ALL * FROM tab0 AS cor0 GROUP BY col2, cor0.col0, cor0.col1

;

SELECT DISTINCT 87 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + 83 AS col2 FROM tab1, tab1 AS cor0 GROUP BY tab1.col2

;

SELECT - 89 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - 98 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col1 + - cor0.col1 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT + + tab2.col2 + tab2.col2 AS col2 FROM tab2 GROUP BY col2

;

SELECT + 61 + - cor0.col1 FROM tab1 AS cor0 GROUP BY col1

;

SELECT - 62 AS col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT - 70 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 87 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col2, cor0.col0, cor0.col1

;

SELECT ALL + - 60 * - 34 AS col0 FROM tab0, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT + cor0.col0 * + cor0.col0 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL col2 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT + + tab0.col2 * 50 AS col1 FROM tab0 GROUP BY tab0.col2

;

SELECT 71 AS col2 FROM tab1 cor0 CROSS JOIN tab0 AS cor1 GROUP BY cor1.col2

;

SELECT DISTINCT 43 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - 42 FROM tab1 cor0 GROUP BY cor0.col1

;

SELECT ALL cor0.col1 AS col0 FROM tab2 AS cor0 GROUP BY col1

;

SELECT DISTINCT col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0

;

SELECT 64 * cor0.col2 * + cor0.col2 AS col1 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT ALL 8 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 55 * + col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL ( - cor0.col2 ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL + col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - 44 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - tab0.col1 * col1 FROM tab0 GROUP BY col1

;

SELECT DISTINCT cor0.col2 * - 20 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT col1 FROM tab1 GROUP BY col1

;

SELECT DISTINCT + 43 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT DISTINCT + cor0.col2 * - 2 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, col2

;

SELECT DISTINCT + 80 AS col1 FROM tab1 AS cor0 GROUP BY col0

;

SELECT DISTINCT + 16 FROM tab2 AS cor0 CROSS JOIN tab2 AS cor1 GROUP BY cor0.col0

;

SELECT + col0 FROM tab2 AS cor0 GROUP BY cor0.col2, col0

;

SELECT ALL - 33 * - cor0.col0 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT + 54 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 6 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - 38 * cor0.col0 + + 38 FROM tab0, tab0 cor0 GROUP BY cor0.col0

;

SELECT ALL - 48 AS col0 FROM tab0, tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT 13 FROM tab2 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT cor0.col1 * + 79 AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT 12 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - - cor0.col2 AS col1 FROM tab2, tab2 cor0 GROUP BY cor0.col2

;

SELECT col1 * 74 FROM tab0 GROUP BY tab0.col1

;

SELECT DISTINCT - 81 * col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - tab1.col1 + - col1 FROM tab1 GROUP BY tab1.col1

;

SELECT ALL col0 FROM tab2 GROUP BY tab2.col0

;

SELECT DISTINCT col2 * col2 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT ALL cor0.col0 * cor0.col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL 44 + + tab1.col0 FROM tab1 GROUP BY tab1.col0

;

SELECT ALL 64 FROM tab2, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - col2 AS col0 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - cor0.col2 + + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - 3 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT 49 FROM tab0 AS cor0 GROUP BY cor0.col0, col2

;

SELECT cor0.col0 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT + ( + 39 ) AS col0 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT - cor0.col1 + + col1 FROM tab2 cor0 GROUP BY cor0.col1

;

SELECT DISTINCT - cor0.col1 * col1 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT ALL + cor0.col1 * 92 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT col2 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT 31 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT - - 14 AS col0 FROM tab1, tab1 AS cor0 GROUP BY cor0.col0

;

SELECT ALL - 49 FROM tab0 GROUP BY col0

;

SELECT - 71 FROM tab2 AS cor0 GROUP BY cor0.col2, cor0.col0

;

SELECT DISTINCT - - 56 + tab2.col1 FROM tab2 GROUP BY tab2.col1

;

SELECT DISTINCT - cor0.col0 AS col2 FROM tab0 cor0 GROUP BY cor0.col0

;

SELECT + cor0.col1 FROM tab2, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 + - cor0.col2 FROM tab0, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + col2 * + cor0.col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT 50 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 65 * - cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + cor0.col2 AS col1 FROM tab2 cor0 GROUP BY cor0.col2, cor0.col1

;

SELECT + NULLIF ( 59, - 22 ) FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT 37 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT 76 AS col0 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL 48 * + tab1.col0 + tab1.col0 AS col2 FROM tab1 GROUP BY col0

;

SELECT DISTINCT 72 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 85 + - col1 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT 57 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT + 35 * - 30 AS col1 FROM tab2 AS cor0 GROUP BY col2

;

SELECT ALL + - tab1.col0 AS col1 FROM tab1 GROUP BY tab1.col0

;

SELECT - ( 45 ) + + col0 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL cor0.col1 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL 44 FROM tab1 cor0 GROUP BY cor0.col2

;

SELECT + cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT 21 + 31 AS col2 FROM tab1 GROUP BY tab1.col2

;

SELECT ALL cor0.col1 FROM tab1, tab2 AS cor0 GROUP BY cor0.col1

;

SELECT cor0.col2 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col2, col2, cor0.col1

;

SELECT 8 FROM tab1 AS cor0 GROUP BY col2, cor0.col2

;

SELECT + cor0.col1 * - 24 AS col2 FROM tab2 AS cor0 GROUP BY cor0.col2, col1

;

SELECT COALESCE ( - 73, cor0.col0, - 90 ) * - 38 + col0 FROM tab1 cor0 GROUP BY col0

;

SELECT ALL COALESCE ( + 72, - cor0.col2 ) + + cor0.col0 AS col2 FROM tab1 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT - cor0.col1 + COALESCE ( 3, col0 ) * + col0 AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col0, col0

;

SELECT ALL 57 * - COALESCE ( cor0.col0, - cor0.col1, NULLIF ( + cor0.col2, + cor0.col0 ) ) AS col0 FROM tab1 AS cor0 GROUP BY cor0.col1, col0, cor0.col2

;

SELECT DISTINCT COALESCE ( - 65, col1 ) * + cor0.col1 AS col2 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT DISTINCT 62 * COALESCE ( - 12 * - col2, - cor0.col1, 84 * + cor0.col1 ) FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT COALESCE ( cor0.col1, cor0.col2 ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT ALL COALESCE ( cor0.col0, col1 ) AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, col0

;

SELECT ALL + NULLIF ( cor0.col0 + - cor0.col2, - COALESCE ( cor0.col2, - cor0.col0, + cor0.col0 ) ) FROM tab0 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT ALL COALESCE ( + 73, + cor0.col2 ) FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT - COALESCE ( cor0.col1, cor0.col1 ) * cor0.col1 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT col1 * + cor0.col1 + - cor0.col1 * - COALESCE ( cor0.col1, + cor0.col1 ) FROM tab1 AS cor0 GROUP BY cor0.col1

;

SELECT - cor0.col2 + - col0 * + NULLIF ( COALESCE ( cor0.col2, - 37, col2 ) + cor0.col0, cor0.col0 ) FROM tab0 cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT + COALESCE ( + 36, cor0.col1 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT COALESCE ( + 30, + 13 ) AS col1 FROM tab0, tab0 AS cor0 GROUP BY cor0.col0

;

SELECT + col1 * + cor0.col2 + COALESCE ( cor0.col1 + cor0.col1, 40, + cor0.col2 ) * + 31 AS col1 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT COALESCE ( 68 + + col0, 40 * - cor0.col0 + 7 ) FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col2

;

SELECT DISTINCT COALESCE ( cor0.col1, + cor0.col0 * - cor0.col0 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT ALL + COALESCE ( 54, col0 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT ALL COALESCE ( 75, cor0.col0 + cor0.col0 * - 85 ) AS col2 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT ALL COALESCE ( 67 + + cor0.col1, cor0.col1 * cor0.col1 ) AS col0 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT ALL col2 * - COALESCE ( 91 * cor0.col1, + cor0.col2, + cor0.col1 * cor0.col1 ) AS col1 FROM tab1 cor0 GROUP BY cor0.col0, col2, cor0.col1

;

SELECT + COALESCE ( 46 + + cor0.col1, NULLIF ( 22, cor0.col1 ), + cor0.col1 ) AS col1 FROM tab1 cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL + cor0.col2 AS col0 FROM tab2 AS cor0 GROUP BY col0, col2

;

SELECT - COALESCE ( + 44, cor0.col2, - 39 ) FROM tab2 AS cor0 GROUP BY cor0.col2

;

SELECT DISTINCT + cor0.col2 * + COALESCE ( cor0.col2, cor0.col2 * + 21 ) AS col2 FROM tab0 AS cor0 GROUP BY col2

;

SELECT DISTINCT cor0.col2 * + col0 * - COALESCE ( cor0.col0 * cor0.col2, - cor0.col0 ) FROM tab0 cor0 GROUP BY cor0.col1, cor0.col2, cor0.col0

;

SELECT DISTINCT COALESCE ( cor0.col0, + 5 ) + cor0.col1 FROM tab2 cor0 GROUP BY cor0.col1, cor0.col0

;

SELECT ALL COALESCE ( - cor0.col1 * + cor0.col1, cor0.col1, 4 ) AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1

;

SELECT + COALESCE ( + 12 + cor0.col1, ( 51 ) * cor0.col1 ) AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1, cor0.col1

;

SELECT ALL COALESCE ( 53, cor0.col2 * + ( 19 ) ) AS col1 FROM tab1 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - COALESCE ( 61 + + 54, cor0.col0 + COALESCE ( 6, + cor0.col1 ) ) * + cor0.col1 FROM tab2 cor0 GROUP BY col0, cor0.col1

;

SELECT + 61 AS col2 FROM tab1 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT + 24 AS col0 FROM tab0 cor0 GROUP BY col2, col1

;

SELECT ALL - 25 FROM tab2 cor0 GROUP BY cor0.col0, col2

;

SELECT - col0 * + cor0.col0 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT DISTINCT - cor1.col0 * 6 FROM tab2, tab1 AS cor0, tab1 AS cor1 GROUP BY cor1.col0

;

SELECT ALL - - 63 * + cor0.col1 FROM tab1, tab0 AS cor0 GROUP BY cor0.col1

;

SELECT 16 AS col2 FROM tab0 AS cor0 GROUP BY col0

;

SELECT ALL + 58 FROM tab2 AS cor0 GROUP BY cor0.col1

;

SELECT 47 FROM tab2 AS cor0 GROUP BY cor0.col0

;

SELECT + col0 + cor0.col0 FROM tab0 AS cor0 GROUP BY cor0.col0

;

SELECT DISTINCT - cor0.col2 * cor0.col2 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT tab0.col1 + - 50 FROM tab0 GROUP BY col1

;

SELECT ALL col1 * + cor0.col2 + - col2 * col1 - cor0.col1 * cor0.col1 * + cor0.col2 AS col0 FROM tab0 AS cor0 GROUP BY cor0.col1, cor0.col2

;

SELECT cor0.col0 + col0 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col0, cor0.col0

;

SELECT ALL + 94 FROM tab1 AS cor0 GROUP BY col1

;

SELECT + cor0.col2 * cor0.col2 * + cor0.col2 FROM tab1 AS cor0 GROUP BY col2

;

SELECT DISTINCT 28 * cor0.col0 + cor0.col1 * - 25 AS col0 FROM tab1 AS cor0 GROUP BY cor0.col0, cor0.col1

;

SELECT DISTINCT cor0.col2 + 12 FROM tab0 cor0 GROUP BY cor0.col2

;

SELECT - cor0.col2 AS col2 FROM tab1, tab2 AS cor0 GROUP BY cor0.col2

;

SELECT ALL - 63 FROM tab0 AS cor0 GROUP BY cor0.col2

;

SELECT ALL cor0.col2 AS col1 FROM tab0 AS cor0 GROUP BY col0, cor0.col2

;

SELECT DISTINCT + tab0.col1 FROM tab0 GROUP BY col1

;

SELECT ALL + col1 FROM tab1 AS cor0 GROUP BY cor0.col1 HAVING ( NULL ) IS NULL
;

SELECT ALL - col1 AS col1 FROM tab2 AS cor0 GROUP BY cor0.col1

;

