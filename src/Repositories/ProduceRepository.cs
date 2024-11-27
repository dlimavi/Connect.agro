using Connect.Agro.Models.Consts;
using Connect.Agro.Models.Domain;
using Dapper;
using Microsoft.Data.SqlClient;

namespace Connect.Agro.Repositories;

public class ProduceRepository
{
    public async Task<List<Produce>> GetAllProducesAsync()
    {
         await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT 
                * 
            FROM Produces sup
            INNER JOIN Products prod ON (sup.ProductId = prod.Id)";
        var result =
            await connection.QueryAsync<Produce>
            (
                query
            );

        var Produces = result.ToList();

        return Produces;
    } 

    public async Task<Produce?> GetById(int ProduceId)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT 
                * 
            FROM Produces sup
            INNER JOIN Products prod ON (sup.ProductId = prod.Id)
            WHERE sup.ProductId = @Id";
        var result =
            await connection.QueryAsync<Produce>
            (
                query,
                new { Id = ProduceId }
            );

        var Produce = result.FirstOrDefault();

        return Produce;
    }

    public async Task<int> Insert(Produce Produce)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query =  @"

        DECLARE @InsertedId INT;

        INSERT INTO Products ( Description, Price) 
        VALUES ( @Description, @Price);

        SET @InsertedId = SCOPE_IDENTITY();

        INSERT INTO Produces ( ProductId, DaysToGrow ) 
        VALUES ( @InsertedId, @DaysToGrow)";
        var insertedProduceId = await connection.ExecuteScalarAsync<int>
        (
            query,
            new
            {
                Produce.Description,
                Produce.Price,
                Produce.DaysToGrow
            }
        );

        return insertedProduceId;
    }

    public async Task Update(Produce Produce)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            UPDATE Products
            SET 
                Description = @Description,
                Price = @Price
            WHERE Id = @Id;

            UPDATE Produces
            SET 
                DaysToGrow = @DaysToGrow
            WHERE ProductId = @Id";
        await connection.ExecuteAsync
        (
            query,
            new
            {
                Produce.Description,
                Produce.Price,
                Produce.DaysToGrow,
                Produce.Id
            }
        );
    }

    public async Task Delete(int ProduceId)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            DELETE FROM Produces    
            WHERE ProductId = @Id
            DELETE FROM Products  
            WHERE Id = @Id";
        await connection.ExecuteAsync
        (
            query, new { Id = ProduceId }
        );
    }
}
