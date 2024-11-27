namespace Connect.Agro.Models.Dtos.Requests;

public class CreateSupplierRequest
{
    public string BusinessName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Document { get; set; } = string.Empty;
}
