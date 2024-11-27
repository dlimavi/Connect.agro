using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Services;
using Connect.Agro.Web.Filters;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Web.Controllers;

[AuthenticatedUserFilter]
public class SupplierController : Controller
{
    public async Task<IActionResult> Index()
    {
        var supplierService = new SupplierService();
        var listResponse = await  supplierService.GetSupplierList();

        return View(listResponse.Payload);
    }
    public IActionResult Register()
    {
        return View();
    }
    public async Task<IActionResult> Edit(int id)
    {
        var supplierService = new SupplierService();
        var payloadResponse = await supplierService.GetSupplierById(id);
        return View(payloadResponse.Payload);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(Supplier supplier)
    {
        var supplierService = new SupplierService();
        await supplierService.UpdateSupplier(supplier);
        return RedirectToAction("Index");
    }

    [HttpPost]
    public async Task<IActionResult> Register(CreateSupplierRequest request)
    {
        var supplierService = new SupplierService();
        await supplierService.CreateSupplier(request);
        return RedirectToAction("Index");
    }

    public async Task<IActionResult> Delete(int id)
    {
        var supplierService = new SupplierService();
        await supplierService.DeleteSupplier(id);
        return RedirectToAction("Index");
    }

}
