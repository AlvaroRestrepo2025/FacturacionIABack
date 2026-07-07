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
/*==============================================================
TABLA: SolicitudesCargaDocumentos
==============================================================*/

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
        REFERENCES dbo.Empresas(IdEmpresa),

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
GO

/*==============================================================
TABLA: SolicitudCargaDocumentoArchivos
==============================================================*/

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
        REFERENCES dbo.SolicitudesCargaDocumentos(IdSolicitud)
        ON DELETE CASCADE
);
GO

/*==============================================================
SP: Consultar Documentos
==============================================================*/

CREATE OR ALTER PROCEDURE dbo.sp_ConsultarDocumentos
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
    FROM dbo.SolicitudesCargaDocumentos s
    INNER JOIN dbo.Empresas e
        ON e.IdEmpresa = s.IdEmpresa
    ORDER BY s.FechaCreacion DESC;
END;
GO

/*==============================================================
SP: Crear Documento
==============================================================*/

CREATE OR ALTER PROCEDURE dbo.sp_CrearDocumento
(
    @IdEmpresa INT,
    @CantidadArchivos INT,
    @UsuarioCreacion NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.SolicitudesCargaDocumentos
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

    SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdSolicitud;
END;
GO

/*==============================================================
SP: Crear Documento Archivo
==============================================================*/

CREATE OR ALTER PROCEDURE dbo.sp_CrearDocumentoArchivo
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

    INSERT INTO dbo.SolicitudCargaDocumentoArchivos
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
END;
GO

/*==============================================================
SP: Actualizar Documento
==============================================================*/

CREATE OR ALTER PROCEDURE dbo.sp_ActualizarDocumento
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

    UPDATE dbo.SolicitudesCargaDocumentos
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

        FechaModificacion = SYSUTCDATETIME()
    WHERE IdSolicitud = @IdSolicitud;
END;
GO

/*==============================================================
SP: Eliminar Archivos de una Solicitud
==============================================================*/

CREATE OR ALTER PROCEDURE dbo.sp_EliminarDocumentoArchivos
(
    @IdSolicitud INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE
    FROM dbo.SolicitudCargaDocumentoArchivos
    WHERE IdSolicitud = @IdSolicitud;
END;
GO
