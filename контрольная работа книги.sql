use [����������� ������]
go

Create table ���������(
	[��� ���������] int not null primary key,
	[�������� ���������] nvarchar(10) not null,
	����� money,
	[���������� ������� ������] int
)
Create table ������(
	[��� ������] int not null primary key,
	��� nvarchar(30) not null,
	[���������� ������] nvarchar(30) not null unique,
	��� nvarchar(15)  unique,
	����� nvarchar(50) not null ,
	������� nvarchar(10) not null 
)
Create table ������(
	[� ������] int not null primary key,
	�������� nvarchar(30) not null,
	[���� ����������� ������] date not null,
	[����� ���������] nvarchar(50) not null,
	[���� ���������� ������] date
)
Create table ����������(
	[��������� �����]int not null primary key,
 	��� nvarchar(30) not null,
	[���� ��������] date not null,
  	��� char(1), 
  	[���������� ������] nvarchar(30) not null unique,
  	��� nvarchar(15)  unique,
   	[��� ���������] int foreign key references ���������,
   	����� nvarchar(50) not null ,
	������� nvarchar(10) not null
 )
Create table �����(
	[� ���������] int not null primary key, 
	[���� ������� ���������] date not null,
	 �������� int foreign key references ����������, 
 	�������� nvarchar(50) not null ,
  	���� money not null,
  	������� money not null,
 	[��������� �������] money not null, 
 	[���� ������] date not null, 
	 ����� int not null , 
 	[������������� ��������] int foreign key references ����������, 
 	[������� ������] int not null
)
 Create table [�����-������] (
	[� ���������] int not null foreign key references �����,  
 	[��� ������] int not null foreign key references ������, 
	[����� �� �������]  int not null, 
 	�������  int not null,
 	primary key ([� ���������],[��� ������])
)
Create table [�����-���������](
	[� ���������] int not null foreign key references �����, 
	[��� ���������] int foreign key references ����������,
	primary key ([� ���������],[��� ���������])
)
Create table [������-������](
	[� ������] int not null foreign key references ������,
 	[� ���������] int not null foreign key references �����,
 	���������� int not null,
  	primary key ([� ���������],[� ������])
)


INSERT [���������] ([��� ���������], [�������� ���������], [�����], [���������� ������� ������]) VALUES (1, N'��������', 1000.0000, 3)
INSERT [���������] ([��� ���������], [�������� ���������], [�����], [���������� ������� ������]) VALUES (2, N'��������', 500.0000, 5)
INSERT [���������] ([��� ���������], [�������� ���������], [�����]) VALUES (0, N'������', 0.0000)

INSERT [����������] ([��������� �����], [���], [���� ��������], [���], [���������� ������], [���], [��� ���������], [�����], [�������]) VALUES (1, N' ������ ������ ����������', CAST(0xB1DC0A00 AS Date), N'�', N'7800123456', N'123456789123', 1, N'������� ��.���� 19-3', N'123456')
INSERT [����������] ([��������� �����], [���], [���� ��������], [���], [���������� ������], [���], [��� ���������], [�����], [�������]) VALUES (2, N'������� �������� ��������', CAST(0xF5EA0A00 AS Date), N'�', N'7802123456', N'789456123789', 2, N'������ ��.�������� 50-78', N'789456')
INSERT [����������] ([��������� �����], [���], [���� ��������], [���], [���������� ������], [���], [��� ���������], [�����], [�������]) VALUES (3, N'������ ���������� ����������', CAST(0x18F20A00 AS Date), N'�', N'7804456123', N'456123789456', 2, N'������ ��.������� ��� 5-3', N'456123')
INSERT [����������] ([��������� �����], [���], [���� ��������], [���], [���������� ������], [���], [��� ���������], [�����], [�������]) VALUES (4, N'����������� ������� ��������', CAST(0x5FF60A00 AS Date), N'�', N'7801123456', N'456123123123', 1, N'��������� ��.������ 5-1', N'456123')
INSERT [����������] ([��������� �����], [���], [���� ��������], [���], [���������� ������], [���], [��� ���������], [�����], [�������]) VALUES (5, N'�������� ���� ����������', CAST(0x30170B00 AS Date), N'�', N'7806456123', N'741852963852', 2, N'�������� ��.�������� ������ 11-5', N'741963')
INSERT [����������] ([��������� �����], [���], [���� ��������], [���], [���������� ������], [���], [��� ���������], [�����], [�������]) VALUES (6, N'��������� ���� ���������', CAST(0x9D180B00 AS Date), N'�', N'7803456789', N'963741852852', 2, N'����� ��.������ 4-25', N'852741')

