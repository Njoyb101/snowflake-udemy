Snowflake Table ──► S3 directly.

```
================================================================================
                        PHASE 1: SETUP & CONFIGURATION
================================================================================

  [ 1. File Format ] ──(Defines layout: CSV/Parquet)──┐
                                                      ▼
  [ 2. Storage Integration ] ──(Grants S3 access)──► [ 3. External Stage ]
                                                     (Bridge to S3 Folder)


================================================================================
                        PHASE 2: EXPORTING THE DATA
================================================================================

  [ Snowflake Table ] 
          │
          ▼  (Uses a Dedicated Warehouse for large files)
  [ COPY INTO Command ] ──(Selects all data or specific columns)
          │
          ▼  (Pushes through the External Stage)
  [ Amazon S3 Bucket ] ──► Creates compressed files (e.g., .csv.gz)


================================================================================
                        PHASE 3: DATA VALIDATION
================================================================================

  [ Snowflake Table ] ◄══(1. Compare Row Counts)══► [ S3 Stage Files ]
          │                                                │
          └──────◄══════(2. Compare Column Values)══════►──┘
                            (Using MINUS query)
                                     │
                                     ▼
                         [ Zero Differences Found ]
                                     │
                                     ▼
                         [ Ready to Share with Client ]

```

```sql

COPY INTO @s3_client_export_stage/full_export_
FROM employees_table
OVERWRITE = TRUE;

```