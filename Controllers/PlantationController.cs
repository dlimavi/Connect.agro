using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Services;
using Connect.Agro.Web.Filters;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace Connect.Agro.Web.Controllers;

[AuthenticatedUserFilter]
public class PlantationController : Controller
{
    public async Task<IActionResult> Index()
    {
        var PlantationService = new PlantationService();
        var listResponse = await  PlantationService.GetPlantationList();

        return View(listResponse.Payload);
    }
    public async Task<IActionResult> Register()
    {
        await SetSelectFields();
        return View();
    }
    public async Task<IActionResult> Edit(int id)
    {
        var PlantationService = new PlantationService();
        var payloadResponse = await PlantationService.GetPlantationById(id);

        await SetSelectFields(payloadResponse.Payload);

        return View(payloadResponse.Payload);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(Plantation Plantation)
    {
        var PlantationService = new PlantationService();
        await PlantationService.UpdatePlantation(Plantation);
        return RedirectToAction("Index");
    }

    [HttpPost]
    public async Task<IActionResult> Register(CreatePlantationRequest request)
    {
        var PlantationService = new PlantationService();
        await PlantationService.CreatePlantation(request);
        return RedirectToAction("Index");
    }

    public async Task<IActionResult> Delete(int id)
    {
        var PlantationService = new PlantationService();
        await PlantationService.DeletePlantation(id);
        return RedirectToAction("Index");
    }

    private async Task SetSelectFields(Plantation? plantation = null)
    {

        var produceService = new ProduceService();
        var sectorService = new SectorService();

        var produces = (await produceService.GetProduceList()).Payload;
        var sectors = (await sectorService.GetSectorList()).Payload;

        SelectList producesSelect;
        SelectList customersSelect;

        if (plantation != null)
        {
            producesSelect = new SelectList(produces, "Id", "Description", plantation.ProductId);
            customersSelect = new SelectList(sectors, "Id", "Description", plantation.SectorId);
        }
        else
        {
            producesSelect = new SelectList(produces, "Id", "Description");
            customersSelect = new SelectList(sectors, "Id", "Description");
        }

        ViewBag.Produces = producesSelect;
        ViewBag.Sectors = customersSelect;
    }

}
