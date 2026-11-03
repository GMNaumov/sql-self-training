# Задачи на группы и разрывы, дубликаты и реляционное деление

**Группы и разрывы (gaps and islands).** Даны даты активности; найдите непрерывные серии дней. Сначала устраните повторные даты, иначе нумерация разрушит группировку.

```sql
;WITH Days AS
(
    SELECT DISTINCT CAST(OrderDate AS date) AS DayDate
    FROM Sales.SalesOrderHeader
), Numbered AS
(
    SELECT DayDate, ROW_NUMBER() OVER(ORDER BY DayDate) AS rn
    FROM Days
), Marked AS
(
    SELECT DayDate, DATEADD(day, -CONVERT(int,rn), DayDate) AS IslandKey
    FROM Numbered
)
SELECT MIN(DayDate) AS StartDay, MAX(DayDate) AS EndDay, COUNT(*) AS Days
FROM Marked
GROUP BY IslandKey
ORDER BY StartDay;
```

В непрерывной серии и дата, и номер увеличиваются на 1, поэтому разность постоянна. Для дат 1,2,4 января серии — 1–2 и 4. Приведение `rn` к `int` здесь подходит для числа различных дат демонстрационной базы; для других задач учитывайте диапазон.

**Дубликаты.** В учебной `#Import` с `ImportID`, `BusinessKey`, `LoadedAt` оставьте наиболее свежую строку:

```sql
;WITH Duplicates AS
(
    SELECT *, ROW_NUMBER() OVER
      (PARTITION BY BusinessKey ORDER BY LoadedAt DESC, ImportID DESC) AS rn
    FROM #Import
)
SELECT * FROM Duplicates WHERE rn > 1;
```

Это безопасный просмотр кандидатов, не удаление. Таблицу нужно заранее создать и наполнить в лаборатории. После проверки можно спроектировать транзакционное удаление и уникальное ограничение. «Одинаковое имя» само по себе не определяет бизнес-дубликат.

**Реляционное деление.** Найдите покупателей, купивших все товары подкатегории 1:

```sql
SELECT c.CustomerID
FROM Sales.Customer AS c
WHERE NOT EXISTS
(
    SELECT 1 FROM Production.Product AS p
    WHERE p.ProductSubcategoryID = 1
      AND NOT EXISTS
      (
          SELECT 1
          FROM Sales.SalesOrderHeader AS h
          JOIN Sales.SalesOrderDetail AS d ON d.SalesOrderID = h.SalesOrderID
          WHERE h.CustomerID = c.CustomerID AND d.ProductID = p.ProductID
      )
);
```

Смысл: «нет требуемого товара, который покупатель не купил». Повторная покупка не помогает закрыть другой товар. Если требуемый набор пуст, условие истинно для всех клиентов; это математическое правило нужно согласовать с бизнесом или добавить проверку непустоты.

[Назад к разделу](../README.md)
