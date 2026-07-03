namespace DTFacturacionIABack.Documentos
{
    public class ArchivoDocumentoDto
    {
        public string NombreArchivo { get; set; } = string.Empty;

        public string RutaArchivo { get; set; } = string.Empty;

        public long TamanoBytes { get; set; }

        public byte[] Contenido { get; set; } = [];
    }
}