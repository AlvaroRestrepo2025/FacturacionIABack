public class ActualizarDocumentoRequest
{
    public int IdSolicitud { get; set; }

    public int IdEmpresa { get; set; }

    public string Estado { get; set; } = string.Empty;

    public string UsuarioModificacion { get; set; } = string.Empty;

    public List<IFormFile> Archivos { get; set; } = new();
}