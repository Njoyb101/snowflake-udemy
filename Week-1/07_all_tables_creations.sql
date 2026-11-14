CREATE OR REPLACE  warehouse know_architecture_1 WITH 
warehouse_size = 'X-SMALL' 
auto_suspend = 180 
auto_resume = true 
initially_suspended = true;

DROP DATABASE IF EXISTS DEMO;

CREATE DATABASE IF NOT EXISTS DEMO;

CREATE SCHEMA IF NOT EXISTS DEMO.RAW ;

-- Regular Table
CREATE OR REPLACE TABLE employees (
    first_name string,
    last_name string,
    email string,
    streetaddress string,
    city string,
    start_date date
);

-- Temp Table
CREATE TEMP TABLE temp_employees (
    first_name string,
    last_name string,
    email string,
    streetaddress string,
    city string,
    start_date date
);

-- We can undrop a normal table but not temp table in different sessions.
DROP TABLE IF EXISTS DEMO.RAW.employees ; 
UNDROP TABLE  DEMO.RAW.employees ;

-- Within a SIngle Session
DROP TABLE IF EXISTS DEMO.RAW.temp_employees ; 
UNDROP TABLE  DEMO.RAW.temp_employees ;