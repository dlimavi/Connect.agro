using Connect.Agro.Models.Consts;
using Connect.Agro.Models.Domain;
using Dapper;
using Microsoft.Data.SqlClient;

namespace Connect.Agro.Repositories;

public class SectorRepository
{
    public async Task<List<Sector>> GetAllSectors()
    {
         await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = "SELECT * FROM Sectors";

        var result =
            await connection.QueryAsync<Sector>
            (
                query
            );

        var Sectors = result.ToList();

        return Sectors;
    } 

    public async Task<Sector?> GetById(int SectorId)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = "SELECT * FROM Sectors WHERE Id = @Id";

        var result =
            await connection.QueryAsync<Sector>
            (
                query,
                new { Id = SectorId }
            );

        var Sector = result.FirstOrDefault();

        return Sector;
    }

    public async Task<List<Plantation>> GetPlantationsBySectorId(int SectorId)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT 
                * 
            FROM Plantations s
            INNER JOIN InventoryMovements invmov ON (s.InventoryMovementId = invmov.ProductId)
            WHERE s.SectorId = @Id
            AND s.ExpectedHarvestDate <= GETDATE()";

        var result =
            await connection.QueryAsync<Plantation>
            (
                query,
                new { Id = SectorId }
            );

        var Plantations = result.ToList();

        return Plantations;
    }

    public async Task Insert(Sector Sector)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = "INSERT INTO Sectors (Description, Capacity) VALUES (@Description, @Capacity);";
        var insertedSectorId = await connection.ExecuteScalarAsync<int>
        (
            query,
            new
            {
                Sector.Description,
                Sector.Capacity
            }
        );
    }

    public async Task Update(Sector Sector)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            UPDATE Sectors
            SET 
                Description = @Description,
                Capacity = @Capacity
            WHERE Id = @Id";

        await connection.ExecuteAsync
        (
            query,
            new
            {
                Sector.Description,
                Sector.Capacity,
                Sector.Id
            }
        );
    }

    public async Task Delete(int SectorId)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            DELETE FROM Sectors  
            WHERE Id = @Id;";

        await connection.ExecuteAsync
        (
            query, new { Id = SectorId }
        );
    }
}
