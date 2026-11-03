# Columnstore в SQL Server 2014

Columnstore хранит данные по столбцам в сжатых сегментах, а не только по строкам. Это полезно для больших сканирований и агрегатов: отчёт читает нужные столбцы, сжатие уменьшает объём, пакетное выполнение обрабатывает группы строк. Поиск одной строки по ключу — другая нагрузка.

В SQL Server 2014 Enterprise кластеризованный columnstore допускает `INSERT`, `UPDATE` и `DELETE`, но таблица с ним не может иметь дополнительные обычные B-tree индексы. Некластеризованный columnstore делает базовую таблицу недоступной для прямых DML-изменений до отключения или удаления индекса. Возможности обновляемого nonclustered columnstore поздних версий здесь применять нельзя.

**Учебный эксперимент на отдельной базе:**

```sql
SELECT ProductKey, OrderDateKey, SalesAmount
INTO dbo.LabInternetSales
FROM AdventureWorksDW2014.dbo.FactInternetSales;
CREATE CLUSTERED COLUMNSTORE INDEX CCI_LabInternetSales
ON dbo.LabInternetSales;
SELECT ProductKey, SUM(SalesAmount) AS Amount
FROM dbo.LabInternetSales GROUP BY ProductKey;
```

Это создаёт новую таблицу и не перестраивает оригинальный факт. Сравните её с rowstore на одинаковом объёме; небольшая учебная база может не показать пользу, характерную для миллионов строк.

**Ошибка:** обещать ускорение всех OLTP-запросов или переносить сюда фильтрованный обновляемый NCCI. Ограничения типов, индексов и выполнения проверяются для 2014. Источник: [раздел SQL Server 2014 в истории Columnstore](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/columnstore-indexes-what-s-new#sql-server-2014-12x).

[Назад к разделу](../README.md)
