-- View
CREATE VIEW DEMO_DB.MYSCHEMA.vw_distinct_full_names AS
SELECT
    DISTINCT CONCAT(
        TRIM(UPPER(first_name)),
        ' ',
        TRIM(UPPER(last_name))
    ) as full_name
FROM
    DEMO_DB.MYSCHEMA.employees;

-- Materialized View
CREATE
OR REPLACE MATERIALIZED VIEW DEMO_DB.MYSCHEMA.mv_distinct_full_names AS
SELECT
    DISTINCT CONCAT(
        TRIM(UPPER(first_name)),
        ' ',
        TRIM(UPPER(last_name))
    ) as full_name
FROM
    DEMO_DB.MYSCHEMA.employees;


-- Secure View
CREATE
OR REPLACE SECURE  VIEW DEMO_DB.MYSCHEMA.svw_distinct_full_names AS
SELECT
    DISTINCT CONCAT(
        TRIM(UPPER(first_name)),
        ' ',
        TRIM(UPPER(last_name))
    ) as full_name
FROM
    DEMO_DB.MYSCHEMA.employees;

SELECT GET_DDL('view', 'DEMO_DB.MYSCHEMA.svw_distinct_full_names');
-- Result: Action not permitted (The logic stays secret!)



SELECT *  FROM DEMO_DB.MYSCHEMA.VW_DISTINCT_FULL_NAMES;
SELECT *  FROM DEMO_DB.MYSCHEMA.svw_distinct_full_names;
SELECT *  FROM DEMO_DB.MYSCHEMA.mv_distinct_full_names; 