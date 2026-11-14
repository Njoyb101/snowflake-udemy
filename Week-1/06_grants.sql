CREATE ROLE IF NOT EXISTS role_analyst;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE role_analyst ;
GRANT USAGE ON DATABASE my_db TO ROLE role_analyst ;
GRANT USAGE ON SCHEMA my_db.my_schema TO ROLE role_analyst ;
GRANT SELECT ON ALL TABLES IN SCHEMA my_db.my_schema TO ROLE role_analyst ;

-- This is like create a new snowflake user with the same accounf Identifier  like IAM Account
CREATE USER raj@siemens.com PASSWORD='temp@123' DEFAULT_ROLE =  role_analyst MUST_CHANGE_PASSWORD=FALSE ;