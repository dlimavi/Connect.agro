namespace Connect.Agro.Models.Dtos.Responses;

public abstract class BaseResponse
{
    public int Code { get; set; }
    public bool Success { get; set; } = true;
}
