--����� 2

--a) ����� ����� �� �������� �����

use Univer
select c.Id, c.FIO
from Child c
where c.IdParent1 is null or c.IdParent2 is null

--b) ����� ���������� ��������� ���� � ������ ��� ����� 3, 4, 5, 6 ���

--�������� ��� ������ ������ �� ��������

use Univer
select sum([Max Count Child] - [Count Child]) as CountFreePlace, g.[Age Children]
from [Group] g
group by g.[Age Children]

--c) ��� ������ ������ ������� ���������� �����, �������� �� ������ ������

--��������� ���������� �� ��������� ��� ��������� �� ������������

use Univer
select isnull(c.[Id Group], -1) as IdGroup, count(c.Id) as CountDisChild
from Disease d join Child c on d.[Id child] = c.Id
where d.[Begin] is not null and d.[End] is null
group by c.[Id Group]

select * from Disease

--d) ����� �������� ����� �������� ����� (������� ���-�� ����������� ������� � ��� > 5)

--��������� ���������� �������, �� ��������� ���, ��������� �� ���������, 
--������������ ������� ��� ������������ �������� ���

use Univer
select c.Id, c.FIO, count(d.Id) as countDis
from Child c join Disease d on c.Id = d.[Id child]
where d.[End] >= DATEADD(YEAR, -1, GETDATE())
group by c.Id, c.FIO
having count(d.Id) > 5

--e) � ������ ���������� ��������� ����� �����, ������� �� ��������� ��� ������� �� 10 �� � ������

use Univer
select g.[Age Children], c.Id, c.FIO, max(c.height) - min(eh.Height) as deltaHeight
from [Group] g join Child c on g.Id = c.[Id Group] join [EditHeight] eh on c.Id = eh.IdChild
where eh.DateEditWeght >= DATEADD(year, -1, GETDATE())
group by g.[Age Children], c.Id, c.FIO
having max(c.height) - min(eh.Height) > 10