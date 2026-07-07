public class CrearDocumentoRequest
{
    public int IdEmpresa { get; set; }

    public string UsuarioRegistro { get; set; } = string.Empty;

    public List<IFormFile> Archivos { get; set; } = new();
}