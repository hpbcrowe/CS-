-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab9.sql
--  Lab Assignment: Lab #9
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2010
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
--   sql> @apply_oracle_lab9.sql
--
-- ------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab8/apply_oracle_lab8.sql

-- Open log file.
SPOOL apply_oracle_lab9.txt

-- Set the page size.
SET ECHO ON
SET PAGESIZE 999

-- ----------------------------------------------------------------------
--  Step #1 : Create the TRANSACTION table.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #1a : Create the TRANSACTION table and TRANSACTION_S1 sequence.
-- ----------------------------------------------------------------------

-- Conditionally drop the TRANSACTION table.
BEGIN
  FOR i IN (SELECT table_name
            FROM   user_tables
            WHERE  table_name = 'TRANSACTION') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT sequence_name
            FROM   user_sequences
            WHERE  sequence_name = 'TRANSACTION_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE '||i.sequence_name;
  END LOOP;
END;
/

-- ----------------------------------------------------------------------
--  Step #1 : Create the TRANSACTION table.
-- ----------------------------------------------------------------------
-- Create the TRANSACTION table.

/********************************************************
CREATE TABLE sample
( sample_id     NUMBER
, sample_text   VARCHAR2(30)
, sample_date   DATE
, sample_amount NUMBER(6,2));

*******************************************************/
CREATE TABLE TRANSACTION
(TRANSACTION_ID NUMBER(22) CONSTRAINT transaction_pk PRIMARY KEY
,TRANSACTION_ACCOUNT VARCHAR2(15) CONSTRAINT nn_transaction_1 NOT NULL
,TRANSACTION_TYPE NUMBER(22) CONSTRAINT nn_transaction_2 NOT NULL
,TRANSACTION_DATE  DATE CONSTRAINT nn_transaction_3 NOT NULL
,TRANSACTION_AMOUNT NUMBER(22) CONSTRAINT nn_transaction_4 NOT NULL
,RENTAL_ID NUMBER(22) CONSTRAINT nn_transaction_5 NOT NULL
,PAYMENT_METHOD_TYPE NUMBER(22) CONSTRAINT nn_transaction_6 NOT NULL
,PAYMENT_ACCOUNT_NUMBER VARCHAR2(19) CONSTRAINT nn_transaction_7 NOT NULL
,CREATED_BY NUMBER(22) CONSTRAINT nn_transaction_8 NOT NULL
,CREATION_DATE DATE CONSTRAINT nn_transaction_9 NOT NULL
,LAST_UPDATED_BY NUMBER(22) CONSTRAINT nn_transaction_10 NOT NULL
,LAST_UPDATE_DATE DATE CONSTRAINT nn_transaction_11 NOT NULL
,CONSTRAINT fk_transaction_1 FOREIGN KEY(TRANSACTION_TYPE) REFERENCES COMMON_LOOKUP(COMMON_LOOKUP_ID)
,CONSTRAINT fk_transaction_2 FOREIGN KEY(RENTAL_ID) REFERENCES RENTAL(RENTAL_ID)
,CONSTRAINT fk_transaction_3 FOREIGN KEY(PAYMENT_METHOD_TYPE) REFERENCES COMMON_LOOKUP(COMMON_LOOKUP_ID)
,CONSTRAINT fk_transaction_4 FOREIGN KEY (CREATED_BY) REFERENCES SYSTEM_USER(SYSTEM_USER_ID)
,CONSTRAINT fk_transaction_5 FOREIGN KEY (LAST_UPDATED_BY) REFERENCES
SYSTEM_USER(SYSTEM_USER_ID)
);


-- ----------------------------------------------------------------------
--  Step #1 : Create the TRANSACTION sequence.
-- ----------------------------------------------------------------------
CREATE SEQUENCE transaction_s1
START WITH 1;



-- ----------------------------------------------------------------------
--  Verify #1a : Check the TRANSACTION table and TRANSACTION_S1 sequence.
-- ----------------------------------------------------------------------
-- Query table structure.
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'TRANSACTION'
ORDER BY 2;

-- ----------------------------------------------------------------------
--  Step #1b : Create the TRANSACTION table's natural key index.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #1 : Create the NATURAL_KEY index on the TRANSACTION table.
-- ----------------------------------------------------------------------

