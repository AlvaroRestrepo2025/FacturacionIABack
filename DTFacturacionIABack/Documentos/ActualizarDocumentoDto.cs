namespace DTFacturacionIABack.Documentos
{
    public class ActualizarDocumentoDto
    {
        public int IdSolicitud { get; set; }

        public int IdEmpresa { get; set; }

        public string Estado { get; set; } = string.Empty;

        public string UsuarioModificacion { get; set; } = string.Empty;

        public List<ArchivoDocumentoDto> Archivos { get; set; } = new();
    }
}