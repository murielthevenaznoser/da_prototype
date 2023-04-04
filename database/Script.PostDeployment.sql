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
insert into dbo.categories
(
    [id],
    [name],
	[primaryEffect],
    [secondaryEffect]
) 
values
    ('00000000-0000-0000-0000-000000000001', N'AINS salycilé', N'Effet primaire', N'Si réaction retardée, éviction de tous les AINS de type salicylé'),
    ('00000000-0000-0000-0000-000000000002', N'AINS', N'Si réaction allergique immédiate, éviction de tous les AINS', N'Effet retardé')
;

insert into dbo.medications 
(
    [id],
    [name],
	[component],
	[categoryId]
) 
values
    ('00000000-0000-0000-0000-000000000001', N'Alcacyl, Tabletten', N'acidum acetylsalicylicum', '00000000-0000-0000-0000-000000000001'),
    ('00000000-0000-0000-0000-000000000002', N'Lebewohl, Hühneraugenpflaster', N'acidum salicylicum', '00000000-0000-0000-0000-000000000001'),
    ('00000000-0000-0000-0000-000000000003', N'Mobilat, Salbe', N'acidum salicylicum', '00000000-0000-0000-0000-000000000001'),
    ('00000000-0000-0000-0000-000000000004', N'Alcacyl, Tabletten', N'acidum acetylsalicylicum', '00000000-0000-0000-0000-000000000002'),
    ('00000000-0000-0000-0000-000000000005', N'Celecoxib Xiromed 200 mg, Hartkapseln', N'celecoxibum', '00000000-0000-0000-0000-000000000002')
;
