-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab3.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  17-Jan-2018
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  
-- ------------------------------------------------------------------
-- This creates tables, sequences, indexes, and constraints necessary
-- to begin lesson #3. Demonstrates proper process and syntax.
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
--   sql> @apply_oracle_lab3.sql
--
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
--  Cleanup prior installations and run previous lab scripts.
-- ------------------------------------------------------------------
@/home/student/Data/cit225/oracle/lab2/apply_oracle_lab2.sql

-- Open log file.
SPOOL apply_oracle_lab3.txt

-- Enter code below.
-- ------------------------------------------------------------------


/*Step1
Using the following ERD (Entity Relationship Diagram) to write an unfiltered query that returns the
count of the number of rows in the member table. You do that by selecting the result from the COUNT(*)
function. (HINT: The asterisk as an argument to the COUNT function is literally the count of pointers to
disk storage locations, instead of memory locations.)
*/

SELECT COUNT(*)
FROM member;

/***************************************
Step 2
Using the following ERD to write a query that returns the last_name column-values with the results of
the COUNT(*) function. Assign a column alias of total_names to the result of the COUNT(*) function.
Order the return set by the ascending number of last name (non-aggregated) occurrences. (HINT: You
need to use a GROUP BY clause when there is one or more aggregated column combined with one or
more non-aggregated columns in a SELECT-list. The GROUP BY clause lists the (non-aggregated)
last_name column minus any column alias. The ORDER BY clause references the column alias for the
COUNT(*) function instead of the COUNT(*) function itself.)
***************************************/

SELECT last_name, COUNT(*) AS total_names
FROM contact
GROUP BY last_name
ORDER BY total_names ASC;

/**************************************
Step 3
Using the following ERD to write a query that returns the item_rating column-values and the results
of the COUNT(*) function. Assign a column alias of total_names to the COUNT(*) function call. Filter
the results with a WHERE clause. The WHERE clause should filter rows where the item_rating values
match any value in the set of 'G', 'PG', or 'NR'. (HINT: You need to use a GROUP BY clause when there
is one or more aggregated column combined with one or more non-aggregated columns in a SELECT-list.
The GROUP BY clause lists the (non-aggregated) item_rating column minus any column alias. The
ORDER BY clause references the column alias for the COUNT(*) function instead of the COUNT(*)
function itself
**************************************/
SELECT item_rating, COUNT(*) AS total_names
FROM item
WHERE item_rating = 'G' OR item_rating = 'PG' OR item_rating = 'NR'
GROUP BY item_rating
ORDER BY total_names;

/**************************************
Step  4

Using the following ERD to write a query that returns the last_name column-value from the contact
table, the account_number and credit_card_number column-values from the member table, and the
results of the COUNT(*) function. Assign a column alias of total_names to the COUNT(*) function call.
Join the member and contact tables on value matches between the member_id column held by both
tables. Use the GROUP BY clause for all non-aggregated columns and sort the result set in descending
order by the total_names column value. (HINT: Use the ORDER BY clause to sort on the result of the
aggregated column.) Filter the aggregated result set with the HAVING clause. The HAVING clause should
return true when the count of non-aggregated rows is greater than 1. (HINT: This can be done by using a
HAVING clause that compares the COUNT(*) result greater than 1.)
**************************************/
SELECT contact.last_name, member.account_number, member.credit_card_number, COUNT(*) AS total_names
FROM contact
INNER JOIN member ON contact.member_id = member.member_id
GROUP BY contact.last_name,member.account_number, member.credit_card_number
HAVING COUNT(*) > 1
ORDER BY total_names;

/**************************************
Step 5
Using the following ERD to write an unfiltered query that returns the unique last_name , city, and
state_province column-values from a join of the contact and address tables. Join the contact and
address tables based on value matches between the contact_id column values held by both tables.
(HINT: Use the DISTINCT operator in the SELECT-list to sort row results into a unique set.) Use the
ORDER BY clause to sort rows based on the ascending value of the last_name column values.
**************************************/
SELECT DISTINCT contact.last_name, address.city, address.state_province
FROM contact
INNER JOIN address ON contact.contact_id = address.contact_id
ORDER BY contact.last_name ASC;

/***************************************
 Step 6
 Using the following ERD to write a query that returns the unique last_name , area_code, and
telephone_number column-values from the contact and telephone tables. However, there is a trick to
this query’s SELECT-list. The trick requires you to format the area_code and telephone_number
columns into the concatenated string. The format should be: (999) 999-9999. Assign a telephone
column alias to the formatted string. (HINT: Format strings using piped concatenation between the
columns and string literals [for the parentheses and dashes]). Join the contact and telephone tables
based on value matches between the contact_id column held by both tables. The DISTINCT operator
sorts the row into a unique result set composed of all column-values in the SELECT-list. Sort rows based
on the ascending alphabetic values of the last_name column. 
 
***************************************/
SELECT DISTINCT contact.last_name, CONCAT(CONCAT(CONCAT(CONCAT('(',telephone.area_code),')'),' '), telephone.telephone_number)
AS telphone
FROM contact
INNER JOIN telephone
ON contact.contact_id = telephone.contact_id
ORDER BY contact.last_name ASC;

