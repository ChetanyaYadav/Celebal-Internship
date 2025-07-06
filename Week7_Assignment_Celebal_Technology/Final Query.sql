--Chetanya_Yadav
--Celebal_Internship
--Id:CT_CSI_SQ_1260



-- Step 1: Create Database
CREATE DATABASE SCD_Project;
GO

-- Step 2: Use the Database
USE SCD_Project;
GO

-- Step 3: Create Source Table (Staging Data)
CREATE TABLE source_table (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50)
);
GO

-- Step 4: Create Target Table (Dimension)
CREATE TABLE target_table (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    previous_city VARCHAR(50),       -- for SCD Type 3/6
    effective_date DATE,             -- for SCD Type 2/6
    end_date DATE,                   -- for SCD Type 2/6
    current_flag BIT                 -- for SCD Type 2/6
);
GO

-- Step 5: Create History Table for SCD Type 4
CREATE TABLE scd_history_table (
    id INT,
    name VARCHAR(50),
    city VARCHAR(50),
    change_date DATE
);
GO

-- Step 6: Insert Sample Data into Source and Target
INSERT INTO source_table VALUES
(1, 'Chetanya', 'Delhi'),
(2, 'Bhupesh', 'Mumbai'),
(3, 'Ashish', 'Haryana');

INSERT INTO target_table (id, name, city, previous_city, effective_date, end_date, current_flag)
VALUES
(1, 'Chetanya', 'Delhi', NULL, '2024-01-01', NULL, 1),
(2, 'Bhupesh', 'Chennai', NULL, '2024-01-01', NULL, 1);
GO

--------------------------------------------------------
-- SCD TYPE 0: No changes allowed
--------------------------------------------------------
CREATE PROCEDURE Apply_SCD_Type0
AS
BEGIN
    INSERT INTO target_table (id, name, city)
    SELECT s.id, s.name, s.city
    FROM source_table s
    LEFT JOIN target_table t ON s.id = t.id
    WHERE t.id IS NULL;
END;
GO

--------------------------------------------------------
-- SCD TYPE 1: Overwrite existing data
--------------------------------------------------------
CREATE PROCEDURE Apply_SCD_Type1
AS
BEGIN
    UPDATE t
    SET t.name = s.name,
        t.city = s.city
    FROM target_table t
    INNER JOIN source_table s ON s.id = t.id;

    INSERT INTO target_table (id, name, city)
    SELECT s.id, s.name, s.city
    FROM source_table s
    LEFT JOIN target_table t ON s.id = t.id
    WHERE t.id IS NULL;
END;
GO

--------------------------------------------------------
-- SCD TYPE 2: Track history using new rows
--------------------------------------------------------
CREATE PROCEDURE Apply_SCD_Type2
AS
BEGIN
    DECLARE @current_date DATE = GETDATE();

    -- Close current version
    UPDATE t
    SET t.end_date = @current_date,
        t.current_flag = 0
    FROM target_table t
    INNER JOIN source_table s ON s.id = t.id
    WHERE t.current_flag = 1 AND 
          (t.name <> s.name OR t.city <> s.city);

    -- Insert new version
    INSERT INTO target_table (id, name, city, effective_date, end_date, current_flag)
    SELECT s.id, s.name, s.city, @current_date, NULL, 1
    FROM source_table s
    LEFT JOIN target_table t ON s.id = t.id AND t.current_flag = 1
    WHERE t.id IS NULL OR (t.name <> s.name OR t.city <> s.city);
END;
GO

--------------------------------------------------------
-- SCD TYPE 3: Store previous value in a column
--------------------------------------------------------
CREATE PROCEDURE Apply_SCD_Type3
AS
BEGIN
    UPDATE t
    SET t.previous_city = t.city,
        t.city = s.city
    FROM target_table t
    INNER JOIN source_table s ON s.id = t.id
    WHERE t.city <> s.city;

    INSERT INTO target_table (id, name, city)
    SELECT s.id, s.name, s.city
    FROM source_table s
    LEFT JOIN target_table t ON s.id = t.id
    WHERE t.id IS NULL;
END;
GO

--------------------------------------------------------
-- SCD TYPE 4: Store history in a separate table
--------------------------------------------------------
CREATE PROCEDURE Apply_SCD_Type4
AS
BEGIN
    DECLARE @current_date DATE = GETDATE();

    -- Copy old version to history
    INSERT INTO scd_history_table (id, name, city, change_date)
    SELECT t.id, t.name, t.city, @current_date
    FROM target_table t
    INNER JOIN source_table s ON s.id = t.id
    WHERE t.name <> s.name OR t.city <> s.city;

    -- Update target
    UPDATE t
    SET t.name = s.name,
        t.city = s.city
    FROM target_table t
    INNER JOIN source_table s ON s.id = t.id;

    -- Insert new records
    INSERT INTO target_table (id, name, city)
    SELECT s.id, s.name, s.city
    FROM source_table s
    LEFT JOIN target_table t ON s.id = t.id
    WHERE t.id IS NULL;
END;
GO

--------------------------------------------------------
-- SCD TYPE 6: Hybrid (1+2+3)
--------------------------------------------------------
CREATE PROCEDURE Apply_SCD_Type6
AS
BEGIN
    DECLARE @current_date DATE = GETDATE();

    -- Close old record
    UPDATE t
    SET t.end_date = @current_date,
        t.current_flag = 0
    FROM target_table t
    INNER JOIN source_table s ON s.id = t.id
    WHERE t.current_flag = 1 AND (t.name <> s.name OR t.city <> s.city);

    -- Insert new record with historical values
    INSERT INTO target_table (id, name, city, previous_city, effective_date, end_date, current_flag)
    SELECT s.id, s.name, s.city, t.city, @current_date, NULL, 1
    FROM source_table s
    LEFT JOIN target_table t ON s.id = t.id AND t.current_flag = 1
    WHERE t.id IS NULL OR (t.name <> s.name OR t.city <> s.city);
END;
GO
