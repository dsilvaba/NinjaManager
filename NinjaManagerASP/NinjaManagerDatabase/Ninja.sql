CREATE TABLE [dbo].[Ninja]
(
	[Id] INT NOT NULL  IDENTITY, 
    [Name] NCHAR(10) NOT NULL, 
    [Gold] INT NOT NULL, 
    CONSTRAINT [PK_Ninja] PRIMARY KEY ([Id]) 
)
