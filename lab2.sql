---Lab2 часть 1
use Northwind
go
create table SuppliersGraf(
	SupplierID int primary key,
	CompanyName nvarchar(40) not null,
	ContactName nvarchar(30) not null
) as NODE

create table ProductsGraf(
	ProductID int primary key not null,
	ProductName nvarchar(40) not null,
	UnitPrice money not null
)as NODE

create table OrdersGraf(
	OrderID int primary key,
	OrderDate datetime null
)as NODE

create table CategoriesGraf(
	CategoryID int primary key not null,
	CategoryName nvarchar(15) not null,
	[Description] [ntext] NULL,
	[Picture] [image] NULL
)as NODE

create table EmployeesGraf(
	EmployeeID int primary key not null,
	LastName nvarchar(20) not null,
	FirstName nvarchar(10) not null
) as NODE

create table CustomersGraf(
	CustomerID nchar(5) primary key not null,
	CompanyName nvarchar(40) not null,
	ContactName nvarchar(30) null,
	Phone nvarchar(24) null,
	Fax nvarchar(24) null
)as NODE


create table CityGraf(
	CityID int identity(1,1),
	City nvarchar(15) not null,
	Region nvarchar(15) null,
	PostalCode nvarchar(10) null,
	Country nvarchar(15) null,
	PRIMARY KEY (CityID, City)
) as NODE

create table ProducesGraf(
	Id int identity(1,1) primary key not null
) as EDGE


create table RelateGraf(
	Id int identity(1,1) primary key not null
) as EDGE

create table ContainsGraf (
	Id int identity(1,1) primary key not null,
	Quantity smallint not null
) as EDGE


create table PlacedGraf(
	Id int identity(1,1) primary key not null
) as EDGE

create table CollectsGraf(
	Id int identity(1,1) primary key not null
) as EDGE


create table ShippedGraf (
	Id int identity(1,1) primary key not null,
	ShipedDate datetime null
) as EDGE


create table LivesGraf(
	Id int identity(1,1) primary key not null
) as EDGE


create table MakesGraf(
	Id int identity(1,1) primary key not null,
	OrderDate datetime null,
	RequiredDate datetime null
) as EDGE

use Northwind
go

--Заполнение данными
--узлы
insert into CategoriesGraf (CategoryID, CategoryName, [Description], [Picture]) select CategoryID, CategoryName, [Description], [Picture]  from Categories

insert into OrdersGraf (OrderID, OrderDate) select OrderID, OrderDate from Orders

insert into SuppliersGraf (SupplierID, CompanyName, ContactName) select SupplierID, CompanyName, ContactName from Suppliers

insert into ProductsGraf (ProductID, ProductName, UnitPrice) select ProductID, ProductName, UnitPrice from Products

insert into EmployeesGraf (EmployeeID, LastName, FirstName) select EmployeeID, LastName, FirstName from Employees

insert into CustomersGraf (CustomerID, CompanyName, ContactName, Phone, Fax) select CustomerID, CompanyName, ContactName, Phone, Fax from Customers

--insert into CityGraf (Region, PostalCode, Country) 
--select Region, PostalCode, Country 
--from Suppliers

drop table CityGraf

insert into CityGraf (City, Country, Region)
select distinct City, Country, Region from
(
    select City, Country, Region, PostalCode from Customers where City is not null
    union
    select City, Country, Region, PostalCode from Suppliers where City is not null
    union
    select City, Country, Region, PostalCode from Employees where City is not null
    union
    select ShipCity as City, ShipCountry as Country, ShipRegion as Region, ShipPostalCode as PostalCode from Orders where ShipCity is not null
) as AllCities
where City <> ''


--заполнение ребер
insert into ProducesGraf
select 
    (select [$node_id_FA2FEE6DBE314C40BF054C05860AD16F] from SuppliersGraf where SupplierId = p.SupplierID) as from_node,
    (select [$node_id_AAA3FB2DD37B4BB988AB54153BA781E1] from ProductsGraf where Productid = p.ProductID) as to_node
from 
    Products p
where 
    exists (select 1 from SuppliersGraf where SupplierId = p.SupplierID)
    and exists (select 1 from ProductsGraf where Productid = p.ProductID)

