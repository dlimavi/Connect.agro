namespace Connect.Agro.Models.Dtos.Responses;

public class PayloadResponse<TPayload> : BaseResponse
{
    public TPayload? Payload { get; set; }
}
