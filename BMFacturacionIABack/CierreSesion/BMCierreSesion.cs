using DMFacturacionIABack.CierreSesion;
using DTFacturacionIABack.CierreSesion;

namespace BMFacturacionIABack.CierreSesion
{
    public class BMCierreSesion : IBMCierreSesion
    {
        private readonly IDMCierreSesion _dmCierreSesion;

        public BMCierreSesion(IDMCierreSesion dmCierreSesion)
        {
            _dmCierreSesion = dmCierreSesion;
        }

        public async Task<CierreSesionResponseDto> RegistrarCierreSesionAsync(
            CierreSesionRequestDto request,
            string? nombreUsuario,
            string? apellido,
            string? rol
        )
        {
            if (request == null)
            {
                return new CierreSesionResponseDto
                {
                    Exito = false,
                    Mensaje = "La solicitud de cierre de sesión es obligatoria."
                };
            }

            if (string.IsNullOrWhiteSpace(request.Motivo))
            {
                return new CierreSesionResponseDto
                {
                    Exito = false,
                    Mensaje = "El motivo de cierre de sesión es obligatorio."
                };
            }

            string nombreUsuarioFinal = string.IsNullOrWhiteSpace(nombreUsuario)
                ? "UsuarioTemporalHU002"
                : nombreUsuario.Trim();

            string? apellidoFinal = string.IsNullOrWhiteSpace(apellido)
                ? null
                : apellido.Trim();

            string? rolFinal = string.IsNullOrWhiteSpace(rol)
                ? "Facturacion"
                : rol.Trim();

            string motivoFinal = NormalizarMotivo(request.Motivo);

            return await _dmCierreSesion.RegistrarCierreSesionAsync(
                nombreUsuarioFinal,
                apellidoFinal,
                motivoFinal,
                rolFinal,
                true
            );
        }

        private static string NormalizarMotivo(string motivo)
        {
            string motivoNormalizado = motivo.Trim();

            if (motivoNormalizado.Equals("Manual", StringComparison.OrdinalIgnoreCase))
            {
                return "Cierre manual de sesión.";
            }

            if (motivoNormalizado.Equals("Inactividad", StringComparison.OrdinalIgnoreCase))
            {
                return "Cierre automático por inactividad.";
            }

            return motivoNormalizado;
        }
    }
}