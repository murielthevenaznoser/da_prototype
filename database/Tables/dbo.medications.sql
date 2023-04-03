CREATE TABLE [dbo].[medications]
(
	[id] [uniqueidentifier] NOT NULL,
	[name] [nvarchar](1000) NOT NULL,
	[component] [nvarchar](1000) NOT NULL,
	[categoryId] [uniqueidentifier] NOT NULL,
	PRIMARY KEY (id),
    FOREIGN KEY (categoryId) REFERENCES categories(id)
) 
GO
