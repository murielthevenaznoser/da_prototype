CREATE TABLE [dbo].[categories]
(
	[id] [uniqueidentifier] NOT NULL,
	[name] [nvarchar](1000) NOT NULL,
	[primaryEffect] [nvarchar](2000) NOT NULL,
	[secondaryEffect] [nvarchar](2000) NOT NULL,
	PRIMARY KEY (id),
)
