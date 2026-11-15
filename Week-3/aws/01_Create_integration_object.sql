--- AWS S3 Configuration.

USE ROLE ACCOUNTADMIN;

create or replace storage integration s3_int
  type = external_stage
  storage_provider = s3
  enabled = true
  storage_aws_role_arn = 'arn:aws:iam::579834220952:role/snowflake_crc_role'
  storage_allowed_locations = ('s3://snowflakecrctest/emp/', 's3://snowflakecrctest/hr/');

DESC INTEGRATION s3_int; 
-- 1. Get the  STORAGE_AWS_IAM_USER_ARN VALUE "arn:aws:iam::411178425800:user/8bq4-s-sgsu5947"
-- 2. Get the STORAGE_AWS_EXTERNAL_ID "IT93082_SFCRole=2_XOPpWY24c6VGSiuKwzErFDAw9oI="
-- 3. Now  Update the  AWS Role Trust Relationship . Sample given in  "IAM_trust_relationship.json"

