/* Нормализация: от повторяющихся значений к связанным таблицам. */
/* 1. Простой: выделить справочник покупателей из заказа. */
CREATE TABLE #Customer (CustomerID int PRIMARY KEY, CustomerName nvarchar(100) NOT NULL);
CREATE TABLE #Order
(
    OrderID int PRIMARY KEY,
    CustomerID int NOT NULL REFERENCES #Customer(CustomerID),
    OrderDate date NOT NULL
);
INSERT #Customer VALUES (1, N'ООО Север'), (2, N'ООО Юг');
INSERT #Order VALUES (101, 1, '20140101'), (102, 1, '20140102');
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM #Order AS o JOIN #Customer AS c ON c.CustomerID = o.CustomerID;
DROP TABLE #Order;
DROP TABLE #Customer;
GO

/* 2. Продвинутый: нормализовать повторяющиеся телефоны в отдельную таблицу. */
CREATE TABLE #Contact (ContactID int PRIMARY KEY, ContactName nvarchar(50) NOT NULL);
CREATE TABLE #ContactPhone
(
    ContactID int NOT NULL REFERENCES #Contact(ContactID),
    Phone nvarchar(25) NOT NULL,
    PhoneType nvarchar(15) NOT NULL,
    PRIMARY KEY (ContactID, Phone)
);
INSERT #Contact VALUES (1, N'Анна');
INSERT #ContactPhone VALUES (1, N'+7-900-000-00-01', N'Рабочий'),
                           (1, N'+7-900-000-00-02', N'Мобильный');
SELECT c.ContactName, p.PhoneType, p.Phone
FROM #Contact AS c JOIN #ContactPhone AS p ON p.ContactID = c.ContactID;
DROP TABLE #ContactPhone;
DROP TABLE #Contact;
GO

/* 3. Практический: состав заказа не дублирует название и цену справочника. */
CREATE TABLE #Product (ProductID int PRIMARY KEY, ProductName nvarchar(50) NOT NULL);
CREATE TABLE #SalesOrder (OrderID int PRIMARY KEY, OrderDate date NOT NULL);
CREATE TABLE #SalesOrderLine
(
    OrderID int NOT NULL REFERENCES #SalesOrder(OrderID),
    LineNumber int NOT NULL,
    ProductID int NOT NULL REFERENCES #Product(ProductID),
    Quantity int NOT NULL,
    UnitPriceAtSale decimal(19,4) NOT NULL, -- историческая цена сделки
    PRIMARY KEY (OrderID, LineNumber)
);
INSERT #Product VALUES (1, N'Велосипед');
INSERT #SalesOrder VALUES (10, '20140105');
INSERT #SalesOrderLine VALUES (10, 1, 1, 2, 45000.00);
SELECT o.OrderID, l.LineNumber, p.ProductName, l.Quantity, l.UnitPriceAtSale
FROM #SalesOrderLine AS l
JOIN #SalesOrder AS o ON o.OrderID = l.OrderID
JOIN #Product AS p ON p.ProductID = l.ProductID;
DROP TABLE #SalesOrderLine;
DROP TABLE #SalesOrder;
DROP TABLE #Product;
GO
