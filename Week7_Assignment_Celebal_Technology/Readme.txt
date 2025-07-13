 SCD (Slowly Changing Dimensions) – SQL Server Stored Procedures
📌 Overview
This repository contains Stored Procedures for handling Slowly Changing Dimensions (SCD) Types 0 through 6 using SQL Server Management Studio (SSMS). These procedures were created as part of my internship assignment at Celebal Technology, focusing on mastering data warehousing concepts and implementation using SQL.

🔢 SCD Types Covered
SCD Type	Description
SCD Type 0	Retains original data, no changes allowed (Fixed Dimension)
SCD Type 1	Overwrites old data with new data (No history)
SCD Type 2	Tracks history by creating a new record with each change
SCD Type 3	Tracks limited history using previous and current columns
SCD Type 4	Uses a separate history table to track changes
SCD Type 6	Combines SCD Types 1, 2, and 3 for comprehensive tracking

Each stored procedure is written separately for clarity and ease of understanding.


🛠️ Technologies Used
SQL Server Management Studio (SSMS)

T-SQL (Transact-SQL)

📚 What I Learned
Real-time data warehouse concepts

Differences and use-cases for each SCD type

Writing modular stored procedures

Data versioning and audit trail maintenance

How to use MERGE, CASE, INSERT, and UPDATE logic efficiently

🙋‍♂️ Author
Chetanya Yadav
SQL Developer Intern – Celebal Technology
Student_id:CT_CSI_SQ_1260
📧 yadavchetanya111@gmail.com
🔗 LinkedIn:https://www.linkedin.com/in/chetanya-yadav-07a048207/