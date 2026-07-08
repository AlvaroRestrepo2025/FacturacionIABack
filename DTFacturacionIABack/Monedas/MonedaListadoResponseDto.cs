namespace DTFacturacionIABack.Monedas
{
    public class MonedaListadoResponseDto
    {
        public bool Exito { get; set; }

        public string Mensaje { get; set; } = string.Empty;

        public List<MonedaDto> Monedas { get; set; } = new List<MonedaDto>();
    }
}