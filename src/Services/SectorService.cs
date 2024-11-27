using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Repositories;

namespace Connect.Agro.Services;

public class SectorService
{
    public async Task<ListResponse<Sector>> GetSectorList()
    {
        var SectorRepository = new SectorRepository();
        var Sectors = await SectorRepository.GetAllSectors();
        return new ListResponse<Sector>(){
            Code = 200,
            Message = "Sectors listed successfully",
            Payload = Sectors
        };
    }

    public async Task<PayloadResponse<Sector?>> GetSectorById(int SectorId)
    {
        var SectorRepository = new SectorRepository();
        var Sector = await SectorRepository.GetById(SectorId);

        if (Sector == null)
        {
            return new PayloadResponse<Sector?>(){
                Code = 404,
                Success = false,
                Payload = null
            };
        }

        return new PayloadResponse<Sector?>(){
            Code = 200,
            Success = true,
            Payload = Sector
        };
    }

    public async Task CreateSector(CreateSectorRequest createSectorRequest)
    {
        var Sector = new Sector(){
            Description = createSectorRequest.Description,
            Capacity = createSectorRequest.Capacity
        };

        var SectorRepository = new SectorRepository();
        await SectorRepository.Insert(Sector);
    }

    public async Task<Sector?> UpdateSector (Sector Sector)
    {
        var SectorRepository = new SectorRepository();
        
        var existentSector = await SectorRepository.GetById(Sector.Id);

        if(existentSector == null) 
        {
            return null;
        }
        
        await SectorRepository.Update(Sector);

        return Sector;

    }

    public async Task<bool> DeleteSector (int SectorId)
    {
        var SectorRepository = new SectorRepository();
        try
        {
            var existentSector = await SectorRepository.GetById(SectorId);

            if (existentSector == null)
            {
                return false;
            }

            await SectorRepository.Delete(SectorId);

            return true;

        }
        catch
        {
            return false;
        }
    }
}
