CREATE TABLE [dbo].[medications]
(
	[id] [uniqueidentifier] NOT NULL,
	[title] [nvarchar](1000) NOT NULL,	
	[completed] [bit] NOT NULL,
	[owner_id] [varchar](128) NOT NULL,
	[position] INT NULL
) 
GO
ALTER TABLE [dbo].[medications] ADD PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)
GO
ALTER TABLE [dbo].[medications] ADD DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[medications] ADD  DEFAULT ((0)) FOR [completed]
GO
ALTER TABLE [dbo].[medications] ADD  DEFAULT ('public') FOR [owner_id]
GO
