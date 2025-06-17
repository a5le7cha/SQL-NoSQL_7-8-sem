--имя входа SQL
Create login [User_Vlasova]
with password=N'P@$$word',
default_database = [2023_IB_1],
check_expiration = off,
check_policy = off
--имя входа Windows
CREATE LOGIN [UNIVERSITY\vlasova_ov] FROM WINDOWS 
WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[Russian]
-- пользователь БД
use [2023_IB_1]
go
CREATE USER [User_Vlasova] FOR LOGIN [User_Vlasova] WITH DEFAULT_SCHEMA=[dbo]
CREATE USER [User1_Vlasova] FOR LOGIN [UNIVERSITY\vlasova_ov] WITH DEFAULT_SCHEMA=[dbo]
--подключение
select user_name(),CURRENT_USER
--пользователь без права входа 
CREATE USER [Test_Vlasova]  without login
execute as user = 'Test_Vlasova'
select user_name(),CURRENT_USER
revert
--выдача прав
grant select on [dbo].[Users] to [User_Vlasova] 
grant select on [dbo].[UsersAudit]([operation],[user],[date]) to [User_Vlasova] with grant option
--отбор прав
revoke select on [dbo].[Users] to [User_Vlasova] 
revoke grant option for  select on [dbo].[UsersAudit]([operation],[user],[date]) to [User_Vlasova] cascade
--выдача прав на выполнение хранимых процедур и функций
grant execute on [dbo].[BestOrder] to [User_Vlasova]
grant execute on [dbo].[prizEmployee] to [User_Vlasova] 
-- дать право на подключение и сделать членом роли datereadear
grant select on [dbo].[OrderProduct] to [User_Vlasova]
--создание роли
CREATE ROLE TestRole
CREATE ROLE TestRole1
ALTER ROLE TestRole ADD MEMBER [User_Vlasova]; 
grant select on [dbo].[UsersAudit]([operation],[user],[date]) to TestRole with grant option
grant select on [dbo].[UsersAudit]([operation],[user],[date]) to TestRole1 as TestRole

-- запрет
deny select on [dbo].[Users] to [User_Vlasova]

select * from master.sys.server_principals
select * from master.sys.login_token
select * from master.sys.database_permissions
select * from master.sys.database_role_members

SELECT  
    [UserName] = CASE princ.[type] 
                    WHEN 'S' THEN princ.[name]
                    WHEN 'U' THEN ulogin.[name] COLLATE Latin1_General_CI_AI
                 END,
    [UserType] = CASE princ.[type]
                    WHEN 'S' THEN 'SQL User'
                    WHEN 'U' THEN 'Windows User'
                 END,  
    [DatabaseUserName] = princ.[name],       
    [Role] = null,      
    [PermissionType] = perm.[permission_name],       
    [PermissionState] = perm.[state_desc],       
    [ObjectType] = obj.type_desc,--perm.[class_desc],       
    [ObjectName] = OBJECT_NAME(perm.major_id),
    [ColumnName] = col.[name]
FROM    
    --database user
    sys.database_principals princ  
LEFT JOIN
    --Login accounts
    sys.login_token ulogin on princ.[sid] = ulogin.[sid]
LEFT JOIN        
    --Permissions
    sys.database_permissions perm ON perm.[grantee_principal_id] = princ.[principal_id]
LEFT JOIN
    --Table columns
    sys.columns col ON col.[object_id] = perm.major_id 
                    AND col.[column_id] = perm.[minor_id]
LEFT JOIN
    sys.objects obj ON perm.[major_id] = obj.[object_id]
WHERE 
    princ.[type] in ('S','U')
UNION
--List all access provisioned to a sql user or windows user/group through a database or application role
SELECT  
    [UserName] = CASE memberprinc.[type] 
                    WHEN 'S' THEN memberprinc.[name]
                    WHEN 'U' THEN ulogin.[name] COLLATE Latin1_General_CI_AI
                 END,
    [UserType] = CASE memberprinc.[type]
                    WHEN 'S' THEN 'SQL User'
                    WHEN 'U' THEN 'Windows User'
                 END, 
    [DatabaseUserName] = memberprinc.[name],   
    [Role] = roleprinc.[name],      
    [PermissionType] = perm.[permission_name],       
    [PermissionState] = perm.[state_desc],       
    [ObjectType] = obj.type_desc,--perm.[class_desc],   
    [ObjectName] = OBJECT_NAME(perm.major_id),
    [ColumnName] = col.[name]
FROM    
    --Role/member associations
    sys.database_role_members members
JOIN
    --Roles
    sys.database_principals roleprinc ON roleprinc.[principal_id] = members.[role_principal_id]
JOIN
    --Role members (database users)
    sys.database_principals memberprinc ON memberprinc.[principal_id] = members.[member_principal_id]
LEFT JOIN
    --Login accounts
    sys.login_token ulogin on memberprinc.[sid] = ulogin.[sid]
LEFT JOIN        
    --Permissions
    sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id]
LEFT JOIN
    --Table columns
    sys.columns col on col.[object_id] = perm.major_id 
                    AND col.[column_id] = perm.[minor_id]
LEFT JOIN
    sys.objects obj ON perm.[major_id] = obj.[object_id]
UNION
--List all access provisioned to the public role, which everyone gets by default
SELECT  
    [UserName] = '{All Users}',
    [UserType] = '{All Users}', 
    [DatabaseUserName] = '{All Users}',       
    [Role] = roleprinc.[name],      
    [PermissionType] = perm.[permission_name],       
    [PermissionState] = perm.[state_desc],       
    [ObjectType] = obj.type_desc,--perm.[class_desc],  
    [ObjectName] = OBJECT_NAME(perm.major_id),
    [ColumnName] = col.[name]
FROM    
    --Roles
    sys.database_principals roleprinc
LEFT JOIN        
    --Role permissions
    sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id]
LEFT JOIN
    --Table columns
    sys.columns col on col.[object_id] = perm.major_id 
                    AND col.[column_id] = perm.[minor_id]                   
JOIN 
    --All objects   
    sys.objects obj ON obj.[object_id] = perm.[major_id]
WHERE
    --Only roles
    roleprinc.[type] = 'R' AND
    --Only public role
    roleprinc.[name] = 'public' AND
    --Only objects of ours, not the MS objects
    obj.is_ms_shipped = 0
ORDER BY
    princ.[Name],
    OBJECT_NAME(perm.major_id),
    col.[name],
    perm.[permission_name],perm.[state_desc],
    obj.type_desc--perm.[class_desc] 