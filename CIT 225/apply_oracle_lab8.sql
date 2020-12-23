-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab8.sql
--  Lab Assignment: Lab #8
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2018
-- ------------------------------------------------------------------
-- Instructions:
-- ------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab8.sql
--
-- ------------------------------------------------------------------

-- Call library files.
@/home/student/Data/cit225/oracle/lab7/apply_oracle_lab7.sql

-- Open log file.
SPOOL apply_oracle_lab8.txt

-- Set the page size.
SET ECHO ON
SET PAGESIZE 999

-- ----------------------------------------------------------------------
--  Step #1 : Add two columns to the RENTAL_ITEM table.
-- ----------------------------------------------------------------------
INSERT INTO price
( price_id
, item_id
, price_type
, active_flag
, start_date
, end_date
, amount
, created_by
, creation_date
, last_updated_by
, last_update_date )
( SELECT price_s1.NEXTVAL
  ,        item_id
  ,        price_type
  ,        active_flag
  ,        start_date
  ,        end_date
  ,        amount
  ,        created_by
  ,        creation_date
  ,        last_updated_by
  ,        last_update_date
  FROM 
    (SELECT   i.item_id
     ,        af.active_flag
     ,        cl.common_lookup_id AS price_type
     ,        cl.common_lookup_type AS price_desc
     ,        CASE
                WHEN (TRUNC(SYSDATE) - i.release_date) <= 30
     		    OR (TRUNC(SYSDATE) - i.release_date) > 30
                AND af.active_flag ='N' THEN To_CHAR(TRUNC(i.release_date), 'DD-MON-YY')
                ELSE 
                To_CHAR(TRUNC(i.release_date)+31, 'DD-MON-YY')           END AS start_date
     ,        CASE
                WHEN  (TRUNC(SYSDATE) - i.release_date) > 30
                AND af.active_flag = 'N' THEN To_CHAR(TRUNC(i.release_date)+30, 'DD-MON-YY')
                ELSE NULL
              END AS end_date
     ,        CASE
                WHEN (TRUNC(SYSDATE)-30)>TRUNC(i.release_date)
                AND af.active_flag ='Y' THEN  CASE
                WHEN cl.COMMON_LOOKUP_TYPE = '1-DAY RENTAL' THEN 1
                WHEN cl.COMMON_LOOKUP_TYPE = '3-DAY RENTAL' THEN 3
                WHEN cl.COMMON_LOOKUP_TYPE = '5-DAY RENTAL' THEN 5
                END
                ELSE  CASE
            WHEN cl.COMMON_LOOKUP_TYPE = '1-DAY RENTAL' THEN 3
            WHEN cl.COMMON_LOOKUP_TYPE = '3-DAY RENTAL' THEN 10
            WHEN cl.COMMON_LOOKUP_TYPE = '5-DAY RENTAL' THEN 15
                END
            END AS amount
     ,        (SELECT system_user_id		       --- created_by
               FROM system_user
               WHERE system_user_name ='DBA2') AS created_by
     ,        (TRUNC(SYSDATE)) AS creation_date
     ,        (SELECT system_user_id		       --- created_by
               FROM system_user
               WHERE system_user_name ='DBA2') AS last_updated_by
     ,        (TRUNC(SYSDATE)) AS last_update_date
     FROM     item i CROSS JOIN
             (SELECT 'Y' AS active_flag FROM dual
              UNION ALL
              SELECT 'N' AS active_flag FROM dual) af CROSS JOIN
             (SELECT '1' AS rental_days FROM dual
              UNION ALL
              SELECT '3' AS rental_days FROM dual
              UNION ALL
              SELECT '5' AS rental_days FROM dual) dr INNER JOIN
              common_lookup cl ON dr.rental_days = SUBSTR(cl.common_lookup_type,1,1)
     WHERE    cl.common_lookup_table = 'PRICE'
     AND      cl.common_lookup_column = 'PRICE_TYPE'
     AND NOT (ACTIVE_FLAG = 'N' AND (TRUNC(SYSDATE)-30) <= TRUNC(i.release_date))));

-- Query the result.
COLUMN type   FORMAT A5   HEADING "Type"
COLUMN 1-Day  FORMAT 9999 HEADING "1-Day"
COLUMN 3-Day  FORMAT 9999 HEADING "3-Day"
COLUMN 5_Day  FORMAT 9999 HEADING "5_Day"
COLUMN total  FORMAT 9999 HEADING "Total"
SELECT  'OLD Y' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND      end_date IS NULL
UNION ALL
SELECT  'OLD N' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND NOT end_date IS NULL
UNION ALL
SELECT  'NEW Y' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND      end_date IS NULL
UNION ALL
SELECT  'NEW N' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND      NOT (end_date IS NULL);

