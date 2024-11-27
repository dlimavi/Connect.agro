using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Connect.Agro.Dll.src.Models.Domain
{
    public class FinanceReport
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public string ProductDescription { get; set; } = string.Empty;
        public int Quantity { get; set; }
        public required string BusinessName { get; set; } = string.Empty;
    }
}
