/*
CREATE DATABASE Statistic
ON PRIMARY (
	NAME = stuTJ,
	FILENAME = 'C:\MSSQL\stuTJ.mdf',
	SIZE = 100,
	FILEGROWTH = 50
)
LOG ON(
	NAME = stuTJ_log,
	FILENAME = 'C:\MSSQL\stuTJ_log.ldf',
	SIZE = 150,
	FILEGROWTH = 50
);
GO

USE Statistic;
GO

BEGIN TRAN;

CREATE SCHEMA Info
	AUTHORIZATION dbo;
GO
	
--Campus -> Grade -> Class -> Student

CREATE TABLE [Info].[Campus]
(
	ID	int IDENTITY NOT NULL PRIMARY KEY,
	Name	nvarchar(100)	NOT NULL,
	Remark	nvarchar(1000)	NULL
);
GO
INSERT INTO [Info].[Campus]([Name])VALUES('本部'),('科丰'),('张仪');
GO

CREATE TABLE [Info].[Grade]
(
	ID int IDENTITY NOT NULL PRIMARY KEY,
	CampusID int NOT NULL REFERENCES [Info].[Campus](ID),
	Name nvarchar(10) NOT NULL DEFAULT '高一',
	Remark nvarchar(1000) NULL
);
GO

INSERT INTO [Info].[Grade]([CampusID],[Name]) VALUES(1, '高一'),(1, '高二'),(1, '高三'),(1, '初一'),(1, '初二'),(1, '初三');
GO

CREATE TABLE [Info].[CourseClass]
(
	ID	int IDENTITY NOT NULL PRIMARY KEY,
	Name	nvarchar(100)	NOT NULL,
	Remark	nvarchar(1000)	NULL
);
GO

--INSERT INTO [Info].[CourseClass]([Name])VALUES('社团'),('体育'),('科技'),('艺术'),('选修课'),('学科竞赛');
GO


CREATE TABLE [dbo].[StuInfo](
	[LoginID] [varchar](10) NOT NULL PRIMAYR KEY,
	[Pwd] [varchar](20) NOT NULL DEFAULT ('12345678'),
	[Name] [nvarchar](4) NULL,
	[Class] [varchar](5) NULL ,
	[Grade] [int] NULL REFERENCES [Info].[Grade](ID),
	[AlreadyApp] [bit] NULL DEFAULT ((0)),
	[Other] [nvarchar](100) NULL,
	[Roles] [varchar](100) NULL CONSTRAINT [dfRole]  DEFAULT ('stus'),
	[CampusID] int NOT NULL REFERENCES [Info].[Campus] (ID)
);
GO

INSERT INTO dbo.StuInfo([LoginID], [Pwd], [Roles],[CampusID])
	VALUES('admin', 'admin', 'admins', 1);
GO

CREATE TABLE TeacherInfo
(
	ID		int IDENTITY PRIMARY KEY NOT NULL,
	Name	nvarchar(5)	NOT NULL,
	Subject tinyint NULL
);
GO
INSERT INTO TeacherInfo(Name) VALUES('李志新');
GO

CREATE TABLE Course
(
	ID	int IDENTITY PRIMARY KEY NOT NULL,
	Name nvarchar(1000) NOT NULL,
	CourseClassID	int NOT NULL REFERENCES [Info].[CourseClass](ID),
	TeacherID int	NOT NULL  FOREIGN KEY REFERENCES TeacherInfo(ID),
	CampusID	int NOT NULL  REFERENCES [Info].[CampusID](ID) ,
	Brief	nvarchar(1000) NULL,
	Site	nvarchar(10) NULL,
	Count	tinyint NULL,
	Other	nvarchar(1000) NULL,
);
GO
ALTER TABLE Course
	ADD CONSTRAINT dfTeacherID DEFAULT 1 FOR TeacherID;
GO

ALTER TABLE Course
	ADD CONSTRAINT dfCampusID DEFAULT 1 FOR CampusID;
	

CREATE TABLE StuCourse
(
	ID int IDENTITY  PRIMARY KEY NOT NULL,
	StuID varchar(10) REFERENCES StuInfo(loginID),
	CourseID int REFERENCES Course(id),
	dt datetime NULL DEFAULT getdate()
);
GO

--The Grade info from Campus
CREATE Table GradeInCampus
(
	ID int NOT NULL IDENTITY  PRIMARY KEY,
	GradeID int REFERENCES [info].[Grade] (ID),
	CampusID int REFERENCES [info].[Campus](ID)
);
GO

COMMIT TRAN;

*/




