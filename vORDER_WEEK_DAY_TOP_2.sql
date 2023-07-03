USE Presentation
GO
--SELECT * FROM dbo.vORDER_WEEK_DAY_TOP_2
CREATE VIEW dbo.vORDER_WEEK_DAY_TOP_2
AS

	WITH owd AS (SELECT 
					DATEPART(WW, o.ORDER_DATETIME)	AS WEEK_NUM,
					DATEPART(DW, o.ORDER_DATETIME)	AS WEEK_DAY,
					COUNT(1)						AS ORDER_COUNT,
					SUM(IIF(b.BRANCH_NAME = 'Москва', 1, 0)) AS ORDER_COUNT_MOSCOW,
					SUM(IIF(b.BRANCH_NAME = 'Москва' AND CAST(o.ORDER_DATETIME AS TIME) > '17:00:00' , 1, 0)) AS ORDER_COUNT_MOSCOW_NIGHT
				FROM Presentation.dbo.ORDER_HEADER o
					INNER JOIN Presentation.dbo.DIM_CUSTOMER cu ON cu.CUSTOMER_ID = o.CUSTOMER_ID
					INNER JOIN Presentation.dbo.DIM_BRANCH b ON b.BRANCH_ID = cu.BRANCH_ID
				WHERE YEAR(o.ORDER_DATETIME) = 2020
				GROUP BY datepart(WW, o.ORDER_DATETIME), datepart(DW, o.ORDER_DATETIME)
	)
	SELECT TOP (2)
		wd.WD_NAME						AS	[День недели],
		AVG(ORDER_COUNT_MOSCOW)			AS	[Среднее кол-во заказов в День Недели в Москве 2020],
		AVG(ORDER_COUNT_MOSCOW_NIGHT)	AS	[Среднее кол-во вечерних заказов в День Недели в Москве 2020],
		AVG(ORDER_COUNT)				AS	[Среднее кол-во заказов в День Недели по всем филиалам в 2020]
	FROM owd
	INNER JOIN Presentation.dbo.WEEK_DAY wd ON wd.WD = owd.WEEK_DAY
	WHERE wd.wd not in (SELECT DATEPART(DW, o.ORDER_DATETIME) DW FROM Presentation.dbo.ORDER_HEADER o
						WHERE YEAR(o.ORDER_DATETIME) = 2020
					AND o.SOURCE_NAME = 'email'
					GROUP BY DATEPART(DW, o.ORDER_DATETIME) 
					HAVING COUNT(1) < 100500)
	GROUP BY wd.WD_NAME
	ORDER BY 2 DESC

--SELECT * FROM vORDER_WEEK_DAY_TOP