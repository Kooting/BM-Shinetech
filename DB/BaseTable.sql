﻿DECLARE @CurrentMigration [nvarchar](max)

IF object_id('[dbo].[__MigrationHistory]') IS NOT NULL
    SELECT @CurrentMigration =
        (SELECT TOP (1) 
        [Project1].[MigrationId] AS [MigrationId]
        FROM ( SELECT 
        [Extent1].[MigrationId] AS [MigrationId]
        FROM [dbo].[__MigrationHistory] AS [Extent1]
        WHERE [Extent1].[ContextKey] = N'BM.DataModel.Migrations.Configuration'
        )  AS [Project1]
        ORDER BY [Project1].[MigrationId] DESC)

IF @CurrentMigration IS NULL
    SET @CurrentMigration = '0'

IF @CurrentMigration < '202003010821193_CreateNewTables'
BEGIN
    CREATE TABLE [dbo].[BookBorrow] (
        [Id] [bigint] NOT NULL IDENTITY,
        [BookId] [bigint] NOT NULL,
        [BorrowUserId] [bigint] NOT NULL,
        [Status] [int] NOT NULL,
        [PlanReturnDate] [datetime] NOT NULL,
        [CreateBy] [nvarchar](256) NOT NULL,
        [CreateDate] [datetime] NOT NULL,
        CONSTRAINT [PK_dbo.BookBorrow] PRIMARY KEY ([Id])
    )
    CREATE TABLE [dbo].[BookCategory] (
        [Id] [bigint] NOT NULL IDENTITY,
        [CategoryName] [nvarchar](max),
        [CreateBy] [nvarchar](256) NOT NULL,
        [CreateDate] [datetime] NOT NULL,
        CONSTRAINT [PK_dbo.BookCategory] PRIMARY KEY ([Id])
    )
    CREATE TABLE [dbo].[BookInfo] (
        [Id] [bigint] NOT NULL IDENTITY,
        [Title] [nvarchar](max),
        [Description] [nvarchar](max),
        [CategoryId] [bigint] NOT NULL,
        [CreateBy] [nvarchar](256) NOT NULL,
        [CreateDate] [datetime] NOT NULL,
        CONSTRAINT [PK_dbo.BookInfo] PRIMARY KEY ([Id])
    )
    CREATE TABLE [dbo].[SysPermission] (
        [Id] [bigint] NOT NULL IDENTITY,
        [PermissionName] [nvarchar](256) NOT NULL,
        [ParentId] [bigint] NOT NULL,
        [CreateBy] [nvarchar](256) NOT NULL,
        [CreateDate] [datetime] NOT NULL,
        CONSTRAINT [PK_dbo.SysPermission] PRIMARY KEY ([Id])
    )
    CREATE TABLE [dbo].[SysRole] (
        [Id] [bigint] NOT NULL IDENTITY,
        [RoleName] [nvarchar](256) NOT NULL,
        [CreateBy] [nvarchar](256) NOT NULL,
        [CreateDate] [datetime] NOT NULL,
        CONSTRAINT [PK_dbo.SysRole] PRIMARY KEY ([Id])
    )
    CREATE TABLE [dbo].[SysRolePermission] (
        [Id] [bigint] NOT NULL IDENTITY,
        [RoleId] [bigint] NOT NULL,
        [CreateBy] [nvarchar](256) NOT NULL,
        [CreateDate] [datetime] NOT NULL,
        [PermissionId] [bigint] NOT NULL,
        CONSTRAINT [PK_dbo.SysRolePermission] PRIMARY KEY ([Id])
    )
    CREATE INDEX [IX_RoleId] ON [dbo].[SysRolePermission]([RoleId])
    CREATE INDEX [IX_PermissionId] ON [dbo].[SysRolePermission]([PermissionId])
    CREATE TABLE [dbo].[SysUser] (
        [Id] [bigint] NOT NULL IDENTITY,
        [UserName] [nvarchar](256) NOT NULL,
        [UserPwd] [nvarchar](256) NOT NULL,
        [RoleId] [bigint] NOT NULL,
        [CreateBy] [nvarchar](256) NOT NULL,
        [CreateDate] [datetime] NOT NULL,
        CONSTRAINT [PK_dbo.SysUser] PRIMARY KEY ([Id])
    )
    ALTER TABLE [dbo].[SysRolePermission] ADD CONSTRAINT [FK_dbo.SysRolePermission_dbo.SysPermission_PermissionId] FOREIGN KEY ([PermissionId]) REFERENCES [dbo].[SysPermission] ([Id]) ON DELETE CASCADE
    ALTER TABLE [dbo].[SysRolePermission] ADD CONSTRAINT [FK_dbo.SysRolePermission_dbo.SysRole_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[SysRole] ([Id]) ON DELETE CASCADE
    CREATE TABLE [dbo].[__MigrationHistory] (
        [MigrationId] [nvarchar](150) NOT NULL,
        [ContextKey] [nvarchar](300) NOT NULL,
        [Model] [varbinary](max) NOT NULL,
        [ProductVersion] [nvarchar](32) NOT NULL,
        CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY ([MigrationId], [ContextKey])
    )
    INSERT [dbo].[__MigrationHistory]([MigrationId], [ContextKey], [Model], [ProductVersion])
    VALUES (N'202003010821193_CreateNewTables', N'BM.DataModel.Migrations.Configuration',  0x1F8B0800000000000400ED5DDB6EDC36107D2FD07F10F4D4168E653B6DD01ABB0992755C188D2FF03A41DF025AA2D742256A2B518E1745BFAC0FFDA4FE4287BAF2A20BA5D5DA595BC8CB9AE49C21876786A4C451FEFBE7DFC99B7BDF33EE7018B901999AFBBB7BA681891D382E594CCD98DEBCF8D97CF3FADB6F26EF1DFFDEF894B77BC9DA812489A6E62DA5CB43CB8AEC5BECA368D777ED3088821BBA6B07BE859CC03AD8DBFBC5DADFB730409880651893CB9850D7C7C91FF0E72C20365ED21879A78183BD282B879A79826A9C211F474B64E3A9F9EE74F708519434348DB79E8BA00F73ECDD98062224A088420F0F3F46784EC3802CE64B2840DED56A89A1DD0DF2229CF5FCB06CAE3B88BD033608AB14CCA1EC38A281DF1170FF6566154B16EF655BB3B01AD8ED3DD897AED8A813DB81D982E08F774118065F4C43567738F342D65434EE6E29B263F0153B050F802EECDF8E318B3D1A87784A704C43042D2EE26BCFB57FC3ABABE00F4CA624F63CBE7FD043A8130AA0E8220C9638A4AB4B7C93F5FAC4310D4B94B364C1428C9349477342E8AB1F4DE30C94A36B0F17D3CF8D7C4E8310FF8A090E11C5CE05A214878461E0C4808A7649173351BBBE360C6662206CB82ED21C0615471CC6CB83CE18171E2297182693C07CE31C8BFDBE0287ED0C370B3188BE5BE540E09410594CE314DD7FC064416FA7E6C14FAF4CE3D8BDC74E5E92217F242E042210A261DC57738F414CACD2795A5D6A06988B205C7572AA5C6874ABBAB9CB0CC4FE6A600EFCD462CEF3A6E809B9093AD193098CD4ACD175E5526FF39C3CC2911DBACB742FB069FE67CEB6EEEAF394FD68BE8A2E70E8BB5194CC88A6330952A347D5E82A4DD412EE37C49E0B14424747F637B2FF3260514F9FF7ACFDC8F81A5DCC388FC3F52D6429409DA13B7791585E3EF0A4442B23081C7E2EB197348D6EDD65FA60605769F6B960F47118F8EC570556DEE8F3150A179842B783B696F3200EED35BDACDF3A234A8E9ED7E079CF30D2372DBA9DCDD1E48DBD3C51106A7148AE6DE16D8D7EC90BE48EDC31BC6C22A668F55D883E7D630A7BB0D42592B0F663FCA8D1C58CF3382B37D37CF1C57978C5CF34646ABBD8A7CF9D1FB29422A3A3D5E81A1FB3B4E10CF46C74F464CE93BB2E9785C4E8C735BA1E6FC11C62DD1A0FEA03F8D9DB280A6C376153DD49573E05881D7C4F1CA3EB9120355AE5461D8C08CEE82EC1FDA0B753F307C5221D1416CF060485F5CAF64DD9A7CFC911F630C5C65B3BBD393043918D1C759EC0BC8E58026100B367972EF266D019082C2EA16ACC7089ED2E91D77148128E66F461FD2C34CA35477889090B1C1DA753A72BE28156ED54A15B326A9B0D2716C7DF1EB44E8E849DE8259E0F374964F1E996A2694BB8CB8FE2B148CBCF994E1FF2C5E901789A066590A12081C3FCC5F0E9D1352BC3F7B462B703AB76B6E189B25544E615C39C635A71B9A85C043236F1950A3F559CF24645255259AD81959ECA2A71D2AA160C29942B40527D3B5AEA565538698D1E425B9FE436EDA8E9AEB70A2BAD6941E0CFC00A085FD98A53DF17AE4E42E188DF602AE5492327A6FB7452F6D61E3B9362C895B3A9C4831E5B115143030F2CD1707D8D9A3257D39AEA72D871411CD67EC20AA842773059BEFB2D026D5137B1D24BAC59C1C4AAB9ED3A3945CB256CF2B9DBAF5989314FAFBECE5ECCBBDF0CF5530CCB8E2A2E8816BD2D34C1710F2DB0540BAAA1A7C76E185176C8BD466CEF3F737CA519BFACD4B87AAE495939D4A9CB23402EC27EE7CB57E53DD58AB537933D8651F96C114FCEB3DC4C37091BECFE31F2505871809E055EEC93FA1D45BD747E679447C8CBBAA0F0B746452CBE461F31BF3DCA63E565FA28F2FD511E4DAED3472D8FC33C5E59DA1549ED1B5FAEA24D2C8947CABE4D61ABB20116F9AFED1DC586672DFFA843D1F4907AF1CDF888F890539827A1666490068392ADD75AECA942D0644EB5E8665893BD34E001B2227D0CE195008F24547467B23C32BE7C64715E5DC362711FDB9BCA8D301A7C6E91DF0CA9E5EB91C2822AD575402D2E3D0A7845E94849915D5594AC39CBE893B10A408F86D5929B2160F91284C7284B47AAE85165A008D60CA54F9F878F64F9434F9946DB156FDAE3B412551B5F4D3C262D93C769EB90B10A408F82D5929B215EF9129AC7284BBB2125B7B064A0A4F0B9B9C22311977BA0DC9BBBF5181AF46D121E4F363D4F36E3897F28EF583BB0D74268F9C6D606F76182F2B85D96EB2B09ACBC2F919B14DA8BF726D2FB9149F6AEA2FD9321CACB8BB489698099EE5C87BDB800D252EC273EB03BFFD39B792E8CB76C708A887B83239A5ED6330FF6F60FA46F8F7C3DDF01B1A2C8F12ADEF5547F0C449CB107B87378ED2E5C66DAD68B859D3FA3C17F8A23D732C0B7387A42891FE3E88350FD290E077ED3213EC541EE5068DFA250BD54B8F68D41CD3EF6FBD2C693616CD54DEE7C52BEF3D1FDF73C629F2F596CD90CAB1BEA6D9E5D218361AD69ADC852588F264A2642CF10B7C57C6B7894BFCDA4935F080C3C2FF2A7129E256F2A6EF46E3163E4148781E7629B27F9290608312B26D7A25C003E210EBE9F9A7F255287C6C9EF9F53C11DE33C84E3D0A1B167FCFD0418D114407B598917EF60ABCEF9DC4F868F727ED8609C90F2A507C3AD76A0ADF7843EE9CE4F8684CF61ABDEE5ACF9F4393CC6D1078D77E32673E02C583EE7E151524F1BF22AD64D5AEC9B19D8782966F369804F3E4BF5C15344BF428ED5DCD8FB4AD8F5E859A56A96903CA33DF346D317761084AF0398FA34F86E2AAFB44ED7B099A7755A3691975AA56BF0D4D51A259BCC6B6D50D96D6C6DE9AF358A86CD8DAD52327CEE6CB596AF3CB55625467B7A6BDB02D27823563FEFB3939136902AAB93B6FA40A6E89002AB5EDD80B588FB3F6160418CDC4509C1FE8718826D61152ADA30F7C81743A947791369777F8A2982FD3C7A1B52F706D914AA6D0CC3655FD8F984BC189ABCF7AFB17342CE63BA8C290C19FBD79E10FAD9A2DAA43FC9F315FB3C394F9E0C44430C01BAE9B223C9397917BB9E53F4FBB8E2485203C156EBEC08CAE692B2A3E86255209D05441328335FB1C9B8C2FED203B0E89CCCD11DEED33788461FF002D9ABFC064E3D48FB4488669F1CB96811223FCA304A79F81338ECF8F7AFFF07E89237D21A690000 , N'6.4.0')
END

IF @CurrentMigration < '202003010824232_CreateV_SysUser'
BEGIN
    CREATE VIEW [dbo].[V_SysUser] AS 
                        SELECT dbo.SysUser.Id AS Id, 
                        dbo.SysUser.UserName, 
                        ISNULL(dbo.SysRole.RoleName, '') AS RoleName,
                        ISNULL(dbo.SysRole.Id, 0) AS RoleId,
                        dbo.SysUser.CreateBy,
                        dbo.SysUser.CreateDate FROM dbo.SysUser LEFT JOIN dbo.SysRole
                        ON dbo.SysUser.RoleId = dbo.SysRole.Id
                  
    INSERT [dbo].[__MigrationHistory]([MigrationId], [ContextKey], [Model], [ProductVersion])
    VALUES (N'202003010824232_CreateV_SysUser', N'BM.DataModel.Migrations.Configuration',  0x1F8B0800000000000400ED5DDB6EDC36107D2FD07F10F4D4168E653B6DD01ABB0992755C188D2FF03A41DF025AA2D742256A2B518E1745BFAC0FFDA4FE4287BAF2A20BA5D5DA595BC8CB9AE49C21876786A4C451FEFBE7DFC99B7BDF33EE7018B901999AFBBB7BA681891D382E594CCD98DEBCF8D97CF3FADB6F26EF1DFFDEF894B77BC9DA812489A6E62DA5CB43CB8AEC5BECA368D777ED3088821BBA6B07BE859CC03AD8DBFBC5DADFB730409880651893CB9850D7C7C91FF0E72C20365ED21879A78183BD282B879A79826A9C211F474B64E3A9F9EE74F708519434348DB79E8BA00F73ECDD98062224A088420F0F3F46784EC3802CE64B2840DED56A89A1DD0DF2229CF5FCB06CAE3B88BD033608AB14CCA1EC38A281DF1170FF6566154B16EF655BB3B01AD8ED3DD897AED8A813DB81D982E08F774118065F4C43567738F342D65434EE6E29B263F0153B050F802EECDF8E318B3D1A87784A704C43042D2EE26BCFB57FC3ABABE00F4CA624F63CBE7FD043A8130AA0E8220C9638A4AB4B7C93F5FAC4310D4B94B364C1428C9349477342E8AB1F4DE30C94A36B0F17D3CF8D7C4E8310FF8A090E11C5CE05A214878461E0C4808A7649173351BBBE360C6662206CB82ED21C0615471CC6CB83CE18171E2297182693C07CE31C8BFDBE0287ED0C370B3188BE5BE540E09410594CE314DD7FC064416FA7E6C14FAF4CE3D8BDC74E5E92217F242E042210A261DC57738F414CACD2795A5D6A06988B205C7572AA5C6874ABBAB9CB0CC4FE6A600EFCD462CEF3A6E809B9093AD193098CD4ACD175E5526FF39C3CC2911DBACB742FB069FE67CEB6EEEAF394FD68BE8A2E70E8BB5194CC88A6330952A347D5E82A4DD412EE37C49E0B14424747F637B2FF3260514F9FF7ACFDC8F81A5DCC388FC3F52D6429409DA13B7791585E3EF0A4442B23081C7E2EB197348D6EDD65FA60605769F6B960F47118F8EC570556DEE8F3150A179842B783B696F3200EED35BDACDF3A234A8E9ED7E079CF30D2372DBA9DCDD1E48DBD3C51106A7148AE6DE16D8D7EC90BE48EDC31BC6C22A668F55D883E7D630A7BB0D42592B0F663FCA8D1C58CF3382B37D37CF1C57978C5CF34646ABBD8A7CF9D1FB29422A3A3D5E81A1FB3B4E10CF46C74F464CE93BB2E9785C4E8C735BA1E6FC11C62DD1A0FEA03F8D9DB280A6C376153DD49573E05881D7C4F1CA3EB9120355AE5461D8C08CEE82EC1FDA0B753F307C5221D1416CF060485F5CAF64DD9A7CFC911F630C5C65B3BBD393043918D1C759EC0BC8E58026100B367972EF266D019082C2EA16ACC7089ED2E91D77148128E66F461FD2C34CA35477889090B1C1DA753A72BE28156ED54A15B326A9B0D2716C7DF1EB44E8E849DE8259E0F374964F1E996A2694BB8CB8FE2B148CBCF994E1FF2C5E901789A066590A12081C3FCC5F0E9D1352BC3F7B462B703AB76B6E189B25544E615C39C635A71B9A85C043236F1950A3F559CF24645255259AD81959ECA2A71D2AA160C29942B40527D3B5AEA565538698D1E425B9FE436EDA8E9AEB70A2BAD6941E0CFC00A085FD98A53DF17AE4E42E188DF602AE5492327A6FB7452F6D61E3B9362C895B3A9C4831E5B115143030F2CD1707D8D9A3257D39AEA72D871411CD67EC20AA842773059BEFB2D026D5137B1D24BAC59C1C4AAB9ED3A3945CB256CF2B9DBAF5989314FAFBECE5ECCBBDF0CF5530CCB8E2A2E8816BD2D34C1710F2DB0540BAAA1A7C76E185176C8BD466CEF3F737CA519BFACD4B87AAE495939D4A9CB23402EC27EE7CB57E53DD58AB537933D8651F96C114FCEB3DC4C37091BECFE31F2505871809E055EEC93FA1D45BD747E679447C8CBBAA0F0B746452CBE461F31BF3DCA63E565FA28F2FD511E4DAED3472D8FC33C5E59DA1549ED1B5FAEA24D2C8947CABE4D61ABB20116F9AFED1DC586672DFFA843D1F4907AF1CDF888F890539827A1666490068392ADD75AECA942D0644EB5E8665893BD34E001B2227D0CE195008F24547467B23C32BE7C64715E5DC362711FDB9BCA8D301A7C6E91DF0CA9E5EB91C2822AD575402D2E3D0A7845E94849915D5594AC39CBE893B10A408F86D5929B2160F91284C7284B47AAE85165A008D60CA54F9F878F64F9434F9946DB156FDAE3B412551B5F4D3C262D93C769EB90B10A408F82D5929B215EF9129AC7284BBB2125B7B064A0A4F0B9B9C22311977BA0DC9BBBF5181AF46D121E4F363D4F36E3897F28EF583BB0D74268F9C6D606F76182F2B85D96EB2B09ACBC2F919B14DA8BF726D2FB9149F6AEA2FD9321CACB8BB489698099EE5C87BDB800D252EC273EB03BFFD39B792E8CB76C708A887B83239A5ED6330FF6F60FA46F8F7C3DDF01B1A2C8F12ADEF5547F0C449CB107B87378ED2E5C66DAD68B859D3FA3C17F8A23D732C0B7387A42891FE3E88350FD290E077ED3213EC541EE5068DFA250BD54B8F68D41CD3EF6FBD2C693616CD54DEE7C52BEF3D1FDF73C629F2F596CD90CAB1BEA6D9E5D218361AD69ADC852588F264A2642CF10B7C57C6B7894BFCDA4935F080C3C2FF2A7129E256F2A6EF46E3163E4148781E7629B27F9290608312B26D7A25C003E210EBE9F9A7F255287C6C9EF9F53C11DE33C84E3D0A1B167FCFD0418D114407B598917EF60ABCEF9DC4F868F727ED8609C90F2A507C3AD76A0ADF7843EE9CE4F8684CF61ABDEE5ACF9F4393CC6D1078D77E32673E02C583EE7E151524F1BF22AD64D5AEC9B19D8782966F369804F3E4BF5C15344BF428ED5DCD8FB4AD8F5E859A56A96903CA33DF346D317761084AF0398FA34F86E2AAFB44ED7B099A7755A3691975AA56BF0D4D51A259BCC6B6D50D96D6C6DE9AF358A86CD8DAD52327CEE6CB596AF3CB55625467B7A6BDB02D27823563FEFB3939136902AAB93B6FA40A6E89002AB5EDD80B588FB3F6160418CDC4509C1FE8718826D61152ADA30F7C81743A947791369777F8A2982FD3C7A1B52F706D914AA6D0CC3655FD8F984BC189ABCF7AFB17342CE63BA8C290C19FBD79E10FAD9A2DAA43FC9F315FB3C394F9E0C44430C01BAE9B223C9397917BB9E53F4FBB8E2485203C156EBEC08CAE692B2A3E86255209D05441328335FB1C9B8C2FED203B0E89CCCD11DEED33788461FF002D9ABFC064E3D48FB4488669F1CB96811223FCA304A79F81338ECF8F7AFFF07E89237D21A690000 , N'6.4.0')
END

IF @CurrentMigration < '202003010825131_CreateV_BookInfo'
BEGIN
    CREATE VIEW [dbo].[V_BookInfo] AS 
                        SELECT dbo.BookInfo.Id AS Id, 
                        dbo.BookInfo.Title, 
    					dbo.BookInfo.Description,
                        ISNULL(dbo.BookCategory.CategoryName, '') AS CategoryName,
                        ISNULL(dbo.BookCategory.Id, 0) AS CategoryId,
                        dbo.BookInfo.CreateBy,
                        dbo.BookInfo.CreateDate FROM dbo.BookInfo LEFT JOIN dbo.BookCategory
                        ON dbo.BookInfo.CategoryId = dbo.BookCategory.Id
    INSERT [dbo].[__MigrationHistory]([MigrationId], [ContextKey], [Model], [ProductVersion])
    VALUES (N'202003010825131_CreateV_BookInfo', N'BM.DataModel.Migrations.Configuration',  0x1F8B0800000000000400ED5DDB6EDC36107D2FD07F10F4D4168E653B6DD01ABB0992755C188D2FF03A41DF025AA2D742256A2B518E1745BFAC0FFDA4FE4287BAF2A20BA5D5DA595BC8CB9AE49C21876786A4C451FEFBE7DFC99B7BDF33EE7018B901999AFBBB7BA681891D382E594CCD98DEBCF8D97CF3FADB6F26EF1DFFDEF894B77BC9DA812489A6E62DA5CB43CB8AEC5BECA368D777ED3088821BBA6B07BE859CC03AD8DBFBC5DADFB730409880651893CB9850D7C7C91FF0E72C20365ED21879A78183BD282B879A79826A9C211F474B64E3A9F9EE74F708519434348DB79E8BA00F73ECDD98062224A088420F0F3F46784EC3802CE64B2840DED56A89A1DD0DF2229CF5FCB06CAE3B88BD033608AB14CCA1EC38A281DF1170FF6566154B16EF655BB3B01AD8ED3DD897AED8A813DB81D982E08F774118065F4C43567738F342D65434EE6E29B263F0153B050F802EECDF8E318B3D1A87784A704C43042D2EE26BCFB57FC3ABABE00F4CA624F63CBE7FD043A8130AA0E8220C9638A4AB4B7C93F5FAC4310D4B94B364C1428C9349477342E8AB1F4DE30C94A36B0F17D3CF8D7C4E8310FF8A090E11C5CE05A214878461E0C4808A7649173351BBBE360C6662206CB82ED21C0615471CC6CB83CE18171E2297182693C07CE31C8BFDBE0287ED0C370B3188BE5BE540E09410594CE314DD7FC064416FA7E6C14FAF4CE3D8BDC74E5E92217F242E042210A261DC57738F414CACD2795A5D6A06988B205C7572AA5C6874ABBAB9CB0CC4FE6A600EFCD462CEF3A6E809B9093AD193098CD4ACD175E5526FF39C3CC2911DBACB742FB069FE67CEB6EEEAF394FD68BE8A2E70E8BB5194CC88A6330952A347D5E82A4DD412EE37C49E0B14424747F637B2FF3260514F9FF7ACFDC8F81A5DCC388FC3F52D6429409DA13B7791585E3EF0A4442B23081C7E2EB197348D6EDD65FA60605769F6B960F47118F8EC570556DEE8F3150A179842B783B696F3200EED35BDACDF3A234A8E9ED7E079CF30D2372DBA9DCDD1E48DBD3C51106A7148AE6DE16D8D7EC90BE48EDC31BC6C22A668F55D883E7D630A7BB0D42592B0F663FCA8D1C58CF3382B37D37CF1C57978C5CF34646ABBD8A7CF9D1FB29422A3A3D5E81A1FB3B4E10CF46C74F464CE93BB2E9785C4E8C735BA1E6FC11C62DD1A0FEA03F8D9DB280A6C376153DD49573E05881D7C4F1CA3EB9120355AE5461D8C08CEE82EC1FDA0B753F307C5221D1416CF060485F5CAF64DD9A7CFC911F630C5C65B3BBD393043918D1C759EC0BC8E58026100B367972EF266D019082C2EA16ACC7089ED2E91D77148128E66F461FD2C34CA35477889090B1C1DA753A72BE28156ED54A15B326A9B0D2716C7DF1EB44E8E849DE8259E0F374964F1E996A2694BB8CB8FE2B148CBCF994E1FF2C5E901789A066590A12081C3FCC5F0E9D1352BC3F7B462B703AB76B6E189B25544E615C39C635A71B9A85C043236F1950A3F559CF24645255259AD81959ECA2A71D2AA160C29942B40527D3B5AEA565538698D1E425B9FE436EDA8E9AEB70A2BAD6941E0CFC00A085FD98A53DF17AE4E42E188DF602AE5492327A6FB7452F6D61E3B9362C895B3A9C4831E5B115143030F2CD1707D8D9A3257D39AEA72D871411CD67EC20AA842773059BEFB2D026D5137B1D24BAC59C1C4AAB9ED3A3945CB256CF2B9DBAF5989314FAFBECE5ECCBBDF0CF5530CCB8E2A2E8816BD2D34C1710F2DB0540BAAA1A7C76E185176C8BD466CEF3F737CA519BFACD4B87AAE495939D4A9CB23402EC27EE7CB57E53DD58AB537933D8651F96C114FCEB3DC4C37091BECFE31F2505871809E055EEC93FA1D45BD747E679447C8CBBAA0F0B746452CBE461F31BF3DCA63E565FA28F2FD511E4DAED3472D8FC33C5E59DA1549ED1B5FAEA24D2C8947CABE4D61ABB20116F9AFED1DC586672DFFA843D1F4907AF1CDF888F890539827A1666490068392ADD75AECA942D0644EB5E8665893BD34E001B2227D0CE195008F24547467B23C32BE7C64715E5DC362711FDB9BCA8D301A7C6E91DF0CA9E5EB91C2822AD575402D2E3D0A7845E94849915D5594AC39CBE893B10A408F86D5929B2160F91284C7284B47AAE85165A008D60CA54F9F878F64F9434F9946DB156FDAE3B412551B5F4D3C262D93C769EB90B10A408F82D5929B215EF9129AC7284BBB2125B7B064A0A4F0B9B9C22311977BA0DC9BBBF5181AF46D121E4F363D4F36E3897F28EF583BB0D74268F9C6D606F76182F2B85D96EB2B09ACBC2F919B14DA8BF726D2FB9149F6AEA2FD9321CACB8BB489698099EE5C87BDB800D252EC273EB03BFFD39B792E8CB76C708A887B83239A5ED6330FF6F60FA46F8F7C3DDF01B1A2C8F12ADEF5547F0C449CB107B87378ED2E5C66DAD68B859D3FA3C17F8A23D732C0B7387A42891FE3E88350FD290E077ED3213EC541EE5068DFA250BD54B8F68D41CD3EF6FBD2C693616CD54DEE7C52BEF3D1FDF73C629F2F596CD90CAB1BEA6D9E5D218361AD69ADC852588F264A2642CF10B7C57C6B7894BFCDA4935F080C3C2FF2A7129E256F2A6EF46E3163E4148781E7629B27F9290608312B26D7A25C003E210EBE9F9A7F255287C6C9EF9F53C11DE33C84E3D0A1B167FCFD0418D114407B598917EF60ABCEF9DC4F868F727ED8609C90F2A507C3AD76A0ADF7843EE9CE4F8684CF61ABDEE5ACF9F4393CC6D1078D77E32673E02C583EE7E151524F1BF22AD64D5AEC9B19D8782966F369804F3E4BF5C15344BF428ED5DCD8FB4AD8F5E859A56A96903CA33DF346D317761084AF0398FA34F86E2AAFB44ED7B099A7755A3691975AA56BF0D4D51A259BCC6B6D50D96D6C6DE9AF358A86CD8DAD52327CEE6CB596AF3CB55625467B7A6BDB02D27823563FEFB3939136902AAB93B6FA40A6E89002AB5EDD80B588FB3F6160418CDC4509C1FE8718826D61152ADA30F7C81743A947791369777F8A2982FD3C7A1B52F706D914AA6D0CC3655FD8F984BC189ABCF7AFB17342CE63BA8C290C19FBD79E10FAD9A2DAA43FC9F315FB3C394F9E0C44430C01BAE9B223C9397917BB9E53F4FBB8E2485203C156EBEC08CAE692B2A3E86255209D05441328335FB1C9B8C2FED203B0E89CCCD11DEED33788461FF002D9ABFC064E3D48FB4488669F1CB96811223FCA304A79F81338ECF8F7AFFF07E89237D21A690000 , N'6.4.0')
END

