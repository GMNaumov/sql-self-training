/* Обобщённые табличные выражения (CTE). */
USE AdventureWorks2014;
GO
/* 1. Простой: именованный промежуточный результат. */
WITH ProductSales AS
(
    SELECT ProductID, SUM(OrderQty) AS Units, SUM(LineTotal) AS Revenue
    FROM Sales.SalesOrderDetail
    GROUP BY ProductID
)
SELECT TOP (20) p.ProductID, p.Name, s.Units, s.Revenue
FROM ProductSales AS s
JOIN Production.Product AS p ON p.ProductID = s.ProductID
ORDER BY s.Revenue DESC;
GO

/* 2. Продвинутый: рекурсивный обход небольшой иерархии сотрудников. */
CREATE TABLE #Employee
(
    EmployeeID int NOT NULL PRIMARY KEY,
    EmployeeName nvarchar(50) NOT NULL,
    ManagerID int NULL
);
INSERT #Employee VALUES (1, N'Директор', NULL), (2, N'Менеджер', 1),
       (3, N'Разработчик', 2), (4, N'Аналитик', 2), (5, N'Стажёр', 3);
WITH OrgTree AS
(
    SELECT EmployeeID, EmployeeName, ManagerID, 0 AS Level,
           CAST(N'/' + CAST(EmployeeID AS nvarchar(20)) + N'/' AS nvarchar(4000)) AS Path
    FROM #Employee WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID, t.Level + 1,
           CAST(t.Path + CAST(e.EmployeeID AS nvarchar(20)) + N'/' AS nvarchar(4000))
    FROM #Employee AS e JOIN OrgTree AS t ON e.ManagerID = t.EmployeeID
    WHERE t.Path NOT LIKE N'%/' + CAST(e.EmployeeID AS nvarchar(20)) + N'/%'
)
SELECT EmployeeID, EmployeeName, Level, Path FROM OrgTree ORDER BY Path;
DROP TABLE #Employee;
GO

/* 3. Практический: разузлование комплекта велосипеда. */
WITH BOM AS
(
    SELECT b.ProductAssemblyID, b.ComponentID, b.PerAssemblyQty,
           CAST(b.PerAssemblyQty AS decimal(38,6)) AS TotalQuantity, 0 AS Level
    FROM Production.BillOfMaterials AS b
    WHERE b.ProductAssemblyID = 800 AND b.EndDate IS NULL
    UNION ALL
    SELECT b.ProductAssemblyID, b.ComponentID, b.PerAssemblyQty,
           CAST(x.TotalQuantity * b.PerAssemblyQty AS decimal(38,6)), x.Level + 1
    FROM BOM AS x
    JOIN Production.BillOfMaterials AS b
      ON b.ProductAssemblyID = x.ComponentID AND b.EndDate IS NULL
    WHERE x.Level < 20
)
SELECT p.ProductID, p.Name, x.Level, x.TotalQuantity
FROM BOM AS x JOIN Production.Product AS p ON p.ProductID = x.ComponentID
ORDER BY x.Level, p.ProductID;
GO
