# Stagging

1. Internal Stagging
    - User Stage (@~)
    - Table Stage (@%) `COURSE.WEEK2.EMPLOYEES` --> `@COURSE.WEEK2.%EMPLOYEES` 
        - When user creates a table, Table staging area is automatically created
        - Can not be dropped
        - Can not copy data from T1 staging area to T2 table T1 Stage --> T1 Table
        - won't support transforming data while copying data to snowflake.
    - Named Stage (@)
2. External Stage



### Stage Object &  File Format Property 


|Parent Property|Properties Type| property | property_type | property_value | property_default |
|:---|:---| :--- | :--- | :--- | :--- |
|Stage Format|File Format| TYPE | String | csv"" | CSV"" |
|Stage Format|File Format| RECORD_DELIMITER | String | \n"" | \n"" |
|Stage Format|File Format| FIELD_DELIMITER | String | "," | "," |
|Stage Format|File Format| FILE_EXTENSION | String | | |
|Stage Format|File Format| SKIP_HEADER | Integer | 1 | 0 |
|Stage Format|File Format| DATE_FORMAT | String | AUTO"" | AUTO"" |
|Stage Format|File Format| TIME_FORMAT | String | AUTO"" | AUTO"" |
|Stage Format|File Format| TIMESTAMP_FORMAT | String | AUTO"" | AUTO"" |
|Stage Format|File Format| BINARY_FORMAT | String | HEX"" | HEX"" |
|Stage Format|File Format| ESCAPE | String | NONE"" | NONE"" |
|Stage Format|File Format| ESCAPE_UNENCLOSED_FIELD | String | \\"" | \\"" |
|Stage Format|File Format| TRIM_SPACE | Boolean | FALSE | FALSE |
|Stage Format|File Format| FIELD_OPTIONALLY_ENCLOSED_BY | String | NONE"" | NONE"" |
|Stage Format|File Format| NULL_IF | List | ["NULL","null"] | [""\\N""] |
|Stage Format|File Format| COMPRESSION | String | gzip"" | AUTO"" |
|Stage Format|File Format| ERROR_ON_COLUMN_COUNT_MISMATCH | Boolean | TRUE | TRUE |
|Stage Format|File Format| VALIDATE_UTF8 | Boolean | TRUE | TRUE |
|Stage Format|File Format| SKIP_BLANK_LINES | Boolean | FALSE | FALSE |
|Stage Format|File Format| REPLACE_INVALID_CHARACTERS | Boolean | FALSE | FALSE |
|Stage Format|File Format| EMPTY_FIELD_AS_NULL | Boolean | TRUE | TRUE |
|Stage Format|File Format| SKIP_BYTE_ORDER_MARK | Boolean | TRUE | TRUE |
|Stage Format|Stage Format| ENCODING | String | UTF8"" | UTF8"" |
|Stage Format|Stage Format| STAGE_FILE_FORMAT | ENCODING | String | UTF8 | UTF8 |
|Stage Format|Stage Format| STAGE_COPY_OPTIONS | ON_ERROR | String | ABORT_STATEMENT"" | ABORT_STATEMENT"" |
|Stage Format|Stage Format| STAGE_COPY_OPTIONS | SIZE_LIMIT | Long | | |
|Stage Format|Stage Format| STAGE_COPY_OPTIONS | PURGE | Boolean | FALSE | FALSE |
|Stage Format|Stage Format| STAGE_COPY_OPTIONS | RETURN_FAILED_ONLY | Boolean | FALSE | FALSE |
|Stage Format|Stage Format| STAGE_COPY_OPTIONS | ENFORCE_LENGTH | Boolean | TRUE | TRUE |
|Stage Format|Stage Format| STAGE_COPY_OPTIONS | TRUNCATECOLUMNS | Boolean | FALSE | FALSE |
|Stage Format|Stage Format| STAGE_COPY_OPTIONS | FORCE | Boolean | FALSE | FALSE |
|Stage Format|Stage Format| STAGE_LOCATION | URL | String | [""s3://snowflake067/test/""] | |
|Stage Format|Stage Format| STAGE_CREDENTIALS | AWS_KEY_ID | String | XXXXXXXX | |

