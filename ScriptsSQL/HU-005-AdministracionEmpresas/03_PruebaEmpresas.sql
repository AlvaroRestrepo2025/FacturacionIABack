USE FacturacionIA;
GO

-- Prueba 1: crear empresa correctamente
EXEC dbo.sp_CrearEmpresa
    @Nit = '900123456-1',
    @RazonSocial = 'Empresa Prueba HU005 S.A.S.',
    @Direccion = 'Calle 100 # 10-20',
    @Cliente = 'Cliente Prueba',
    @Telefono = '6011234567',
    @ComercialPositivo = 'Comercial Prueba',
    @Supervisor = 'Supervisor Prueba',
    @CR = 'CR001',
    @Ciudad = 'Bogotá',
    @Moneda = 'COP',
    @UsuarioCreacion = 'UsuarioTemporalHU005';
GO

-- Prueba 2: intentar crear empresa con NIT duplicado
EXEC dbo.sp_CrearEmpresa
    @Nit = '900123456-1',
    @RazonSocial = 'Empresa Duplicada HU005 S.A.S.',
    @Direccion = 'Carrera 15 # 20-30',
    @Cliente = 'Cliente Duplicado',
    @Telefono = '6017654321',
    @ComercialPositivo = 'Comercial Duplicado',
    @Supervisor = 'Supervisor Duplicado',
    @CR = 'CR002',
    @Ciudad = 'Bogotá',
    @Moneda = 'COP',
    @UsuarioCreacion = 'UsuarioTemporalHU005';
GO

-- Prueba 3: listar empresas sin filtro
EXEC dbo.sp_ListarEmpresas
    @Busqueda = NULL,
    @Pagina = 1,
    @CantidadRegistros = 10;
GO

-- Prueba 4: buscar empresa por texto
EXEC dbo.sp_ListarEmpresas
    @Busqueda = 'HU005',
    @Pagina = 1,
    @CantidadRegistros = 10;
GO

-- Prueba 5: actualizar empresa y cambiar estado a inactivo
DECLARE @IdEmpresaPrueba INT;

SELECT TOP 1
    @IdEmpresaPrueba = IdEmpresa
FROM dbo.Empresas
WHERE Nit = '900123456-1'
ORDER BY IdEmpresa DESC;

EXEC dbo.sp_ActualizarEmpresa
    @IdEmpresa = @IdEmpresaPrueba,
    @Nit = '900123456-1',
    @RazonSocial = 'Empresa Prueba HU005 Actualizada S.A.S.',
    @Direccion = 'Calle 100 # 10-20 Actualizada',
    @Cliente = 'Cliente Prueba Actualizado',
    @Telefono = '6019999999',
    @ComercialPositivo = 'Comercial Prueba Actualizado',
    @Supervisor = 'Supervisor Prueba Actualizado',
    @CR = 'CR001-A',
    @Ciudad = 'Bogotá',
    @Moneda = 'COP',
    @Estado = 0,
    @UsuarioModificacion = 'UsuarioTemporalHU005';
GO

-- Consulta final de validación
SELECT TOP 10
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
ORDER BY IdEmpresa DESC;
GO