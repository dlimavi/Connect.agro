namespace Connect.Agro.Models.Dtos.Requests;

public class CreateCustomerRequest
{
    public string BusinessName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Document { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
}
