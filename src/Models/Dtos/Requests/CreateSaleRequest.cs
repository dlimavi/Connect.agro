namespace Connect.Agro.Models.Dtos.Requests;

public class CreateSaleRequest
{
    public int ProductId { get; set; }
    public int Quantity { get; set; }
    public DateTime Date { get; set; }
    public int CustomerId { get; set; }
}
