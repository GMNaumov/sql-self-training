/* NULL и трёхзначная логика. */
USE AdventureWorks2014;
GO
/* 1. Простой: NULL проверяется через IS NULL. */
SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color IS NULL
ORDER BY ProductID;
GO

/* 2. Продвинутый: UNKNOWN не равен FALSE и не проходит WHERE. */
DECLARE @KnownColor nvarchar(15) = N'Red',
        @UnknownColor nvarchar(15) = NULL;
SELECT ColorPredicate = CASE WHEN @KnownColor = N'Red' THEN N'TRUE' ELSE N'FALSE' END;
SELECT UnknownPredicate = CASE WHEN @UnknownColor = N'Red' THEN N'TRUE'
                               WHEN @UnknownColor <> N'Red' THEN N'FALSE'
                               ELSE N'UNKNOWN' END;
SELECT NotUnknownPredicate = CASE WHEN NOT (@UnknownColor = N'Red') THEN N'TRUE'
                                  WHEN NOT (@UnknownColor <> N'Red') THEN N'FALSE'
                                  ELSE N'UNKNOWN' END;
GO

/* 3. Практический: отчёт о заполненности необязательных полей сотрудников. */
SELECT COUNT(*) AS AllPeople,
       COUNT(MiddleName) AS WithMiddleName,
       SUM(CASE WHEN MiddleName IS NULL THEN 1 ELSE 0 END) AS MissingMiddleName,
       SUM(CASE WHEN MiddleName = N'' THEN 1 ELSE 0 END) AS EmptyMiddleName
FROM Person.Person;

-- NULL и пустая строка — разные состояния; не объединяйте их без бизнес-правила.
GO
