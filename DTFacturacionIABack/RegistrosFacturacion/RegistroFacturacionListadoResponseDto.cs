namespace DTFacturacionIABack.RegistrosFacturacion
{
    public class RegistroFacturacionListadoResponseDto
    {
        public bool Exito { get; set; }

        public string Mensaje { get; set; } = string.Empty;

        public List<RegistroFacturacionDto> RegistrosFacturacion { get; set; } = new List<RegistroFacturacionDto>();

        public int TotalRegistros { get; set; }

        public int Pagina { get; set; }

        public int CantidadRegistros { get; set; }
    }
}
