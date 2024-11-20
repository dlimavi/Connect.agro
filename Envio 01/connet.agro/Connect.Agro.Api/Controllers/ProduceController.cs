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
    public class ProduceController : ControllerBase
    {
        
        [HttpGet("List")]
        public async Task<IActionResult> ListProduces()
        {
            var ProduceService = new ProduceService();
            var Produces = await ProduceService.GetProduceListAsync();

            return Ok(Produces);
        }

        [HttpGet]
        public async Task<IActionResult> GetProduce([FromQuery] int id)
        {
            var ProduceService = new ProduceService();
            var response = await ProduceService.GetProduceByIdAsync(id);

            if (response.Code == 404)
            {
                return NotFound();
            }

            return Ok(response);
        }

        [HttpPost]
        public async Task<IActionResult> CreateProduce([FromBody] CreateProduceRequest Produce)
        {
            var ProduceService = new ProduceService();
            var createdProduceId = await ProduceService.CreateProduceAsync(Produce);

            return Created("api/Produces/{id}", createdProduceId);
        }

        [HttpPut]
        public async Task<IActionResult> UpdateProduce([FromBody] Produce Produce)
        {
            var ProduceService = new ProduceService();
            var updatedProduce = await ProduceService.UpdateProduceAsync(Produce);

            

            if (updatedProduce == null)
            {
                return NotFound();
            }

            return Ok(
                new PayloadResponse<Produce>(){
                    Success = true,
                    Code = 200,
                    Payload = updatedProduce
                }
            );
        }

        [HttpDelete]
         public async Task<IActionResult> DeleteProduce([FromQuery] int ProduceId)
        {
            var ProduceService = new ProduceService();
            var deleted = await ProduceService.DeleteProduceAsync(ProduceId);

            if(!deleted)
            {
                return NotFound();
            }

            return Ok();
        }
    }
}
