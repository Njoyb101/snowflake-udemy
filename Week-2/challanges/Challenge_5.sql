/*
Challenge Summary
Track the source file for every loaded row by modifying your population table and updating your COPY INTO command in Snowflake:
• Add a Metadata Column: Alter the population table to add a new column named file_name (or filename).
• Capture Source Filenames: Modify your COPY INTO statement using a subquery and Snowflake's METADATA$FILENAME column to load 
all the files from population/countries_A while populating the new file_name column with each row's source file name.
*/

CREATE TABLE demo_db.public.population (
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

copy INTO demo_db.public.population
FROM
    (
        SELECT
            metadata$filename,
            t.$1,
            t.$2,
            t.$3,
            t.$4,
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
            @population/countries_a/ AS t
    ) file_format = my_csv_format ;


SELECT
    *
FROM
    demo_db.public.population;