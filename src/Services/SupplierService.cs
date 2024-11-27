using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Repositories;

namespace Connect.Agro.Services;

public class SupplierService
{
    public async Task<ListResponse<Supplier>> GetSupplierList()
    {
        var supplierRepository = new SupplierRepository();
        var suppliers = await supplierRepository.GetAllSuppliersAsync();
        return new ListResponse<Supplier>(){
            Code = 200,
            Message = "Suppliers listed successfully",
            Payload = suppliers
        };
    }

    public async Task<PayloadResponse<Supplier?>> GetSupplierById(int supplierId)
    {
        var supplierRepository = new SupplierRepository();
        var supplier = await supplierRepository.GetByIdAsync(supplierId);

        if (supplier == null)
        {
            return new PayloadResponse<Supplier?>(){
                Code = 404,
                Success = false,
                Payload = null
            };
        }

        return new PayloadResponse<Supplier?>(){
            Code = 200,
            Success = true,
            Payload = supplier
        };
    }

    public async Task<int> CreateSupplier(CreateSupplierRequest createSupplierRequest)
    {
        var supplier = new Supplier(){
            BusinessName = createSupplierRequest.BusinessName,
            Email = createSupplierRequest.Email,
            Document = createSupplierRequest.Document
        };

        var supplierRepository = new SupplierRepository();
        var createdSupplierId = await supplierRepository.InsertAsync(supplier);

        return createdSupplierId;
    }

    public async Task<Supplier?> UpdateSupplier (Supplier supplier)
    {
        var supplierRepository = new SupplierRepository();
        
        var existentSupplier = await supplierRepository.GetByIdAsync(supplier.Id);

        if(existentSupplier == null) 
        {
            return null;
        }
        
        await supplierRepository.UpdateAsync(supplier);

        return supplier;

    }

    public async Task<bool> DeleteSupplier (int supplierId)
    {
        var supplierRepository = new SupplierRepository();
        try
        {

            var existentSupplier = await supplierRepository.GetByIdAsync(supplierId);

            if(existentSupplier == null) 
            {
                return false;
            }

            await supplierRepository.DeleteAsync(supplierId);

            return true;
        }
        catch
        {
            return false;
        }
    }
}