insert into RelateGraf 
select 
	(select [$node_id_AAA3FB2DD37B4BB988AB54153BA781E1] from ProductsGraf where ProductID = p.ProductID) as from_node,
	(select [$node_id_BA95071285D4465F96F767E7D7C961F1] from CategoriesGraf where CategoryID = p.CategoryID) as to_node
from 
	Products p
where 
	exists (select 1 from ProductsGraf where ProductID = p.ProductID)
	and exists (select 1 from CategoriesGraf where CategoryID = p.CategoryID)

insert into ContainsGraf
select
	og.$node_id, 
    pg.$node_id,
    od.Quantity
from 
	[Order Details] od
	join OrdersGraf og ON od.OrderID = og.OrderID
    join ProductsGraf pg ON od.ProductID = pg.ProductID
--where 
	--exists (select 1 from OrdersGraf where OrderID = od.OrderID)
	--and exists (select 1 from ProductsGraf where ProductID = od.ProductID)


insert into PlacedGraf ($from_id, $to_id)
select 
    sg.$node_id, 
    cg.$node_id
from 
    Suppliers s
    join SuppliersGraf sg on s.SupplierID = sg.SupplierID
    join CityGraf cg on s.City = cg.City AND (s.Country = cg.Country OR (s.Country IS NULL AND cg.Country IS NULL))

drop table CollectsGraf

insert into CollectsGraf
select
	eg.$node_id, 
    og.$node_id
from 
	Orders o
    join EmployeesGraf eg on o.EmployeeID = eg.EmployeeID
    join OrdersGraf og on o.OrderID = og.OrderID
where o.EmployeeID IS NOT NULL


insert into ShippedGraf ($from_id, $to_id, ShipedDate)
select 
    og.$node_id, 
    cg.$node_id,
    o.ShippedDate
from 
    Orders o
    join OrdersGraf og on o.OrderID = og.OrderID
    join CityGraf cg on o.ShipCity = cg.City AND o.ShipCountry = cg.Country
where o.ShipCity IS NOT NULL

-- LivesGraf (Клиенты -> Города)
insert into LivesGraf ($from_id, $to_id)
select 
    cg.$node_id, 
    city.$node_id
from 
    Customers c
    join CustomersGraf cg on c.CustomerID = cg.CustomerID
    join CityGraf city on c.City = city.City and c.Country = city.Country
where c.City IS NOT NULL

insert into LivesGraf ($from_id, $to_id)
select 
    eg.$node_id, -- ID сотрудника из EmployeesGraf
    city.$node_id -- ID города из CityGraf
from 
    Employees emp
    join EmployeesGraf eg on emp.EmployeeID = eg.EmployeeID
    join CityGraf city on emp.City = city.City 
                      and emp.Country = city.Country
where 
    emp.City IS NOT NULL 
    and emp.City <> ''

-- MakesGraf (Клиенты -> Заказы)
insert into MakesGraf ($from_id, $to_id, OrderDate, RequiredDate)
select 
    cg.$node_id, 
    og.$node_id,
    o.OrderDate,
    o.RequiredDate
from 
    Orders o
    join CustomersGraf cg on o.CustomerID = cg.CustomerID
    join OrdersGraf og on o.OrderID = og.OrderID
where o.CustomerID IS NOT NULL

-----------------------------------------------------------------
--Запросы к графовой  и реляционной:



--Как называется самый дорогой товар из товарной категории №1?(Beverages)

--ok
select top 1 ProductName
from ProductsGraf pg, RelateGraf rg, CategoriesGraf cg
where match(pg-(rg)->cg) and cg.CategoryID = 1
order by pg.UnitPrice desc


--Запросы к реляционной:

select top 1 ProductName
from Products
where CategoryID = 1
order by UnitPrice desc

-----------------------------------------------------------------
--В какие города заказы комплектовались более десяти дней?

--ok
select distinct cg.City, mg.[OrderDate], sg.[ShipedDate]
from OrdersGraf og, ShippedGraf sg, CityGraf cg, MakesGraf mg, CustomersGraf cust
where match(og-(sg)->cg) and match(cust-(mg)->og)  and datediff(day,mg.[OrderDate],sg.[ShipedDate])>10

--select * from CityGraf og
--where og.City = 'Bern'

--Запросы к реляционной:

select distinct ShipCity as City, Orders.*
from Orders
where datediff(day, OrderDate, ShippedDate) > 10

