# Задачи на подзапросы и оконные функции

**Задача 1.** Найдите последний заказ каждого покупателя, имеющего заказы. Последний определяется максимальной датой, при равенстве — максимальным `SalesOrderID`.

```sql
;WITH Ranked AS
(
    SELECT CustomerID, SalesOrderID, OrderDate,
           ROW_NUMBER() OVER
           (PARTITION BY CustomerID
            ORDER BY OrderDate DESC, SalesOrderID DESC) AS rn
    FROM Sales.SalesOrderHeader
)
SELECT CustomerID, SalesOrderID, OrderDate
FROM Ranked WHERE rn = 1
ORDER BY CustomerID;
```

Внешний фильтр нужен потому, что окно недоступно в `WHERE` своего уровня. `MAX(OrderDate)` даёт дату, но не автоматически всю строку заказа. Если вернуть все ничьи, понадобится иная логика ранга. Для сохранения клиентов без заказов подходит `OUTER APPLY` от `Sales.Customer`.

**Задача 2.** Найдите товары, чья цена выше средней среди товаров их подкатегории. Товары без подкатегории исключите явно.

```sql
SELECT p.ProductID, p.Name, p.ListPrice
FROM Production.Product AS p
WHERE p.ProductSubcategoryID IS NOT NULL
  AND p.ListPrice >
  (
      SELECT AVG(p2.ListPrice)
      FROM Production.Product AS p2
      WHERE p2.ProductSubcategoryID = p.ProductSubcategoryID
  );
```

Здесь среднее включает текущий товар и нулевые цены; если условие иное, измените набор среднего. Аналог — CTE с `AVG(...) OVER(PARTITION BY ProductSubcategoryID)` и внешним сравнением.

**Проверка:** подкатегория с одним товаром не даст результата при строгом `>`; цены 10,20,30 дадут только 30. `NULL` подкатегории не должен случайно стать отдельной общей категорией, если условие её исключает.

**Обсуждение:** полезность индекса оценивайте по фильтру, группировке, объёму и плану. Не обещайте, что коррелированный запрос обязательно физически выполняется полностью заново для каждой строки.

[Назад к разделу](../README.md)
