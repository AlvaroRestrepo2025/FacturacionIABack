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
            int? idUsuario,
            string nombreUsuario,
            string tipoCierre,
            string? motivo,
            string? tipoUsuario,
            string? direccionIp,
            string? userAgent,
            string? tokenReferencia
        )
        {
            CierreSesionResponseDto respuesta = new CierreSesionResponseDto();

            using SqlConnection connection = new SqlConnection(_connectionString);
            using SqlCommand command = new SqlCommand("dbo.sp_RegistrarCierreSesion", connection);

            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@IdUsuario", (object?)idUsuario ?? DBNull.Value);
            command.Parameters.AddWithValue("@NombreUsuario", nombreUsuario);
            command.Parameters.AddWithValue("@TipoCierre", tipoCierre);
            command.Parameters.AddWithValue("@Motivo", (object?)motivo ?? DBNull.Value);
            command.Parameters.AddWithValue("@TipoUsuario", (object?)tipoUsuario ?? DBNull.Value);
            command.Parameters.AddWithValue("@DireccionIp", (object?)direccionIp ?? DBNull.Value);
            command.Parameters.AddWithValue("@UserAgent", (object?)userAgent ?? DBNull.Value);
            command.Parameters.AddWithValue("@TokenReferencia", (object?)tokenReferencia ?? DBNull.Value);

            await connection.OpenAsync();

            using SqlDataReader reader = await command.ExecuteReaderAsync();

            if (await reader.ReadAsync())
            {
                respuesta.Exito = reader["Exito"] != DBNull.Value && Convert.ToBoolean(reader["Exito"]);
                respuesta.Mensaje = reader["Mensaje"]?.ToString() ?? string.Empty;

                respuesta.IdAuditoriaCierreSesion = reader["IdAuditoriaCierreSesion"] == DBNull.Value
                    ? null
                    : Convert.ToInt32(reader["IdAuditoriaCierreSesion"]);

                respuesta.FechaCierre = reader["FechaCierre"] == DBNull.Value
                    ? null
                    : Convert.ToDateTime(reader["FechaCierre"]);
            }

            return respuesta;
        }
    }
}