CREATE UNIQUE INDEX natural_key
ON TRANSACTION(RENTAL_ID
,TRANSACTION_TYPE
,TRANSACTION_DATE
,PAYMENT_METHOD_TYPE
,PAYMENT_ACCOUNT_NUMBER
,TRANSACTION_ACCOUNT);



-- ----------------------------------------------------------------------
--  Verify #1b : Query the TRANSACTION table's natural key index.
-- ----------------------------------------------------------------------
COLUMN table_name       FORMAT A12
COLUMN index_name       FORMAT A16
COLUMN uniqueness       FORMAT A8
COLUMN column_position  FORMAT 9999
COLUMN column_name      FORMAT A24
SELECT   i.table_name
,        i.index_name
,        i.uniqueness
,        ic.column_position
,        ic.column_name
FROM     user_indexes i INNER JOIN user_ind_columns ic
ON       i.index_name = ic.index_name
WHERE    i.table_name = 'TRANSACTION'
AND      i.uniqueness = 'UNIQUE'
AND      i.index_name = 'NATURAL_KEY';

-- ----------------------------------------------------------------------
--  Step #2 : Insert new rows in COMMON_LOOKUP table.
-- ----------------------------------------------------------------------
/************************************************************************
You insert the six rows by using the following instructions.

Table Name: COMMON_LOOKUP
Lookup Table	Lookup Column	Lookup Type	Lookup Meaning	Lookup Code
TRANSACTION	TRANSACTION_TYPE	CREDIT	Credit	CR
TRANSACTION	TRANSACTION_TYPE	DEBIT	Debit	DR
TRANSACTION	PAYMENT_METHOD_TYPE	DISCOVER_CARD	Discover Card	
TRANSACTION	PAYMENT_METHOD_TYPE	VISA_CARD	Visa Card	
TRANSACTION	PAYMENT_METHOD_TYPE	MASTER_CARD	Master Card	
TRANSACTION	PAYMENT_METHOD_TYPE	CASH	Cash
INSERT INTO common_lookup
  2  VALUES
  3    (common_lookup_s1.nextval
  4  	,'3-DAY RENTAL'
  5  	,'3-Day Rental'
  6  	,1001
  7  	,SYSDATE
  8  	,1001
  9  	,SYSDATE
 10  	,'PRICE'
 11  	,'PRICE_TYPE'
 12  	,3);
 COMMON_LOOKUP_ID                                     NOT NULL NUMBER
 COMMON_LOOKUP_TYPE                                   NOT NULL VARCHAR2(30)
 COMMON_LOOKUP_MEANING                                NOT NULL VARCHAR2(30)
 CREATED_BY                                           NOT NULL NUMBER
 CREATION_DATE                                        NOT NULL DATE
 LAST_UPDATED_BY                                      NOT NULL NUMBER
 LAST_UPDATE_DATE                                     NOT NULL DATE
 COMMON_LOOKUP_TABLE                                  NOT NULL VARCHAR2(30)
 COMMON_LOOKUP_COLUMN                                 NOT NULL VARCHAR2(30)
 COMMON_LOOKUP_CODE  
 
 
 
************************************************************************/
INSERT INTO common_lookup
VALUES
(common_lookup_s1.nextval
,'CREDIT'
,'Credit'
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,'TRANSACTION'
,'TRANSACTION_TYPE'
,'CR');

INSERT INTO common_lookup
VALUES
(common_lookup_s1.nextval
,'DEBIT'
,'Debit'
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,'TRANSACTION'
,'TRANSACTION_TYPE'
,'DR');

INSERT INTO common_lookup
VALUES
(common_lookup_s1.nextval
,'DISCOVER_CARD'
,'Discover Card'
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,'TRANSACTION'
,'PAYMENT_METHOD_TYPE'
,NULL);

INSERT INTO common_lookup
VALUES
(common_lookup_s1.nextval
,'VISA_CARD'
,'Visa Card'
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,'TRANSACTION'
,'PAYMENT_METHOD_TYPE'
,NULL);

INSERT INTO common_lookup
VALUES
(common_lookup_s1.nextval
,'MASTER_CARD'
,'Master Card'
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,'TRANSACTION'
,'PAYMENT_METHOD_TYPE'
,NULL);

INSERT INTO common_lookup
VALUES
(common_lookup_s1.nextval
,'CASH'
,'Cash'
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,'TRANSACTION'
,'PAYMENT_METHOD_TYPE'
,NULL);



