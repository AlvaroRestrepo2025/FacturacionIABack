using System.Net.Http.Json;
using DTFacturacionIABack.UsuariosExternos;
using System.Text.Json;

namespace BMFacturacionIABack.Services
{
    public class SecurityApiService : ISecurityApiService
    {
        private readonly HttpClient _httpClient;

        public SecurityApiService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task RegistrarUsuarioAsync(
     SecurityApiRegistrarUsuarioDto usuario)
        {
            Console.WriteLine(
                JsonSerializer.Serialize(
                    usuario,
                    new JsonSerializerOptions
                    {
                        WriteIndented = true
                    }));

            var response = await _httpClient.PostAsJsonAsync(
                "RegistrarUsuario",
                usuario);

            var contenido = await response.Content.ReadAsStringAsync();

            Console.WriteLine("Status: " + response.StatusCode);
            Console.WriteLine("Respuesta:");
            Console.WriteLine(contenido);

            if (!response.IsSuccessStatusCode)
            {
                throw new Exception(contenido);
            }
        }

        public async Task<List<UsuarioExternoDto>> ObtenerUsuariosAsync()
        {
            var response = await _httpClient.GetAsync("ConsultarUsuarios");

            response.EnsureSuccessStatusCode();

            var json = await response.Content.ReadAsStringAsync();

            var options = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            };

            var resultado = JsonSerializer.Deserialize<SecurityConsultarUsuariosResponse>(
                json,
                options);

            if (resultado == null || resultado.Resultado == null)
                return new List<UsuarioExternoDto>();

            return resultado.Resultado.Select(x => new UsuarioExternoDto
            {
                IdUsuarioExterno = x.UsuarioId,
                Nombre = $"{x.Nombre} {x.Apellido}".Trim(),
                Correo = x.Correo,
                Notas = x.Notas ?? "",
                Estado = x.Activo,
                UsuarioCreacion = x.UsuarioRegistro,
                FechaCreacion = x.FechaRegistro ?? DateTime.MinValue,
                UsuarioModificacion = x.UsuarioModificacion,
                FechaModificacion = x.FechaModificacion
            }).ToList();
        }

        public async Task ActualizarUsuarioAsync(SecurityApiActualizarUsuarioDto usuario)
        {
            Console.WriteLine(
                JsonSerializer.Serialize(
                    usuario,
                    new JsonSerializerOptions
                    {
                        WriteIndented = true
                    }));

            var response = await _httpClient.PutAsJsonAsync(
                "ActualizarUsuario",
                usuario);

            var contenido = await response.Content.ReadAsStringAsync();

            Console.WriteLine("Status: " + response.StatusCode);
            Console.WriteLine("Respuesta:");
            Console.WriteLine(contenido);

            if (!response.IsSuccessStatusCode)
            {
                throw new Exception(contenido);
            }
        }
    }

}