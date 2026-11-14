create or replace transient database control_db;

create or replace schema external_stages;

create or replace schema internal_stages;

create or replace schema file_formats;

------------------------------------------------
-- Create external stage
------------------------------------------------
-- Not Secure
create or replace stage control_db.external_stages.my_ext_stage 
url='s3://snowflake067/test/'
credentials=(aws_key_id='AKIAUIIPUVJBJMSPABKO' aws_secret_key='bgQb6b816dzQdGkT+JPVqeiQ561B');

DESC STAGE control_db.external_stages.my_ext_stage ;

-- Not Secure
alter stage my_ext_stage set credentials=(aws_key_id='d4c3b2a1' aws_secret_key='z9y8x7w6');

------------------------------------------------
-- Create Internal stage
------------------------------------------------

create or replace stage control_db.internal_stages.my_int_stage

DESC STAGE control_db.internal_stages.my_int_stage

------------------------------------------------
-- Create File Format
------------------------------------------------

create or replace file format control_db.file_formats.my_csv_format
type = csv 
field_delimiter = ',' 
skip_header = 1 
null_if = ('NULL', 'null') 
empty_field_as_null = true 
compression = gzip;

desc file format control_db.file_formats.my_csv_format
