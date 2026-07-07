using DTFacturacionIABack.Documentos;
using Microsoft.Data.SqlClient;
using System.Data;

namespace DMFacturacionIABack.Documentos
{
    public class DMDocumentos : IDMDocumentos
    {
        private readonly string _connectionString;

        public DMDocumentos(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<List<DocumentoDto>> ObtenerDocumentosAsync()
        {
            List<DocumentoDto> documentos = new();

            using SqlConnection connection =
                new SqlConnection(_connectionString);

            using SqlCommand command =
                new SqlCommand("sp_ConsultarDocumentos", connection);

            command.CommandType = CommandType.StoredProcedure;

            await connection.OpenAsync();

            using SqlDataReader reader =
                await command.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                documentos.Add(new DocumentoDto
                {
                    IdSolicitud = Convert.ToInt32(reader["IdSolicitud"]),

                    Identificador =
                        (Guid)reader["Identificador"],

                    IdEmpresa =Convert.ToInt32(reader["IdEmpresa"]),

                    Nit =
                        reader["Nit"].ToString()!,

                    Empresa =
                        reader["Empresa"].ToString()!,

                    CantidadArchivos =
                        Convert.ToInt32(reader["CantidadArchivos"]),

                    UsuarioCreacion =
                        reader["UsuarioCreacion"].ToString()!,

                    FechaCreacion =
                        Convert.ToDateTime(reader["FechaCreacion"]),

                    UsuarioModificacion =
                        reader["UsuarioModificacion"] == DBNull.Value
                            ? null
                            : reader["UsuarioModificacion"].ToString(),

                    FechaModificacion =
                        reader["FechaModificacion"] == DBNull.Value
                            ? null
                            : Convert.ToDateTime(reader["FechaModificacion"]),

                    Estado =
                        reader["Estado"].ToString()!
                });
            }

            return documentos;
        }

        public async Task CrearDocumentoAsync(
     CrearDocumentoDto documento,
     string usuarioCreacion)
        {
            using SqlConnection connection =
                new SqlConnection(_connectionString);

            using SqlCommand command =
                new SqlCommand("sp_CrearDocumento", connection);

            command.CommandType =
                CommandType.StoredProcedure;

            command.Parameters.AddWithValue(
                "@IdEmpresa",
                documento.IdEmpresa);

            command.Parameters.AddWithValue(
                "@CantidadArchivos",
                documento.Archivos.Count);

            command.Parameters.AddWithValue(
                "@UsuarioCreacion",
                usuarioCreacion);

            await connection.OpenAsync();

            int idSolicitud =
                Convert.ToInt32(
                    await command.ExecuteScalarAsync());

            foreach (var archivo in documento.Archivos)
            {
                await CrearArchivoAsync(
                    connection,
                    idSolicitud,
                    archivo);
            }
        }

        public async Task ActualizarDocumentoAsync(
            ActualizarDocumentoDto documento,
            string usuarioModificacion)
        {
            using SqlConnection connection =
                new SqlConnection(_connectionString);

            await connection.OpenAsync();

            int cantidadArchivos =
                documento.Archivos?.Count ?? 0;

            using SqlCommand command =
                new SqlCommand("sp_ActualizarDocumento", connection);

            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue(
                "@IdSolicitud",
                documento.IdSolicitud);

            command.Parameters.AddWithValue(
                "@IdEmpresa",
                documento.IdEmpresa);

            command.Parameters.AddWithValue(
                "@Estado",
                documento.Estado);

            command.Parameters.AddWithValue(
                "@CantidadArchivos",
                cantidadArchivos);

            command.Parameters.AddWithValue(
                "@UsuarioModificacion",
                usuarioModificacion);

            await command.ExecuteNonQueryAsync();

            // Solo reemplazar archivos cuando el usuario cargó nuevos
            if (cantidadArchivos > 0)
            {
                using SqlCommand deleteCommand =
                    new SqlCommand(
                        "sp_EliminarDocumentoArchivos",
                        connection);

                deleteCommand.CommandType =
                    CommandType.StoredProcedure;

                deleteCommand.Parameters.AddWithValue(
                    "@IdSolicitud",
                    documento.IdSolicitud);

                await deleteCommand.ExecuteNonQueryAsync();

                foreach (var archivo in documento.Archivos)
                {
                    await CrearArchivoAsync(
                        connection,
                        documento.IdSolicitud,
                        archivo);
                }
            }
        }

        private async Task CrearArchivoAsync(
            SqlConnection connection,
            int idSolicitud,
            ArchivoDocumentoDto archivo)
        {
            using SqlCommand command =
                new SqlCommand(
                    "sp_CrearDocumentoArchivo",
                    connection);

            command.CommandType =
                CommandType.StoredProcedure;

            command.Parameters.AddWithValue(
                "@IdSolicitud",
                idSolicitud);

            command.Parameters.AddWithValue(
                "@NombreOriginal",
                archivo.NombreArchivo);

            command.Parameters.AddWithValue(
                "@NombreServidor",
                Path.GetFileName(archivo.RutaArchivo));

            command.Parameters.AddWithValue(
                "@Ruta",
                archivo.RutaArchivo);

            command.Parameters.AddWithValue(
                "@Extension",
                Path.GetExtension(archivo.NombreArchivo));

            command.Parameters.AddWithValue(
                "@Tamano",
                archivo.TamanoBytes);

            await command.ExecuteNonQueryAsync();
        }
    }
}