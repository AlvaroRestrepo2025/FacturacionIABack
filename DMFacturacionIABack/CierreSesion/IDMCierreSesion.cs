using DTFacturacionIABack.CierreSesion;

namespace DMFacturacionIABack.CierreSesion
{
    public interface IDMCierreSesion
    {
        Task<CierreSesionResponseDto> RegistrarCierreSesionAsync(
            string nombreUsuario,
            string? apellido,
            string motivo,
            string? rol,
            bool exitoso
        );
    }
}