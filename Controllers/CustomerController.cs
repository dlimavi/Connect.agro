using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Services;
using Connect.Agro.Web.Filters;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Web.Controllers;

[AuthenticatedUserFilter]
public class CustomerController : Controller
{
    public async Task<IActionResult> Index()
    {
        var CustomerService = new CustomerService();
        var listResponse = await  CustomerService.GetCustomerList();

        return View(listResponse.Payload);
    }
    public IActionResult Register()
    {
        return View();
    }
    public async Task<IActionResult> Edit(int id)
    {
        var CustomerService = new CustomerService();
        var payloadResponse = await CustomerService.GetCustomerById(id);
        return View(payloadResponse.Payload);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(Customer Customer)
    {
        var CustomerService = new CustomerService();
        await CustomerService.UpdateCustomer(Customer);
        return RedirectToAction("Index");
    }

    [HttpPost]
    public async Task<IActionResult> Register(CreateCustomerRequest request)
    {
        var CustomerService = new CustomerService();
        await CustomerService.CreateCustomer(request);
        return RedirectToAction("Index");
    }

    public async Task<IActionResult> Delete(int id)
    {
        var CustomerService = new CustomerService();
        await CustomerService.DeleteCustomer(id);
        return RedirectToAction("Index");
    }

}
