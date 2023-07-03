USE Presentation
GO
--SELECT * FROM dbo.vORDER_WEEK_DAY_TOP
CREATE VIEW dbo.vORDER_WEEK_DAY_TOP
AS

	WITH owd AS (SELECT 
					DATEPART(WW, o.ORDER_DATETIME)	AS WEEK_NUM,
					DATEPART(DW, o.ORDER_DATETIME)	AS WEEK_DAY,
					COUNT(1)						AS ORDER_COUNT,
					SUM(IIF(b.BRANCH_NAME = '������', 1, 0)) AS ORDER_COUNT_MOSCOW,
					SUM(IIF(b.BRANCH_NAME = '������' AND CAST(o.ORDER_DATETIME AS TIME) > '17:00:00' , 1, 0)) AS ORDER_COUNT_MOSCOW_NIGHT
				FROM Presentation.dbo.ORDER_HEADER o
					INNER JOIN Presentation.dbo.DIM_CUSTOMER cu ON cu.CUSTOMER_ID = o.CUSTOMER_ID
					INNER JOIN Presentation.dbo.DIM_BRANCH b ON b.BRANCH_ID = cu.BRANCH_ID
				WHERE YEAR(o.ORDER_DATETIME) = 2020
				GROUP BY datepart(WW, o.ORDER_DATETIME), datepart(DW, o.ORDER_DATETIME)
	)
	SELECT TOP (2)
		wd.WD_NAME						AS	[���� ������],
		AVG(ORDER_COUNT_MOSCOW)			AS	[������� ���-�� ������� � ���� ������ � ������ 2020],
		AVG(ORDER_COUNT_MOSCOW_NIGHT)	AS	[������� ���-�� �������� ������� � ���� ������ � ������ 2020],
		AVG(ORDER_COUNT)				AS	[������� ���-�� ������� � ���� ������ �� ���� �������� � 2020]
	FROM owd
	INNER JOIN Presentation.dbo.WEEK_DAY wd ON wd.WD = owd.WEEK_DAY
	GROUP BY wd.WD_NAME
	ORDER BY 2 DESC

--SELECT * FROM vORDER_WEEK_DAY_TOP