using BMFacturacionIABack.UsuariosExternos;
using DTFacturacionIABack.UsuariosExternos;
using Microsoft.AspNetCore.Mvc;

namespace FacturacionIABack.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsuariosExternosController : ControllerBase
    {
        private readonly IBMUsuariosExternos _bmUsuariosExternos;

        public UsuariosExternosController(
            IBMUsuariosExternos bmUsuariosExternos)
        {
            _bmUsuariosExternos = bmUsuariosExternos;
        }

        [HttpGet]
        public async Task<IActionResult> ObtenerUsuarios()
        {
            var usuarios =
                await _bmUsuariosExternos.ObtenerUsuariosAsync();

            return Ok(usuarios);
        }

        [HttpPost]
        public async Task<IActionResult> CrearUsuario(
    [FromBody] CrearUsuarioExternoDto usuario)
        {
            await _bmUsuariosExternos.CrearUsuarioAsync(usuario);

            return Ok(new
            {
                mensaje = "Usuario creado correctamente."
            });
        }

        [HttpPut]
        public async Task<IActionResult> ActualizarUsuario(
            [FromBody] ActualizarUsuarioExternoDto usuario)
        {
            await _bmUsuariosExternos.ActualizarUsuarioAsync(usuario);

            return Ok(new
            {
                mensaje = "Usuario actualizado correctamente."
            });
        }
    }
}