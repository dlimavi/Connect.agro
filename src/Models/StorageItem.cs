namespace Connect.Agro.Models;

public class StorageSupply
{
    public int Id { get; set; }
    public string Description { get; set; } = string.Empty;
    public double Price { get; set; }
    public int Quantity { get; set; }
}
