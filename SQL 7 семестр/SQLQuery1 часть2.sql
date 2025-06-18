--часть 2

--a) Ќайти детей из неполных семей

use Univer
select c.Id, c.FIO
from Child c
where c.IdParent1 is null or c.IdParent2 is null

--b) Ќайти количество свободных мест в садике дл€ детей 3, 4, 5, 6 лет

--добавить дл€ каждой группы по возрасту

use Univer
select sum([Max Count Child] - [Count Child]) as CountFreePlace, g.[Age Children]
from [Group] g
group by g.[Age Children]

--c) ƒл€ каждой группы вывести количество детей, болеющих на данный момент

--проверить вычислени€ за последний год правильно ли производ€тс€

use Univer
select isnull(c.[Id Group], -1) as IdGroup, count(c.Id) as CountDisChild
from Disease d join Child c on d.[Id child] = c.Id
where d.[Begin] is not null and d.[End] is null
group by c.[Id Group]

select * from Disease

--d) Ќайти наиболее часто болеющих детей (среднее кол-во заболеваний ребенка в год > 5)

--проверить вычислени€ услови€, за послдений год, правильно ли считаетс€, 
--использовать функцию дл€ высчитывани€ разности дат

use Univer
select c.Id, c.FIO, count(d.Id) as countDis
from Child c join Disease d on c.Id = d.[Id child]
where d.[End] >= DATEADD(YEAR, -1, GETDATE())
group by c.Id, c.FIO
having count(d.Id) > 5

--e) ¬ каждой возрастной категории найти детей, которые за последний год выросли на 10 см и больше

use Univer
select g.[Age Children], c.Id, c.FIO, max(c.height) - min(eh.Height) as deltaHeight
from [Group] g join Child c on g.Id = c.[Id Group] join [EditHeight] eh on c.Id = eh.IdChild
where eh.DateEditWeght >= DATEADD(year, -1, GETDATE())
group by g.[Age Children], c.Id, c.FIO
having max(c.height) - min(eh.Height) > 10