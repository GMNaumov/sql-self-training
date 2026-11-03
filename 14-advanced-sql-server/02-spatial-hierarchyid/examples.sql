/* Пространственные типы и hierarchyid. */
/* 1. Простой: geography хранит координаты, расстояние возвращается в метрах. */
DECLARE @Moscow geography = geography::Point(55.7558, 37.6173, 4326);
DECLARE @Kazan geography = geography::Point(55.7963, 49.1088, 4326);
SELECT @Moscow.STDistance(@Kazan) / 1000.0 AS DistanceKm;
GO

/* 2. Продвинутый: hierarchyid адресует узел дерева и его потомков. */
CREATE TABLE #OrgUnit
(
    Node hierarchyid NOT NULL PRIMARY KEY,
    UnitName nvarchar(100) NOT NULL
);
INSERT #OrgUnit VALUES
(hierarchyid::Parse(N'/'), N'Компания'),
(hierarchyid::Parse(N'/1/'), N'Производство'),
(hierarchyid::Parse(N'/1/1/'), N'Сборка');
SELECT Node.ToString() AS NodePath, UnitName
FROM #OrgUnit
WHERE Node.IsDescendantOf(hierarchyid::Parse(N'/1/')) = 1;
DROP TABLE #OrgUnit;
GO

/* 3. Практический: geometry ищет пересечение учебных производственных зон. */
DECLARE @ZoneA geometry = geometry::STGeomFromText('POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))', 0);
DECLARE @ZoneB geometry = geometry::STGeomFromText('POLYGON((5 5, 15 5, 15 15, 5 15, 5 5))', 0);
SELECT @ZoneA.STIntersects(@ZoneB) AS Intersects,
       @ZoneA.STIntersection(@ZoneB).STArea() AS IntersectionArea;
GO
