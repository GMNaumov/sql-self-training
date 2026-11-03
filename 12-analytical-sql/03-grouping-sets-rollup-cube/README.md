# GROUPING SETS, ROLLUP и CUBE

`GROUPING SETS` явно задаёт несколько уровней итогов за один запрос. `ROLLUP` создаёт иерархические итоги, `CUBE` — все сочетания измерений. С ростом числа измерений CUBE быстро увеличивает число групп.

```sql
SELECT d.CalendarYear, p.Color,
       SUM(f.SalesAmount) AS Amount,
       GROUPING(d.CalendarYear) AS IsYearTotal,
       GROUPING(p.Color) AS IsColorTotal
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
GROUP BY GROUPING SETS
((d.CalendarYear, p.Color), (d.CalendarYear), ());
```

Контекст — DW. Здесь есть год+цвет, итог года и общий итог. Строка с `IsColorTotal = 1` не означает неизвестный цвет: столбец не участвует в данном уровне агрегации. `GROUPING` отличает такой служебный `NULL` от реального `NULL` в данных.

`ROLLUP(Year, Month)` создаёт группы `(Year,Month)`, `(Year)` и `()`. `CUBE(Year,Color)` добавляет также общий итог каждого цвета по всем годам. Важно не сложить подробные и итоговые строки повторно в приложении.

**Пример ошибки.** Суммировали все строки выгрузки с годами и общим итогом и получили удвоенную сумму. Итоговая строка — альтернативное представление тех же фактов, а не новая продажа.

**Самопроверка.** Можно ли отличать итоги только через `Color IS NULL`? Нет: настоящий цвет может быть неизвестен. Используйте `GROUPING` или `GROUPING_ID`.

[Назад к разделу](../README.md)
