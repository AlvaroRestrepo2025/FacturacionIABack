using DTFacturacionIABack.UsuariosExternos;
using System.Data;
using Microsoft.Data.SqlClient;

namespace DMFacturacionIABack.UsuariosExternos
{
    public class DMUsuariosExternos : IDMUsuariosExternos
    {
        private readonly string _connectionString;

        public DMUsuariosExternos(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<List<UsuarioExternoDto>> ObtenerUsuariosAsync()
        {
            List<UsuarioExternoDto> usuarios = new();

            using SqlConnection connection =
                new SqlConnection(_connectionString);

            using SqlCommand command =
                new SqlCommand("sp_ConsultarUsuariosExternos", connection);

            command.CommandType = CommandType.StoredProcedure;

            await connection.OpenAsync();

            using SqlDataReader reader =
                await command.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                usuarios.Add(new UsuarioExternoDto
                {
                    IdUsuarioExterno = Convert.ToInt32(reader["IdUsuarioExterno"]),
                    Nombre = reader["Nombre"].ToString() ?? string.Empty,
                    Correo = reader["Correo"].ToString() ?? string.Empty,
                    Notas = reader["Notas"].ToString() ?? string.Empty,

                    Estado = Convert.ToBoolean(reader["Estado"]),

                    UsuarioCreacion = reader["UsuarioCreacion"].ToString() ?? string.Empty,

                    FechaCreacion = Convert.ToDateTime(reader["FechaCreacion"]),

                    UsuarioModificacion =
                        reader["UsuarioModificacion"] == DBNull.Value
                        ? null
                        : reader["UsuarioModificacion"].ToString(),

                    FechaModificacion =
                        reader["FechaModificacion"] == DBNull.Value
                        ? null
                        : Convert.ToDateTime(reader["FechaModificacion"])
                });
            }

            return usuarios;
        }

        public async Task CrearUsuarioAsync(
     CrearUsuarioExternoDto usuario,
     string password,
     string usuarioCreacion)
        {
            using SqlConnection connection =
                new SqlConnection(_connectionString);

            using SqlCommand command =
                new SqlCommand("sp_CrearUsuarioExterno", connection);

            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@Nombre", usuario.Nombre);
            command.Parameters.AddWithValue("@Correo", usuario.Correo);
            command.Parameters.AddWithValue("@Notas", usuario.Notas);

            command.Parameters.AddWithValue("@PasswordGenerada", password);

            command.Parameters.AddWithValue("@UsuarioCreacion", usuarioCreacion);

            await connection.OpenAsync();

            await command.ExecuteNonQueryAsync();
        }

        public async Task ActualizarUsuarioAsync(
            ActualizarUsuarioExternoDto usuario,
            string usuarioModificacion)
        {
            using SqlConnection connection =
                new SqlConnection(_connectionString);

            using SqlCommand command =
                new SqlCommand("sp_ActualizarUsuarioExterno", connection);

            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@IdUsuarioExterno", usuario.IdUsuarioExterno);
            command.Parameters.AddWithValue("@Nombre", usuario.Nombre);
            command.Parameters.AddWithValue("@Correo", usuario.Correo);
            command.Parameters.AddWithValue("@Notas", usuario.Notas);
            command.Parameters.AddWithValue("@Estado", usuario.Estado);

            command.Parameters.AddWithValue(
                "@UsuarioModificacion",
                usuarioModificacion);

            await connection.OpenAsync();

            await command.ExecuteNonQueryAsync();
        }
    }
}