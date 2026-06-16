namespace DTFacturacionIABack.CierreSesion
{
    public class CierreSesionResponseDto
    {
        public bool Exito { get; set; }

        public string Mensaje { get; set; } = string.Empty;

        public int? IdAuditoriaCierreSesion { get; set; }

        public DateTime? FechaCierre { get; set; }
    }
}