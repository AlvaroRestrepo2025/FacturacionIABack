using System.Data;
using DTFacturacionIABack.Monedas;
using Microsoft.Data.SqlClient;

namespace DMFacturacionIABack.Monedas
{
    public class DMMonedas : IDMMonedas
    {
        private readonly string _connectionString;

        public DMMonedas(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<MonedaListadoResponseDto> ListarMonedasAsync()
        {
            MonedaListadoResponseDto respuesta = new MonedaListadoResponseDto
            {
                Exito = true,
                Mensaje = "Monedas consultadas correctamente."
            };

            try
            {
                using SqlConnection connection = new SqlConnection(_connectionString);
                using SqlCommand command = new SqlCommand("dbo.sp_ListarMonedas", connection);

                command.CommandType = CommandType.StoredProcedure;

                await connection.OpenAsync();

                using SqlDataReader reader = await command.ExecuteReaderAsync();

                while (await reader.ReadAsync())
                {
                    MonedaDto moneda = new MonedaDto
                    {
                        IdMoneda = reader["IdMoneda"] == DBNull.Value
                            ? 0
                            : Convert.ToInt32(reader["IdMoneda"]),

                        Moneda = reader["Moneda"]?.ToString() ?? string.Empty,

                        UsuarioRegistro = reader["UsuarioRegistro"]?.ToString() ?? string.Empty,

                        FechaRegistro = reader["FechaRegistro"] == DBNull.Value
                            ? DateTime.MinValue
                            : Convert.ToDateTime(reader["FechaRegistro"]),

                        UsuarioModificacion = reader["UsuarioModificacion"] == DBNull.Value
                            ? null
                            : reader["UsuarioModificacion"]?.ToString(),

                        FechaModificacion = reader["FechaModificacion"] == DBNull.Value
                            ? null
                            : Convert.ToDateTime(reader["FechaModificacion"]),

                        Estado = reader["Estado"] != DBNull.Value &&
                                 Convert.ToBoolean(reader["Estado"])
                    };

                    respuesta.Monedas.Add(moneda);
                }

                return respuesta;
            }
            catch (Exception ex)
            {
                return new MonedaListadoResponseDto
                {
                    Exito = false,
                    Mensaje = $"Error al consultar monedas: {ex.Message}",
                    Monedas = new List<MonedaDto>()
                };
            }
        }
    }
}