1. Why it is important to analyz snowflake warehouse ?
> costs

2. How auto suspend behaviour helps ?
> auto-suspend pauses the warehouse after a period of inactivity to reduce credits; the limitation is you need to tune the inactivity timeout carefully so it doesn’t suspend during intermittent usage or before the next burst of queries.

3. How to optimize infrequent queries ?
> For infrequent queries, I’d right-size the warehouse based on expected average workload and enable auto-suspend with an inactivity timeout so it pauses when it’s not needed, then monitor usage to adjust the timeout if needed. we'll keep the warehouse small for typical periods, enable auto-suspend with a sensible inactivity timeout for your workload, and validate using warehouse/query usage patterns to ensure you’re not suspending too aggressively.

4. What will happen if many users start  treating snowflake as a cheap solution just because it scales on demand ?
> I’d expect costs to become unpredictable if everyone runs large workloads by default, and performance could suffer from spiky concurrency and poorly managed warehouses—so governance like monitoring, workload policies, and chargeback/showback would matter.
>> Mention at least one risk from widespread on-demand usage: unexpectedly high monthly bills due to heavy/inefficient queries, warehouse contention/performance variability, and the need for policies like workload management, quotas, and monitoring/chargeback.

5. “Let’s say your Snowflake bill unexpectedly increased this month. How would you use metadata views to investigate what went wrong?”
> Expected direction: Use WAREHOUSE_METERING_HISTORY to identify high usage; QUERY_HISTORY to spot expensive queries or long idle periods; EVENT_HISTORY to confirm active vs suspended periods.

6. “You mentioned Snowflake charges by the minute and uses ‘credits’. Can you explain what affects how much a credit costs?”
> Expected direction: Credit cost varies by edition — Standard ($2), Enterprise ($3), Business Critical ($4); same usage, different billing rate.

###  1. ACID Transactions & Snapshot Isolation
Q1: Snowflake doesn’t use traditional indexes, primary keys, or unique constraints. How does it still support ACID transactions?
>  Snowflake relies on its cloud services layer and snapshot isolation. It tracks metadata for each file version and controls access through a lock-based key-value store, ensuring consistency and isolation during concurrent transactions.

Q2: What is snapshot isolation in Snowflake?
>  It's a method where each transaction works on a "snapshot" of data files at the moment the transaction starts. Changes are applied only to those file versions, ensuring consistency without conflicts.

Q3: What happens if a second transaction tries to update a table that's already locked?
>  The second transaction will go into a blocked state until the first one completes. This is controlled by the cloud services layer using the lock metadata.

Q4: Can a SELECT query still return results if the table is dropped during execution?
>  Yes, if the SELECT query started before the table was dropped, it can complete using snapshot isolation. But new queries afterward will fail.

Q5: Who controls the locking mechanism in Snowflake?
>  The cloud services layer manages locking using metadata stored in a key-value format for all files and transactions.



### 2. Constraints in Snowflake
Q6: Which table constraints are actually enforced in Snowflake?
>  Only the NOT NULL constraint is enforced. Others like PRIMARY KEY and FOREIGN KEY exist for reference/documentation only.

Q7: If constraints like PRIMARY KEY aren't enforced, why are they allowed?
>  They help with easier data migration from other databases and allow modeling tools to infer relationships between tables.

Q8: What happens when you insert duplicate values in a PRIMARY KEY column?
>  Snowflake will allow it. The PRIMARY KEY is not enforced—it’s only metadata.

### 3. Updates, Inserts, and Deletes
Q9: How does an UPDATE operation work under the hood in Snowflake?
>  Snowflake marks the affected micro-partitions as deleted and writes new ones with updated data. It doesn’t modify existing files directly.

Q10: Why does DELETE remove whole micro-partitions instead of specific rows?
>  Snowflake stores data in immutable files (like on S3). Entire files must be rewritten, which aligns with its append-only architecture.

