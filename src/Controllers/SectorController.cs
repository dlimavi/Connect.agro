using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Controllers;

[Route("api/[controller]")]
[ApiController]
[Authorize]
public class SectorController : ControllerBase
{

    [HttpGet("List")]
    public async Task<IActionResult> ListSectors()
    {
        var SectorService = new SectorService();
        var Sectors = await SectorService.GetSectorList();

        return Ok(Sectors);
    }

    [HttpGet]
    public async Task<IActionResult> GetSector([FromQuery] int id)
    {
        var SectorService = new SectorService();
        var response = await SectorService.GetSectorById(id);

        if (response.Code == 404)
        {
            return NotFound();
        }

        return Ok(response);
    }

    [HttpPost]
    public async Task<IActionResult> CreateSector([FromBody] CreateSectorRequest createSectorRequest)
    {
        var SectorService = new SectorService();
        await SectorService.CreateSector(createSectorRequest);

        return Created();
    }

    [HttpPut]
    public async Task<IActionResult> UpdateSector([FromBody] Sector Sector)
    {
        var SectorService = new SectorService();
        var updatedSector = await SectorService.UpdateSector(Sector);

        if (updatedSector == null)
        {
            return NotFound();
        }

        return Ok(
            new PayloadResponse<Sector>()
            {
                Success = true,
                Code = 200,
                Payload = updatedSector
            }
        );
    }

    [HttpDelete]
    public async Task<IActionResult> DeleteSector([FromQuery] int SectorId)
    {
        var SectorService = new SectorService();
        var deleted = await SectorService.DeleteSector(SectorId);

        if (!deleted)
        {
            return NotFound();
        }

        return Ok();
    }
}
