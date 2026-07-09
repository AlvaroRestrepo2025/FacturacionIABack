USE master;
GO

IF DB_ID('FacturacionIA') IS NULL
BEGIN
    CREATE DATABASE FacturacionIA;
END;
GO

USE FacturacionIA;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

/* =========================================================
   HU-002 / HU-005
   TABLA: AuditoriaSesion
   Registra eventos de inicio y cierre de sesión.
   ========================================================= */

IF OBJECT_ID('[dbo].[AuditoriaSesion]', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[AuditoriaSesion]
    (
        [IdAuditoriaSesion] [int] IDENTITY(1,1) NOT NULL,
        [NombreUsuario] [nvarchar](100) NOT NULL,
        [Apellido] [nvarchar](100) NULL,
        [Fecha] [datetime2](7) NOT NULL,
        [Exitoso] [bit] NOT NULL,
        [Motivo] [nvarchar](250) NOT NULL,
        [Rol] [nvarchar](50) NULL,

        CONSTRAINT [PK_AuditoriaSesion] PRIMARY KEY CLUSTERED
        (
            [IdAuditoriaSesion] ASC
        )
        WITH
        (
            PAD_INDEX = OFF,
            STATISTICS_NORECOMPUTE = OFF,
            IGNORE_DUP_KEY = OFF,
            ALLOW_ROW_LOCKS = ON,
            ALLOW_PAGE_LOCKS = ON,
            OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
        ) ON [PRIMARY]
    ) ON [PRIMARY];
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.default_constraints
    WHERE name = 'DF_AuditoriaSesion_Fecha'
      AND parent_object_id = OBJECT_ID('[dbo].[AuditoriaSesion]')
)
BEGIN
    ALTER TABLE [dbo].[AuditoriaSesion]
    ADD CONSTRAINT [DF_AuditoriaSesion_Fecha]
    DEFAULT (SYSUTCDATETIME()) FOR [Fecha];
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.default_constraints
    WHERE name = 'DF_AuditoriaSesion_Exitoso'
      AND parent_object_id = OBJECT_ID('[dbo].[AuditoriaSesion]')
)
BEGIN
    ALTER TABLE [dbo].[AuditoriaSesion]
    ADD CONSTRAINT [DF_AuditoriaSesion_Exitoso]
    DEFAULT ((1)) FOR [Exitoso];
END;
GO

/* =========================================================
   HU-005
   TABLA: Empresas
   Administración de empresas para el área de facturación.
   ========================================================= */

IF OBJECT_ID('[dbo].[Empresas]', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Empresas]
    (
        [IdEmpresa] [int] IDENTITY(1,1) NOT NULL,
        [Nit] [nvarchar](30) NOT NULL,
        [RazonSocial] [nvarchar](200) NOT NULL,
        [Direccion] [nvarchar](250) NOT NULL,
        [Cliente] [nvarchar](200) NOT NULL,
        [Telefono] [nvarchar](50) NOT NULL,
        [ComercialPositivo] [nvarchar](150) NOT NULL,
        [Supervisor] [nvarchar](150) NOT NULL,
        [CR] [nvarchar](50) NOT NULL,
        [Ciudad] [nvarchar](100) NOT NULL,
        [Moneda] [nvarchar](20) NOT NULL,
        [UsuarioCreacion] [nvarchar](100) NOT NULL,
        [FechaCreacion] [datetime2](7) NOT NULL,
        [UsuarioModificacion] [nvarchar](100) NULL,
        [FechaModificacion] [datetime2](7) NULL,
        [Estado] [bit] NOT NULL,

        CONSTRAINT [PK_Empresas] PRIMARY KEY CLUSTERED
        (
            [IdEmpresa] ASC
        )
        WITH
        (
            PAD_INDEX = OFF,
            STATISTICS_NORECOMPUTE = OFF,
            IGNORE_DUP_KEY = OFF,
            ALLOW_ROW_LOCKS = ON,
            ALLOW_PAGE_LOCKS = ON,
            OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
        ) ON [PRIMARY]
    ) ON [PRIMARY];
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.key_constraints
    WHERE name = 'UQ_Empresas_Nit'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    ADD CONSTRAINT [UQ_Empresas_Nit]
    UNIQUE ([Nit]);
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.default_constraints
    WHERE name = 'DF_Empresas_FechaCreacion'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    ADD CONSTRAINT [DF_Empresas_FechaCreacion]
    DEFAULT (SYSUTCDATETIME()) FOR [FechaCreacion];
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.default_constraints
    WHERE name = 'DF_Empresas_Estado'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    ADD CONSTRAINT [DF_Empresas_Estado]
    DEFAULT ((1)) FOR [Estado];
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_Empresas_Nit_NoVacio'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    WITH CHECK ADD CONSTRAINT [CK_Empresas_Nit_NoVacio]
    CHECK ((LTRIM(RTRIM([Nit])) <> ''));
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_Empresas_RazonSocial_NoVacio'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    WITH CHECK ADD CONSTRAINT [CK_Empresas_RazonSocial_NoVacio]
    CHECK ((LTRIM(RTRIM([RazonSocial])) <> ''));
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_Empresas_Direccion_NoVacio'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    WITH CHECK ADD CONSTRAINT [CK_Empresas_Direccion_NoVacio]
    CHECK ((LTRIM(RTRIM([Direccion])) <> ''));
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_Empresas_Cliente_NoVacio'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    WITH CHECK ADD CONSTRAINT [CK_Empresas_Cliente_NoVacio]
    CHECK ((LTRIM(RTRIM([Cliente])) <> ''));
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_Empresas_Telefono_NoVacio'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    WITH CHECK ADD CONSTRAINT [CK_Empresas_Telefono_NoVacio]
    CHECK ((LTRIM(RTRIM([Telefono])) <> ''));
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_Empresas_ComercialPositivo_NoVacio'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    WITH CHECK ADD CONSTRAINT [CK_Empresas_ComercialPositivo_NoVacio]
    CHECK ((LTRIM(RTRIM([ComercialPositivo])) <> ''));
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_Empresas_Supervisor_NoVacio'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    WITH CHECK ADD CONSTRAINT [CK_Empresas_Supervisor_NoVacio]
    CHECK ((LTRIM(RTRIM([Supervisor])) <> ''));
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_Empresas_CR_NoVacio'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    WITH CHECK ADD CONSTRAINT [CK_Empresas_CR_NoVacio]
    CHECK ((LTRIM(RTRIM([CR])) <> ''));
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_Empresas_Ciudad_NoVacio'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    WITH CHECK ADD CONSTRAINT [CK_Empresas_Ciudad_NoVacio]
    CHECK ((LTRIM(RTRIM([Ciudad])) <> ''));
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_Empresas_Moneda_NoVacio'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    WITH CHECK ADD CONSTRAINT [CK_Empresas_Moneda_NoVacio]
    CHECK ((LTRIM(RTRIM([Moneda])) <> ''));
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_Empresas_UsuarioCreacion_NoVacio'
      AND parent_object_id = OBJECT_ID('[dbo].[Empresas]')
)
BEGIN
    ALTER TABLE [dbo].[Empresas]
    WITH CHECK ADD CONSTRAINT [CK_Empresas_UsuarioCreacion_NoVacio]
    CHECK ((LTRIM(RTRIM([UsuarioCreacion])) <> ''));
