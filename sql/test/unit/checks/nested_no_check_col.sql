select * from (select check(2 > 1) as chek, 2 as foo);
--1 row but no check col
