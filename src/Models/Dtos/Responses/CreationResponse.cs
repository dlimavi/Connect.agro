namespace Connect.Agro.Models.Dtos.Responses;

public class CreationResponse : PayloadResponse<string>
{
    public CreationResponse()
    {
        Code = 201;
        Success = true;
    }
}
