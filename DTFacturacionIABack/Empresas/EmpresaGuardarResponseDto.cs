namespace DTFacturacionIABack.Empresas
{
    public class EmpresaGuardarResponseDto
    {
        public bool Exito { get; set; }

        public string Mensaje { get; set; } = string.Empty;

        public int? IdEmpresa { get; set; }
    }
}