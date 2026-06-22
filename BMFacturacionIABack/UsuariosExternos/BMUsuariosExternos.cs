using DMFacturacionIABack.UsuariosExternos;
using DTFacturacionIABack.UsuariosExternos;
using System.Net.Mail;
using System.Linq;


namespace BMFacturacionIABack.UsuariosExternos
{
    public class BMUsuariosExternos : IBMUsuariosExternos
    {
        private readonly IDMUsuariosExternos _dmUsuariosExternos;

        public BMUsuariosExternos(
            IDMUsuariosExternos dmUsuariosExternos)
        {
            _dmUsuariosExternos = dmUsuariosExternos;
        }

        public async Task<List<UsuarioExternoDto>> ObtenerUsuariosAsync()
        {
            return await _dmUsuariosExternos.ObtenerUsuariosAsync();
        }

        public async Task CrearUsuarioAsync(CrearUsuarioExternoDto usuario)
        {
            if (string.IsNullOrWhiteSpace(usuario.Nombre))
            {
                throw new Exception("El nombre es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(usuario.Correo))
            {
                throw new Exception("El correo es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(usuario.Notas))
            {
                throw new Exception("Las notas son obligatorias.");
            }

            try
            {
                MailAddress correo = new(usuario.Correo);
            }
            catch
            {
                throw new Exception("El correo no tiene un formato válido.");
            }

            string passwordGenerada = GenerarPassword();

            await _dmUsuariosExternos.CrearUsuarioAsync(
                usuario,
                passwordGenerada,
                "Sistema");
        }

        public async Task ActualizarUsuarioAsync(ActualizarUsuarioExternoDto usuario)
        {
            if (string.IsNullOrWhiteSpace(usuario.Nombre))
            {
                throw new Exception("El nombre es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(usuario.Correo))
            {
                throw new Exception("El correo es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(usuario.Notas))
            {
                throw new Exception("Las notas son obligatorias.");
            }

            try
            {
                MailAddress correo = new(usuario.Correo);
            }
            catch
            {
                throw new Exception("El correo no tiene un formato válido.");
            }

            await _dmUsuariosExternos.ActualizarUsuarioAsync(
                usuario,
                "Sistema");
        }

        private string GenerarPassword()
        {
            const string caracteres =
                "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

            Random random = new();

            return new string(
                Enumerable.Repeat(caracteres, 8)
                    .Select(s => s[random.Next(s.Length)])
                    .ToArray());
        }
    }
}