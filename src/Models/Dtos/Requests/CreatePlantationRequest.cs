namespace Connect.Agro.Models.Dtos.Requests;

public class CreatePlantationRequest
{
    public int ProductId { get; set; }
    public DateTime Date { get; set; }
    public int Quantity { get; set; }
    public DateTime EstimatedHarvestDate { get; set; } 
    public int SectorId { get; set; }
}
