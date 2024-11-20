using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class SupplyController : ControllerBase
    {
        
        [HttpGet("List")]
        public async Task<IActionResult> ListSupplys()
        {
            var SupplyService = new SupplyService();
            var Supplys = await SupplyService.GetSupplyListAsync();

            return Ok(Supplys);
        }

        [HttpGet]
        public async Task<IActionResult> GetSupply([FromQuery] int id)
        {
            var SupplyService = new SupplyService();
            var response = await SupplyService.GetSupplyByIdAsync(id);

            if (response.Code == 404)
            {
                return NotFound();
            }

            return Ok(response);
        }

        [HttpPost]
        public async Task<IActionResult> CreateSupply([FromBody] CreateSupplyRequest Supply)
        {
            var SupplyService = new SupplyService();
            var createdSupplyId = await SupplyService.CreateSupplyAsync(Supply);

            return Created("api/Supplys/{id}", createdSupplyId);
        }

        [HttpPut]
        public async Task<IActionResult> UpdateSupply([FromBody] Supply Supply)
        {
            var SupplyService = new SupplyService();
            var updatedSupply = await SupplyService.UpdateSupplyAsync(Supply);

            

            if (updatedSupply == null)
            {
                return NotFound();
            }

            return Ok(
                new PayloadResponse<Supply>(){
                    Success = true,
                    Code = 200,
                    Payload = updatedSupply
                }
            );
        }

        [HttpDelete]
         public async Task<IActionResult> DeleteSupply([FromQuery] int SupplyId)
        {
            var SupplyService = new SupplyService();
            var deleted = await SupplyService.DeleteSupplyAsync(SupplyId);

            if(!deleted)
            {
                return NotFound();
            }

            return Ok();
        }
    }
}
