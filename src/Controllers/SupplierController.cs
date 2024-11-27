using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Controllers;

[Route("api/[controller]")]
[ApiController]
[Authorize]
public class SupplierController : ControllerBase
{
    
    [HttpGet("List")]
    public async Task<IActionResult> ListSuppliers()
    {
        var supplierService = new SupplierService();
        var suppliers = await supplierService.GetSupplierList();

        return Ok(suppliers);
    }

    [HttpGet]
    public async Task<IActionResult> GetSupplier([FromQuery] int id)
    {
        var supplierService = new SupplierService();
        var response = await supplierService.GetSupplierById(id);

        if (response.Code == 404)
        {
            return NotFound();
        }

        return Ok(response);
    }

    [HttpPost]
    public async Task<IActionResult> CreateSupplier([FromBody] CreateSupplierRequest supplier)
    {
        var supplierService = new SupplierService();
        var createdSupplierId = await supplierService.CreateSupplier(supplier);

        return Created("api/suppliers/{id}", createdSupplierId);
    }

    [HttpPut]
    public async Task<IActionResult> UpdateSupplier([FromBody] Supplier supplier)
    {
        var supplierService = new SupplierService();
        var updatedSupplier = await supplierService.UpdateSupplier(supplier);

        

        if (updatedSupplier == null)
        {
            return NotFound();
        }

        return Ok(
            new PayloadResponse<Supplier>(){
                Success = true,
                Code = 200,
                Payload = updatedSupplier
            }
        );
    }

    [HttpDelete]
     public async Task<IActionResult> DeleteSupplier([FromQuery] int supplierId)
    {
        var supplierService = new SupplierService();
        var deleted = await supplierService.DeleteSupplier(supplierId);

        if(!deleted)
        {
            return NotFound();
        }

        return Ok();
    }
}
