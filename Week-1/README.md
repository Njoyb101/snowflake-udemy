# Snowflake Data Retention Features

### 1. Time Travel
**Time Travel** allows you to access historical data (i.e., data that has been changed or deleted) at any point within a defined retention period. It is primarily used for querying older data, restoring dropped objects, or undoing accidental changes.

*   **Capabilities:** 
    *   Query data from the past (e.g., using `AT` or `BEFORE` clauses).
    *   Clone historical databases, schemas, or tables.
    *   Restore dropped tables, schemas, or databases using `UNDROP`.
*   **Retention Period:** 
    *   **Standard Edition:** Up to 1 day for Permanent tables.
    *   **Enterprise Edition (or higher):** Up to 90 days for Permanent tables.
    *   **Transient & Temporary Tables:** Maximum of 1 day (or 0 days).
*   **Cost:** Standard data storage rates apply to the historical data maintained during this period.

---

### 2. Fail-safe
**Fail-safe** is a non-configurable, 7-day data recovery window provided automatically by Snowflake after the Time Travel retention period ends. It acts as a final safety net for disaster recovery and can only be accessed by Snowflake Support.

*   **Capabilities:** 
    *   Protects historical data in the event of extreme data corruption or system failure.
    *   **Cannot** be queried or managed directly by users or administrators.
    *   Requires a support ticket to Snowflake to recover data.
*   **Retention Period:** Fixed at exactly **7 days** for all Permanent tables.
*   **Table Restrictions:** Fail-safe is **not** available for Transient or Temporary tables.
*   **Cost:** Standard data storage rates apply to data maintained in Fail-safe.

| Table Type | Fail-safe | Time Travel |Listed in the Catalog|Can be queried ?|Gone After the Session?|
| :--- | :---: | :---: |:---: |:---: |:---: |
| **Regular (Permanent)** | ✔️ | ✔️ |✔️ |✔️ |❌ |
| **Transient** | ❌ | ✔️ |✔️ |✔️ |❌ |
| **Temporary (Temp)** | ❌ | ❌ |✔️ |✔️ |✔️ |

---
## Types of Views
- Views
- Materialized view
- Secure view ( View def is not exposed)🤯wtf🤯

## Types of Copy Into
- `COPY INTO` -  manual or orchestrated
- SNOW PIPE -  Near rela time Auto trigger
- SNOW Pipe Stream - Real time with CDC
    - standard stream ( all insert update delete)
    - insert only stream

## Tasks
Run an SQL Statement i snowflake

## How to see if a query is eligible for  Performance Acceleration ?
```sql
SELECT PARSE_JSON(SYSTEM$ESTIMATE_QUERY_ACCELERATION('01c85194-0002-4c97-000f-fe760004a612'));

```
## Query Acceleration Services (QAS)
- It is a Service Layer Result Set Cache not the warehouse level cache.
- Majorly for  Scanning queries and filter cases
> leveraging the warehouse cache is not possible when the query utilizes Query Acceleration Services (QAS), which typically requires a different handling of data.

In Snowflake, `UPPER_LIMIT_SCALE_FACTOR` represents the maximum scale factor applicable to a query running on a warehouse utilizing the **[Query Acceleration Service (QAS)](https://snowflake.com "Using the Query Acceleration Service (QAS)")**. 

When configuring a virtual warehouse, this parameter is set via the SQL property `QUERY_ACCELERATION_MAX_SCALE_FACTOR`. In Snowflake metadata views—such as the `QUERY_ACCELERATION_ELIGIBLE` view—it appears as the column name **`UPPER_LIMIT_SCALE_FACTOR`**.

---

### ⚙️ How the Scale Factor Works
The scale factor acts as a cost-control ceiling. It establishes a multiplier on the base compute size of your warehouse, defining how much additional compute resource the Query Acceleration Service can leased to run a single query:

*   **The Multiplier Effect:** If you have a **Medium warehouse** (which consumes 4 credits/hour) and you set the scale factor to **5**, the warehouse can temporarily lease up to 5 × its normal capacity for QAS-eligible tasks (like heavy table scans and filtering). 
*   **The Cost Maximum:** In this example, the maximum extra cost would be 20 additional credits per hour (4 credits × 5).
*   **Dynamic Allocation:** The factor is an *upper bound*. Snowflake's engine determines how many extra servers are actually necessary up to that limit; it won't greedily consume the maximum unless required.

### 📊 Default Behaviors and Settings
Depending on how you provision or structure your virtual warehouses, different defaults apply:

| Action / Setup | Default Scale Factor Limit |
| :--- | :--- |
| **Explicitly enabling QAS** via `CREATE WAREHOUSE` or `ALTER WAREHOUSE` | **8** |
| **Snowflake Auto-enabled QAS** (on standard warehouses created out-of-the-box) | **8** |
| **Setting the factor to `0`** | **Unbounded** (gives Snowflake complete flexibility to scale as large as necessary) |

### 🔍 How to Monitor It
You can look at historical queries to see what their upper limits were and whether they would have benefited from QAS by running a query against the [Account Usage View](https://snowflake.com "QUERY_ACCELERATION_ELIGI"):

```sql
SELECT 
    QUERY_ID,
    WAREHOUSE_NAME,
    WAREHOUSE_SIZE,
    ELIGIBLE_QUERY_ACCELERATION_TIME,
    UPPER_LIMIT_SCALE_FACTOR
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
WHERE START_TIME >= DATEADD(month, -1, CURRENT_TIMESTAMP());
```

