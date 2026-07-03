using BMFacturacionIABack.Services;
using DMFacturacionIABack.Documentos;
using DTFacturacionIABack.Documentos;

namespace BMFacturacionIABack.Documentos
{
    public class BMDocumentos : IBMDocumentos
    {
        private readonly IDMDocumentos _dmDocumentos;
        private readonly IFileStorageService _fileStorageService;

        public BMDocumentos(
            IDMDocumentos dmDocumentos,
            IFileStorageService fileStorageService)
        {
            _dmDocumentos = dmDocumentos;
            _fileStorageService = fileStorageService;
        }

        public async Task<List<DocumentoDto>> ObtenerDocumentosAsync()
        {
            return await _dmDocumentos.ObtenerDocumentosAsync();
        }

        public async Task CrearDocumentoAsync(
    CrearDocumentoDto documento)
        {
            if (documento.IdEmpresa <= 0)
            {
                throw new Exception("Seleccione una empresa antes de continuar.");
            }

            if (documento.Archivos == null ||
                documento.Archivos.Count == 0)
            {
                throw new Exception("Debe cargar al menos un archivo para continuar.");
            }

            documento.Archivos =
                await _fileStorageService.GuardarArchivosAsync(
                    documento.Archivos);

            await _dmDocumentos.CrearDocumentoAsync(
                documento,
                 documento.UsuarioRegistro);
        }

        public async Task ActualizarDocumentoAsync(
    ActualizarDocumentoDto documento)
        {
            if (documento.IdEmpresa <= 0)
            {
                throw new Exception("Debe seleccionar una empresa.");
            }

            if (documento.Archivos != null &&
                documento.Archivos.Count > 0)
            {
                documento.Archivos =
                    await _fileStorageService.GuardarArchivosAsync(
                        documento.Archivos);
            }

            await _dmDocumentos.ActualizarDocumentoAsync(
                documento,
                 documento.UsuarioModificacion);
        }
    }
}