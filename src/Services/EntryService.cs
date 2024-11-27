using Connect.Agro.Dll.src.Models.Dtos.Reports;
using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Repositories;

namespace Connect.Agro.Services;

public class EntryService
{
    public async Task<ListResponse<EntryReport>> GetEntryList()
    {
        var EntryRepository = new EntryRepository();
        var Entrys = await EntryRepository.GetAllEntries();
        return new ListResponse<EntryReport>()
        {
            Code = 200,
            Message = "Entrys listed successfully",
            Payload = Entrys
        };
    }

    public async Task<PayloadResponse<Entry>> GetEntryById(int id)
    {
        var EntryRepository = new EntryRepository();
        var entry = await EntryRepository.GetById(id);
        return new PayloadResponse<Entry>()
        {
            Code = 200,
            Success = true,
            Payload = entry
        };
    }

    public async Task<CreationResponse> CreateEntry(CreateEntryRequest createEntryRequest)
    {
        try
        {
            var Entry = new Entry()
            {
                ProductId = createEntryRequest.ProductId,
                Date = createEntryRequest.Date,
                Quantity = createEntryRequest.Quantity,
                SupplierId = createEntryRequest.SupplierId,
            };

            var EntryRepository = new EntryRepository();

            await EntryRepository.Insert(Entry);

            var response = new CreationResponse() { Payload = "Entry created successfully" };

            return response;
        }
        catch
        {
            return new CreationResponse()
            {
                Code = 500,
                Success = false,
                Payload = "Something went wrong while creating the Entry"
            };
        }

    }

    public async Task UpdateEntry(Entry Entry)
    {
        var EntryRepository = new EntryRepository();

        await EntryRepository.Update(Entry);
    }

    public async Task<bool> DeleteEntry(int id)
    {
        var EntryRepository = new EntryRepository();

        try
        {
            var existentEntry = await EntryRepository.GetById(id);

            if (existentEntry == null)
            {
                return false;
            }

            await EntryRepository.Delete(id);

            return true;
        }
        catch
        {
            return false;
        }
    }
}
