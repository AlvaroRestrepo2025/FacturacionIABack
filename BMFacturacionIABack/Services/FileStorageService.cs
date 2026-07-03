using DTFacturacionIABack.Documentos;

namespace BMFacturacionIABack.Services
{
    public class FileStorageService : IFileStorageService
    {
        private readonly string _rutaBase;

        public FileStorageService()
        {
            _rutaBase = Path.Combine(
                Directory.GetCurrentDirectory(),
                "wwwroot",
                "uploads",
                "documentos");

            if (!Directory.Exists(_rutaBase))
            {
                Directory.CreateDirectory(_rutaBase);
            }
        }

        public async Task<List<ArchivoDocumentoDto>> GuardarArchivosAsync(
            List<ArchivoDocumentoDto> archivos)
        {
            List<ArchivoDocumentoDto> resultado = new();

            foreach (var archivo in archivos)
            {
                string extension =
                    Path.GetExtension(archivo.NombreArchivo);

                string nombreUnico =
                    $"{Guid.NewGuid()}{extension}";

                string rutaCompleta =
                    Path.Combine(_rutaBase, nombreUnico);

                await File.WriteAllBytesAsync(
                    rutaCompleta,
                    archivo.Contenido);

                resultado.Add(new ArchivoDocumentoDto
                {
                    NombreArchivo = archivo.NombreArchivo,

                    TamanoBytes = archivo.TamanoBytes,

                    RutaArchivo =
                        Path.Combine(
                            "uploads",
                            "documentos",
                            nombreUnico)
                            .Replace("\\", "/")
                });
            }

            return resultado;
        }
    }
}