# Задачи на соединения и агрегацию

**Условие.** Для каждого покупателя выведите число заказов 2014 года и сумму товаров; покупатели без заказов должны остаться с нулями. Одна строка — один `CustomerID`.

```sql
SELECT c.CustomerID,
       COUNT(h.SalesOrderID) AS OrderCount,
       COALESCE(SUM(h.SubTotal), 0) AS GoodsAmount
FROM Sales.Customer AS c
LEFT JOIN Sales.SalesOrderHeader AS h
  ON h.CustomerID = c.CustomerID
 AND h.OrderDate >= '20140101' AND h.OrderDate < '20150101'
GROUP BY c.CustomerID
ORDER BY c.CustomerID;
```

Фильтр правого источника находится в `ON`, поэтому клиент без подходящих заказов сохраняется. `COUNT(h.SalesOrderID)` не считает дополненную строку; `COUNT(*)` дал бы 1. `COALESCE` отображает отсутствие суммы как 0 по условию задачи.

**Проверка вручную.** У A два заказа на 100 и 200, у B ни одного: A получает 2 и 300, B — 0 и 0. Добавьте у A заказ в 2013 году: результат не меняется. Перенос годового фильтра в `WHERE` убрал бы B.

**Дополнительная задача.** Выведите только покупателей, которые купили товар 707, без повторов.

```sql
SELECT c.CustomerID
FROM Sales.Customer AS c
WHERE EXISTS
(
    SELECT 1
    FROM Sales.SalesOrderHeader AS h
    JOIN Sales.SalesOrderDetail AS d ON d.SalesOrderID = h.SalesOrderID
    WHERE h.CustomerID = c.CustomerID AND d.ProductID = 707
);
```

`EXISTS` сохраняет по одной строке клиента независимо от количества подходящих позиций. Это не означает, что join с последующим `DISTINCT` всегда медленнее; преимущество здесь — явный смысл проверки существования.

**Типичная ошибка:** присоединить позиции к первому запросу и суммировать `h.SubTotal`: каждый заголовок повторится по числу позиций. Предварительно агрегируйте на нужном уровне или используйте меры позиции.

[Назад к разделу](../README.md)
