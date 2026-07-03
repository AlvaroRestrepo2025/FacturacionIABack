using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Configuration;
using MimeKit;

namespace BMFacturacionIABack.Services
{
    public class EmailService
    {
        private readonly IConfiguration _configuration;

        public EmailService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task EnviarCredencialesAsync(
            string correoDestino,
            string nombre,
            string password)
        {
            string correoOrigen =
                _configuration["EmailSettings:From"]!;

            string nombreOrigen =
                _configuration["EmailSettings:FromName"] ?? "Facturación IA";

            string apiKey =
                _configuration["EmailSettings:SendGridApiKey"]!;

            var mensaje = new MimeMessage();

            mensaje.From.Add(new MailboxAddress(nombreOrigen, correoOrigen));
            mensaje.To.Add(new MailboxAddress(nombre, correoDestino));
            mensaje.Subject = "Credenciales de acceso";

            var builder = new BodyBuilder
            {
                TextBody =
                    $@"Hola {nombre},

                        Su usuario fue creado correctamente.

                        Correo:
                        {correoDestino}

                        Contraseña:
                        {password}

                        Por favor cambie la contraseña al iniciar sesión.",
                HtmlBody =
                    $@"<p>Hola {nombre},</p>
                       <p>Su usuario fue creado correctamente.</p>
                       <p><strong>Correo:</strong> {correoDestino}</p>
                       <p><strong>Contraseña:</strong> {password}</p>"
            };

            mensaje.Body = builder.ToMessageBody();

            using var cliente = new SmtpClient();

            await cliente.ConnectAsync(
                "smtp.sendgrid.net",
                587,
                SecureSocketOptions.StartTls);

            // El usuario SIEMPRE es literalmente "apikey", y la
            // "contraseña" es tu API Key de SendGrid.
            await cliente.AuthenticateAsync("apikey", apiKey);

            await cliente.SendAsync(mensaje);

            await cliente.DisconnectAsync(true);
        }
    }
}