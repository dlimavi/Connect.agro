namespace Connect.Agro.Dll.src.Models.Dtos.Reports;

public class EntryReport
{
    public int Id { get; set; }
    public required string ProductDescription { get; set; }
    public DateTime Date { get; set; }
    public int Quantity { get; set; }
    public required string SupplierBusinessName { get; set; }
}
