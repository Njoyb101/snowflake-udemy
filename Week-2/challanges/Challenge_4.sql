/*** you will see error ****/

/*
Challenge Summary
Expand your previous single-file data load to ingest all the country files located in the countries_A subfolder inside your internal stage:
• Load Multiple Files: Modify your COPY INTO command to load all files starting with the letter "A" from the population/countries_A stage into the population table.
• Handle Column Mismatch Errors: Resolve the loading error caused by files that contain fewer columns (11 columns) than your target table (14 columns) by reading the Snowflake 
error message and adding the appropriate parameter (such as ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE) to your file format or copy command.
*/
copy into demo_db.public.population
from '@population/countries_a/'
file_format = my_csv_format

alter file format my_csv_format
set error_on_column_count_mismatch=false


copy into demo_db.public.population
from '@population/countries_a/'
file_format = my_csv_format