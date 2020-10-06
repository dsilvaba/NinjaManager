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
PRINT N'Dropping [dbo].[FK_Category]...';


GO
ALTER TABLE [dbo].[Equipment] DROP CONSTRAINT [FK_Category];


GO
PRINT N'Dropping [dbo].[FK_Equipment]...';


GO
ALTER TABLE [dbo].[NinjaEquipment] DROP CONSTRAINT [FK_Equipment];


GO
PRINT N'Dropping [dbo].[FK_Ninja]...';


GO
ALTER TABLE [dbo].[NinjaEquipment] DROP CONSTRAINT [FK_Ninja];


GO
PRINT N'Starting rebuilding table [dbo].[Equipment]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Equipment] (
    [Id]           INT        IDENTITY (1, 1) NOT NULL,
    [Name]         NCHAR (10) NULL,
    [Price]        INT        NULL,
    [Strength]     INT        NULL,
    [Agility]      INT        NULL,
    [Intelligence] INT        NULL,
    [Category]     NCHAR (10) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Equipment])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Equipment] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Equipment] ([Id], [Name], [Price], [Strength], [Agility], [Intelligence], [Category])
        SELECT   [Id],
                 [Name],
                 [Price],
                 [Strength],
                 [Agility],
                 [Intelligence],
                 [Category]
        FROM     [dbo].[Equipment]
        ORDER BY [Id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Equipment] OFF;
    END

DROP TABLE [dbo].[Equipment];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Equipment]', N'Equipment';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [dbo].[Ninja]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Ninja] (
    [Id]   INT        IDENTITY (1, 1) NOT NULL,
    [Name] NCHAR (10) NULL,
    [Gold] INT        NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
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

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[FK_Category]...';


GO
ALTER TABLE [dbo].[Equipment] WITH NOCHECK
    ADD CONSTRAINT [FK_Category] FOREIGN KEY ([Category]) REFERENCES [dbo].[Category] ([CategoryName]);


GO
PRINT N'Creating [dbo].[FK_Equipment]...';


GO
ALTER TABLE [dbo].[NinjaEquipment] WITH NOCHECK
    ADD CONSTRAINT [FK_Equipment] FOREIGN KEY ([Equipment_Id]) REFERENCES [dbo].[Equipment] ([Id]);


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

ALTER TABLE [dbo].[NinjaEquipment] WITH CHECK CHECK CONSTRAINT [FK_Equipment];

ALTER TABLE [dbo].[NinjaEquipment] WITH CHECK CHECK CONSTRAINT [FK_Ninja];


GO
PRINT N'Update complete.';


GO
