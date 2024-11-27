using Connect.Agro.Models.Consts;
using Connect.Agro.Models.Domain;
using Dapper;
using Microsoft.Data.SqlClient;

namespace Connect.Agro.Repositories;

public class SupplyRepository
{
    public async Task<List<Supply>> GetAllSupplies()
    {
         await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT 
                * 
            FROM Supplies sup
            INNER JOIN Products prod ON (sup.ProductId = prod.Id)";
        var result =
            await connection.QueryAsync<Supply>
            (
                query
            );

        var Supplys = result.ToList();

        return Supplys;
    } 

    public async Task<Supply?> GetById(int SupplyId)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT 
                * 
            FROM Supplies sup
            INNER JOIN Products prod ON (sup.ProductId = prod.Id)
            WHERE sup.ProductId = @Id";
        var result =
            await connection.QueryAsync<Supply>
            (
                query,
                new { Id = SupplyId }
            );

        var Supply = result.FirstOrDefault();

        return Supply;
    }

    public async Task<int> Insert(Supply Supply)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"

        DECLARE @InsertedId INT;

        INSERT INTO Products ( Description, Price) 
        VALUES ( @Description, @Price);

        SET @InsertedId = SCOPE_IDENTITY();

        INSERT INTO Supplies ( ProductId ) 
        VALUES ( @InsertedId)";
        var insertedSupplyId = await connection.ExecuteScalarAsync<int>
        (
            query,
            new
            {
                Supply.Description,
                Supply.Price
            }
        );

        return insertedSupplyId;
    }

    public async Task Update(Supply Supply)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            UPDATE Products
            SET 
                Description = @Description,
                Price = @Price
            WHERE Id = @Id";

        await connection.ExecuteAsync
        (
            query,
            new
            {
                Supply.Description,
                Supply.Price,
                Supply.Id
            }
        );
    }

    public async Task Delete(int SupplyId)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            DELETE FROM Supplies  
            WHERE ProductId = @Id
            DELETE FROM Products  
            WHERE Id = @Id";
        await connection.ExecuteAsync
        (
            query, new { Id = SupplyId }
        );
    }
}
