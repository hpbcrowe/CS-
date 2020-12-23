-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab4.sql
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
--   sql> @apply_oracle_lab4.sql
--
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
--  Cleanup prior installations and run previous lab scripts.
-- ------------------------------------------------------------------
@/home/student/Data/cit225/oracle/lab3/apply_oracle_lab3.sql

-- Open log file.
SPOOL apply_oracle_lab4.txt

-- Enter code below.
-- ------------------------------------------------------------------
/***********************************
Step 1
Using the following ERD to write a query that returns the unique member_id column value from a join
between the member and contact table in the SELECT-list. Join the member and contact table by using
the member_id columns form both tables. Filter the results in the WHERE clause by checking whether
from the last_name column value is a 'Sweeney' string literal. (HINT: Use the DISTINCT operator.)
***********************************/
SET PAGESIZE 99
COL member_id FORMAT 9999 HEADING "Member|ID #"
SELECT DISTINCT member.member_id
FROM member
INNER JOIN contact
ON member.member_id = contact.member_id
WHERE last_name = 'Sweeney';

/************************************
Step 2
Using the following ERD to write a query that returns the non-unique last_name, account_number,
and credit_card_number column values from a join between the contact and member tables. Join the
member and contact table by using the member_id columns form both tables. Filter the results in the
WHERE clause by checking whether from the last_name column value is a case insensitive 'SWEENEY'
string. (HINT: You need to promote the contents of the last_name column to uppercase before making
the comparison.)
************************************/
COL last_name          FORMAT A10 HEADING "Last Name"
COL account_number     FORMAT A10 HEADING "Account|Number"
COL credit_card_number FORMAT A19 HEADING "Credit Card Number"
SELECT contact.last_name, member.account_number, member.credit_card_number
FROM contact
INNER JOIN member
ON contact.member_id = member.member_id
WHERE UPPER(contact.last_name) LIKE 'SWEENEY';

/**************************************
 Step 3
 Using the following ERD, write a query, that returns the unique last_name, account_number, and
credit_card_number column values from a join between the contact and member tables. Join the
member and contact table by using the member_id columns form both tables. Filter the results in the
WHERE clause by checking whether from the last_name column value is a case insensitive 'SWEENEY'
string. (HINT: You should use the DISTINCT operator.)

**************************************/
COL last_name          FORMAT A10 HEADING "Last Name"
COL account_number     FORMAT A10 HEADING "Account|Number"
COL credit_card_number FORMAT A19 HEADING "Credit Card Number"
SELECT DISTINCT contact.last_name, member.account_number, member.credit_card_number
FROM contact
INNER JOIN member
ON contact.member_id = member.member_id
WHERE UPPER(contact.last_name) LIKE 'SWEENEY';

/**************************************
Step 4
Using the following ERD to write a query that returns the unique last_name, account_number,
credit_card_number column values, and a single column concatenated from the city ,
state_province, and postal_code column values. Use a city_address alias for the concatenated
column values, with this format: city, state zip.
Join the member and contact table by using the member_id columns form both tables; and the result of
the first join to the address table by using the contact_id column found in the contact and address
tables. Concatenate the column values with the double pipe concatenation operator (||). Filter the
results in the WHERE clause with a case sensitive 'Vizquel' string. (HINT: Use the DISTINCT operator to
reduce the rows to a unique row set.)
CONCAT(CONCAT(CONCAT(CONCAT('(',telephone.area_code),')'),' '), telephone.telephone_number)
AS telphone
**************************************/
COL last_name          FORMAT A10 HEADING "Last Name"
COL account_number     FORMAT A10 HEADING "Account|Number"
COL credit_card_number FORMAT A19 HEADING "Credit Card Number"
COL address            FORMAT A22 HEADING "Address"
SELECT DISTINCT contact.last_name, member.account_number, member.credit_card_number,
address.city || ',' || address.state_province || ' ' || address.postal_code AS 
city_address
FROM ((contact
INNER JOIN member ON contact.member_id = member.member_id)
INNER JOIN address ON contact.contact_id = address.contact_id)
WHERE last_name LIKE 'Vizquel';