-- ----------------------------------------------------------------------
--  Verify #2 : Insert new rows in COMMON_LOOKUP table.
-- ----------------------------------------------------------------------
COLUMN common_lookup_id     FORMAT 9999 HEADING "Lookup|ID #"
COLUMN common_lookup_table  FORMAT A18  HEADING "Lookup|Table"
COLUMN common_lookup_column FORMAT A20  HEADING "Lookup|Column"
COLUMN common_lookup_type   FORMAT A14  HEADING "Lookup|Type"
COLUMN common_lookup_code   FORMAT A8   HEADING "Lookup|Code"
SELECT common_lookup_id
,      common_lookup_table
,      common_lookup_column
,      common_lookup_type
,      common_lookup_code
FROM   common_lookup
WHERE  common_lookup_table IN ('TRANSACTION','PAYMENT_METHOD_TYPE');

-- ----------------------------------------------------------------------
--  Step #3a : Create and seed AIRPORT and ACCOUNT_LIST tables.
-- ----------------------------------------------------------------------
BEGIN
  FOR i IN (SELECT table_name
            FROM   user_tables
            WHERE  table_name = 'AIRPORT') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT sequence_name
            FROM   user_sequences
            WHERE  sequence_name = 'AIRPORT_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE '||i.sequence_name;
  END LOOP;
END;
/

-- ----------------------------------------------------------------------
--  Step #3a : Create the AIRPORT table.
-- ----------------------------------------------------------------------
CREATE TABLE AIRPORT
(AIRPORT_ID NUMBER(22) CONSTRAINT airport_pk PRIMARY KEY
,AIRPORT_CODE VARCHAR2(3) CONSTRAINT airport_nn_1 NOT NULL
,AIRPORT_CITY VARCHAR2(30) CONSTRAINT airport_nn_2 NOT NULL
,CITY  VARCHAR2(30) CONSTRAINT airport_nn_3 NOT NULL
,STATE_PROVINCE VARCHAR2(30) CONSTRAINT airport_nn_4 NOT NULL
,CREATED_BY NUMBER(22) CONSTRAINT airport_nn_5 NOT NULL
,CREATION_DATE DATE CONSTRAINT airport_nn_6 NOT NULL
,LAST_UPDATED_BY NUMBER(22) CONSTRAINT airport_nn_7 NOT NULL
,LAST_UPDATE_DATE DATE CONSTRAINT airport_nn_8 NOT NULL
,CONSTRAINT fk_airport_1 FOREIGN KEY(CREATED_BY) REFERENCES SYSTEM_USER(SYSTEM_USER_ID)
,CONSTRAINT fk_airport_2 FOREIGN KEY(LAST_UPDATED_BY) REFERENCES
SYSTEM_USER(SYSTEM_USER_ID));




-- ----------------------------------------------------------------------
--  Step #3a : Create the AIRPORT sequence.
-- ----------------------------------------------------------------------
CREATE SEQUENCE airport_s1
START WITH 1;



-- ----------------------------------------------------------------------
--  Verify #3a : Create and seed AIRPORT and ACCOUNT_LIST tables.
-- ----------------------------------------------------------------------
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'AIRPORT'
ORDER BY 2;

-- ----------------------------------------------------------------------
--  Step #3b : Create natural key index on the AIRPORT table.
-- ----------------------------------------------------------------------

CREATE UNIQUE INDEX NK_AIRPORT
ON AIRPORT(AIRPORT_CODE
,AIRPORT_CITY
,CITY
,STATE_PROVINCE);




-- ----------------------------------------------------------------------
--  Verify #3b : Verify the quality of the natural key index.
-- ----------------------------------------------------------------------
COLUMN table_name       FORMAT A12
COLUMN index_name       FORMAT A16
COLUMN uniqueness       FORMAT A8
COLUMN column_position  FORMAT 9999
COLUMN column_name      FORMAT A24
SELECT   i.table_name
,        i.index_name
,        i.uniqueness
,        ic.column_position
,        ic.column_name
FROM     user_indexes i INNER JOIN user_ind_columns ic
ON       i.index_name = ic.index_name
WHERE    i.table_name = 'AIRPORT'
AND      i.uniqueness = 'UNIQUE'
AND      i.index_name = 'NK_AIRPORT';

