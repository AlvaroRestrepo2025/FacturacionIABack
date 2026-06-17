USE FacturacionIA;
GO

IF NOT EXISTS (
    SELECT 1 
    FROM sys.tables 
    WHERE name = 'AuditoriaCierreSesion'
)
BEGIN
    CREATE TABLE dbo.AuditoriaCierreSesion
    (
        IdAuditoriaCierreSesion INT IDENTITY(1,1) NOT NULL,
        IdUsuario INT NULL,
        NombreUsuario NVARCHAR(100) NOT NULL,
        TipoCierre NVARCHAR(50) NOT NULL,
        FechaCierre DATETIME2 NOT NULL CONSTRAINT DF_AuditoriaCierreSesion_FechaCierre DEFAULT SYSUTCDATETIME(),
        Exitoso BIT NOT NULL CONSTRAINT DF_AuditoriaCierreSesion_Exitoso DEFAULT 1,
        Motivo NVARCHAR(250) NULL,
        TipoUsuario NVARCHAR(50) NULL,
        DireccionIp NVARCHAR(50) NULL,
        UserAgent NVARCHAR(500) NULL,
        TokenReferencia NVARCHAR(500) NULL,

        CONSTRAINT PK_AuditoriaCierreSesion 
            PRIMARY KEY (IdAuditoriaCierreSesion),

        CONSTRAINT FK_AuditoriaCierreSesion_Usuario
            FOREIGN KEY (IdUsuario)
            REFERENCES dbo.Usuario(IdUsuario)
    );
END;
GO