Q11: If an UPDATE affects more than 80% of records, what’s the best practice?
>  Consider recreating the table or using a combination of DELETE and INSERT, as it may be more efficient.

### 4. Performance Tuning & Cost Optimization
Q12: What is the main goal of performance tuning in Snowflake?
> The main goal is cost optimization. Snowflake handles most tuning internally, so developers focus on efficient usage to reduce compute and storage costs.

Q13: Should you resize a warehouse or use a multi-cluster warehouse when queries queue?
> Use a multi-cluster warehouse. It scales out automatically, spinning up additional clusters when demand increases—more efficient than resizing.

Q14: Why should developers share a virtual warehouse during development?
> To take advantage of the local disk cache and reduce redundant compute, which helps lower cost and improve performance.

Q15: Why should data be ordered by filter/join columns before loading?
> It helps optimize micro-partition pruning, improving query performance and avoiding the extra cost of clustering.

Q16: Which query performs better: SELECT * or selecting specific columns?
> Selecting specific columns performs better. Snowflake reads only the required columns from the storage layer.

### 5. Transaction Rollback & Manual Management
Q17: Does aborting a running UPDATE rollback partial changes?
> Yes. Snowflake will roll back the entire transaction. No changes will persist unless the transaction is committed.

Q18: How can you prevent an automatic commit in Snowflake?
> Use BEGIN to start a transaction manually. Then you must explicitly run COMMIT or ROLLBACK.

Q19: How can you prove that an aborted transaction didn’t change data?
> Rerunning the query should return the same results. If result cache is used, disable it and verify data was not altered.

Q20: How do you kill a blocking transaction?
> Identify the blocking query using logs or session info, then cancel it using the QUERY_ID.

### 6. Query Lifecycle & Optimizer Behavior
Q21: What are the phases a query goes through in Snowflake?
> Parsing → Object resolution → Access control → Optimization → Plan execution on the virtual warehouse.

Q22: Why doesn’t Snowflake use traditional indexes?
> Snowflake uses compressed files on blob storage like S3. Indexing is costly, unnecessary, and doesn't align with Snowflake’s architecture.

Q23: How does Snowflake achieve efficient query execution without indexes?
> It uses metadata, pruning, zone maps, and column offsets in micro-partitions to avoid full scans and improve performance.

### 7. Miscellaneous Behavior
Q24: What is the purpose of the key-value store in the Cloud Services Layer?
> It tracks metadata about each file and transaction, enabling lock management and snapshot isolation for concurrency.

Q25: What happens if two update statements target different columns in the same table concurrently?
> The second transaction still blocks, as Snowflake locks the entire file (micro-partition), not just the specific column.

### 8. QAS
Q1: What is the purpose of the Query Acceleration Service (QAS) in Snowflake?
> The Query Acceleration Service improves query performance by offloading scan and filtering operations to shared, on-demand compute resources. This helps reduce the impact of slow, resource-intensive queries on overall warehouse performance.

Q2: Which stages of query execution does QAS accelerate?
> QAS accelerates only the table scan and filtering operations. It does not optimize aggregation, joins, or result writing.

Q3: What kind of queries benefit from QAS?
> Queries that spend most of their execution time on scanning and filtering large datasets, especially when the data is being read from remote storage (e.g., S3).

Q4: How is QAS different from Multi-Cluster Warehouses?
> Multi-cluster warehouses help handle concurrent queries by spinning up additional clusters, reducing queue time. QAS reduces individual query execution time by parallelizing scan/filter operations.

Q5: **Can QAS use the warehouse cache to improve performance?**
> **No. Since QAS uses external, shared compute resources, the warehouse cache (which resides in the Snowflake virtual warehouse) is not utilized.**

Q6: Why doesn’t Snowflake support dynamic vertical scaling for warehouses?
> Vertical scaling increases resource cost and can lead to underutilization. Snowflake supports horizontal scaling via multi-cluster warehouses but not on-the-fly vertical resizing (e.g., from XS to L).

