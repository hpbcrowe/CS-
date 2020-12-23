-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab5.sql
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
-- to begin lesson #5. Demonstrates proper process and syntax.
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
--   sql> @apply_oracle_lab5.sql
--
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
--  Cleanup prior installations and run previous lab scripts.
-- ------------------------------------------------------------------
@/home/student/Data/cit225/oracle/lab4/apply_oracle_lab4.sql

-- Open log file.
SPOOL apply_oracle_lab5.txt

-- Enter code below.
-- ------------------------------------------------------------------
/**********************************************
step 1 Using the following ERD, write a query (also known as a SELECT statement) that returns the unique
system_user_id column-value from the system_user table where the system_user_name columnvalue in the table is the 'DBA1' string. A query that finds the surrogate key by using the natural key is
called a scalar query. You typically use scalar queries as subqueries to discover a primary key and use it
as a foreign key value.
***********************************************/
COL system_user_id FORMAT 9999 HEADING "System|User|ID #"
SELECT DISTINCT system_user_id
FROM system_user
WHERE system_user_name = 'DBA1';

/************************************************
step 2
Using the following ERD, write a query that returns the system_user_id and system_user_name
column-values from the system_user table where the system_user_name column-value in the table is
the 'DBA1' string. A query that finds the surrogate key by using the natural key is called a scalar query.
You typically use scalar queries as subqueries to discover a primary key and use it as a foreign key
value.
************************************************/
COL system_user_id FORMAT 9999 HEADING "System|User|ID #"
COL system_user_name FORMAT A20 HEADING "System|User|Name"

SELECT DISTINCT system_user_id,system_user_name
FROM system_user
WHERE system_user_name = 'DBA1';

/******************************************************
step 3
Using the following ERD, write a query that returns the system_user_id and system_user_name
column-values from two copies of the system_user table where in the first copy of the system_user
table is given a su1 alias and the second copy is given a su2 alias. Table and view aliases are useful
when you want to disambiguate, or tell the difference between, matching column names from two tables.
However, they are essential when you want to join one copy of a table to another copy of the same table.
This type of join is called a recursive or self-referencing join and it uses one column of the table as a
primary key and another as a foreign key. This self-referencing approach exists in the system_user
table where the created_by and last_updated_by columns hold copies of a value found in the
system_user_id column. These types of foreign keys may hold values that equal the primary key value
of the same row, a different row, or two different rows.
You will return the system_user_id and system_user_name column-values from two copies of the
same table. You must assign the columns different column aliases because two copies of the same
column name can’t co-exist in the same SELECT-list. You should use system_user_id1 and
system_user_name1 for the first copy of the table, and system_user_id2 and system_user_name2 for
the second copy of the table. You will return only one row where the system_user_name column-value
of the first copy of the system_user table equals the 'DBA1' string literal value. You will join the two
copies of the system_user table on the value match between the created_by column from the first
copy with the system_user_id column-value of the second copy of the table.
The loop back one-to-many relationship in the following ERD maps two recursive relationships. One
maps from the created_by column to the system_user_id column and the other maps the
last_updated_by column to the system_user_id column. This query only traverses one of the
recursive relationships.
******************************************************/
COL system_user_id1 FORMAT 9999 HEADING "System User|ID #"
COL system_user_name1 FORMAT A12 HEADING "System User|Name"
COL system_user_id2 FORMAT 9999 HEADING "Created By|System User|ID #"
COL system_user_name2 FORMAT A12 HEADING "Created By|System User|Name"
SELECT su1.system_user_id AS system_user_id1, su1.system_user_name AS system_user_name1, su2.system_user_id AS system_user_id2, su2.system_user_name AS system_user_name2
FROM system_user su1
INNER JOIN system_user su2
ON su1.created_by = su2.system_user_id
WHERE su1.system_user_name = 'DBA1';

