# Триггеры

Триггер (trigger) — модуль, автоматически запускаемый событием. DML-триггер связан с `INSERT`, `UPDATE` или `DELETE`. Он выполняется на команду, а не отдельно на каждую строку. Таблицы `inserted` и `deleted` могут содержать много строк.

В отдельной учебной базе можно создать журнал изменений количества:

```sql
CREATE TABLE dbo.LabStock(ProductID int PRIMARY KEY, Qty int NOT NULL);
CREATE TABLE dbo.LabStockAudit(ProductID int, OldQty int, NewQty int);
GO
CREATE TRIGGER dbo.tr_LabStockAudit ON dbo.LabStock
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.LabStockAudit(ProductID, OldQty, NewQty)
    SELECT i.ProductID, d.Qty, i.Qty
    FROM inserted AS i
    JOIN deleted AS d ON d.ProductID = i.ProductID
    WHERE i.Qty <> d.Qty;
END;
```

Предполагается, что ключ товара не меняют, а `Qty` не допускает `NULL`. При массовом обновлении журнал получает запись для каждой действительно изменённой величины. `UPDATE(Qty)` само по себе означает попытку присвоения столбцу, а не доказательство изменения значения.

Триггер работает в транзакции исходной команды: ошибка и откат могут отменить обе записи. `AFTER` выполняется после успешных проверок ограничений, `INSTEAD OF` заменяет исходное действие.

**Ошибка:** `SELECT @id = ProductID FROM inserted` и последующая обработка единственного идентификатора. Такой код теряет строки при массовой операции. Простые правила диапазона и ссылок лучше задавать `CHECK` и внешними ключами, оставляя триггерам действительно необходимые действия.

[Назад к разделу](../README.md)