END;
GO

/* =========================================================
   HU-002
   PROCEDIMIENTO: sp_RegistrarSesion
   ========================================================= */

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_RegistrarSesion]
    @NombreUsuario NVARCHAR(100),
    @Apellido NVARCHAR(100) = NULL,
    @Motivo NVARCHAR(250),
    @Rol NVARCHAR(50) = NULL,
    @Exitoso BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @NombreUsuario IS NULL OR LTRIM(RTRIM(@NombreUsuario)) = ''
        BEGIN
            SELECT
                CAST(0 AS BIT) AS Exito,
                'El nombre de usuario es obligatorio.' AS Mensaje,
                NULL AS IdAuditoriaSesion,
                NULL AS Fecha;
            RETURN;
        END;

        IF @Motivo IS NULL OR LTRIM(RTRIM(@Motivo)) = ''
        BEGIN
            SELECT
                CAST(0 AS BIT) AS Exito,
                'El motivo de la sesión es obligatorio.' AS Mensaje,
                NULL AS IdAuditoriaSesion,
                NULL AS Fecha;
            RETURN;
        END;

        DECLARE @Fecha DATETIME2(7) = SYSUTCDATETIME();

        INSERT INTO [dbo].[AuditoriaSesion]
        (
            [NombreUsuario],
            [Apellido],
            [Fecha],
            [Exitoso],
            [Motivo],
            [Rol]
        )
        VALUES
        (
            LTRIM(RTRIM(@NombreUsuario)),
            NULLIF(LTRIM(RTRIM(ISNULL(@Apellido, ''))), ''),
            @Fecha,
            @Exitoso,
            LTRIM(RTRIM(@Motivo)),
            NULLIF(LTRIM(RTRIM(ISNULL(@Rol, ''))), '')
        );

        SELECT
            CAST(1 AS BIT) AS Exito,
            'Auditoría de sesión registrada correctamente.' AS Mensaje,
            SCOPE_IDENTITY() AS IdAuditoriaSesion,
            @Fecha AS Fecha;
    END TRY
    BEGIN CATCH
        SELECT
            CAST(0 AS BIT) AS Exito,
            ERROR_MESSAGE() AS Mensaje,
            NULL AS IdAuditoriaSesion,
            NULL AS Fecha;
    END CATCH
END;
GO

