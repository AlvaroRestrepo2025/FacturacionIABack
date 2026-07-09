using BMFacturacionIABack.RegistrosFacturacion;
using DTFacturacionIABack.RegistrosFacturacion;
using Microsoft.AspNetCore.Mvc;

namespace FacturacionIABack.Controllers
{
    [ApiController]
    [Route("api/registros-facturacion")]
    public class RegistrosFacturacionController : ControllerBase
    {
        private readonly IBMRegistrosFacturacion _bmRegistrosFacturacion;

        public RegistrosFacturacionController(
            IBMRegistrosFacturacion bmRegistrosFacturacion
        )
        {
            _bmRegistrosFacturacion = bmRegistrosFacturacion;
        }

        /// <summary>
        /// Lista registros para facturación con búsqueda, filtros y paginación.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> ListarRegistrosFacturacion(
            [FromQuery] string? busqueda,
            [FromQuery] string? estado,
            [FromQuery] DateTime? fechaInicio,
            [FromQuery] DateTime? fechaFin,
            [FromQuery] int pagina = 1,
            [FromQuery] int cantidadRegistros = 10)
        {
            var response = await _bmRegistrosFacturacion.ListarRegistrosFacturacionAsync(
                busqueda,
                estado,
                fechaInicio,
                fechaFin,
                pagina,
                cantidadRegistros
            );

            return Ok(response);
        }

        /// <summary>
        /// Obtiene los registros seleccionados para exportación.
        /// </summary>
        [HttpPost("exportar")]
        public async Task<IActionResult> ObtenerRegistrosFacturacionParaExportar(
            [FromBody] ExportarRegistrosFacturacionRequestDto request)
        {
            var response = await _bmRegistrosFacturacion.ObtenerRegistrosFacturacionPorIdsAsync(
                request
            );

            return Ok(response);
        }
    }
}
