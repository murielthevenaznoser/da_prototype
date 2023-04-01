-- Create application user 
if (serverproperty('Edition') = 'SQL Azure') begin

    if not exists (select * from sys.database_principals where [type] in ('E', 'S') and [name] = 'app_dab_user')
    begin 
        create user [app_dab_user] with password = 'rANd0m_PAzzw0rd!'        
    end

    alter role db_owner add member [app_dab_user]
    
end else begin

    if not exists (select * from sys.server_principals where [type] in ('E', 'S') and [name] = 'app_dab_user')
    begin 
        create login [app_dab_user] with password = 'rANd0m_PAzzw0rd!'
    end    

    if not exists (select * from sys.database_principals where [type] in ('E', 'S') and [name] = 'app_dab_user')
    begin
        create user [app_dab_user] from login [app_dab_user]            
    end

    alter role db_owner add member [app_dab_user]
end

-- Insert sample data
delete from dbo.medications where id in
(
    '00000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000003',
    '00000000-0000-0000-0000-000000000004',
    '00000000-0000-0000-0000-000000000005'
);
insert into dbo.medications 
(
    [id],
    [title],
	[completed],
	[owner_id],
	[position]
) 
values
    ('00000000-0000-0000-0000-000000000001', N'Hello world', 0, 'public', 1),
    ('00000000-0000-0000-0000-000000000002', N'This is done', 1, 'public', 2),
    ('00000000-0000-0000-0000-000000000003', N'And this is not done (yet!)', 0, 'public', 4),
    ('00000000-0000-0000-0000-000000000004', N'This is a ☆☆☆☆☆ tool!', 0, 'public', 3),
    ('00000000-0000-0000-0000-000000000005', N'Add support for sorting', 1, 'public', 5)
;

if (object_id('tempdb..#medications_order') is not null)
begin    
    update
        t
    set
        t.position = s.[order]
    from
        dbo.medications t
    inner join
        #medications_order s on t.id = s.id
    ;
    drop table #medications_order;
end

delete from dbo.categories where id in
(
    '00000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000003'
);
insert into dbo.categories
(
    [id],
    [title],
	[position]
) 
values
    ('00000000-0000-0000-0000-000000000001', N'Hello world', 1),
    ('00000000-0000-0000-0000-000000000002', N'This is done', 2),
    ('00000000-0000-0000-0000-000000000003', N'And this is not done (yet!)', 3),
;

if (object_id('tempdb..#categories_order') is not null)
begin    
    update
        t
    set
        t.position = s.[order]
    from
        dbo.categories t
    inner join
        #categories_order s on t.id = s.id
    ;
    drop table #categories_order;
end
