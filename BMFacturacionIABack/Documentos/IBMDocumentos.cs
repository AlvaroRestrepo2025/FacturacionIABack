using DTFacturacionIABack.Documentos;

namespace BMFacturacionIABack.Documentos
{
    public interface IBMDocumentos
    {
        Task<List<DocumentoDto>> ObtenerDocumentosAsync();

        Task CrearDocumentoAsync(CrearDocumentoDto documento);

        Task ActualizarDocumentoAsync(
            ActualizarDocumentoDto documento);
    }
}