/*********************************************************
step 4
Using the following ERD, write a query, that returns three copies of the system_user_id and
system_user_name column-values where the system_user_name value in the first copy of the
system_user table equals a 'DBA1' string literal value.
You will return the system_user_id and system_user_name column-values from two copies of the
same table. You must assign the columns different column aliases because two copies of the same
column name can’t work. You should use system_user_id1 and system_user_name1 for the first copy
of the table, and system_user_id2 and system_user_name2 for the second copy of the table, and
system_user_id3 and system_user_name3 for the second copy of the table. You will return only one
row where the system_user_name column-value of the first copy of the system_user table equals the
'DBA1' string literal value. You will join the first two copies of the system_user table on the value
match between the created_by column from the first copy with the system_user_id column of the
second copy of the table, and then join the result set of the first two copies to the third copy of the table
by using the last_updated_by column from the first copy with the system_user_id column of the
third copy of the table.
The loop back one-to-many relationship in the following ERD maps two recursive relationships. One
maps from the created_by column to the system_user_id column and the other maps the
last_updated_by column to the system_user_id column. This query traverses both of the recursive
relationships

*********************************************************/
COL system_user_id1 FORMAT 9999 HEADING "System User|ID #"
COL system_user_name1 FORMAT A12 HEADING "System User|Name"
COL system_user_id2 FORMAT 9999 HEADING "Created By|System User|ID #"
COL system_user_name2 FORMAT A12 HEADING "Created By|System User|Name"
COL system_user_id3 FORMAT 9999 HEADING "Last|Updated By|System User|ID #"
COL system_user_name3 FORMAT A12 HEADING "Last|Updated By|System User|Name"
SELECT su1.system_user_id AS system_user_id1, su1.system_user_name As system_user_name1, su2.system_user_id AS system_user_id2, su2.system_user_name AS system_user_name2, su3.system_user_id AS system_user_id3, su3.system_user_name AS system_user_name3
FROM system_user su1
INNER JOIN system_user su2 ON su1.created_by = su2.system_user_id
INNER JOIN system_user su3 ON su1.last_updated_by = su3.system_user_id
WHERE su1.system_user_name = 'DBA1';

/***********************************************************
step 5
Using the following ERD, write a query, that returns three copies of the system_user_id and
system_user_name column-values in the SELECT-list. You want to start with the solution to Step #4 and
then remove any where clause from the prior solution to see all rows in the system_user table with who
created and last updated each row.

***********************************************************/
COL system_user_id1 FORMAT 9999 HEADING "System User|ID #"
COL system_user_name1 FORMAT A12 HEADING "System User|Name"
COL system_user_id2 FORMAT 9999 HEADING "Created By|System User|ID #"
COL system_user_name2 FORMAT A12 HEADING "Created By|System User|Name"
COL system_user_id3 FORMAT 9999 HEADING "Last|Updated By|System User|ID #"
COL system_user_name3 FORMAT A12 HEADING "Last|Updated By|System User|Name"
SELECT su1.system_user_id AS system_user_id1, su1.system_user_name As system_user_name1, su2.system_user_id AS system_user_id2, su2.system_user_name AS system_user_name2, su3.system_user_id AS system_user_id3, su3.system_user_name AS system_user_name3
FROM system_user su1
INNER JOIN system_user su2 ON su1.created_by = su2.system_user_id
INNER JOIN system_user su3 ON su1.last_updated_by = su3.system_user_id;

/***************************************************************
step 6
Using the following ERD, write a CREATE statement, that creates a rating_agency table. Before you
create the table, you should run the following command to ensure any previous version of the table is
dropped:
DROP TABLE rating_agency;
You should create the table with the following constraints:
• A primary key constraint pk_rating_agency on the rating_agency_id column.
• A unique constraint uq_rating_agency on the rating_agency_abbr column.
• A foreign key constraint fk_rating_agency_1 on the created_by column that references the
system_user_id in the system_user table.
• A foreign key constraint fk_rating_agency_2 on the last_updated_by column that
references the system_user_id in the system_user table.
• Not null constraints nn_rating_agency_n (where n is an integer from 1 to 6) on the
rating_agency_abbr, rating_agency_name, created_by, creation_date,
last_updated_by, last_update_date columns respectfully.
Unfortunately, the modeling tool doesn’t allow you to rename the primary key column in design mode.
In lieu of PRIMARY, you should use pk_rating_agency for the primary key constraint.
***************************************************************/
DROP TABLE rating_agency;
CREATE TABLE rating_agency
(rating_agency_id integer CONSTRAINT pk_rating_agency PRIMARY KEY,
rating_agency_abbr VARCHAR(4) CONSTRAINT nn_rating_agency_1 NOT NULL,
rating_agency_name VARCHAR(40) CONSTRAINT nn_rating_agency_2 NOT NULL,
created_by integer CONSTRAINT nn_rating_agency_3 NOT NULL,
creation_date DATE CONSTRAINT nn_rating_agency_4 NOT NULL,
last_updated_by integer CONSTRAINT nn_rating_agency_5 NOT NULL,
last_update_date DATE CONSTRAINT nn_rating_agency_6 NOT NULL,
CONSTRAINT uq_rating_agency UNIQUE(rating_agency_abbr),
CONSTRAINT fk_rating_agency_1 FOREIGN KEY(created_by) REFERENCES system_user(system_user_id),
CONSTRAINT fk_rating_agency_2 FOREIGN KEY(last_updated_by) REFERENCES
system_user(system_user_id)
);
DROP SEQUENCE rating_agency_s1;
CREATE SEQUENCE rating_agency_s1
START WITH 1001
INCREMENT BY 1;

