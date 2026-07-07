using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTFacturacionIABack.UsuariosExternos
{
    public class UsuarioExternoDto
    {
        public int IdUsuarioExterno { get; set; }

        public string Usuario { get; set; } = string.Empty;

        public string Nombre { get; set; } = string.Empty;

        public string Correo { get; set; } = string.Empty;

        public string Notas { get; set; } = string.Empty;

        public bool Estado { get; set; }

        public string UsuarioCreacion { get; set; } = string.Empty;

        public DateTime FechaCreacion { get; set; }

        public string? UsuarioModificacion { get; set; }

        public DateTime? FechaModificacion { get; set; }
    }
}