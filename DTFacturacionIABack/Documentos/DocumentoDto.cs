namespace DTFacturacionIABack.Documentos
{
    public class DocumentoDto
    {
        public int IdSolicitud { get; set; }

        public Guid Identificador { get; set; }

        public int IdEmpresa { get; set; }

        public string Nit { get; set; } = string.Empty;

        public string Empresa { get; set; } = string.Empty;

        public int CantidadArchivos { get; set; }

        public string UsuarioCreacion { get; set; } = string.Empty;

        public DateTime FechaCreacion { get; set; }

        public string? UsuarioModificacion { get; set; }

        public DateTime? FechaModificacion { get; set; }

        public string Estado { get; set; } = string.Empty;
    }
}
