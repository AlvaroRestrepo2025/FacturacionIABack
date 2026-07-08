using BMFacturacionIABack.Documentos;
using DTFacturacionIABack.Documentos;
using Microsoft.AspNetCore.Mvc;

namespace FacturacionIABack.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DocumentosController : ControllerBase
    {
        private readonly IBMDocumentos _bmDocumentos;

        public DocumentosController(
            IBMDocumentos bmDocumentos)
        {
            _bmDocumentos = bmDocumentos;
        }

        [HttpGet]
        public async Task<IActionResult> Obtener()
        {
            var documentos =
                await _bmDocumentos.ObtenerDocumentosAsync();

            return Ok(documentos);
        }

        [HttpPost]
        public async Task<IActionResult> Crear(
    [FromForm] CrearDocumentoRequest request)
        {
            CrearDocumentoDto dto = new()
            {
                IdEmpresa = request.IdEmpresa,
                UsuarioRegistro = request.UsuarioRegistro
            };

            foreach (var archivo in request.Archivos)
            {
                using MemoryStream ms = new();

                await archivo.CopyToAsync(ms);

                dto.Archivos.Add(new ArchivoDocumentoDto
                {
                    NombreArchivo = archivo.FileName,
                    TamanoBytes = archivo.Length,
                    Contenido = ms.ToArray()
                });
            }

            await _bmDocumentos.CrearDocumentoAsync(dto);

            return Ok(new
            {
                mensaje = "Documento creado correctamente."
            });
        }

        [HttpPut]
        public async Task<IActionResult> Actualizar(
    [FromForm] ActualizarDocumentoRequest request)
        {
            ActualizarDocumentoDto dto = new()
            {
                IdSolicitud = request.IdSolicitud,
                IdEmpresa = request.IdEmpresa,
                Estado = request.Estado,
                UsuarioModificacion = request.UsuarioModificacion
            };

            foreach (var archivo in request.Archivos)
            {
                using MemoryStream ms = new();

                await archivo.CopyToAsync(ms);

                dto.Archivos.Add(new ArchivoDocumentoDto
                {
                    NombreArchivo = archivo.FileName,
                    TamanoBytes = archivo.Length,
                    Contenido = ms.ToArray()
                });
            }

            await _bmDocumentos.ActualizarDocumentoAsync(dto);

            return Ok(new
            {
                mensaje = "Documento actualizado correctamente."
            });
        }
    }
}