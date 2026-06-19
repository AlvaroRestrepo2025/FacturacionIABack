using System.Data;
using DTFacturacionIABack.Empresas;
using Microsoft.Data.SqlClient;

namespace DMFacturacionIABack.Empresas
{
    public class DMEmpresas : IDMEmpresas
    {
        private readonly string _connectionString;

        public DMEmpresas(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<EmpresaListadoResponseDto> ListarEmpresasAsync(
            string? busqueda,
            int pagina,
            int cantidadRegistros
        )
        {
            EmpresaListadoResponseDto respuesta = new EmpresaListadoResponseDto
            {
                Exito = true,
                Mensaje = "Empresas consultadas correctamente.",
                Pagina = pagina,
                CantidadRegistros = cantidadRegistros
            };

            try
            {
                using SqlConnection connection = new SqlConnection(_connectionString);
                using SqlCommand command = new SqlCommand("dbo.sp_ListarEmpresas", connection);

                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add("@Busqueda", SqlDbType.NVarChar, 200).Value =
                    string.IsNullOrWhiteSpace(busqueda)
                        ? DBNull.Value
                        : busqueda.Trim();

                command.Parameters.Add("@Pagina", SqlDbType.Int).Value = pagina;
                command.Parameters.Add("@CantidadRegistros", SqlDbType.Int).Value = cantidadRegistros;

                await connection.OpenAsync();

                using SqlDataReader reader = await command.ExecuteReaderAsync();

                while (await reader.ReadAsync())
                {
                    if (reader["IdEmpresa"] == DBNull.Value)
                    {
                        continue;
                    }

                    EmpresaDto empresa = new EmpresaDto
                    {
                        IdEmpresa = Convert.ToInt32(reader["IdEmpresa"]),
                        Nit = reader["Nit"]?.ToString() ?? string.Empty,
                        RazonSocial = reader["RazonSocial"]?.ToString() ?? string.Empty,
                        Direccion = reader["Direccion"]?.ToString() ?? string.Empty,
                        Cliente = reader["Cliente"]?.ToString() ?? string.Empty,
                        Telefono = reader["Telefono"]?.ToString() ?? string.Empty,
                        ComercialPositivo = reader["ComercialPositivo"]?.ToString() ?? string.Empty,
                        Supervisor = reader["Supervisor"]?.ToString() ?? string.Empty,
                        CR = reader["CR"]?.ToString() ?? string.Empty,
                        Ciudad = reader["Ciudad"]?.ToString() ?? string.Empty,
                        Moneda = reader["Moneda"]?.ToString() ?? string.Empty,
                        UsuarioCreacion = reader["UsuarioCreacion"]?.ToString() ?? string.Empty,

                        FechaCreacion = reader["FechaCreacion"] == DBNull.Value
                            ? DateTime.MinValue
                            : Convert.ToDateTime(reader["FechaCreacion"]),

                        UsuarioModificacion = reader["UsuarioModificacion"] == DBNull.Value
                            ? null
                            : reader["UsuarioModificacion"]?.ToString(),

                        FechaModificacion = reader["FechaModificacion"] == DBNull.Value
                            ? null
                            : Convert.ToDateTime(reader["FechaModificacion"]),

                        Estado = reader["Estado"] != DBNull.Value && Convert.ToBoolean(reader["Estado"]),

                        TotalRegistros = reader["TotalRegistros"] == DBNull.Value
                            ? 0
                            : Convert.ToInt32(reader["TotalRegistros"])
                    };

                    respuesta.Empresas.Add(empresa);

                    if (respuesta.TotalRegistros == 0)
                    {
                        respuesta.TotalRegistros = empresa.TotalRegistros;
                    }
                }

                return respuesta;
            }
            catch (Exception ex)
            {
                return new EmpresaListadoResponseDto
                {
                    Exito = false,
                    Mensaje = $"Error al consultar empresas: {ex.Message}",
                    Empresas = new List<EmpresaDto>(),
                    TotalRegistros = 0,
                    Pagina = pagina,
                    CantidadRegistros = cantidadRegistros
                };
            }
        }

        public async Task<EmpresaGuardarResponseDto> CrearEmpresaAsync(
            CrearEmpresaRequestDto request
        )
        {
            try
            {
                using SqlConnection connection = new SqlConnection(_connectionString);
                using SqlCommand command = new SqlCommand("dbo.sp_CrearEmpresa", connection);

                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add("@Nit", SqlDbType.NVarChar, 30).Value = request.Nit.Trim();
                command.Parameters.Add("@RazonSocial", SqlDbType.NVarChar, 200).Value = request.RazonSocial.Trim();
                command.Parameters.Add("@Direccion", SqlDbType.NVarChar, 250).Value = request.Direccion.Trim();
                command.Parameters.Add("@Cliente", SqlDbType.NVarChar, 200).Value = request.Cliente.Trim();
                command.Parameters.Add("@Telefono", SqlDbType.NVarChar, 50).Value = request.Telefono.Trim();
                command.Parameters.Add("@ComercialPositivo", SqlDbType.NVarChar, 150).Value = request.ComercialPositivo.Trim();
                command.Parameters.Add("@Supervisor", SqlDbType.NVarChar, 150).Value = request.Supervisor.Trim();
                command.Parameters.Add("@CR", SqlDbType.NVarChar, 50).Value = request.CR.Trim();
                command.Parameters.Add("@Ciudad", SqlDbType.NVarChar, 100).Value = request.Ciudad.Trim();
                command.Parameters.Add("@Moneda", SqlDbType.NVarChar, 20).Value = request.Moneda.Trim();
                command.Parameters.Add("@UsuarioCreacion", SqlDbType.NVarChar, 100).Value = request.UsuarioCreacion.Trim();

                await connection.OpenAsync();

                using SqlDataReader reader = await command.ExecuteReaderAsync();

                if (await reader.ReadAsync())
                {
                    return new EmpresaGuardarResponseDto
                    {
                        Exito = reader["Exito"] != DBNull.Value && Convert.ToBoolean(reader["Exito"]),
                        Mensaje = reader["Mensaje"]?.ToString() ?? string.Empty,
                        IdEmpresa = reader["IdEmpresa"] == DBNull.Value
                            ? null
                            : Convert.ToInt32(reader["IdEmpresa"])
                    };
                }

                return new EmpresaGuardarResponseDto
                {
                    Exito = false,
                    Mensaje = "No se obtuvo respuesta al crear la empresa.",
                    IdEmpresa = null
                };
            }
            catch (Exception ex)
            {
                return new EmpresaGuardarResponseDto
                {
                    Exito = false,
                    Mensaje = $"Error al crear empresa: {ex.Message}",
                    IdEmpresa = null
                };
            }
        }

        public async Task<EmpresaGuardarResponseDto> ActualizarEmpresaAsync(
            ActualizarEmpresaRequestDto request
        )
        {
            try
            {
                using SqlConnection connection = new SqlConnection(_connectionString);
                using SqlCommand command = new SqlCommand("dbo.sp_ActualizarEmpresa", connection);

                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add("@IdEmpresa", SqlDbType.Int).Value = request.IdEmpresa;
                command.Parameters.Add("@Nit", SqlDbType.NVarChar, 30).Value = request.Nit.Trim();
                command.Parameters.Add("@RazonSocial", SqlDbType.NVarChar, 200).Value = request.RazonSocial.Trim();
                command.Parameters.Add("@Direccion", SqlDbType.NVarChar, 250).Value = request.Direccion.Trim();
                command.Parameters.Add("@Cliente", SqlDbType.NVarChar, 200).Value = request.Cliente.Trim();
                command.Parameters.Add("@Telefono", SqlDbType.NVarChar, 50).Value = request.Telefono.Trim();
                command.Parameters.Add("@ComercialPositivo", SqlDbType.NVarChar, 150).Value = request.ComercialPositivo.Trim();
                command.Parameters.Add("@Supervisor", SqlDbType.NVarChar, 150).Value = request.Supervisor.Trim();
                command.Parameters.Add("@CR", SqlDbType.NVarChar, 50).Value = request.CR.Trim();
                command.Parameters.Add("@Ciudad", SqlDbType.NVarChar, 100).Value = request.Ciudad.Trim();
                command.Parameters.Add("@Moneda", SqlDbType.NVarChar, 20).Value = request.Moneda.Trim();
                command.Parameters.Add("@Estado", SqlDbType.Bit).Value = request.Estado;
                command.Parameters.Add("@UsuarioModificacion", SqlDbType.NVarChar, 100).Value = request.UsuarioModificacion.Trim();

                await connection.OpenAsync();

                using SqlDataReader reader = await command.ExecuteReaderAsync();

                if (await reader.ReadAsync())
                {
                    return new EmpresaGuardarResponseDto
                    {
                        Exito = reader["Exito"] != DBNull.Value && Convert.ToBoolean(reader["Exito"]),
                        Mensaje = reader["Mensaje"]?.ToString() ?? string.Empty,
                        IdEmpresa = reader["IdEmpresa"] == DBNull.Value
                            ? null
                            : Convert.ToInt32(reader["IdEmpresa"])
                    };
                }

                return new EmpresaGuardarResponseDto
                {
                    Exito = false,
                    Mensaje = "No se obtuvo respuesta al actualizar la empresa.",
                    IdEmpresa = null
                };
            }
            catch (Exception ex)
            {
                return new EmpresaGuardarResponseDto
                {
                    Exito = false,
                    Mensaje = $"Error al actualizar empresa: {ex.Message}",
                    IdEmpresa = null
                };
            }
        }
    }
}