/* =========================================================
   HU-005
   PROCEDIMIENTO: sp_CrearEmpresa
   ========================================================= */

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_CrearEmpresa]
    @Nit NVARCHAR(30),
    @RazonSocial NVARCHAR(200),
    @Direccion NVARCHAR(250),
    @Cliente NVARCHAR(200),
    @Telefono NVARCHAR(50),
    @ComercialPositivo NVARCHAR(150),
    @Supervisor NVARCHAR(150),
    @CR NVARCHAR(50),
    @Ciudad NVARCHAR(100),
    @Moneda NVARCHAR(20),
    @UsuarioCreacion NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @Nit IS NULL OR LTRIM(RTRIM(@Nit)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El NIT es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @RazonSocial IS NULL OR LTRIM(RTRIM(@RazonSocial)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'La razón social es obligatoria.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @Direccion IS NULL OR LTRIM(RTRIM(@Direccion)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'La dirección es obligatoria.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @Cliente IS NULL OR LTRIM(RTRIM(@Cliente)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El cliente es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @Telefono IS NULL OR LTRIM(RTRIM(@Telefono)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El teléfono es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @ComercialPositivo IS NULL OR LTRIM(RTRIM(@ComercialPositivo)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El comercial Positivo es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @Supervisor IS NULL OR LTRIM(RTRIM(@Supervisor)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El supervisor es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @CR IS NULL OR LTRIM(RTRIM(@CR)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El CR es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @Ciudad IS NULL OR LTRIM(RTRIM(@Ciudad)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'La ciudad es obligatoria.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @Moneda IS NULL OR LTRIM(RTRIM(@Moneda)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'La moneda es obligatoria.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @UsuarioCreacion IS NULL OR LTRIM(RTRIM(@UsuarioCreacion)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El usuario de creación es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF EXISTS
        (
            SELECT 1
            FROM [dbo].[Empresas]
            WHERE [Nit] = LTRIM(RTRIM(@Nit))
        )
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'Ya existe una empresa registrada con el NIT indicado.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        INSERT INTO [dbo].[Empresas]
        (
            [Nit],
            [RazonSocial],
            [Direccion],
            [Cliente],
            [Telefono],
            [ComercialPositivo],
            [Supervisor],
            [CR],
            [Ciudad],
            [Moneda],
            [UsuarioCreacion],
            [FechaCreacion],
            [Estado]
        )
        VALUES
        (
            LTRIM(RTRIM(@Nit)),
            LTRIM(RTRIM(@RazonSocial)),
            LTRIM(RTRIM(@Direccion)),
            LTRIM(RTRIM(@Cliente)),
            LTRIM(RTRIM(@Telefono)),
            LTRIM(RTRIM(@ComercialPositivo)),
            LTRIM(RTRIM(@Supervisor)),
            LTRIM(RTRIM(@CR)),
            LTRIM(RTRIM(@Ciudad)),
            LTRIM(RTRIM(@Moneda)),
            LTRIM(RTRIM(@UsuarioCreacion)),
            SYSUTCDATETIME(),
            1
        );

        SELECT
            CAST(1 AS BIT) AS Exito,
            'Empresa creada correctamente.' AS Mensaje,
            SCOPE_IDENTITY() AS IdEmpresa;
    END TRY
    BEGIN CATCH
        SELECT
            CAST(0 AS BIT) AS Exito,
            ERROR_MESSAGE() AS Mensaje,
            NULL AS IdEmpresa;
    END CATCH
END;
GO

/* =========================================================
   HU-005
   PROCEDIMIENTO: sp_ActualizarEmpresa
   ========================================================= */

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_ActualizarEmpresa]
    @IdEmpresa INT,
    @Nit NVARCHAR(30),
    @RazonSocial NVARCHAR(200),
    @Direccion NVARCHAR(250),
    @Cliente NVARCHAR(200),
    @Telefono NVARCHAR(50),
    @ComercialPositivo NVARCHAR(150),
    @Supervisor NVARCHAR(150),
    @CR NVARCHAR(50),
    @Ciudad NVARCHAR(100),
    @Moneda NVARCHAR(20),
    @Estado BIT,
    @UsuarioModificacion NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @IdEmpresa IS NULL OR @IdEmpresa <= 0
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El identificador de la empresa es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF NOT EXISTS
        (
            SELECT 1
            FROM [dbo].[Empresas]
            WHERE [IdEmpresa] = @IdEmpresa
        )
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'La empresa indicada no existe.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @Nit IS NULL OR LTRIM(RTRIM(@Nit)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El NIT es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @RazonSocial IS NULL OR LTRIM(RTRIM(@RazonSocial)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'La razón social es obligatoria.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @Direccion IS NULL OR LTRIM(RTRIM(@Direccion)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'La dirección es obligatoria.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @Cliente IS NULL OR LTRIM(RTRIM(@Cliente)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El cliente es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @Telefono IS NULL OR LTRIM(RTRIM(@Telefono)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El teléfono es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @ComercialPositivo IS NULL OR LTRIM(RTRIM(@ComercialPositivo)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El comercial Positivo es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @Supervisor IS NULL OR LTRIM(RTRIM(@Supervisor)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El supervisor es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @CR IS NULL OR LTRIM(RTRIM(@CR)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El CR es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @Ciudad IS NULL OR LTRIM(RTRIM(@Ciudad)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'La ciudad es obligatoria.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @Moneda IS NULL OR LTRIM(RTRIM(@Moneda)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'La moneda es obligatoria.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF @UsuarioModificacion IS NULL OR LTRIM(RTRIM(@UsuarioModificacion)) = ''
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'El usuario de modificación es obligatorio.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        IF EXISTS
        (
            SELECT 1
            FROM [dbo].[Empresas]
            WHERE [Nit] = LTRIM(RTRIM(@Nit))
              AND [IdEmpresa] <> @IdEmpresa
        )
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'Ya existe otra empresa registrada con el NIT indicado.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        UPDATE [dbo].[Empresas]
        SET
            [Nit] = LTRIM(RTRIM(@Nit)),
            [RazonSocial] = LTRIM(RTRIM(@RazonSocial)),
            [Direccion] = LTRIM(RTRIM(@Direccion)),
            [Cliente] = LTRIM(RTRIM(@Cliente)),
            [Telefono] = LTRIM(RTRIM(@Telefono)),
            [ComercialPositivo] = LTRIM(RTRIM(@ComercialPositivo)),
            [Supervisor] = LTRIM(RTRIM(@Supervisor)),
            [CR] = LTRIM(RTRIM(@CR)),
            [Ciudad] = LTRIM(RTRIM(@Ciudad)),
            [Moneda] = LTRIM(RTRIM(@Moneda)),
            [Estado] = @Estado,
            [UsuarioModificacion] = LTRIM(RTRIM(@UsuarioModificacion)),
            [FechaModificacion] = SYSUTCDATETIME()
        WHERE [IdEmpresa] = @IdEmpresa;

        SELECT
            CAST(1 AS BIT) AS Exito,
            'Empresa actualizada correctamente.' AS Mensaje,
            @IdEmpresa AS IdEmpresa;
    END TRY
    BEGIN CATCH
        SELECT
            CAST(0 AS BIT) AS Exito,
            ERROR_MESSAGE() AS Mensaje,
            NULL AS IdEmpresa;
    END CATCH
END;
GO

/* =========================================================
   HU-005
   PROCEDIMIENTO: sp_ListarEmpresas
   ========================================================= */

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_ListarEmpresas]
    @Busqueda NVARCHAR(200) = NULL,
    @Pagina INT = 1,
    @CantidadRegistros INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @Pagina IS NULL OR @Pagina <= 0
        BEGIN
            SET @Pagina = 1;
        END;

        IF @CantidadRegistros IS NULL OR @CantidadRegistros <= 0
        BEGIN
            SET @CantidadRegistros = 10;
        END;

        DECLARE @Offset INT = (@Pagina - 1) * @CantidadRegistros;
        DECLARE @BusquedaNormalizada NVARCHAR(200) = NULL;

        IF @Busqueda IS NOT NULL AND LTRIM(RTRIM(@Busqueda)) <> ''
        BEGIN
            SET @BusquedaNormalizada = '%' + LTRIM(RTRIM(@Busqueda)) + '%';
        END;

        ;WITH EmpresasFiltradas AS
        (
            SELECT
                [IdEmpresa],
                [Nit],
                [RazonSocial],
                [Direccion],
                [Cliente],
                [Telefono],
                [ComercialPositivo],
                [Supervisor],
                [CR],
                [Ciudad],
                [Moneda],
                [UsuarioCreacion],
                [FechaCreacion],
                [UsuarioModificacion],
                [FechaModificacion],
                [Estado]
            FROM [dbo].[Empresas]
            WHERE
                @BusquedaNormalizada IS NULL
                OR [Nit] LIKE @BusquedaNormalizada
                OR [RazonSocial] LIKE @BusquedaNormalizada
                OR [Cliente] LIKE @BusquedaNormalizada
                OR [Ciudad] LIKE @BusquedaNormalizada
                OR [ComercialPositivo] LIKE @BusquedaNormalizada
                OR [Supervisor] LIKE @BusquedaNormalizada
                OR [CR] LIKE @BusquedaNormalizada
        )
        SELECT
            [IdEmpresa],
            [Nit],
            [RazonSocial],
            [Direccion],
            [Cliente],
            [Telefono],
            [ComercialPositivo],
            [Supervisor],
            [CR],
            [Ciudad],
            [Moneda],
            [UsuarioCreacion],
            [FechaCreacion],
            [UsuarioModificacion],
            [FechaModificacion],
            [Estado],
            COUNT(1) OVER() AS [TotalRegistros]
        FROM EmpresasFiltradas
        ORDER BY [IdEmpresa] DESC
        OFFSET @Offset ROWS
        FETCH NEXT @CantidadRegistros ROWS ONLY;
    END TRY
    BEGIN CATCH
        SELECT
            CAST(NULL AS INT) AS [IdEmpresa],
            CAST(NULL AS NVARCHAR(30)) AS [Nit],
            CAST(NULL AS NVARCHAR(200)) AS [RazonSocial],
            CAST(NULL AS NVARCHAR(250)) AS [Direccion],
            CAST(NULL AS NVARCHAR(200)) AS [Cliente],
            CAST(NULL AS NVARCHAR(50)) AS [Telefono],
            CAST(NULL AS NVARCHAR(150)) AS [ComercialPositivo],
            CAST(NULL AS NVARCHAR(150)) AS [Supervisor],
            CAST(NULL AS NVARCHAR(50)) AS [CR],
            CAST(NULL AS NVARCHAR(100)) AS [Ciudad],
            CAST(NULL AS NVARCHAR(20)) AS [Moneda],
            CAST(NULL AS NVARCHAR(100)) AS [UsuarioCreacion],
            CAST(NULL AS DATETIME2) AS [FechaCreacion],
            CAST(NULL AS NVARCHAR(100)) AS [UsuarioModificacion],
            CAST(NULL AS DATETIME2) AS [FechaModificacion],
            CAST(NULL AS BIT) AS [Estado],
            CAST(0 AS INT) AS [TotalRegistros];
    END CATCH
END;
GO

    --Guillermo:

--HU 006 06/07/2026
CREATE TABLE dbo.SolicitudesCargaDocumentos
(
    IdSolicitud INT IDENTITY(1,1) NOT NULL,

    Identificador UNIQUEIDENTIFIER NOT NULL
        CONSTRAINT DF_SolicitudesCargaDocumentos_Identificador
        DEFAULT NEWID(),

    IdEmpresa INT NOT NULL,

    CantidadArchivos INT NOT NULL,

    Estado NVARCHAR(20) NOT NULL
        CONSTRAINT DF_SolicitudesCargaDocumentos_Estado
        DEFAULT 'Activo',

    UsuarioCreacion NVARCHAR(100) NOT NULL,

    FechaCreacion DATETIME2 NOT NULL
        CONSTRAINT DF_SolicitudesCargaDocumentos_FechaCreacion
        DEFAULT SYSUTCDATETIME(),

    UsuarioModificacion NVARCHAR(100) NULL,

    FechaModificacion DATETIME2 NULL,

    CONSTRAINT PK_SolicitudesCargaDocumentos
        PRIMARY KEY (IdSolicitud),

    CONSTRAINT FK_SolicitudesCargaDocumentos_Empresas
        FOREIGN KEY (IdEmpresa)
        REFERENCES Empresas(IdEmpresa),

    CONSTRAINT CK_SolicitudesCargaDocumentos_Cantidad
        CHECK (CantidadArchivos > 0),

    CONSTRAINT CK_SolicitudesCargaDocumentos_UsuarioCreacion
        CHECK (LTRIM(RTRIM(UsuarioCreacion)) <> ''),

    CONSTRAINT CK_SolicitudesCargaDocumentos_Estado
        CHECK
        (
            Estado IN
            (
                'Activo',
                'Inactivo',
                'Procesado',
                'Facturado',
                'Inconsistencia'
            )
        )
);

-----------------------------------------------------
CREATE TABLE dbo.SolicitudCargaDocumentoArchivos
    (
        IdArchivo INT IDENTITY(1,1) NOT NULL,

        IdSolicitud INT NOT NULL,

        NombreOriginal NVARCHAR(300) NOT NULL,

        NombreServidor NVARCHAR(300) NOT NULL,

        Ruta NVARCHAR(500) NOT NULL,

        Extension NVARCHAR(10) NOT NULL,

        Tamano BIGINT NOT NULL,

        FechaCreacion DATETIME2 NOT NULL
            CONSTRAINT DF_SolicitudCargaDocumentoArchivos_FechaCreacion
            DEFAULT SYSUTCDATETIME(),

        CONSTRAINT PK_SolicitudCargaDocumentoArchivos
            PRIMARY KEY (IdArchivo),

        CONSTRAINT FK_SolicitudCargaDocumentoArchivos_Solicitud
            FOREIGN KEY (IdSolicitud)
            REFERENCES SolicitudesCargaDocumentos(IdSolicitud)
            ON DELETE CASCADE
    );

-----------------------------------------------
CREATE OR ALTER PROCEDURE sp_ConsultarDocumentos
AS
BEGIN

    SET NOCOUNT ON;

    SELECT

        s.IdSolicitud,

        s.Identificador,

        e.IdEmpresa,

        e.Nit,

        e.RazonSocial AS Empresa,

        s.CantidadArchivos,

        s.UsuarioCreacion,

        s.FechaCreacion,

        s.UsuarioModificacion,

        s.FechaModificacion,

        s.Estado

    FROM SolicitudesCargaDocumentos s

    INNER JOIN Empresas e
        ON e.IdEmpresa = s.IdEmpresa

    ORDER BY s.FechaCreacion DESC;

END
GO

---------------------------------------------------
CREATE OR ALTER PROCEDURE sp_CrearDocumento
(
    @IdEmpresa INT,
    @CantidadArchivos INT,
    @UsuarioCreacion NVARCHAR(100)
)
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO SolicitudesCargaDocumentos
    (
        IdEmpresa,
        CantidadArchivos,
        UsuarioCreacion
    )
    VALUES
    (
        @IdEmpresa,
        @CantidadArchivos,
        @UsuarioCreacion
    );

    SELECT SCOPE_IDENTITY();

END
GO
-----------------------------------------------------
CREATE OR ALTER PROCEDURE sp_CrearDocumentoArchivo
(
    @IdSolicitud INT,
    @NombreOriginal NVARCHAR(300),
    @NombreServidor NVARCHAR(300),
    @Ruta NVARCHAR(500),
    @Extension NVARCHAR(10),
    @Tamano BIGINT
)
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO SolicitudCargaDocumentoArchivos
    (
        IdSolicitud,
        NombreOriginal,
        NombreServidor,
        Ruta,
        Extension,
        Tamano
    )
    VALUES
    (
        @IdSolicitud,
        @NombreOriginal,
        @NombreServidor,
        @Ruta,
        @Extension,
        @Tamano
    );

END
GO
--------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_ActualizarDocumento
(
    @IdSolicitud INT,
    @IdEmpresa INT,
    @Estado NVARCHAR(20),
    @CantidadArchivos INT,
    @UsuarioModificacion NVARCHAR(100)
)
AS
BEGIN

    SET NOCOUNT ON;

    UPDATE SolicitudesCargaDocumentos
    SET

        IdEmpresa = @IdEmpresa,

        Estado = @Estado,

        CantidadArchivos =
            CASE
                WHEN @CantidadArchivos > 0
                    THEN @CantidadArchivos
                ELSE CantidadArchivos
            END,

        UsuarioModificacion = @UsuarioModificacion,

        FechaModificacion = GETDATE()

    WHERE IdSolicitud = @IdSolicitud;

END
GO
----------------------------------------------------
CREATE OR ALTER PROCEDURE sp_EliminarDocumentoArchivos
(
    @IdSolicitud INT
)
AS
BEGIN

    SET NOCOUNT ON;

    DELETE
    FROM SolicitudCargaDocumentoArchivos
    WHERE IdSolicitud = @IdSolicitud;

END
GO
    
/* =========================================================
   HU-008
   TABLA: RegistrosFacturacion
   Consulta y descarga de registros para facturación.
   Reutiliza la tabla Empresas de HU-005.
   ========================================================= */

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[RegistrosFacturacion]', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[RegistrosFacturacion]
    (
        [IdRegistroFacturacion] INT IDENTITY(1,1) NOT NULL,
        [NumeroRegistro] NVARCHAR(50) NOT NULL,
        [IdEmpresa] INT NOT NULL,
        [FechaCreacion] DATETIME2(0) NOT NULL,
        [Descripcion] NVARCHAR(300) NOT NULL,
        [Valor] DECIMAL(18,2) NOT NULL,
        [Estado] NVARCHAR(20) NOT NULL,
        [UsuarioCreacion] NVARCHAR(100) NOT NULL,
        [FechaModificacion] DATETIME2(0) NULL,
        [UsuarioModificacion] NVARCHAR(100) NULL,
        [Activo] BIT NOT NULL,
        [IdSolicitud] INT NULL,
        [Moneda] NVARCHAR(10) NOT NULL,

        CONSTRAINT PK_RegistrosFacturacion
            PRIMARY KEY CLUSTERED (IdRegistroFacturacion)
    );
END;
GO

/* =========================================================
   DEFAULTS
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.default_constraints
    WHERE name = 'DF_RegistrosFacturacion_FechaCreacion'
)
BEGIN
    ALTER TABLE dbo.RegistrosFacturacion
    ADD CONSTRAINT DF_RegistrosFacturacion_FechaCreacion
    DEFAULT (SYSUTCDATETIME()) FOR FechaCreacion;
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.default_constraints
    WHERE name = 'DF_RegistrosFacturacion_Estado'
)
BEGIN
    ALTER TABLE dbo.RegistrosFacturacion
    ADD CONSTRAINT DF_RegistrosFacturacion_Estado
    DEFAULT ('PROCESADO') FOR Estado;
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.default_constraints
    WHERE name = 'DF_RegistrosFacturacion_Activo'
)
BEGIN
    ALTER TABLE dbo.RegistrosFacturacion
    ADD CONSTRAINT DF_RegistrosFacturacion_Activo
    DEFAULT ((1)) FOR Activo;
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.default_constraints
    WHERE name = 'DF_RegistrosFacturacion_Moneda'
)
BEGIN
    ALTER TABLE dbo.RegistrosFacturacion
    ADD CONSTRAINT DF_RegistrosFacturacion_Moneda
    DEFAULT ('COP') FOR Moneda;
END;
GO

/* =========================================================
   FOREIGN KEYS
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_RegistrosFacturacion_Empresas'
)
BEGIN
    ALTER TABLE dbo.RegistrosFacturacion
    WITH CHECK ADD CONSTRAINT FK_RegistrosFacturacion_Empresas
    FOREIGN KEY (IdEmpresa)
    REFERENCES dbo.Empresas(IdEmpresa);
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_RegistrosFacturacion_SolicitudesCargaDocumentos'
)
BEGIN
    ALTER TABLE dbo.RegistrosFacturacion
    WITH CHECK ADD CONSTRAINT FK_RegistrosFacturacion_SolicitudesCargaDocumentos
    FOREIGN KEY (IdSolicitud)
    REFERENCES dbo.SolicitudesCargaDocumentos(IdSolicitud);
END;
GO

/* =========================================================
   CHECKS
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_RegistrosFacturacion_Estado'
)
BEGIN
    ALTER TABLE dbo.RegistrosFacturacion
    WITH CHECK ADD CONSTRAINT CK_RegistrosFacturacion_Estado
    CHECK (Estado IN ('PROCESADO','FACTURADO'));
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_RegistrosFacturacion_Moneda'
)
BEGIN
    ALTER TABLE dbo.RegistrosFacturacion
    WITH CHECK ADD CONSTRAINT CK_RegistrosFacturacion_Moneda
    CHECK (Moneda IN ('COP','USD','SOL'));
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_RegistrosFacturacion_Valor'
)
BEGIN
    ALTER TABLE dbo.RegistrosFacturacion
    WITH CHECK ADD CONSTRAINT CK_RegistrosFacturacion_Valor
    CHECK (Valor >= 0);
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_RegistrosFacturacion_NumeroRegistro_NoVacio'
)
BEGIN
    ALTER TABLE dbo.RegistrosFacturacion
    WITH CHECK ADD CONSTRAINT CK_RegistrosFacturacion_NumeroRegistro_NoVacio
    CHECK (LTRIM(RTRIM(NumeroRegistro)) <> '');
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_RegistrosFacturacion_Descripcion_NoVacio'
)
BEGIN
    ALTER TABLE dbo.RegistrosFacturacion
    WITH CHECK ADD CONSTRAINT CK_RegistrosFacturacion_Descripcion_NoVacio
    CHECK (LTRIM(RTRIM(Descripcion)) <> '');
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_RegistrosFacturacion_UsuarioCreacion_NoVacio'
)
BEGIN
    ALTER TABLE dbo.RegistrosFacturacion
    WITH CHECK ADD CONSTRAINT CK_RegistrosFacturacion_UsuarioCreacion_NoVacio
    CHECK (LTRIM(RTRIM(UsuarioCreacion)) <> '');
END;
GO

/* =========================================================
   ÍNDICES
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_RegistrosFacturacion_Filtros'
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_RegistrosFacturacion_Filtros
    ON dbo.RegistrosFacturacion
    (
        Activo,
        Estado,
        FechaCreacion,
        IdEmpresa
    )
    INCLUDE
    (
        NumeroRegistro,
        Descripcion,
        Valor,
        Moneda
    );
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_RegistrosFacturacion_IdEmpresa'
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_RegistrosFacturacion_IdEmpresa
    ON dbo.RegistrosFacturacion(IdEmpresa);
END;
GO

/* =========================================================
   HU-008
   ÍNDICES: RegistrosFacturacion
   Mejoran búsqueda por estado, fecha, empresa y registros activos.
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_RegistrosFacturacion_Filtros'
      AND object_id = OBJECT_ID('[dbo].[RegistrosFacturacion]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_RegistrosFacturacion_Filtros]
    ON [dbo].[RegistrosFacturacion]
    (
        [Activo],
        [Estado],
        [FechaCreacion],
        [IdEmpresa]
    )
    INCLUDE
    (
        [NumeroRegistro],
        [Descripcion],
        [Valor]
    );
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_RegistrosFacturacion_IdEmpresa'
      AND object_id = OBJECT_ID('[dbo].[RegistrosFacturacion]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_RegistrosFacturacion_IdEmpresa]
    ON [dbo].[RegistrosFacturacion]
    (
        [IdEmpresa]
    );
END;
GO

/* =========================================================
   HU-008
   PROCEDIMIENTO: sp_ListarRegistrosFacturacion
   Consulta registros con búsqueda, estado, fechas y paginación.
   ========================================================= */

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_ListarRegistrosFacturacion]
    @Busqueda NVARCHAR(200) = NULL,
    @Estado NVARCHAR(20) = NULL,
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL,
    @Pagina INT = 1,
    @CantidadRegistros INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @Pagina IS NULL OR @Pagina <= 0
        BEGIN
            SET @Pagina = 1;
        END;

        IF @CantidadRegistros IS NULL OR @CantidadRegistros <= 0
        BEGIN
            SET @CantidadRegistros = 10;
        END;

        IF @CantidadRegistros > 100
        BEGIN
            SET @CantidadRegistros = 100;
        END;

        DECLARE @Offset INT = (@Pagina - 1) * @CantidadRegistros;
        DECLARE @BusquedaNormalizada NVARCHAR(200) = NULL;
        DECLARE @EstadoNormalizado NVARCHAR(20) = NULL;

        IF @Busqueda IS NOT NULL AND LTRIM(RTRIM(@Busqueda)) <> ''
        BEGIN
            SET @BusquedaNormalizada = '%' + LTRIM(RTRIM(@Busqueda)) + '%';
        END;

        IF @Estado IS NOT NULL AND LTRIM(RTRIM(@Estado)) <> ''
        BEGIN
            SET @EstadoNormalizado = UPPER(LTRIM(RTRIM(@Estado)));
        END;

        ;WITH RegistrosFiltrados AS
        (
            SELECT
                RF.[IdRegistroFacturacion],
                RF.[NumeroRegistro],
                RF.[FechaCreacion],
                E.[RazonSocial],
                E.[Ciudad],
                RF.[Descripcion],
                RF.[Valor],
                RF.[Estado]
            FROM [dbo].[RegistrosFacturacion] RF
            INNER JOIN [dbo].[Empresas] E
                ON E.[IdEmpresa] = RF.[IdEmpresa]
            WHERE
                RF.[Activo] = 1
                AND E.[Estado] = 1
                AND (
                    @BusquedaNormalizada IS NULL
                    OR RF.[NumeroRegistro] LIKE @BusquedaNormalizada
                    OR E.[RazonSocial] LIKE @BusquedaNormalizada
                    OR E.[Ciudad] LIKE @BusquedaNormalizada
                    OR RF.[Descripcion] LIKE @BusquedaNormalizada
                )
                AND (
                    @EstadoNormalizado IS NULL
                    OR RF.[Estado] = @EstadoNormalizado
                )
                AND (
                    @FechaInicio IS NULL
                    OR CAST(RF.[FechaCreacion] AS DATE) >= @FechaInicio
                )
                AND (
                    @FechaFin IS NULL
                    OR CAST(RF.[FechaCreacion] AS DATE) <= @FechaFin
                )
        )
        SELECT
            [IdRegistroFacturacion],
            [NumeroRegistro],
            [FechaCreacion],
            [RazonSocial],
            [Ciudad],
            [Descripcion],
            [Valor],
            [Estado],
            COUNT(1) OVER() AS [TotalRegistros]
        FROM RegistrosFiltrados
        ORDER BY [FechaCreacion] DESC, [IdRegistroFacturacion] DESC
        OFFSET @Offset ROWS
        FETCH NEXT @CantidadRegistros ROWS ONLY;
    END TRY
    BEGIN CATCH
        SELECT
            CAST(NULL AS INT) AS [IdRegistroFacturacion],
            CAST(NULL AS NVARCHAR(50)) AS [NumeroRegistro],
            CAST(NULL AS DATETIME2) AS [FechaCreacion],
            CAST(NULL AS NVARCHAR(200)) AS [RazonSocial],
            CAST(NULL AS NVARCHAR(100)) AS [Ciudad],
            CAST(NULL AS NVARCHAR(300)) AS [Descripcion],
            CAST(NULL AS DECIMAL(18,2)) AS [Valor],
            CAST(NULL AS NVARCHAR(20)) AS [Estado],
            CAST(0 AS INT) AS [TotalRegistros];
    END CATCH
END;
GO

/* =========================================================
   HU-008
   PROCEDIMIENTO: sp_ObtenerRegistrosFacturacionPorIds
   Consulta los registros seleccionados para exportación.
   ========================================================= */

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_ObtenerRegistrosFacturacionPorIds]
    @Ids NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        ;WITH IdsSeleccionados AS
        (
            SELECT DISTINCT
                TRY_CAST([value] AS INT) AS [IdRegistroFacturacion]
            FROM STRING_SPLIT(@Ids, ',')
            WHERE TRY_CAST([value] AS INT) IS NOT NULL
        )
        SELECT
            RF.[IdRegistroFacturacion],
            RF.[NumeroRegistro],
            RF.[FechaCreacion],
            E.[RazonSocial],
            E.[Ciudad],
            RF.[Descripcion],
            RF.[Valor],
            RF.[Estado]
        FROM [dbo].[RegistrosFacturacion] RF
        INNER JOIN [dbo].[Empresas] E
            ON E.[IdEmpresa] = RF.[IdEmpresa]
        INNER JOIN IdsSeleccionados IDS
            ON IDS.[IdRegistroFacturacion] = RF.[IdRegistroFacturacion]
        WHERE
            RF.[Activo] = 1
            AND E.[Estado] = 1
        ORDER BY RF.[FechaCreacion] DESC, RF.[IdRegistroFacturacion] DESC;
    END TRY
    BEGIN CATCH
        SELECT
            CAST(NULL AS INT) AS [IdRegistroFacturacion],
            CAST(NULL AS NVARCHAR(50)) AS [NumeroRegistro],
            CAST(NULL AS DATETIME2) AS [FechaCreacion],
            CAST(NULL AS NVARCHAR(200)) AS [RazonSocial],
            CAST(NULL AS NVARCHAR(100)) AS [Ciudad],
            CAST(NULL AS NVARCHAR(300)) AS [Descripcion],
            CAST(NULL AS DECIMAL(18,2)) AS [Valor],
            CAST(NULL AS NVARCHAR(20)) AS [Estado];
    END CATCH
END;
GO


/* ============================================================
   HU-008 - REGISTROS PARA FACTURACIÓN
   Ajustes incluidos en esta historia:
   1. Listado de registros para facturación con:
      - búsqueda
      - filtro por estado
      - filtro por rango de fechas
      - paginación
      - soporte de moneda
   2. Exportación de registros seleccionados por Ids con soporte de moneda
   ============================================================ */

USE [FacturacionIA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* ============================================================
   HU-008 - Listar registros para facturación
   Procedimiento: dbo.sp_ListarRegistrosFacturacion
   ============================================================ */
ALTER PROCEDURE [dbo].[sp_ListarRegistrosFacturacion]
    @Busqueda NVARCHAR(200) = NULL,
    @Estado NVARCHAR(20) = NULL,
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL,
    @Pagina INT = 1,
    @CantidadRegistros INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF @Pagina <= 0
        SET @Pagina = 1;

    IF @CantidadRegistros <= 0
        SET @CantidadRegistros = 10;

    IF @CantidadRegistros > 100
        SET @CantidadRegistros = 100;

    SET @Busqueda = NULLIF(LTRIM(RTRIM(@Busqueda)), '');
    SET @Estado = NULLIF(UPPER(LTRIM(RTRIM(@Estado))), '');

    ;WITH RegistrosFiltrados AS
    (
        SELECT
            RF.IdRegistroFacturacion,
            RF.NumeroRegistro,
            RF.FechaCreacion,
            E.RazonSocial,
            E.Ciudad,
            RF.Descripcion,
            RF.Valor,
            RF.Moneda,
            RF.Estado
        FROM dbo.RegistrosFacturacion RF
        INNER JOIN dbo.Empresas E
            ON E.IdEmpresa = RF.IdEmpresa
        WHERE
            RF.Activo = 1
            AND E.Estado = 1
            AND (
                @Busqueda IS NULL
                OR RF.NumeroRegistro LIKE '%' + @Busqueda + '%'
                OR E.RazonSocial LIKE '%' + @Busqueda + '%'
                OR E.Ciudad LIKE '%' + @Busqueda + '%'
                OR RF.Descripcion LIKE '%' + @Busqueda + '%'
            )
            AND (
                @Estado IS NULL
                OR RF.Estado = @Estado
            )
            AND (
                @FechaInicio IS NULL
                OR CAST(RF.FechaCreacion AS DATE) >= @FechaInicio
            )
            AND (
                @FechaFin IS NULL
                OR CAST(RF.FechaCreacion AS DATE) <= @FechaFin
            )
    )
    SELECT
        IdRegistroFacturacion,
        NumeroRegistro,
        FechaCreacion,
        RazonSocial,
        Ciudad,
        Descripcion,
        Valor,
        Moneda,
        Estado,
        COUNT(1) OVER() AS TotalRegistros
    FROM RegistrosFiltrados
    ORDER BY FechaCreacion DESC, IdRegistroFacturacion DESC
    OFFSET (@Pagina - 1) * @CantidadRegistros ROWS
    FETCH NEXT @CantidadRegistros ROWS ONLY;
END;
GO


/* ============================================================
   HU-008 - Obtener registros para exportación
   Procedimiento: dbo.sp_ObtenerRegistrosFacturacionPorIds
   ============================================================ */
ALTER PROCEDURE [dbo].[sp_ObtenerRegistrosFacturacionPorIds]
    @Ids NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH IdsSeleccionados AS
    (
        SELECT DISTINCT
            TRY_CAST(value AS INT) AS IdRegistroFacturacion
        FROM STRING_SPLIT(@Ids, ',')
        WHERE TRY_CAST(value AS INT) IS NOT NULL
    )
    SELECT
        RF.IdRegistroFacturacion,
        RF.NumeroRegistro,
        RF.FechaCreacion,
        E.RazonSocial,
        E.Ciudad,
        RF.Descripcion,
        RF.Valor,
        RF.Moneda,
        RF.Estado
    FROM dbo.RegistrosFacturacion RF
    INNER JOIN dbo.Empresas E
        ON E.IdEmpresa = RF.IdEmpresa
    INNER JOIN IdsSeleccionados IDS
        ON IDS.IdRegistroFacturacion = RF.IdRegistroFacturacion
    WHERE
        RF.Activo = 1
        AND E.Estado = 1
    ORDER BY RF.FechaCreacion DESC, RF.IdRegistroFacturacion DESC;
END;
GO

/* ============================================================
   HU-005 / HU-008
   TABLA: Monedas
   Catálogo de monedas disponibles para empresas y registros.
   ============================================================ */

IF OBJECT_ID('[dbo].[Monedas]', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Monedas]
    (
        IdMoneda INT IDENTITY(1,1) PRIMARY KEY,
        Moneda VARCHAR(10) NOT NULL,
        UsuarioRegistro VARCHAR(30) NOT NULL,
        FechaRegistro DATETIME NOT NULL,
        UsuarioModificacion VARCHAR(30) NULL,
        FechaModificacion DATETIME NULL,
        Estado BIT NOT NULL
    );
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM [dbo].[Monedas]
    WHERE Moneda = 'COP'
)
BEGIN
    INSERT INTO [dbo].[Monedas]
    (
        Moneda,
        UsuarioRegistro,
        FechaRegistro,
        Estado
    )
    VALUES
    (
        'COP',
        'Jhon Cuervo',
        GETDATE(),
        1
    );
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM [dbo].[Monedas]
    WHERE Moneda = 'USD'
)
BEGIN
    INSERT INTO [dbo].[Monedas]
    (
        Moneda,
        UsuarioRegistro,
        FechaRegistro,
        Estado
    )
    VALUES
    (
        'USD',
        'Jhon Cuervo',
        GETDATE(),
        1
    );
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM [dbo].[Monedas]
    WHERE Moneda = 'PEN'
)
BEGIN
    INSERT INTO [dbo].[Monedas]
    (
        Moneda,
        UsuarioRegistro,
        FechaRegistro,
        Estado
    )
    VALUES
    (
        'PEN',
        'Jhon Cuervo',
        GETDATE(),
        1
    );
END;
GO

/* ============================================================
   HU-005 / HU-008
   PROCEDIMIENTO: dbo.sp_ListarMonedas
   Lista monedas activas para desplegables.
   ============================================================ */

CREATE OR ALTER PROCEDURE [dbo].[sp_ListarMonedas]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdMoneda,
        Moneda,
        UsuarioRegistro,
        FechaRegistro,
        UsuarioModificacion,
        FechaModificacion,
        Estado
    FROM [dbo].[Monedas]
    WHERE Estado = 1
    ORDER BY Moneda ASC;
END;
GO
