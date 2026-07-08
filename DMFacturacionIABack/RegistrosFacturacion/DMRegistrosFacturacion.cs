using System.Data;
using DTFacturacionIABack.RegistrosFacturacion;
using Microsoft.Data.SqlClient;

namespace DMFacturacionIABack.RegistrosFacturacion
{
    public class DMRegistrosFacturacion : IDMRegistrosFacturacion
    {
        private readonly string _connectionString;

        public DMRegistrosFacturacion(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<RegistroFacturacionListadoResponseDto> ListarRegistrosFacturacionAsync(
            string? busqueda,
            string? estado,
            DateTime? fechaInicio,
            DateTime? fechaFin,
            int pagina,
            int cantidadRegistros
        )
        {
            RegistroFacturacionListadoResponseDto respuesta = new RegistroFacturacionListadoResponseDto
            {
                Exito = true,
                Mensaje = "Registros para facturación consultados correctamente.",
                Pagina = pagina,
                CantidadRegistros = cantidadRegistros
            };

            try
            {
                using SqlConnection connection = new SqlConnection(_connectionString);
                using SqlCommand command = new SqlCommand("dbo.sp_ListarRegistrosFacturacion", connection);

                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add("@Busqueda", SqlDbType.NVarChar, 200).Value =
                    string.IsNullOrWhiteSpace(busqueda)
                        ? DBNull.Value
                        : busqueda.Trim();

                command.Parameters.Add("@Estado", SqlDbType.NVarChar, 20).Value =
                    string.IsNullOrWhiteSpace(estado)
                        ? DBNull.Value
                        : estado.Trim().ToUpper();

                command.Parameters.Add("@FechaInicio", SqlDbType.Date).Value =
                    fechaInicio.HasValue
                        ? fechaInicio.Value.Date
                        : DBNull.Value;

                command.Parameters.Add("@FechaFin", SqlDbType.Date).Value =
                    fechaFin.HasValue
                        ? fechaFin.Value.Date
                        : DBNull.Value;

                command.Parameters.Add("@Pagina", SqlDbType.Int).Value = pagina;
                command.Parameters.Add("@CantidadRegistros", SqlDbType.Int).Value = cantidadRegistros;

                await connection.OpenAsync();

                using SqlDataReader reader = await command.ExecuteReaderAsync();

                while (await reader.ReadAsync())
                {
                    if (reader["IdRegistroFacturacion"] == DBNull.Value)
                    {
                        continue;
                    }

                    RegistroFacturacionDto registro = new RegistroFacturacionDto
                    {
                        IdRegistroFacturacion = Convert.ToInt32(reader["IdRegistroFacturacion"]),
                        NumeroRegistro = reader["NumeroRegistro"]?.ToString() ?? string.Empty,

                        FechaCreacion = reader["FechaCreacion"] == DBNull.Value
                            ? DateTime.MinValue
                            : Convert.ToDateTime(reader["FechaCreacion"]),

                        RazonSocial = reader["RazonSocial"]?.ToString() ?? string.Empty,
                        Ciudad = reader["Ciudad"]?.ToString() ?? string.Empty,
                        Descripcion = reader["Descripcion"]?.ToString() ?? string.Empty,

                        Valor = reader["Valor"] == DBNull.Value
                            ? 0
                            : Convert.ToDecimal(reader["Valor"]),

                        Moneda = reader["Moneda"] == DBNull.Value
                            ? "COP"
                            : reader["Moneda"]?.ToString() ?? "COP",

                        Estado = reader["Estado"]?.ToString() ?? string.Empty,

                        TotalRegistros = reader["TotalRegistros"] == DBNull.Value
                            ? 0
                            : Convert.ToInt32(reader["TotalRegistros"])
                    };

                    respuesta.RegistrosFacturacion.Add(registro);

                    if (respuesta.TotalRegistros == 0)
                    {
                        respuesta.TotalRegistros = registro.TotalRegistros;
                    }
                }

                return respuesta;
            }
            catch (Exception ex)
            {
                return new RegistroFacturacionListadoResponseDto
                {
                    Exito = false,
                    Mensaje = $"Error al consultar registros para facturación: {ex.Message}",
                    RegistrosFacturacion = new List<RegistroFacturacionDto>(),
                    TotalRegistros = 0,
                    Pagina = pagina,
                    CantidadRegistros = cantidadRegistros
                };
            }
        }

        public async Task<RegistroFacturacionExportarResponseDto> ObtenerRegistrosFacturacionPorIdsAsync(
            List<int> idsRegistros
        )
        {
            try
            {
                string ids = string.Join(
                    ",",
                    idsRegistros
                        .Where(id => id > 0)
                        .Distinct()
                );

                using SqlConnection connection = new SqlConnection(_connectionString);
                using SqlCommand command = new SqlCommand("dbo.sp_ObtenerRegistrosFacturacionPorIds", connection);

                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add("@Ids", SqlDbType.NVarChar).Value = ids;

                await connection.OpenAsync();

                using SqlDataReader reader = await command.ExecuteReaderAsync();

                RegistroFacturacionExportarResponseDto respuesta = new RegistroFacturacionExportarResponseDto
                {
                    Exito = true,
                    Mensaje = "Registros para exportación consultados correctamente."
                };

                while (await reader.ReadAsync())
                {
                    if (reader["IdRegistroFacturacion"] == DBNull.Value)
                    {
                        continue;
                    }

                    RegistroFacturacionDto registro = new RegistroFacturacionDto
                    {
                        IdRegistroFacturacion = Convert.ToInt32(reader["IdRegistroFacturacion"]),

                        NumeroRegistro = reader["NumeroRegistro"]?.ToString() ?? string.Empty,

                        FechaCreacion = reader["FechaCreacion"] == DBNull.Value
                            ? DateTime.MinValue
                            : Convert.ToDateTime(reader["FechaCreacion"]),

                        RazonSocial = reader["RazonSocial"]?.ToString() ?? string.Empty,
                        Ciudad = reader["Ciudad"]?.ToString() ?? string.Empty,
                        Descripcion = reader["Descripcion"]?.ToString() ?? string.Empty,

                        Valor = reader["Valor"] == DBNull.Value
                            ? 0
                            : Convert.ToDecimal(reader["Valor"]),

                        Moneda = reader["Moneda"] == DBNull.Value
                            ? "COP"
                            : reader["Moneda"]?.ToString() ?? "COP",

                        Estado = reader["Estado"]?.ToString() ?? string.Empty
                    };

                    respuesta.RegistrosFacturacion.Add(registro);
                }

                return respuesta;
            }
            catch (Exception ex)
            {
                return new RegistroFacturacionExportarResponseDto
                {
                    Exito = false,
                    Mensaje = $"Error al obtener registros para exportación: {ex.Message}",
                    RegistrosFacturacion = new List<RegistroFacturacionDto>()
                };
            }
        }
    }
}