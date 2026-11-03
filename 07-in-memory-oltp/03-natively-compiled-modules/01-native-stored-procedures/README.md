# Нативно скомпилированные хранимые процедуры

После создания `dbo.LabOrderState` в подготовленной учебной базе можно определить простой модуль чтения. Объекты таблицы и процедуры должны находиться в одной базе; `SCHEMABINDING` связывает модуль с определением таблицы.

```sql
CREATE PROCEDURE dbo.GetLabOrderState @OrderID int
WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH
(
    TRANSACTION ISOLATION LEVEL = SNAPSHOT,
    LANGUAGE = N'us_english'
)
    SELECT OrderID, Status
    FROM dbo.LabOrderState
    WHERE OrderID = @OrderID;
END;
GO
EXEC dbo.GetLabOrderState @OrderID = 123;
```

Если заказ отсутствует, вернётся пустой набор. `EXECUTE AS OWNER` — контекст безопасности, который требует осознанного выбора; он не должен служить оправданием выдачи широких прав приложению. Язык и изоляция зафиксированы в атомарном блоке.

Создание должно начинать пакет. Пример предназначен для SQL Server 2014 с подготовленным In-Memory OLTP и ещё требует проверки выполнением. У native-модуля нет права читать `AdventureWorks2014.Production.Product` как обычную дисковую таблицу.

**Ошибка:** ожидать ускорение простого запроса на пустой таблице как доказательство пользы. Нужны реалистичные строки, частота вызовов и конкурентная нагрузка. Отдельно измеряйте обычную процедуру на тех же memory-optimized данных, чтобы понять вклад native-компиляции.

[Назад к разделу](../README.md)
