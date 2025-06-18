--Lab 5

--Создать  3 триггера:
	--a) Триггер любого типа на добавление нового ребенка в группу – 
	--		если в группе нет свободных мест, ребенок не добавляется
	
use Univer
go
create or alter trigger AddChildGroup
on [dbo].[Child]
instead of insert  
as
begin 
	if @@ROWCOUNT = 1
	begin

		declare @MaxCapacity int, @CurrentCapasity int, @IdGroup int

		select @IdGroup = i.[Id Group]
		from  inserted i

		select @MaxCapacity = [Max Count Child], @CurrentCapasity = [Count Child] 
		from Univer.dbo.[Group]
		where Id = @IdGroup

		if @MaxCapacity > @CurrentCapasity
		begin 
			insert into Univer.dbo.Child (Id, FIO, height, [weight], [date birth], adress, [Id Group], IdParent1, IdParent2)
			select *
			from inserted

			update Univer.dbo.[Group]
			set [Count Child] = [Count Child] + 1
			where Id = @IdGroup

			print('Новый ребенок дабавлен')
		end
		else
		begin
			print('Ребенок не добавлен')
		end
	end
	else
	begin 
		print('Введите одну строчку')
	end
end

use Univer
insert into Child
values (19, 'Орлов Виктор Петрович', 123, 37, '2020-10-23', 'Ярославль', 4, null, null)

select *
from [Group]
--where Id = 3

--b)  Последующий триггер на изменение дат начала и конца болезни ребенка – если окажется, 
--		что дата конца меньше, чем дата начала , то изменение дат не происходит, 
--		выдается соотв. сообщение
	
use Univer
go
create or alter trigger SetDateBeginEndDisease
on [Univer].dbo.Disease
after update
as 
begin
	declare @DateBegin date, @DateEnd date, @id int

	declare curs cursor for 
	select i.Id, i.[Begin], i.[End]
	from inserted i

	select @DateBegin = [Begin], @DateEnd = [End]
	from inserted

	declare @curId int, @curBegin date, @curEnd date

	open curs
	fetch next from curs into @curId, @curBegin, @curEnd
	while @@FETCH_STATUS = 0
	begin

		if DATEDIFF(YEAR, @curBegin, @curEnd) < 0
		begin 
			print('дата конца меньше, чем дата начала')

			select @DateBegin = d.[Begin], @DateEnd = d.[End], @id = d.Id from deleted d where d.Id = @curId

			delete from Disease where Id = @curId

			insert into Disease select * from deleted where Id = @curId
		end
		else if DATEDIFF(MONTH, @curBegin, @curEnd) < 0
		begin
			print('дата конца меньше, чем дата начала')

			select @DateBegin = d.[Begin], @DateEnd = d.[End], @id = d.Id from deleted d 

			delete from Disease where Id = @curId

			insert into Disease select * from deleted where Id = @curId
		end
		else if DATEDIFF(day, @curBegin, @curEnd) < 0
		begin
			print('дата конца меньше, чем дата начала')

			select @DateBegin = d.[Begin], @DateEnd = d.[End], @id = d.Id from deleted d 

			delete from Disease where Id = @curId

			insert into Disease select * from deleted where Id = @curid
		end
		else
		begin	
			print('Данные обновлены')
 		end

	fetch next from curs into @curId, @curBegin, @curEnd
	end

	close curs
	deallocate curs
end

use Univer
select *
from Disease

update Disease
set [Begin] = '2024-12-13', [End] = '2024-11-13'
--where Id = 2

--c) Замещающий триггер на операцию удаления – при выпуске ребенка из сада 
--		удаляются сведения о его родителях, показатели его роста, веса, болезни, 
--		корректируется количество свободных мест

use Univer
go
create or alter trigger DeleteChild
on Child
instead of delete
as
begin 
	if @@ROWCOUNT = 1
	begin
		declare @IdChild int, @IdGroup int, @IdParent1 int, @IdParent2 int

		select @IdChild = d.Id, @IdGroup = d.[Id Group], @IdParent1 = d.IdParent1, @IdParent2 = d.IdParent2
		from deleted d

		update [Group]
		set [Count Child] = [Count Child] - 1
		where Id = @IdGroup

		delete EditHeight
		where IdChild = @IdChild

		delete EditWeight
		where IdChild = @IdChild

		delete Disease
		where [Id child] = @IdChild

		delete Child
		where Id = (select Id from deleted)

--Проверим, есть ли у родителей еще дети

		declare @countChildParent int

		select @countChildParent = count(Id)
		from Child
		where IdParent1 = @IdParent1 or IdParent2 = @IdParent2
		
		if @countChildParent = 0
		begin
			delete Parent
			where Id = @IdParent1

			delete Parent
			where Id = @IdParent2
		end

		print('Ребенок и все данные о нем удалены')
	end
	else
	begin
		print('Удаляйте по одной строчке')
	end
end

use Univer

where Id = 2

use Univer
begin transaction 
select * from Child
delete Child
where Id = 6
select * from Child
select * from Parent
rollback