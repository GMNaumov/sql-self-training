# Microsoft SQL Server 2014: с нуля до собеседования

Русскоязычный самоучитель для начинающего разработчика: от первого запроса до разбора задач собеседований, производительности и эксплуатации. Целевая среда — **Microsoft SQL Server 2014 Enterprise**, совместимость реляционных учебных баз — **120**. Основные данные — AdventureWorks2014 и AdventureWorksDW2014.

## Как начать с нуля

Начните с [маршрута и метода занятий](00-getting-started/01-course-roadmap/README.md), затем идите по разделам в указанном порядке. У каждого раздела есть введение и оглавление, у вложенных тем — возврат к родителю. Первые уроки объясняют, что такое таблица, строка и запрос; последующие используют уже введённые понятия.

**Сквозная история.** AdventureWorks — учебная компания, продающая велосипеды и сопутствующие товары. Сначала вы прочитаете каталог, затем соедините заказы с позициями, посчитаете продажи, спроектируете безопасное изменение остатка и разберёте восстановление после сбоя. В аналитической базе посмотрите на те же типы событий через факты, измерения и календарь.

Для каждой темы прочитайте объяснение, предскажите результат примера и проверьте его на маленьком наборе вручную. Измените одно условие и объясните разницу. После появления экземпляра повторите пример на сервере, сопоставьте результат с прогнозом и сохраните наблюдения. В [подготовке к собеседованиям](15-interview-preparation/README.md) есть условия, решения, типичные ошибки и итоговая самопроверка.

## Как читать примеры

- `sql` в блоке кода — SQL/T-SQL для Database Engine. По умолчанию запросы OLTP используют `AdventureWorks2014`, аналитические — `AdventureWorksDW2014`; переключайте базу явно перед выполнением.
- `Production.Product` означает таблицу `Product` схемы `Production`. `p`, `h`, `d` после `AS` — локальные псевдонимы, а не новые таблицы.
- Объекты с именами `Lab...`, `SqlTraining`, `AW_RestoreLab` — объекты будущей отдельной лаборатории. Они не гарантированно существуют в Microsoft-базах. Урок сообщает необходимые предпосылки. Создание постоянного модуля должно начинать отдельный пакет.
- Таблицы `#...` — временные объекты текущего подключения. Независимые примеры с повторяющимися именами запускайте в новых сеансах или удаляйте старые объекты после упражнения.
- `GO` — разделитель пакетов SSMS, который не отправляют как T-SQL через обычный драйвер. Код `dax` и `mdx` относится к Analysis Services и требует отдельно созданной модели.
- Пути `E:\SqlLabBackups` и `E:\SqlLabKeys`, даты восстановления, имена серверов и пароли-обозначения нужно адаптировать к стенду. Исходные `.bak` проекта нельзя использовать как выходной путь backup.

Экземпляра SQL Server на компьютере пока нет. Примеры и инструкции **не проверены выполнением**; статическая проверка текста и ссылок не заменяет запуск. Числа в маленьких поясняющих наборах — ручные иллюстрации, не измерения демонстрационных баз. Установка, восстановление, изменение конфигурации и отправка отчётов в рамках наполнения материалов не выполнялись. Отдельные `.sql`-файлы пока не создаются.

## Маршрут обучения

1. [Введение и подготовка окружения](00-getting-started/README.md)
2. [Основы реляционных баз данных и SQL](01-sql-fundamentals/README.md)
3. [Выборка и комбинирование данных](02-querying-data/README.md)
4. [Изменение данных и проектирование баз](03-data-modification-and-modeling/README.md)
5. [Программирование на T-SQL](04-tsql-programming/README.md)
6. [Транзакции и конкурентный доступ](05-transactions-and-concurrency/README.md)
7. [Индексы и производительность запросов](06-performance/README.md)
8. [In-Memory OLTP](07-in-memory-oltp/README.md)
9. [Администрирование SQL Server](08-administration/README.md)
10. [Безопасность SQL Server](09-security/README.md)
11. [Высокая доступность и аварийное восстановление](10-high-availability/README.md)
12. [Аналитические хранилища данных](11-data-warehouse/README.md)
13. [Аналитический SQL](12-analytical-sql/README.md)
14. [BI и интеграция данных](13-bi-and-integration/README.md)
15. [Дополнительные возможности SQL Server](14-advanced-sql-server/README.md)
16. [Подготовка к собеседованиям](15-interview-preparation/README.md)

