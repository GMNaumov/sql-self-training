/* Проверка целостности базы. */
/* 1. Простой: последняя известная успешная CHECKDB. */
DBCC DBINFO (N'AdventureWorks2014') WITH TABLERESULTS;
GO
/* В выводе ищите dbi_dbccLastKnownGood; результат DBINFO не заменяет новую проверку. */

/* 2. Продвинутый: PHYSICAL_ONLY проверяет меньше, чем полная CHECKDB. */
/*
DBCC CHECKDB (N'AdventureWorks2014') WITH PHYSICAL_ONLY, NO_INFOMSGS, ALL_ERRORMSGS;
*/
GO

/* 3. Практический: полная проверка учебной копии перед исправлением production. */
/*
DBCC CHECKDB (N'AW_RestoreLab') WITH NO_INFOMSGS, ALL_ERRORMSGS;
*/
GO
/* REPAIR_ALLOW_DATA_LOSS может удалить данные; не является первым действием при повреждении. */
