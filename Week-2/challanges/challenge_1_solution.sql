/*
Set up your environment using Gitpod and SnowSQL, then execute two main tasks in Snowflake using data from the module 
two/data/practice/countries folder in your GitHub repository:
• Create an Internal Stage: Create a named internal stage in Snowflake called population.
• Upload Specific Files: Use the PUT command to upload all country population files starting with the letter "A" from 
your local/Gitpod directory into a specific subfolder named countries_A inside the population stage.
*/

CREATE
OR replace stage population;

PUT file: / / / workspace / snowflake / Module -2 / Snowflake - stages / DATA / Practice_data / countries / A * @population / countries_a /;

list @population;