select
	CustomerID,
	CompanyName
from Customers
where CustomerID = 'ALFKI'

select * from Customers
--------------------------------------
rollback

--Part 1 :
begin transaction
--Step 2 : สร้าง Order
insert into Orders
	(CustomerID, EmployeeID,
	 OrderDate, RequiredDate, Freight)
values
	('ALFKI', 1, GETDATE(),
	 DATEADD(DAY,7,GETDATE()), 50.00)
--Step 3 : ดู OrderID
select SCOPE_IDENTITY() as NewOrderID --11082
--Step 4 :
--เพิ่มสินค้าใน Order เงื่อนไข 1
insert into [Order Details]
	(OrderID, ProductID, UnitPrice,
	 Quantity, Discount)
Select
	11082,
	ProductID,
	UnitPrice,
	2,
	0
from Products
where ProductID = 1
--เพิ่มสินค้าใน Order เงื่อนไข 2
insert into [Order Details]
	(OrderID, ProductID, UnitPrice,
	 Quantity, Discount)
Select
	11082,
	ProductID,
	UnitPrice,
	3,
	0
from Products
where ProductID = 2
--Step 5 : ตรวจข้อมูล
select * from Orders
where OrderID = 11082

select * from [Order Details]
where OrderID = 11082
--Step 6 : Commit และตรวจสอบผล
Commit

select * from Orders
where OrderID = 11082


--Part 2 :
begin transaction
--Step 1 : เริ่ม Transaction เพื่อเพิ่มข้อมูลกใม่
insert into Orders
	(CustomerID, EmployeeID,
	 OrderDate, RequiredDate, Freight)
values
	('ALFKI', 1, GETDATE(),
	 DATEADD(DAY,7,GETDATE()), 75.00)
--Step 2 : เก็บค่า OrderID
select SCOPE_IDENTITY() as RollbackOrderID --11084
--Step 3 : เพิ่มสินค้าใน Product1 ลงใน Order
insert into [Order Details]
	(OrderID, ProductID, UnitPrice,
	 Quantity, Discount)
Select
	11084,
	ProductID,
	UnitPrice,
	1,
	0
from Products
where ProductID = 1
--Step 4 : เพิ่มสินค้าใน Product2 ลงใน Order
insert into [Order Details]
	(OrderID, ProductID, UnitPrice,
	 Quantity, Discount)
Select
	11084,
	ProductID,
	UnitPrice,
	2,
	0
from Products
where ProductID = 2
--Step 5 : ตรวจข้อมูลก่อน Rollback
select * from Orders
where OrderID = 11084

select * from [Order Details]
where OrderID = 11084
--Step 6 : Rollback
rollback
--Step 7 : ตรวจผลหลัง Rollback
select * from Orders
where OrderID = 11084 --ข้อมูลหายหลัง Rollback

select * from [Order Details] 
where OrderID = 11084 --ข้อมูลหายหลัง Rollback