/***********************************************************
step 7
Use the prior ERD from Step #6 to write the INSERT statement. You exclude the rating_agency_id
column from the list of columns because it’s using a SERIAL data type. By excluding it from the list of
columns, the database automatically grabs the next value from the associated sequence and consumes it
for the INSERT statement. Naturally, it also increments the sequence for the next INSERT statement.

***********************************************************/
INSERT INTO rating_agency
(rating_agency_id,rating_agency_abbr,rating_agency_name,created_by,creation_date,
last_updated_by,last_update_date)
VALUES
(rating_agency_s1.NEXTVAL,'ESRB','Entertainment Software Rating Board',(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2'),SYSDATE,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2'),SYSDATE);

INSERT INTO rating_agency
(rating_agency_id,rating_agency_abbr,rating_agency_name,created_by,creation_date,
last_updated_by,last_update_date)
VALUES
(rating_agency_s1.NEXTVAL,'MPAA','Motion Picture Association of America',(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2'),SYSDATE,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2'),SYSDATE);
COL rating_agency_id FORMAT 9999 HEADING "Rating|Agency|ID #"
COL rating_agency_abbr FORMAT A6 HEADING "Rating|Agency|Abbr"
COL rating_agency_name FORMAT A40 HEADING "Rating Agency"
SELECT rating_agency_id
, rating_agency_abbr
, rating_agency_name
FROM rating_agency;

