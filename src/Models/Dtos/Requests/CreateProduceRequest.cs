namespace Connect.Agro.Models.Dtos.Requests;

public class CreateProduceRequest
{
    public string Description { get; set; } = string.Empty;
    public double Price { get; set; }
    public int DaysToGrow { get; set; }
}
