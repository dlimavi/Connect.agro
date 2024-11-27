using Connect.Agro.Models.Consts;
using Connect.Agro.Models.Domain;
using Dapper;
using Microsoft.Data.SqlClient;

namespace Connect.Agro.Repositories;

public class SupplierRepository
{
    public async Task<List<Supplier>> GetAllSuppliersAsync()
    {
         await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT 
                * 
            FROM Suppliers sup
            INNER JOIN Companies comp ON (sup.CompanyId = comp.Id)";
        var result =
            await connection.QueryAsync<Supplier>
            (
                query
            );

        var suppliers = result.ToList();

        return suppliers;
    } 

    public async Task<Supplier?> GetByIdAsync(int supplierId)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT 
                * 
            FROM Suppliers sup
            INNER JOIN Companies comp ON (sup.CompanyId = comp.Id)
            WHERE Sup.CompanyId = @Id";

        var result =
            await connection.QueryAsync<Supplier>
            (
                query,
                new { Id = supplierId }
            );

        var supplier = result.FirstOrDefault();

        return supplier;
    }

    public async Task<int> InsertAsync(Supplier supplier)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            DECLARE @InsertedId INT;
            INSERT INTO Companies ( BusinessName, Email, Document ) 
            VALUES ( @BusinessName, @Email, @Document )

            SET @InsertedId = SCOPE_IDENTITY();

            INSERT INTO Suppliers (CompanyId)
            VALUES (@InsertedId)";
        var insertedSupplierId = await connection.ExecuteScalarAsync<int>
        (
            query,
            new
            {
                supplier.BusinessName,
                supplier.Email,
                supplier.Document
            }
        );

        return insertedSupplierId;
    }

    public async Task UpdateAsync(Supplier supplier)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            UPDATE Companies
            SET 
                BusinessName = @BusinessName,
                Email = @Email,
                Document = @Document

            WHERE Id = @Id";

        await connection.ExecuteAsync
        (
            query,
            new
            {
                supplier.BusinessName,
                supplier.Email,
                supplier.Document,
                supplier.Id
            }
        );
    }

    public async Task DeleteAsync(int supplierId)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            DELETE FROM Suppliers  
            WHERE CompanyId = @Id;

            DELETE FROM Companies  
            WHERE Id = @Id";
        await connection.ExecuteAsync
        (
            query, new { Id = supplierId }
        );
    }
}
