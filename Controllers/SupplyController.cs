using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Services;
using Connect.Agro.Web.Filters;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Web.Controllers;

[AuthenticatedUserFilter]
public class SupplyController : Controller
{
    public async Task<IActionResult> Index()
    {
        var SupplyService = new SupplyService();
        var listResponse = await  SupplyService.GetSupplyList();

        return View(listResponse.Payload);
    }
    public IActionResult Register()
    {
        return View();
    }
    public async Task<IActionResult> Edit(int id)
    {
        var SupplyService = new SupplyService();
        var payloadResponse = await SupplyService.GetSupplyById(id);
        return View(payloadResponse.Payload);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(Supply Supply)
    {
        var SupplyService = new SupplyService();
        await SupplyService.UpdateSupply(Supply);
        return RedirectToAction("Index");
    }

    [HttpPost]
    public async Task<IActionResult> Register(CreateSupplyRequest request)
    {
        var SupplyService = new SupplyService();
        await SupplyService.CreateSupply(request);
        return RedirectToAction("Index");
    }

    public async Task<IActionResult> Delete(int id)
    {
        var SupplyService = new SupplyService();
        await SupplyService.DeleteSupply(id);
        return RedirectToAction("Index");
    }

}
