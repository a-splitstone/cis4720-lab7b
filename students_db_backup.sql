/* ==========================================================================
   students_db_backup.sql
   CIS 4720 Database Management and SQL

   WHAT THIS FILE IS
   A starter database for in_class_lab7b. It builds a schema called
   students_db holding one table of students, plus a view. The lab PCs are
   wiped every night, so a script like this one is how you get a working
   database back in a few seconds instead of typing it all again. The file
   is the database. The server is disposable.

   WHAT IT BUILDS
     1. A schema called students_db
     2. One table, STUDENT, with six columns and a primary key
     3. Five rows of data
     4. One view, STUDENT_GPA, showing just the names and the grade averages

   BEFORE YOU RUN IT
   The schema has to exist before VS Code can connect to it, and VS Code
   will not create one for you. Step 4 of the lab has you create it at the
   command prompt first. Do that step before you open VS Code.

   HOW TO RUN IT
   Open it in VS Code with SQLTools connected to students_db, then run the
   whole file. Lab7b walks you through it.

   READ THIS BEFORE YOU RUN IT A SECOND TIME
   Run it once and everything works. Run it twice and you get errors,
   because the table already exists and the rows are already there. Step 10
   of the lab explains which parts to comment out and why.
   ========================================================================== */


-- ======================================================================
-- SECTION 1. The schema
-- A schema is the container that holds your tables. CREATE DATABASE makes
-- one, and USE tells the server which one the statements below apply to.
-- ======================================================================

-- Create the schema. IF NOT EXISTS means this line is safe to run twice,
-- and safe to run even though you already made it at the command prompt.
CREATE DATABASE IF NOT EXISTS students_db;

-- Switch into it. Everything below lands inside this schema.
USE students_db;


-- ======================================================================
-- SECTION 2. The table
-- Each column gets a data type that fits what it holds:
--   INT           whole numbers, used here for the id
--   VARCHAR(30)   text up to 30 characters
--   DECIMAL(3,2)  a number with 1 digit before the point and 2 after,
--                 which is exactly the shape of a grade average
--   DATE          a real date, stored as YYYY-MM-DD
-- NOT NULL means the column may never be left empty.
-- PRIMARY KEY means student_id must be unique and may never be empty.
-- ======================================================================

-- CREATE TABLE STUDENT (
--     student_id  INT          NOT NULL,
--     first_name  VARCHAR(30)  NOT NULL,
--     last_name   VARCHAR(30)  NOT NULL,
--     major       VARCHAR(40),
--     gpa         DECIMAL(3,2),
--     enrolled_on DATE,
--     PRIMARY KEY (student_id)
-- );


-- -- ======================================================================
-- -- SECTION 3. The data
-- -- Five students. Two enrolled in the same term, which is useful later when
-- -- you start filtering on a date.
-- -- ======================================================================

-- INSERT INTO STUDENT VALUES (1,'Ana',   'Reyes', 'CIS',              3.75,'2025-08-25');
-- INSERT INTO STUDENT VALUES (2,'Marcus','Bell',  'Computer Science', 3.20,'2025-08-25');
-- INSERT INTO STUDENT VALUES (3,'Priya', 'Nair',  'Mathematics',      3.90,'2026-01-12');
-- INSERT INTO STUDENT VALUES (4,'Devon', 'Rao',   'CIS',              2.85,'2026-01-12');
-- INSERT INTO STUDENT VALUES (5,'Elena', 'Vargas','Business',         3.45,'2026-08-24');


-- -- ======================================================================
-- -- SECTION 4. The view
-- -- A view is a stored SELECT statement you can query as if it were a table.
-- -- This one shows only the names and the grade average, so anyone using it
-- -- cannot reach the id, the major or the enrollment date.
-- -- ======================================================================

-- CREATE VIEW STUDENT_GPA AS
-- SELECT first_name, last_name, gpa
-- FROM STUDENT;


-- ======================================================================
-- SECTION 5. Checks
-- These only read. They are safe to run as many times as you like, so
-- leave them switched on even after the first run.
-- ======================================================================

-- All five rows, straight from the table.
SELECT * FROM STUDENT;

-- The view, highest grade average first. Three columns, not six.
SELECT * FROM STUDENT_GPA ORDER BY gpa DESC;

-- Should come back as 5 students and an average of 3.43.
SELECT COUNT(*) AS students, ROUND(AVG(gpa), 2) AS average_gpa FROM STUDENT;

