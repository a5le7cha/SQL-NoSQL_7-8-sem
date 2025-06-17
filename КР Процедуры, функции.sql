--Хранимая процедура, Вариант 11

use [контрольная работа]
go

create or alter procedure FreeMenedger
as 
begin 
	select DISTINCT s.ФИО, count(k.[№ контракта]) as [Количество не вышедших в тираж книг]
	from dbo.Книги k join 
	dbo.Сотрудники s on 
	k.Менеджер = s.[Табельный номер]
	join dbo.Должности d 
	on s.[Код должности] = d.[Код должности]
	where s.[Код должности] = 1 and k.[Дата выхода] > GETDATE()
	group by s.[Табельный номер], s.ФИО
	order by count(k.[№ контракта]) asc
end;

exec FreeMenedger






--Функция, Вариант 11

INSERT into dbo.Книги ([№ контракта], [Дата подписи контракта], [Менеджер], [Название], [Цена], [Затраты], [Авторский гонорар], [Дата выхода], [Тираж], [Ответственный редактор], [Остаток тиража]) 
VALUES (15, CAST(0xA0390B00 AS Date), 1, N'Географические проблемы', 100.0000, 50.0000, 30.0000, CAST(0xBC390B00 AS Date), 3000, 2, 10),
(16, CAST(0xA0390B00 AS Date), 1, N'Хорреография', 100.0000, 50.0000, 30.0000, CAST(0xBC390B00 AS Date), 1000, 2, 100),
(17, CAST(0xA0390B00 AS Date), 1, N'Современный танец', 100.0000, 50.0000, 30.0000, CAST(0xBC390B00 AS Date), 1000, 2, 500),
(18, CAST(0xA0390B00 AS Date), 1, N'Основы балета', 100.0000, 50.0000, 30.0000, CAST(0xBC390B00 AS Date), 5000, 2, 1000),
(19, CAST(0xA0390B00 AS Date), 1, N'Основы народного танца', 100.0000, 50.0000, 30.0000, CAST(0xBC390B00 AS Date), 12000, 2, 1000)

create or alter function SellingBooks()
returns table
as
return
(
	select top 5 [№ контракта], [Дата подписи контракта], [Менеджер], [Название], [Цена], [Затраты], [Авторский гонорар], [Дата выхода], [Ответственный редактор], [Тираж], [Остаток тиража], [Тираж]-[Остаток тиража] as Продано, CONVERT(float, [Остаток тиража]) / CONVERT(float, [Тираж]) as Продаваемость
	from dbo.Книги
	order by CONVERT(float, [Остаток тиража]) / CONVERT(float, [Тираж]) asc
)

select *
from SellingBooks()







--Триггер, Вариант 6
create trigger DismissalOfAnEmployee
on [University\a.eremeev].Сотрудники
after update
as  
begin 
	declare @TabNumberEmp int
	set @TabNumberEmp = (select [Табельный номер] from inserted)



	update [University\a.eremeev].Сотрудники s
	set s.[Код должности] = 0
	where s.[Табельный номер] = (select [Табельный номер] from inserted)
end



create trigger DismissalOfAnEmployee
on Сотрудники
after update
as
begin
	if exists (select * from inserted where [Код должности] = 0)
	begin
		declare @DeletedEditorId int;
		declare @BookContractId int;

		select @DeletedEditorId = [Табельный номер] from deleted;

		declare @EditorId int;

		declare book_cursor cursor for
		select [№ контракта]
		from Книги
		where [Ответственный редактор] = @DeletedEditorId and [Дата выхода] > GETDATE();

		open book_cursor;
		fetch next from book_cursor into @BookContractId;

		while @@FETCH_STATUS = 0
		begin
			
			select top 1 @EditorId = [Код редактора]
			from (
				select [Код редактора], count(*) as EditCount
				from [Книги-Редакторы]
				group by [Код редактора]
			) as EditorCounts
			order by EditCount asc;

			update Книги
			set [Ответственный редактор] = @EditorId
			where [№ контракта] = @BookContractId;

			fetch next from book_cursor INTO @BookContractId;
		end

		close book_cursor;
		deallocate book_cursor;
	end
end

select *
from Сотрудники

update Сотрудники
set [Код должности] = 0
where [Табельный номер] = 5