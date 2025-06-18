--часть 1
--1.1 Выбрать из произвольной таблицы данные и отсортировать их по двум  
--произвольным имеющимся в таблице признакам (разные направления сортировки).

--Найти родителей, их работу и номер телефона, отсортированных по ФИО и номеру телефона

use Univer
select FIO, Job, [Number Phone]
from Parent
order by FIO, [Number Phone]

--1.2 Выбрать из произвольной таблицы те записи, которые удовлетворяют
--условию отбора (where). Привести 2-3 запроса

-- Найти всех воспитателей, которые работают в группе с id = 2

use Univer
select *
from [Kindergarten teacher]
where [Id Group] = 2

--Найти воспитателя под номером 1

use Univer
select FIO
from [Kindergarten teacher]
where Number = 1

--1.3 Привести примеры 2-3 запросов с использованием агрегатных функций
--(count, max, sum и др.) с группировкой и без группировки. 

--Посчитать количество детей в детском саду

use Univer
select count(id) countID 
from Child

--Найти самый большой вес среди детей

use Univer
select max(weight) maxWeight
from Child

--Найти детей, которые живут в Ярославле

use Univer
select FIO
from Child
where weight > 20 and adress = 'Ярославль'
group by adress, FIO

--1.4  Привести примеры подведения подытога с использованием 
--GROUP BY [ALL] [ CUBE | ROLLUP](2-3 запроса). 
--В ROLLUP и CUBE использовать не менее 2-х столбцов

--Найти родителей, у который нет работы

use Univer
select FIO, Job
from Parent
group by rollup(FIO, Job)
having Job = 'Нет'

--Найти родителей, которые зарабатывают больше 20000 р

use Univer
select FIO, monyParent
from Parent
group by FIO, rollup(monyParent)
having monyParent>20000

--1.5 Выбрать из таблиц информацию об объектах, 
--в названиях которых нет заданной последовательности букв (LIKE).

--Найти тех родителей, у который Фамилия начиается не с буквы Г

use Univer
select *
from Parent
where FIO not like 'Г%' 

--2.1 Вывести информацию подчиненной (дочерней) таблицы, заменяя коды
--(значения внешних ключей) соответствующими символьными значениями из
--родительских таблиц. Привести 2-3 запроса с использованием классического
--подхода соединения таблиц (where).

--Найти номера, ФИО воспитателей и группу в которой они работают

Use Univer
select 
Number,
FIO,
(select Title
from [Group]
where [Id Group] = [Group].Id) as TitleGroup
from [Kindergarten teacher]

--Найти данные детей и название группы, в которой они состоят 

Use Univer
select FIO, height, [weight], adress,
(select Title
from [Group]
where [Id Group] = [Group].Id) as TitleGroup
from Child

--2.2. Реализовать запросы пункта 2.1 через внутреннее соединение inner join.

--Найти воспитателя и название группы, в которой она работает

Use Univer
select FIO, Title
from [Kindergarten teacher] kt join [Group] g on kt.[Id Group] = g.Id

--Найти детей и группу, в которой они состоят

use Univer
select c.Id IdChild, c.FIO, adress AdrChild, Title
from Child c join [Group] g on c.[Id Group] = g.Id

--2.3. Левое внешнее соединение left join. Привести 2-3 запроса.

--Вывестиа всю информацию о детях и группах, в которых они находятся

Use Univer
select *
from Child ch left join [Group] g on ch.[Id Group] = g.Id

--Вывести информацию о воспитателях и группах, в которых они работают

Use Univer
select *
from [Kindergarten teacher] kt left join [Group] g on kt.[Id Group] = g.Id

--2.4. Правое внешнее соединение right join. Привести 2-3 запроса 

--Вывести всю информацию о детях и их родителях

use Univer;
select distinct *
from Child c right join Parent p on c.IdParent1 = p.Id or c.IdParent2 = p.Id

--Вывести всю информацию о детях и группах, в которых они учаться 

use Univer
select *
from [Group] g right join Child c on g.Id = c.[Id Group]

--2.5. Привести примеры 2-3 запросов с использованием агрегатных функций
--и группировки.

--Найти общую сумму дохода родителей каждого ребенка

use Univer
select sum(p.monyParent) as AllSumParent
from Parent p join Child c on p.Id = c.IdParent1 or p.Id = c.IdParent2
group by c.Id

--Найти количество детей в группах

