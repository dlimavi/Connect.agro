using Connect.Agro.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Api.Controllers;

[Route("api/[controller]")]
[ApiController]
[Authorize]
public class StorageReportsController : ControllerBase
{
    [HttpGet("ProducesStorageReport")]
    public async Task<IActionResult> GetProducesStorageReportAsync()
    {
        var storageReportsRepository = new StorageReportsRepository();
        var report = await storageReportsRepository.GetCurrentProducesStorage();

        return Ok(report);
    }

    [HttpGet("SuppliesStorageReport")]
    public async Task<IActionResult> GetSuppliesStorageReportAsync()
    {
        var storageReportsRepository = new StorageReportsRepository();
        var report = await storageReportsRepository.GetCurrentSuppliesStorage();

        return Ok(report);
    }
}