-----------------------------------------------------------------
--Какие покупатели до сих пор ждут отгрузки своих заказов?

--ok
use Northwind
select distinct cust.ContactName
from CustomersGraf cust, MakesGraf m, OrdersGraf o, ShippedGraf sg, CityGraf cg
where match(cust-(m)->o) and match(o-(sg)->cg) and sg.ShipedDate is null
--and not exists(
--    select 1 from ShippedGraf s, CityGraf c 
--    where 
--)

--Запросы к реляционной:

select distinct c.CompanyName
from Customers c
join Orders o on c.CustomerID = o.CustomerID
where o.ShippedDate IS NULL

-----------------------------------------------------------------
--Скольких покупателей обслужил продавец, лидирующий по общему количеству заказов?

--ok
select top 1  eg.[EmployeeID] as Empl,  count (distinct cust.[CustomerID]) as CustCNT
from EmployeesGraf eg, MakesGraf mg, OrdersGraf og, CollectsGraf cg, CustomersGraf cust
where  match(cust-(mg)->og) and match(eg-(cg)->og)
group by eg.$node_id, eg.[EmployeeID]
order by COUNT (og.[OrderID]) desc


--Запросы к реляционной:

with TopEmployee as (
    select top 1 e.EmployeeID, e.FirstName, e.LastName
    from Orders o join  Employees e on o.EmployeeID = e.EmployeeID
    group by e.EmployeeID, e.FirstName, e.LastName
    order by count(OrderID) desc
)
select e.FirstName, e.LastName, count(distinct CustomerID) as CustomerCount
from Orders o join  Employees e on o.EmployeeID = e.EmployeeID
where o.EmployeeID = (select EmployeeID from TopEmployee)
group by e.FirstName, e.LastName

-----------------------------------------------------------------
--Сколько французских городов обслужил продавец №1 в 1997-м?

--ok
select count(distinct c.City) as FrenchCitiesCount
from EmployeesGraf e, CollectsGraf col, OrdersGraf o, ShippedGraf s, CityGraf c
where e.EmployeeID = 1
and match(e-(col)->o)
and match(o-(s)->c)
and c.Country = 'France'
and year(o.OrderDate) = 1997
go

--Запросы к реляционной:

select count(distinct o.ShipCity) as FrenchCitiesCount
from Orders o
join Customers c on o.CustomerID = c.CustomerID
where o.EmployeeID = 1 
  and year(o.OrderDate) = 1997
  and c.Country = 'France'

-----------------------------------------------------------------
--В каких странах есть города, в которые было отправлено больше двух заказов?

--ok
select distinct c.City, count(*) as counte
from CityGraf c, ShippedGraf sg, OrdersGraf og
where match(og-(sg)->c)
group by c.$node_id, c.City, c.Country
having count(og.OrderID) > 2
go

--Запросы к реляционной:

select distinct ShipCity, count(*) as OrderCount
from Orders
group by ShipCountry, ShipCity
having count(OrderID) > 2

-----------------------------------------------------------------
--Перечислите названия товаров, которые были проданы в количестве менее 1000 штук (quantity)?

--ok
select distinct p.ProductName
from ProductsGraf p, ContainsGraf con, OrdersGraf o
where match(o-(con)->p)
group by p.ProductID, p.ProductName
having sum(con.Quantity) < 1000


--Запросы к реляционной:

select distinct p.ProductName
from [Order Details] od
join Products p on od.ProductID = p.ProductID
group by p.ProductID, p.ProductName
having sum(od.Quantity) < 1000

-----------------------------------------------------------------
--Как зовут покупателей, которые делали заказы с доставкой в другой город (не в тот, в котором они прописаны)?

--ok
select distinct cust.ContactName
from CustomersGraf cust, LivesGraf l, CityGraf custCity, 
     MakesGraf m, OrdersGraf o, ShippedGraf s, CityGraf shipCity
where match(cust-(l)->custCity)
and match(cust-(m)->o)
and match(o-(s)->shipCity)
and custCity.City <> shipCity.City 

--Запросы к реляционной:

select distinct c.ContactName
from Orders o
join Customers c on o.CustomerID = c.CustomerID
where o.ShipCity <> c.City

-----------------------------------------------------------------
--Товарами из какой категории в 1997-м году заинтересовалось больше всего компаний, имеющих факс?

