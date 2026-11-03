# Восстановление AdventureWorks2014 и AdventureWorksDW2014

Резервная копия (backup) `.bak` содержит данные для восстановления базы, а не текст запросов. Её нельзя открыть как таблицу. Восстановление (restore) создаёт файлы базы на сервере. Исходные копии в корне проекта нужно сохранить неизменными.

Сначала в будущей лаборатории получите список файлов:

```sql
RESTORE FILELISTONLY
FROM DISK = N'D:\Projects\sql-self-training\AdventureWorks2014.bak';
```

Это путь с точки зрения сервера. Учётная запись службы SQL Server должна иметь доступ к файлу. В выводе найдите логические имена файлов данных и журнала. Затем в SSMS выберите Restore Database → Device, укажите копию и отдельные целевые пути на странице Files. Повторите для DW. Не используйте `WITH REPLACE` для обхода непонятной ошибки: этот параметр может разрешить перезапись существующей базы.

После восстановления проверьте:

```sql
SELECT name, state_desc, compatibility_level
FROM sys.databases
WHERE name IN (N'AdventureWorks2014', N'AdventureWorksDW2014');
-- Только в подготовленной учебной среде:
ALTER DATABASE AdventureWorks2014 SET COMPATIBILITY_LEVEL = 120;
ALTER DATABASE AdventureWorksDW2014 SET COMPATIBILITY_LEVEL = 120;
```

Ожидаемое состояние доступной базы — `ONLINE`. Отдельно выполните `DBCC CHECKDB` в лаборатории и прочитайте результат: наличие имени базы ещё не доказывает целостность. Копию новой версии сервера нельзя восстановить на старой версии, понижение совместимости это не исправляет.

**Самопроверка.** Почему файл виден вам, но restore получает отказ? Доступ к нему нужен службе сервера. Официальные сведения: [AdventureWorks и восстановление](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure).

[Назад к разделу](../README.md)
