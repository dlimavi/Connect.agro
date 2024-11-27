namespace Connect.Agro.Models.Dtos.Requests;

public class CreateEntryRequest
{
    public int ProductId { get; set; }
    public int Quantity { get; set; }
    public DateTime Date { get; set; }
    public int SupplierId { get; set; }
}