--ok
select top 1 with ties cat.CategoryName, count(distinct cust.CustomerID) as CompanyCount
from CategoriesGraf cat, RelateGraf r, ProductsGraf p, 
     ContainsGraf con, OrdersGraf o, MakesGraf m, CustomersGraf cust
where match(cat<-(r)-p)
and match(p<-(con)-o)
and match(o<-(m)-cust)
and cust.Fax IS NOT NULL
and year(m.OrderDate) = 1997
group by cat.$node_id, cat.CategoryName
order by CompanyCount desc
go

--Запросы к реляционной:

select top 1 with ties cat.CategoryName, COUNT(distinct c.CustomerID) as CompanyCount
from Orders o
join Customers c on o.CustomerID = c.CustomerID
join [Order Details] od on o.OrderID = od.OrderID
join Products p on od.ProductID = p.ProductID
join Categories cat on p.CategoryID = cat.CategoryID
where year(o.OrderDate) = 1997 
  and c.Fax is not null
group by cat.CategoryID, cat.CategoryName
order by count(distinct c.CustomerID) desc

-----------------------------------------------------------------
--Перечислите названия товаров, которые были проданы в количестве менее 1000 штук в регион, где они производились ?

select distinct p.ProductName
from ProductsGraf p, ProducesGraf pr, SuppliersGraf s, PlacedGraf pl,
CityGraf supCity, ContainsGraf con, OrdersGraf o, ShippedGraf sh, CityGraf shipCity
where MATCH(p<-(pr)-s)
and match(s-(pl)->supCity)
and match(p<-(con)-o)
and match(o-(sh)->shipCity)
   and supCity.Country = shipCity.Country  
    and supCity.Country IS NOT NULL    
    and shipCity.Country IS NOT NULL
group by p.ProductID, p.ProductName
having sum(con.Quantity) < 1000


--Запросы к реляционной:

select distinct p.ProductName
from [Order Details] od
join Products p on od.ProductID = p.ProductID
join Orders o on od.OrderID = o.OrderID
join Suppliers s on p.SupplierID = s.SupplierID
where o.ShipCountry = s.Country
group by p.ProductID, p.ProductName
having sum(od.Quantity) < 1000

-----------------------------------------------------------------
--Как зовут покупателей, которые делали заказы с доставкой в город продавца? 

--ok
select distinct cust.ContactName
from CustomersGraf cust, MakesGraf m, OrdersGraf o, 
     ShippedGraf s, CityGraf shipCity, CollectsGraf col, 
     EmployeesGraf e, LivesGraf l, CityGraf empCity
where match(cust-(m)->o) 
and match(e-(col)->o-(s)->shipCity) 
and match(e-(l)->empCity)  
and shipCity.City = empCity.City
and shipCity.Country = empCity.Country
				

--Запросы к реляционной:

select distinct c.ContactName
from Orders o
join Customers c on o.CustomerID = c.CustomerID
join Employees e on o.EmployeeID = e.EmployeeID
where o.ShipCity = e.City

-----------------------------------------------------------------
--Для каждого покупателя (имя, фамилия) показать название его любимого товара в каждой категории. 
--Любимый товар – это тот, которого покупатель купил больше всего штук (столбец Quantity).

--ok
with CustomerFavorites as (
    select 
        cust.CustomerID,
        cust.ContactName,
        cat.CategoryID,
        cat.CategoryName,
        p.ProductID,
        p.ProductName,
        sum(con.Quantity) as TotalQuantity,
        rank() over (partition by cust.CustomerID, cat.CategoryID order by sum(con.Quantity) desc) as rank_c 
    from CustomersGraf cust, MakesGraf m, ContainsGraf con, RelateGraf r, ProductsGraf p, Categoriesgraf cat, OrdersGraf o
	where match(cust-(m)->o) and match(o-(con)->p) and match(p-(r)->cat)
    group by cust.CustomerID, cust.ContactName, cat.CategoryID, cat.CategoryName, p.ProductID, p.ProductName
)
select ContactName, CategoryName, ProductName, TotalQuantity
from CustomerFavorites
where rank_c = 1
go

--Запросы к реляционной:

