# Оконные агрегаты и рамки ROWS и RANGE

Рамка (window frame) определяет часть упорядоченного раздела относительно текущей строки. `ROWS` задаёт физические позиции строк. `RANGE` учитывает одинаковые ключи порядка; поддерживаемые формы в SQL Server 2014 ограничены и не являются произвольным интервалом «семь календарных дней».

```sql
SELECT SalesOrderID, CustomerID, OrderDate, SubTotal,
       SUM(SubTotal) OVER
       (PARTITION BY CustomerID ORDER BY OrderDate, SalesOrderID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningAmount
FROM Sales.SalesOrderHeader;
```

`UNBOUNDED PRECEDING` — начало раздела, `CURRENT ROW` — текущая строка. Получаем сумму от первого заказа покупателя до текущего. Явная рамка делает намерение понятным.

**Разница на равных значениях.** Для сумм 10 и 20 на одной дате окно с `ORDER BY OrderDate` и рамкой `RANGE ... CURRENT ROW` даст обеим строкам итог 30. `ROWS` считает по позициям, но для устойчивого промежуточного результата нужен дополнительный ключ порядка.

При `SUM` с порядком и без рамки по умолчанию обычно действует `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`, а не полный раздел. Для полного итога уберите порядок или задайте рамку до `UNBOUNDED FOLLOWING`.

**Ошибка:** считать `ROWS 6 PRECEDING` семью днями на таблице, где пропущены даты или несколько строк в день. Сначала сформируйте одну строку на календарный день, затем применяйте рамку.

[Назад к разделу](../README.md)
