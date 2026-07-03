namespace BMFacturacionIABack.Services
{
    public class SecurityApiActualizarUsuarioDto
    {
        public int UsuarioId { get; set; }

        public string Nombre { get; set; } = string.Empty;

        public string Apellido { get; set; } = string.Empty;

        public string Correo { get; set; } = string.Empty;

        public string Cargo { get; set; } = string.Empty;

        public string UsuarioRegistro { get; set; } = string.Empty;

        public bool Activo { get; set; }

        public string? Notas { get; set; }

        public SecurityLoginDto Credenciales { get; set; } = new();
    }
}