﻿/*
Deployment script for NinjaManagerASP

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "NinjaManagerASP"
:setvar DefaultFilePrefix "NinjaManagerASP"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column Agility on table [dbo].[Equipment] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column Category on table [dbo].[Equipment] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column Intelligence on table [dbo].[Equipment] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column Name on table [dbo].[Equipment] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column Price on table [dbo].[Equipment] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column Strength on table [dbo].[Equipment] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [dbo].[Equipment])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
/*
The column Gold on table [dbo].[Ninja] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column Name on table [dbo].[Ninja] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [dbo].[Ninja])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Dropping [dbo].[FK_Category]...';


GO
ALTER TABLE [dbo].[Equipment] DROP CONSTRAINT [FK_Category];


GO
PRINT N'Dropping [dbo].[FK_Ninja]...';


GO
ALTER TABLE [dbo].[NinjaEquipment] DROP CONSTRAINT [FK_Ninja];


GO
PRINT N'Altering [dbo].[Equipment]...';


GO
ALTER TABLE [dbo].[Equipment] ALTER COLUMN [Agility] INT NOT NULL;

ALTER TABLE [dbo].[Equipment] ALTER COLUMN [Category] NCHAR (10) NOT NULL;

ALTER TABLE [dbo].[Equipment] ALTER COLUMN [Intelligence] INT NOT NULL;

ALTER TABLE [dbo].[Equipment] ALTER COLUMN [Name] NCHAR (10) NOT NULL;

ALTER TABLE [dbo].[Equipment] ALTER COLUMN [Price] INT NOT NULL;

ALTER TABLE [dbo].[Equipment] ALTER COLUMN [Strength] INT NOT NULL;


GO
PRINT N'Starting rebuilding table [dbo].[Ninja]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Ninja] (
    [Id]   INT        IDENTITY (1, 1) NOT NULL,
    [Name] NCHAR (10) NOT NULL,
    [Gold] INT        NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_Ninja1] PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Ninja])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Ninja] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Ninja] ([Id], [Name], [Gold])
        SELECT   [Id],
                 [Name],
                 [Gold]
        FROM     [dbo].[Ninja]
        ORDER BY [Id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Ninja] OFF;
    END

DROP TABLE [dbo].[Ninja];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Ninja]', N'Ninja';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_Ninja1]', N'PK_Ninja', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[FK_Category]...';


GO
ALTER TABLE [dbo].[Equipment] WITH NOCHECK
    ADD CONSTRAINT [FK_Category] FOREIGN KEY ([Category]) REFERENCES [dbo].[Category] ([CategoryName]);


GO
PRINT N'Creating [dbo].[FK_Ninja]...';


GO
ALTER TABLE [dbo].[NinjaEquipment] WITH NOCHECK
    ADD CONSTRAINT [FK_Ninja] FOREIGN KEY ([Ninja_Id]) REFERENCES [dbo].[Ninja] ([Id]);


GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Equipment] WITH CHECK CHECK CONSTRAINT [FK_Category];

ALTER TABLE [dbo].[NinjaEquipment] WITH CHECK CHECK CONSTRAINT [FK_Ninja];


GO
PRINT N'Update complete.';


GO
