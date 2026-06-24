using DTFacturacionIABack.Empresas;

namespace BMFacturacionIABack.Empresas
{
    public interface IBMEmpresas
    {
        Task<EmpresaListadoResponseDto> ListarEmpresasAsync(
            string? busqueda,
            int pagina,
            int cantidadRegistros
        );

        Task<EmpresaGuardarResponseDto> CrearEmpresaAsync(
            CrearEmpresaRequestDto request
        );

        Task<EmpresaGuardarResponseDto> ActualizarEmpresaAsync(
            int idEmpresa,
            ActualizarEmpresaRequestDto request
        );
    }
}