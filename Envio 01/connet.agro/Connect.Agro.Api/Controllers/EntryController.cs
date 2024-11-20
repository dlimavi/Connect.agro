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
    public class EntryController : ControllerBase
    {
        
        [HttpGet("List")]
        public async Task<IActionResult> ListEntrys()
        {
            var EntryService = new EntryService();
            var Entrys = await EntryService.GetEntryListAsync();

            return Ok(Entrys);
        }

        [HttpPost]
        public async Task<IActionResult> CreateEntry([FromBody] CreateEntryRequest Entry)
        {
            var EntryService = new EntryService();
            var creationResponse = await EntryService.CreateEntryAsync(Entry);

            return Created("api/Entrys/{id}", creationResponse);
        }

        [HttpPut]
        public async Task<IActionResult> UpdateEntry([FromBody] Entry entry)
        {
            var EntryService = new EntryService();
            await EntryService.UpdateEntryAsync(entry);

            return Ok();
        }

        [HttpDelete]
        public async Task<IActionResult> DeleteEntry([FromQuery] int EntryId)
        {
            var EntryService = new EntryService();
            var deleted = await EntryService.DeleteEntryAsync(EntryId);

            if (!deleted)
            {
                return NotFound();
            }

            return Ok();
        }
    }
}
