using System;

namespace BMFacturacionIABack.Services
{
    public class SecurityConsultarUsuariosResponse
    {
        public bool Respuesta { get; set; }

        public List<SecurityUsuarioDto>? Resultado { get; set; }
    }

    public class SecurityUsuarioDto
    {
        public int UsuarioId { get; set; }

        public string? Nombre { get; set; }

        public string? Apellido { get; set; }

        public string? Correo { get; set; }

        public string? Usuario { get; set; }

        public string? Cargo { get; set; }

        public string? Notas { get; set; }

        public bool Activo { get; set; }

        public string? UsuarioRegistro { get; set; }

        public DateTime? FechaRegistro { get; set; }

        public string? UsuarioModificacion { get; set; }

        public DateTime? FechaModificacion { get; set; }
    }
}