-- ----------------------------------------------------------------------
--  Step #2 : After inserting the data into the PRICE table, you should
--            add the NOT NULL constraint to the PRICE_TYPE column of
--            the PRICE table.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #2 : Add a constraint to PRICE table.
-- ----------------------------------------------------------------------

ALTER TABLE price
MODIFY (price_type  number CONSTRAINT price_con NOT NULL);



-- ----------------------------------------------------------------------
--  Step #2 : Verify the constraint is added to the PRICE table.
-- ----------------------------------------------------------------------
COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'PRICE'
AND      column_name = 'PRICE_TYPE';

-- ----------------------------------------------------------------------
--  Step #3 : After updating the data in the PRICE table with a valid
--            PRICE_TYPE column value, and then apply a NOT NULL
--            constraint.
-- ----------------------------------------------------------------------

COLUMN co_date FORMAT A24 HEADING "Check Out Date"
COLUMN today   FORMAT A24 HEADING "Today Date"
SELECT TO_CHAR(r.check_out_date,'DD-MON-YYYY HH24:MI:DD') AS co_date
,      TO_CHAR(TRUNC(sysdate),'DD-MON-YYYY HH24:MI:DD') AS today
FROM   rental r;

-- Update the RENTAL_ITEM_PRICE column with valid values.
-- ----------------------------------------------------------------------
--   a. The TRUNC(SYSDATE + 1) value guarantees a range match when
--       inputs weren't truncated.
--   b. Change all the entries in the RENTAL table to TRUNC(SYSDATE)
--      values.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #3 : Fix the following update statement.
-- ----------------------------------------------------------------------
UPDATE   rental_item ri
SET      rental_item_price =
          (SELECT   p.amount
           FROM     price p INNER JOIN common_lookup cl1
           ON       p.price_type = cl1.common_lookup_id CROSS JOIN rental r
                    CROSS JOIN common_lookup cl2
           WHERE    p.item_id = ri.item_id
           AND      ri.rental_id = r.rental_id
           AND      ri.rental_item_type = cl2.common_lookup_id
           AND      cl1.common_lookup_code = cl2.common_lookup_code
           AND      r.check_out_date
                      BETWEEN p.start_date AND NVL(p.end_date,TRUNC(SYSDATE) + 1));

-- ----------------------------------------------------------------------
--  Verify #3 : Query the RENTAL_ITEM_PRICE values.
-- ----------------------------------------------------------------------

-- Set to extended linesize value.
SET LINESIZE 9999

-- Format column names.
COL customer_name          FORMAT A20  HEADING "Contact|--------|Customer Name"
COL contact_id             FORMAT 9999 HEADING "Contact|--------|Contact|ID #"
COL customer_id            FORMAT 9999 HEADING "Rental|--------|Customer|ID #"
COL r_rental_id            FORMAT 9999 HEADING "Rental|------|Rental|ID #"
COL ri_rental_id           FORMAT 9999 HEADING "Rental|Item|------|Rental|ID #"
COL rental_item_id         FORMAT 9999 HEADING "Rental|Item|------||ID #"
COL price_item_id          FORMAT 9999 HEADING "Price|------|Item|ID #"
COL rental_item_item_id    FORMAT 9999 HEADING "Rental|Item|------|Item|ID #"
COL rental_item_price      FORMAT 9999 HEADING "Rental|Item|------||Price"
COL amount                 FORMAT 9999 HEADING "Price|------||Amount"
COL price_type_code        FORMAT 9999 HEADING "Price|------|Type|Code"
COL rental_item_type_code  FORMAT 9999 HEADING "Rental|Item|------|Type|Code"
SELECT   c.last_name||', '||c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name
         END AS customer_name
,        c.contact_id
,        r.customer_id
,        r.rental_id AS r_rental_id
,        ri.rental_id AS ri_rental_id
,        ri.rental_item_id
,        p.item_id AS price_item_id
,        ri.item_id AS rental_item_item_id
,        ri.rental_item_price
,        p.amount
,        TO_NUMBER(cl2.common_lookup_code) AS price_type_code
,        TO_NUMBER(cl2.common_lookup_code) AS rental_item_type_code
FROM     price p INNER JOIN common_lookup cl1
ON       p.price_type = cl1.common_lookup_id
AND      cl1.common_lookup_table = 'PRICE'
AND      cl1.common_lookup_column = 'PRICE_TYPE' FULL JOIN rental_item ri
ON       p.item_id = ri.item_id INNER JOIN common_lookup cl2
ON       ri.rental_item_type = cl2.common_lookup_id
AND      cl2.common_lookup_table = 'RENTAL_ITEM'
AND      cl2.common_lookup_column = 'RENTAL_ITEM_TYPE' RIGHT JOIN rental r
ON       ri.rental_id = r.rental_id FULL JOIN contact c
ON       r.customer_id = c.contact_id
WHERE    cl1.common_lookup_code = cl2.common_lookup_code
AND      r.check_out_date
BETWEEN  p.start_date AND NVL(p.end_date,TRUNC(SYSDATE) + 1)
ORDER BY 2, 3;

