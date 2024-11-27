using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Connect.Agro.Dll.src.Models.Dtos.Reports;

public class PlantationReport
{
    public int Id { get; set; }
    public required string ProductDescription { get; set; }
    public DateTime Date { get; set; }
    public int Quantity { get; set; }
    public DateTime ExpectedHarvestDate { get; set; }
    public required string SectorDescription { get; set; }
}
