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
            int? idUsuario,
            string? nombreUsuario,
            string? tipoUsuario,
            string? direccionIp,
            string? userAgent,
            string? tokenReferencia
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

            if (string.IsNullOrWhiteSpace(request.TipoCierre))
            {
                return new CierreSesionResponseDto
                {
                    Exito = false,
                    Mensaje = "El tipo de cierre es obligatorio."
                };
            }

            if (request.TipoCierre != "Manual" && request.TipoCierre != "Inactividad")
            {
                return new CierreSesionResponseDto
                {
                    Exito = false,
                    Mensaje = "El tipo de cierre no es válido. Use Manual o Inactividad."
                };
            }

            string nombreUsuarioFinal = string.IsNullOrWhiteSpace(nombreUsuario)
                ? "UsuarioTemporalHU002"
                : nombreUsuario;

            string motivo = request.TipoCierre == "Inactividad"
                ? "Cierre automático por inactividad."
                : "Cierre manual de sesión.";

            return await _dmCierreSesion.RegistrarCierreSesionAsync(
                idUsuario,
                nombreUsuarioFinal,
                request.TipoCierre,
                motivo,
                tipoUsuario,
                direccionIp,
                userAgent,
                tokenReferencia
            );
        }
    }
}