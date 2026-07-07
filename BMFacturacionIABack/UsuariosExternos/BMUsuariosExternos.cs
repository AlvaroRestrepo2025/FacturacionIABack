using DMFacturacionIABack.UsuariosExternos;
using DTFacturacionIABack.UsuariosExternos;
using BMFacturacionIABack.Services;
using System.Net.Mail;
using System.Linq;

namespace BMFacturacionIABack.UsuariosExternos
{
    public class BMUsuariosExternos : IBMUsuariosExternos
    {
        private readonly IDMUsuariosExternos _dmUsuariosExternos;
        private readonly EmailService _emailService;
        private readonly ISecurityApiService _securityApiService;

        public BMUsuariosExternos(
             IDMUsuariosExternos dmUsuariosExternos,
             EmailService emailService,
             ISecurityApiService securityApiService)
        {
            _dmUsuariosExternos = dmUsuariosExternos;
            _emailService = emailService;
            _securityApiService = securityApiService;
        }

        public async Task<List<UsuarioExternoDto>> ObtenerUsuariosAsync()
        {
            return await _securityApiService.ObtenerUsuariosAsync();
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

            var usuarios = await _securityApiService.ObtenerUsuariosAsync();

            if (usuarios.Any(u => u.Correo.Equals(usuario.Correo, StringComparison.OrdinalIgnoreCase)))
            {
                throw new Exception("Ya existe un usuario registrado con ese correo electrónico.");
            }

            var usuarioGenerado = GenerarUsuario(usuario.Nombre);

            if (usuarios.Any(u => u.Usuario.Equals(usuarioGenerado, StringComparison.OrdinalIgnoreCase)))
            {
                throw new Exception("Ya existe un usuario registrado con ese nombre de usuario.");
            }

            string passwordGenerada = GenerarPassword();

            var (nombre, apellido) = SepararNombre(usuario.Nombre);

            var usuarioSeguridad = new SecurityApiRegistrarUsuarioDto
            {
                Nombre = nombre,
                Apellido = apellido,
                Correo = usuario.Correo,
                Cargo = "Contabler",
                Notas = usuario.Notas,
                UsuarioRegistro = usuario.UsuarioRegistro,
                Credenciales = new SecurityLoginDto
                {
                    Usuario = usuarioGenerado,
                    Contrasena = passwordGenerada
                }
            };

            try
            {
                await _securityApiService.RegistrarUsuarioAsync(usuarioSeguridad);

                await _emailService.EnviarCredencialesAsync(
                    usuario.Correo,
                    usuario.Nombre,
                    passwordGenerada);
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("UNIQUE KEY") ||
                    ex.Message.Contains("duplicate key"))
                {
                    throw new Exception("Ya existe un usuario registrado con ese correo electrónico.");
                }

                throw;
            }
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

            var (nombre, apellido) = SepararNombre(usuario.Nombre);

            var usuarioSeguridad = new SecurityApiActualizarUsuarioDto
            {
                UsuarioId = usuario.IdUsuarioExterno,
                Nombre = nombre,
                Apellido = apellido,
                Correo = usuario.Correo,
                Cargo = "Contabler",
                UsuarioRegistro = usuario.UsuarioModificacion,
                Activo = usuario.Estado,
                Notas = usuario.Notas,
                Credenciales = new SecurityLoginDto
                {
                    Usuario = GenerarUsuario(usuario.Nombre),
                    Contrasena = ""
                }
            };

            await _securityApiService.ActualizarUsuarioAsync(usuarioSeguridad);

        }

        private (string Nombre, string Apellido) SepararNombre(string nombreCompleto)
        {
            var partes = nombreCompleto
                .Split(' ', StringSplitOptions.RemoveEmptyEntries);

            if (partes.Length == 1)
            {
                return (partes[0], ".");
            }

            return (
                string.Join(" ", partes.Take(partes.Length - 1)),
                partes.Last());
        }

        private string GenerarUsuario(string nombre)
        {
            return nombre.Replace(" ", "");
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