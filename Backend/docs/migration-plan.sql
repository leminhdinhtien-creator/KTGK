IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpEditions] (
        [Id] int NOT NULL IDENTITY,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [DeleterUserId] bigint NULL,
        [DeletionTime] datetime2 NULL,
        [DisplayName] nvarchar(64) NOT NULL,
        [IsDeleted] bit NOT NULL,
        [LastModificationTime] datetime2 NULL,
        [LastModifierUserId] bigint NULL,
        [Name] nvarchar(32) NOT NULL,
        CONSTRAINT [PK_AbpEditions] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpAuditLogs] (
        [Id] bigint NOT NULL IDENTITY,
        [BrowserInfo] nvarchar(256) NULL,
        [ClientIpAddress] nvarchar(64) NULL,
        [ClientName] nvarchar(128) NULL,
        [CustomData] nvarchar(2000) NULL,
        [Exception] nvarchar(2000) NULL,
        [ExecutionDuration] int NOT NULL,
        [ExecutionTime] datetime2 NOT NULL,
        [ImpersonatorTenantId] int NULL,
        [ImpersonatorUserId] bigint NULL,
        [MethodName] nvarchar(256) NULL,
        [Parameters] nvarchar(1024) NULL,
        [ServiceName] nvarchar(256) NULL,
        [TenantId] int NULL,
        [UserId] bigint NULL,
        CONSTRAINT [PK_AbpAuditLogs] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpUserAccounts] (
        [Id] bigint NOT NULL IDENTITY,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [DeleterUserId] bigint NULL,
        [DeletionTime] datetime2 NULL,
        [EmailAddress] nvarchar(450) NULL,
        [IsDeleted] bit NOT NULL,
        [LastLoginTime] datetime2 NULL,
        [LastModificationTime] datetime2 NULL,
        [LastModifierUserId] bigint NULL,
        [TenantId] int NULL,
        [UserId] bigint NOT NULL,
        [UserLinkId] bigint NULL,
        [UserName] nvarchar(450) NULL,
        CONSTRAINT [PK_AbpUserAccounts] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpUserLoginAttempts] (
        [Id] bigint NOT NULL IDENTITY,
        [BrowserInfo] nvarchar(256) NULL,
        [ClientIpAddress] nvarchar(64) NULL,
        [ClientName] nvarchar(128) NULL,
        [CreationTime] datetime2 NOT NULL,
        [Result] tinyint NOT NULL,
        [TenancyName] nvarchar(64) NULL,
        [TenantId] int NULL,
        [UserId] bigint NULL,
        [UserNameOrEmailAddress] nvarchar(255) NULL,
        CONSTRAINT [PK_AbpUserLoginAttempts] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpUserOrganizationUnits] (
        [Id] bigint NOT NULL IDENTITY,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [OrganizationUnitId] bigint NOT NULL,
        [TenantId] int NULL,
        [UserId] bigint NOT NULL,
        CONSTRAINT [PK_AbpUserOrganizationUnits] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpBackgroundJobs] (
        [Id] bigint NOT NULL IDENTITY,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [IsAbandoned] bit NOT NULL,
        [JobArgs] nvarchar(max) NOT NULL,
        [JobType] nvarchar(512) NOT NULL,
        [LastTryTime] datetime2 NULL,
        [NextTryTime] datetime2 NOT NULL,
        [Priority] tinyint NOT NULL,
        [TryCount] smallint NOT NULL,
        CONSTRAINT [PK_AbpBackgroundJobs] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpLanguages] (
        [Id] int NOT NULL IDENTITY,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [DeleterUserId] bigint NULL,
        [DeletionTime] datetime2 NULL,
        [DisplayName] nvarchar(64) NOT NULL,
        [Icon] nvarchar(128) NULL,
        [IsDeleted] bit NOT NULL,
        [LastModificationTime] datetime2 NULL,
        [LastModifierUserId] bigint NULL,
        [Name] nvarchar(10) NOT NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpLanguages] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpLanguageTexts] (
        [Id] bigint NOT NULL IDENTITY,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [Key] nvarchar(256) NOT NULL,
        [LanguageName] nvarchar(10) NOT NULL,
        [LastModificationTime] datetime2 NULL,
        [LastModifierUserId] bigint NULL,
        [Source] nvarchar(128) NOT NULL,
        [TenantId] int NULL,
        [Value] nvarchar(max) NOT NULL,
        CONSTRAINT [PK_AbpLanguageTexts] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpNotifications] (
        [Id] uniqueidentifier NOT NULL,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [Data] nvarchar(max) NULL,
        [DataTypeName] nvarchar(512) NULL,
        [EntityId] nvarchar(96) NULL,
        [EntityTypeAssemblyQualifiedName] nvarchar(512) NULL,
        [EntityTypeName] nvarchar(250) NULL,
        [ExcludedUserIds] nvarchar(max) NULL,
        [NotificationName] nvarchar(96) NOT NULL,
        [Severity] tinyint NOT NULL,
        [TenantIds] nvarchar(max) NULL,
        [UserIds] nvarchar(max) NULL,
        CONSTRAINT [PK_AbpNotifications] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpNotificationSubscriptions] (
        [Id] uniqueidentifier NOT NULL,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [EntityId] nvarchar(96) NULL,
        [EntityTypeAssemblyQualifiedName] nvarchar(512) NULL,
        [EntityTypeName] nvarchar(250) NULL,
        [NotificationName] nvarchar(96) NULL,
        [TenantId] int NULL,
        [UserId] bigint NOT NULL,
        CONSTRAINT [PK_AbpNotificationSubscriptions] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpTenantNotifications] (
        [Id] uniqueidentifier NOT NULL,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [Data] nvarchar(max) NULL,
        [DataTypeName] nvarchar(512) NULL,
        [EntityId] nvarchar(96) NULL,
        [EntityTypeAssemblyQualifiedName] nvarchar(512) NULL,
        [EntityTypeName] nvarchar(250) NULL,
        [NotificationName] nvarchar(96) NOT NULL,
        [Severity] tinyint NOT NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpTenantNotifications] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpUserNotifications] (
        [Id] uniqueidentifier NOT NULL,
        [CreationTime] datetime2 NOT NULL,
        [State] int NOT NULL,
        [TenantId] int NULL,
        [TenantNotificationId] uniqueidentifier NOT NULL,
        [UserId] bigint NOT NULL,
        CONSTRAINT [PK_AbpUserNotifications] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpOrganizationUnits] (
        [Id] bigint NOT NULL IDENTITY,
        [Code] nvarchar(95) NOT NULL,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [DeleterUserId] bigint NULL,
        [DeletionTime] datetime2 NULL,
        [DisplayName] nvarchar(128) NOT NULL,
        [IsDeleted] bit NOT NULL,
        [LastModificationTime] datetime2 NULL,
        [LastModifierUserId] bigint NULL,
        [ParentId] bigint NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpOrganizationUnits] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpOrganizationUnits_AbpOrganizationUnits_ParentId] FOREIGN KEY ([ParentId]) REFERENCES [AbpOrganizationUnits] ([Id]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpUsers] (
        [Id] bigint NOT NULL IDENTITY,
        [AccessFailedCount] int NOT NULL,
        [AuthenticationSource] nvarchar(64) NULL,
        [ConcurrencyStamp] nvarchar(max) NULL,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [DeleterUserId] bigint NULL,
        [DeletionTime] datetime2 NULL,
        [EmailAddress] nvarchar(256) NOT NULL,
        [EmailConfirmationCode] nvarchar(328) NULL,
        [IsActive] bit NOT NULL,
        [IsDeleted] bit NOT NULL,
        [IsEmailConfirmed] bit NOT NULL,
        [IsLockoutEnabled] bit NOT NULL,
        [IsPhoneNumberConfirmed] bit NOT NULL,
        [IsTwoFactorEnabled] bit NOT NULL,
        [LastLoginTime] datetime2 NULL,
        [LastModificationTime] datetime2 NULL,
        [LastModifierUserId] bigint NULL,
        [LockoutEndDateUtc] datetime2 NULL,
        [Name] nvarchar(32) NOT NULL,
        [NormalizedEmailAddress] nvarchar(256) NOT NULL,
        [NormalizedUserName] nvarchar(32) NOT NULL,
        [Password] nvarchar(128) NOT NULL,
        [PasswordResetCode] nvarchar(328) NULL,
        [PhoneNumber] nvarchar(max) NULL,
        [SecurityStamp] nvarchar(max) NULL,
        [Surname] nvarchar(32) NOT NULL,
        [TenantId] int NULL,
        [UserName] nvarchar(32) NOT NULL,
        CONSTRAINT [PK_AbpUsers] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpUsers_AbpUsers_CreatorUserId] FOREIGN KEY ([CreatorUserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_AbpUsers_AbpUsers_DeleterUserId] FOREIGN KEY ([DeleterUserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_AbpUsers_AbpUsers_LastModifierUserId] FOREIGN KEY ([LastModifierUserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpFeatures] (
        [Id] bigint NOT NULL IDENTITY,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [Discriminator] nvarchar(max) NOT NULL,
        [Name] nvarchar(128) NOT NULL,
        [Value] nvarchar(2000) NOT NULL,
        [EditionId] int NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpFeatures] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpFeatures_AbpEditions_EditionId] FOREIGN KEY ([EditionId]) REFERENCES [AbpEditions] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpUserClaims] (
        [Id] bigint NOT NULL IDENTITY,
        [ClaimType] nvarchar(450) NULL,
        [ClaimValue] nvarchar(max) NULL,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [TenantId] int NULL,
        [UserId] bigint NOT NULL,
        CONSTRAINT [PK_AbpUserClaims] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpUserClaims_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpUserLogins] (
        [Id] bigint NOT NULL IDENTITY,
        [LoginProvider] nvarchar(128) NOT NULL,
        [ProviderKey] nvarchar(256) NOT NULL,
        [TenantId] int NULL,
        [UserId] bigint NOT NULL,
        CONSTRAINT [PK_AbpUserLogins] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpUserLogins_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpUserRoles] (
        [Id] bigint NOT NULL IDENTITY,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [RoleId] int NOT NULL,
        [TenantId] int NULL,
        [UserId] bigint NOT NULL,
        CONSTRAINT [PK_AbpUserRoles] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpUserRoles_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpUserTokens] (
        [Id] bigint NOT NULL IDENTITY,
        [LoginProvider] nvarchar(max) NULL,
        [Name] nvarchar(max) NULL,
        [TenantId] int NULL,
        [UserId] bigint NOT NULL,
        [Value] nvarchar(max) NULL,
        CONSTRAINT [PK_AbpUserTokens] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpUserTokens_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpSettings] (
        [Id] bigint NOT NULL IDENTITY,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [LastModificationTime] datetime2 NULL,
        [LastModifierUserId] bigint NULL,
        [Name] nvarchar(256) NOT NULL,
        [TenantId] int NULL,
        [UserId] bigint NULL,
        [Value] nvarchar(2000) NULL,
        CONSTRAINT [PK_AbpSettings] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpSettings_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpRoles] (
        [Id] int NOT NULL IDENTITY,
        [ConcurrencyStamp] nvarchar(max) NULL,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [DeleterUserId] bigint NULL,
        [DeletionTime] datetime2 NULL,
        [DisplayName] nvarchar(64) NOT NULL,
        [IsDefault] bit NOT NULL,
        [IsDeleted] bit NOT NULL,
        [IsStatic] bit NOT NULL,
        [LastModificationTime] datetime2 NULL,
        [LastModifierUserId] bigint NULL,
        [Name] nvarchar(32) NOT NULL,
        [NormalizedName] nvarchar(32) NOT NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpRoles] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpRoles_AbpUsers_CreatorUserId] FOREIGN KEY ([CreatorUserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_AbpRoles_AbpUsers_DeleterUserId] FOREIGN KEY ([DeleterUserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_AbpRoles_AbpUsers_LastModifierUserId] FOREIGN KEY ([LastModifierUserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpTenants] (
        [Id] int NOT NULL IDENTITY,
        [ConnectionString] nvarchar(1024) NULL,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [DeleterUserId] bigint NULL,
        [DeletionTime] datetime2 NULL,
        [EditionId] int NULL,
        [IsActive] bit NOT NULL,
        [IsDeleted] bit NOT NULL,
        [LastModificationTime] datetime2 NULL,
        [LastModifierUserId] bigint NULL,
        [Name] nvarchar(128) NOT NULL,
        [TenancyName] nvarchar(64) NOT NULL,
        CONSTRAINT [PK_AbpTenants] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpTenants_AbpUsers_CreatorUserId] FOREIGN KEY ([CreatorUserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_AbpTenants_AbpUsers_DeleterUserId] FOREIGN KEY ([DeleterUserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_AbpTenants_AbpEditions_EditionId] FOREIGN KEY ([EditionId]) REFERENCES [AbpEditions] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_AbpTenants_AbpUsers_LastModifierUserId] FOREIGN KEY ([LastModifierUserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpPermissions] (
        [Id] bigint NOT NULL IDENTITY,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [Discriminator] nvarchar(max) NOT NULL,
        [IsGranted] bit NOT NULL,
        [Name] nvarchar(128) NOT NULL,
        [TenantId] int NULL,
        [RoleId] int NULL,
        [UserId] bigint NULL,
        CONSTRAINT [PK_AbpPermissions] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpPermissions_AbpRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AbpRoles] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_AbpPermissions_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE TABLE [AbpRoleClaims] (
        [Id] bigint NOT NULL IDENTITY,
        [ClaimType] nvarchar(450) NULL,
        [ClaimValue] nvarchar(max) NULL,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [RoleId] int NOT NULL,
        [TenantId] int NULL,
        [UserId] int NULL,
        CONSTRAINT [PK_AbpRoleClaims] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpRoleClaims_AbpRoles_UserId] FOREIGN KEY ([UserId]) REFERENCES [AbpRoles] ([Id]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpFeatures_EditionId_Name] ON [AbpFeatures] ([EditionId], [Name]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpFeatures_TenantId_Name] ON [AbpFeatures] ([TenantId], [Name]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpAuditLogs_TenantId_ExecutionDuration] ON [AbpAuditLogs] ([TenantId], [ExecutionDuration]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpAuditLogs_TenantId_ExecutionTime] ON [AbpAuditLogs] ([TenantId], [ExecutionTime]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpAuditLogs_TenantId_UserId] ON [AbpAuditLogs] ([TenantId], [UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpPermissions_TenantId_Name] ON [AbpPermissions] ([TenantId], [Name]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpPermissions_RoleId] ON [AbpPermissions] ([RoleId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpPermissions_UserId] ON [AbpPermissions] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpRoleClaims_RoleId] ON [AbpRoleClaims] ([RoleId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpRoleClaims_UserId] ON [AbpRoleClaims] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpRoleClaims_TenantId_ClaimType] ON [AbpRoleClaims] ([TenantId], [ClaimType]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserAccounts_EmailAddress] ON [AbpUserAccounts] ([EmailAddress]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserAccounts_UserName] ON [AbpUserAccounts] ([UserName]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserAccounts_TenantId_EmailAddress] ON [AbpUserAccounts] ([TenantId], [EmailAddress]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserAccounts_TenantId_UserId] ON [AbpUserAccounts] ([TenantId], [UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserAccounts_TenantId_UserName] ON [AbpUserAccounts] ([TenantId], [UserName]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserClaims_UserId] ON [AbpUserClaims] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserClaims_TenantId_ClaimType] ON [AbpUserClaims] ([TenantId], [ClaimType]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserLogins_UserId] ON [AbpUserLogins] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserLogins_TenantId_UserId] ON [AbpUserLogins] ([TenantId], [UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserLogins_TenantId_LoginProvider_ProviderKey] ON [AbpUserLogins] ([TenantId], [LoginProvider], [ProviderKey]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserLoginAttempts_UserId_TenantId] ON [AbpUserLoginAttempts] ([UserId], [TenantId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserLoginAttempts_TenancyName_UserNameOrEmailAddress_Result] ON [AbpUserLoginAttempts] ([TenancyName], [UserNameOrEmailAddress], [Result]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserOrganizationUnits_TenantId_OrganizationUnitId] ON [AbpUserOrganizationUnits] ([TenantId], [OrganizationUnitId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserOrganizationUnits_TenantId_UserId] ON [AbpUserOrganizationUnits] ([TenantId], [UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserRoles_UserId] ON [AbpUserRoles] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserRoles_TenantId_RoleId] ON [AbpUserRoles] ([TenantId], [RoleId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserRoles_TenantId_UserId] ON [AbpUserRoles] ([TenantId], [UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserTokens_UserId] ON [AbpUserTokens] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserTokens_TenantId_UserId] ON [AbpUserTokens] ([TenantId], [UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpBackgroundJobs_IsAbandoned_NextTryTime] ON [AbpBackgroundJobs] ([IsAbandoned], [NextTryTime]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpSettings_UserId] ON [AbpSettings] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpSettings_TenantId_Name] ON [AbpSettings] ([TenantId], [Name]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpLanguages_TenantId_Name] ON [AbpLanguages] ([TenantId], [Name]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpLanguageTexts_TenantId_Source_LanguageName_Key] ON [AbpLanguageTexts] ([TenantId], [Source], [LanguageName], [Key]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpNotificationSubscriptions_NotificationName_EntityTypeName_EntityId_UserId] ON [AbpNotificationSubscriptions] ([NotificationName], [EntityTypeName], [EntityId], [UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpNotificationSubscriptions_TenantId_NotificationName_EntityTypeName_EntityId_UserId] ON [AbpNotificationSubscriptions] ([TenantId], [NotificationName], [EntityTypeName], [EntityId], [UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpTenantNotifications_TenantId] ON [AbpTenantNotifications] ([TenantId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUserNotifications_UserId_State_CreationTime] ON [AbpUserNotifications] ([UserId], [State], [CreationTime]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpOrganizationUnits_ParentId] ON [AbpOrganizationUnits] ([ParentId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpOrganizationUnits_TenantId_Code] ON [AbpOrganizationUnits] ([TenantId], [Code]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpRoles_CreatorUserId] ON [AbpRoles] ([CreatorUserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpRoles_DeleterUserId] ON [AbpRoles] ([DeleterUserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpRoles_LastModifierUserId] ON [AbpRoles] ([LastModifierUserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpRoles_TenantId_NormalizedName] ON [AbpRoles] ([TenantId], [NormalizedName]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUsers_CreatorUserId] ON [AbpUsers] ([CreatorUserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUsers_DeleterUserId] ON [AbpUsers] ([DeleterUserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUsers_LastModifierUserId] ON [AbpUsers] ([LastModifierUserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUsers_TenantId_NormalizedEmailAddress] ON [AbpUsers] ([TenantId], [NormalizedEmailAddress]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpUsers_TenantId_NormalizedUserName] ON [AbpUsers] ([TenantId], [NormalizedUserName]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpTenants_CreatorUserId] ON [AbpTenants] ([CreatorUserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpTenants_DeleterUserId] ON [AbpTenants] ([DeleterUserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpTenants_EditionId] ON [AbpTenants] ([EditionId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpTenants_LastModifierUserId] ON [AbpTenants] ([LastModifierUserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    CREATE INDEX [IX_AbpTenants_TenancyName] ON [AbpTenants] ([TenancyName]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170424115119_Initial_Migrations'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20170424115119_Initial_Migrations', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170608053244_Upgraded_To_Abp_2_1_0'
)
BEGIN
    ALTER TABLE [AbpRoleClaims] DROP CONSTRAINT [FK_AbpRoleClaims_AbpRoles_UserId];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170608053244_Upgraded_To_Abp_2_1_0'
)
BEGIN
    DROP INDEX [IX_AbpRoleClaims_UserId] ON [AbpRoleClaims];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170608053244_Upgraded_To_Abp_2_1_0'
)
BEGIN
    DECLARE @var sysname;
    SELECT @var = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpRoleClaims]') AND [c].[name] = N'UserId');
    IF @var IS NOT NULL EXEC(N'ALTER TABLE [AbpRoleClaims] DROP CONSTRAINT [' + @var + '];');
    ALTER TABLE [AbpRoleClaims] DROP COLUMN [UserId];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170608053244_Upgraded_To_Abp_2_1_0'
)
BEGIN
    ALTER TABLE [AbpLanguages] ADD [IsDisabled] bit NOT NULL DEFAULT CAST(0 AS bit);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170608053244_Upgraded_To_Abp_2_1_0'
)
BEGIN
    ALTER TABLE [AbpRoleClaims] ADD CONSTRAINT [FK_AbpRoleClaims_AbpRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AbpRoles] ([Id]) ON DELETE CASCADE;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170608053244_Upgraded_To_Abp_2_1_0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20170608053244_Upgraded_To_Abp_2_1_0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170621153937_Added_Description_And_IsActive_To_Role'
)
BEGIN
    ALTER TABLE [AbpRoles] ADD [Description] nvarchar(max) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170621153937_Added_Description_And_IsActive_To_Role'
)
BEGIN
    ALTER TABLE [AbpRoles] ADD [IsActive] bit NOT NULL DEFAULT CAST(0 AS bit);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170621153937_Added_Description_And_IsActive_To_Role'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20170621153937_Added_Description_And_IsActive_To_Role', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170703134115_Remove_IsActive_From_Role'
)
BEGIN
    DECLARE @var1 sysname;
    SELECT @var1 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpRoles]') AND [c].[name] = N'IsActive');
    IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [AbpRoles] DROP CONSTRAINT [' + @var1 + '];');
    ALTER TABLE [AbpRoles] DROP COLUMN [IsActive];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170703134115_Remove_IsActive_From_Role'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20170703134115_Remove_IsActive_From_Role', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170804083601_Upgraded_To_Abp_v2.2.2'
)
BEGIN
    ALTER TABLE [AbpUserOrganizationUnits] ADD [IsDeleted] bit NOT NULL DEFAULT CAST(0 AS bit);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20170804083601_Upgraded_To_Abp_v2.2.2'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20170804083601_Upgraded_To_Abp_v2.2.2', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    DROP INDEX [IX_AbpUserClaims_TenantId_ClaimType] ON [AbpUserClaims];
    DECLARE @var2 sysname;
    SELECT @var2 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUserClaims]') AND [c].[name] = N'ClaimType');
    IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [AbpUserClaims] DROP CONSTRAINT [' + @var2 + '];');
    ALTER TABLE [AbpUserClaims] ALTER COLUMN [ClaimType] nvarchar(256) NULL;
    CREATE INDEX [IX_AbpUserClaims_TenantId_ClaimType] ON [AbpUserClaims] ([TenantId], [ClaimType]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    DROP INDEX [IX_AbpUserAccounts_TenantId_UserName] ON [AbpUserAccounts];
    DROP INDEX [IX_AbpUserAccounts_UserName] ON [AbpUserAccounts];
    DECLARE @var3 sysname;
    SELECT @var3 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUserAccounts]') AND [c].[name] = N'UserName');
    IF @var3 IS NOT NULL EXEC(N'ALTER TABLE [AbpUserAccounts] DROP CONSTRAINT [' + @var3 + '];');
    ALTER TABLE [AbpUserAccounts] ALTER COLUMN [UserName] nvarchar(32) NULL;
    CREATE INDEX [IX_AbpUserAccounts_TenantId_UserName] ON [AbpUserAccounts] ([TenantId], [UserName]);
    CREATE INDEX [IX_AbpUserAccounts_UserName] ON [AbpUserAccounts] ([UserName]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    DROP INDEX [IX_AbpUserAccounts_EmailAddress] ON [AbpUserAccounts];
    DROP INDEX [IX_AbpUserAccounts_TenantId_EmailAddress] ON [AbpUserAccounts];
    DECLARE @var4 sysname;
    SELECT @var4 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUserAccounts]') AND [c].[name] = N'EmailAddress');
    IF @var4 IS NOT NULL EXEC(N'ALTER TABLE [AbpUserAccounts] DROP CONSTRAINT [' + @var4 + '];');
    ALTER TABLE [AbpUserAccounts] ALTER COLUMN [EmailAddress] nvarchar(256) NULL;
    CREATE INDEX [IX_AbpUserAccounts_EmailAddress] ON [AbpUserAccounts] ([EmailAddress]);
    CREATE INDEX [IX_AbpUserAccounts_TenantId_EmailAddress] ON [AbpUserAccounts] ([TenantId], [EmailAddress]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    DROP INDEX [IX_AbpRoleClaims_TenantId_ClaimType] ON [AbpRoleClaims];
    DECLARE @var5 sysname;
    SELECT @var5 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpRoleClaims]') AND [c].[name] = N'ClaimType');
    IF @var5 IS NOT NULL EXEC(N'ALTER TABLE [AbpRoleClaims] DROP CONSTRAINT [' + @var5 + '];');
    ALTER TABLE [AbpRoleClaims] ALTER COLUMN [ClaimType] nvarchar(256) NULL;
    CREATE INDEX [IX_AbpRoleClaims_TenantId_ClaimType] ON [AbpRoleClaims] ([TenantId], [ClaimType]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    CREATE TABLE [AbpEntityChangeSets] (
        [Id] bigint NOT NULL IDENTITY,
        [BrowserInfo] nvarchar(256) NULL,
        [ClientIpAddress] nvarchar(64) NULL,
        [ClientName] nvarchar(128) NULL,
        [CreationTime] datetime2 NOT NULL,
        [ExtensionData] nvarchar(max) NULL,
        [ImpersonatorTenantId] int NULL,
        [ImpersonatorUserId] bigint NULL,
        [Reason] nvarchar(256) NULL,
        [TenantId] int NULL,
        [UserId] bigint NULL,
        CONSTRAINT [PK_AbpEntityChangeSets] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    CREATE TABLE [AbpEntityChanges] (
        [Id] bigint NOT NULL IDENTITY,
        [ChangeTime] datetime2 NOT NULL,
        [ChangeType] tinyint NOT NULL,
        [EntityChangeSetId] bigint NOT NULL,
        [EntityId] nvarchar(48) NULL,
        [EntityTypeFullName] nvarchar(192) NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpEntityChanges] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpEntityChanges_AbpEntityChangeSets_EntityChangeSetId] FOREIGN KEY ([EntityChangeSetId]) REFERENCES [AbpEntityChangeSets] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    CREATE TABLE [AbpEntityPropertyChanges] (
        [Id] bigint NOT NULL IDENTITY,
        [EntityChangeId] bigint NOT NULL,
        [NewValue] nvarchar(512) NULL,
        [OriginalValue] nvarchar(512) NULL,
        [PropertyName] nvarchar(96) NULL,
        [PropertyTypeFullName] nvarchar(192) NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpEntityPropertyChanges] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpEntityPropertyChanges_AbpEntityChanges_EntityChangeId] FOREIGN KEY ([EntityChangeId]) REFERENCES [AbpEntityChanges] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    CREATE INDEX [IX_AbpEntityChanges_EntityChangeSetId] ON [AbpEntityChanges] ([EntityChangeSetId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    CREATE INDEX [IX_AbpEntityChanges_EntityTypeFullName_EntityId] ON [AbpEntityChanges] ([EntityTypeFullName], [EntityId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    CREATE INDEX [IX_AbpEntityChangeSets_TenantId_CreationTime] ON [AbpEntityChangeSets] ([TenantId], [CreationTime]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    CREATE INDEX [IX_AbpEntityChangeSets_TenantId_Reason] ON [AbpEntityChangeSets] ([TenantId], [Reason]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    CREATE INDEX [IX_AbpEntityChangeSets_TenantId_UserId] ON [AbpEntityChangeSets] ([TenantId], [UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    CREATE INDEX [IX_AbpEntityPropertyChanges_EntityChangeId] ON [AbpEntityPropertyChanges] ([EntityChangeId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180201051646_Upgraded_To_Abp_v3.4.0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20180201051646_Upgraded_To_Abp_v3.4.0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180320131229_Upgraded_To_Abp_v3_5_0'
)
BEGIN
    DECLARE @var6 sysname;
    SELECT @var6 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUserTokens]') AND [c].[name] = N'Value');
    IF @var6 IS NOT NULL EXEC(N'ALTER TABLE [AbpUserTokens] DROP CONSTRAINT [' + @var6 + '];');
    ALTER TABLE [AbpUserTokens] ALTER COLUMN [Value] nvarchar(512) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180320131229_Upgraded_To_Abp_v3_5_0'
)
BEGIN
    DECLARE @var7 sysname;
    SELECT @var7 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUserTokens]') AND [c].[name] = N'Name');
    IF @var7 IS NOT NULL EXEC(N'ALTER TABLE [AbpUserTokens] DROP CONSTRAINT [' + @var7 + '];');
    ALTER TABLE [AbpUserTokens] ALTER COLUMN [Name] nvarchar(128) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180320131229_Upgraded_To_Abp_v3_5_0'
)
BEGIN
    DECLARE @var8 sysname;
    SELECT @var8 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUserTokens]') AND [c].[name] = N'LoginProvider');
    IF @var8 IS NOT NULL EXEC(N'ALTER TABLE [AbpUserTokens] DROP CONSTRAINT [' + @var8 + '];');
    ALTER TABLE [AbpUserTokens] ALTER COLUMN [LoginProvider] nvarchar(64) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180320131229_Upgraded_To_Abp_v3_5_0'
)
BEGIN
    DECLARE @var9 sysname;
    SELECT @var9 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUsers]') AND [c].[name] = N'SecurityStamp');
    IF @var9 IS NOT NULL EXEC(N'ALTER TABLE [AbpUsers] DROP CONSTRAINT [' + @var9 + '];');
    ALTER TABLE [AbpUsers] ALTER COLUMN [SecurityStamp] nvarchar(128) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180320131229_Upgraded_To_Abp_v3_5_0'
)
BEGIN
    DECLARE @var10 sysname;
    SELECT @var10 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUsers]') AND [c].[name] = N'PhoneNumber');
    IF @var10 IS NOT NULL EXEC(N'ALTER TABLE [AbpUsers] DROP CONSTRAINT [' + @var10 + '];');
    ALTER TABLE [AbpUsers] ALTER COLUMN [PhoneNumber] nvarchar(32) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180320131229_Upgraded_To_Abp_v3_5_0'
)
BEGIN
    DECLARE @var11 sysname;
    SELECT @var11 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUsers]') AND [c].[name] = N'ConcurrencyStamp');
    IF @var11 IS NOT NULL EXEC(N'ALTER TABLE [AbpUsers] DROP CONSTRAINT [' + @var11 + '];');
    ALTER TABLE [AbpUsers] ALTER COLUMN [ConcurrencyStamp] nvarchar(128) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180320131229_Upgraded_To_Abp_v3_5_0'
)
BEGIN
    DECLARE @var12 sysname;
    SELECT @var12 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpRoles]') AND [c].[name] = N'ConcurrencyStamp');
    IF @var12 IS NOT NULL EXEC(N'ALTER TABLE [AbpRoles] DROP CONSTRAINT [' + @var12 + '];');
    ALTER TABLE [AbpRoles] ALTER COLUMN [ConcurrencyStamp] nvarchar(128) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180320131229_Upgraded_To_Abp_v3_5_0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20180320131229_Upgraded_To_Abp_v3_5_0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180509121141_Upgraded_To_Abp_v3_6_1'
)
BEGIN
    DECLARE @var13 sysname;
    SELECT @var13 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUserLoginAttempts]') AND [c].[name] = N'BrowserInfo');
    IF @var13 IS NOT NULL EXEC(N'ALTER TABLE [AbpUserLoginAttempts] DROP CONSTRAINT [' + @var13 + '];');
    ALTER TABLE [AbpUserLoginAttempts] ALTER COLUMN [BrowserInfo] nvarchar(512) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180509121141_Upgraded_To_Abp_v3_6_1'
)
BEGIN
    DECLARE @var14 sysname;
    SELECT @var14 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpEntityChangeSets]') AND [c].[name] = N'BrowserInfo');
    IF @var14 IS NOT NULL EXEC(N'ALTER TABLE [AbpEntityChangeSets] DROP CONSTRAINT [' + @var14 + '];');
    ALTER TABLE [AbpEntityChangeSets] ALTER COLUMN [BrowserInfo] nvarchar(512) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180509121141_Upgraded_To_Abp_v3_6_1'
)
BEGIN
    DECLARE @var15 sysname;
    SELECT @var15 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpAuditLogs]') AND [c].[name] = N'BrowserInfo');
    IF @var15 IS NOT NULL EXEC(N'ALTER TABLE [AbpAuditLogs] DROP CONSTRAINT [' + @var15 + '];');
    ALTER TABLE [AbpAuditLogs] ALTER COLUMN [BrowserInfo] nvarchar(512) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180509121141_Upgraded_To_Abp_v3_6_1'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20180509121141_Upgraded_To_Abp_v3_6_1', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180726102703_Upgrade_ABP_3.8.0'
)
BEGIN
    DECLARE @var16 sysname;
    SELECT @var16 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUsers]') AND [c].[name] = N'UserName');
    IF @var16 IS NOT NULL EXEC(N'ALTER TABLE [AbpUsers] DROP CONSTRAINT [' + @var16 + '];');
    ALTER TABLE [AbpUsers] ALTER COLUMN [UserName] nvarchar(256) NOT NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180726102703_Upgrade_ABP_3.8.0'
)
BEGIN
    DROP INDEX [IX_AbpUsers_TenantId_NormalizedUserName] ON [AbpUsers];
    DECLARE @var17 sysname;
    SELECT @var17 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUsers]') AND [c].[name] = N'NormalizedUserName');
    IF @var17 IS NOT NULL EXEC(N'ALTER TABLE [AbpUsers] DROP CONSTRAINT [' + @var17 + '];');
    ALTER TABLE [AbpUsers] ALTER COLUMN [NormalizedUserName] nvarchar(256) NOT NULL;
    CREATE INDEX [IX_AbpUsers_TenantId_NormalizedUserName] ON [AbpUsers] ([TenantId], [NormalizedUserName]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180726102703_Upgrade_ABP_3.8.0'
)
BEGIN
    DROP INDEX [IX_AbpUserAccounts_TenantId_UserName] ON [AbpUserAccounts];
    DROP INDEX [IX_AbpUserAccounts_UserName] ON [AbpUserAccounts];
    DECLARE @var18 sysname;
    SELECT @var18 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUserAccounts]') AND [c].[name] = N'UserName');
    IF @var18 IS NOT NULL EXEC(N'ALTER TABLE [AbpUserAccounts] DROP CONSTRAINT [' + @var18 + '];');
    ALTER TABLE [AbpUserAccounts] ALTER COLUMN [UserName] nvarchar(256) NULL;
    CREATE INDEX [IX_AbpUserAccounts_TenantId_UserName] ON [AbpUserAccounts] ([TenantId], [UserName]);
    CREATE INDEX [IX_AbpUserAccounts_UserName] ON [AbpUserAccounts] ([UserName]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180726102703_Upgrade_ABP_3.8.0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20180726102703_Upgrade_ABP_3.8.0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180731132139_Upgrade_ABP_3.8.1'
)
BEGIN
    DECLARE @var19 sysname;
    SELECT @var19 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUserTokens]') AND [c].[name] = N'LoginProvider');
    IF @var19 IS NOT NULL EXEC(N'ALTER TABLE [AbpUserTokens] DROP CONSTRAINT [' + @var19 + '];');
    ALTER TABLE [AbpUserTokens] ALTER COLUMN [LoginProvider] nvarchar(128) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180731132139_Upgrade_ABP_3.8.1'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20180731132139_Upgrade_ABP_3.8.1', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180927062608_Upgrade_ABP_3.8.3'
)
BEGIN
    ALTER TABLE [AbpUserTokens] ADD [ExpireDate] datetime2 NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20180927062608_Upgrade_ABP_3.8.3'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20180927062608_Upgrade_ABP_3.8.3', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20181013103914_Upgraded_To_Abp_v3_9_0'
)
BEGIN
    DECLARE @var20 sysname;
    SELECT @var20 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUsers]') AND [c].[name] = N'Surname');
    IF @var20 IS NOT NULL EXEC(N'ALTER TABLE [AbpUsers] DROP CONSTRAINT [' + @var20 + '];');
    ALTER TABLE [AbpUsers] ALTER COLUMN [Surname] nvarchar(64) NOT NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20181013103914_Upgraded_To_Abp_v3_9_0'
)
BEGIN
    DECLARE @var21 sysname;
    SELECT @var21 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUsers]') AND [c].[name] = N'Name');
    IF @var21 IS NOT NULL EXEC(N'ALTER TABLE [AbpUsers] DROP CONSTRAINT [' + @var21 + '];');
    ALTER TABLE [AbpUsers] ALTER COLUMN [Name] nvarchar(64) NOT NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20181013103914_Upgraded_To_Abp_v3_9_0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20181013103914_Upgraded_To_Abp_v3_9_0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20190208051931_Upgrade_ABP_4_2_0'
)
BEGIN
    DECLARE @var22 sysname;
    SELECT @var22 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUsers]') AND [c].[name] = N'LastLoginTime');
    IF @var22 IS NOT NULL EXEC(N'ALTER TABLE [AbpUsers] DROP CONSTRAINT [' + @var22 + '];');
    ALTER TABLE [AbpUsers] DROP COLUMN [LastLoginTime];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20190208051931_Upgrade_ABP_4_2_0'
)
BEGIN
    DECLARE @var23 sysname;
    SELECT @var23 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUserAccounts]') AND [c].[name] = N'LastLoginTime');
    IF @var23 IS NOT NULL EXEC(N'ALTER TABLE [AbpUserAccounts] DROP CONSTRAINT [' + @var23 + '];');
    ALTER TABLE [AbpUserAccounts] DROP COLUMN [LastLoginTime];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20190208051931_Upgrade_ABP_4_2_0'
)
BEGIN
    ALTER TABLE [AbpAuditLogs] ADD [ReturnValue] nvarchar(max) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20190208051931_Upgrade_ABP_4_2_0'
)
BEGIN
    CREATE TABLE [AbpOrganizationUnitRoles] (
        [Id] bigint NOT NULL IDENTITY,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [TenantId] int NULL,
        [RoleId] int NOT NULL,
        [OrganizationUnitId] bigint NOT NULL,
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_AbpOrganizationUnitRoles] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20190208051931_Upgrade_ABP_4_2_0'
)
BEGIN
    CREATE INDEX [IX_AbpOrganizationUnitRoles_TenantId_OrganizationUnitId] ON [AbpOrganizationUnitRoles] ([TenantId], [OrganizationUnitId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20190208051931_Upgrade_ABP_4_2_0'
)
BEGIN
    CREATE INDEX [IX_AbpOrganizationUnitRoles_TenantId_RoleId] ON [AbpOrganizationUnitRoles] ([TenantId], [RoleId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20190208051931_Upgrade_ABP_4_2_0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20190208051931_Upgrade_ABP_4_2_0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20190703062215_Upgraded_To_Abp_4_7_0'
)
BEGIN
    DROP INDEX [IX_AbpSettings_TenantId_Name] ON [AbpSettings];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20190703062215_Upgraded_To_Abp_4_7_0'
)
BEGIN
    CREATE UNIQUE INDEX [IX_AbpSettings_TenantId_Name_UserId] ON [AbpSettings] ([TenantId], [Name], [UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20190703062215_Upgraded_To_Abp_4_7_0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20190703062215_Upgraded_To_Abp_4_7_0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20190719143908_Upgraded_To_Abp_4_8_0'
)
BEGIN
    DROP INDEX [IX_AbpLanguageTexts_TenantId_Source_LanguageName_Key] ON [AbpLanguageTexts];
    DECLARE @var24 sysname;
    SELECT @var24 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpLanguageTexts]') AND [c].[name] = N'LanguageName');
    IF @var24 IS NOT NULL EXEC(N'ALTER TABLE [AbpLanguageTexts] DROP CONSTRAINT [' + @var24 + '];');
    ALTER TABLE [AbpLanguageTexts] ALTER COLUMN [LanguageName] nvarchar(128) NOT NULL;
    CREATE INDEX [IX_AbpLanguageTexts_TenantId_Source_LanguageName_Key] ON [AbpLanguageTexts] ([TenantId], [Source], [LanguageName], [Key]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20190719143908_Upgraded_To_Abp_4_8_0'
)
BEGIN
    DROP INDEX [IX_AbpLanguages_TenantId_Name] ON [AbpLanguages];
    DECLARE @var25 sysname;
    SELECT @var25 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpLanguages]') AND [c].[name] = N'Name');
    IF @var25 IS NOT NULL EXEC(N'ALTER TABLE [AbpLanguages] DROP CONSTRAINT [' + @var25 + '];');
    ALTER TABLE [AbpLanguages] ALTER COLUMN [Name] nvarchar(128) NOT NULL;
    CREATE INDEX [IX_AbpLanguages_TenantId_Name] ON [AbpLanguages] ([TenantId], [Name]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20190719143908_Upgraded_To_Abp_4_8_0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20190719143908_Upgraded_To_Abp_4_8_0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20191216011543_Upgraded_To_Abp_5_1_0'
)
BEGIN
    DROP INDEX [IX_AbpUserLoginAttempts_TenancyName_UserNameOrEmailAddress_Result] ON [AbpUserLoginAttempts];
    DECLARE @var26 sysname;
    SELECT @var26 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUserLoginAttempts]') AND [c].[name] = N'UserNameOrEmailAddress');
    IF @var26 IS NOT NULL EXEC(N'ALTER TABLE [AbpUserLoginAttempts] DROP CONSTRAINT [' + @var26 + '];');
    ALTER TABLE [AbpUserLoginAttempts] ALTER COLUMN [UserNameOrEmailAddress] nvarchar(256) NULL;
    CREATE INDEX [IX_AbpUserLoginAttempts_TenancyName_UserNameOrEmailAddress_Result] ON [AbpUserLoginAttempts] ([TenancyName], [UserNameOrEmailAddress], [Result]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20191216011543_Upgraded_To_Abp_5_1_0'
)
BEGIN
    DECLARE @var27 sysname;
    SELECT @var27 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpSettings]') AND [c].[name] = N'Value');
    IF @var27 IS NOT NULL EXEC(N'ALTER TABLE [AbpSettings] DROP CONSTRAINT [' + @var27 + '];');
    ALTER TABLE [AbpSettings] ALTER COLUMN [Value] nvarchar(max) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20191216011543_Upgraded_To_Abp_5_1_0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20191216011543_Upgraded_To_Abp_5_1_0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200220110527_Upgraded_To_Abp_5_2_0'
)
BEGIN
    CREATE TABLE [AbpWebhookEvents] (
        [Id] uniqueidentifier NOT NULL,
        [WebhookName] nvarchar(max) NOT NULL,
        [Data] nvarchar(max) NULL,
        [CreationTime] datetime2 NOT NULL,
        [TenantId] int NULL,
        [IsDeleted] bit NOT NULL,
        [DeletionTime] datetime2 NULL,
        CONSTRAINT [PK_AbpWebhookEvents] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200220110527_Upgraded_To_Abp_5_2_0'
)
BEGIN
    CREATE TABLE [AbpWebhookSubscriptions] (
        [Id] uniqueidentifier NOT NULL,
        [CreationTime] datetime2 NOT NULL,
        [CreatorUserId] bigint NULL,
        [TenantId] int NULL,
        [WebhookUri] nvarchar(max) NOT NULL,
        [Secret] nvarchar(max) NOT NULL,
        [IsActive] bit NOT NULL,
        [Webhooks] nvarchar(max) NULL,
        [Headers] nvarchar(max) NULL,
        CONSTRAINT [PK_AbpWebhookSubscriptions] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200220110527_Upgraded_To_Abp_5_2_0'
)
BEGIN
    CREATE TABLE [AbpWebhookSendAttempts] (
        [Id] uniqueidentifier NOT NULL,
        [WebhookEventId] uniqueidentifier NOT NULL,
        [WebhookSubscriptionId] uniqueidentifier NOT NULL,
        [Response] nvarchar(max) NULL,
        [ResponseStatusCode] int NULL,
        [CreationTime] datetime2 NOT NULL,
        [LastModificationTime] datetime2 NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpWebhookSendAttempts] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpWebhookSendAttempts_AbpWebhookEvents_WebhookEventId] FOREIGN KEY ([WebhookEventId]) REFERENCES [AbpWebhookEvents] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200220110527_Upgraded_To_Abp_5_2_0'
)
BEGIN
    CREATE INDEX [IX_AbpWebhookSendAttempts_WebhookEventId] ON [AbpWebhookSendAttempts] ([WebhookEventId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200220110527_Upgraded_To_Abp_5_2_0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20200220110527_Upgraded_To_Abp_5_2_0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200320114152_Upgraded_To_Abp_5_4_0'
)
BEGIN
    DROP INDEX [IX_AbpOrganizationUnits_TenantId_Code] ON [AbpOrganizationUnits];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200320114152_Upgraded_To_Abp_5_4_0'
)
BEGIN
    CREATE TABLE [AbpDynamicParameters] (
        [Id] int NOT NULL IDENTITY,
        [ParameterName] nvarchar(450) NULL,
        [InputType] nvarchar(max) NULL,
        [Permission] nvarchar(max) NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpDynamicParameters] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200320114152_Upgraded_To_Abp_5_4_0'
)
BEGIN
    CREATE TABLE [AbpDynamicParameterValues] (
        [Id] int NOT NULL IDENTITY,
        [Value] nvarchar(max) NOT NULL,
        [TenantId] int NULL,
        [DynamicParameterId] int NOT NULL,
        CONSTRAINT [PK_AbpDynamicParameterValues] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpDynamicParameterValues_AbpDynamicParameters_DynamicParameterId] FOREIGN KEY ([DynamicParameterId]) REFERENCES [AbpDynamicParameters] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200320114152_Upgraded_To_Abp_5_4_0'
)
BEGIN
    CREATE TABLE [AbpEntityDynamicParameters] (
        [Id] int NOT NULL IDENTITY,
        [EntityFullName] nvarchar(450) NULL,
        [DynamicParameterId] int NOT NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpEntityDynamicParameters] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpEntityDynamicParameters_AbpDynamicParameters_DynamicParameterId] FOREIGN KEY ([DynamicParameterId]) REFERENCES [AbpDynamicParameters] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200320114152_Upgraded_To_Abp_5_4_0'
)
BEGIN
    CREATE TABLE [AbpEntityDynamicParameterValues] (
        [Id] int NOT NULL IDENTITY,
        [Value] nvarchar(max) NOT NULL,
        [EntityId] nvarchar(max) NULL,
        [EntityDynamicParameterId] int NOT NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpEntityDynamicParameterValues] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpEntityDynamicParameterValues_AbpEntityDynamicParameters_EntityDynamicParameterId] FOREIGN KEY ([EntityDynamicParameterId]) REFERENCES [AbpEntityDynamicParameters] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200320114152_Upgraded_To_Abp_5_4_0'
)
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [IX_AbpOrganizationUnits_TenantId_Code] ON [AbpOrganizationUnits] ([TenantId], [Code]) WHERE [TenantId] IS NOT NULL');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200320114152_Upgraded_To_Abp_5_4_0'
)
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [IX_AbpDynamicParameters_ParameterName_TenantId] ON [AbpDynamicParameters] ([ParameterName], [TenantId]) WHERE [ParameterName] IS NOT NULL AND [TenantId] IS NOT NULL');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200320114152_Upgraded_To_Abp_5_4_0'
)
BEGIN
    CREATE INDEX [IX_AbpDynamicParameterValues_DynamicParameterId] ON [AbpDynamicParameterValues] ([DynamicParameterId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200320114152_Upgraded_To_Abp_5_4_0'
)
BEGIN
    CREATE INDEX [IX_AbpEntityDynamicParameters_DynamicParameterId] ON [AbpEntityDynamicParameters] ([DynamicParameterId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200320114152_Upgraded_To_Abp_5_4_0'
)
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [IX_AbpEntityDynamicParameters_EntityFullName_DynamicParameterId_TenantId] ON [AbpEntityDynamicParameters] ([EntityFullName], [DynamicParameterId], [TenantId]) WHERE [EntityFullName] IS NOT NULL AND [TenantId] IS NOT NULL');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200320114152_Upgraded_To_Abp_5_4_0'
)
BEGIN
    CREATE INDEX [IX_AbpEntityDynamicParameterValues_EntityDynamicParameterId] ON [AbpEntityDynamicParameterValues] ([EntityDynamicParameterId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200320114152_Upgraded_To_Abp_5_4_0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20200320114152_Upgraded_To_Abp_5_4_0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200604091046_Upgraded_To_Abp_5_9'
)
BEGIN
    DROP INDEX [IX_AbpOrganizationUnits_TenantId_Code] ON [AbpOrganizationUnits];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200604091046_Upgraded_To_Abp_5_9'
)
BEGIN
    CREATE INDEX [IX_AbpOrganizationUnits_TenantId_Code] ON [AbpOrganizationUnits] ([TenantId], [Code]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200604091046_Upgraded_To_Abp_5_9'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20200604091046_Upgraded_To_Abp_5_9', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    DROP TABLE [AbpDynamicParameterValues];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    DROP TABLE [AbpEntityDynamicParameterValues];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    DROP TABLE [AbpEntityDynamicParameters];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    DROP TABLE [AbpDynamicParameters];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    CREATE TABLE [AbpDynamicProperties] (
        [Id] int NOT NULL IDENTITY,
        [PropertyName] nvarchar(450) NULL,
        [InputType] nvarchar(max) NULL,
        [Permission] nvarchar(max) NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpDynamicProperties] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    CREATE TABLE [AbpDynamicEntityProperties] (
        [Id] int NOT NULL IDENTITY,
        [EntityFullName] nvarchar(450) NULL,
        [DynamicPropertyId] int NOT NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpDynamicEntityProperties] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpDynamicEntityProperties_AbpDynamicProperties_DynamicPropertyId] FOREIGN KEY ([DynamicPropertyId]) REFERENCES [AbpDynamicProperties] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    CREATE TABLE [AbpDynamicPropertyValues] (
        [Id] int NOT NULL IDENTITY,
        [Value] nvarchar(max) NOT NULL,
        [TenantId] int NULL,
        [DynamicPropertyId] int NOT NULL,
        CONSTRAINT [PK_AbpDynamicPropertyValues] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpDynamicPropertyValues_AbpDynamicProperties_DynamicPropertyId] FOREIGN KEY ([DynamicPropertyId]) REFERENCES [AbpDynamicProperties] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    CREATE TABLE [AbpDynamicEntityPropertyValues] (
        [Id] int NOT NULL IDENTITY,
        [Value] nvarchar(max) NOT NULL,
        [EntityId] nvarchar(max) NULL,
        [DynamicEntityPropertyId] int NOT NULL,
        [TenantId] int NULL,
        CONSTRAINT [PK_AbpDynamicEntityPropertyValues] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AbpDynamicEntityPropertyValues_AbpDynamicEntityProperties_DynamicEntityPropertyId] FOREIGN KEY ([DynamicEntityPropertyId]) REFERENCES [AbpDynamicEntityProperties] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    CREATE INDEX [IX_AbpDynamicEntityProperties_DynamicPropertyId] ON [AbpDynamicEntityProperties] ([DynamicPropertyId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [IX_AbpDynamicEntityProperties_EntityFullName_DynamicPropertyId_TenantId] ON [AbpDynamicEntityProperties] ([EntityFullName], [DynamicPropertyId], [TenantId]) WHERE [EntityFullName] IS NOT NULL AND [TenantId] IS NOT NULL');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    CREATE INDEX [IX_AbpDynamicEntityPropertyValues_DynamicEntityPropertyId] ON [AbpDynamicEntityPropertyValues] ([DynamicEntityPropertyId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [IX_AbpDynamicProperties_PropertyName_TenantId] ON [AbpDynamicProperties] ([PropertyName], [TenantId]) WHERE [PropertyName] IS NOT NULL AND [TenantId] IS NOT NULL');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    CREATE INDEX [IX_AbpDynamicPropertyValues_DynamicPropertyId] ON [AbpDynamicPropertyValues] ([DynamicPropertyId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20200928141743_Upgraded_To_ABP_5_13_0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20200928141743_Upgraded_To_ABP_5_13_0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20201112121732_Upgraded_To_ABP_6_0'
)
BEGIN
    ALTER TABLE [AbpEntityPropertyChanges] ADD [NewValueHash] nvarchar(max) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20201112121732_Upgraded_To_ABP_6_0'
)
BEGIN
    ALTER TABLE [AbpEntityPropertyChanges] ADD [OriginalValueHash] nvarchar(max) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20201112121732_Upgraded_To_ABP_6_0'
)
BEGIN
    ALTER TABLE [AbpDynamicProperties] ADD [DisplayName] nvarchar(max) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20201112121732_Upgraded_To_ABP_6_0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20201112121732_Upgraded_To_ABP_6_0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20201217144556_Upgrade_To_ABP_6_1_1'
)
BEGIN
    ALTER TABLE [AbpDynamicPropertyValues] DROP CONSTRAINT [PK_AbpDynamicPropertyValues];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20201217144556_Upgrade_To_ABP_6_1_1'
)
BEGIN
    DECLARE @var28 sysname;
    SELECT @var28 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpDynamicPropertyValues]') AND [c].[name] = N'Id');
    IF @var28 IS NOT NULL EXEC(N'ALTER TABLE [AbpDynamicPropertyValues] DROP CONSTRAINT [' + @var28 + '];');
    ALTER TABLE [AbpDynamicPropertyValues] DROP COLUMN [Id];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20201217144556_Upgrade_To_ABP_6_1_1'
)
BEGIN
    ALTER TABLE [AbpDynamicPropertyValues] ADD [Id] bigint NOT NULL IDENTITY;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20201217144556_Upgrade_To_ABP_6_1_1'
)
BEGIN
    ALTER TABLE [AbpDynamicPropertyValues] ADD CONSTRAINT [PK_AbpDynamicPropertyValues] PRIMARY KEY ([Id]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20201217144556_Upgrade_To_ABP_6_1_1'
)
BEGIN
    ALTER TABLE [AbpDynamicEntityPropertyValues] DROP CONSTRAINT [PK_AbpDynamicEntityPropertyValues];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20201217144556_Upgrade_To_ABP_6_1_1'
)
BEGIN
    DECLARE @var29 sysname;
    SELECT @var29 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpDynamicEntityPropertyValues]') AND [c].[name] = N'Id');
    IF @var29 IS NOT NULL EXEC(N'ALTER TABLE [AbpDynamicEntityPropertyValues] DROP CONSTRAINT [' + @var29 + '];');
    ALTER TABLE [AbpDynamicEntityPropertyValues] DROP COLUMN [Id];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20201217144556_Upgrade_To_ABP_6_1_1'
)
BEGIN
    ALTER TABLE [AbpDynamicEntityPropertyValues] ADD [Id] bigint NOT NULL IDENTITY;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20201217144556_Upgrade_To_ABP_6_1_1'
)
BEGIN
    ALTER TABLE [AbpDynamicEntityPropertyValues] ADD CONSTRAINT [PK_AbpDynamicEntityPropertyValues] PRIMARY KEY ([Id]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20201217144556_Upgrade_To_ABP_6_1_1'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20201217144556_Upgrade_To_ABP_6_1_1', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20210324090321_Upgrade_To_ABP_6_3'
)
BEGIN
    DROP INDEX [IX_AbpDynamicProperties_PropertyName_TenantId] ON [AbpDynamicProperties];
    DECLARE @var30 sysname;
    SELECT @var30 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpDynamicProperties]') AND [c].[name] = N'PropertyName');
    IF @var30 IS NOT NULL EXEC(N'ALTER TABLE [AbpDynamicProperties] DROP CONSTRAINT [' + @var30 + '];');
    ALTER TABLE [AbpDynamicProperties] ALTER COLUMN [PropertyName] nvarchar(256) NULL;
    EXEC(N'CREATE UNIQUE INDEX [IX_AbpDynamicProperties_PropertyName_TenantId] ON [AbpDynamicProperties] ([PropertyName], [TenantId]) WHERE [PropertyName] IS NOT NULL AND [TenantId] IS NOT NULL');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20210324090321_Upgrade_To_ABP_6_3'
)
BEGIN
    DROP INDEX [IX_AbpDynamicEntityProperties_EntityFullName_DynamicPropertyId_TenantId] ON [AbpDynamicEntityProperties];
    DECLARE @var31 sysname;
    SELECT @var31 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpDynamicEntityProperties]') AND [c].[name] = N'EntityFullName');
    IF @var31 IS NOT NULL EXEC(N'ALTER TABLE [AbpDynamicEntityProperties] DROP CONSTRAINT [' + @var31 + '];');
    ALTER TABLE [AbpDynamicEntityProperties] ALTER COLUMN [EntityFullName] nvarchar(256) NULL;
    EXEC(N'CREATE UNIQUE INDEX [IX_AbpDynamicEntityProperties_EntityFullName_DynamicPropertyId_TenantId] ON [AbpDynamicEntityProperties] ([EntityFullName], [DynamicPropertyId], [TenantId]) WHERE [EntityFullName] IS NOT NULL AND [TenantId] IS NOT NULL');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20210324090321_Upgrade_To_ABP_6_3'
)
BEGIN
    ALTER TABLE [AbpAuditLogs] ADD [ExceptionMessage] nvarchar(1024) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20210324090321_Upgrade_To_ABP_6_3'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210324090321_Upgrade_To_ABP_6_3', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20210628103231_Upgrade_To_ABP_6_4_rc1'
)
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [IX_AbpUserLogins_ProviderKey_TenantId] ON [AbpUserLogins] ([ProviderKey], [TenantId]) WHERE [TenantId] IS NOT NULL');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20210628103231_Upgrade_To_ABP_6_4_rc1'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210628103231_Upgrade_To_ABP_6_4_rc1', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20220622074714_Upgrade_To_ABP_7.3'
)
BEGIN
    ALTER TABLE [AbpUserNotifications] ADD [TargetNotifiers] nvarchar(max) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20220622074714_Upgrade_To_ABP_7.3'
)
BEGIN
    ALTER TABLE [AbpNotifications] ADD [TargetNotifiers] nvarchar(max) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20220622074714_Upgrade_To_ABP_7.3'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20220622074714_Upgrade_To_ABP_7.3', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20221213132802_Upgraded_To_Abp_8_0'
)
BEGIN
    DECLARE @var32 sysname;
    SELECT @var32 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpUserNotifications]') AND [c].[name] = N'TargetNotifiers');
    IF @var32 IS NOT NULL EXEC(N'ALTER TABLE [AbpUserNotifications] DROP CONSTRAINT [' + @var32 + '];');
    ALTER TABLE [AbpUserNotifications] ALTER COLUMN [TargetNotifiers] nvarchar(1024) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20221213132802_Upgraded_To_Abp_8_0'
)
BEGIN
    DECLARE @var33 sysname;
    SELECT @var33 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpNotifications]') AND [c].[name] = N'TargetNotifiers');
    IF @var33 IS NOT NULL EXEC(N'ALTER TABLE [AbpNotifications] DROP CONSTRAINT [' + @var33 + '];');
    ALTER TABLE [AbpNotifications] ALTER COLUMN [TargetNotifiers] nvarchar(1024) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20221213132802_Upgraded_To_Abp_8_0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20221213132802_Upgraded_To_Abp_8_0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240125104915_Upgraded_To_Abp_9_1'
)
BEGIN
    DECLARE @var34 sysname;
    SELECT @var34 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpPermissions]') AND [c].[name] = N'Discriminator');
    IF @var34 IS NOT NULL EXEC(N'ALTER TABLE [AbpPermissions] DROP CONSTRAINT [' + @var34 + '];');
    ALTER TABLE [AbpPermissions] ALTER COLUMN [Discriminator] nvarchar(21) NOT NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240125104915_Upgraded_To_Abp_9_1'
)
BEGIN
    ALTER TABLE [AbpNotificationSubscriptions] ADD [TargetNotifiers] nvarchar(1024) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240125104915_Upgraded_To_Abp_9_1'
)
BEGIN
    DECLARE @var35 sysname;
    SELECT @var35 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpFeatures]') AND [c].[name] = N'Discriminator');
    IF @var35 IS NOT NULL EXEC(N'ALTER TABLE [AbpFeatures] DROP CONSTRAINT [' + @var35 + '];');
    ALTER TABLE [AbpFeatures] ALTER COLUMN [Discriminator] nvarchar(21) NOT NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240125104915_Upgraded_To_Abp_9_1'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240125104915_Upgraded_To_Abp_9_1', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240503071035_Upgraded_To_Abp_9_2'
)
BEGIN
    ALTER TABLE [AbpUserLoginAttempts] ADD [FailReason] nvarchar(1024) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240503071035_Upgraded_To_Abp_9_2'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240503071035_Upgraded_To_Abp_9_2', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250114124801_Upgraded_To_Abp_10_0'
)
BEGIN
    DECLARE @var36 sysname;
    SELECT @var36 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpAuditLogs]') AND [c].[name] = N'Parameters');
    IF @var36 IS NOT NULL EXEC(N'ALTER TABLE [AbpAuditLogs] DROP CONSTRAINT [' + @var36 + '];');
    ALTER TABLE [AbpAuditLogs] ALTER COLUMN [Parameters] nvarchar(2048) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250114124801_Upgraded_To_Abp_10_0'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20250114124801_Upgraded_To_Abp_10_0', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250528073026_Upgraded_To_Abp_10_2'
)
BEGIN
    DECLARE @var37 sysname;
    SELECT @var37 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AbpAuditLogs]') AND [c].[name] = N'Parameters');
    IF @var37 IS NOT NULL EXEC(N'ALTER TABLE [AbpAuditLogs] DROP CONSTRAINT [' + @var37 + '];');
    ALTER TABLE [AbpAuditLogs] ALTER COLUMN [Parameters] nvarchar(max) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250528073026_Upgraded_To_Abp_10_2'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20250528073026_Upgraded_To_Abp_10_2', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE TABLE [ReadingExams] (
        [Id] int NOT NULL IDENTITY,
        [Name] nvarchar(200) NOT NULL,
        [DurationMinutes] int NOT NULL,
        [TotalQuestions] int NOT NULL,
        [AnswerStatus] nvarchar(20) NOT NULL,
        [SourceHash] nvarchar(64) NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        CONSTRAINT [PK_ReadingExams] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_ReadingExam] CHECK ([DurationMinutes]=75 AND [TotalQuestions]=100 AND [AnswerStatus] IN ('proposed','verified'))
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE TABLE [ReadingAttempts] (
        [Id] uniqueidentifier NOT NULL,
        [ExamId] int NOT NULL,
        [UserId] bigint NOT NULL,
        [StartedAt] datetime2 NOT NULL,
        [Deadline] datetime2 NOT NULL,
        [SubmittedAt] datetime2 NULL,
        [Status] nvarchar(20) NOT NULL,
        [Correct] int NOT NULL,
        [Wrong] int NOT NULL,
        [Skipped] int NOT NULL,
        CONSTRAINT [PK_ReadingAttempts] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_ReadingAttempts_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AbpUsers] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_ReadingAttempts_ReadingExams_ExamId] FOREIGN KEY ([ExamId]) REFERENCES [ReadingExams] ([Id]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE TABLE [ReadingParts] (
        [Id] int NOT NULL IDENTITY,
        [ExamId] int NOT NULL,
        [Number] int NOT NULL,
        CONSTRAINT [PK_ReadingParts] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_ReadingPart] CHECK ([Number] IN (5,6,7)),
        CONSTRAINT [FK_ReadingParts_ReadingExams_ExamId] FOREIGN KEY ([ExamId]) REFERENCES [ReadingExams] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE TABLE [ReadingGroups] (
        [Id] int NOT NULL IDENTITY,
        [PartId] int NOT NULL,
        [Key] nvarchar(80) NOT NULL,
        CONSTRAINT [PK_ReadingGroups] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_ReadingGroups_ReadingParts_PartId] FOREIGN KEY ([PartId]) REFERENCES [ReadingParts] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE TABLE [ReadingDocuments] (
        [Id] int NOT NULL IDENTITY,
        [GroupId] int NOT NULL,
        [Order] int NOT NULL,
        [Text] nvarchar(max) NOT NULL,
        [Image] varbinary(max) NULL,
        [ImageMime] nvarchar(30) NULL,
        CONSTRAINT [PK_ReadingDocuments] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_ReadingDocuments_ReadingGroups_GroupId] FOREIGN KEY ([GroupId]) REFERENCES [ReadingGroups] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE TABLE [ReadingQuestions] (
        [Id] int NOT NULL IDENTITY,
        [ExamId] int NOT NULL,
        [PartId] int NOT NULL,
        [GroupId] int NULL,
        [Number] int NOT NULL,
        [Text] nvarchar(max) NOT NULL,
        [CorrectAnswer] nvarchar(1) NOT NULL,
        [AnswerStatus] nvarchar(20) NOT NULL,
        CONSTRAINT [PK_ReadingQuestions] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_ReadingQuestion] CHECK ([Number] BETWEEN 101 AND 200 AND [CorrectAnswer] IN ('A','B','C','D') AND [AnswerStatus] IN ('proposed','verified')),
        CONSTRAINT [FK_ReadingQuestions_ReadingExams_ExamId] FOREIGN KEY ([ExamId]) REFERENCES [ReadingExams] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_ReadingQuestions_ReadingGroups_GroupId] FOREIGN KEY ([GroupId]) REFERENCES [ReadingGroups] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_ReadingQuestions_ReadingParts_PartId] FOREIGN KEY ([PartId]) REFERENCES [ReadingParts] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE TABLE [ReadingAnswers] (
        [Id] int NOT NULL IDENTITY,
        [AttemptId] uniqueidentifier NOT NULL,
        [QuestionId] int NOT NULL,
        [Letter] nvarchar(1) NOT NULL,
        CONSTRAINT [PK_ReadingAnswers] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_ReadingAnswer] CHECK ([Letter] IN ('A','B','C','D')),
        CONSTRAINT [FK_ReadingAnswers_ReadingAttempts_AttemptId] FOREIGN KEY ([AttemptId]) REFERENCES [ReadingAttempts] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_ReadingAnswers_ReadingQuestions_QuestionId] FOREIGN KEY ([QuestionId]) REFERENCES [ReadingQuestions] ([Id]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE TABLE [ReadingChoices] (
        [Id] int NOT NULL IDENTITY,
        [QuestionId] int NOT NULL,
        [Letter] nvarchar(1) NOT NULL,
        [Text] nvarchar(max) NOT NULL,
        CONSTRAINT [PK_ReadingChoices] PRIMARY KEY ([Id]),
        CONSTRAINT [CK_ReadingChoice] CHECK ([Letter] IN ('A','B','C','D')),
        CONSTRAINT [FK_ReadingChoices_ReadingQuestions_QuestionId] FOREIGN KEY ([QuestionId]) REFERENCES [ReadingQuestions] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE UNIQUE INDEX [IX_ReadingAnswers_AttemptId_QuestionId] ON [ReadingAnswers] ([AttemptId], [QuestionId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE INDEX [IX_ReadingAnswers_QuestionId] ON [ReadingAnswers] ([QuestionId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE INDEX [IX_ReadingAttempts_ExamId] ON [ReadingAttempts] ([ExamId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE INDEX [IX_ReadingAttempts_Status_Deadline] ON [ReadingAttempts] ([Status], [Deadline]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE INDEX [IX_ReadingAttempts_UserId_ExamId_Status] ON [ReadingAttempts] ([UserId], [ExamId], [Status]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE UNIQUE INDEX [IX_ReadingChoices_QuestionId_Letter] ON [ReadingChoices] ([QuestionId], [Letter]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE UNIQUE INDEX [IX_ReadingDocuments_GroupId_Order] ON [ReadingDocuments] ([GroupId], [Order]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE UNIQUE INDEX [IX_ReadingExams_SourceHash] ON [ReadingExams] ([SourceHash]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE UNIQUE INDEX [IX_ReadingGroups_PartId_Key] ON [ReadingGroups] ([PartId], [Key]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE UNIQUE INDEX [IX_ReadingParts_ExamId_Number] ON [ReadingParts] ([ExamId], [Number]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE UNIQUE INDEX [IX_ReadingQuestions_ExamId_Number] ON [ReadingQuestions] ([ExamId], [Number]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE INDEX [IX_ReadingQuestions_GroupId] ON [ReadingQuestions] ([GroupId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    CREATE INDEX [IX_ReadingQuestions_PartId] ON [ReadingQuestions] ([PartId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012014611_AddToeicReading'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20261012014611_AddToeicReading', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012015550_ReadingDocumentEditingAndRelations'
)
BEGIN
    ALTER TABLE [ReadingQuestions] DROP CONSTRAINT [FK_ReadingQuestions_ReadingGroups_GroupId];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012015550_ReadingDocumentEditingAndRelations'
)
BEGIN
    ALTER TABLE [ReadingQuestions] DROP CONSTRAINT [FK_ReadingQuestions_ReadingParts_PartId];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012015550_ReadingDocumentEditingAndRelations'
)
BEGIN
    DROP INDEX [IX_ReadingQuestions_GroupId] ON [ReadingQuestions];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012015550_ReadingDocumentEditingAndRelations'
)
BEGIN
    DROP INDEX [IX_ReadingQuestions_PartId] ON [ReadingQuestions];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012015550_ReadingDocumentEditingAndRelations'
)
BEGIN
    ALTER TABLE [ReadingDocuments] ADD [TextWasEdited] bit NOT NULL DEFAULT CAST(0 AS bit);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012015550_ReadingDocumentEditingAndRelations'
)
BEGIN
    ALTER TABLE [ReadingParts] ADD CONSTRAINT [AK_ReadingParts_Id_ExamId] UNIQUE ([Id], [ExamId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012015550_ReadingDocumentEditingAndRelations'
)
BEGIN
    ALTER TABLE [ReadingGroups] ADD CONSTRAINT [AK_ReadingGroups_Id_PartId] UNIQUE ([Id], [PartId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012015550_ReadingDocumentEditingAndRelations'
)
BEGIN
    CREATE INDEX [IX_ReadingQuestions_GroupId_PartId] ON [ReadingQuestions] ([GroupId], [PartId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012015550_ReadingDocumentEditingAndRelations'
)
BEGIN
    CREATE INDEX [IX_ReadingQuestions_PartId_ExamId] ON [ReadingQuestions] ([PartId], [ExamId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012015550_ReadingDocumentEditingAndRelations'
)
BEGIN
    ALTER TABLE [ReadingQuestions] ADD CONSTRAINT [FK_ReadingQuestions_ReadingGroups_GroupId_PartId] FOREIGN KEY ([GroupId], [PartId]) REFERENCES [ReadingGroups] ([Id], [PartId]) ON DELETE NO ACTION;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012015550_ReadingDocumentEditingAndRelations'
)
BEGIN
    ALTER TABLE [ReadingQuestions] ADD CONSTRAINT [FK_ReadingQuestions_ReadingParts_PartId_ExamId] FOREIGN KEY ([PartId], [ExamId]) REFERENCES [ReadingParts] ([Id], [ExamId]) ON DELETE NO ACTION;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012015550_ReadingDocumentEditingAndRelations'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20261012015550_ReadingDocumentEditingAndRelations', N'9.0.5');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012022205_AnonymousReadingSessions'
)
BEGIN
    DECLARE @var38 sysname;
    SELECT @var38 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[ReadingAttempts]') AND [c].[name] = N'UserId');
    IF @var38 IS NOT NULL EXEC(N'ALTER TABLE [ReadingAttempts] DROP CONSTRAINT [' + @var38 + '];');
    ALTER TABLE [ReadingAttempts] ALTER COLUMN [UserId] bigint NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012022205_AnonymousReadingSessions'
)
BEGIN
    ALTER TABLE [ReadingAttempts] ADD [GuestKeyHash] nvarchar(64) NULL;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012022205_AnonymousReadingSessions'
)
BEGIN
    CREATE INDEX [IX_ReadingAttempts_GuestKeyHash_ExamId_Status] ON [ReadingAttempts] ([GuestKeyHash], [ExamId], [Status]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261012022205_AnonymousReadingSessions'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20261012022205_AnonymousReadingSessions', N'9.0.5');
END;

COMMIT;
GO

