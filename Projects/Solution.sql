CREATE TABLE FileSystem
(
NodeID INT PRIMARY KEY
,
NodeName VARCHAR
(255),
ParentID INT
,
SizeBytes INT
);
INSERT INTO FileSystem (NodeID, NodeName, ParentID, SizeBytes) VALUES
(1, 'Documents', NULL, NULL),
(2, 'Pictures', NULL, NULL),
(3, 'File1.txt', 1, 500),
(4, 'Folder1', NULL, NULL),
(5, 'Image.jpg', 2, 1200),
(6, 'Subfolder1', 4, NULL),
(7, 'File2.txt', 4, 750),
(8, 'File3.txt', 3, 300),
(9, 'Folder2', 2, NULL),
(10, 'File4.txt', 9, 250);
WITH FileHierarchy AS
(
-- Start with each node as its own root
SELECT
NodeID AS RootID
,
NodeID
,
SizeBytes
FROM FileSystem
UNION ALL
-- Recursively join children
SELECT
fh
.RootID
,
fs
.NodeID
,
fs
.SizeBytes
FROM FileHierarchy fh
JOIN FileSystem fs ON fs
.ParentID = fh
.NodeID
)
-- Final aggregation
SELECT
fs
.NodeID
,
fs
.NodeName
,
SUM
(COALESCE
(fh
.SizeBytes,
0)) AS SizeBytes
FROM FileHierarchy fh
JOIN FileSystem fs ON fs
.NodeID = fh
.RootID
GROUP BY fs
.NodeID, fs
.NodeName
ORDER BY fs
.NodeID
;