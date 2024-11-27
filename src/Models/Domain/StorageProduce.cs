namespace Connect.Agro.Models.Domain;

public class StorageProduce
{
    public int Id { get; set; }
    public string Description { get; set; } = string.Empty;
    public double Price { get; set; }
    public int Quantity { get; set; }
    public int DaysToGrow { get; set; }
}
