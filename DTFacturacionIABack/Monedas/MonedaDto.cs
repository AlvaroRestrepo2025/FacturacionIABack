namespace DTFacturacionIABack.Monedas
{
    public class MonedaDto
    {
        public int IdMoneda { get; set; }

        public string Moneda { get; set; } = string.Empty;

        public string UsuarioRegistro { get; set; } = string.Empty;

        public DateTime FechaRegistro { get; set; }

        public string? UsuarioModificacion { get; set; }

        public DateTime? FechaModificacion { get; set; }

        public bool Estado { get; set; }
    }
}