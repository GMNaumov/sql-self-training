# Файловая группа и создание таблиц, оптимизированных для памяти

Перед созданием таблиц нужна файловая группа `CONTAINS MEMORY_OPTIMIZED_DATA` с контейнером. Это файловое хранилище для checkpoint-данных, а не способ поместить `.mdf` в оперативную память. Пути выбирает администратор в будущей лаборатории.

**Сценарий подготовки:** создайте отдельную базу `SqlTraining`, установите совместимость `120`, добавьте memory-optimized файловую группу и контейнер через `ALTER DATABASE ... ADD FILEGROUP ... CONTAINS MEMORY_OPTIMIZED_DATA` и `ADD FILE ... TO FILEGROUP`. Проверьте свободное место, права службы и поддержку Enterprise. Полный пример команд с путями следует адаптировать к реальному экземпляру; на текущем стенде отдельная база `SqlTraining` ещё не подготовлена.

Например, для **уже отдельно созданной** базы `SqlTraining` команды подготовки имеют следующую форму. Родительская папка должна существовать и быть доступной службе, а конечный путь контейнера — быть новым. Имена и расположение учебные, эти команды здесь не выполнялись:

```sql
ALTER DATABASE SqlTraining SET COMPATIBILITY_LEVEL = 120;
ALTER DATABASE SqlTraining
ADD FILEGROUP LabMemory CONTAINS MEMORY_OPTIMIZED_DATA;
ALTER DATABASE SqlTraining
ADD FILE (NAME = N'LabMemoryContainer',
          FILENAME = N'E:\SqlLabData\SqlTrainingMemory')
TO FILEGROUP LabMemory;
USE SqlTraining;
GO
```

В подготовленной базе определение таблицы:

```sql
CREATE TABLE dbo.LabOrderState
(
    OrderID int NOT NULL PRIMARY KEY NONCLUSTERED HASH
        WITH (BUCKET_COUNT = 1024),
    Status int NOT NULL,
    CreatedAt datetime2 NOT NULL,
    INDEX IX_CreatedAt NONCLUSTERED (CreatedAt)
)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
```

Уникальный `OrderID` определяет заказ, `Status` — состояние, `CreatedAt` — время. Размер hash здесь учебный, а не универсальный. `SCHEMA_AND_DATA` сохраняет подтверждённые данные при обычной полной устойчивости транзакций.

**Ошибка:** выполнить только `CREATE TABLE` в неподготовленной базе и принять отказ за неподдерживаемый синтаксис. Сначала проверьте сервер, редакцию, файловую группу и ограничения типов. Не путайте эту таблицу с уже существующим объектом AdventureWorks: это новый учебный объект.

[Назад к разделу](../README.md)
