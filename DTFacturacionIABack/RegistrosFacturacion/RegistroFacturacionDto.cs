namespace DTFacturacionIABack.RegistrosFacturacion
{
    public class RegistroFacturacionDto
    {
        public int IdRegistroFacturacion { get; set; }

        public string NumeroRegistro { get; set; } = string.Empty;

        public DateTime FechaCreacion { get; set; }

        public string RazonSocial { get; set; } = string.Empty;

        public string Ciudad { get; set; } = string.Empty;

        public string Descripcion { get; set; } = string.Empty;

        public decimal Valor { get; set; }

        public string Moneda { get; set; } = "COP";

        public string Estado { get; set; } = string.Empty;

        public int TotalRegistros { get; set; }
    }
}