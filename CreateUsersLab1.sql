create login [User_Alexey]
with password = N'Er_alesha_',
default_database = [Univer],
check_expiration = off,
check_policy = off

alter login [Yana] 
with password = N'1234',
default_database = [Univer], 
check_expiration = off,
check_policy = off

use [Univer]
go
create user [User_Alexey] for login [User_Alexey] with default_schema = [dbo]
create user [User_Yana1] for login [Yana] with default_schema = [dbo]

create role AdminRole
create role UserRole

--предоставление прав админу на все действия с таблицами
grant select, update, delete, insert on [dbo].[Child] to AdminRole
grant select, update, delete, insert on [dbo].[Disease] to AdminRole
grant select, update, delete, insert on [dbo].[EditHeight] to AdminRole
grant select, update, delete, insert on [dbo].[EditWeight] to AdminRole
grant select, update, delete, insert on [dbo].[Group] to AdminRole
grant select, update, delete, insert on [dbo].[Kindergarten teacher] to AdminRole
grant select, update, delete, insert on [dbo].[Parent] to AdminRole
grant select, update, delete, insert on [dbo].[Program] to AdminRole

--Выдача прав админу на выполнение хранимой процедуры
grant execute on [dbo].[ChildSickNow] to AdminRole
grant execute on [dbo].[ListIndicators] to AdminRole
grant execute on [dbo].[TeacherChild] to AdminRole

--выдача прав админу на выполнения функции
grant select on [dbo].[GetChildrenGrowthAndWeightChange] to AdminRole 
grant select on [dbo].[ListChildFromSingleParentFamily] to AdminRole with grant option
grant execute on [dbo].[AverageWeight]  to AdminRole with grant option

--предоствление прав админу на представление
grant select on [dbo].[CountParent] to AdminRole
grant select on [dbo].[ParentMam] to AdminRole

--назначение роли AdminRole пользователю User_Alexey
exec sp_addrolemember 'AdminRole', 'User_Alexey'

--назначение роли простого пользователя прав на таблицы
grant select, insert, update, delete on [Univer].[dbo].[Child] to User_Yana1
grant select, insert, update, delete on [Univer].[dbo].[Group] to User_Yana1

--назначение роли UserRole пользоватлю User_Yana
exec sp_addrolemember 'UserRole', 'User_Yana1'


select dp.name AS Role_Name,
    obj.name AS Object_Name,
    p.permission_name,
    p.state_desc AS Permission_State
from sys.database_permissions p join sys.objects obj on p.major_id = obj.object_id
JOIN 
    sys.database_principals dp on p.grantee_principal_id = dp.principal_id
where dp.type IN ('R', 'S') and obj.name = 'Child'
order by dp.name, obj.name