using BMFacturacionIABack.Services;
using DTFacturacionIABack.UsuariosExternos;

namespace BMFacturacionIABack.Services
{
    public interface ISecurityApiService
    {
        Task RegistrarUsuarioAsync(SecurityApiRegistrarUsuarioDto usuario);
        Task<List<UsuarioExternoDto>> ObtenerUsuariosAsync();
        Task ActualizarUsuarioAsync(SecurityApiActualizarUsuarioDto usuario);
    }
}