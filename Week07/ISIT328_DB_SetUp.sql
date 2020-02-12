

PRINT '~~ISIT328 :: Starting the  DB Setup'

----------------------------------------
-- CREATE A NEW DATABASE
----------------------------------------
USE master
GO
IF EXISTS(select * from sys.databases where name= 'ISIT328' )
	BEGIN
		PRINT '~~ISIT328 :: Droping the old DB'
		DROP DATABASE ISIT328
	END


CREATE DATABASE [ISIT328]
 CONTAINMENT = NONE
 return;

 -- Make this DB compatible to SQL Server 2012 through SQL Server 2016
 -- more info on this link --> https://msdn.microsoft.com/en-us/library/bb510680.aspx
ALTER DATABASE [ISIT328] SET COMPATIBILITY_LEVEL = 110
GO

---------------------------------------
-- CREATE THE LOGIN
---------------------------------------
IF EXISTS (SELECT name FROM master.sys.server_principals WHERE name = 'ISIT328_user')
	BEGIN
		PRINT '~~ISIT328 :: Droping the old login'
		DROP LOGIN [ISIT328_user]
	END
GO

CREATE LOGIN [ISIT328_user] WITH PASSWORD='abc123', DEFAULT_DATABASE=[ISIT328], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


PRINT '~~ISIT328 :: Creating the tables'
-----------------------------------
-- CREATE THE PERSON TABLE
------------------------------------
USE [ISIT328]
GO

/****** Object:  Table [dbo].[Person]    Script Date: 11/10/2019 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Person](
	[FName] [varchar](50) NOT NULL,
	[LName] [varchar](50) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[phone] [varchar](50) NOT NULL,
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Person_email_MUST_BE_UNIQUE] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Person_MUST_BE_UNIQUE] UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'~~~ No repeated UserName allowed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'CONSTRAINT',@level2name=N'IX_Person_MUST_BE_UNIQUE'
GO


-----------------------------------
-- CREATE THE BLOG TABLE
------------------------------------

/****** Object:  Table [dbo].[Blog]    Script Date: 11/11/2019 9:00:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Blog](
	[Title] [varchar](50) NULL,
	[Body] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


------------------------------------
-- CREATE THE USER
------------------------------------
USE [ISIT328]
GO

IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = 'ISIT328_user')
	BEGIN
		PRINT '~~ISIT328:: Droping the old user'
		DROP USER [ISIT328_user]
	END
	

CREATE USER [ISIT328_user] FOR LOGIN [ISIT328_user] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ISIT328_user]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ISIT328_user]
GO



print 'Inserting some data .... SATART'
INSERT INTO [dbo].[Person]([FName],[LName],[email],[phone],[UserName],[Password])
     VALUES
	 ('Poe', 'Dameron', 'pd@pd.com', '206 12345', 'pdameron', 'admin'),
	 ('Darth', 'Maul', 'dm@pd.com', '206 12345', 'dmaul', '123456'),
	 ('General', 'Grievous', 'gg@pd.com', '206 12345', 'ggrievous', 'letmein'),
	 ('Luke', 'Skywalker', 'lk@pd.com', '206 12345', 'lkywalker', 'qwerty'),
	 ('Admiral', 'Ackbar', 'aa@pd.com', '206 12345', 'aackbar', 'password'),
	 ('Count', 'Dooku', 'cd@pd.com', '206 12345', 'cdooku', '111111'),
	 ('General', 'Hux', 'gh@pd.com', '206 12345', 'ghux', 'sunshine'),
	 ('Kylo', 'Ren', 'kren@pd.com', '206 12345', 'kren', 'iloveyou'),
	 ('Darth', 'Vader', 'vader@pd.com', '206 12345', 'dvader', 'princess')

INSERT INTO [dbo].[Blog]([Title],[Body])
     VALUES('Summer Vacation','We went to Mexico and had fun at the beach'),
	 ('School Homework','It was very challenging, yet I enjoyed it')

PRINT ''
PRINT '~~ISIT328 :: Finished the DB Setup'