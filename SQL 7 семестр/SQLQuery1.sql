use Univer

--Программа
create table [Program] (
	[Number] int not null primary key,
	[Name] nvarchar(50)
);

--Группа
CREATE TABLE [Group](
	[Id] int identity(1,1) not null primary key,
	[Title] nvarchar(50) not null,
	[Max Count Child] int,
	[Count Child] int not null,
	[Age Children] int check([Age Children] > 2 and [Age Children] < 7) not null,
	[Number Program] int not null,
	foreign key ([Number Program]) references Program (Number) 
);

--Родитель
create table Parent(
	Id int not null primary key,
	FIO nvarchar(100) not null,
	[Number Phone] nvarchar(100),
	Job nvarchar(100),
	[Status] nvarchar(20) not null
);

--Ребенок
create table Child(
	Id int not null primary key,
	[FIO] nvarchar(50) not null,
	height int not null,
	[date edit weight] nvarchar(20),
	[weight] int not null,
	[date birth] date not null,
	[adress] nvarchar(20) not null,
	[Id Group] int not null,
	[IdParent1] int null,
	[IdParent2] int null,
	foreign key ([Id Group]) references [Group] (Id),
	foreign key ([IdParent1]) references [Parent] (Id),
	foreign key ([IdParent2]) references [Parent] (Id)
);

--Воспитатель детского сада
create table [Kindergarten teacher](
	Number int primary key not null,
	FIO nvarchar(100) not null,
	[Id Group] int not null,
	foreign key ([Id Group]) references [Group] (Id)
);

--Диагноз
create table Disease(
	Id int primary key not null,
	[Begin] date not null,
	[End] date null,
	[Diagnosis] nvarchar(100) not null,
	[Id child] int not null,
	foreign key ([Id child]) references Child (Id)
);

--Таблица измерения роста ребенка
create table EditHeight(
	Id int primary key not null,
	IdChild int not null,
	DateEditWeght date not null,
	Height int not null,
	foreign key (IdChild) references Child (Id)
)