-- STUDENT is a BASE TABLE and STUDENT_GPA is a VIEW. SHOW TABLES on its
-- own does not tell them apart, which is why this one says FULL.
SHOW FULL TABLES;


-- ######################################################################
-- YOUR LAB7B WORK STARTS BELOW THIS LINE
--
-- Add your Chapter 5 statements under the headings below, in order. Put a
-- comment above every statement saying what it does, in your own words.
-- The comments are graded.
-- ######################################################################


-- STEP 11. Section 5.1, look at your schema
-- The first statement shows the database name as an alias called my_schema. The second statement shows the tables in the schema, and whether they are base tables or views.
SELECT DATABASE() AS my_schema;
SHOW FULL TABLES;
-- STEP 12. Section 5.2, look at the data types
-- The statement shows the column names, data types, and other information about the STUDENT table.
DESCRIBE STUDENT;
-- STEP 13. Section 5.3, create a table by copying with a subquery
-- The statement creates a new table called STUDENT_COPY that contains the student_id, first_name, last_name, and gpa columns from the STUDENT table. The second statement selects all rows from the STUDENT_COPY table to display its contents. The third statement shows the CREATE TABLE statement for the STUDENT_COPY table, which includes its structure and column definitions.
CREATE TABLE STUDENT_COPY AS
SELECT student_id, first_name, last_name, gpa
FROM STUDENT;

SELECT * FROM STUDENT_COPY;
SHOW CREATE TABLE STUDENT_COPY;
-- STEP 14. Section 5.4, change the structure of the copy
-- adds a new honors column to the end
ALTER TABLE STUDENT_COPY ADD COLUMN honors CHAR(1);

-- changes the last_name column to allow up to 50 characters and not allow nulls
ALTER TABLE STUDENT_COPY MODIFY COLUMN last_name VARCHAR(50) NOT NULL;

--adds back the primary key constraint on student_id, which was lost when the table was copied
ALTER TABLE STUDENT_COPY ADD PRIMARY KEY (student_id);

-- shows the new structure of the STUDENT_COPY table, including the new honors column and the modified last_name column
DESCRIBE STUDENT_COPY;
--failed like it should have
INSERT INTO student_copy VALUES (1, 'Duplicate', 'Row', 0.00, NULL);

-- removes the honors column from the STUDENT_COPY table
ALTER TABLE STUDENT_COPY DROP COLUMN honors;
-- STEP 15. Section 5.5, insert, update and delete a row
-- inserts a new row into the STUDENT_COPY table with student_id 6, first_name 'Omar', last_name 'Faruqi', and gpa 3.10
INSERT INTO STUDENT_COPY VALUES (6, 'Omar', 'Faruqi', 3.10);
SELECT * FROM STUDENT_COPY WHERE student_id = 6;
-- updates the gpa of the row with student_id 6 in the STUDENT_COPY table to 3.35
UPDATE STUDENT_COPY SET gpa = 3.35 WHERE student_id = 6;
SELECT * FROM STUDENT_COPY WHERE student_id = 6;
--removes the student from the table
DELETE FROM STUDENT_COPY WHERE student_id = 6;
SELECT * FROM STUDENT_COPY WHERE student_id = 6;
-- STEP 16. Section 5.6, create a view and update through it
--creates a view called HIGH_GPA that selects the student_id, first_name, last_name, and gpa columns from the STUDENT_COPY table for students with a gpa greater than 3.50
CREATE VIEW HIGH_GPA AS
SELECT student_id, first_name, last_name, gpa
FROM student_copy
WHERE gpa > 3.50;

SELECT * FROM HIGH_GPA ORDER BY gpa DESC;

-- Checks GPA before making changes
SELECT student_id, gpa
FROM student_copy
WHERE student_id = 1;

--Updates the GPA using the HIGH_GPA view, setting the gpa of the student with student_id 1 to 3.95
UPDATE HIGH_GPA
SET gpa = 3.95
WHERE student_id = 1;

-- Checks GPA after making changes
SELECT student_id, gpa
FROM student_copy
WHERE student_id = 1;

--test code that is in the file meant to error
CREATE VIEW GPA_SUMMARY AS
SELECT COUNT(*) AS n, ROUND(AVG(gpa), 2) AS avg_gpa
FROM student_copy;

UPDATE GPA_SUMMARY SET avg_gpa = 4.00;