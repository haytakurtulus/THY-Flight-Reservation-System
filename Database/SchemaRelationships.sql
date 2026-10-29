use [Thy_Proje]
SELECT 
    FK.name AS [Ýliþki Adý],
    TP.name AS [Ana Tablo (Parent)],
    RCP.name AS [Ana Kolon],
    TR.name AS [Baðlý Tablo (Child)],
    RC.name AS [Baðlý Kolon]
FROM sys.foreign_keys FK
INNER JOIN sys.tables TP ON FK.referenced_object_id = TP.object_id
INNER JOIN sys.tables TR ON FK.parent_object_id = TR.object_id
INNER JOIN sys.foreign_key_columns FKC ON FKC.constraint_object_id = FK.object_id
INNER JOIN sys.columns RC ON FKC.parent_column_id = RC.column_id AND FKC.parent_object_id = RC.object_id
INNER JOIN sys.columns RCP ON FKC.referenced_column_id = RCP.column_id AND FKC.referenced_object_id = RCP.object_id
