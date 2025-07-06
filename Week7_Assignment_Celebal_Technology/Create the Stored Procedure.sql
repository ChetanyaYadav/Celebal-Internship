CREATE PROCEDURE Apply_SCD_Type0
AS
BEGIN
    -- Only insert new records that don't exist in the target
    INSERT INTO target_table (id, name, city)
    SELECT s.id, s.name, s.city
    FROM source_table s
    LEFT JOIN target_table t ON s.id = t.id
    WHERE t.id IS NULL;
END;
