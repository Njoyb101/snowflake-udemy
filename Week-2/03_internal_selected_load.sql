-- Copy only the first 3 cols from the stagging to the table

create or replace table COURSE.WEEK2.EMPLOYEES_2 (
         first_name string ,
         last_name string ,
         email string 
);

-- snow sql --query "put file://D:/Learning/JobReady/24_snowflake/Employee/employees01.csv @COURSE.WEEK2.%EMPLOYEES_2 ;"

copy into COURSE.WEEK2.EMPLOYEES_2
from (select  t.$1 , t.$2 , t.$3 from @COURSE.WEEK2.%EMPLOYEES_2 t)
file_format = COURSE.file_formats.emp_csv_format
ON_ERROR = 'skip_file'
PURGE = TRUE;

select * from COURSE.WEEK2.EMPLOYEES_2 ;