-- ----------------------------------------------------------------------
--  Step #3c : Insert rows into the AIRPORT table.
-- ----------------------------------------------------------------------
/***********************************************************************
Table Name     Column ID Column Name            Nullable Data Type
-------------- --------- ---------------------- -------- ------------
AIRPORT                1 AIRPORT_ID             NOT NULL NUMBER(22)
AIRPORT                2 AIRPORT_CODE           NOT NULL VARCHAR2(3)
AIRPORT                3 AIRPORT_CITY           NOT NULL VARCHAR2(30)
AIRPORT                4 CITY                   NOT NULL VARCHAR2(30)
AIRPORT                5 STATE_PROVINCE         NOT NULL VARCHAR2(30)
AIRPORT                6 CREATED_BY             NOT NULL NUMBER(22)
AIRPORT                7 CREATION_DATE          NOT NULL DATE
AIRPORT                8 LAST_UPDATED_BY        NOT NULL NUMBER(22)
AIRPORT                9 LAST_UPDATE_DATE       NOT NULL DATE
LAX	Los Angeles	Los Angeles	California
SLC	Salt Lake City	Provo	Utah
SLC	Salt Lake City	Spanish Fork	Utah
SFO	San Francisco	San Francsico	California
SJC	San Jose	San Jose	California
SJC	San Jose	San Carlos	California
***********************************************************************/
INSERT INTO AIRPORT
VALUES
(airport_s1.nextval
,'LAX'
,'Los Angeles'
,'Los Angeles'
,'California'
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE);

INSERT INTO AIRPORT
VALUES
(airport_s1.nextval
,'SLC'
,'Salt Lake City'
,'Provo'
,'Utah'
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE);

INSERT INTO AIRPORT
VALUES
(airport_s1.nextval
,'SLC'
,'Salt Lake City'
,'Spanish Fork'
,'Utah'
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE);

INSERT INTO AIRPORT
VALUES
(airport_s1.nextval
,'SFO'
,'San Francisco'
,'San Francisco'
,'California'
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE);


INSERT INTO AIRPORT
VALUES
(airport_s1.nextval
,'SJC'
,'San Jose'
,'San Jose'
,'California'
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE);

INSERT INTO AIRPORT
VALUES
(airport_s1.nextval
,'SJC'
,'San Jose'
,'San Carlos'
,'California'
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE
,(SELECT system_user_id FROM system_user WHERE system_user_name = 'DBA2')
,SYSDATE);



-- ----------------------------------------------------------------------
--  Verify #3c : Insert rows into the AIRPORT table.
-- ----------------------------------------------------------------------
COLUMN code           FORMAT A6  HEADING "Code"
COLUMN airport_city   FORMAT A16 HEADING "Airport City"
COLUMN city           FORMAT A16 HEADING "City"
COLUMN state_province FORMAT A12 HEADING "State or|Province"
SELECT   airport_code AS code
,        airport_city
,        city
,        state_province
FROM     airport;

-- Conditionally drop table.
BEGIN
  FOR i IN (SELECT table_name
            FROM   user_tables
            WHERE  table_name = 'ACCOUNT_LIST') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT sequence_name
            FROM   user_sequences
            WHERE  sequence_name = 'ACCOUNT_LIST_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE '||i.sequence_name;
  END LOOP;
END;
/

-- ----------------------------------------------------------------------
--  Step #3d : Create the ACCOUNT_LIST table.
-- ----------------------------------------------------------------------
CREATE TABLE ACCOUNT_LIST
(ACCOUNT_LIST_ID NUMBER(22) CONSTRAINT account_list_pk PRIMARY KEY
,ACCOUNT_NUMBER VARCHAR2(10) CONSTRAINT account_list_nn_1 NOT NULL
,CONSUMED_DATE DATE
,CONSUMED_BY NUMBER(22)
,CREATED_BY NUMBER(22) CONSTRAINT account_list_nn_2 NOT NULL
,CREATION_DATE DATE CONSTRAINT account_list_nn_3 NOT NULL
,LAST_UPDATED_BY NUMBER(22) CONSTRAINT account_list_nn_4 NOT NULL
,LAST_UPDATE_DATE DATE CONSTRAINT account_list_nn_5 NOT NULL
,CONSTRAINT fk_account_1 FOREIGN KEY(CONSUMED_BY) REFERENCES SYSTEM_USER(SYSTEM_USER_ID)
,CONSTRAINT fk_account_2 FOREIGN KEY(CREATED_BY) REFERENCES SYSTEM_USER(SYSTEM_USER_ID)
,CONSTRAINT fk_account_3 FOREIGN KEY(LAST_UPDATED_BY) REFERENCES SYSTEM_USER(SYSTEM_USER_ID));




