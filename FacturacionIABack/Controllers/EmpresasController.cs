using BMFacturacionIABack.Empresas;
using DTFacturacionIABack.Empresas;
using Microsoft.AspNetCore.Mvc;

namespace FacturacionIABack.Controllers
{
    [ApiController]
    [Route("api/empresas")]
    public class EmpresasController : ControllerBase
    {
        private readonly IBMEmpresas _bmEmpresas;

        public EmpresasController(IBMEmpresas bmEmpresas)
        {
            _bmEmpresas = bmEmpresas;
        }

        /// <summary>
        /// Lista empresas con búsqueda y paginación.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> ListarEmpresas(
            [FromQuery] string? busqueda,
            [FromQuery] int pagina = 1,
            [FromQuery] int cantidadRegistros = 10)
        {
            var response = await _bmEmpresas.ListarEmpresasAsync(
                busqueda,
                pagina,
                cantidadRegistros
            );

            return Ok(response);
        }

        /// <summary>
        /// Crea una nueva empresa.
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> CrearEmpresa(
            [FromBody] CrearEmpresaRequestDto request)
        {
            var response = await _bmEmpresas.CrearEmpresaAsync(request);

            return Ok(response);
        }

        /// <summary>
        /// Actualiza una empresa existente.
        /// </summary>
        [HttpPut("{idEmpresa:int}")]
        public async Task<IActionResult> ActualizarEmpresa(
            [FromRoute] int idEmpresa,
            [FromBody] ActualizarEmpresaRequestDto request)
        {
            var response = await _bmEmpresas.ActualizarEmpresaAsync(
                idEmpresa,
                request
            );

            return Ok(response);
        }
    }
}