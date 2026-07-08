using DMFacturacionIABack.RegistrosFacturacion;
using DTFacturacionIABack.RegistrosFacturacion;

namespace BMFacturacionIABack.RegistrosFacturacion
{
    public class BMRegistrosFacturacion : IBMRegistrosFacturacion
    {
        private readonly IDMRegistrosFacturacion _dmRegistrosFacturacion;

        public BMRegistrosFacturacion(
            IDMRegistrosFacturacion dmRegistrosFacturacion
        )
        {
            _dmRegistrosFacturacion = dmRegistrosFacturacion;
        }

        public async Task<RegistroFacturacionListadoResponseDto> ListarRegistrosFacturacionAsync(
            string? busqueda,
            string? estado,
            DateTime? fechaInicio,
            DateTime? fechaFin,
            int pagina,
            int cantidadRegistros
        )
        {
            if (pagina <= 0)
            {
                pagina = 1;
            }

            if (cantidadRegistros <= 0)
            {
                cantidadRegistros = 10;
            }

            if (cantidadRegistros > 100)
            {
                cantidadRegistros = 100;
            }

            estado = NormalizarEstado(estado);

            if (!string.IsNullOrWhiteSpace(estado) &&
                estado != "PROCESADO" &&
                estado != "FACTURADO")
            {
                return new RegistroFacturacionListadoResponseDto
                {
                    Exito = false,
                    Mensaje = "El estado debe ser PROCESADO o FACTURADO.",
                    RegistrosFacturacion = new List<RegistroFacturacionDto>(),
                    TotalRegistros = 0,
                    Pagina = pagina,
                    CantidadRegistros = cantidadRegistros
                };
            }

            if (fechaInicio.HasValue &&
                fechaFin.HasValue &&
                fechaInicio.Value.Date > fechaFin.Value.Date)
            {
                return new RegistroFacturacionListadoResponseDto
                {
                    Exito = false,
                    Mensaje = "La fecha inicial no puede ser mayor que la fecha final.",
                    RegistrosFacturacion = new List<RegistroFacturacionDto>(),
                    TotalRegistros = 0,
                    Pagina = pagina,
                    CantidadRegistros = cantidadRegistros
                };
            }

            return await _dmRegistrosFacturacion.ListarRegistrosFacturacionAsync(
                busqueda,
                estado,
                fechaInicio,
                fechaFin,
                pagina,
                cantidadRegistros
            );
        }

        public async Task<RegistroFacturacionExportarResponseDto> ObtenerRegistrosFacturacionPorIdsAsync(
            ExportarRegistrosFacturacionRequestDto request
        )
        {
            if (request == null ||
                request.IdsRegistros == null ||
                !request.IdsRegistros.Any())
            {
                return new RegistroFacturacionExportarResponseDto
                {
                    Exito = false,
                    Mensaje = "Debe seleccionar al menos un registro para exportar.",
                    RegistrosFacturacion = new List<RegistroFacturacionDto>()
                };
            }

            List<int> idsValidos = request.IdsRegistros
                .Where(id => id > 0)
                .Distinct()
                .ToList();

            if (!idsValidos.Any())
            {
                return new RegistroFacturacionExportarResponseDto
                {
                    Exito = false,
                    Mensaje = "Los registros seleccionados no son válidos.",
                    RegistrosFacturacion = new List<RegistroFacturacionDto>()
                };
            }

            return await _dmRegistrosFacturacion.ObtenerRegistrosFacturacionPorIdsAsync(
                idsValidos
            );
        }

        private static string? NormalizarEstado(
            string? estado
        )
        {
            if (string.IsNullOrWhiteSpace(estado))
            {
                return null;
            }

            return estado.Trim().ToUpper();
        }
    }
}
