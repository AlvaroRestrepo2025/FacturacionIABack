using DTFacturacionIABack.UsuariosExternos;

namespace BMFacturacionIABack.UsuariosExternos
{
    public interface IBMUsuariosExternos
    {
        Task<List<UsuarioExternoDto>> ObtenerUsuariosAsync();

        Task CrearUsuarioAsync(CrearUsuarioExternoDto usuario);

        Task ActualizarUsuarioAsync(
            ActualizarUsuarioExternoDto usuario);
    }
}