use Univer
select count(c.Id) as countChild
from Child c join [Group] g on c.[Id Group] = g.Id
group by c.Id

--2.6. Привести примеры 2-3 запросов с использованием группировки 
--и условия отбора групп (Having).

--Найти матерей каждого ребенка

use Univer
select c.Id as IdChild, p.Id as IdParent, p.FIO as FIOParent
from Parent p join [Child] c on p.Id = c.IdParent1 or p.Id = c.IdParent2
group by c.Id, p.Status, p.Id, p.FIO
having p.Status = 'мать'

--Найти детей, у родителей которых нет работы, 
--вывести идентификатор ребенка и родителя, вывести ФИО родителя

use Univer
select Parent.FIO
from Parent
group by Parent.Job, Parent.FIO
having Parent.Job = 'Нет'

--3.1  На основе любых запросов из п. 2 создать два представления (VIEW).

--Найти общую сумму дохода родителей каждого ребенка

create view CountParent
as select sum(p.monyParent) as countParent
from Parent p join Child c on p.Id = c.IdParent1 or p.Id = c.IdParent2
group by c.Id	

use Univer
select * from CountParent

--Найти матерей детей

create view ParentMam
as 
select c.Id as IdChild, p.Id as IdParent, p.FIO as FIOParent
from Parent p join [Child] c on p.Id = c.IdParent1 or p.Id = c.IdParent2
group by c.Id, p.Status, p.Id, p.FIO
having p.Status = 'мать'

use Univer
select * from ParentMam

--3.2  Привести примеры использования общетабличных выражений (СТЕ) (2-3 запроса)

--Найти родителей, которые зарабатывают больше 10000

use Univer;
with ChildParent as
(
	select p.FIO
	from Parent p join Child c on p.Id = c.IdParent1 or p.Id = c.IdParent2
	where p.monyParent > 10000
)

select *
from ChildParent 

--Найти тех воспистателей, котрые работают в группах

use Univer;
with NotNullKing as (
	 select kt.FIO
	 from [Kindergarten teacher] kt
	 where kt.[Id Group]  is not null
)

select *
from NotNullKing
	
--5.1 Привести примеры 3-4 запросов с использованием UNION / UNION ALL, EXCEPT, INTERSECT. 
--Данные  в одном из запросов отсортируйте по произвольному признаку.

--Часто болеющие дети и те, кто не вырос за последний год

use Univer
select c.Id, c.FIO
from Child c join Disease d on c.Id = d.[Id child]
group by c.Id, c.FIO
having count(d.ID) > 3
union all
select 
    c.Id,
    c.FIO
from
    Child c
left join 
    (select 
        e.IdChild,
        e.Height,
        ROW_NUMBER() over (partition by e.IdChild order by e.DateEditWeght desc) as rn
    FROM 
        EditHeight e
    WHERE 
        e.IdChild >= DATEADD(YEAR, -1, GETDATE())) lh ON c.Id = lh.IdChild
where 
    lh.rn is null or
    (select MIN(Height) from EditHeight eh where eh.IdChild = c.Id) = 
    (select MAX(Height) from EditHeight eh where eh.IdChild = c.Id)

--Найти детей, которые максимально выросли (дети которые имею самый большой рост) и не болели

select id, FIO,height
from Child
where height = (select MAX(height) from Child)
intersect
select c.id, c.FIO, c.height
from Child c
left join Disease d on c.id = d.[Id child]
where d.[Id child] is null

--6.1 Привести примеры получения сводных (итоговых) таблиц с использованием CASE

use Univer
select FIO,
		case 
			when monyParent >= 50000 then 'Is big'
			when monyParent <= 1000 then 'Is small'
			else 'Simple'
		end as BigMony
from Parent

--6.2 Привести примеры получения сводных (итоговых) таблиц с использованием PIVOT и UNPIVOT.

--вывести сколько детей в каждой группе болеет болезнями (боль, ОРВИ, грипп)

select *
from (
    select
        g.Title,
        d.Diagnosis,
        count(c.Id) as ChildCount
    from 
        [Group] g
    join 
         Child c on c.[Id Group] = g.Id
    join 
        Disease d on c.Id = d.[Id child]
    group by 
        g.Title, d.Diagnosis
) AS SourceTable
pivot (
    sum(ChildCount)
    for Diagnosis in ([грип], [ОРВИ], [боль])) as PivotTable

--