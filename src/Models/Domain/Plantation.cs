namespace Connect.Agro.Models.Domain;

public class Plantation : InventoryMovement
{
    public DateTime ExpectedHarvestDate { get; set; }
    public int SectorId { get; set; }
}
