using DMFacturacionIABack.Monedas;
using DTFacturacionIABack.Monedas;

namespace BMFacturacionIABack.Monedas
{
    public class BMMonedas : IBMMonedas
    {
        private readonly IDMMonedas _dmMonedas;

        public BMMonedas(IDMMonedas dmMonedas)
        {
            _dmMonedas = dmMonedas;
        }

        public async Task<MonedaListadoResponseDto> ListarMonedasAsync()
        {
            return await _dmMonedas.ListarMonedasAsync();
        }
    }
}