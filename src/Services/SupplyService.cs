using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Repositories;

namespace Connect.Agro.Services;

public class SupplyService
{
    public async Task<ListResponse<Supply>> GetSupplyList()
    {
        var SupplyRepository = new SupplyRepository();
        var Supplys = await SupplyRepository.GetAllSupplies();
        return new ListResponse<Supply>(){
            Code = 200,
            Message = "Supplys listed successfully",
            Payload = Supplys
        };
    }

    public async Task<PayloadResponse<Supply?>> GetSupplyById(int SupplyId)
    {
        var SupplyRepository = new SupplyRepository();
        var Supply = await SupplyRepository.GetById(SupplyId);

        if (Supply == null)
        {
            return new PayloadResponse<Supply?>(){
                Code = 404,
                Success = false,
                Payload = null
            };
        }

        return new PayloadResponse<Supply?>(){
            Code = 200,
            Success = true,
            Payload = Supply
        };
    }

    public async Task<int> CreateSupply(CreateSupplyRequest createSupplyRequest)
    {
        var Supply = new Supply(){
            Description = createSupplyRequest.Description,
            Price = createSupplyRequest.Price
        };

        var SupplyRepository = new SupplyRepository();
        var createdSupplyId = await SupplyRepository.Insert(Supply);

        return createdSupplyId;
    }

    public async Task<Supply?> UpdateSupply (Supply Supply)
    {
        var SupplyRepository = new SupplyRepository();
        
        var existentSupply = await SupplyRepository.GetById(Supply.Id);

        if(existentSupply == null) 
        {
            return null;
        }
        
        await SupplyRepository.Update(Supply);

        return Supply;

    }

    public async Task<bool> DeleteSupply (int SupplyId)
    {
        var SupplyRepository = new SupplyRepository();
        try
        {
            var existentSupply = await SupplyRepository.GetById(SupplyId);

            if(existentSupply == null) 
            {
                return false;
            }

            await SupplyRepository.Delete(SupplyId);

            return true;
        }
        catch
        {
            return false;
        }
    }
}
