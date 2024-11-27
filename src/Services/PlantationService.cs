using Connect.Agro.Dll.src.Models.Dtos.Reports;
using Connect.Agro.Models.Domain;
using Connect.Agro.Models.Dtos.Requests;
using Connect.Agro.Models.Dtos.Responses;
using Connect.Agro.Repositories;

namespace Connect.Agro.Services;

public class PlantationService
{
    public async Task<ListResponse<PlantationReport>> GetPlantationList()
    {
        var PlantationRepository = new PlantationRepository();
        var Plantations = await PlantationRepository.GetAllPlantations();
        return new ListResponse<PlantationReport>(){
            Code = 200,
            Message = "Plantations listed successfully",
            Payload = Plantations
        };
    }

    private async Task<(bool, CreationResponse?)> ValidateSector(int sectorId)
    {
        var SectorRepository = new SectorRepository();
        var sector = await SectorRepository.GetById(sectorId);

        if (sector == null)
        {
            return (
                false,
                new CreationResponse(){
                    Code = 400,
                    Success = false,
                    Payload = "O Setor não existe"
                }
            );
        }

        var sectorPlantations = await SectorRepository.GetPlantationsBySectorId(sectorId); 

        if (sectorPlantations.Count >= sector.Capacity)
        {
            return (
                false,
                new CreationResponse(){
                    Code = 400,
                    Success = false,
                    Payload = "O Setor está esgotado"
                }
            );
        }

        return ( true, null );
    }

    public async Task<CreationResponse> CreatePlantation(CreatePlantationRequest createPlantationRequest)
    {
        var plantation = new Plantation(){
            ProductId = createPlantationRequest.ProductId,            
            Date = createPlantationRequest.Date,
            Quantity = createPlantationRequest.Quantity,
            SectorId = createPlantationRequest.SectorId,
            ExpectedHarvestDate = createPlantationRequest.EstimatedHarvestDate
        };       

        var (isSectorValid, sectorValidationResponse) = await ValidateSector(plantation.SectorId);

        if  (!isSectorValid && sectorValidationResponse != null)
        {
            return  sectorValidationResponse;
        }

        var PlantationRepository = new PlantationRepository();
        
        await PlantationRepository.Insert(plantation);

        var response = new CreationResponse(){ Payload = "Plantation created successfully"};

        return response;
    }

    public async Task<PayloadResponse<Plantation>> GetPlantationById(int id)
    {
        var PlantationRepository = new PlantationRepository();
        var plantation = await PlantationRepository.GetById(id);
        return new PayloadResponse<Plantation>()
        {
            Code = 200,
            Success = true,
            Payload = plantation
        };
    }

    public async Task UpdatePlantation(Plantation plantation)
    {
        var PlantationRepository = new PlantationRepository();

        var (isSectorValid, sectorValidationResponse) = await ValidateSector(plantation.SectorId);

        if  (!isSectorValid && sectorValidationResponse != null)
        {
            throw new ArgumentException(sectorValidationResponse.Payload);
        }
        
        await PlantationRepository.Update(plantation);
    }

    public async Task<bool> DeletePlantation (int id)
    {
        var PlantationRepository = new PlantationRepository();

        var existentPlantation = await PlantationRepository.GetById(id);

        if(existentPlantation == null) 
        {
            return false;
        }

        await PlantationRepository.Delete(id);

        return true;
    }
}
