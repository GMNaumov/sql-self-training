/* Источники данных и измерения SSAS Multidimensional. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: именованный запрос измерения даты. */
SELECT DateKey, FullDateAlternateKey, CalendarYear,
       CalendarQuarter, MonthNumberOfYear, EnglishMonthName
FROM dbo.DimDate;
GO

/* 2. Продвинутый: ключи и атрибуты иерархии продукта. */
SELECT p.ProductKey, p.EnglishProductName,
       ps.ProductSubcategoryKey, ps.EnglishProductSubcategoryName,
       pc.ProductCategoryKey, pc.EnglishProductCategoryName
FROM dbo.DimProduct AS p
LEFT JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
LEFT JOIN dbo.DimProductCategory AS pc ON pc.ProductCategoryKey = ps.ProductCategoryKey;
GO

/* 3. Практический: проверка уникальности ключа перед processing. */
SELECT ProductKey, COUNT(*) AS DuplicateCount
FROM dbo.DimProduct
GROUP BY ProductKey
HAVING COUNT(*) > 1;
GO
/* Пустой результат необходим для корректного KeyColumns измерения Product. */