Q7: What is the scale factor in Query Acceleration?
> The scale factor is a cost control mechanism that defines the upper bound on how many compute resources can be leased for query acceleration. It acts as a multiplier based on the warehouse size.

Q8: How does the scale factor impact cost?
> For example, a medium warehouse (4 credits/hour) with a scale factor of 5 can lease up to 5x the compute, potentially costing up to 20 additional credits/hour.

Q9: How can you determine if a query is eligible for QAS?
> Use the system function `ESTIMATE_QUERY_ACCELERATION(query_id)` or check the `SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE` view. The function also estimates time savings and recommends a scale factor.

Q10: Is QAS automatically applied once it is enabled on a warehouse?
> No. It only applies to queries that are QAS-eligible, i.e., queries that spend a significant portion of time in scan and filter stages.

Q11: If multiple queries are running on a non-multi-cluster extra-small warehouse, what happens?
> All queries compete for the same limited compute resources, leading to queueing and longer execution times.

Q12: Can QAS reduce queueing of concurrent queries?
> No. QAS reduces scan/filter latency, not query queueing. For handling concurrency, use multi-cluster warehouses.

Q13: Does QAS always improve performance regardless of query type?
> No. It is beneficial only for queries dominated by scan and filter operations. Queries focused on joins or aggregations may not benefit.

Q14: If a query originally took 4 minutes and completes in 1 minute after enabling QAS, what does that imply?
> The scan/filter operations were a bottleneck, and QAS helped parallelize and accelerate those operations by using additional compute nodes.

Q15: Why should we be cautious when choosing a high scale factor in QAS?
> A high scale factor can lead to significantly increased compute costs. It’s important to balance performance with cost efficiency.


## Seach Optimization Service (SOS)
Q1: What is the Search Optimization Service in Snowflake?
> It's a feature that improves the performance of lookup and analytical queries, especially those that filter a small number of rows using extensive predicates on large datasets.

Q2: When should you use Search Optimization Service?
> When querying large tables with point lookups or specific filtering that returns a small number of rows (e.g., 10 to 1,000 rows out of millions).

Q3: How does SOS differ from Clustering and Query Acceleration Service (QAS)?
> Clustering: Orders data in micro-partitions based on key columns. Useful for consistent range filtering.
> - QAS: Adds parallel I/O compute resources to improve large scan queries.
> - SOS: Maintains a separate index-like structure for quick lookup of micro-partitions containing relevant data.

Q4: What happens when a query using SOS is executed?
> Snowflake consults the SOS storage/index to locate relevant micro-partitions and scans only those, rather than the entire table.

Q5: Is the SOS structure similar to an index?
> Yes, functionally it behaves like an index, but without enforcing uniqueness or not-null constraints.

Q6: How does Snowflake physically store SOS data?
> As additional storage attached to the table, it stores metadata mapping values to partition addresses. It's likely implemented as a hidden materialized view internally.

Q7: What is the cost implication of enabling SOS?
> Enabling SOS results in additional storage costs(~ 10% per column). 
>> For example, a 150 GB table may incur 30 GB more storage when SOS is applied to two columns.
> Better do it on a  Low Cardinality Column.
> 

Q8: How does SOS affect partition scanning?
> Without SOS, Snowflake scans all partitions. With SOS, it may scan only a subset (e.g., 3 or 4 out of 9,000+ partitions), significantly improving performance.

Q9: Is it beneficial to apply SOS on small tables (e.g., <10 GB)?
> Not really. The performance gains are negligible since full-table scans are already fast due to small data volume.

Q10: What happens if SOS is applied to a column but the query returns large result sets?
> SOS becomes ineffective. Snowflake will still scan most or all partitions because the result set is large and broadly distributed.

Q11: What makes a column suitable for SOS?
> Columns used in filters that return highly selective results (few rows) and have high cardinality (many distinct values).

Q12: How can you verify SOS is being used in a query?
> In the Query Profile, you can see whether "Search Optimization Access" was used and how many partitions were scanned.

