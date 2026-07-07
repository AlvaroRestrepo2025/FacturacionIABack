namespace DTFacturacionIABack.CierreSesion
{
    public class CierreSesionResponseDto
    {
        public bool Exito { get; set; }

        public string Mensaje { get; set; } = string.Empty;

        public int? IdAuditoriaSesion { get; set; }

        public DateTime? Fecha { get; set; }
    }
}