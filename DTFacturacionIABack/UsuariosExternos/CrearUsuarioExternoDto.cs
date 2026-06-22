using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTFacturacionIABack.UsuariosExternos
{
    public class CrearUsuarioExternoDto
    {
        public string Nombre { get; set; } = string.Empty;

        public string Correo { get; set; } = string.Empty;

        public string Notas { get; set; } = string.Empty;
    }
}