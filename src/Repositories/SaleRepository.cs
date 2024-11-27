using Connect.Agro.Dll.src.Models.Dtos.Reports;
using Connect.Agro.Models.Consts;
using Connect.Agro.Models.Domain;
using Dapper;
using Microsoft.Data.SqlClient;

namespace Connect.Agro.Repositories;

public class SaleRepository
{
    public async Task<List<SaleReport>> GetAllSales()
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT 
	            invmov.Id,
	            pdt.Description AS ProductDescription,
	            invmov.Date,
	            invmov.Quantity,
	            comp.BusinessName AS CustomerBusinessName
            FROM Sales s
            INNER JOIN InventoryMovements invmov ON (s.InventoryMovementId = invmov.Id)
            INNER JOIN Products pdt ON (invmov.ProductId = pdt.Id)
            INNER JOIN Companies comp ON (s.CustomerId = comp.Id)";
        var result =
            await connection.QueryAsync<SaleReport>
            (
                query
            );

        var Sales = result.ToList();

        return Sales;
    }

    public async Task<Sale?> GetById(int id)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT
            * 
            FROM Sales s
            INNER JOIN InventoryMovements invmov ON (s.InventoryMovementId = invmov.Id)
            WHERE s.InventoryMovementId = @Id";

        var result = await connection.QueryAsync<Sale> (query, new { Id = id });

        var Sale = result.FirstOrDefault();

        return Sale;
    }

    public async Task Update(Sale Sale)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            
            UPDATE InventoryMovements
            SET 
                ProductId = @ProductId,
                Date = @Date, 
                Quantity = @Quantity
            WHERE Id = @Id;

            UPDATE Sales
            SET
                CustomerId = @CustomerId
            WHERE InventoryMovementId = @Id";

        var insertedSaleId = await connection.ExecuteScalarAsync<int>
        (
            query,
            new
            {
                Sale.Id,
                Sale.ProductId,
                Sale.Date,
                Sale.Quantity,
                Sale.CustomerId
            }
        );
    }


    public async Task Insert(Sale Sale)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            
            DECLARE @InsertedId INT;

            INSERT INTO InventoryMovements ( ProductId, Date, Quantity)
            VALUES ( @ProductId, @Date, @Quantity);

            SET @InsertedId = SCOPE_IDENTITY();

            INSERT INTO Sales (InventoryMovementId, CustomerId) 
            VALUES ( @InsertedId, @CustomerId)";
            
        await connection.ExecuteAsync
        (
            query,
            new
            {
                Sale.ProductId,
                Sale.Date,
                Sale.Quantity,
                Sale.CustomerId
            }
        );
    }

    public async Task Delete(int id)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            DELETE FROM Sales  
            WHERE InventoryMovementId = @Id;
            
            DELETE FROM InventoryMovements  
            WHERE Id = @Id";

        await connection.ExecuteAsync ( query, new { id } );
    }
}
