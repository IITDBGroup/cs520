CREATE TABLE sal (shop TEXT, sales INT, month INT);

INSERT INTO sal VALUES ('chicago', 10 , 1);
INSERT INTO sal VALUES ('chicago', 5 , 2);
INSERT INTO sal VALUES ('chicago', 18 , 3);

COMMIT;

SELECT * FROM sal;

--  shop   | sales | month 
-- ---------+-------+-------
--  chicago |    10 |     1
--  chicago |     5 |     2
--  chicago |    18 |     3
-- (3 rows)

SELECT sum(sales), month FROM sal GROUP BY month;

--  sum | month 
-- -----+-------
--    5 |     2
--   18 |     3
--   10 |     1
-- (3 rows)

INSERT INTO sal VALUES ('schaumburg', 1 , 1);
INSERT INTO sal VALUES ('schaumburg', 2 , 2);
INSERT INTO sal VALUES ('schaumburg', 3 , 3);

SELECT sum(sales), month FROM sal GROUP BY month;

--  sum | month 
-- -----+-------
--    7 |     2
--   21 |     3
--   11 |     1
-- (3 rows)




-- ********************************************************************************
-- * WINDOW FUNCTIONS
-- ********************************************************************************

-- compute an accumulative sum ordering by month without using window functions
WITH msal AS (SELECT sum(sales) AS s, month FROM sal GROUP BY month)
SELECT sum(a.s), b.month FROM msal a, msal b WHERE a.month <= b.month GROUP BY b.month;

--  Sum | month 
-- -----+-------
--   18 |     2
--   39 |     3
--   11 |     1
-- (3 rows)

-- ********************************************************************************
-- * ADVANCED GROUPING
-- ********************************************************************************

-- manual computation of total sales and sales per month (using NULL to make it union compatible)

SELECT sum(sales) AS s, NULL AS month FROM sal UNION ALL (SELECT sum(sales) AS s, month FROM sal GROUP BY month);

--  s  | month 
-- ----+-------
--  39 |      
--   7 |     2
--  21 |     3
--  11 |     1
-- (4 rows)

-- this representation is ambiguous if the group-by attribute(s) have NULL values  
INSERT INTO sal VALUES ('schaumburg', 15 , NULL);
SELECT sum(sales) AS s, NULL AS month FROM sal UNION ALL (SELECT sum(sales) AS s, month FROM sal GROUP BY month)                                                                                       ;

--  s  | month 
-- ----+-------
--  54 |      
--  15 |      
--   7 |     2
--  21 |     3
--  11 |     1
-- (5 rows)

-- solution: create an additional attribute that stores the grouping that was used
SELECT sum(sales) AS s, NULL AS month, '()' AS grp FROM sal UNION ALL (SELECT sum(sales) AS s, month, '(month)' AS grp FROM sal GROUP BY month)                                                        ;

--  s  | month |   grp   
-- ----+-------+---------
--  54 |       | ()
--  15 |       | (month)
--   7 |     2 | (month)
--  21 |     3 | (month)
--  11 |     1 | (month)
-- (5 rows)

-- to make it more efficient and easier to query this information let's use boolean attributes:

SELECT sum(sales) AS s, NULL AS month, 0 AS grpMonth FROM sal UNION ALL (SELECT sum(sales) AS s, month, 1 AS grpMonth FROM sal GROUP BY month)                                                         ;

--  s  | month | grpmonth 
-- ----+-------+----------
--  54 |       |        0
--  15 |       |        1
--   7 |     2 |        1
--  21 |     3 |        1
--  11 |     1 |        1
-- (5 rows)


-- the GROUPING SETS simplifies the specification of such queries
SELECT sum(sales) AS s, month FROM sal GROUP BY GROUPING SETS ((), (month));

--  s  | month 
-- ----+-------
--  54 |      
--  15 |      
--   7 |     2
--  21 |     3
--  11 |     1
-- (5 rows)

-- grouping(attr) resolves the ambiguity mentioned above
SELECT sum(sales) AS s, month, grouping(month) AS grpmonth FROM sal GROUP BY GROUPING SETS ((), (month));

--  s  | month | grpmonth 
-- ----+-------+----------
--  54 |       |        1
--  15 |       |        0
--   7 |     2 |        0
--  21 |     3 |        0
--  11 |     1 |        0
-- (5 rows)


SELECT sum(sales) AS s, month, grouping(month) AS grpmonth, grouping(shop) AS grpshop FROM sal GROUP BY GROUPING SETS (()

--  s  | month | grpmonth | grpshop 
-- ----+-------+----------+---------
--  54 |       |        1 |       1
--  15 |       |        0 |       1
--   7 |     2 |        0 |       1
--  21 |     3 |        0 |       1
--  11 |     1 |        0 |       1
--  33 |       |        1 |       0
--  21 |       |        1 |       0
-- (7 rows)


SELECT sum(sales) AS s, month, grouping(month) AS grpmonth, grouping(shop) AS grpshop FROM sal GROUP BY GROUPING SETS ((), (month), (shop), (month, shop));

--  s  | month | grpmonth | grpshop 
-- ----+-------+----------+---------
--  54 |       |        1 |       1
--  15 |       |        0 |       0
--   5 |     2 |        0 |       0
--   3 |     3 |        0 |       0
--  10 |     1 |        0 |       0
--   1 |     1 |        0 |       0
--  18 |     3 |        0 |       0
--   2 |     2 |        0 |       0
--  15 |       |        0 |       1
--   7 |     2 |        0 |       1
--  21 |     3 |        0 |       1
--  11 |     1 |        0 |       1
--  33 |       |        1 |       0
--  21 |       |        1 |       0
-- (14 rows)


-- CUBE groups on all subsets of the provided set of attributes
SELECT sum(sales) AS s, month, grouping(month) AS grpmonth, grouping(shop) AS grpshop FROM sal GROUP BY CUBE (month, shop);

--  s  | month | grpmonth | grpshop 
-- ----+-------+----------+---------
--  54 |       |        1 |       1
--  15 |       |        0 |       0
--   5 |     2 |        0 |       0
--   3 |     3 |        0 |       0
--  10 |     1 |        0 |       0
--   1 |     1 |        0 |       0
--  18 |     3 |        0 |       0
--   2 |     2 |        0 |       0
--  15 |       |        0 |       1
--   7 |     2 |        0 |       1
--  21 |     3 |        0 |       1
--  11 |     1 |        0 |       1
--  33 |       |        1 |       0
--  21 |       |        1 |       0
-- (14 rows)

