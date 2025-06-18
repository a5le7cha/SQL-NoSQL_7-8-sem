--����� 1
--1.1 ������� �� ������������ ������� ������ � ������������� �� �� ����  
--������������ ��������� � ������� ��������� (������ ����������� ����������).

--����� ���������, �� ������ � ����� ��������, ��������������� �� ��� � ������ ��������

use Univer
select FIO, Job, [Number Phone]
from Parent
order by FIO, [Number Phone]

--1.2 ������� �� ������������ ������� �� ������, ������� �������������
--������� ������ (where). �������� 2-3 �������

-- ����� ���� ������������, ������� �������� � ������ � id = 2

use Univer
select *
from [Kindergarten teacher]
where [Id Group] = 2

--����� ����������� ��� ������� 1

use Univer
select FIO
from [Kindergarten teacher]
where Number = 1

--1.3 �������� ������� 2-3 �������� � �������������� ���������� �������
--(count, max, sum � ��.) � ������������ � ��� �����������. 

--��������� ���������� ����� � ������� ����

use Univer
select count(id) countID 
from Child

--����� ����� ������� ��� ����� �����

use Univer
select max(weight) maxWeight
from Child

--����� �����, ������� ����� � ���������

use Univer
select FIO
from Child
where weight > 20 and adress = '���������'
group by adress, FIO

--1.4  �������� ������� ���������� �������� � �������������� 
--GROUP BY [ALL] [ CUBE | ROLLUP](2-3 �������). 
--� ROLLUP � CUBE ������������ �� ����� 2-� ��������

--����� ���������, � ������� ��� ������

use Univer
select FIO, Job
from Parent
group by rollup(FIO, Job)
having Job = '���'

--����� ���������, ������� ������������ ������ 20000 �

use Univer
select FIO, monyParent
from Parent
group by FIO, rollup(monyParent)
having monyParent>20000

--1.5 ������� �� ������ ���������� �� ��������, 
--� ��������� ������� ��� �������� ������������������ ���� (LIKE).

--����� ��� ���������, � ������� ������� ��������� �� � ����� �

use Univer
select *
from Parent
where FIO not like '�%' 

--2.1 ������� ���������� ����������� (��������) �������, ������� ����
--(�������� ������� ������) ���������������� ����������� ���������� ��
--������������ ������. �������� 2-3 ������� � �������������� �������������
--������� ���������� ������ (where).

--����� ������, ��� ������������ � ������ � ������� ��� ��������

Use Univer
select 
Number,
FIO,
(select Title
from [Group]
where [Id Group] = [Group].Id) as TitleGroup
from [Kindergarten teacher]

--����� ������ ����� � �������� ������, � ������� ��� ������� 

Use Univer
select FIO, height, [weight], adress,
(select Title
from [Group]
where [Id Group] = [Group].Id) as TitleGroup
from Child

--2.2. ����������� ������� ������ 2.1 ����� ���������� ���������� inner join.

--����� ����������� � �������� ������, � ������� ��� ��������

Use Univer
select FIO, Title
from [Kindergarten teacher] kt join [Group] g on kt.[Id Group] = g.Id

--����� ����� � ������, � ������� ��� �������

use Univer
select c.Id IdChild, c.FIO, adress AdrChild, Title
from Child c join [Group] g on c.[Id Group] = g.Id

--2.3. ����� ������� ���������� left join. �������� 2-3 �������.

--�������� ��� ���������� � ����� � �������, � ������� ��� ���������

Use Univer
select *
from Child ch left join [Group] g on ch.[Id Group] = g.Id

--������� ���������� � ������������ � �������, � ������� ��� ��������

Use Univer
select *
from [Kindergarten teacher] kt left join [Group] g on kt.[Id Group] = g.Id

--2.4. ������ ������� ���������� right join. �������� 2-3 ������� 

--������� ��� ���������� � ����� � �� ���������

