using DTFacturacionIABack.Monedas;

namespace BMFacturacionIABack.Monedas
{
    public interface IBMMonedas
    {
        Task<MonedaListadoResponseDto> ListarMonedasAsync();
    }
}
