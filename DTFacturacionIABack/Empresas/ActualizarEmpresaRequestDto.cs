namespace DTFacturacionIABack.Empresas
{
    public class ActualizarEmpresaRequestDto
    {
        public int IdEmpresa { get; set; }

        public string Nit { get; set; } = string.Empty;

        public string RazonSocial { get; set; } = string.Empty;

        public string Direccion { get; set; } = string.Empty;

        public string Cliente { get; set; } = string.Empty;

        public string Telefono { get; set; } = string.Empty;

        public string ComercialPositivo { get; set; } = string.Empty;

        public string Supervisor { get; set; } = string.Empty;

        public string CR { get; set; } = string.Empty;

        public string Ciudad { get; set; } = string.Empty;

        public string Moneda { get; set; } = string.Empty;

        public bool Estado { get; set; }

        public string UsuarioModificacion { get; set; } = string.Empty;
    }
}