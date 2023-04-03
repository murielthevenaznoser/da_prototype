if (exists(select * from sys.columns where object_id = object_id('dbo.medications')))
begin
    truncate table dbo.medications;
end
if (exists(select * from sys.columns where object_id = object_id('dbo.categories'))
begin
    truncate table dbo.categories;
end