with CustomerFavorites as (
    select 
        c.ContactName,
        cat.CategoryID,
        cat.CategoryName,
        p.ProductName,
        sum(od.Quantity) as TotalQuantity,
        rank() over (partition by c.CustomerID, cat.CategoryID order by sum(od.Quantity) desc) as rank_c
    from Customers c
    join Orders o on c.CustomerID = o.CustomerID
    join [Order Details] od on o.OrderID = od.OrderID
    join Products p on od.ProductID = p.ProductID
    join Categories cat on p.CategoryID = cat.CategoryID
    group by c.CustomerID, c.ContactName, cat.CategoryID, cat.CategoryName, p.ProductID, p.ProductName
)
select 
    ContactName,
    CategoryName,
    ProductName as FavoriteProduct
from CustomerFavorites
where rank_c = 1
order by ContactName, CategoryName

-----------------------------------------------------------------
--Сколько всего единиц товаров (то есть, штук – Quantity) продал каждый продавец (имя, фамилия) осенью 1996 года?

--ok
select e.FirstName, e.LastName, sum(cn.Quantity) as TotalQuantity
from EmployeesGraf e, ProductsGraf p, OrdersGraf o, CollectsGraf col, ContainsGraf cn, ShippedGraf sg, CityGraf cg
where match(e -(col)->o-(cn)->p) and match(o -(sg)->cg) and year (sg.[ShipedDate]) = 1996
and month (sg.[ShipedDate]) > 8 and month (sg.[ShipedDate]) <12
group by e.EmployeeID, e.FirstName, e.LastName
order by TotalQuantity desc

--Запросы к реляционной:

select 
    e.FirstName,
    e.LastName,
    sum(od.Quantity) as TotalQuantity
from Employees e
join Orders o on e.EmployeeID = o.EmployeeID
join [Order Details] od on o.OrderID = od.OrderID
where year(o.OrderDate) = 1996 
  and month(o.OrderDate) between 9 and 11
group by e.EmployeeID, e.FirstName, e.LastName
order by TotalQuantity desc

-----------------------------------------------------------------

--часть 2
--Своя графовая
use Univer
go

--узлы
create table ProgramGraf (
	Number int not null PRIMARY KEY,
	[Name] nvarchar(50) null
) as NODE

create table GroupGraf (
	Id int not null PRIMARY KEY,
	Title nvarchar(50) not null,
	MaxCountChild int null,
	CountChild int not null,
	AgeChild int not null
) as NODE

create table ParentGraf(
	Id int not null PRIMARY KEY,
	FIO nvarchar(100) not null,
	NumberPhone int null,
	Job nvarchar(100) null,
	[Status] nvarchar(20) not null,
	monyParent money null
) as NODE

create table ChildGraf(
	Id int PRIMARY KEY,
	FIO nvarchar(50) not null,
	height int not null,
	[weight] int not null,
	dataBirth date not null,
	[address] nvarchar(20) not null
) as NODE

create table EditHGraf (
	Id int not null PRIMARY KEY,
	DateEditH date not null,
	Height int not null
) as NODE

create table EditWGraf (
	Id int not null PRIMARY KEY,
	[Weight] int not null,
	DateEditW date not null,
	DeltaWeight int not null
) as NODE

create table KindTeacherGraf (
	Number int not null PRIMARY KEY,
	FIO nvarchar(100) not null,
	IdGroup int null,
	DateOfBirth date null
) as NODE

create table DiseaseGraf (
	Id int not null PRIMARY KEY,
	[Begin] date null,
	[End] date null,
	Diagnosis nvarchar(100) not null
) as NODE


--ребра

--Свидетельство о рождении
create table BirthСertificate(
	Id int identity(1,1) PRIMARY KEY not null
) as EDGE


--Рабочее место
create table Workplace(
	Id int identity(1,1) PRIMARY KEY not null
) as EDGE

--Журнал
create table Magazine(
	Id int identity(1,1) PRIMARY KEY not null
) as EDGE


--Медецинская карта
create table MedicalCard(
	Id int identity(1,1) PRIMARY KEY not null
) as EDGE


--Таблица роста
create table TableHeight(
	Id int identity(1,1) PRIMARY KEY not null
) as EDGE

--Таблица веса
create table TableWeight(
	Id int identity(1,1) PRIMARY KEY not null
) as EDGE

--Рабочий устав
create table WorkRegulations(
	Id int identity(1,1) not null
) as EDGE

--Заполнение данными

--Узлы

