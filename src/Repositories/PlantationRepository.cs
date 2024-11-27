using Connect.Agro.Dll.src.Models.Dtos.Reports;
using Connect.Agro.Models.Consts;
using Connect.Agro.Models.Domain;
using Dapper;
using Microsoft.Data.SqlClient;

namespace Connect.Agro.Repositories;

public class PlantationRepository
{
    public async Task<List<PlantationReport>> GetAllPlantations()
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT 
                invmov.Id,
                pdt.Description AS ProductDescription,
                invmov.Date,
                invmov.Quantity,
                pla.ExpectedHarvestDate,
                sec.Description AS SectorDescription
            FROM Plantations pla
            INNER JOIN InventoryMovements invmov ON (pla.InventoryMovementId = invmov.Id)
            INNER JOIN Products pdt ON (invmov.ProductId = pdt.Id)
            INNER JOIN Sectors sec ON (pla.SectorId = sec.Id)";
        var result =
            await connection.QueryAsync<PlantationReport>
            (
                query
            );

        var Plantations = result.ToList();

        return Plantations;
    }

    public async Task<Plantation?> GetById(int id)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            SELECT
            * 
            FROM Plantations pla
            INNER JOIN InventoryMovements invmov ON (pla.InventoryMovementId = invmov.Id)
            WHERE pla.InventoryMovementId = @Id";

        var result = await connection.QueryAsync<Plantation> (query, new { Id = id });

        var Plantation = result.FirstOrDefault();

        return Plantation;
    }

    public async Task Update(Plantation plantation)
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

            UPDATE Plantations
            SET
                ExpectedHarvestDate = @ExpectedHarvestDate,
                SectorId = @SectorId
            WHERE InventoryMovementId = @Id";

        var insertedPlantationId = await connection.ExecuteScalarAsync<int>
        (
            query,
            new
            {
                plantation.Id,
                plantation.ProductId,
                plantation.Date,
                plantation.Quantity,
                plantation.ExpectedHarvestDate,
                plantation.SectorId
            }
        );
    }


    public async Task Insert(Plantation Plantation)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            
            DECLARE @InsertedId INT;

            INSERT INTO InventoryMovements ( ProductId, Date, Quantity)
            VALUES ( @ProductId, @Date, @Quantity);

            SET @InsertedId = SCOPE_IDENTITY();

            INSERT INTO Plantations (InventoryMovementId, SectorId, ExpectedHarvestDate) 
            VALUES (@InsertedId, @SectorId, @ExpectedHarvestDate)";

        var insertedPlantationId = await connection.ExecuteScalarAsync<int>
        (
            query,
            new
            {
                Plantation.ProductId,
                Plantation.Date,
                Plantation.Quantity,
                Plantation.SectorId,
                Plantation.ExpectedHarvestDate
            }
        );
    }

    public async Task Delete(int id)
    {
        await using var connection = new SqlConnection(SettingsConsts.ConnectionString);
        await connection.OpenAsync();

        var query = @"
            DELETE FROM Plantations  
            WHERE InventoryMovementId = @Id;
            
            DELETE FROM InventoryMovements  
            WHERE Id = @Id";

        await connection.ExecuteAsync ( query, new { id } );
    }
}
