PUT file: / / / workspace / snowflake / Module -2 / Snowflake - stages / DATA / Practice_data / countries / A * @ % population_afgn / countries_a /;

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
            @%population_afgn/countries_a / t
    ) file_format = my_csv_format;

SELECT
    *
FROM
    demo_db.public.population_afgn