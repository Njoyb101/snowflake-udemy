/*
Challenge Summary
Clean and transform two fields during the data load itself (inside your COPY INTO subquery) rather than updating the table afterward:
• Clean the File Name: Strip the folder path prefix countries_A/ from METADATA$FILENAME so that 
only the actual file name is stored in the file_name column.
• Strip Percentage Symbols: Remove the % sign from the yearly_percentage_change column values during 
the COPY INTO transformation before inserting them into the population table.
*/

copy INTO demo_db.public.population
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
            @population / countries_a / t
    ) file_format = my_csv_format;