using DTFacturacionIABack.Documentos;

namespace DMFacturacionIABack.Documentos
{
    public interface IDMDocumentos
    {
        Task<List<DocumentoDto>> ObtenerDocumentosAsync();

        Task CrearDocumentoAsync(
            CrearDocumentoDto documento,
            string usuarioCreacion);

        Task ActualizarDocumentoAsync(
            ActualizarDocumentoDto documento,
            string usuarioModificacion);
    }
}