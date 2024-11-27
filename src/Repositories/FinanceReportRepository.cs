using Connect.Agro.Models.Consts;
using Connect.Agro.Models;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using Connect.Agro.Dll.src.Models.Domain;

namespace Connect.Agro.Dll.src.Repositories
{
    public class FinanceReportRepository
    {

        public async Task<List<FinanceReport>> GetSaleReport()
        {
            await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
            await connection.OpenAsync();

            var query = @"
                SELECT 
					sub.Year,
					sub.Month,
					sub.Description AS ProductDescription,
					SUM(sub.Quantity) AS Quantity,
					sub.BusinessName
				FROM
					(SELECT 
						YEAR(DATE) AS Year,
						MONTH(DATE) AS Month,
						pdt.Description,
						invmov.Quantity,
						comp.BusinessName
					FROM Sales sal
					INNER JOIN InventoryMovements invmov ON (sal.InventoryMovementId = invmov.Id)
					INNER JOIN Products pdt ON (invmov.ProductId = pdt.Id)
					INNER JOIN Companies comp ON (sal.CustomerId = comp.Id)
					)sub
				GROUP BY
					sub.Year,
					sub.Month,
					sub.Description,
					sub.BusinessName
				ORDER BY 
					sub.Year,
					sub.Month
            ";
            var result =
                await connection.QueryAsync<FinanceReport>
                (
                    query
                );

            var saleReports = result.ToList();

            return saleReports;
        }

        public async Task<List<FinanceReport>> GetEntryReport()
        {
            await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
            await connection.OpenAsync();

            var query = @"
                SELECT 
					sub.Year,
					sub.Month,
					sub.Description AS ProductDescription,
					SUM(sub.Quantity) AS Quantity,
					sub.BusinessName
				FROM
					(SELECT 
						YEAR(DATE) AS Year,
						MONTH(DATE) AS Month,
						pdt.Description,
						invmov.Quantity,
						comp.BusinessName
					FROM Entries ent
					INNER JOIN InventoryMovements invmov ON (ent.InventoryMovementId = invmov.Id)
					INNER JOIN Products pdt ON (invmov.ProductId = pdt.Id)
					INNER JOIN Companies comp ON (ent.SupplierId = comp.Id)
					)sub
				GROUP BY
					sub.Year,
					sub.Month,
					sub.Description,
					sub.BusinessName
				ORDER BY 
					sub.Year,
					sub.Month
            ";
            var result =
                await connection.QueryAsync<FinanceReport>
                (
                    query
                );

            var entryReports = result.ToList();

            return entryReports;
        }
    }
}
