CREATE TABLE [dbo].[Ninja]
(
	[Id] INT NOT NULL  IDENTITY, 
    [Name] NCHAR(50) NOT NULL, 
    [Gold] INT NOT NULL, 
    CONSTRAINT [PK_Ninja] PRIMARY KEY ([Id]) 
)
