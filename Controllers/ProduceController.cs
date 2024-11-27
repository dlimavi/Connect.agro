using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Services;
using Connect.Agro.Web.Filters;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Web.Controllers;

[AuthenticatedUserFilter]
public class ProduceController : Controller
{
    public async Task<IActionResult> Index()
    {
        var ProduceService = new ProduceService();
        var listResponse = await  ProduceService.GetProduceList();

        return View(listResponse.Payload);
    }
    public IActionResult Register()
    {
        return View();
    }
    public async Task<IActionResult> Edit(int id)
    {
        var ProduceService = new ProduceService();
        var payloadResponse = await ProduceService.GetProduceById(id);
        return View(payloadResponse.Payload);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(Produce Produce)
    {
        var ProduceService = new ProduceService();
        await ProduceService.UpdateProduce(Produce);
        return RedirectToAction("Index");
    }

    [HttpPost]
    public async Task<IActionResult> Register(CreateProduceRequest request)
    {
        var ProduceService = new ProduceService();
        await ProduceService.CreateProduce(request);
        return RedirectToAction("Index");
    }

    public async Task<IActionResult> Delete(int id)
    {
        var ProduceService = new ProduceService();
        await ProduceService.DeleteProduce(id);
        return RedirectToAction("Index");
    }

}
