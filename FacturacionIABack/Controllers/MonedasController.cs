using BMFacturacionIABack.Monedas;
using Microsoft.AspNetCore.Mvc;

namespace FacturacionIABack.Controllers
{
    [ApiController]
    [Route("api/monedas")]
    public class MonedasController : ControllerBase
    {
        private readonly IBMMonedas _bmMonedas;

        public MonedasController(IBMMonedas bmMonedas)
        {
            _bmMonedas = bmMonedas;
        }

        /// <summary>
        /// Lista las monedas activas disponibles para empresas.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> ListarMonedas()
        {
            var response = await _bmMonedas.ListarMonedasAsync();

            return Ok(response);
        }
    }
}