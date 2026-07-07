namespace DTFacturacionIABack.Documentos
{
    public class CrearDocumentoDto
    {
        public int IdEmpresa { get; set; }

        public string UsuarioRegistro { get; set; } = string.Empty;

        public List<ArchivoDocumentoDto> Archivos { get; set; } = new();
    }
}