# Нарастающие итоги и скользящие вычисления

Нарастающий итог складывает значения от начала периода до текущей точки. Скользящий показатель использует ограниченное окно, например семь дней. Перед вычислением определите одну строку на нужную единицу времени.

```sql
;WITH Monthly AS
(
    SELECT d.CalendarYear, d.MonthNumberOfYear,
           SUM(f.SalesAmount) AS Amount
    FROM dbo.FactInternetSales AS f
    JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
    GROUP BY d.CalendarYear, d.MonthNumberOfYear
)
SELECT CalendarYear, MonthNumberOfYear, Amount,
       SUM(Amount) OVER
       (PARTITION BY CalendarYear ORDER BY MonthNumberOfYear
        ROWS UNBOUNDED PRECEDING) AS YearToDate
FROM Monthly
ORDER BY CalendarYear, MonthNumberOfYear;
```

Контекст — DW. `PARTITION BY CalendarYear` сбрасывает итог в начале года. Для сумм 100, 200, 50 получится 100, 300, 350. Если нужен итог всей истории, уберите разделение по году.

Для семидневной средней сначала сформируйте полный календарь дней с дневной суммой, затем `AVG(...) OVER(ORDER BY Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)`. Первые дни имеют неполную рамку; решите, показывать ли их. Отсутствующие дни и `NULL` меняют знаменатель среднего.

**Ошибка:** усреднять месячные средние без весов или считать строку позиции днём. Уровень входа определяет математический смысл окна.

**Самопроверка.** Равен ли итог декабря годовой сумме? Да, если входят все нужные месяцы, данные и определение меры согласованы, а годовая рамка не обрезана внешними условиями раньше расчёта.

[Назад к разделу](../README.md)