/*************************************************************
You can verify that the correct customers are configured with the following query. If they don’t show up in your environment with the following query, you made a mistake with the insert into the MEMBER, CONTACT, ADDRESS, STREET_ADDRESS, and TELEPHONE tables.

*************************************************************/

COL customer_name  FORMAT A24  HEADING "Customer Name"
COL city           FORMAT A12  HEADING "City"
COL state          FORMAT A6   HEADING "State"
COL telephone      FORMAT A10  HEADING "Telephone"
SELECT   m.account_number
,        c.last_name||', '||c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name
         END AS customer_name
,        a.city AS city
,        a.state_province AS state
,        t.telephone_number AS telephone
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id;


/*******************************************************
It should return the following rows:

Account
Number	   Customer Name	    City	 State	Telephone
---------- ------------------------ ------------ ------ ----------
B293-71445 Winn, Randi		    San Jose	 CA	111-1111
B293-71445 Winn, Brian		    San Jose	 CA	111-1111
B293-71446 Vizquel, Oscar	    San Jose	 CA	222-2222
B293-71446 Vizquel, Doreen	    San Jose	 CA	222-2222
B293-71447 Sweeney, Meaghan	    San Jose	 CA	333-3333
B293-71447 Sweeney, Matthew	    San Jose	 CA	333-3333
B293-71447 Sweeney, Ian M	    San Jose	 CA	333-3333
R11-514-34 Clinton, Goeffrey Ward   Provo	 Utah	423-1234
R11-514-35 Moss, Wendy		    Provo	 Utah	423-1234
R11-514-36 Gretelz, Simon Jonah     Provo	 Utah	423-1234
R11-514-37 Royal, Elizabeth Jane    Provo	 Utah	423-1234
R11-514-38 Smith, Brian Nathan	    Spanish Fork Utah	423-1234
US00011    Potter, Harry	    Provo	 Utah	333-3333
US00011    Potter, Ginny	    Provo	 Utah	333-3333
US00011    Potter, Lily Luna	    Provo	 Utah	333-3333

******************************************************/


/******************************************************
You can verify that the correct rental and rental items are configured with the following query. If they don’t show up in your environment with the following query, you made a mistake with the insert into the RENTALRENTAL_ITEM tables.
******************************************************/


COL account_number  FORMAT A10  HEADING "Account|Number"
COL customer_name   FORMAT A22  HEADING "Customer Name"
COL rental_id       FORMAT 9999 HEADING "Rental|ID #"
COL rental_item_id  FORMAT 9999 HEADING "Rental|Item|ID #"
SELECT   m.account_number
,        c.last_name||', '||c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name
         END AS customer_name
,        r.rental_id
,        ri.rental_item_id
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN rental r
ON       c.contact_id = r.customer_id INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id
ORDER BY 3, 4;

/*****************************************************************
It should return the following rows:

Rental
Account 			  Rental   Item
Number	   Customer Name	    ID #   ID #
---------- ---------------------- ------ ------
B293-71446 Vizquel, Oscar	    1001   1001
B293-71446 Vizquel, Oscar	    1001   1002
B293-71446 Vizquel, Oscar	    1001   1003
B293-71446 Vizquel, Doreen	    1002   1004
B293-71446 Vizquel, Doreen	    1002   1005
B293-71447 Sweeney, Meaghan	    1003   1006
B293-71447 Sweeney, Ian M	    1004   1007
B293-71445 Winn, Brian		    1005   1008
B293-71445 Winn, Brian		    1005   1009
US00011    Potter, Harry	    1006   1010
US00011    Potter, Harry	    1006   1011
US00011    Potter, Ginny	    1007   1012
US00011    Potter, Lily Luna	    1008   1013
******************************************************************/

/*****************************************************************
You can confirm you’ve updated the correct PRICE_TYPE and RENTAL_ITEM_TYPE foreign keys values with the following query:
******************************************************************/

