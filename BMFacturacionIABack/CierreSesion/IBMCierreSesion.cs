using DTFacturacionIABack.CierreSesion;

namespace BMFacturacionIABack.CierreSesion
{
    public interface IBMCierreSesion
    {
        Task<CierreSesionResponseDto> RegistrarCierreSesionAsync(
            CierreSesionRequestDto request,
            int? idUsuario,
            string? nombreUsuario,
            string? tipoUsuario,
            string? direccionIp,
            string? userAgent,
            string? tokenReferencia
        );
    }
}