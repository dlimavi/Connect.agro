using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Services;
using Connect.Agro.Web.Filters;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace Connect.Agro.Web.Controllers;

[AuthenticatedUserFilter]
public class SaleController : Controller
{
    public async Task<IActionResult> Index()
    {
        var SaleService = new SaleService();
        var listResponse = await  SaleService.GetSaleList();

        return View(listResponse.Payload);
    }

    private async Task SetSelectFields(Sale? sale = null)
    {

        var produceService = new ProduceService();
        var customerService = new CustomerService();

        var produces = (await produceService.GetProduceList()).Payload;
        var customers = (await customerService.GetCustomerList()).Payload;

        SelectList producesSelect;
        SelectList customersSelect;

        if (sale != null)
        {
            producesSelect = new SelectList(produces, "Id", "Description", sale.ProductId);
            customersSelect = new SelectList(customers, "Id", "BusinessName", sale.CustomerId);
        }
        else
        {
            producesSelect = new SelectList(produces, "Id", "Description");
            customersSelect = new SelectList(customers, "Id", "BusinessName");
        }

        ViewBag.Produces = producesSelect;
        ViewBag.Customers = customersSelect;
    }

    public async Task<IActionResult> Register()
    {
        await SetSelectFields();

        return View();
    }

    public async Task<IActionResult> Edit(int id)
    {
        var SaleService = new SaleService();
        var payloadResponse = await SaleService.GetSaleById(id);

        await SetSelectFields(payloadResponse.Payload);

        return View(payloadResponse.Payload);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(Sale Sale)
    {
        var SaleService = new SaleService();
        await SaleService.UpdateSale(Sale);
        return RedirectToAction("Index");
    }

    [HttpPost]
    public async Task<IActionResult> Register(CreateSaleRequest request)
    {
        var SaleService = new SaleService();
        await SaleService.CreateSale(request);

        return RedirectToAction("Index");
    }

    public async Task<IActionResult> Delete(int id)
    {
        var SaleService = new SaleService();
        await SaleService.DeleteSale(id);
        return RedirectToAction("Index");
    }

}