insert into ProgramGraf (Number, [Name]) select Number, [Name] from Program
insert into GroupGraf (Id, Title, MaxCountChild, CountChild, AgeChild) select Id, Title, [Max Count Child], [Count Child], [Age Children] from [Group]
insert into ParentGraf (Id, FIO, Job, NumberPhone, [Status], monyParent) select Id, FIO, Job, [Number Phone], [Status], monyParent from Parent
insert into ChildGraf (Id, FIO, height, [weight], dataBirth, [address]) select Id, FIO, height, [weight], [date birth], adress from Child
insert into EditHGraf (Id, DateEditH, Height) select Id, DateEditWeght, Height from EditHeight
insert into EditWGraf (Id, [Weight], DateEditW, DeltaWeight) select Id, [Weight], DateEditWeight, DeltaWeight from EditWeight
insert into KindTeacherGraf (Number, FIO, DateOfBirth) select Number, FIO, DateOfBirth from [Kindergarten teacher]
insert into DiseaseGraf (Id, [Begin], [End], Diagnosis) select Id, [Begin], [End], Diagnosis from Disease

--ребра

--сделано
insert into BirthСertificate
select
	(select [$node_id_136B3374CB294FEBAF36958FB7CE0A61] from ParentGraf where ch.IdParent1 = Id) as from_node,
	(select [$node_id_697229DE7D694149B805FC38981C1F28] from ChildGraf where ch.Id = Id) as to_node
from 
	Child ch
where
	exists (select 1 from ParentGraf where Id = ch.IdParent1)
	and exists (select 1 from ChildGraf where Id = ch.Id)


insert into BirthСertificate
select
	(select [$node_id_136B3374CB294FEBAF36958FB7CE0A61] from ParentGraf where ch.IdParent2 = Id) as from_node,
	(select [$node_id_697229DE7D694149B805FC38981C1F28] from ChildGraf where ch.Id = Id) as to_node
from 
	Child ch
where
	exists (select 1 from ParentGraf where Id = ch.IdParent2)
	and exists (select 1 from ChildGraf where Id = ch.Id)
------------------------------------------------------
--сделано
insert into Magazine
select
	(select [$node_id_697229DE7D694149B805FC38981C1F28] from ChildGraf where ch.Id = Id) as from_node,
	(select [$node_id_743E68B5A04E4EA99988D6047D5FC1D9] from GroupGraf where ch.[Id Group] = Id) as to_node
from 
	Child ch
where
	exists (select 1 from ChildGraf where Id = ch.Id)
	and exists (select 1 from GroupGraf where Id = ch.[Id Group])

--------------------------------------------------------

--insert into Disease (Id, [Begin], [End], Diagnosis, [Id child]) values (13, '2025-05-20', null, 'воспаление легких', 8)

--сделано
insert into MedicalCard
select
	(select [$node_id_2F6A51297EB943B889C047DE2C2DACB2] from DiseaseGraf where d.Id = Id) as from_node,
	(select [$node_id_697229DE7D694149B805FC38981C1F28] from ChildGraf where d.[Id child] = Id) as to_node
from 
	Disease d
where
	exists (select 1 from DiseaseGraf where Id = d.Id)
	and exists (select 1 from ChildGraf where Id = d.[Id child])

-------------------------------------------------------------
--сделано
insert into TableHeight
select
	(select [$node_id_697229DE7D694149B805FC38981C1F28] from ChildGraf where eh.IdChild = Id) as from_node,
	(select [$node_id_38895F8A05A64951A2E8420547BDBEDC] from EditHGraf where eh.Id = Id) as to_node
from 
	EditHeight eh
where
	exists (select 1 from ChildGraf where Id = eh.IdChild)
	and exists (select 1 from EditHGraf where Id = eh.Id)

--------------------------------------------------------------
--сделано
insert into TableWeight
select
	(select [$node_id_697229DE7D694149B805FC38981C1F28] from ChildGraf where ew.IdChild = Id) as from_node,
	(select [$node_id_48DC7C0F613946AEACDF3FC0EC60C478] from EditWGraf where ew.Id = Id) as to_node
from 
	EditWeight ew
where
	exists (select 1 from ChildGraf where Id = ew.IdChild)
	and exists (select 1 from EditWGraf where Id = ew.[Weight])