Q13: Can SOS be applied on shared or sample databases?
> No. SOS requires ownership of the table and can't be applied on Snowflake's shared databases due to materialized view restrictions.

Q14: If two queries return similar results, but only one uses SOS, why might the times differ significantly?
> The SOS-enabled query benefits from partition pruning via the index, whereas the other scans the entire table, leading to longer execution time.



Q15: What is a real-world use case where SOS provides tangible benefit?
> A Tableau dashboard that fires point queries (e.g., fetching 50 rows from a 1 TB table) after user interaction benefits from faster response when SOS is enabled.

Q16: If SOS scans fewer partitions, why might overall execution time still be similar for small tables?
> Because the overhead of scanning a small table is already low, and the time saved by partition pruning is minimal.



Q17: How do you apply SOS to a column in Snowflake?

```sql
ALTER TABLE table_name MODIFY COLUMN column_name SET SEARCH OPTIMIZATION = ON;
-- For exact matches (EQUALITY) and IN predicates
ALTER TABLE my_table ADD SEARCH OPTIMIZATION ON EQUALITY(customer_id, email);

-- For partial string matches (LIKE, ILIKE, CONTAINS)
ALTER TABLE my_table ADD SEARCH OPTIMIZATION ON SUBSTRING(phone_number);

-- For full text search predicates (requires Enterprise Edition)
ALTER TABLE my_table ADD SEARCH OPTIMIZATION ON FULL_TEXT(comments_column);

-- For geospatial queries (GEOGRAPHY data types)
ALTER TABLE my_table ADD SEARCH OPTIMIZATION ON GEO(location_coordinates);

```
Q18: Can SOS be used along with clustering?
> Yes, but they serve different use cases. Clustering helps for range filters and large scans, SOS helps for selective point lookups.



Q19: What are signs that a column is not a good candidate for SOS?
> - The column has low cardinality
> - Queries on that column return large result sets
> - Filtering on that column still scans all partitions



Q20: Summarize the difference in behavior of SOS with numeric vs. string values.
> In the provided lecture, queries with numeric filters performed better with SOS. String filters also benefited but may take slightly more time due to overhead.


Q21 : Imagine you’ve enabled SOS on a table with semi-structured data, and you’re frequently searching JSON fields. How would you evaluate whether enabling SOS is truly improving query performance in this scenario?
> When dealing with nested JSON fields, you’re right that enabling SOS could result in high cardinality, which might not bring the expected performance benefits but would increase storage costs. Evaluating whether SOS improves performance would require testing query execution times before and after enabling SOS, while also monitoring storage usage and cost.

Q22: Let’s say you’re working on a dataset with billions of rows, and you often search for customer transactions using a specific customer ID column. How would enabling SOS impact your query performance, and what trade-offs might you consider before enabling it?

> high cardinality can significantly increase storage requirements, making SOS less cost-effective in those cases. For medium or low cardinality columns, it’s a much smarter choice.

## Data Volume and Cost
Q1: How does data volume affect query cost in Snowflake?
>  As data volume increases, more micro-partitions are read from remote storage, increasing warehouse uptime, which in turn increases cost—even if query complexity remains the same.



Q2: What do you pay for in Snowflake during query execution?
>  You pay for the warehouse uptime, not for the query execution itself. Even idle warehouses cost money if they’re running.



## Micro-partition Scanning
Q3: Why does Snowflake sometimes scan unnecessary data during query execution?
>  Snowflake retrieves data in micro-partitions, which may contain more data than required. Without ordering or clustering, it can’t precisely fetch only the relevant data.



Q4: How does unordered data in remote storage affect performance?
>  Unordered data leads to scanning excess micro-partitions, increasing compute time and cost.



## Clustering & Ordering
Q5: How does clustering help in query performance?
>  Clustering organizes micro-partitions by specified columns, allowing Snowflake to read fewer partitions and fetch data more efficiently.



