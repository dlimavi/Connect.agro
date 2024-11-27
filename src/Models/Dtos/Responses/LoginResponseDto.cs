using Connect.Agro.Models.Domain;

namespace Connect.Agro.Models.Dtos.Responses;

public class LoginResponseDto : PayloadResponse<string>
{
    public string AuthorizationToken { get; set; } = string.Empty;
    public User LoggedUser { get; set; } = new();
}
