namespace Connect.Agro.Models.Dtos.Responses;

public class ListResponse<T>
{
    public int Code { get; set; }
    public string Message { get; set; } = string.Empty;
    public List<T> Payload { get; set; } = [];
}
