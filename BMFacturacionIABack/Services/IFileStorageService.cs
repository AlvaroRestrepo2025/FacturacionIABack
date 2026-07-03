using DTFacturacionIABack.Documentos;

namespace BMFacturacionIABack.Services
{
    public interface IFileStorageService
    {
        Task<List<ArchivoDocumentoDto>> GuardarArchivosAsync(
            List<ArchivoDocumentoDto> archivos);
    }
}