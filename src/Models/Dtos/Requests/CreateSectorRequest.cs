namespace Connect.Agro.Models.Dtos.Requests;

public class CreateSectorRequest
{
    public string Description { get; set; } = string.Empty;
    public int Capacity { get; set; }
}
