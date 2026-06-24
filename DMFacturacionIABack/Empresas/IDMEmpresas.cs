using DTFacturacionIABack.Empresas;

namespace DMFacturacionIABack.Empresas
{
    public interface IDMEmpresas
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
            ActualizarEmpresaRequestDto request
        );
    }
}