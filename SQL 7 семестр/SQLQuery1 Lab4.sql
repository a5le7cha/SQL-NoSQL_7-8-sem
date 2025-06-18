--Lab 4

use Univer

--Создать  4 различных хранимых процедуры:

--a) Процедура без параметров, выдающая список детей по группам,     ++++++
--		болеющих в данный момент, в виде: название группы, ФИО ребенка, 
--		дата начала болезни, диагноз

create or alter procedure ChildSickNow 
as
begin
	select g.Id, g.Title, c.FIO, d.[Begin], d.Diagnosis
	from Univer.dbo.[Group] g join Univer.dbo.Child c on g.Id = c.[Id Group] join Univer.dbo.Disease d on c.Id = d.[Id child]
	where d.[End] is null
	group by g.Id, g.Title, c.FIO, d.[Begin], d.Diagnosis
end

exec ChildSickNow

--b) Процедура, на входе получающая ФИО ребенка и формирующая список +++++
--		его показателей роста и веса за последний год

create or alter procedure ListIndicators @NameChild nvarchar(50)
as
begin
	select c.[weight] as Weigh, eh.[Height] as Height, eh.DateEditWeght
	from Univer.dbo.Child c join Univer.dbo.EditHeight eh on c.Id = eh.IdChild
	where c.FIO = @NameChild and eh.DateEditWeght >= DATEADD(YEAR, -1, getdate()) 
end

select *
from Univer.dbo.Child c join Univer.dbo.EditHeight eh on c.Id = eh.IdChild

declare @fioChild nvarchar(50)

set @fioChild = 'Коля'

exec ListIndicators @fioChild

--c) Процедура, на входе получающая ФИО ребенка,                ++++++
--		выходной параметр –  ФИО его воспитателя 
--		(если их несколько, то наиболее старшего по возрасту)

create or alter procedure TeacherChild @NameChild nvarchar(50), @NameTeacher nvarchar(50) output
as
begin
	select top 1 @NameTeacher = kt.FIO
	from Univer.dbo.[Kindergarten teacher] kt join Univer.dbo.[Group] g on kt.[Id Group] = g.Id 
	join Univer.dbo.Child c on g.Id = c.[Id Group]
	order by kt.DateOfBirth
end

declare @fioChild nvarchar(50), @fioKt nvarchar(50)

set @fioChild = 'Коля'

exec TeacherChild @fioChild, @fioKt output

print(@fioKt)

--d) Процедура, вызывающая вложенную процедуру:  ++++
--		вложенная процедура находит среднее количество заболеваний на 1-го ребенка в год; 
--		главная процедура выводит список детей, упорядоченный по группам, 
--		у которых среднее количество болезней в год больше, чем среднее по саду


--посчитать среднее количество заболеваний на 1го ребенка = 
-- = количество всех заболеваний / количество всех детей
create or alter procedure AverageNumberDiseases @AvgDis int output
as
begin
	select @AvgDis = AVG(countDis)
	from(
	select count(d.Id) as countDis
	from Univer.dbo.Child c join Univer.dbo.Disease d on c.Id = d.[Id child]
	group by c.Id, year(d.[End])) as a
end

create or alter procedure ListChild
as 
begin
	declare @avg int
	exec AverageNumberDiseases @avg output

	select distinct c.Id, c.FIO
	from Univer.dbo.Child c join Univer.dbo.Disease d on c.Id = d.[Id child]
	group by c.Id, c.FIO, year(d.[End])
	having count(d.Id) > @avg
	order by c.Id
end

exec ListChild

--3 пользовательских функции:

--a) Скалярная функция, которая возвращает средний показатель 
--		увеличения веса детей с начала текущего года

create or alter function AverageWeight()
returns decimal 
as
begin
	declare @avgW decimal

	select @avgW = cast(sum(ew.DeltaWeight) as decimal)/count(distinct ew.IdChild)
	from Univer.dbo.EditWeight ew
	where ew.DateEditWeight >= DATEFROMPARTS(YEAR(GETDATE()), 1, 1) and ew.DateEditWeight <= CAST(GETDATE() AS DATE)

	return @avgW 
end

declare @number decimal

set @number = Univer.dbo.AverageWeight()

print(@number)

--b) Inline-функция, возвращающая список детей из неполных семей ++++

create function ListChildFromSingleParentFamily()
returns table
as
return
select c.Id, c.FIO
from Univer.dbo.Child c
where c.IdParent1 is null or c.IdParent2 is null

select * from ListChildFromSingleParentFamily()

--c) Multi-statement-функция, выдающая инфомацию об изменении веса и роста детей 
--		за заданный год в виде: ФИО ребенка, рост на начало года, вес на начало года, 
--		рост на конец года, вес на конец года.

create or alter function GetChildrenGrowthAndWeightChange(@VarYear int)
returns @Result table (
    FullName nvarchar(100),
    HeightStart nvarchar(100),
    WeightStart nvarchar(100),
    HeightEnd nvarchar(100),
    WeightEnd nvarchar(100)
)
as
begin
    insert into @Result (FullName, HeightStart, WeightStart, HeightEnd, WeightEnd)
    select 
        c.FIO as FullName,
        isnull((select top 1 convert(nvarchar(100), eh.Height) 
         from Univer.dbo.EditHeight eh 
         where eh.IdChild = c.Id
         and YEAR(eh.DateEditWeght) = @VarYear 
         order by eh.DateEditWeght asc), 'не измерялся') as HeightStart,
        isnull((select top 1 convert(nvarchar(100), ew.[Weight]) 
         from Univer.dbo.EditWeight ew 
         where ew.IdChild = c.Id
         and YEAR(ew.DateEditWeight) = @VarYear 
         order by ew.DateEditWeight asc), 'не измерялся') as WeightStart,
        isnull((select top 1 convert(nvarchar(100), eh.Height) 
         from Univer.dbo.EditHeight eh 
         where eh.IdChild= c.Id
         and YEAR(eh.DateEditWeght) = @VarYear 
         order by eh.DateEditWeght desc), 'не измерялся') as HeightEnd,
        isnull((select top 1 convert(nvarchar(100), ew.[Weight]) 
         from Univer.dbo.EditWeight ew 
         where ew.IdChild= c.Id 
         and YEAR(ew.DateEditWeight) = @VarYear 
         order by ew.DateEditWeight desc), 'не измерялся') as WeightEnd
    from 
        Univer.dbo.Child c
    --where 
     --   exists (select 1 from Univer.dbo.EditWeight ew where ew.IdChild = c.Id and YEAR(ew.DateEditWeight) = @VarYear)
   --     or exists (select 1 from Univer.dbo.EditHeight eh where eh.IdChild = c.Id and YEAR(eh.DateEditWeght) = @VarYear)

    return
end

select * from Univer.dbo.EditWeight 

select * from GetChildrenGrowthAndWeightChange(2024)