using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Services;
using Connect.Agro.Web.Filters;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Web.Controllers;

[AuthenticatedUserFilter]
public class SectorController : Controller
{
    public async Task<IActionResult> Index()
    {
        var SectorService = new SectorService();
        var listResponse = await  SectorService.GetSectorList();

        return View(listResponse.Payload);
    }
    public IActionResult Register()
    {
        return View();
    }
    public async Task<IActionResult> Edit(int id)
    {
        var SectorService = new SectorService();
        var payloadResponse = await SectorService.GetSectorById(id);
        return View(payloadResponse.Payload);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(Sector Sector)
    {
        var SectorService = new SectorService();
        await SectorService.UpdateSector(Sector);
        return RedirectToAction("Index");
    }

    [HttpPost]
    public async Task<IActionResult> Register(CreateSectorRequest request)
    {
        var SectorService = new SectorService();
        await SectorService.CreateSector(request);
        return RedirectToAction("Index");
    }

    public async Task<IActionResult> Delete(int id)
    {
        var SectorService = new SectorService();
        await SectorService.DeleteSector(id);
        return RedirectToAction("Index");
    }

}
