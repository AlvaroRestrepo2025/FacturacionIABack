using Microsoft.AspNetCore.Mvc;

namespace FacturacionIABack.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ClientesController : Controller
    {
        [HttpGet]
        public IActionResult Index()
        {
            return Ok("dato");
        }
    }
}
