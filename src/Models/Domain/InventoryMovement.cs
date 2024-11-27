namespace Connect.Agro.Models.Domain;

public abstract class InventoryMovement
{
    public int Id { get; set; }
    public int ProductId { get; set; }
    public DateTime Date { get; set; }
    public int Quantity { get; set; }
}