Q6: What happens to clustering when data is frequently updated?
>  Insert/update/delete operations can disorder the data, requiring reclustering to maintain performance.



## Scaling Warehouses
Q7: When should you scale up a Snowflake warehouse?
>  Scale up when data volume increases and you need more memory and disk space to process a single large query faster.



Q8: When should you scale out a Snowflake warehouse?
>  Scale out when multiple queries are competing for resources; adding clusters helps parallelize the workload.



## Query Performance
Q9: How can bad join conditions affect performance in Snowflake?
>  Bad joins (like joining on columns with duplicates) can lead to exploding join results and long execution times.



Q10: What should you check if a query runs slowly?
>  Use the Query Profile to inspect stages like table scan, joins, and result writing to identify bottlenecks.

Q11: What causes exploding joins in Snowflake?
>  Joining tables on non-unique keys or using Cartesian joins can multiply result sets unexpectedly.



## Storage Optimization Features
Q12: What are the three main storage optimization techniques in Snowflake?
> 

Automatic Clustering

Search Optimization

Materialized Views



Q13: What is the benefit of ordering data in storage?
>  Ordered data reduces the number of micro-partitions scanned, lowering compute time and cost.



## Snowflake's Revenue Model
Q14: How does Snowflake generate revenue?
>  Primarily by selling compute resources—either serverless (e.g., for clustering) or user-provisioned warehouses.



Q15: Why might Snowflake avoid building a drastically more efficient query engine?
>  More efficient processing would reduce warehouse uptime, decreasing customer bills—and thus Snowflake’s revenue.



## Warehouse Monitor
Q16: What is a Warehouse Monitor in Snowflake?
>  A monitoring tool that tracks credit usage across warehouses and can notify or suspend warehouses when thresholds are reached.



Q17: What actions can a warehouse monitor take when thresholds are met?
> 

Notify

Notify & Suspend

Notify & Suspend Immediately



Q18: What's the difference between 'Suspend' and 'Suspend Immediately'?
> 

Suspend: Waits for running queries to finish

Suspend Immediately: Terminates all activity instantly



## Budget Object in Snowflake
Q19: What is the purpose of a Budget object in Snowflake?
>  To monitor costs associated with objects like tables, databases, pipes, tasks, and materialized views.



Q20: Is the Budget object available in Snowflake trial accounts?
>  No, it’s only available in standard (paid) accounts and not in government regions.

Q21: What’s the difference between ‘Suspend’ and ‘Suspend Immediately’ when managing warehouses? when to use what ? 
> 'Suspend' pauses a warehouse only after all running queries are completed, so it avoids disrupting any ongoing processes. On the other hand, 'Suspend Immediately' stops the warehouse right away, even if there are active queries, which could result in query failures.
>> Use 'Suspend' during routine operations when you want to save costs but still let ongoing queries finish smoothly. It's great for non-urgent scenarios. 'Suspend Immediately' is best for urgent situations—like stopping excessive costs from runaway queries—where halting the warehouse quickly outweighs the risk of disrupting any processes.

Q22:  Imagine you’re working on a Snowflake database with a massive table containing billions of rows, and users are experiencing slow query performance when filtering on a specific column. How would you approach diagnosing and optimizing the performance of these queries in a real-world scenario?
> In this situation, you can start by checking the query execution plan to identify bottlenecks. Implement clustering keys on the column being filtered to improve data pruning. If the column has low cardinality, consider using Search Optimization Service to accelerate filtering. Also, monitor and tune warehouse size based on query demand.
>> First, use the Query Profile feature in Snowflake to analyze the execution plan and spot inefficiencies—like full table scans or high processing times. If you notice full table scans, try adding a clustering key on the column being filtered. This helps Snowflake prune unnecessary micro-partitions and fetch data faster. For columns with low cardinality—like status flags or boolean fields—enabling Search Optimization Service can drastically improve query speed. Lastly, ensure your warehouse size is appropriate; scaling up temporarily might help heavy queries, but scaling out could be better for concurrent users. 