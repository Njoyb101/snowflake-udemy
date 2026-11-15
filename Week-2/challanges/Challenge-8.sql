/*
Challenge Summary
Upload all country files to a named internal stage, then selectively load only a subset of them into an existing table in Snowflake:
• Recreate the Internal Stage: Create (or replace) the named internal stage called population.
• Upload All Country Files: Run a PUT command to upload all country files (not just those starting with "A") into a countries subfolder inside the population stage.
• Truncate the Target Table: Clear out the existing records in your target table using TRUNCATE TABLE.
• Selectively Load "A" Files: Write a COPY INTO command using pattern matching (such as PATTERN = '.*countries/A.*') to load only the files starting with the 
letter "A" from the stage into your table.

*/

PUT file: / / / workspace / snowflake / Module -2 / Snowflake - stages / DATA / Practice_data / countries / A * @ % population_afgn / countries /;

CREATE
OR replace TABLE demo_db.public.population_afgn (
    file_name VARCHAR,
    country VARCHAR,
    YEAR VARCHAR,
    Population VARCHAR,
    Yearly_percentage_change VARCHAR,
    Yearly_Change VARCHAR,
    Migrants_net VARCHAR,
    Median_Age VARCHAR,
    Fertility_Rate VARCHAR,
    Density_P_Km_sq VARCHAR,
    Urban_Pop_percentage VARCHAR,
    Urban_Population VARCHAR,
    Country_Share_of_WorldPop VARCHAR,
    World_Population VARCHAR,
    Rank VARCHAR
);

copy INTO demo_db.public.population_afgn
FROM
    (
        SELECT
            split_part(metadata$filename, '/', 2),
            t.$1,
            t.$2,
            t.$3,
            replace(t.$4, '%', ''),
            t.$5,
            t.$6,
            t.$7,
            t.$8,
            t.$9,
            t.$10,
            t.$11,
            t.$12,
            t.$13,
            t.$14
        FROM
            @population/countries/ t
    ) file_format = my_csv_format 
    pattern = '^.*/a.*$' ;
truncate TABLE demo_db.public.population_afgn
SELECT
    *
FROM
    demo_db.public.population_afgn;

CREATE
OR replace stage population;