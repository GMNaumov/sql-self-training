# Изучение AdventureWorksDW2014

Начинайте знакомство с DW с карты таблиц и ключей. `FactInternetSales` — позиции интернет-продаж; `FactResellerSales` — продажи через посредников. `DimDate` — календарь; `DimProduct` — продукты; `DimCustomer` — клиенты интернет-канала; `DimSalesTerritory` — территории.

```sql
SELECT TOP (10) f.SalesOrderNumber, f.SalesOrderLineNumber,
       d.FullDateAlternateKey AS OrderDate,
       p.EnglishProductName, f.OrderQuantity, f.SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
ORDER BY f.SalesOrderNumber, f.SalesOrderLineNumber;
```

Выполняется в `AdventureWorksDW2014`. Ключ даты — техническое целое, хотя часто выглядит как `yyyymmdd`; для календарных операций используйте настоящее поле даты или измерение, а не арифметику `DateKey + 1`.

Изучите зерно через сочетание номера заказа и позиции, число фактов и уникальность ключей измерений. Сравните даты заказа, срока и отправки: это разные роли календаря. Не соединяйте их произвольным `OR`, иначе смысл отчёта станет неясным.

Набор данных учебный и исторический. Отсутствие продаж в текущем году не означает ошибку запроса. Выбирайте диапазон после просмотра доступных дат.

**Самопроверка.** Можно ли напрямую приравнять `ProductKey` в DW к `ProductID` в OLTP? Нет: суррогатный ключ и ключ источника имеют разные роли. Используйте явное соответствие бизнес-ключей с учётом версий.

[Назад к разделу](../README.md)
