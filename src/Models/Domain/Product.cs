namespace Connect.Agro.Models.Domain;

public abstract class Product
{
    public int Id { get; set; }
    public string Description { get; set; } = string.Empty;
    public double Price { get; set; }
}
