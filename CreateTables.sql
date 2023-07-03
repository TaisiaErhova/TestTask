USE Presentation
GO
--������� ��
DROP TABLE IF EXISTS dbo.ORDER_DETAIL;
DROP TABLE IF EXISTS dbo.ORDER_HEADER;
DROP TABLE IF EXISTS dbo.DIM_CUSTOMER;
DROP TABLE IF EXISTS dbo.DIM_BRANCH;
DROP TABLE IF EXISTS dbo.WEEK_DAY;

GO
--�������� ������
CREATE TABLE dbo.DIM_BRANCH(
BRANCH_ID INT PRIMARY KEY IDENTITY(1,1),
BRANCH_NAME NVARCHAR(255) NOT NULL);

CREATE TABLE dbo.DIM_CUSTOMER
(CUSTOMER_ID INT PRIMARY KEY IDENTITY(1,1),
BRANCH_ID INT NOT NULL,
CUSTOMER_NAME NVARCHAR(4000) NOT NULL
,CONSTRAINT FK_CUSTOMER_BRANCH FOREIGN KEY (BRANCH_ID)
        REFERENCES dbo.DIM_BRANCH (BRANCH_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE);

CREATE TABLE dbo.ORDER_HEADER
	(ORDER_ID INT IDENTITY(1,1) PRIMARY KEY,
	CUSTOMER_ID INT NOT NULL, 
	ORDER_NUM NVARCHAR(255) NOT NULL, 
	ORDER_DATETIME DATETIME NOT NULL,
	CONSTRAINT FK_ORDER_CUSTOMER FOREIGN KEY (CUSTOMER_ID)
        REFERENCES dbo.DIM_CUSTOMER (CUSTOMER_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE);

CREATE TABLE dbo.ORDER_DETAIL
(ORDER_ID INT, 
PRODUCT_NAME NVARCHAR(4000) NOT NULL, 
UNIT NVARCHAR(10), 
QUANTITY DECIMAL(18, 2)
,CONSTRAINT FK_DETAILS_ORDER FOREIGN KEY (ORDER_ID)
        REFERENCES dbo.ORDER_HEADER (ORDER_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE);

CREATE TABLE dbo.WEEK_DAY 
(WD  INT NOT NULL,
WD_NAME NVARCHAR(10));

--------------------���������� ������-----------------------------------------------------------
INSERT INTO dbo.DIM_BRANCH(BRANCH_NAME)
VALUES ('������'), ('�����-���������'), ('�����������'), ('������������'), ('���������');

INSERT INTO dbo.WEEK_DAY(WD, WD_NAME)
VALUES (1,'��'), (2,'��'), (3,'��'), (4,'��'), (5,'��'), (6, '��'), (7, '��');

--��� ���������� ������ ���������� ��������
WITH id AS (select 1 as id
			union all
			select id + 1
			from id
			where id < 100) 
INSERT INTO dbo.DIM_CUSTOMER(BRANCH_ID, CUSTOMER_NAME)
SELECT 
	BRANCH_ID, 
	CONCAT('�������� ', 1000*BRANCH_ID + id)
FROM dbo.DIM_BRANCH, id;

WITH id AS (select 1 as id
			union all
			select id + 1
			from id
			where id < 100) 
INSERT INTO dbo.ORDER_HEADER(CUSTOMER_ID, ORDER_NUM, ORDER_DATETIME)
SELECT 
	CUSTOMER_ID,
	CONCAT('����� �', 100000*CUSTOMER_ID + id), 
	DATEADD(SS, 10*ID*CUSTOMER_ID, '2020-01-01') 
FROM dbo.DIM_CUSTOMER, id;

UPDATE dbo.ORDER_HEADER
SET ORDER_DATETIME = '2020-06-01'
WHERE ORDER_ID < 20000;

UPDATE dbo.ORDER_HEADER
SET ORDER_DATETIME = '2020-08-02'
WHERE ORDER_ID BETWEEN 20000 AND 35000;


WITH id AS (select 1 as id
			union all
			select id + 1
			from id
			where id < 10) 
INSERT INTO dbo.ORDER_DETAIL(ORDER_ID, PRODUCT_NAME, UNIT, QUANTITY)
SELECT 
	ORDER_ID,
	CONCAT('����� �', 100*ORDER_ID + id),
	IIF(ORDER_ID < 20000, '��', '��'),
	10*ID*ORDER_ID 
FROM dbo.ORDER_HEADER, id;
	
------------------------------------------------------------------------------------------------

--����� ������
SELECT * FROM  dbo.WEEK_DAY;
SELECT * FROM dbo.DIM_BRANCH;
SELECT * FROM dbo.DIM_CUSTOMER;
SELECT TOP 100 * FROM dbo.ORDER_HEADER;
SELECT TOP 100 * FROM dbo.ORDER_DETAIL;



