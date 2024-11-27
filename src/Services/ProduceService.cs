using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Repositories;

namespace Connect.Agro.Services;

public class ProduceService
{
    public async Task<ListResponse<Produce>> GetProduceList()
    {
        var ProduceRepository = new ProduceRepository();
        var Produces = await ProduceRepository.GetAllProducesAsync();
        return new ListResponse<Produce>(){
            Code = 200,
            Message = "Produces listed successfully",
            Payload = Produces
        };
    }

    public async Task<PayloadResponse<Produce?>> GetProduceById(int ProduceId)
    {
        var ProduceRepository = new ProduceRepository();
        var Produce = await ProduceRepository.GetById(ProduceId);

        if (Produce == null)
        {
            return new PayloadResponse<Produce?>(){
                Code = 404,
                Success = false,
                Payload = null
            };
        }

        return new PayloadResponse<Produce?>(){
            Code = 200,
            Success = true,
            Payload = Produce
        };
    }

    public async Task<int> CreateProduce(CreateProduceRequest createProduceRequest)
    {
        var Produce = new Produce(){
            Description = createProduceRequest.Description,
            Price = createProduceRequest.Price,
            DaysToGrow = createProduceRequest.DaysToGrow
        };

        var ProduceRepository = new ProduceRepository();
        var createdProduceId = await ProduceRepository.Insert(Produce);

        return createdProduceId;
    }

    public async Task<Produce?> UpdateProduce (Produce Produce)
    {
        var ProduceRepository = new ProduceRepository();
        
        var existentProduce = await ProduceRepository.GetById(Produce.Id);

        if(existentProduce == null) 
        {
            return null;
        }
        
        await ProduceRepository.Update(Produce);

        return Produce;

    }

    public async Task<bool> DeleteProduce (int ProduceId)
    {
        var ProduceRepository = new ProduceRepository();
                    
        try
        {
            var existentProduce = await ProduceRepository.GetById(ProduceId);

            if (existentProduce == null)
            {
                return false;
            }

            await ProduceRepository.Delete(ProduceId);

            return true;
        }
        catch
        {
            return false;
        }
    }
}
