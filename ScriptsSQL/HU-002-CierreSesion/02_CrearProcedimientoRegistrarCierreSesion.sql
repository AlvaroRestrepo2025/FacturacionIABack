USE FacturacionIA;
GO

CREATE OR ALTER PROCEDURE dbo.sp_RegistrarCierreSesion
    @IdUsuario INT = NULL,
    @NombreUsuario NVARCHAR(100),
    @TipoCierre NVARCHAR(50),
    @Motivo NVARCHAR(250) = NULL,
    @TipoUsuario NVARCHAR(50) = NULL,
    @DireccionIp NVARCHAR(50) = NULL,
    @UserAgent NVARCHAR(500) = NULL,
    @TokenReferencia NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @NombreUsuario IS NULL OR LTRIM(RTRIM(@NombreUsuario)) = ''
        BEGIN
            SELECT 
                CAST(0 AS BIT) AS Exito,
                'El nombre de usuario es obligatorio.' AS Mensaje,
                NULL AS IdAuditoriaCierreSesion,
                NULL AS FechaCierre;
            RETURN;
        END;

        IF @TipoCierre NOT IN ('Manual', 'Inactividad')
        BEGIN
            SELECT 
                CAST(0 AS BIT) AS Exito,
                'El tipo de cierre no es válido. Use Manual o Inactividad.' AS Mensaje,
                NULL AS IdAuditoriaCierreSesion,
                NULL AS FechaCierre;
            RETURN;
        END;

        IF @IdUsuario IS NOT NULL 
           AND NOT EXISTS (
                SELECT 1 
                FROM dbo.Usuario 
                WHERE IdUsuario = @IdUsuario
           )
        BEGIN
            SELECT 
                CAST(0 AS BIT) AS Exito,
                'El usuario indicado no existe.' AS Mensaje,
                NULL AS IdAuditoriaCierreSesion,
                NULL AS FechaCierre;
            RETURN;
        END;

        DECLARE @FechaCierre DATETIME2 = SYSUTCDATETIME();

        INSERT INTO dbo.AuditoriaCierreSesion
        (
            IdUsuario,
            NombreUsuario,
            TipoCierre,
            FechaCierre,
            Exitoso,
            Motivo,
            TipoUsuario,
            DireccionIp,
            UserAgent,
            TokenReferencia
        )
        VALUES
        (
            @IdUsuario,
            @NombreUsuario,
            @TipoCierre,
            @FechaCierre,
            1,
            @Motivo,
            @TipoUsuario,
            @DireccionIp,
            @UserAgent,
            @TokenReferencia
        );

        SELECT 
            CAST(1 AS BIT) AS Exito,
            'Sesión cerrada correctamente.' AS Mensaje,
            SCOPE_IDENTITY() AS IdAuditoriaCierreSesion,
            @FechaCierre AS FechaCierre;
    END TRY
    BEGIN CATCH
        SELECT 
            CAST(0 AS BIT) AS Exito,
            ERROR_MESSAGE() AS Mensaje,
            NULL AS IdAuditoriaCierreSesion,
            NULL AS FechaCierre;
    END CATCH
END;
GO