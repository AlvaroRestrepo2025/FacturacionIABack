USE FacturacionIA;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.tables
    WHERE name = 'Empresas'
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.Empresas
    (
        IdEmpresa INT IDENTITY(1,1) NOT NULL,
        Nit NVARCHAR(30) NOT NULL,
        RazonSocial NVARCHAR(200) NOT NULL,
        Direccion NVARCHAR(250) NOT NULL,
        Cliente NVARCHAR(200) NOT NULL,
        Telefono NVARCHAR(50) NOT NULL,
        ComercialPositivo NVARCHAR(150) NOT NULL,
        Supervisor NVARCHAR(150) NOT NULL,
        CR NVARCHAR(50) NOT NULL,
        Ciudad NVARCHAR(100) NOT NULL,
        Moneda NVARCHAR(20) NOT NULL,
        UsuarioCreacion NVARCHAR(100) NOT NULL,
        FechaCreacion DATETIME2 NOT NULL CONSTRAINT DF_Empresas_FechaCreacion DEFAULT SYSUTCDATETIME(),
        UsuarioModificacion NVARCHAR(100) NULL,
        FechaModificacion DATETIME2 NULL,
        Estado BIT NOT NULL CONSTRAINT DF_Empresas_Estado DEFAULT 1,

        CONSTRAINT PK_Empresas
            PRIMARY KEY (IdEmpresa),

        CONSTRAINT UQ_Empresas_Nit
            UNIQUE (Nit),

        CONSTRAINT CK_Empresas_Nit_NoVacio
            CHECK (LTRIM(RTRIM(Nit)) <> ''),

        CONSTRAINT CK_Empresas_RazonSocial_NoVacio
            CHECK (LTRIM(RTRIM(RazonSocial)) <> ''),

        CONSTRAINT CK_Empresas_Direccion_NoVacio
            CHECK (LTRIM(RTRIM(Direccion)) <> ''),

        CONSTRAINT CK_Empresas_Cliente_NoVacio
            CHECK (LTRIM(RTRIM(Cliente)) <> ''),

        CONSTRAINT CK_Empresas_Telefono_NoVacio
            CHECK (LTRIM(RTRIM(Telefono)) <> ''),

        CONSTRAINT CK_Empresas_ComercialPositivo_NoVacio
            CHECK (LTRIM(RTRIM(ComercialPositivo)) <> ''),

        CONSTRAINT CK_Empresas_Supervisor_NoVacio
            CHECK (LTRIM(RTRIM(Supervisor)) <> ''),

        CONSTRAINT CK_Empresas_CR_NoVacio
            CHECK (LTRIM(RTRIM(CR)) <> ''),

        CONSTRAINT CK_Empresas_Ciudad_NoVacio
            CHECK (LTRIM(RTRIM(Ciudad)) <> ''),

        CONSTRAINT CK_Empresas_Moneda_NoVacio
            CHECK (LTRIM(RTRIM(Moneda)) <> ''),

        CONSTRAINT CK_Empresas_UsuarioCreacion_NoVacio
            CHECK (LTRIM(RTRIM(UsuarioCreacion)) <> '')
    );
END;
GO