-- ----------------------------------------------------------------------
--  Step #3d : Create the ACCOUNT_LIST sequence.
-- ----------------------------------------------------------------------

CREATE SEQUENCE account_list_s1
START WITH 1;



-- ----------------------------------------------------------------------
--  Verify #3d : Check the ACCOUNT_LIST table.
-- ----------------------------------------------------------------------
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ACCOUNT_LIST'
ORDER BY 2;

-- ----------------------------------------------------------------------
--  Step #3e : Seed the ACCOUNT_LIST table.
-- ----------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE seed_account_list IS

  /* Declare variable to capture table, and column. */
  lv_table_name   VARCHAR2(90);
  lv_column_name  VARCHAR2(30);

  /* Declare an exception variable and PRAGMA map. */
  not_null_column  EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_null_column,-1400);

BEGIN
  /* Set savepoint. */
  SAVEPOINT all_or_none;

  /* Read a distinct list of airport codes. */
  FOR i IN (SELECT DISTINCT airport_code FROM airport) LOOP
    FOR j IN 1..50 LOOP
      INSERT INTO account_list
      VALUES
      ( account_list_s1.NEXTVAL
      , i.airport_code||'-'||LPAD(j,6,'0')
      , null
      , null
      , 1002
      , SYSDATE
      , 1002
      , SYSDATE);
    END LOOP;
  END LOOP;

  /* Commit the writes as a group. */
  COMMIT;

EXCEPTION
  WHEN not_null_column THEN
    /* Capture the table and column name that triggered the error. */
    lv_table_name := (TRIM(BOTH '"' FROM RTRIM(REGEXP_SUBSTR(SQLERRM,'".*\."',REGEXP_INSTR(SQLERRM,'\.',1,1)),'."')));
    lv_column_name := (TRIM(BOTH '"' FROM REGEXP_SUBSTR(SQLERRM,'".*"',REGEXP_INSTR(SQLERRM,'\.',1,2))));

    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
    RAISE_APPLICATION_ERROR(
       -20001
      ,'Remove the NOT NULL contraint from the '||lv_column_name||' column in'||CHR(10)||' the '||lv_table_name||' table.');
  WHEN OTHERS THEN
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
END;
/

-- Show errors if any.
SHOW ERRORS

SET SERVEROUTPUT ON SIZE 99999

-- Call the nested loop seeding procedure.
EXECUTE seed_account_list;

-- ----------------------------------------------------------------------
--  Verify #3e : Verify the values in the ACCOUNT_LIST table.
-- ----------------------------------------------------------------------
COLUMN airport FORMAT A7
SELECT   SUBSTR(account_number,1,3) AS "Airport"
,        COUNT(*) AS "# Accounts"
FROM     account_list
WHERE    consumed_date IS NULL
GROUP BY SUBSTR(account_number,1,3)
ORDER BY 1;

-- ----------------------------------------------------------------------
--  Step #3f : Update the ADDRESS table.
-- ----------------------------------------------------------------------
UPDATE address
SET    state_province = 'California'
WHERE  state_province = 'CA';

UPDATE address
SET    state_province = 'Utah'
WHERE  state_province = 'Ut';




-- ----------------------------------------------------------------------
--  Step #3g : Update the MEMBER table and consume values from the
--             ACCOUNT_LIST table.
-- ----------------------------------------------------------------------
-- Enable session debugging.
ALTER SESSION SET PLSQL_CCFLAGS = 'debug:1';

CREATE OR REPLACE PROCEDURE update_member_account IS

  /* Declare a local variable. */
  lv_account_number VARCHAR2(10);

  /* Declare a SQL cursor fabricated from local variables. */
  CURSOR member_cursor IS
    SELECT   DISTINCT
             m.member_id
    ,        a.city
    ,        a.state_province
    FROM     member m INNER JOIN contact c
    ON       m.member_id = c.member_id INNER JOIN address a
    ON       c.contact_id = a.contact_id
    ORDER BY m.member_id;

