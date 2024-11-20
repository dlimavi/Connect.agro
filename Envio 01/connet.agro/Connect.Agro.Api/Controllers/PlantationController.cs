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
    public class PlantationController : ControllerBase
    {
        
        [HttpGet("List")]
        public async Task<IActionResult> ListPlantations()
        {
            var PlantationService = new PlantationService();
            var Plantations = await PlantationService.GetPlantationListAsync();

            return Ok(Plantations);
        }

        [HttpPost]
        public async Task<IActionResult> CreatePlantation([FromBody] CreatePlantationRequest Plantation)
        {
            var PlantationService = new PlantationService();
            var creationResponse = await PlantationService.CreatePlantationAsync(Plantation);

            return Created("api/Plantations/{id}", creationResponse);
        }

        [HttpPut]
        public async Task<IActionResult> UpdatePlantation([FromBody] Plantation plantation)
        {
            var PlantationService = new PlantationService();
            await PlantationService.UpdatePlantationAsync(plantation);

            return Ok();
        }

        [HttpDelete]
         public async Task<IActionResult> DeletePlantation([FromQuery] int plantationId)
        {
            var PlantationService = new PlantationService();
            var deleted = await PlantationService.DeletePlantationAsync(plantationId);

            if(!deleted)
            {
                return NotFound();
            }

            return Ok();
        }
    }
}
