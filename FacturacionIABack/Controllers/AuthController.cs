using BMFacturacionIABack.CierreSesion;
using DTFacturacionIABack.CierreSesion;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace FacturacionIABack.Controllers
{
    [ApiController]
    [Route("api/auth")]
    public class AuthController : ControllerBase
    {
        private readonly IBMCierreSesion _bmCierreSesion;

        public AuthController(IBMCierreSesion bmCierreSesion)
        {
            _bmCierreSesion = bmCierreSesion;
        }

        [HttpPost("logout")]
        public async Task<IActionResult> Logout([FromBody] CierreSesionRequestDto request)
        {
            string? tokenReferencia = ObtenerTokenDesdeHeader();
            string? direccionIp = HttpContext.Connection.RemoteIpAddress?.ToString();
            string? userAgent = Request.Headers.UserAgent.ToString();

            int? idUsuario = ObtenerIdUsuarioDesdeClaims();
            string? nombreUsuario = ObtenerNombreUsuarioDesdeClaims();
            string? tipoUsuario = ObtenerTipoUsuarioDesdeClaims();

            CierreSesionResponseDto respuesta = await _bmCierreSesion.RegistrarCierreSesionAsync(
                request,
                idUsuario,
                nombreUsuario,
                tipoUsuario,
                direccionIp,
                userAgent,
                tokenReferencia
            );

            if (!respuesta.Exito)
            {
                return BadRequest(respuesta);
            }

            return Ok(respuesta);
        }

        private string? ObtenerTokenDesdeHeader()
        {
            string authorizationHeader = Request.Headers.Authorization.ToString();

            if (string.IsNullOrWhiteSpace(authorizationHeader))
            {
                return null;
            }

            if (authorizationHeader.StartsWith("Bearer ", StringComparison.OrdinalIgnoreCase))
            {
                return authorizationHeader.Replace("Bearer ", string.Empty, StringComparison.OrdinalIgnoreCase).Trim();
            }

            return authorizationHeader;
        }

        private int? ObtenerIdUsuarioDesdeClaims()
        {
            string? idUsuarioClaim = User.FindFirstValue(ClaimTypes.NameIdentifier)
                ?? User.FindFirstValue("IdUsuario")
                ?? User.FindFirstValue("idUsuario");

            if (int.TryParse(idUsuarioClaim, out int idUsuario))
            {
                return idUsuario;
            }

            return null;
        }

        private string? ObtenerNombreUsuarioDesdeClaims()
        {
            return User.FindFirstValue(ClaimTypes.Name)
                ?? User.FindFirstValue("NombreUsuario")
                ?? User.FindFirstValue("nombreUsuario")
                ?? User.Identity?.Name;
        }

        private string? ObtenerTipoUsuarioDesdeClaims()
        {
            return User.FindFirstValue("TipoUsuario")
                ?? User.FindFirstValue("tipoUsuario");
        }
    }
}