/************************************
Step 5
Using the following ERD to write a query that returns three individual columns and one dynamically
built column through concatenation. The first three columns in the SELECT-list are the last_name,
column from the contact table, and the account_number and credit_card_number columns from the
member table. You create the fourth column by concatenating the street_address column from the
street_address table and the city, state_province, and postal_code columns from the address
table. Assign c_address as a column alias to the concatenated column, which should display like:
 c_address
---------------------
12 El Camino Real +
San Jose, CA 95192
Join the member table to the contact table, the contact table to the address table, and the address
table to the street_address with their respective primary and foreign key column values. Filter the
return set of rows by using the last_name column value where it matches a case sensitive 'Vizquel'
string. Data science often requires encoding these hybrid-type return values in single or double quotes at
the end of any line of text. A utility like Linux’s or macOS’s sed to replace the + symbol with a white
space. The Windows OS requires the use of .NET programming elements or a Node.js solution.
************************************/
COL last_name          FORMAT A12 HEADING "Last Name"
COL account_number     FORMAT A10 HEADING "Account|Number"
COL credit_card_number FORMAT A19 HEADING "Credit Card Number"
COL c_address          FORMAT A22 HEADING "Address"
SELECT DISTINCT contact.last_name, member.account_number, member.credit_card_number,
street_address.street_address || chr(10) ||
address.city || ',' || address.state_province || ' ' || address.postal_code AS 
c_address
FROM (((contact
INNER JOIN member ON contact.member_id = member.member_id)
INNER JOIN address ON contact.contact_id = address.contact_id)
INNER JOIN street_address ON address.address_id = street_address.address_id)
WHERE last_name LIKE 'Vizquel';

/*************************************
Step 6
Using the following ERD to write a query that returns three individual columns and one dynamically
built column through concatenation. The first two columns in the SELECT-list are the last_name,
column from the contact table and the account_number column from the member table. You create the
third column by concatenating the street_address column from the street_address table and the
city, state_province, and postal_code columns from the address table. Assign c_address as a
column alias to the concatenated column, which should display like:
 c_address
---------------------
12 El Camino Real +
San Jose, CA 95192
The fourth column should be a formatted telephone number from the area_code and
telephone_number columns from the telephone table. It should have this format: (999) 999-9999.
Join the member table to the contact table, the contact table to the address table, the address table to
the street_address , and the contact table to the telephone table with their respective primary and
foreign key column values. Filter the return set of rows by using the last_name column value where it
matches a case sensitive 'Vizquel' string
*************************************/
COL last_name          FORMAT A12 HEADING "Last Name"
COL account_number     FORMAT A10 HEADING "Account|Number"
COL c_address          FORMAT A18 HEADING "Address"
COL telephone          FORMAT A14 HEADING "Telephone"
SELECT DISTINCT contact.last_name, member.account_number,
street_address.street_address ||chr(10) ||
address.city || ',' || address.state_province || ' ' || address.postal_code AS 
c_address, CONCAT(CONCAT(CONCAT(CONCAT('(',telephone.area_code),')'),' '), telephone.telephone_number) AS telphone
FROM ((((contact
INNER JOIN member ON contact.member_id = member.member_id)
INNER JOIN address ON contact.contact_id = address.contact_id)
INNER JOIN street_address ON address.address_id = street_address.address_id)
INNER JOIN telephone ON contact.contact_id = telephone.contact_id)
WHERE last_name LIKE 'Vizquel';

/************************************
Step 7
Using the prior ERD from Step #7 re-write the query, to return all 8 member accounts. You simply need
to remove the WHERE clause from the Step #6 query
************************************/
COL last_name      FORMAT A12 HEADING "Last Name"
COL account_number FORMAT A10 HEADING "Account|Number"
COL c_address      FORMAT A24 HEADING "Address"
COL telephone      FORMAT A14 HEADING "Telephone"
SELECT DISTINCT contact.last_name, member.account_number,street_address.street_address || chr(10) ||address.city || ',' || address.state_province || ' ' || address.postal_code AS c_address, '(' || telephone.area_code || ')' || telephone.telephone_number  AS Telephone
FROM ((((contact
INNER JOIN member ON contact.member_id = member.member_id)
INNER JOIN address ON contact.contact_id = address.contact_id)
INNER JOIN street_address ON address.address_id = street_address.address_id)
INNER JOIN telephone ON contact.contact_id = telephone.contact_id)
ORDER BY last_name;

