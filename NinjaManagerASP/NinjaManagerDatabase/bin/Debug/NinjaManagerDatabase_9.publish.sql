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
PRINT N'Starting rebuilding table [dbo].[Category]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Category] (
    [CategoryName] NCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([CategoryName] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Category])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Category] ([CategoryName])
        SELECT   [CategoryName]
        FROM     [dbo].[Category]
        ORDER BY [CategoryName] ASC;
    END

DROP TABLE [dbo].[Category];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Category]', N'Category';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Altering [dbo].[Equipment]...';


GO
ALTER TABLE [dbo].[Equipment] ALTER COLUMN [Category] NCHAR (50) NOT NULL;

ALTER TABLE [dbo].[Equipment] ALTER COLUMN [Name] NCHAR (50) NOT NULL;


GO
PRINT N'Altering [dbo].[Ninja]...';


GO
ALTER TABLE [dbo].[Ninja] ALTER COLUMN [Name] NCHAR (50) NOT NULL;


GO
PRINT N'Creating [dbo].[FK_Category]...';


GO
ALTER TABLE [dbo].[Equipment] WITH NOCHECK
    ADD CONSTRAINT [FK_Category] FOREIGN KEY ([Category]) REFERENCES [dbo].[Category] ([CategoryName]);


GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Equipment] WITH CHECK CHECK CONSTRAINT [FK_Category];


GO
PRINT N'Update complete.';


GO