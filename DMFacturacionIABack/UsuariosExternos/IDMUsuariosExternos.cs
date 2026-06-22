using DTFacturacionIABack.UsuariosExternos;

namespace DMFacturacionIABack.UsuariosExternos
{
    public interface IDMUsuariosExternos
    {
        Task<List<UsuarioExternoDto>> ObtenerUsuariosAsync();

        Task CrearUsuarioAsync(
            CrearUsuarioExternoDto usuario,
            string password,
            string usuarioCreacion);

        Task ActualizarUsuarioAsync(
            ActualizarUsuarioExternoDto usuario,
            string usuarioModificacion);
    }
}