BEGIN

  /* Set savepoint. */
  SAVEPOINT all_or_none;

  /* Conditional debugging.
  ||  Enable it with the following command:
  || --------------------------------------------------
  ||  ALTER SESSION SEt PLSQL_CCFLAGS = 'debug:1';
  || --------------------------------------------------
  */
  $IF $$DEBUG = 1 $THEN
    dbms_output.put_line(CHR(10));
    dbms_output.put_line('Debugging Consumed by ID numbers.');
    dbms_output.put_line('------------------------------------------');
  $END

  /* Open a local cursor. */
  FOR i IN member_cursor LOOP

      /* Secure a unique account number as they are consumed. */
      SELECT al.account_number
      INTO   lv_account_number
      FROM   account_list al INNER JOIN airport ap
      ON     SUBSTR(al.account_number,1,3) = ap.airport_code
      WHERE  ap.city = i.city
      AND    ap.state_province = i.state_province
      AND    consumed_by IS NULL
      AND    consumed_date IS NULL
      AND    ROWNUM < 2
      ORDER BY al.account_number;

      /* Conditional debugging.
      ||  Enable it with the following command:
      || --------------------------------------------------
      ||  ALTER SESSION SEt PLSQL_CCFLAGS = 'debug:1';
      || --------------------------------------------------
      */
      $IF $$DEBUG = 1 $THEN
        dbms_output.put_line(
            '[id]['||i.member_id||']: '
	  ||'lv_account_number ['||lv_account_number||']');
      $END

      /* Update a member with a unique account number linked an airport. */
      UPDATE member
      SET    account_number = lv_account_number
      WHERE  member_id = i.member_id;

      /* Mark consumed the last used account number. */
      UPDATE account_list
      SET    consumed_by = 1002
      ,      consumed_date = SYSDATE
      WHERE  account_number = lv_account_number;

  END LOOP;

  $IF $$DEBUG = 1 $THEN
    dbms_output.put_line('------------------------------------------');
  $END

  /* Commit the writes as a group. */
  COMMIT;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    /* This prints a message. */
    dbms_output.put_line('You have an error in your AIRPORT table inserts.');

    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
  WHEN OTHERS THEN
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
END;
/

LIST
SHOW ERRORS

-- Enable session debugging.
ALTER SESSION SET PLSQL_CCFLAGS = '';

-- ----------------------------------------------------------------------
--  Verify #3g : Verify the update of the MEMBER table and consume
--               values from the ACCOUNT_LIST table.
-- ----------------------------------------------------------------------
COLUMN object_name FORMAT A22
COLUMN object_type FORMAT A12
SELECT   object_name
,        object_type
FROM     user_objects
WHERE    object_name = 'UPDATE_MEMBER_ACCOUNT';

-- Call the UPDATE_MEMBER_ACCOUNT procedure.
EXECUTE update_member_account();


-- ----------------------------------------------------------------------
--  Verify #3g : Diagnostics
-- ----------------------------------------------------------------------
-- Format the SQL statement display.
COLUMN member_id      FORMAT 999999 HEADING "Member|ID #"
COLUMN last_name      FORMAT A7     HEADING "Last|Name"
COLUMN account_number FORMAT A10    HEADING "Account|Number"
COLUMN acity          FORMAT A12    HEADING "Address City"
COLUMN apcode         FORMAT A8     HEADING "Airport|State or|Province"
COLUMN alcode         FORMAT A8     HEADING "Airport|Code"

-- Query distinct members and addresses.
SELECT   DISTINCT
         m.member_id
,        c.last_name
,        m.account_number
,        a.city AS acity
,        ap.state_province AS apstate
,        SUBSTR(al.account_number,1,3) AS alcode
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN airport ap
ON       a.city = ap.city
AND      a.state_province = ap.state_province INNER JOIN account_list al
ON       ap.airport_code = SUBSTR(al.account_number,1,3)
ORDER BY 1;

COLUMN member_id      FORMAT 999999 HEADING "Member|ID #"
COLUMN last_name      FORMAT A7     HEADING "Last|Name"
COLUMN account_number FORMAT A10    HEADING "Account|Number"
COLUMN acity          FORMAT A12    HEADING "Address City"
COLUMN astate         FORMAT A10    HEADING "Address|State or|Province"
COLUMN apstate        FORMAT A10    HEADING "Airport|State or|Province"
COLUMN apcode         FORMAT A8     HEADING "Airport|State or|Province"
COLUMN alcode         FORMAT A8     HEADING "Account|State or|Province"

-- Query distinct members and addresses.
SELECT   DISTINCT
         m.member_id
