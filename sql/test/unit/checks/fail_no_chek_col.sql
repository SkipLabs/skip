select chek from (select check(2 > 1) as chek, 2 as foo);
--fail, no chek col
