USE FacturacionIA;
GO

CREATE OR ALTER PROCEDURE dbo.sp_ListarEmpresas
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
                IdEmpresa,
                Nit,
                RazonSocial,
                Direccion,
                Cliente,
                Telefono,
                ComercialPositivo,
                Supervisor,
                CR,
                Ciudad,
                Moneda,
                UsuarioCreacion,
                FechaCreacion,
                UsuarioModificacion,
                FechaModificacion,
                Estado
            FROM dbo.Empresas
            WHERE
                @BusquedaNormalizada IS NULL
                OR Nit LIKE @BusquedaNormalizada
                OR RazonSocial LIKE @BusquedaNormalizada
                OR Cliente LIKE @BusquedaNormalizada
                OR Ciudad LIKE @BusquedaNormalizada
                OR ComercialPositivo LIKE @BusquedaNormalizada
                OR Supervisor LIKE @BusquedaNormalizada
                OR CR LIKE @BusquedaNormalizada
        )
        SELECT
            IdEmpresa,
            Nit,
            RazonSocial,
            Direccion,
            Cliente,
            Telefono,
            ComercialPositivo,
            Supervisor,
            CR,
            Ciudad,
            Moneda,
            UsuarioCreacion,
            FechaCreacion,
            UsuarioModificacion,
            FechaModificacion,
            Estado,
            COUNT(1) OVER() AS TotalRegistros
        FROM EmpresasFiltradas
        ORDER BY IdEmpresa DESC
        OFFSET @Offset ROWS
        FETCH NEXT @CantidadRegistros ROWS ONLY;
    END TRY
    BEGIN CATCH
        SELECT
            CAST(NULL AS INT) AS IdEmpresa,
            CAST(NULL AS NVARCHAR(30)) AS Nit,
            CAST(NULL AS NVARCHAR(200)) AS RazonSocial,
            CAST(NULL AS NVARCHAR(250)) AS Direccion,
            CAST(NULL AS NVARCHAR(200)) AS Cliente,
            CAST(NULL AS NVARCHAR(50)) AS Telefono,
            CAST(NULL AS NVARCHAR(150)) AS ComercialPositivo,
            CAST(NULL AS NVARCHAR(150)) AS Supervisor,
            CAST(NULL AS NVARCHAR(50)) AS CR,
            CAST(NULL AS NVARCHAR(100)) AS Ciudad,
            CAST(NULL AS NVARCHAR(20)) AS Moneda,
            CAST(NULL AS NVARCHAR(100)) AS UsuarioCreacion,
            CAST(NULL AS DATETIME2) AS FechaCreacion,
            CAST(NULL AS NVARCHAR(100)) AS UsuarioModificacion,
            CAST(NULL AS DATETIME2) AS FechaModificacion,
            CAST(NULL AS BIT) AS Estado,
            CAST(0 AS INT) AS TotalRegistros;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CrearEmpresa
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

        IF EXISTS (
            SELECT 1
            FROM dbo.Empresas
            WHERE Nit = LTRIM(RTRIM(@Nit))
        )
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'Ya existe una empresa registrada con el NIT indicado.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        INSERT INTO dbo.Empresas
        (
            Nit,
            RazonSocial,
            Direccion,
            Cliente,
            Telefono,
            ComercialPositivo,
            Supervisor,
            CR,
            Ciudad,
            Moneda,
            UsuarioCreacion,
            FechaCreacion,
            Estado
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

CREATE OR ALTER PROCEDURE dbo.sp_ActualizarEmpresa
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

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Empresas
            WHERE IdEmpresa = @IdEmpresa
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

        IF EXISTS (
            SELECT 1
            FROM dbo.Empresas
            WHERE Nit = LTRIM(RTRIM(@Nit))
              AND IdEmpresa <> @IdEmpresa
        )
        BEGIN
            SELECT CAST(0 AS BIT) AS Exito, 'Ya existe otra empresa registrada con el NIT indicado.' AS Mensaje, NULL AS IdEmpresa;
            RETURN;
        END;

        UPDATE dbo.Empresas
        SET
            Nit = LTRIM(RTRIM(@Nit)),
            RazonSocial = LTRIM(RTRIM(@RazonSocial)),
            Direccion = LTRIM(RTRIM(@Direccion)),
            Cliente = LTRIM(RTRIM(@Cliente)),
            Telefono = LTRIM(RTRIM(@Telefono)),
            ComercialPositivo = LTRIM(RTRIM(@ComercialPositivo)),
            Supervisor = LTRIM(RTRIM(@Supervisor)),
            CR = LTRIM(RTRIM(@CR)),
            Ciudad = LTRIM(RTRIM(@Ciudad)),
            Moneda = LTRIM(RTRIM(@Moneda)),
            Estado = @Estado,
            UsuarioModificacion = LTRIM(RTRIM(@UsuarioModificacion)),
            FechaModificacion = SYSUTCDATETIME()
        WHERE IdEmpresa = @IdEmpresa;

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