/************************************
Step 8
Using the following ERD to write a query that returns same set of columns as Step #6 and Step #7 but
returns only rows where all membership accounts have rentals. Join the member table to the contact
table, the contact table to the address table, the address table to the street_address , the contact
table to the telephone table, and the contact table to the rental table with their respective primary
and foreign key column values. Primary and foreign key columns share the same column name with one
exception. The customer_id foreign key column of the rental table points to the contact_id primary
key of the contact table.

************************************/
COL last_name      FORMAT A12 HEADING "Last Name"
COL account_number FORMAT A10 HEADING "Account|Number"
COL c_address      FORMAT A24 HEADING "Address"
COL telephone      FORMAT A14 HEADING "Telephone"
SELECT DISTINCT contact.last_name, member.account_number,street_address.street_address || chr(10) ||
address.city || ',' || address.state_province || ' ' || address.postal_code AS 
c_address, '(' || telephone.area_code || ')' || telephone.telephone_number  AS Telephone
FROM (((((contact
INNER JOIN member ON contact.member_id = member.member_id)
INNER JOIN address ON contact.contact_id = address.contact_id)
INNER JOIN street_address ON address.address_id = street_address.address_id)
INNER JOIN telephone ON contact.contact_id = telephone.contact_id)
RIGHT JOIN rental ON contact.contact_id = rental.customer_id)
WHERE rental.check_out_date IS NOT NULL
ORDER BY last_name;

/*********************************************
Step 9
Using the ERD from Step #8, write a query that returns same set of columns as Step #6 and Step #7 but
returns only rows where all membership accounts have no rentals. Join the member table to the contact
table, the contact table to the address table, the address table to the street_address , the contact
table to the telephone table, and the contact table to the rental table with their respective primary
and foreign key column values. Primary and foreign key columns share the same column name with one
exception. The customer_id foreign key column of the rental table points to the contact_id primary
key of the contact table and the join to the rental table should be an outer join that lets you filter rows
where the customer_id value is null.

*********************************************/
COL last_name      FORMAT A12 HEADING "Last Name"
COL account_number FORMAT A10 HEADING "Account|Number"
COL c_address      FORMAT A24 HEADING "Address"
COL telephone      FORMAT A14 HEADING "Telephone"
SELECT DISTINCT last_name, member.account_number,
street_address.street_address || chr(10) || address.city || ',' || address.state_province || ' ' || address.postal_code AS 
c_address, '(' || telephone.area_code || ')' || telephone.telephone_number  AS Telephone
FROM member
INNER JOIN contact ON contact.member_id = member.member_id
INNER JOIN address ON contact.contact_id = address.contact_id
INNER JOIN street_address ON address.address_id = street_address.address_id
INNER JOIN telephone ON (contact.contact_id = telephone.contact_id AND 
address.address_id = telephone.address_id)
LEFT JOIN rental ON contact.contact_id = rental.customer_id
GROUP BY last_name,member.account_number,street_address.street_address, address.city, address.state_province, address.postal_code, telephone.area_code,telephone.telephone_number
HAVING COUNT(rental.customer_id) = 0
ORDER BY last_name;


/***********************************************
Step 10
Join the member table to the contact table, the contact table to the address table, the address table to
the street_address , the contact table to the telephone table, the contact table to the rental table,
the rental table to the rental_item table, and the rental_item table to the item table with their respective
primary and foreign key column values. The exception for foreign key naming is the customer_id,
which is an overriding name for the contact_id that the foreign key references.
Filter the result set in the WHERE clause by using a wildcard string match that finds either 'Stir Wars'
or 'Star Wars' followed by any set of string literal values.

***********************************************/
COL last_name      FORMAT A12 HEADING "Last Name"
COL account_number FORMAT A10 HEADING "Account|Number"
COL c_address      FORMAT A24 HEADING "Address"
COL telephone      FORMAT A14 HEADING "Telephone"
SELECT DISTINCT contact.last_name, member.account_number,'(' || telephone.area_code || ')' || telephone.telephone_number|| chr(10) ||
street_address.street_address || chr(10) ||
address.city || ',' || address.state_province || ' ' || address.postal_code AS 
c_address, item.item_title
FROM (((((((contact
INNER JOIN member ON contact.member_id = member.member_id)
INNER JOIN address ON contact.contact_id = address.contact_id)
INNER JOIN street_address ON address.address_id = street_address.address_id)
INNER JOIN telephone ON contact.contact_id = telephone.contact_id)
INNER JOIN rental ON contact.contact_id = rental.customer_id)
INNER JOIN rental_item ON rental.rental_id = rental_item.rental_id)
INNER JOIN item ON rental_item.rental_item_id = item.item_id)
WHERE item.item_title LIKE 'Stir Wars%' OR item.item_title LIKE 'Star Wars%';

-- ------------------------------------------------------------------
-- Enter lab code above.

-- Close log file.
SPOOL OFF



