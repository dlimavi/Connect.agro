using Connect.Agro.Dll.src.Repositories;
using Connect.Agro.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace Connect.Agro.Web.Controllers
{
    public class ReportController : Controller
    {
        public async Task<IActionResult> ProduceStorageReport()
        {
            var repository = new StorageReportsRepository();
            var result = await repository.GetCurrentProducesStorage();
            return View(result);
        }
        public async Task<IActionResult> SupplyStorageReport()
        {
            var repository = new StorageReportsRepository();
            var result = await repository.GetCurrentSuppliesStorage();
            return View(result);
        }
        public async Task<IActionResult> IncomeReport()
        {
            var repository = new FinanceReportRepository();
            var result = await repository.GetSaleReport();
            return View(result);
        }
        public async Task<IActionResult> ExpenseReport()
        {
            var repository = new FinanceReportRepository();
            var result = await repository.GetEntryReport();
            return View(result);
        }

    }
}
