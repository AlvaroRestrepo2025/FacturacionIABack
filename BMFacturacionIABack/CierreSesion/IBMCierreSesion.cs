using DTFacturacionIABack.CierreSesion;

namespace BMFacturacionIABack.CierreSesion
{
    public interface IBMCierreSesion
    {
        Task<CierreSesionResponseDto> RegistrarCierreSesionAsync(
            CierreSesionRequestDto request,
            string? nombreUsuario,
            string? apellido,
            string? rol
        );
    }
}