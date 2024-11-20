using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class CustomerController : ControllerBase
    {
        
        [HttpGet("List")]
        public async Task<IActionResult> ListCustomers()
        {
            var CustomerService = new CustomerService();
            var Customers = await CustomerService.GetCustomerListAsync();

            return Ok(Customers);
        }

        [HttpGet]
        public async Task<IActionResult> GetCustomer([FromQuery] int id)
        {
            var CustomerService = new CustomerService();
            var response = await CustomerService.GetCustomerByIdAsync(id);

            if (response.Code == 404)
            {
                return NotFound();
            }

            return Ok(response);
        }

        [HttpPost]
        public async Task<IActionResult> CreateCustomer([FromBody] CreateCustomerRequest Customer)
        {
            var CustomerService = new CustomerService();
            var createdCustomerId = await CustomerService.CreateCustomerAsync(Customer);

            return Created("api/Customers/{id}", createdCustomerId);
        }

        [HttpPut]
        public async Task<IActionResult> UpdateCustomer([FromBody] Customer Customer)
        {
            var CustomerService = new CustomerService();
            var updatedCustomer = await CustomerService.UpdateCustomerAsync(Customer);

            if (updatedCustomer == null)
            {
                return NotFound();
            }

            return Ok(
                new PayloadResponse<Customer>(){
                    Success = true,
                    Code = 200,
                    Payload = updatedCustomer
                }
            );
        }

        [HttpDelete]
         public async Task<IActionResult> DeleteCustomer([FromQuery] int CustomerId)
        {
            var CustomerService = new CustomerService();
            var deleted = await CustomerService.DeleteCustomerAsync(CustomerId);

            if(!deleted)
            {
                return NotFound();
            }

            return Ok();
        }
    }
}
