CREATE TABLE [dbo].[Equipment]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NCHAR(10) NOT NULL, 
    [Price] INT NOT NULL, 
    [Strength] INT NOT NULL, 
    [Agility] INT NOT NULL, 
    [Intelligence] INT NOT NULL, 
    [Category] NCHAR(10) NOT NULL, 
    CONSTRAINT [FK_Category] FOREIGN KEY ([Category]) REFERENCES [Category]([CategoryName])
)