COL common_lookup_table  FORMAT A12 HEADING "Common|Lookup Table"
COL common_lookup_column FORMAT A18 HEADING "Common|Lookup Column"
COL common_lookup_code   FORMAT 999 HEADING "Common|Lookup|Code"
COL total_pk_count       FORMAT 999 HEADING "Foreign|Key|Count"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        TO_NUMBER(cl.common_lookup_code) AS common_lookup_code
,        COUNT(*) AS total_pk_count
FROM     price p INNER JOIN common_lookup cl
ON       p.price_type = cl.common_lookup_id
AND      cl.common_lookup_table = 'PRICE'
AND      cl.common_lookup_column = 'PRICE_TYPE'
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_code
UNION ALL
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        TO_NUMBER(cl.common_lookup_code) AS common_lookup_code
,        COUNT(*) AS total_pk_count
FROM     rental_item ri INNER JOIN common_lookup cl
ON       ri.rental_item_type = cl.common_lookup_id
AND      cl.common_lookup_table = 'RENTAL_ITEM'
AND      cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_code
ORDER BY 1, 2, 3;

/*******************************************************************
It should return the following values:

Common Foreign
Common	     Common		Lookup	   Key
Lookup Table Lookup Column	  Code	 Count
------------ ------------------ ------ -------
PRICE	     PRICE_TYPE 	     1	    45
PRICE	     PRICE_TYPE 	     3	    45
PRICE	     PRICE_TYPE 	     5	    45
RENTAL_ITEM  RENTAL_ITEM_TYPE	     1	     2
RENTAL_ITEM  RENTAL_ITEM_TYPE	     3	     1
RENTAL_ITEM  RENTAL_ITEM_TYPE	     5	    10
******************************************************************/
/*****************************************************************
The most common error occurs when you insert the wrong start date in the PRICE table. The following query will help you see that type of error:
*****************************************************************/

COL customer_name          FORMAT A20  HEADING "Contact|--------|Customer Name"
COL r_rental_id            FORMAT 9999 HEADING "Rental|------|Rental|ID #"
COL amount                 FORMAT 9999 HEADING "Price|------||Amount"
COL price_type_code        FORMAT 9999 HEADING "Price|------|Type|Code"
COL rental_item_type_code  FORMAT 9999 HEADING "Rental|Item|------|Type|Code"
COL needle                 FORMAT A11  HEADING "Rental|--------|Check Out|Date"
COL low_haystack           FORMAT A11  HEADING "Price|--------|Start|Date"
COL high_haystack          FORMAT A11  HEADING "Price|--------|End|Date"
SELECT   c.last_name||', '||c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name
         END AS customer_name
,        ri.rental_id AS ri_rental_id
,        p.amount
,        TO_NUMBER(cl2.common_lookup_code) AS price_type_code
,        TO_NUMBER(cl2.common_lookup_code) AS rental_item_type_code
,        p.start_date AS low_haystack
,        r.check_out_date AS needle
,        NVL(p.end_date,TRUNC(SYSDATE) + 1) AS high_haystack
FROM     price p INNER JOIN common_lookup cl1
ON       p.price_type = cl1.common_lookup_id
AND      cl1.common_lookup_table = 'PRICE'
AND      cl1.common_lookup_column = 'PRICE_TYPE' FULL JOIN rental_item ri
ON       p.item_id = ri.item_id INNER JOIN common_lookup cl2
ON       ri.rental_item_type = cl2.common_lookup_id
AND      cl2.common_lookup_table = 'RENTAL_ITEM'
AND      cl2.common_lookup_column = 'RENTAL_ITEM_TYPE' RIGHT JOIN rental r
ON       ri.rental_id = r.rental_id FULL JOIN contact c
ON       r.customer_id = c.contact_id
WHERE    cl1.common_lookup_code = cl2.common_lookup_code
AND      p.active_flag = 'Y'
AND NOT  r.check_out_date
           BETWEEN  p.start_date AND NVL(p.end_date,TRUNC(SYSDATE) + 1)
ORDER BY 2, 3;


-- Reset to default linesize value.
SET LINESIZE 80

-- ----------------------------------------------------------------------
--  Step #4 : Add NOT NULL constraint on RENTAL_ITEM_PRICE column
--            of the RENTAL_ITEM table.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #4 : Alter the RENTAL_ITEM table.
-- ----------------------------------------------------------------------

ALTER TABLE rental_item
MODIFY (rental_item_price  number CONSTRAINT rental_item_price_con NOT NULL);




-- ----------------------------------------------------------------------
--  Verify #4 : Add NOT NULL constraint on RENTAL_ITEM_PRICE column
--              of the RENTAL_ITEM table.
-- ----------------------------------------------------------------------
COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'RENTAL_ITEM'
AND      column_name = 'RENTAL_ITEM_PRICE';

SPOOL OFF
