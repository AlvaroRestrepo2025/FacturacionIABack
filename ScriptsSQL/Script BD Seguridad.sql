USE db_SecurityPositivo;
GO

/*==============================================================
HU 006 - Juan Guillermo - 06/07/2026
Agregar nuevas columnas
==============================================================*/

ALTER TABLE dbo.Usuarios
ADD Notas VARCHAR(200) NULL;
GO

ALTER TABLE dbo.Usuarios
ADD UsuarioModificacion VARCHAR(100) NULL;
GO

ALTER TABLE dbo.Usuarios
ADD FechaModificacion DATETIME NULL;
GO

/*==============================================================
SP: Consultar Usuarios
==============================================================*/

CREATE OR ALTER PROCEDURE dbo.SP_ConsultarUsuarios
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        UsuarioId,
        Nombre,
        Apellido,
        Correo,
        Usuario,
        Cargo,
        Notas,
        Activo,
        UsuarioRegistro,
        FechaRegistro,
        UsuarioModificacion,
        FechaModificacion
    FROM dbo.Usuarios
    WHERE Cargo = 'Contabler'
    ORDER BY FechaRegistro DESC;
END;
GO

/*==============================================================
SP: Actualizar Usuario
==============================================================*/

CREATE OR ALTER PROCEDURE dbo.SP_ActualizarUsuario
(
    @IN_UsuarioId INT,
    @IN_Nombre VARCHAR(50),
    @IN_Apellido VARCHAR(100),
    @IN_Correo VARCHAR(100),
    @IN_Usuario VARCHAR(30),
    @IN_Notas VARCHAR(200) = NULL,
    @IN_Activo BIT,
    @IN_UsuarioModificacion VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Usuarios
    SET
        Nombre = @IN_Nombre,
        Apellido = @IN_Apellido,
        Correo = @IN_Correo,
        Usuario = @IN_Usuario,
        Notas = @IN_Notas,
        Activo = @IN_Activo,
        UsuarioModificacion = @IN_UsuarioModificacion,
        FechaModificacion = GETDATE()
    WHERE UsuarioId = @IN_UsuarioId;
END;
GO

/*==============================================================
SP: Registrar Usuario
==============================================================*/

CREATE OR ALTER PROCEDURE dbo.SP_RegistrarUsuario
(
    @IN_Nombre VARCHAR(50),
    @IN_Apellido VARCHAR(100),
    @IN_Correo VARCHAR(100),
    @IN_Cargo VARCHAR(50),
    @IN_Usuario VARCHAR(30),
    @IN_ContraseñaHash VARBINARY(64),
    @IN_Salto VARBINARY(16),
    @IN_UsuarioRegistro VARCHAR(100),
    @IN_Notas VARCHAR(200) = NULL,
    @OUT_ConsultaId INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Usuarios
    (
        Nombre,
        Apellido,
        Correo,
        Cargo,
        Usuario,
        ContraseñaHash,
        Salto,
        UsuarioRegistro,
        FechaRegistro,
        Activo,
        Notas
    )
    VALUES
    (
        @IN_Nombre,
        @IN_Apellido,
        @IN_Correo,
        @IN_Cargo,
        @IN_Usuario,
        @IN_ContraseñaHash,
        @IN_Salto,
        @IN_UsuarioRegistro,
        GETDATE(),
        1,
        @IN_Notas
    );

    SET @OUT_ConsultaId = CAST(SCOPE_IDENTITY() AS INT);
END;
GO
