using Connect.Agro.Dll.src.Models.Dtos.Reports;
using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Repositories;

namespace Connect.Agro.Services;

public class SaleService
{
    public async Task<ListResponse<SaleReport>> GetSaleList()
    {
        var saleRepository = new SaleRepository();
        var Sales = await saleRepository.GetAllSales();
        return new ListResponse<SaleReport>(){
            Code = 200,
            Message = "Sales listed successfully",
            Payload = Sales
        };
    }

    public async Task<PayloadResponse<Sale>> GetSaleById(int id)
    {
        var saleRepository = new SaleRepository();
        var sale = await saleRepository.GetById(id);
        return new PayloadResponse<Sale>()
        {
            Code = 200,
            Success = true,
            Payload = sale
        };
    }

    public async Task<CreationResponse> CreateSale(CreateSaleRequest createSaleRequest)
    {
        try
        {
            var sale = new Sale(){
                ProductId = createSaleRequest.ProductId,            
                Date = createSaleRequest.Date,
                Quantity = createSaleRequest.Quantity,
                CustomerId = createSaleRequest.CustomerId,
            };

            var storageReportsRepository = new StorageReportsRepository();

            var storageProduce = await storageReportsRepository.GetCurrentProducesStorageByProductId(sale.ProductId);

            if (sale.Quantity > storageProduce.Quantity)
            {
                return new CreationResponse()
                {
                    Code = 400,
                    Success = false,
                    Payload = $"There is not enought of this product to this sale. Current amount{storageProduce.Quantity}"
                };
            }

            var saleRepository = new SaleRepository();
            
            await saleRepository.Insert(sale);

            var response = new CreationResponse(){ Payload = "Sale created successfully"};

            return response;
        }
        catch
        {
            return new CreationResponse(){
                Code = 500,
                Success = false,
                Payload = "Something went wrong while creating the Sale"
            };
        }
    }

    public async Task UpdateSale(Sale Sale)
    {
        var saleRepository = new SaleRepository();
        
        await saleRepository.Update(Sale);
    }

    public async Task<bool> DeleteSale (int id)
    {
        var saleRepository = new SaleRepository();

        var existentSale = await saleRepository.GetById(id);

        if(existentSale == null) 
        {
            return false;
        }

        await saleRepository.Delete(id);

        return true;
    }
}