/***************************************
Step 7
Using the following ERD to write a query that returns the common_lookup_id,
common_lookup_context, common_lookup_type, and common_lookup_meaning column values from
the common_lookup table. Filter the result set on the common_lookup_type column-value that matches
any of the following set of values: 'BLU-RAY', 'DVD_FULL_SCREEN', or 'DVD_WIDE_SCREEN'. (HINT:
Use an IN comparison operator in the WHERE clause.) Sort the return set of rows based on the ascending
common_lookup_type column’s values.
***************************************/
COL common_lookup_context FORMAT A12 HEADING "Common|Lookup|Context"
COL common_lookup_type FORMAT A22 HEADING "Common|Lookup Type"
SELECT common_lookup_id,common_lookup_context,common_lookup_type,common_lookup_meaning
FROM common_lookup
WHERE common_lookup_type IN ('BLU-RAY','DVD_FULL_SCREEN','DVD_WIDE_SCREEN')
ORDER BY common_lookup_type ASC;


/**************************************
Step 8
Using the following ERD to write a query that returns the item_title and item_rating column-values
from the item table after joining the item and rental_item tables. Join the two tables on the matching
item_id column-values found in each of the tables. This query uses a WHERE clause to match the
item_type column’s value with one or more of the results from a scalar subquery. Use an IN operator
with the subquery and order the query’s results by the ascending value of the item_title column value.
The subquery selects the common_lookup_id column-value from the common_lookup table where the
column’s value of the common_lookup_type column matches any of the values in the set of: 'BLU-RAY',
'DVD_FULL_SCREEN', and 'DVD_WIDE_SCREEN'. (HINT: You actually wrote this subquery in Step #7
but it returns four columns. You can use the solution to Step #7 as the starting point for a subquery by
removing the three unnecessary columns from original.)
**************************************/
SELECT item.item_title, item.item_rating
FROM item
INNER JOIN rental_item
ON item.item_id = rental_item.item_id
WHERE item.item_type = ANY(
SELECT common_lookup_id
FROM common_lookup
WHERE common_lookup_type IN ('BLU-RAY','DVD_FULL_SCREEN','DVD_WIDE_SCREEN')
)
ORDER BY item.item_title ASC;

/*************************************
Step 9
Using the following ERD to write a query that returns the common_lookup_id,
common_lookup_context, common_lookup_type, and common_lookup_meaning columns from the
common_lookup table; and the count of the credit_card_type column values from the member table.
Assign credit_cards as the column alias to the count of the credit_card_type column values. Join
the member and common_lookup tables by matching the credit_card_type column from the member
table and common_lookup_id column from the common_lookup table. Filter the result set by finding the
common_lookup_type column-values that match one of the following list of values: 'DISCOVER_CARD',
'MASTER_CARD', and 'VISA_CARD'. Group the result set based on the non-aggregated columns.
*************************************/
SELECT common_lookup.common_lookup_id, common_lookup.common_lookup_context, common_lookup.common_lookup_type,
common_lookup.common_lookup_meaning, COUNT(member.credit_card_type) AS credit_cards
FROM common_lookup
INNER JOIN member
ON common_lookup.common_lookup_id = member.credit_card_type
WHERE common_lookup_type IN ('DISCOVER_CARD','MASTER_CARD','VISA_CARD')
GROUP BY common_lookup.common_lookup_id, common_lookup.common_lookup_context, common_lookup.common_lookup_type,
common_lookup.common_lookup_meaning;


/*************************************
STEP 10
*************************************/


SELECT common_lookup.common_lookup_id, common_lookup.common_lookup_context, common_lookup.common_lookup_type,
common_lookup.common_lookup_meaning, COUNT(member.credit_card_type) AS credit_cards
FROM common_lookup
LEFT JOIN member
ON common_lookup.common_lookup_id = member.credit_card_type
WHERE common_lookup_type IN ('DISCOVER_CARD','MASTER_CARD','VISA_CARD')
GROUP BY common_lookup.common_lookup_id, common_lookup.common_lookup_context, common_lookup.common_lookup_type,
common_lookup.common_lookup_meaning
HAVING COUNT(credit_card_type) =0;



-- ------------------------------------------------------------------
-- Enter lab code above.

-- Close log file.
SPOOL OFF
