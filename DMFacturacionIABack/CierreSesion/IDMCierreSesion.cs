using DTFacturacionIABack.CierreSesion;

namespace DMFacturacionIABack.CierreSesion
{
    public interface IDMCierreSesion
    {
        Task<CierreSesionResponseDto> RegistrarCierreSesionAsync(
            int? idUsuario,
            string nombreUsuario,
            string tipoCierre,
            string? motivo,
            string? tipoUsuario,
            string? direccionIp,
            string? userAgent,
            string? tokenReferencia
        );
    }
}