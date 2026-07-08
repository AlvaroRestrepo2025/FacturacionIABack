namespace DTFacturacionIABack.RegistrosFacturacion
{
    public class RegistroFacturacionExportarResponseDto
    {
        public bool Exito { get; set; }

        public string Mensaje { get; set; } = string.Empty;

        public List<RegistroFacturacionDto> RegistrosFacturacion { get; set; } = new List<RegistroFacturacionDto>();
    }
}