,        c.last_name
,        m.account_number
,        a.city AS acity
,        a.state_province AS astate
,        ap.state_province AS apstate
,        ap.airport_code AS apcode
,        SUBSTR(al.account_number,1,3) AS alcode
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN airport ap
ON       a.city = ap.city
AND      a.state_province = ap.state_province INNER JOIN account_list al
ON       ap.airport_code = SUBSTR(al.account_number,1,3)
ORDER BY 1;

-- Expand line size.
SET LINESIZE 99

-- Verify the account changes in the MEMBER table.
COLUMN member_id      FORMAT 999999 HEADING "Member|ID #"
COLUMN last_name      FORMAT A7     HEADING "Last|Name"
COLUMN account_number FORMAT A10    HEADING "Account|Number"
COLUMN acity          FORMAT A14    HEADING "Address City"
COLUMN apcity         FORMAT A14    HEADING "Airport City"
COLUMN astate         FORMAT A10    HEADING "Address|State or|Province"
COLUMN apstate        FORMAT A10    HEADING "Airport|State or|Province"
COLUMN apcode         FORMAT A8     HEADING "Airport|State or|Province"
COLUMN alcode         FORMAT A8     HEADING "Account|State or|Province"
SELECT   DISTINCT
         m.member_id
,        c.last_name
,        m.account_number
,        a.city AS acity
,        ap.city AS apcity
,        a.state_province AS astate
,        ap.state_province AS apstate
,        ap.airport_code AS apcode
,        SUBSTR(al.account_number,1,3) AS alcode
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id RIGHT JOIN airport ap
ON       a.city = ap.city
AND      a.state_province = ap.state_province RIGHT JOIN account_list al
ON       ap.airport_code = SUBSTR(al.account_number,1,3)
ORDER BY 1;


-- Verify the account changes in the MEMBER table.
COLUMN member_id      FORMAT 999999 HEADING "Member|ID #"
COLUMN last_name      FORMAT A10    HEADING "Last|Name"
COLUMN account_number FORMAT A10 HEADING "Account|Number"
COLUMN city           FORMAT A16 HEADING "City"
COLUMN state_province FORMAT A10 HEADING "State or|Province"
SELECT   DISTINCT
         m.member_id
,        c.last_name
,        m.account_number
,        a.city
,        a.state_province
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id
ORDER BY 1;

-- ----------------------------------------------
--  Step #4 : Create Oracle external table and verify data set.
-- ----------------------------------------------
-- Conditionally drop table.
BEGIN
  FOR i IN (SELECT table_name
            FROM   user_tables
            WHERE  table_name = 'TRANSACTION_UPLOAD') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
END;
/
-- ----------------------------------------------
--  Step #4 : Create Oracle external table.
-- ----------------------------------------------
CREATE TABLE STUDENT.TRANSACTION_UPLOAD
(ACCOUNT_NUMBER VARCHAR2(10)
,FIRST_NAME VARCHAR2(20)
,MIDDLE_NAME VARCHAR2(20)
,LAST_NAME VARCHAR2(20)
,CHECK_OUT_DATE DATE
,RETURN_DATE DATE
,RENTAL_ITEM_TYPE VARCHAR2(12)
,TRANSACTION_TYPE VARCHAR2(14)
,TRANSACTION_AMOUNT NUMBER
,TRANSACTION_DATE  DATE
,ITEM_ID NUMBER
,PAYMENT_METHOD_TYPE VARCHAR2(14)
,PAYMENT_ACCOUNT_NUMBER VARCHAR2(19))
  ORGANIZATION EXTERNAL
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "UPLOAD"
      ACCESS PARAMETERS
      ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'UPLOAD':'transaction_upload.bad'
      DISCARDFILE 'UPLOAD':'transaction_upload.dis'
      LOGFILE     'UPLOAD':'transaction_upload.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL     )
      LOCATION
       ( 'transaction_upload.csv'
       )
    )
   REJECT LIMIT UNLIMITED;




-- ----------------------------------------------
--  Step #4 : Verify Oracle external table.
-- ----------------------------------------------
SET LONG 4000000
SELECT dbms_metadata.get_ddl('TABLE'
                            ,'TRANSACTION_UPLOAD') AS "Table Description"
FROM   dual;

-- ----------------------------------------------
--  Step #4 : Verify rows in external table.
-- ----------------------------------------------
SELECT COUNT(*) AS "External Rows"
FROM   transaction_upload;

SPOOL OFF