/**************************************************************
step 8
Using the following ERD, write a CREATE statement, that creates a rating table. Before you create the
table, you should run the following command to ensure any previous version of the table is dropped:
DROP TABLE rating;
You should create the table with the following constraints:
• A primary key constraint pk_rating on the rating_id column.
• A unique constraint uq_rating on the rating column.
• A foreign key constraint fk_rating_1 on the created_by column that references the
system_user_id in the system_user table.
• A foreign key constraint fk_rating_2 on the last_updated_by column that references the
system_user_id in the system_user table.
• Not null constraints nn_rating_n (where n is an integer from 1 to 7) on the rating_agency_id,
rating, description, created_by, creation_date, last_updated_by, last_update_date
columns respectfully.
**************************************************************/
DROP TABLE rating;
CREATE TABLE rating
(rating_id integer CONSTRAINT pk_rating PRIMARY KEY,
 rating_agency_id integer CONSTRAINT nn_rating_1 NOT NULL, 
 rating VARCHAR(15) CONSTRAINT nn_rating_2 NOT NULL,
 description VARCHAR(420) CONSTRAINT nn_rating_3 NOT NULL,
 created_by integer CONSTRAINT nn_rating_4 NOT NULL,
 creation_date DATE CONSTRAINT nn_rating_5 NOT NULL,
 last_updated_by integer CONSTRAINT nn_rating_6 NOT NULL,
 last_update_date DATE CONSTRAINT nn_rating_7 NOT NULL,
 CONSTRAINT uq_rating UNIQUE(rating),
 CONSTRAINT fk_rating_1 FOREIGN KEY(created_by) REFERENCES system_user(system_user_id),
 CONSTRAINT fk_rating_2 FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id)
); 
DROP SEQUENCE rating_s1;
CREATE SEQUENCE rating_s1
START WITH 1001
INCREMENT BY 1;
--ESRB RATINGS
INSERT INTO rating
(rating_id, rating_agency_id, rating, description, created_by, creation_date,
last_updated_by, last_update_date)
VALUES
(rating_s1.NEXTVAL, (SELECT rating_agency_id FROM rating_agency WHERE
rating_agency_abbr = 'ESRB'), 'EC', 'Early Childhood', (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE, (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE);
INSERT INTO rating
(rating_id, rating_agency_id, rating, description, created_by, creation_date,
last_updated_by, last_update_date)
VALUES
(rating_s1.NEXTVAL, (SELECT rating_agency_id FROM rating_agency WHERE
rating_agency_abbr = 'ESRB'), 'E', 'Everyone', (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE, (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE);
INSERT INTO rating
(rating_id, rating_agency_id, rating, description, created_by, creation_date,
last_updated_by, last_update_date)
VALUES
(rating_s1.NEXTVAL, (SELECT rating_agency_id FROM rating_agency WHERE
rating_agency_abbr = 'ESRB'), 'E10+', 'Everyone 10+', (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE, (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE);
INSERT INTO rating
(rating_id, rating_agency_id, rating, description, created_by, creation_date,
last_updated_by, last_update_date)
VALUES
(rating_s1.NEXTVAL, (SELECT rating_agency_id FROM rating_agency WHERE
rating_agency_abbr = 'ESRB'), 'T', 'Teen', (SELECT system_user_id FROM system_user
WHERE system_user_name = 'DBA2'), SYSDATE, (SELECT system_user_id FROM system_user
WHERE system_user_name = 'DBA2'), SYSDATE);
INSERT INTO rating
(rating_id, rating_agency_id, rating, description, created_by, creation_date,
last_updated_by, last_update_date)
VALUES
(rating_s1.NEXTVAL, (SELECT rating_agency_id FROM rating_agency WHERE
rating_agency_abbr = 'ESRB'), 'M', 'Mature', (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE, (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE);
INSERT INTO rating
(rating_id, rating_agency_id, rating, description, created_by, creation_date,
last_updated_by, last_update_date)
VALUES
(rating_s1.NEXTVAL, (SELECT rating_agency_id FROM rating_agency WHERE
rating_agency_abbr = 'ESRB'), 'AO', 'Adult Only', (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE, (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE);
INSERT INTO rating
(rating_id, rating_agency_id, rating, description, created_by, creation_date,
last_updated_by, last_update_date)
VALUES
(rating_s1.NEXTVAL, (SELECT rating_agency_id FROM rating_agency WHERE
rating_agency_abbr = 'ESRB'), 'RP', 'Rating Pending', (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE, (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE);
--MPAA RATINGS
INSERT INTO rating
(rating_id, rating_agency_id, rating, description, created_by, creation_date,
last_updated_by, last_update_date)
VALUES
(rating_s1.NEXTVAL, (SELECT rating_agency_id FROM rating_agency WHERE
rating_agency_abbr = 'MPAA'), 'G', 'General Audiences', (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE, (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE);
INSERT INTO rating
(rating_id, rating_agency_id, rating, description, created_by, creation_date,
last_updated_by, last_update_date)
VALUES
(rating_s1.NEXTVAL, (SELECT rating_agency_id FROM rating_agency WHERE
rating_agency_abbr = 'MPAA'), 'PG', 'Parental Guidance Suggested', (SELECT
system_user_id FROM system_user WHERE system_user_name = 'DBA2'), SYSDATE, (SELECT
system_user_id FROM system_user WHERE system_user_name = 'DBA2'), SYSDATE);
INSERT INTO rating
(rating_id, rating_agency_id, rating, description, created_by, creation_date,
last_updated_by, last_update_date)
VALUES
(rating_s1.NEXTVAL, (SELECT rating_agency_id FROM rating_agency WHERE
rating_agency_abbr = 'MPAA'), 'PG-13', 'Parental Guidance Strongly Suggested',
(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2'), SYSDATE,
(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2'), SYSDATE);
INSERT INTO rating
(rating_id, rating_agency_id, rating, description, created_by, creation_date,
last_updated_by, last_update_date)
VALUES
(rating_s1.NEXTVAL, (SELECT rating_agency_id FROM rating_agency WHERE
rating_agency_abbr = 'MPAA'), 'NC-17', 'No One 17 And Under Admitted', (SELECT
system_user_id FROM system_user WHERE system_user_name = 'DBA2'), SYSDATE, (SELECT
system_user_id FROM system_user WHERE system_user_name = 'DBA2'), SYSDATE);
INSERT INTO rating
(rating_id, rating_agency_id, rating, description, created_by, creation_date,
last_updated_by, last_update_date)
VALUES
(rating_s1.NEXTVAL, (SELECT rating_agency_id FROM rating_agency WHERE
rating_agency_abbr = 'MPAA'), 'R', 'Restricted', (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE, (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE);
INSERT INTO rating
(rating_id, rating_agency_id, rating, description, created_by, creation_date,
last_updated_by, last_update_date)
VALUES
(rating_s1.NEXTVAL, (SELECT rating_agency_id FROM rating_agency WHERE
rating_agency_abbr = 'MPAA'), 'NR', 'Not Rated', (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE, (SELECT system_user_id FROM
system_user WHERE system_user_name = 'DBA2'), SYSDATE);
UPDATE item SET item_rating = 'E' where item_rating = 'Everyone';
UPDATE item SET item_rating = 'T' where item_rating = 'Teen';
UPDATE item SET item_rating = 'M' where item_rating = 'Mature';
UPDATE item SET item_rating = 'PG-13' where item_rating = 'PG13';

/********************************************************
step 9
Using the Step #8 ERD, write an ALTER statement. It should add a new rating_id column to the item
table. After adding the rating_id column to the item table, you should use an UPDATE statement to
populate the rating_id column with the correct foreign key values. You can use a correlated UPDATE
statement to update the rating_id column-values. A correlated UPDATE statement uses a subquery as
the right operand in a SET clause, like
UPDATE subordinate_table_name t
SET t.foreign_key_column =
 ( SELECT st.primary_key_column
 FROM superior_table_name st
 WHERE st.natural_key_column = t.existing_column );
********************************************************/
SET LINESIZE 600
ALTER TABLE item 
ADD rating_id INT;
ALTER TABLE item
ADD CONSTRAINT rating_id FOREIGN KEY(rating_id)
REFERENCES rating(rating_id);
 UPDATE item 
 SET item.rating_id =
 (SELECT rating.rating_id
 FROM rating
 WHERE item.item_rating =rating.rating);
 
COL fk FORMAT 9999 HEADING "Item|------||Foreign|Key #"
COL irating FORMAT A15 HEADING "Item|----------||Non-unique|Rating"
COL counter FORMAT 9999 HEADING "Item|----------|Count|Non-unique|Rating"
COL pk FORMAT 9999 HEADING "Rating|------||Primary|Key #"
COL pk_abbr FORMAT A6 HEADING "Rating|Agency|------||Unique|Agency"
COL rating FORMAT A15 HEADING "Rating|------||Unique|Rating"
SELECT item.rating_id AS fk, item.item_rating AS irating, COUNT(item.item_rating) AS counter, rating.rating_agency_id AS pk, rating_agency.rating_agency_abbr AS 
pk_abbr, rating.rating AS rating
FROM item
INNER JOIN rating ON item.rating_id = rating.rating_id
INNER JOIN rating_agency ON rating.rating_agency_id = rating_agency.rating_agency_id
GROUP BY item.rating_id, item.item_rating, rating.rating_agency_id, rating_agency.rating_agency_abbr, rating.rating
ORDER BY item.rating_id;
ALTER TABLE item
MODIFY (rating_id INT CONSTRAINT rating_null NOT NULL);
ALTER TABLE item
DROP (item_rating);

/*******************************************************
step 10
Using the following ERD, write the query, to return the results from the member, contact, rental,
rental_item, item, rating, and rating_agency tables. The SELECT-list will display:
• 1st column should be the account_number from the member table.
• 2nd column should return the last_name column from the contact table.
• 3rd column should return the item_title column from the item table.
• 4th column should return the rating_agency_abbr from the rating_agency table.
• 5th column should return the rating column from the rating table.
Join the member and contact table by using the member_id column in both tables.
Join the result set to the rental table by using the contact_id column from the contact
table and the customer_id column from the rental table.
• Join the result set to the rental_item table by using the rental_id column from the
rental and rental_item tables.
• Join the result set to the item table by using the item_id column from the rental_item
and item tables.
• Join the result set to the rating table by using the rating_id column from the item and
rating tables.
• Join the result set to the rating_agency table by using the rating_agency_id column
from the rating and rating_agency tables.
*******************************************************/
COL account_number FORMAT A10 HEADING "Account|Number"
COL last_name FORMAT A10 HEADING "Last Name"
COL item_title FORMAT A24 HEADING "Item Title"
COL rating_agency_abbr FORMAT A6 HEADING "Rating|Agency|Abbr"
COL rating FORMAT A10 HEADING "Rating"
SELECT member.account_number, contact.last_name, item.item_title, rating_agency.rating_agency_abbr, rating.rating
FROM member
INNER JOIN contact ON member.member_id = contact.member_id
INNER JOIN rental ON contact.contact_id = rental.customer_id
INNER JOIN rental_item ON rental.rental_id = rental_item.rental_id
INNER JOIN item ON rental_item.item_id = item.item_id
INNER JOIN rating ON item.rating_id = rating.rating_id
INNER JOIN rating_agency ON rating.rating_agency_id = rating_agency.rating_agency_id;


-----------------------------------------------------------------
-- Enter lab code above.

-- Close log file.
SPOOL OFF