## Демонстрационные данные

- `AdventureWorks2014.bak` — учебная OLTP-база.
- `AdventureWorksDW2014.bak` — учебное аналитическое хранилище.

Исходные резервные копии Microsoft хранятся в корне и должны оставаться неизменными. [Подготовка восстановления](00-getting-started/03-adventureworks-restore/README.md) объясняет серверные пути, логические имена файлов и проверку совместимости.

## Границы версии и источники

SQL Server 2014 — историческая целевая версия курса. В примерах не используются как доступные функции `STRING_AGG`, `STRING_SPLIT`, `CREATE OR ALTER`, `DROP ... IF EXISTS`, JSON-функции, temporal tables, Query Store и другие возможности более новых движков. Установка совместимости 120 на новом сервере не воспроизводит полностью старую версию. Для SSAS Tabular 2014 используется отдельная совместимость **1103**.

Материалы изложены самостоятельно на русском языке. Для уточнения синтаксиса и ограничений используйте первичные источники Microsoft. Современная страница Learn часто описывает несколько версий: читайте пометки применимости, а не переносите все её примеры в 2014.

- [AdventureWorks: базы и восстановление](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure) — происхождение учебных копий и общая процедура.
- [Оценщик кардинальности SQL Server 2014](https://www.microsoft.com/en-us/sql-server/blog/2014/03/17/the-new-and-improved-cardinality-estimator-in-sql-server-2014/) — связь оценок с выбором плана.
- [Columnstore: раздел SQL Server 2014](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/columnstore-indexes-what-s-new#sql-server-2014-12x) — обновляемый clustered и ограничения nonclustered.
- [Ограничения T-SQL для In-Memory OLTP](https://learn.microsoft.com/en-us/sql/relational-databases/in-memory-oltp/transact-sql-constructs-not-supported-by-in-memory-oltp) и [native-процедуры 2014](https://www.microsoft.com/en-us/sql-server/blog/2014/02/21/using-natively-compiled-stored-procedures-in-sql-server-2014/) — поддерживаемое подмножество языка.
- [Backup encryption](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/backup-encryption) и [TDE](https://learn.microsoft.com/en-us/sql/relational-databases/security/encryption/transparent-data-encryption) — разные границы защиты и необходимость ключей.
- [TLS 1.2 для SQL Server](https://learn.microsoft.com/en-us/troubleshoot/sql/database-engine/connect/tls-1-2-support-microsoft-sql-server) — зависимость от сборки и клиентского ПО.
- [Возможности SQL Server 2014](https://www.microsoft.com/en-us/sql-server/blog/2014/03/18/sql-server-2014-releases-april-1/) — в том числе увеличение числа вторичных AG-реплик.
- [Совместимость SSAS Tabular](https://learn.microsoft.com/en-us/analysis-services/tabular-models/compatibility-level-for-tabular-models-in-analysis-services) — 1100/1103 для старого движка.
- [Развёртывание SSIS](https://learn.microsoft.com/en-us/sql/integration-services/packages/deploy-integration-services-ssis-projects-and-packages) — отличия project/package deployment и версий.

## Что считать результатом обучения

Вы умеете объяснить число и смысл строк, выбрать ключи и ограничения, безопасно выразить изменение, найти причину задержки по измерениям и составить проверяемый план восстановления. Для аналитики — определить зерно, историю и меру, согласовать загрузку и сверить отчёт с SQL. Эти навыки развиваются практикой; чтение не заменяет испытаний на целевом экземпляре и не гарантирует результат конкретного собеседования.
