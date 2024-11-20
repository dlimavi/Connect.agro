using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class SaleController : ControllerBase
    {
        
        [HttpGet("List")]
        public async Task<IActionResult> ListSales()
        {
            var SaleService = new SaleService();
            var Sales = await SaleService.GetSaleListAsync();

            return Ok(Sales);
        }

        [HttpPost]
        public async Task<IActionResult> CreateSale([FromBody] CreateSaleRequest Sale)
        {
            var SaleService = new SaleService();
            var creationResponse = await SaleService.CreateSaleAsync(Sale);

            return Created("api/Sales/{id}", creationResponse);
        }

        [HttpPut]
        public async Task<IActionResult> UpdateSale([FromBody] Sale Sale)
        {
            var SaleService = new SaleService();
            await SaleService.UpdateSaleAsync(Sale);

            return Ok();
        }

        [HttpDelete]
        public async Task<IActionResult> DeleteSale([FromQuery] int SaleId)
        {
            var SaleService = new SaleService();
            var deleted = await SaleService.DeleteSaleAsync(SaleId);

            if (!deleted)
            {
                return NotFound();
            }

            return Ok();
        }
    }
}