use Univer;
select distinct *
from Child c right join Parent p on c.IdParent1 = p.Id or c.IdParent2 = p.Id

--������� ��� ���������� � ����� � �������, � ������� ��� ������� 

use Univer
select *
from [Group] g right join Child c on g.Id = c.[Id Group]

--2.5. �������� ������� 2-3 �������� � �������������� ���������� �������
--� �����������.

--����� ����� ����� ������ ��������� ������� �������

use Univer
select sum(p.monyParent) as AllSumParent
from Parent p join Child c on p.Id = c.IdParent1 or p.Id = c.IdParent2
group by c.Id

--����� ���������� ����� � �������

use Univer
select count(c.Id) as countChild
from Child c join [Group] g on c.[Id Group] = g.Id
group by c.Id

--2.6. �������� ������� 2-3 �������� � �������������� ����������� 
--� ������� ������ ����� (Having).

--����� ������� ������� �������

use Univer
select c.Id as IdChild, p.Id as IdParent, p.FIO as FIOParent
from Parent p join [Child] c on p.Id = c.IdParent1 or p.Id = c.IdParent2
group by c.Id, p.Status, p.Id, p.FIO
having p.Status = '����'

--����� �����, � ��������� ������� ��� ������, 
--������� ������������� ������� � ��������, ������� ��� ��������

use Univer
select Parent.FIO
from Parent
group by Parent.Job, Parent.FIO
having Parent.Job = '���'

--3.1  �� ������ ����� �������� �� �. 2 ������� ��� ������������� (VIEW).

--����� ����� ����� ������ ��������� ������� �������

create view CountParent
as select sum(p.monyParent) as countParent
from Parent p join Child c on p.Id = c.IdParent1 or p.Id = c.IdParent2
group by c.Id	

use Univer
select * from CountParent

--����� ������� �����

create view ParentMam
as 
select c.Id as IdChild, p.Id as IdParent, p.FIO as FIOParent
from Parent p join [Child] c on p.Id = c.IdParent1 or p.Id = c.IdParent2
group by c.Id, p.Status, p.Id, p.FIO
having p.Status = '����'

use Univer
select * from ParentMam

--3.2  �������� ������� ������������� ������������� ��������� (���) (2-3 �������)

--����� ���������, ������� ������������ ������ 10000

use Univer;
with ChildParent as
(
	select p.FIO
	from Parent p join Child c on p.Id = c.IdParent1 or p.Id = c.IdParent2
	where p.monyParent > 10000
)

select *
from ChildParent 

--����� ��� �������������, ������ �������� � �������

use Univer;
with NotNullKing as (
	 select kt.FIO
	 from [Kindergarten teacher] kt
	 where kt.[Id Group]  is not null
)

select *
from NotNullKing
	
--5.1 �������� ������� 3-4 �������� � �������������� UNION / UNION ALL, EXCEPT, INTERSECT. 
--������  � ����� �� �������� ������������ �� ������������� ��������.

--����� �������� ���� � ��, ��� �� ����� �� ��������� ���

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

--����� �����, ������� ����������� ������� (���� ������� ���� ����� ������� ����) � �� ������

select id, FIO,height
from Child
where height = (select MAX(height) from Child)
intersect
select c.id, c.FIO, c.height
from Child c
left join Disease d on c.id = d.[Id child]
where d.[Id child] is null

--6.1 �������� ������� ��������� ������� (��������) ������ � �������������� CASE

use Univer
select FIO,
		case 
			when monyParent >= 50000 then 'Is big'
			when monyParent <= 1000 then 'Is small'
			else 'Simple'
		end as BigMony
from Parent

--6.2 �������� ������� ��������� ������� (��������) ������ � �������������� PIVOT � UNPIVOT.

--������� ������� ����� � ������ ������ ������ ��������� (����, ����, �����)

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
    for Diagnosis in ([����], [����], [����])) as PivotTable

--