-- Source (new data feed)
INSERT INTO source_table (id, name, city)
VALUES 
    (1, 'Chetanya', 'Delhi'),
    (2, 'Bhupesh', 'Mumbai'),
    (3, 'Ashish', 'Pune');

-- Target (existing records)
INSERT INTO target_table (id, name, city)
VALUES 
    (1, 'Chetanya', 'Delhi'),
    (2, 'Bhupesh', 'Chennai');  -- Intentional mismatch (will NOT update)
