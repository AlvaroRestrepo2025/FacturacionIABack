USE FacturacionIA;
GO

-- Prueba 1: cierre manual
EXEC dbo.sp_RegistrarCierreSesion
    @IdUsuario = NULL,
    @NombreUsuario = 'UsuarioTemporalHU002',
    @TipoCierre = 'Manual',
    @Motivo = 'Prueba local de cierre manual HU-002',
    @TipoUsuario = 'Temporal',
    @DireccionIp = '127.0.0.1',
    @UserAgent = 'Prueba desde script SQL',
    @TokenReferencia = 'token-prueba-manual-hu002';
GO

-- Prueba 2: cierre por inactividad
EXEC dbo.sp_RegistrarCierreSesion
    @IdUsuario = NULL,
    @NombreUsuario = 'UsuarioTemporalHU002',
    @TipoCierre = 'Inactividad',
    @Motivo = 'Prueba local de cierre automático por inactividad HU-002',
    @TipoUsuario = 'Temporal',
    @DireccionIp = '127.0.0.1',
    @UserAgent = 'Prueba desde script SQL',
    @TokenReferencia = 'token-prueba-inactividad-hu002';
GO

-- Prueba 3: validación de tipo de cierre incorrecto
EXEC dbo.sp_RegistrarCierreSesion
    @IdUsuario = NULL,
    @NombreUsuario = 'UsuarioTemporalHU002',
    @TipoCierre = 'CierreIncorrecto',
    @Motivo = 'Prueba de validación tipo de cierre inválido',
    @TipoUsuario = 'Temporal',
    @DireccionIp = '127.0.0.1',
    @UserAgent = 'Prueba desde script SQL',
    @TokenReferencia = 'token-prueba-error-hu002';
GO

-- Consulta de validación
SELECT TOP 10
    IdAuditoriaCierreSesion,
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
FROM dbo.AuditoriaCierreSesion
ORDER BY IdAuditoriaCierreSesion DESC;
GO