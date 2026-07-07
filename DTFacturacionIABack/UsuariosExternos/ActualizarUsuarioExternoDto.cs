public class ActualizarUsuarioExternoDto
{
    public int IdUsuarioExterno { get; set; }

    public string Usuario { get; set; } = string.Empty;

    public string Nombre { get; set; } = string.Empty;

    public string Correo { get; set; } = string.Empty;

    public string Notas { get; set; } = string.Empty;

    public bool Estado { get; set; }

    public string UsuarioModificacion { get; set; } = string.Empty;
}