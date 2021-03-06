/**********************************************************************/
/* OLENAKEDB_DEV_INSTALL.SQL                                          */
/*                                                                    */
/* Creates the OLenakeDB_DEV database and installs its objects.       */
/* 									                                  */
/*																	  */
/* Copyright (c) VisionDream ICT Solutions							  */
/* All Rights Reserved.												  */
/*																	  */
/**********************************************************************/

SET NOCOUNT ON
GO

DECLARE		@StartTime	NVARCHAR(99)
SELECT		@StartTime = CONVERT(NVARCHAR, GETDATE(), 121)

PRINT '-----------------------------------------------------------'
PRINT 'Starting execution of ''OLENAKEDB_DEV_INSTALL.SQL'' script.'
PRINT 'Started at: ' + @StartTime
PRINT '-----------------------------------------------------------'
PRINT ''
GO

USE	[master]
GO

SET NOCOUNT ON

DECLARE		@DBName_New	SYSNAME
SELECT		@DBName_New = QUOTENAME(N'OLenakeDB_DEV')

/**************************************************************/
/*                                                            */
/*      D  A  T  A  B  A  S  E    C  R  E  A  T  I  O  N      */
/*                                                            */
/**************************************************************/

/****** Object:  Database [OLenakeDB_DEV]    Script Date: 2020/07/28 01:24:48 ******/
IF (NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE (name = N'OLenakeDB_DEV')))
BEGIN
    PRINT 'Database ''' + @DBName_New + ''' does not exist.'
	PRINT 'Creating database ''' + @DBName_New + '''...'

	CREATE DATABASE [OLenakeDB_DEV]
	COLLATE SQL_Latin1_General_CP1_CI_AS

	USE [OLenakeDB_DEV]
END
ELSE
BEGIN
	PRINT 'Database ''' + @DBName_New + ''' already exists.'
	PRINT 'Skipping database ''' + @DBName_New + ''' creation...'
	PRINT ''

	USE [OLenakeDB_DEV]
END
GO

IF EXISTS (SELECT OBJECT_ID FROM sys.triggers WHERE (name = N'ddlDatabaseTriggerLog_OLenakeDB_DEV') AND type = N'TR')
	DISABLE TRIGGER [ddlDatabaseTriggerLog_OLenakeDB_DEV] ON DATABASE

/****** Object:  Table [dbo].[DatabaseLog]    Script Date: 2020/08/07 21:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[DatabaseLog]','U') IS NULL)
BEGIN
	PRINT 'Dropping table [dbo].[DatabaseLog].'
	DROP TABLE [dbo].[DatabaseLog]
END
GO

PRINT 'Creating table [dbo].[DatabaseLog]...';
PRINT ''
GO

CREATE TABLE [dbo].[DatabaseLog]
(
	[DatabaseLogId]		[BIGINT] IDENTITY(1, 1) NOT NULL,
	[CreatedDate]		[DATETIME] NOT NULL DEFAULT GETDATE(),
	[DatabaseUser]		[SYSNAME] NOT NULL,
	[Event]				[SYSNAME] NOT NULL,
	[Schema]			[SYSNAME] NULL,
	[Object]			[SYSNAME] NULL,
	[TSQL]				[NVARCHAR](MAX) NOT NULL,
	[XmlEvent]			[XML] NOT NULL,
	CONSTRAINT [PK_DatabaseLog_DatabaseLogID] PRIMARY KEY NONCLUSTERED 
	(
		[DatabaseLogId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Trigger [ddlDatabaseTriggerLog_OLenakeDB_DEV]    Script Date: 2020/08/07 21:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT OBJECT_ID FROM sys.triggers WHERE (name = N'ddlDatabaseTriggerLog_OLenakeDB_DEV') AND type = N'TR')
BEGIN
	PRINT 'Dropping database trigger [ddlDatabaseTriggerLog_OLenakeDB_DEV].'
    DROP TRIGGER [ddlDatabaseTriggerLog_OLenakeDB_DEV] ON DATABASE
END
GO

PRINT 'Creating database trigger [ddlDatabaseTriggerLog_OLenakeDB_DEV]...';
GO

CREATE TRIGGER [ddlDatabaseTriggerLog_OLenakeDB_DEV] ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS AS 
BEGIN
    SET NOCOUNT ON;

    DECLARE @data XML;
    DECLARE @schema SYSNAME;
    DECLARE @object SYSNAME;
    DECLARE @eventType SYSNAME;

    SET @data = EVENTDATA();
    SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)[1]', 'SYSNAME');
    SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'SYSNAME');
    SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'SYSNAME') 

    IF @object IS NOT NULL
        PRINT '  ' + @eventType + ' - ' + @schema + '.' + @object;
    ELSE
        PRINT '  ' + @eventType + ' - ' + @schema;

    IF @eventType IS NULL
        PRINT CONVERT(NVARCHAR(MAX), @data);

    INSERT [dbo].[DatabaseLog] 
    (
		[CreatedDate], 
		[DatabaseUser], 
		[Event], 
		[Schema], 
		[Object], 
		[TSQL], 
		[XmlEvent]
    ) 
    VALUES 
    (
		GETDATE(), 
		CONVERT(SYSNAME, CURRENT_USER), 
		@eventType, 
		CONVERT(SYSNAME, @schema), 
		CONVERT(SYSNAME, @object), 
		@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)'), 
		@data
    );
END;
GO

ENABLE TRIGGER [ddlDatabaseTriggerLog_OLenakeDB_DEV] ON DATABASE
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Database trigger to audit all of the DDL changes made to the OLenakeDB_DEV 2019 database.' , @level0type=N'TRIGGER',@level0name=N'ddlDatabaseTriggerLog_OLenakeDB_DEV'
GO

/**********************************************************************/
/* User-Defined Data Types create steps                               */
/**********************************************************************/
PRINT ''
PRINT 'User-Defined Data Types create steps.'
PRINT 'Starting User-Defined Data Types create steps...'
GO

--IF NOT EXISTS(SELECT 0 FROM sys.types t 
--              WHERE t.name = N'AggregationType' AND t.schema_id = SCHEMA_ID(N'sysutility_ucp_core'))
--BEGIN
--  RAISERROR ('Creating type [sysutility_ucp_core].[AggregationType]', 0, 1) WITH NOWAIT;
--  CREATE TYPE [sysutility_ucp_core].[AggregationType] FROM TINYINT
--END
--GO

--IF NOT EXISTS (SELECT * FROM sys.types where name = 'syspolicy_target_filters_type')
--BEGIN
--    PRINT 'Creating type [dbo].[syspolicy_target_filters_type]...'
--    CREATE TYPE [dbo].[syspolicy_target_filters_type]
--    AS
--    TABLE (
--        target_filter_id int,
--        policy_id int,
--        type sysname NOT NULL,
--        filter nvarchar(max) NOT NULL,
--        type_skeleton sysname NOT NULL
--        )
--END
--GO

--IF EXISTS (SELECT * FROM sys.types WHERE name = N'ByteVarBinaryMax')
--BEGIN
--	PRINT 'Dropping type [dbo].[ByteVarBinaryMax].'
--    DROP TYPE [dbo].[ByteVarBinaryMax]
--	CREATE TYPE [dbo].[ByteVarBinaryMax] FROM VARBINARY(MAX) NULL
--END
--GO

--DROP TYPE [dbo].[ByteVarBinaryMax]
--DROP TYPE [dbo].[Content]
--DROP TYPE [dbo].[FilePath]
--DROP TYPE [dbo].[BigText]
--DROP TYPE [dbo].[LongText]
--DROP TYPE [dbo].[ShortText]
--DROP TYPE [dbo].[Description]
--DROP TYPE [dbo].[AddressLines]
--DROP TYPE [dbo].[Name]
--DROP TYPE [dbo].[ShortName]
--DROP TYPE [dbo].[OrderNumber]
--DROP TYPE [dbo].[AccountNumber]
--DROP TYPE [dbo].[NationalIDNumber]
--DROP TYPE [dbo].[ContactNumber]
--DROP TYPE [dbo].[BigCode]
--DROP TYPE [dbo].[LongCode]
--DROP TYPE [dbo].[ShortCode]
--DROP TYPE [dbo].[IntGender]
--DROP TYPE [dbo].[CharFlag]
--DROP TYPE [dbo].[BitFlag]
--DROP TYPE [dbo].[Amount]
--GO

CREATE TYPE [dbo].[ByteVarBinaryMax] FROM VARBINARY(MAX) NULL
GO
CREATE TYPE [dbo].[Content] FROM NVARCHAR(4000) NULL
GO
CREATE TYPE [dbo].[FilePath] FROM NVARCHAR(512) NULL
GO
CREATE TYPE [dbo].[BigText] FROM NVARCHAR(512) NULL
GO
CREATE TYPE [dbo].[LongText] FROM NVARCHAR(256) NULL
GO
CREATE TYPE [dbo].[ShortText] FROM NVARCHAR(128) NULL
GO
CREATE TYPE [dbo].[Description] FROM NVARCHAR(100) NULL
GO
CREATE TYPE [dbo].[AddressLines] FROM NVARCHAR(80) NULL
GO
CREATE TYPE [dbo].[Name] FROM NVARCHAR(50) NULL
GO
CREATE TYPE [dbo].[ShortName] FROM NVARCHAR(25) NULL
GO
CREATE TYPE [dbo].[OrderNumber] FROM NVARCHAR(25) NULL
GO
CREATE TYPE [dbo].[AccountNumber] FROM NVARCHAR(15) NULL
GO
CREATE TYPE [dbo].[NationalIDNumber] FROM NCHAR(13) NULL
GO
CREATE TYPE [dbo].[ContactNumber] FROM NCHAR(10) NULL
GO
CREATE TYPE [dbo].[BigCode] FROM NVARCHAR(10) NOT NULL
GO
CREATE TYPE [dbo].[LongCode] FROM NCHAR(5) NOT NULL
GO
CREATE TYPE [dbo].[ShortCode] FROM NCHAR(3) NOT NULL
GO
CREATE TYPE [dbo].[IntGender] FROM INT NOT NULL
GO
CREATE TYPE [dbo].[CharFlag] FROM NCHAR(1) NOT NULL
GO
CREATE TYPE [dbo].[BitFlag] FROM BIT NOT NULL
GO
CREATE TYPE [dbo].[Amount] FROM MONEY NOT NULL
GO


PRINT 'Completed User-Defined Data Types create steps...'
GO
/**********************************************************************/
/* User-Defined Data Types steps                                      */
/**********************************************************************/

/****** Object:  Function [dbo].[ufnLeadingZeros]    Script Date: 2020/08/07 21:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID(N'[dbo].[ufnLeadingZeros]', 'FN') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping function [dbo].[ufnLeadingZeros].'
    DROP FUNCTION [dbo].[ufnLeadingZeros]
END
GO 

PRINT 'Creating function [dbo].[ufnLeadingZeros]...';
GO

CREATE FUNCTION [dbo].[ufnLeadingZeros]
(
    @Value	INT
) 
RETURNS NVARCHAR(8) 
WITH SCHEMABINDING 
AS 
BEGIN
    DECLARE @ReturnValue NVARCHAR(8);

    SET @ReturnValue = CONVERT(NVARCHAR(8), @Value);
    SET @ReturnValue = REPLICATE('0', 8 - DATALENGTH(@ReturnValue)) + @ReturnValue;

    RETURN (@ReturnValue);
END;
GO

/****** Object:  Table [dbo].[OLBuildVersion]    Script Date: 2020/08/07 21:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[OLBuildVersion]','U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[OLBuildVersion].'
	DROP TABLE [dbo].[OLBuildVersion]
END
GO

PRINT 'Creating table [dbo].[OLBuildVersion]...';
GO

CREATE TABLE [dbo].[OLBuildVersion](
	[SystemInformationId]	[TINYINT] IDENTITY(1, 1) NOT NULL,
	[DatabaseVersion]		[dbo].[ShortName] NOT NULL,
	[VersionDate]			[DATETIME] NOT NULL,
	[CreatedDate]			[DATETIME] NOT NULL DEFAULT (GETDATE()),
	CONSTRAINT [PK_OLBuildVersion_SystemInformationId] PRIMARY KEY CLUSTERED 
	(
		[SystemInformationId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Populate and dump data into table [dbo].[OLBuildVersion] ******/
PRINT 'Inserting into table [dbo].[OLBuildVersion]...';
GO

INSERT INTO [dbo].[OLBuildVersion]
 (DatabaseVersion, VersionDate) VALUES ('15.0.18333.0', CONVERT(DATE, '2019-11-04'))

/****** Object:  Table [dbo].[ErrorLog]    Script Date: 2020/08/07 21:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[ErrorLog]','U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[ErrorLog].'
	DROP TABLE [dbo].[ErrorLog]
END
GO

PRINT 'Creating table [dbo].[ErrorLog]...';
GO

CREATE TABLE [dbo].[ErrorLog]
(
	[ErrorLogId]		[BIGINT] IDENTITY(1,1) NOT NULL,
	[ErrorDate]			[DATETIME] NOT NULL DEFAULT GETDATE(),
	[UserName]			[SYSNAME] NOT NULL,
	[ErrorNumber]		[INT] NOT NULL,
	[ErrorSeverity]		[INT] NULL,
	[ErrorState]		[INT] NULL,
	[ErrorProcedure]	[dbo].[ShortText] NULL,
	[ErrorLine]			[INT] NULL,
	[ErrorMessage]		[dbo].[Content] NOT NULL,
	CONSTRAINT [PK_ErrorLog_ErrorLogId] PRIMARY KEY CLUSTERED 
	(
		[ErrorLogId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Stored Procedure [dbo].[uspPrintError]    Script Date: 2020/08/07 21:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID(N'[dbo].[uspPrintError]', 'P') IS NULL)
BEGIN
	PRINT ''
    PRINT 'Dropping procedure [dbo].[uspPrintError]...'
    DROP PROCEDURE [dbo].[uspPrintError]
END
GO 

PRINT 'Creating procedure [dbo].[uspPrintError]...';
GO

-- uspPrintError prints error information about the error that caused 
-- execution to jump to the CATCH block of a TRY...CATCH construct. 
-- Should be executed from within the scope of a CATCH block otherwise 
-- it will return without printing any error information.
CREATE PROCEDURE [dbo].[uspPrintError] 
AS
BEGIN
    SET NOCOUNT ON;

    -- Print error information. 
    PRINT 'Error ' + CONVERT(VARCHAR(50), ERROR_NUMBER()) + ', ' +
          'Severity ' + CONVERT(VARCHAR(5), ERROR_SEVERITY()) + ', ' +
          'State ' + CONVERT(VARCHAR(5), ERROR_STATE()) + ', ' +
          'Procedure ' + ISNULL(ERROR_PROCEDURE(), '-') + ', ' +
          'Line ' + CONVERT(VARCHAR(5), ERROR_LINE());
    PRINT ERROR_MESSAGE();
END;
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Prints error information about the error that caused execution to jump to the CATCH block of a TRY...CATCH construct. Should be executed from within the scope of a CATCH block otherwise it will return without printing any error information.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'uspPrintError'
GO

/****** Object:  Stored Procedure [dbo].[uspLogError]    Script Date: 2020/08/07 21:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID(N'[dbo].[uspLogError]', 'P') IS NULL)
BEGIN
	PRINT ''
    PRINT 'Dropping procedure [dbo].[uspLogError]...'
    DROP PROCEDURE [dbo].[uspLogError]
END
GO 

PRINT 'Creating procedure [dbo].[uspLogError]...';
GO

-- uspLogError logs error information in the ErrorLog table about the 
-- error that caused execution to jump to the CATCH block of a 
-- TRY...CATCH construct. This should be executed from within the scope 
-- of a CATCH block otherwise it will return without inserting error 
-- information.
CREATE PROCEDURE [dbo].[uspLogError] 
    @ErrorLogID [INT] = 0 OUTPUT -- contains the ErrorLogID of the row inserted
AS                               -- by uspLogError in the ErrorLog table
BEGIN
    SET NOCOUNT ON;

    -- Output parameter value of 0 indicates that error 
    -- information was not logged
    SET @ErrorLogID = 0;

    BEGIN TRY
        -- Return if there is no error information to log
        IF ERROR_NUMBER() IS NULL
            RETURN;

        -- Return if inside an uncommittable transaction.
        -- Data insertion/modification is not allowed when 
        -- a transaction is in an uncommittable state.
        IF XACT_STATE() = -1
        BEGIN
            PRINT 'Cannot log error since the current transaction is in an uncommittable state. ' 
                + 'Rollback the transaction before executing uspLogError in order to successfully log error information.';
            RETURN;
        END

        INSERT [dbo].[ErrorLog] 
            (
				[UserName], 
				[ErrorNumber], 
				[ErrorSeverity], 
				[ErrorState], 
				[ErrorProcedure], 
				[ErrorLine], 
				[ErrorMessage]
            ) 
        VALUES 
            (
				CONVERT(SYSNAME, CURRENT_USER), 
				ERROR_NUMBER(),
				ERROR_SEVERITY(),
				ERROR_STATE(),
				ERROR_PROCEDURE(),
				ERROR_LINE(),
				ERROR_MESSAGE()
            );

        -- Pass back the ErrorLogID of the row inserted
        SET @ErrorLogID = @@IDENTITY;
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred in stored procedure uspLogError: ';
        EXECUTE [dbo].[uspPrintError];
        RETURN -1;
    END CATCH
END;
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logs error information in the ErrorLog table about the error that caused execution to jump to the CATCH block of a TRY...CATCH construct. Should be executed from within the scope of a CATCH block otherwise it will return without inserting error information.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'uspLogError'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Output parameter for the stored procedure uspLogError. Contains the ErrorLogID value corresponding to the row inserted by uspLogError in the ErrorLog table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'uspLogError', @level2type=N'PARAMETER',@level2name=N'@ErrorLogID'
GO

/****** Object:  Table [dbo].[CountryRegion]    Script Date: 2020/08/07 21:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[CountryRegion]', 'U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[CountryRegion].'
	DROP TABLE [dbo].[CountryRegion]
END
GO

PRINT 'Creating table [dbo].[CountryRegion]...';
GO

CREATE TABLE [dbo].[CountryRegion]
(
	[CountryRegionCode]		[dbo].[ShortCode] NOT NULL,
	[Name]					[dbo].[Name] NOT NULL,
	[CreatedDate]			[DATETIME] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_CountryRegion_CountryRegionCode] PRIMARY KEY CLUSTERED 
	(
		[CountryRegionCode] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[StateProvince]    Script Date: 2020/08/07 21:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[StateProvince]','U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[StateProvince].'
	DROP TABLE [dbo].[StateProvince]
END
GO

PRINT 'Creating table [dbo].[StateProvince]...';
GO

CREATE TABLE [dbo].[StateProvince]
(
	[StateProvinceId]		[INT] IDENTITY(1, 1) NOT NULL,
	[StateProvinceCode]		[dbo].[ShortCode] NOT NULL,
	[CountryRegionCode]		[dbo].[ShortCode] NOT NULL,
	[Name]					[dbo].[Name] NOT NULL,
	[CreatedDate]			[DATETIME] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_StateProvince_StateProvinceId] PRIMARY KEY CLUSTERED 
	(
		[StateProvinceId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	CONSTRAINT [FK_StateProvince_CountryRegion_CountryRegionCode] FOREIGN KEY
	(
		[CountryRegionCode]
	)REFERENCES [dbo].[CountryRegion] ([CountryRegionCode])
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[AddressType]    Script Date: 2020/07/28 01:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[AddressType]','U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[AddressType].'
	DROP TABLE [dbo].[AddressType]
END
GO

PRINT 'Creating table [dbo].[AddressType]...';
GO

CREATE TABLE [dbo].[AddressType]
(
	[Id]					[INT] IDENTITY(1, 1) NOT NULL,
	[Name]					[dbo].[Name] NOT NULL,
	[CreatedDate]			[DATETIME] NOT NULL DEFAULT GETDATE(),
 CONSTRAINT [PK_AddressType_AddressTypeId] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Address]    Script Date: 2020/07/28 01:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[Address]','U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[Address].'
	DROP TABLE [dbo].[Address]
END
GO

PRINT 'Creating table [dbo].[Address]...';
GO

CREATE TABLE [dbo].[Address]
(
	[Id]					[INT] IDENTITY(1, 1) NOT NULL,
	[AddressLine1]			[dbo].[AddressLines] NOT NULL,
	[AddressLine2]			[dbo].[AddressLines] NOT NULL,
	[City]					[dbo].[Name] NOT NULL,
	[StateProvinceId]		[INT] NOT NULL,
	[PostalCode]			[dbo].[BigCode] NOT NULL,
	[SpatialLocation]		[GEOGRAPHY] NULL,
	[CreatedDate]			[DATETIME] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	CONSTRAINT [FK_Address_StateProvince_StateProvinceId] FOREIGN KEY
	(
		[StateProvinceId]
	)REFERENCES [dbo].[StateProvince] ([StateProvinceId])
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PersonType]    Script Date: 2020/08/07 21:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[PersonType]', 'U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[PersonType].'
	DROP TABLE [dbo].[PersonType]
END
GO

PRINT 'Creating table [dbo].[PersonType]...';
GO

CREATE TABLE [dbo].[PersonType]
(
	[PersonTypeCode]		[dbo].[ShortCode] NOT NULL,
	[Name]					[dbo].[Name] NOT NULL,
	[CreatedDate]			[DATETIME] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_PersonType_PersonTypeId] PRIMARY KEY CLUSTERED 
	(
		[PersonTypeCode] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ContactType]    Script Date: 2020/08/07 21:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[ContactType]', 'U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[ContactType].'
	DROP TABLE [dbo].[ContactType]
END
GO

PRINT 'Creating table [dbo].[ContactType]...';
GO

CREATE TABLE [dbo].[ContactType]
(
	[Id]					[INT] IDENTITY(1, 1) NOT NULL,
	[Name]					[dbo].[Name] NOT NULL,
	[CreatedDate]			[DATETIME] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_ContactType_ContactTypeId] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Person]    Script Date: 2020/07/28 01:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[Person]','U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[Person].'
	DROP TABLE [dbo].[Person]
END
GO

PRINT 'Creating table [dbo].[Person]...';
GO

CREATE TABLE [dbo].[Person]
(
	[Id]					[INT] IDENTITY(1,1) NOT NULL,
	[PersonTypeCode]		[dbo].[ShortCode] NOT NULL,
	[Title]					[dbo].[BigCode] NOT NULL,
	[Initials]				[dbo].[BigCode] NOT NULL,
	[FirstName]				[dbo].[Name] NOT NULL,
	[Surname]				[dbo].[Name] NOT NULL,
	[BirthDate]				[DATE] NOT NULL,
	[CreatedDate]			[DATETIME] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[EmailAddress]    Script Date: 2020/07/28 01:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[EmailAddress]','U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[EmailAddress].'
	DROP TABLE [dbo].[EmailAddress]
END
GO

PRINT 'Creating table [dbo].[EmailAddress]...';
GO

CREATE TABLE [dbo].[EmailAddress]
(
	[PersonId]				[INT] NOT NULL,
	[EmailAddressId]		[INT] IDENTITY(1, 1) NOT NULL,
	[EmailAddress]			[dbo].[AddressLines] NOT NULL,
	[CreatedDate]			[DATETIME] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_EmailAddress] PRIMARY KEY CLUSTERED 
	(
		[PersonId] ASC,
		[EmailAddressId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	CONSTRAINT [FK_EmailAddress_Person_PersonId] FOREIGN KEY
	(
		[PersonId]
	)REFERENCES [dbo].[Person] ([Id])
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PersonAddress]    Script Date: 2020/07/28 01:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[PersonAddress]','U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[PersonAddress].'
	DROP TABLE [dbo].[PersonAddress]
END
GO

PRINT 'Creating table [dbo].[PersonAddress]...';
GO

CREATE TABLE [dbo].[PersonAddress]
(
	[PersonId]				[INT] NOT NULL,
	[AddressId]				[INT] NOT NULL,
	[AddressTypeId]			[INT] NOT NULL,
	[CreatedDate]			[DATETIME] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_PersonAddress_PersonId_AddressId_AddressTypeId] PRIMARY KEY CLUSTERED 
	(
		[PersonId] ASC,
		[AddressId] ASC,
		[AddressTypeId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	CONSTRAINT [FK_PersonAddress_Person_PersonId] FOREIGN KEY
	(
		[PersonId]
	)REFERENCES [dbo].[Person] ([Id]),
	CONSTRAINT [FK_PersonAddress_Address_AddressId] FOREIGN KEY
	(
		[AddressId]
	)REFERENCES [dbo].[Address] ([Id]),
	CONSTRAINT [FK_PersonAddress_AddressType_AddressTypeId] FOREIGN KEY
	(
		[AddressTypeId]
	)REFERENCES [dbo].[AddressType] ([Id])
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PersonContact]    Script Date: 2020/07/28 01:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[PersonContact]','U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[PersonContact].'
	DROP TABLE [dbo].[PersonContact]
END
GO

PRINT 'Creating table [dbo].[PersonContact]...';
GO

CREATE TABLE [dbo].[PersonContact]
(
	[PersonId]				[INT] NOT NULL,
	[ContactTypeId]			[INT] NOT NULL,
	[CreatedDate]			[DATETIME] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_PersonContact_PersonId_ContactTypeId] PRIMARY KEY CLUSTERED 
	(
		[PersonId] ASC,
		[ContactTypeId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	CONSTRAINT [FK_PersonContact_Person_PersonId] FOREIGN KEY
	(
		[PersonId]
	)REFERENCES [dbo].[Person] ([Id]),
	CONSTRAINT [FK_PersonContact_ContactType_ContactTypeId] FOREIGN KEY
	(
		[ContactTypeId]
	)REFERENCES [dbo].[ContactType] ([Id])
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PhoneNumberType]    Script Date: 2020/07/28 01:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[PhoneNumberType]','U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[PhoneNumberType].'
	DROP TABLE [dbo].[PhoneNumberType]
END
GO

PRINT 'Creating table [dbo].[PhoneNumberType]...';
GO

CREATE TABLE [dbo].[PhoneNumberType]
(
	[Id]					[INT] IDENTITY(1,1) NOT NULL,
	[Name]					[dbo].[Name] NOT NULL,
	[CreatedDate]			[DATETIME] NOT NULL DEFAULT GETDATE(),
 CONSTRAINT [PK_PhoneNumberType_PhoneNumberTypeId] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PersonPhone]    Script Date: 2020/07/28 01:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT OBJECT_ID('[dbo].[PersonPhone]','U') IS NULL)
BEGIN
	PRINT ''
	PRINT 'Dropping table [dbo].[PersonPhone].'
	DROP TABLE [dbo].[PersonPhone]
END
GO

PRINT 'Creating table [dbo].[PersonPhone]...';
GO

CREATE TABLE [dbo].[PersonPhone]
(
	[PersonId]				[INT] NOT NULL,
	[PhoneNumber]			[dbo].[ContactNumber] NOT NULL,
	[PhoneNumberTypeId]		[INT] NOT NULL,
	[CreatedDate]			[DATETIME] NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_PersonPhone_PersonId_PhoneNumber_PhoneNumberTypeId] PRIMARY KEY CLUSTERED 
	(
		[PersonId] ASC,
		[PhoneNumber] ASC,
		[PhoneNumberTypeId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	CONSTRAINT [FK_PersonPhone_Person_PersonId] FOREIGN KEY
	(
		[PersonId]
	)REFERENCES [dbo].[Person] ([Id]),
	CONSTRAINT [FK_PersonPhone_PhoneNumberType_PhoneNumberTypeId] FOREIGN KEY
	(
		[PhoneNumberTypeId]
	)REFERENCES [dbo].[PhoneNumberType] ([Id])
) ON [PRIMARY]
GO


SET NOCOUNT ON
GO

DECLARE	@EndTime	VARCHAR(99)
SELECT	@EndTime = CONVERT(VARCHAR, GETDATE(), 121)

PRINT ''
PRINT '------------------------------------------------------------'
PRINT 'Execution of ''OLENAKEDB_DEV_INSTALL.SQL'' script completed.'
PRINT 'Completed at: ' + @EndTime
PRINT '------------------------------------------------------------'
GO


--DECLARE	@ContactTypeID	AS NVARCHAR(256)
--DECLARE ContactInfo_Cursor CURSOR FOR  

--SELECT ContactTypeID FROM [Person].[ContactType]
--OPEN ContactInfo_Cursor;  
--FETCH NEXT FROM ContactInfo_Cursor INTO @ContactTypeID;  
--WHILE @@FETCH_STATUS = 0  
--   BEGIN
--	  DECLARE @ContactInfo	AS TABLE
--		(
--			[PersonID] int NOT NULL, 
--			[FirstName] [nvarchar](50) NULL, 
--			[LastName] [nvarchar](50) NULL, 
--			[JobTitle] [nvarchar](50) NULL,
--			[BusinessEntityType] [nvarchar](50) NULL
--		)
--	  INSERT INTO @ContactInfo
--	  SELECT * FROM [dbo].[ufnGetContactInformation](@ContactTypeID)

--      Print '   ' + @ContactTypeID + ' . . .  '
--      FETCH NEXT FROM ContactInfo_Cursor INTO @ContactTypeID;
--   END;  
--CLOSE ContactInfo_Cursor;  
--SELECT * FROM @ContactInfo 
--DEALLOCATE ContactInfo_Cursor;  
--GO

