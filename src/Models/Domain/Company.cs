namespace Connect.Agro.Models.Domain;

public abstract class Company
{
    public int Id { get; set; }
    public string BusinessName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Document { get; set; } = string.Empty;
    
}
