--CELEBAL TECHNOLOGIES
--SUMMER INTERN
--CHETANYA YADAV
--ID:CT_CSI_SQ_1260

CREATE TABLE DateDimension (
    SKDate INT PRIMARY KEY,
    KeyDate DATE UNIQUE,
    [Date] DATE,
    CalendarDay INT,
    CalendarMonth INT,
    CalendarQuarter INT,
    CalendarYear INT,
    DayNameLong VARCHAR(20),
    DayNameShort VARCHAR(10),
    DayNumberOfWeek INT,
    DayNumberOfYear INT,
    DaySuffix VARCHAR(5),
    FiscalWeek INT,
    FiscalPeriod INT,
    FiscalQuarter INT,
    FiscalYear INT,
    FiscalYearPeriod VARCHAR(10)
);
GO
