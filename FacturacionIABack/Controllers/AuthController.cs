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
            string? nombreUsuario = ObtenerNombreUsuarioDesdeClaims();
            string? apellido = ObtenerApellidoDesdeClaims();
            string? rol = ObtenerRolDesdeClaims();

            CierreSesionResponseDto respuesta = await _bmCierreSesion.RegistrarCierreSesionAsync(
                request,
                nombreUsuario,
                apellido,
                rol
            );

            if (!respuesta.Exito)
            {
                return BadRequest(respuesta);
            }

            return Ok(respuesta);
        }

        private string? ObtenerNombreUsuarioDesdeClaims()
        {
            return User.FindFirstValue(ClaimTypes.Name)
                ?? User.FindFirstValue("NombreUsuario")
                ?? User.FindFirstValue("nombreUsuario")
                ?? User.FindFirstValue("Usuario")
                ?? User.FindFirstValue("usuario")
                ?? User.Identity?.Name;
        }

        private string? ObtenerApellidoDesdeClaims()
        {
            return User.FindFirstValue(ClaimTypes.Surname)
                ?? User.FindFirstValue("Apellido")
                ?? User.FindFirstValue("apellido")
                ?? User.FindFirstValue("Apellidos")
                ?? User.FindFirstValue("apellidos");
        }

        private string? ObtenerRolDesdeClaims()
        {
            return User.FindFirstValue(ClaimTypes.Role)
                ?? User.FindFirstValue("Rol")
                ?? User.FindFirstValue("rol")
                ?? User.FindFirstValue("Area")
                ?? User.FindFirstValue("area");
        }
    }
}