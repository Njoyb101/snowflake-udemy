CREATE DATABASE IF NOT EXISTS COURSE;
CREATE SCHEMA IF NOT EXISTS COURSE.WEEK2 ;

CREATE OR REPLACE TABLE COURSE.WEEK2.EMPLOYEES (
    first_name STRING,
    last_name STRING,
    email STRING,
    streetaddress STRING,
    city STRING,
    start_date date
);

SELECT * FROM COURSE.WEEK2.EMPLOYEES;
SELECT CURRENT_REGION();

DESC table  COURSE.WEEK2.EMPLOYEES;


-- Table Stage(@%) : COURSE.WEEK2.EMPLOYEES --> @COURSE.WEEK2.%EMPLOYEES
----------------------------------------------
-- Load the new data to Stagging
----------------------------------------------
-- From Console Failed
put file:///root/Snowflake/Data/Employee/employees1*.csv @COURSE.WEEK2.%EMPLOYEES ; 


-- From Terminal
snow sql --query "put file://D:/Learning/JobReady/24_snowflake/Employee/employees03.csv @COURSE.WEEK2.%EMPLOYEES ;"

-- Now Data in Stagging
SELECT * FROM @COURSE.WEEK2.%EMPLOYEES;

----------------------------------------------
-- Custom File Format
----------------------------------------------
create or replace schema COURSE.file_formats;

create or replace file format COURSE.file_formats.emp_csv_format
type = csv 
field_delimiter = ',' 
skip_header = 0 
null_if = ('NULL', 'null') 
empty_field_as_null = true 
FIELD_OPTIONALLY_ENCLOSED_BY ='"'
compression = gzip;

----------------------------------------------
-- Stagging to Table
----------------------------------------------
COPY INTO COURSE.WEEK2.EMPLOYEES
FROM @COURSE.WEEK2.%EMPLOYEES
file_format = emp_csv_format
ON_ERROR = 'skip_file'
PURGE = TRUE; -- Cleans up the stagging.

-- Manual Clean up
LIST @%EMPLOYEES; --to view the files
REMOVE @%EMPLOYEES; --to Clean up All files
REMOVE @%EMPLOYEES/your_specific_file.csv.gz;; --to Clean up specific files
REMOVE @%EMPLOYEES PATTERN='*.csv.gz'; -- Cleanup with pattern


----------------------------------------------
-- Roubnd : 2
----------------------------------------------
-- 1. Load to Stagging
-- snow sql --query "put file://D:/Learning/JobReady/24_snowflake/Employee/employees03.csv @COURSE.WEEK2.%EMPLOYEES ;"

-- 2. View in Stagging
SELECT * FROM @COURSE.WEEK2.%EMPLOYEES; -- Does not have the file format schema advantage . so can not query

-- 3. Stagging to Table 
COPY INTO COURSE.WEEK2.EMPLOYEES
FROM @COURSE.WEEK2.%EMPLOYEES
file_format = COURSE.FILE_FORMATS.EMP_CSV_FORMAT
ON_ERROR = 'continue'
PURGE = TRUE;

-- 4.  View from table
SELECT * FROM COURSE.WEEK2.EMPLOYEES;