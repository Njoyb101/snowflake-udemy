/*
Challenge Summary
Fix the issue from the previous load (where the file's header row was mistakenly imported as data) by completing two tasks in Snowflake:
• Create a File Format: Create a named CSV file format called my_csv_format (or my CSV format) configured to skip the header row (SKIP_HEADER = 1).
• Reload the Data: Write and execute a COPY INTO command that uses this new file format to load the Afghanistan file into the population table 
without importing the header record.

*/create or replace file format demo_db.public.my_csv_format;

alter file format demo_db.public.my_csv_format
set skip_header=1

desc file format demo_db.public.my_csv_format;

copy into demo_db.public.population
from '@population/countries_a/afghanistan-population.csv.gz'
file_format = my_csv_format

