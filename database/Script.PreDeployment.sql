if (exists(select * from sys.columns where object_id = object_id('dbo.medications') and [name] = 'order'))
begin
    select * into #medications_order from dbo.medications;
    truncate table dbo.medications;
end
if (exists(select * from sys.columns where object_id = object_id('dbo.categories') and [name] = 'order'))
begin
    select * into #categories_order from dbo.categories;
    truncate table dbo.categories;
end
