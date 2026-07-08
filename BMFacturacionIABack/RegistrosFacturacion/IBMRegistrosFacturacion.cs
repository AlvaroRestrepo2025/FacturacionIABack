using DTFacturacionIABack.RegistrosFacturacion;

namespace BMFacturacionIABack.RegistrosFacturacion
{
    public interface IBMRegistrosFacturacion
    {
        Task<RegistroFacturacionListadoResponseDto> ListarRegistrosFacturacionAsync(
            string? busqueda,
            string? estado,
            DateTime? fechaInicio,
            DateTime? fechaFin,
            int pagina,
            int cantidadRegistros
        );

        Task<RegistroFacturacionExportarResponseDto> ObtenerRegistrosFacturacionPorIdsAsync(
            ExportarRegistrosFacturacionRequestDto request
        );
    }
}
