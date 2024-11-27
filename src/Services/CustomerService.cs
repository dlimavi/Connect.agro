using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Repositories;

namespace Connect.Agro.Services;

public class CustomerService
{
    public async Task<ListResponse<Customer>> GetCustomerList()
    {
        var CustomerRepository = new CustomerRepository();
        var Customers = await CustomerRepository.GetAllCustomersAsync();
        return new ListResponse<Customer>(){
            Code = 200,
            Message = "Customers listed successfully",
            Payload = Customers
        };
    }

    public async Task<PayloadResponse<Customer?>> GetCustomerById(int CustomerId)
    {
        var CustomerRepository = new CustomerRepository();
        var Customer = await CustomerRepository.GetById(CustomerId);

        if (Customer == null)
        {
            return new PayloadResponse<Customer?>(){
                Code = 404,
                Success = false,
                Payload = null
            };
        }

        return new PayloadResponse<Customer?>(){
            Code = 200,
            Success = true,
            Payload = Customer
        };
    }

    public async Task<int> CreateCustomer(CreateCustomerRequest createCustomerRequest)
    {
        var Customer = new Customer(){
            BusinessName = createCustomerRequest.BusinessName,
            Email = createCustomerRequest.Email,
            Document = createCustomerRequest.Document,
            Address = createCustomerRequest.Address
        };

        var CustomerRepository = new CustomerRepository();
        var createdCustomerId = await CustomerRepository.InsertAsync(Customer);

        return createdCustomerId;
    }

    public async Task<Customer?> UpdateCustomer (Customer Customer)
    {
        var CustomerRepository = new CustomerRepository();
        
        var existentCustomer = await CustomerRepository.GetById(Customer.Id);

        if(existentCustomer == null) 
        {
            return null;
        }
        
        await CustomerRepository.Update(Customer);

        return Customer;

    }

    public async Task<bool> DeleteCustomer (int CustomerId)
    {
        var CustomerRepository = new CustomerRepository();
        try
        {
            var existentCustomer = await CustomerRepository.GetById(CustomerId);

            if(existentCustomer == null) 
            {
                return false;
            }

            await CustomerRepository.DeleteAsync(CustomerId);

            return true;
        }
        catch
        {
            return false;
        }
    }
}
