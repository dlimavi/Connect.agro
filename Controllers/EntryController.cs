using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Services;
using Connect.Agro.Web.Filters;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace Connect.Agro.Web.Controllers;

[AuthenticatedUserFilter]
public class EntryController : Controller
{
    public async Task<IActionResult> Index()
    {
        var EntryService = new EntryService();
        var listResponse = await  EntryService.GetEntryList();

        return View(listResponse.Payload);
    }
    public async Task<IActionResult> Register()
    {
        await SetSelectFields();
        return View();
    }
    public async Task<IActionResult> Edit(int id)
    {
        var EntryService = new EntryService();
        var payloadResponse = await EntryService.GetEntryById(id);

        await SetSelectFields(payloadResponse.Payload);

        return View(payloadResponse.Payload);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(Entry Entry)
    {
        var EntryService = new EntryService();
        await EntryService.UpdateEntry(Entry);
        return RedirectToAction("Index");
    }

    [HttpPost]
    public async Task<IActionResult> Register(CreateEntryRequest request)
    {
        var EntryService = new EntryService();
        await EntryService.CreateEntry(request);
        return RedirectToAction("Index");
    }

    public async Task<IActionResult> Delete(int id)
    {
        var EntryService = new EntryService();
        await EntryService.DeleteEntry(id);
        return RedirectToAction("Index");
    }

    private async Task SetSelectFields(Entry? entry = null)
    {

        var suppliesService = new SupplyService();
        var supplierService = new SupplierService();

        var supplies = (await suppliesService.GetSupplyList()).Payload;
        var suppliers = (await supplierService.GetSupplierList()).Payload;

        SelectList supplysSelect;
        SelectList suppliersSelect;

        if (entry != null)
        {
            supplysSelect = new SelectList(supplies, "Id", "Description", entry.ProductId);
            suppliersSelect = new SelectList(suppliers, "Id", "BusinessName", entry.SupplierId);
        }
        else
        {
            supplysSelect = new SelectList(supplies, "Id", "Description");
            suppliersSelect = new SelectList(suppliers, "Id", "BusinessName");
        }

        ViewBag.Supplies = supplysSelect;
        ViewBag.Suppliers = suppliersSelect;
    }

}
