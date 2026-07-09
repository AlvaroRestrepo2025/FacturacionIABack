using DTFacturacionIABack.Monedas;

namespace DMFacturacionIABack.Monedas
{
    public interface IDMMonedas
    {
        Task<MonedaListadoResponseDto> ListarMonedasAsync();
    }
}