-------------------------------------------------------------
--сделано
insert into Workplace
select
	(select [$node_id_743E68B5A04E4EA99988D6047D5FC1D9] from GroupGraf where kt.[Id Group] = Id) as from_node,
	(select [$node_id_1D39522D527046C28BA4AF286C218913] from KindTeacherGraf where kt.Number = Number) as to_node
from 
	[Kindergarten teacher] kt
where
	exists (select 1 from GroupGraf where Id = kt.[Id Group])
	and exists (select 1 from KindTeacherGraf where Number = kt.Number)

---------------------------------------------------------------
--сделано
insert into WorkRegulations
select
	(select [$node_id_743E68B5A04E4EA99988D6047D5FC1D9] from GroupGraf where g.Id = Id) as from_node,
	(select [$node_id_F71F0712B0BD4C6DA72A78D392067474] from ProgramGraf where g.[Number Program] = Number) as to_node
from 
	[Group] g
where
	exists (select 1 from GroupGraf where Id = g.Id)
	and exists (select 1 from ProgramGraf where Number = g.[Number Program])


--Запросы:
--a) Найти детей из неполных семей

--готово
select c.Id, c.FIO as ChildName
from ChildGraf c, BirthСertificate bc, ParentGraf p
where match(c<-(bc)-p) 
group by c.Id, c.FIO
having count(p.Id) < 2

-----------------------------------------------------------
--b) Найти количество свободных мест в садике для детей 3, 4, 5, 6 лет


--готово
select g.Title as GroupName, 
       g.MaxCountChild - g.CountChild as FreeSlots,
       g.AgeChild
from GroupGraf g
where g.AgeChild between 3 and 6
and g.MaxCountChild > g.CountChild

-----------------------------------------------------------
--c) Для каждой группы вывести количество детей, болеющих на данный момент

--проверить заполнение таблиц, узлов и ребер
insert into Disease (id, [Begin], [End], Diagnosis, [Id child]) values (14, '2025-06-10', null, 'воспаление легких', 2)

select distinct c.Id, g.Id
from GroupGraf g, Magazine m, ChildGraf  c, MedicalCard mc, DiseaseGraf d
where match(d-(mc)->c-(m)->g)
and d.[End] is null

select g.Id as GroupId, g.Title, count(distinct c.Id) as SickChildrenCount
from GroupGraf g, Magazine m, ChildGraf c, MedicalCard mc, DiseaseGraf d
where match(g<-(m)-c<-(mc)-d)
and d.[Begin] <= getdate() 
and (d.[End] is null or d.[End] >= getdate())
group by g.Id, g.Title

-----------------------------------------------------------
--d) Найти наиболее часто болеющих детей (среднее кол-во заболеваний ребенка в год > 5)

--добавить данные, правильность запослнения
select c.Id, c.FIO as ChildName, 
       count(d.Id) as DiseaseCount,
       datediff(year, min(d.[Begin]), getdate()) as YearsObserved,
       count(d.Id)*1.0/nullif(datediff(year, min(d.[Begin]), getdate()), 0) as DiseasesPerYear
from ChildGraf c, MedicalCard mc, DiseaseGraf d
where match(d-(mc)->c)
group by c.Id, c.FIO
having count(d.Id)*1.0/nullif(datediff(year, min(d.[Begin]), getdate()), 0) > 5

-----------------------------------------------------------
--e) В каждой возрастной категории найти детей, которые за последний год выросли на 10 см и больше

select * from EditHGraf

select c.FIO, g.AgeChild
from ChildGraf c, GroupGraf g, EditHGraf eh, Magazine m, TableHeight th
where match (c-(m)->g)
union
select c.FIO, g.AgeChild
from ChildGraf c, GroupGraf g, EditHGraf eh, Magazine m, TableHeight th
where match(c-(th)->eh)
  and eh.DateEditH >= dateadd(year, -1, getdate())
  and eh.Height >= c.height + 10

-----------------------------------------------------------
--g) Запрос на использование SHORTEST_PATH


select distinct c.FIO as ChildName, kt.FIO as TeacherName
from ChildGraf c, KindTeacherGraf kt, Magazine m, Workplace w, GroupGraf gg
where match (c-(m)->gg-(w)->kt)
  --and c.FIO = N'Коля'
  --and kt.FIO = N'Олеговна Анастасия федоровна' 