INSERT [�����] ([� ���������], [���� ������� ���������], [��������], [��������], [����], [�������], [��������� �������], [���� ������], [�����], [������������� ��������], [������� ������]) VALUES (1, CAST(0xA0390B00 AS Date), 1, N'����������� �������� ���������� � �����������', 100.0000, 50.0000, 30.0000, CAST(0xBC390B00 AS Date), 1000, 2, 1000)
INSERT [�����] ([� ���������], [���� ������� ���������], [��������], [��������], [����], [�������], [��������� �������], [���� ������], [�����], [������������� ��������], [������� ������]) VALUES (2, CAST(0x8C390B00 AS Date), 4, N'��������� � ��������� �������������� ��������', 250.0000, 100.0000, 50.0000, CAST(0xAB390B00 AS Date), 2000, 3, 2000)
INSERT [�����] ([� ���������], [���� ������� ���������], [��������], [��������], [����], [�������], [��������� �������], [���� ������], [�����], [������������� ��������], [������� ������]) VALUES (3, CAST(0xA9390B00 AS Date), 4, N'�������� ������� ������������� �����������', 150.0000, 90.0000, 20.0000, CAST(0xC6390B00 AS Date), 1500, 2, 1500)
INSERT [�����] ([� ���������], [���� ������� ���������], [��������], [��������], [����], [�������], [��������� �������], [���� ������], [�����], [������������� ��������], [������� ������]) VALUES (4, CAST(0x5D390B00 AS Date), 1, N'���������� ����� � ����������', 300.0000, 200.0000, 100.0000, CAST(0x77390B00 AS Date), 2000, 6, 2000)
INSERT [�����] ([� ���������], [���� ������� ���������], [��������], [��������], [����], [�������], [��������� �������], [���� ������], [�����], [������������� ��������], [������� ������]) VALUES (5, CAST(0x78390B00 AS Date), 1, N'����������� ��� ������� � �����������', 230.0000, 150.0000, 70.0000, CAST(0xA9390B00 AS Date), 1000, 5, 1000)
INSERT [�����] ([� ���������], [���� ������� ���������], [��������], [��������], [����], [�������], [��������� �������], [���� ������], [�����], [������������� ��������], [������� ������]) VALUES (6, CAST(0x3F390B00 AS Date), 1, N'������������� �����������', 170.0000, 100.0000, 60.0000, CAST(0xD83A0B00 AS Date), 2000, 6, 2000)
INSERT [�����] ([� ���������], [���� ������� ���������], [��������], [��������], [����], [�������], [��������� �������], [���� ������], [�����], [������������� ��������], [������� ������]) VALUES (7, CAST(0xA9390B00 AS Date), 4, N'������������� �����������', 270.0000, 200.0000, 120.0000, CAST(0xC8390B00 AS Date), 2000, 2, 2000)

INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (1, 2)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (1, 5)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (1, 6)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (2, 3)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (2, 5)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (2, 6)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (3, 3)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (4, 2)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (4, 4)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (4, 5)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (4, 6)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (5, 2)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (5, 3)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (6, 2)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (6, 3)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (6, 5)
INSERT [�����-���������] ([� ���������], [��� ���������]) VALUES (7, 4)

INSERT [������] ([��� ������], [���], [���������� ������], [���], [�����], [�������]) VALUES (1, N'���������� �. �.', N'7800123456', N'456123789789', N'����������� ��.��������� 34-67', N'123456')
INSERT [������] ([��� ������], [���], [���������� ������], [���], [�����], [�������]) VALUES (2, N'�������� �������� ��������', N'7802456321', N'852147639123', N'������ ��.��������� ���� 3-5', N'456123')
INSERT [������] ([��� ������], [���], [���������� ������], [���], [�����], [�������]) VALUES (3, N'������ ������', N'123456789123', N'123456456123', N'�����-��������� ��.������� 26-54', N'123456')
INSERT [������] ([��� ������], [���], [���������� ������], [���], [�����], [�������]) VALUES (4, N'�������������� �. �.', N'7800654132', N'852369471528', N'��������� ��.���������������� 15-27', N'123654')
INSERT [������] ([��� ������], [���], [���������� ������], [���], [�����], [�������]) VALUES (5, N'������� ������� �����������', N'7802564231', N'852369417582', N'��������� ��������� 13-6', N'123456')

INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (1, 1, 1, 20)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (1, 2, 3, 10)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (1, 5, 2, 20)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (2, 1, 3, 10)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (2, 3, 2, 10)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (2, 4, 1, 20)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (3, 1, 2, 10)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (3, 5, 1, 30)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (4, 2, 2, 20)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (4, 4, 3, 10)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (4, 5, 1, 25)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (5, 3, 1, 10)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (5, 4, 2, 5)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (5, 5, 3, 2)
INSERT [�����-������] ([� ���������], [��� ������], [����� �� �������], [�������]) VALUES (6, 5, 1, 100)

INSERT [������] ([� ������], [��������], [���� ����������� ������], [����� ���������], [���� ���������� ������]) VALUES (1, N'�������� ������ ���������', CAST(0x3C390B00 AS Date), N'��������� ��������� 81', CAST(0x8D390B00 AS Date))
INSERT [������] ([� ������], [��������], [���� ����������� ������], [����� ���������], [���� ���������� ������]) VALUES (2, N'����� ��������� ����������', CAST(0x5D390B00 AS Date), N'������ ���� 21 36', CAST(0x7C390B00 AS Date))
INSERT [������] ([� ������], [��������], [���� ����������� ������], [����� ���������], [���� ���������� ������]) VALUES (3, N'�������� ������� ������������', CAST(0x67390B00 AS Date), N'���� �������� 12 45', NULL)
INSERT [������] ([� ������], [��������], [���� ����������� ������], [����� ���������], [���� ���������� ������]) VALUES (4, N'��������� �������� ����������', CAST(0x78390B00 AS Date), N'������� ������������ 38', CAST(0xA9390B00 AS Date))
INSERT [������] ([� ������], [��������], [���� ����������� ������], [����� ���������], [���� ���������� ������]) VALUES (5, N'�������� ���� ���������', CAST(0x77390B00 AS Date), N'�����-��������� 10-� ����� 11', CAST(0xBC390B00 AS Date))
INSERT [������] ([� ������], [��������], [���� ����������� ������], [����� ���������], [���� ���������� ������]) VALUES (6, N'�������� ����� �������', CAST(0x44390B00 AS Date), N'����-��������� ������ 30', NULL)
INSERT [������] ([� ������], [��������], [���� ����������� ������], [����� ���������], [���� ���������� ������]) VALUES (7, N'��������� ����� �������������', CAST(0x96390B00 AS Date), N'������-�� ���� ������� 56 70', CAST(0xB2390B00 AS Date))
INSERT [������] ([� ������], [��������], [���� ����������� ������], [����� ���������], [���� ���������� ������]) VALUES (8, N'�������� ���� ���������', CAST(0xAC390B00 AS Date), N'�����-��������� 10-� ����� 11', NULL)
INSERT [������] ([� ������], [��������], [���� ����������� ������], [����� ���������], [���� ���������� ������]) VALUES (9, N'������� ������� ��������', CAST(0xA5390B00 AS Date), N'������� ��������� 24 45', NULL)
INSERT [������] ([� ������], [��������], [���� ����������� ������], [����� ���������], [���� ���������� ������]) VALUES (10, N'�������� ������� ������������', CAST(0x86390B00 AS Date), N'���� �������� 12 45', CAST(0xBC390B00 AS Date))
INSERT [������] ([� ������], [��������], [���� ����������� ������], [����� ���������], [���� ���������� ������]) VALUES (11, N'����� ��������� ����������', CAST(0x91390B00 AS Date), N'������ ���� 21 36', CAST(0xC6390B00 AS Date))
INSERT [������] ([� ������], [��������], [���� ����������� ������], [����� ���������], [���� ���������� ������]) VALUES (12, N'�������� ������� ������������', CAST(0xAA390B00 AS Date), N'���� �������� 12 45', CAST(0xC8390B00 AS Date))

INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (2, 1, 1500)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (9, 1, 1000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (1, 2, 2000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (4, 2, 2000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (6, 2, 1000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (9, 2, 2000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (3, 3, 2000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (4, 3, 5000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (7, 3, 2000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (9, 3, 3000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (12, 3, 3000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (2, 4, 2500)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (5, 4, 3000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (9, 4, 4000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (11, 4, 1000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (1, 5, 1000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (8, 5, 1000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (10, 5, 2000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (11, 5, 2000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (1, 6, 1000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (5, 6, 4500)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (7, 6, 5000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (11, 6, 3000)
INSERT [������-������] ([� ������], [� ���������], [����������]) VALUES (11, 7, 2000)

