CREATE TABLE [dbo].[NinjaEquipment]
(
	[Ninja_Id] INT NOT NULL , 
    [Equipment_Id] INT NOT NULL, 
    PRIMARY KEY ([Equipment_Id], [Ninja_Id]), 
    CONSTRAINT [FK_Ninja] FOREIGN KEY ([Ninja_Id]) REFERENCES [Ninja]([Id]), 
    CONSTRAINT [FK_Equipment] FOREIGN KEY ([Equipment_Id]) REFERENCES [Equipment]([Id])
)
