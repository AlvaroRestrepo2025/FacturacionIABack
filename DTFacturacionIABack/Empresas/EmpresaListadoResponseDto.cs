namespace DTFacturacionIABack.Empresas
{
    public class EmpresaListadoResponseDto
    {
        public bool Exito { get; set; }

        public string Mensaje { get; set; } = string.Empty;

        public List<EmpresaDto> Empresas { get; set; } = new List<EmpresaDto>();

        public int TotalRegistros { get; set; }

        public int Pagina { get; set; }

        public int CantidadRegistros { get; set; }
    }
}