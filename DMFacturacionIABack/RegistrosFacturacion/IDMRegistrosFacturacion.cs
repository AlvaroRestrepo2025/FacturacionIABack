using DTFacturacionIABack.RegistrosFacturacion;

namespace DMFacturacionIABack.RegistrosFacturacion
{
    public interface IDMRegistrosFacturacion
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
            List<int> idsRegistros
        );
    }
}
