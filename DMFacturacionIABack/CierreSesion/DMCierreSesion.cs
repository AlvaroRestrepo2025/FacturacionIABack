using System.Data;
using DTFacturacionIABack.CierreSesion;
using Microsoft.Data.SqlClient;

namespace DMFacturacionIABack.CierreSesion
{
    public class DMCierreSesion : IDMCierreSesion
    {
        private readonly string _connectionString;

        public DMCierreSesion(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<CierreSesionResponseDto> RegistrarCierreSesionAsync(
            string nombreUsuario,
            string? apellido,
            string motivo,
            string? rol,
            bool exitoso
        )
        {
            CierreSesionResponseDto respuesta = new CierreSesionResponseDto();

            using SqlConnection connection = new SqlConnection(_connectionString);
            using SqlCommand command = new SqlCommand("dbo.sp_RegistrarSesion", connection);

            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@NombreUsuario", nombreUsuario);
            command.Parameters.AddWithValue("@Apellido", (object?)apellido ?? DBNull.Value);
            command.Parameters.AddWithValue("@Motivo", motivo);
            command.Parameters.AddWithValue("@Rol", (object?)rol ?? DBNull.Value);
            command.Parameters.AddWithValue("@Exitoso", exitoso);

            await connection.OpenAsync();

            using SqlDataReader reader = await command.ExecuteReaderAsync();

            if (await reader.ReadAsync())
            {
                respuesta.Exito = reader["Exito"] != DBNull.Value && Convert.ToBoolean(reader["Exito"]);
                respuesta.Mensaje = reader["Mensaje"]?.ToString() ?? string.Empty;

                respuesta.IdAuditoriaSesion = reader["IdAuditoriaSesion"] == DBNull.Value
                    ? null
                    : Convert.ToInt32(reader["IdAuditoriaSesion"]);

                respuesta.Fecha = reader["Fecha"] == DBNull.Value
                    ? null
                    : Convert.ToDateTime(reader["Fecha"]);
            }

            return respuesta;
        }
    }
}