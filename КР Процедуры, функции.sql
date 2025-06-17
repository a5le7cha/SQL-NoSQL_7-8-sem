--�������� ���������, ������� 11

use [����������� ������]
go

create or alter procedure FreeMenedger
as 
begin 
	select DISTINCT s.���, count(k.[� ���������]) as [���������� �� �������� � ����� ����]
	from dbo.����� k join 
	dbo.���������� s on 
	k.�������� = s.[��������� �����]
	join dbo.��������� d 
	on s.[��� ���������] = d.[��� ���������]
	where s.[��� ���������] = 1 and k.[���� ������] > GETDATE()
	group by s.[��������� �����], s.���
	order by count(k.[� ���������]) asc
end;

exec FreeMenedger






--�������, ������� 11

INSERT into dbo.����� ([� ���������], [���� ������� ���������], [��������], [��������], [����], [�������], [��������� �������], [���� ������], [�����], [������������� ��������], [������� ������]) 
VALUES (15, CAST(0xA0390B00 AS Date), 1, N'�������������� ��������', 100.0000, 50.0000, 30.0000, CAST(0xBC390B00 AS Date), 3000, 2, 10),
(16, CAST(0xA0390B00 AS Date), 1, N'������������', 100.0000, 50.0000, 30.0000, CAST(0xBC390B00 AS Date), 1000, 2, 100),
(17, CAST(0xA0390B00 AS Date), 1, N'����������� �����', 100.0000, 50.0000, 30.0000, CAST(0xBC390B00 AS Date), 1000, 2, 500),
(18, CAST(0xA0390B00 AS Date), 1, N'������ ������', 100.0000, 50.0000, 30.0000, CAST(0xBC390B00 AS Date), 5000, 2, 1000),
(19, CAST(0xA0390B00 AS Date), 1, N'������ ��������� �����', 100.0000, 50.0000, 30.0000, CAST(0xBC390B00 AS Date), 12000, 2, 1000)

create or alter function SellingBooks()
returns table
as
return
(
	select top 5 [� ���������], [���� ������� ���������], [��������], [��������], [����], [�������], [��������� �������], [���� ������], [������������� ��������], [�����], [������� ������], [�����]-[������� ������] as �������, CONVERT(float, [������� ������]) / CONVERT(float, [�����]) as �������������
	from dbo.�����
	order by CONVERT(float, [������� ������]) / CONVERT(float, [�����]) asc
)

select *
from SellingBooks()







--�������, ������� 6
create trigger DismissalOfAnEmployee
on [University\a.eremeev].����������
after update
as  
begin 
	declare @TabNumberEmp int
	set @TabNumberEmp = (select [��������� �����] from inserted)



	update [University\a.eremeev].���������� s
	set s.[��� ���������] = 0
	where s.[��������� �����] = (select [��������� �����] from inserted)
end



create trigger DismissalOfAnEmployee
on ����������
after update
as
begin
	if exists (select * from inserted where [��� ���������] = 0)
	begin
		declare @DeletedEditorId int;
		declare @BookContractId int;

		select @DeletedEditorId = [��������� �����] from deleted;

		declare @EditorId int;

		declare book_cursor cursor for
		select [� ���������]
		from �����
		where [������������� ��������] = @DeletedEditorId and [���� ������] > GETDATE();

		open book_cursor;
		fetch next from book_cursor into @BookContractId;

		while @@FETCH_STATUS = 0
		begin
			
			select top 1 @EditorId = [��� ���������]
			from (
				select [��� ���������], count(*) as EditCount
				from [�����-���������]
				group by [��� ���������]
			) as EditorCounts
			order by EditCount asc;

			update �����
			set [������������� ��������] = @EditorId
			where [� ���������] = @BookContractId;

			fetch next from book_cursor INTO @BookContractId;
		end

		close book_cursor;
		deallocate book_cursor;
	end
end

select *
from ����������

update ����������
set [��� ���������] = 0
where [��������� �����] = 5