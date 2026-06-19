using DMFacturacionIABack.Empresas;
using DTFacturacionIABack.Empresas;

namespace BMFacturacionIABack.Empresas
{
    public class BMEmpresas : IBMEmpresas
    {
        private readonly IDMEmpresas _dmEmpresas;

        public BMEmpresas(IDMEmpresas dmEmpresas)
        {
            _dmEmpresas = dmEmpresas;
        }

        public async Task<EmpresaListadoResponseDto> ListarEmpresasAsync(
            string? busqueda,
            int pagina,
            int cantidadRegistros
        )
        {
            if (pagina <= 0)
            {
                pagina = 1;
            }

            if (cantidadRegistros <= 0)
            {
                cantidadRegistros = 10;
            }

            if (cantidadRegistros > 100)
            {
                cantidadRegistros = 100;
            }

            return await _dmEmpresas.ListarEmpresasAsync(
                busqueda,
                pagina,
                cantidadRegistros
            );
        }

        public async Task<EmpresaGuardarResponseDto> CrearEmpresaAsync(
            CrearEmpresaRequestDto request
        )
        {
            EmpresaGuardarResponseDto validacion = ValidarCrearEmpresa(request);

            if (!validacion.Exito)
            {
                return validacion;
            }

            NormalizarCrearEmpresa(request);

            return await _dmEmpresas.CrearEmpresaAsync(request);
        }

        public async Task<EmpresaGuardarResponseDto> ActualizarEmpresaAsync(
            int idEmpresa,
            ActualizarEmpresaRequestDto request
        )
        {
            EmpresaGuardarResponseDto validacion = ValidarActualizarEmpresa(
                idEmpresa,
                request
            );

            if (!validacion.Exito)
            {
                return validacion;
            }

            request.IdEmpresa = idEmpresa;

            NormalizarActualizarEmpresa(request);

            return await _dmEmpresas.ActualizarEmpresaAsync(request);
        }

        private static EmpresaGuardarResponseDto ValidarCrearEmpresa(
            CrearEmpresaRequestDto request
        )
        {
            if (request == null)
            {
                return CrearRespuestaError("La información de la empresa es obligatoria.");
            }

            if (string.IsNullOrWhiteSpace(request.Nit))
            {
                return CrearRespuestaError("El NIT es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(request.RazonSocial))
            {
                return CrearRespuestaError("La razón social es obligatoria.");
            }

            if (string.IsNullOrWhiteSpace(request.Direccion))
            {
                return CrearRespuestaError("La dirección es obligatoria.");
            }

            if (string.IsNullOrWhiteSpace(request.Cliente))
            {
                return CrearRespuestaError("El cliente es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(request.Telefono))
            {
                return CrearRespuestaError("El teléfono es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(request.ComercialPositivo))
            {
                return CrearRespuestaError("El comercial Positivo es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(request.Supervisor))
            {
                return CrearRespuestaError("El supervisor es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(request.CR))
            {
                return CrearRespuestaError("El CR es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(request.Ciudad))
            {
                return CrearRespuestaError("La ciudad es obligatoria.");
            }

            if (string.IsNullOrWhiteSpace(request.Moneda))
            {
                return CrearRespuestaError("La moneda es obligatoria.");
            }

            if (string.IsNullOrWhiteSpace(request.UsuarioCreacion))
            {
                return CrearRespuestaError("El usuario de creación es obligatorio.");
            }

            return new EmpresaGuardarResponseDto
            {
                Exito = true,
                Mensaje = "Validación correcta."
            };
        }

        private static EmpresaGuardarResponseDto ValidarActualizarEmpresa(
            int idEmpresa,
            ActualizarEmpresaRequestDto request
        )
        {
            if (idEmpresa <= 0)
            {
                return CrearRespuestaError("El identificador de la empresa es obligatorio.");
            }

            if (request == null)
            {
                return CrearRespuestaError("La información de la empresa es obligatoria.");
            }

            if (request.IdEmpresa > 0 && request.IdEmpresa != idEmpresa)
            {
                return CrearRespuestaError("El identificador de la ruta no coincide con el identificador enviado.");
            }

            if (string.IsNullOrWhiteSpace(request.Nit))
            {
                return CrearRespuestaError("El NIT es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(request.RazonSocial))
            {
                return CrearRespuestaError("La razón social es obligatoria.");
            }

            if (string.IsNullOrWhiteSpace(request.Direccion))
            {
                return CrearRespuestaError("La dirección es obligatoria.");
            }

            if (string.IsNullOrWhiteSpace(request.Cliente))
            {
                return CrearRespuestaError("El cliente es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(request.Telefono))
            {
                return CrearRespuestaError("El teléfono es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(request.ComercialPositivo))
            {
                return CrearRespuestaError("El comercial Positivo es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(request.Supervisor))
            {
                return CrearRespuestaError("El supervisor es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(request.CR))
            {
                return CrearRespuestaError("El CR es obligatorio.");
            }

            if (string.IsNullOrWhiteSpace(request.Ciudad))
            {
                return CrearRespuestaError("La ciudad es obligatoria.");
            }

            if (string.IsNullOrWhiteSpace(request.Moneda))
            {
                return CrearRespuestaError("La moneda es obligatoria.");
            }

            if (string.IsNullOrWhiteSpace(request.UsuarioModificacion))
            {
                return CrearRespuestaError("El usuario de modificación es obligatorio.");
            }

            return new EmpresaGuardarResponseDto
            {
                Exito = true,
                Mensaje = "Validación correcta.",
                IdEmpresa = idEmpresa
            };
        }

        private static void NormalizarCrearEmpresa(
            CrearEmpresaRequestDto request
        )
        {
            request.Nit = request.Nit.Trim();
            request.RazonSocial = request.RazonSocial.Trim();
            request.Direccion = request.Direccion.Trim();
            request.Cliente = request.Cliente.Trim();
            request.Telefono = request.Telefono.Trim();
            request.ComercialPositivo = request.ComercialPositivo.Trim();
            request.Supervisor = request.Supervisor.Trim();
            request.CR = request.CR.Trim();
            request.Ciudad = request.Ciudad.Trim();
            request.Moneda = request.Moneda.Trim();
            request.UsuarioCreacion = request.UsuarioCreacion.Trim();
        }

        private static void NormalizarActualizarEmpresa(
            ActualizarEmpresaRequestDto request
        )
        {
            request.Nit = request.Nit.Trim();
            request.RazonSocial = request.RazonSocial.Trim();
            request.Direccion = request.Direccion.Trim();
            request.Cliente = request.Cliente.Trim();
            request.Telefono = request.Telefono.Trim();
            request.ComercialPositivo = request.ComercialPositivo.Trim();
            request.Supervisor = request.Supervisor.Trim();
            request.CR = request.CR.Trim();
            request.Ciudad = request.Ciudad.Trim();
            request.Moneda = request.Moneda.Trim();
            request.UsuarioModificacion = request.UsuarioModificacion.Trim();
        }

        private static EmpresaGuardarResponseDto CrearRespuestaError(
            string mensaje
        )
        {
            return new EmpresaGuardarResponseDto
            {
                Exito = false,
                Mensaje = mensaje,
                IdEmpresa = null
            };
        }
    }
}