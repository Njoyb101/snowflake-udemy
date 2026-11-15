/*
Challenge Summary
Using the files you previously uploaded to the countries_A subfolder inside 
the population internal stage, complete two tasks in Snowflake:
• Create a Table: Run the provided script to create a target table named population with the specified column names.
• Load Specific Data: Write and execute a COPY INTO command to load only the Afghanistan data file 
from the population/countries_A internal stage into the newly created population table.
*/

copy into demo_db.public.population
from '@population/countries_a/afghanistan-population.csv.gz'